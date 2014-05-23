//+======================================================================
//
// Project:   Tango
//
// Description:	java source code to defined  an extended PogoDeviceClass class
//
// $Author: verdier $
//
// Copyright (C) :      2004,2005,2006,2007,2008,2009,2009,2010,2011,2012,2013,2014
//						European Synchrotron Radiation Facility
//                      BP 220, Grenoble 38043
//                      FRANCE
//
// This file is part of Tango.
//
// Tango is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Tango is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Tango.  If not, see <http://www.gnu.org/licenses/>.
//
// $Revision: $
// $Date:  $
//
// $HeadURL: $
//
//-======================================================================

package org.tango.pogo.pogo_gui;


import fr.esrf.tango.pogo.pogoDsl.*;
import org.eclipse.emf.common.util.EList;
import org.tango.pogo.pogo_gui.tools.*;

import javax.swing.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;


/**
 * This class is able to defined  an extended PogoDeviceClass class
 *
 * @author verdier
 */


public class DeviceClass {
    private OldPogoModel old_pogo_class = null;
    private PogoDeviceClass pogo_class = null;
    private ArrayList<DeviceClass> ancestors = new ArrayList<DeviceClass>();
    private static final String defaultInheritanceStart = "Device_";
    private static final String defaultInheritanceEnd = "Impl";
    private static final String defaultInheritance =
            defaultInheritanceStart + defaultInheritanceEnd;
    //  Used only by MultiClasses
    private ArrayList<String> parentClasses = new ArrayList<String>();
    //===============================================================

    /**
     * Create an empty object
     */
    //===============================================================
    public DeviceClass() {
        pogo_class = OAWutils.factory.createPogoDeviceClass();
        pogo_class.setDescription(OAWutils.factory.createClassDescription());
        //  Add default inheitance
        pogo_class.getDescription().getInheritances().add(getDefaultInheritance());
    }
    //===============================================================

    /**
     * Create an new object
     *
     * @param name     new class name
     * @param devclass inheritance device classes
     */
    //===============================================================
    public DeviceClass(String name, DeviceClass devclass) {
        pogo_class = OAWutils.factory.createPogoDeviceClass();
        pogo_class.setDescription(OAWutils.factory.createClassDescription());
        pogo_class.setName(name);
        EList<Inheritance> inheritances = pogo_class.getDescription().getInheritances();
        if (inheritances.size() == 0)
            inheritances.add(getDefaultInheritance());

        if (devclass != null) {
            Inheritance inheritance = OAWutils.factory.createInheritance();
            inheritance.setClassname(devclass.pogo_class.getName());
            inheritance.setSourcePath(devclass.pogo_class.getDescription().getSourcePath());
            inheritances.add(0, inheritance);
        }
    }
    //===============================================================

    /**
     * Create the object from the specified file.
     *
     * @param filename specified file to create object.
     * @throws PogoException if failed to read or parse specified file
     */
    //===============================================================
    public DeviceClass(String filename) throws PogoException {
        this(filename, true);
    }
    //===============================================================

    /**
     * Create the object from the specified file.
     *
     * @param filename        specified file to create object.
     * @param loadInheritance Will load inheitance class(es) if true.
     * @throws PogoException if failed to read or parse specified file
     */
    //===============================================================
    public DeviceClass(String filename, boolean loadInheritance) throws PogoException {
        if (filename.endsWith(".xmi")) {
            //	Load the model
            pogo_class = OAWutils.getInstance().loadDeviceClassModel(filename);

            EList<Inheritance> inheritances = pogo_class.getDescription().getInheritances();
            if (inheritances.size() == 0)
                inheritances.add(getDefaultInheritance());

            //	And set the path (could have changed)
            String path = Utils.getPath(filename);
            pogo_class.getDescription().setSourcePath(path);

            //	Load inheritance classes if any
            Utils.getInstance().stopSplashRefresher();
            if (loadInheritance)
                if (!loadInheritanceClasses())
                    throw new PogoException("CANCEL");
        } else {
            String str = ParserTool.readFile(filename);
            if (!str.contains("This file is generated by POGO"))
               throw new PogoException("The file has not been generated by Pogo or too much modified by hand\n    ("
                       + filename + ")\n");
            old_pogo_class = new OldPogoModel(filename);
            pogo_class = old_pogo_class.getPogoDeviceClass();
        }
        //  Check if asbstract class or not
        checkIfAbstractClass(pogo_class, true);
    }

    //===============================================================
    //===============================================================
    public static boolean isDefaultInheritance(Inheritance inher) {
        if (inher.getClassname() == null)
            return true;
        //  Could have Idl number between 
        return (inher.getClassname().startsWith(defaultInheritanceStart) &&
                inher.getClassname().endsWith(defaultInheritanceEnd));

    }

    //===============================================================
    //===============================================================
    public static Inheritance getDefaultInheritance() {
        Inheritance inher = OAWutils.factory.createInheritance();
        //System.out.println("inher.setClassname("+defaultInheritance+")");
        inher.setClassname(defaultInheritance);
        inher.setSourcePath("");
        return inher;
    }
    //===============================================================
    /**
     * @return the abstract attribute names if any.
     */
    //===============================================================
    public ArrayList<String> getAbstractAttributeNames() {
        ArrayList<String> attnames = new ArrayList<String>();
        EList<Attribute> attributes = pogo_class.getAttributes();
        for (Attribute att : attributes)
            if (!Utils.isTrue(att.getStatus().getConcrete()) &&
                    !Utils.isTrue(att.getStatus().getConcreteHere())) {
                attnames.add(att.getName());
            }
        return attnames;
    }
    //===============================================================
    /**
     * @return the abstract command names if any.
     */
    //===============================================================
    public ArrayList<String> getAbstractCommandNames() {
        ArrayList<String> cmdnames = new ArrayList<String>();
        EList<Command> commands = pogo_class.getCommands();
        for (Command cmd : commands)
            if (!Utils.isTrue(cmd.getStatus().getConcrete()) &&
                    !Utils.isTrue(cmd.getStatus().getConcreteHere())) {
                cmdnames.add(cmd.getName());
            }
        return cmdnames;
    }
    //===============================================================

    /**
     * Check if there is at least an abstract command or attribute.
     * It fill the field (hasAbstractCommand & hasAbstractAttribute) if requested.
     *
     * @return true if is an abstract class (no abstract command or attribute)
     */
    //===============================================================
    public boolean checkIfAbstractClass() {
        return checkIfAbstractClass(pogo_class, false);
    }
    //===============================================================

    /**
     * Check if there is at least an abstract command or attribute.
     * It fill the field (hasAbstractCommand & hasAbstractAttribute) if requested.
     *
     * @param pc     the specified Pogo class
     * @param update update fields if true.
     * @return true if is an abstract class (no abstract command or attribute)
     */
    //===============================================================
    public static boolean checkIfAbstractClass(PogoDeviceClass pc, boolean update) {
        EList<Command> commands = pc.getCommands();
        EList<Attribute> attributes = pc.getAttributes();

        if (update) {
            pc.getDescription().setHasAbstractCommand("false");
            pc.getDescription().setHasAbstractAttribute("false");
            for (Command cmd : commands) {
                if (cmd.getStatus() != null) {
                    if (!Utils.isTrue(cmd.getStatus().getConcrete()) &&
                            !Utils.isTrue(cmd.getStatus().getConcreteHere())) {
                        pc.getDescription().setHasAbstractCommand("true");
                    }
                }
            }
            for (Attribute att : attributes) {
                if (att.getStatus() != null) {
                    if (!Utils.isTrue(att.getStatus().getConcrete()) &&
                            !Utils.isTrue(att.getStatus().getConcreteHere())) {
                        pc.getDescription().setHasAbstractAttribute("true");
                    }
                }
            }
        }
        return (Utils.isTrue(pc.getDescription().getHasAbstractCommand()) ||
                Utils.isTrue(pc.getDescription().getHasAbstractAttribute()));
    }

    //===============================================================
    //===============================================================
    public boolean isOldPogoModel() {
        return (old_pogo_class != null);
    }

    //===============================================================
    //===============================================================
    public boolean isOldPogoModelAbstract() throws PogoException {
        if (old_pogo_class == null)
            throw new PogoException("This class is not an old POGO model.");
        return old_pogo_class.isAbsAbstract();
    }

    //===============================================================
    //===============================================================
    private String checkInheritanceFile(String filename, String className) throws PogoException {
        System.out.println("checkInheritanceFile for  " + filename);
        if (!new File(filename).exists()) {
            //	Check if can be found from env.
            String from_env = InheritanceUtils.checkInheritanceFileFromEnv(filename);
            if (from_env != null)
                return from_env;
            if (!PogoGUI.useDisplay)
                throw new PogoException(filename + ": inheritance file not found");

            //	Else, Display error (NOT FOUND !)
            JOptionPane.showMessageDialog(new JFrame(),
                    filename + "\nInheritance class Not Found !",
                    "Error Window", JOptionPane.ERROR_MESSAGE);

            //	Propose to get from elsewhere
            String path = pogo_class.getDescription().getSourcePath();
            JFileChooser chooser =
                    new JFileChooser(new File(path).getAbsolutePath());

            PogoFileFilter filter = new PogoFileFilter("xmi", className + " class");
            //filter.setExtensionListInDescription(false);
            chooser.setFileFilter(filter);
            if (chooser.showOpenDialog(new JFrame()) == JFileChooser.APPROVE_OPTION) {
                File file = chooser.getSelectedFile();
                if (file != null) {
                    if (!file.isDirectory())
                        filename = file.getAbsolutePath();
                    else
                        return null;
                } else
                    return null;
            } else
                return null;    //	Cancelled
        }
        //	OK It exists
        return filename;
    }

    //===============================================================
    //===============================================================
    private boolean loadInheritanceClasses() throws PogoException {
        //	Load ancestor classes
        try {
            //	Try to load it
            EList<Inheritance> inheritances = pogo_class.getDescription().getInheritances();
            for (Inheritance inheritance : inheritances) {
                if (!isDefaultInheritance(inheritance)) {
                    String className = inheritance.getClassname();
                    String filename =
                            inheritance.getSourcePath() +
                                    java.lang.System.getProperty("file.separator") +
                                    className + ".xmi";
                    if ((filename = checkInheritanceFile(filename, className)) == null)
                        return false;

                    //	OK. Lo add it
                    Utils.getInstance().startSplashRefresher(
                            "Loading  " + Utils.getRelativeFilename(filename));
                    ancestors.add(new DeviceClass(filename, false));
                    inheritance.setSourcePath(Utils.getPath(filename));
                    Utils.getInstance().stopSplashRefresher();
                }
            }
        } catch (PogoException e) {
            if (PogoGUI.useDisplay) {
                Utils.getInstance().stopSplashRefresher();
                e.popup(new JFrame());
            } else
                throw e;
        } catch (Exception e) {
            if (PogoGUI.useDisplay) {
                Utils.getInstance().stopSplashRefresher();
                PogoException.popup(new JFrame(), e);
            }
            e.printStackTrace();
            return false;
        }
        return true;
    }

    //==============================================================
    //==============================================================
    public void removeInheritance() {
        EList<Inheritance> inheritances = pogo_class.getDescription().getInheritances();
        inheritances.clear();
        Inheritance inheritance = OAWutils.factory.createInheritance();
        inheritance.setClassname(DeviceClass.getDefaultInheritance().getClassname());
        inheritance.setSourcePath("");
        inheritances.add(inheritance);

        EList<Property> classprops = pogo_class.getClassProperties();
        EList<Property> devprops = pogo_class.getDeviceProperties();
        EList<Command> commands = pogo_class.getCommands();
        EList<Attribute> attributes = pogo_class.getAttributes();
        EList<State> states = pogo_class.getStates();

        for (Property property : classprops) {
            property.getStatus().setInherited("false");
        }
        for (Property property : devprops) {
            property.getStatus().setInherited("false");
        }
        for (Command command : commands) {
            if (!command.getName().equals("State") &&
                    !command.getName().equals("Statuse")) {
                command.getStatus().setInherited("false");
            }
        }
        for (Attribute attribute : attributes) {
            attribute.getStatus().setInherited("false");
        }
        for (State state : states) {
            state.getStatus().setInherited("false");
        }
    }

    //==============================================================
    //==============================================================
    public String getProjectFilename() {
        return pogo_class.getDescription().getSourcePath() +
                "/" + pogo_class.getName() + ".xmi";
    }

    //==============================================================
    //==============================================================
    public PogoDeviceClass getPogoDeviceClass() {
        return pogo_class;
    }

    //===============================================================
    //===============================================================
    public ArrayList<DeviceClass> getAncestors() {
        return ancestors;
    }
    //===============================================================
    //===============================================================
    public void setAncestors(ArrayList<DeviceClass> ancestors) {
        this.ancestors = ancestors;
    }

    //===============================================================
    //===============================================================
    public void addAncestor(DeviceClass ancestor) {

        for (DeviceClass anAncestor : ancestor.ancestors) {
            ancestors.add(anAncestor);
            Inheritance inheritance = OAWutils.factory.createInheritance();
            inheritance.setClassname(anAncestor.getPogoDeviceClass().getName());
            inheritance.setSourcePath(anAncestor.getPogoDeviceClass().getDescription().getSourcePath());
            pogo_class.getDescription().getInheritances().add(inheritance);
        }

        this.ancestors.add(ancestor);
        Inheritance inheritance = OAWutils.factory.createInheritance();
        inheritance.setClassname(ancestor.getPogoDeviceClass().getName());
        inheritance.setSourcePath(ancestor.getPogoDeviceClass().getDescription().getSourcePath());
        pogo_class.getDescription().getInheritances().add(inheritance);
    }

    //===============================================================
    //===============================================================
    public String getSourceFile(String lang) {
        String  separator = java.lang.System.getProperty("file.separator");
        String path = pogo_class.getDescription().getSourcePath() + separator;

        if (lang.equals("cpp"))
            return  path + pogo_class.getName() + ".cpp";
        else
        if (lang.equals("python"))
            return  path + pogo_class.getName() + ".py";
        else {
            path += "org" + separator + "tango" + separator +
                    pogo_class.getName().toLowerCase() + separator;
        //if (lang.equals("java"))
            return  path + pogo_class.getName() + ".java";
        }
    }

    //===============================================================
    //===============================================================
    public void generateWithNewName(String newClassName, boolean modified, DeletedObjects deleted, RenamedObjects renamed)
            throws SecurityException,  IOException, PogoException {
        String srcClassName = getPogoDeviceClass().getName();
        //  if modified, generated before 
        if (modified) {
            getPogoDeviceClass().getDescription().setFilestogenerate("XMI File, Code files");
            generate(deleted, renamed);
        }
        deleted.clear();
        renamed.clear();

        //  Change class name and generate
        getPogoDeviceClass().setName(newClassName);
        getPogoDeviceClass().getDescription().setFilestogenerate("XMI File, Code files");
        generate(new DeletedObjects(), new RenamedObjects());

        //  Manage Protected areas for each file
        if (getPogoDeviceClass().getDescription().getLanguage().toLowerCase().equals("cpp")) {
            String path = getPogoDeviceClass().getDescription().getSourcePath();
            String[] extensions = {
                    ".h", ".cpp",
                    "Class.h", "Class.cpp",
                    "StateMachine.cpp"
            };
            for (String extension : extensions) {
                String inFileName = path + "/" + srcClassName + extension;
                String outFileName = path + "/" + newClassName + extension;
                ProtectedAreaManager pam = new ProtectedAreaManager(inFileName);
                pam.setClassName(newClassName, outFileName);
            }

            //  And remove original files (for old class name)
            for (String extension : extensions)
                if (!new File(path + "/" + srcClassName + extension).delete())
                    System.err.println("failed to delete" + srcClassName + extension);
        }
    }

    //===============================================================
    //===============================================================
    public void generate(DeletedObjects deleted, RenamedObjects renamed)
            throws SecurityException, IOException, PogoException {
        String className = pogo_class.getName();
        String  lang = pogo_class.getDescription().getLanguage().toLowerCase();
       //	Get code for deleted and renamed objects
        if (renamed != null)
            renamed.readCode(className, getSourceFile(lang));
        if (deleted != null)
            deleted.readCode(getSourceFile(lang));

        //	Generate code from model
        OAWutils oaw = OAWutils.getInstance();
        oaw.generate(pogo_class);

        //	Insert code for deleted and rename objects
        if (deleted != null)
            if (deleted.size() > 0) {
                deleted.insertCode(getSourceFile(lang));
                System.out.println(getSourceFile(lang) + "  updated");
            }
        if (renamed != null)
            if (renamed.size() > 0) {
                renamed.insertCode(className, getSourceFile(lang));
                System.out.println(getSourceFile(lang) + "  updated");
            }
    }

    //===============================================================
    //===============================================================
    public void generateDocFromOldModel(String oldSrcFilename, String targetDir) throws PogoException {
        try {
            String descFilename = Utils.getPath(oldSrcFilename);
            descFilename += "/" + PogoProperty.docHome + "/Description.html";
            if (targetDir == null)
                targetDir = Utils.getPath(descFilename);
            old_pogo_class.generateDocFromOldModel(descFilename, targetDir);
        } catch (Exception e) {
            e.printStackTrace();
            if (e instanceof PogoException)
                throw (PogoException) e;
            else
                throw new PogoException(e.toString());
        }
    }

    //===============================================================
    //===============================================================
    public void generateFromOldModel(String filename, boolean recoverCode) throws PogoException {
        try {
            String path = Utils.getPath(filename);
            path += PogoConst.CONVERSION_DIR;
            if (!new File(path).exists())
                if (!new File(path).mkdir())
                    throw new PogoException("Cannot create path: " + path);

            //	Set the file list to be generated and generate
            pogo_class.getDescription().setFilestogenerate("XMI file,Code files,Linux Makefile");
            pogo_class.getDescription().setSourcePath(path);
            java.lang.System.out.println("\n===============================================================\n\n");
            OAWutils.getInstance().generate(pogo_class);

            //	For old model, try to copy methods code to new model.
            if (recoverCode) {
                recoverCodeFromOldPogoModel();
            }

            //	If not test, swap directories
            old_pogo_class.swapDirectories(pogo_class);
        } catch (Exception e) {
            e.printStackTrace();
            if (e instanceof PogoException)
                throw (PogoException) e;
            else
                throw new PogoException(e.toString());
        }
    }
    //===============================================================

    /**
     * recover code from old Pogo model to
     * insert in new model.
     *
     * @throws Exception in case of exception occured
     */
    //===============================================================
    private void recoverCodeFromOldPogoModel() throws Exception {
        if (old_pogo_class == null)
            throw new PogoException("This is not an old POGO model");


        if (Utils.getLanguage(pogo_class.getDescription().getLanguage()) == PogoConst.Cpp) {
            old_pogo_class.recoverCppCodeFromOldPogoModel(pogo_class);
            old_pogo_class.manageCppAdditionalFiles(pogo_class);
        }
    }
    //===============================================================
    //===============================================================


    //===============================================================
    //===============================================================
    public void resetParentClasses() {
        parentClasses.clear();
    }

    //===============================================================
    //===============================================================
    public ArrayList<String> getParentClasses() {
        return parentClasses;
    }

    //===============================================================
    //===============================================================
    public void addParentClass(String name) {
        parentClasses.add(name);
    }

    //===============================================================
    //===============================================================
    public String toString() {
        if (pogo_class.getName() == null ||
                pogo_class.getName().length() == 0)
            return "This class";
        return pogo_class.getName();
    }

    //===============================================================
    //===============================================================
    public static void main(String[] args) {
        String path = "/segfs/tango/tools/pogo/test/cpp/test_oaw";
        String filename = path + "/TestOaw.xmi";
        try {
            OAWutils oaw = OAWutils.getInstance();
            PogoDeviceClass pogo_class = oaw.loadDeviceClassModel(filename);


            //= new DeviceClass(filename).getPogoDeviceClass();

            java.lang.System.err.println("\n\n\n");
            /*try { Thread.sleep(1000); } catch (Exception e){}*/


            pogo_class.getDescription().setSourcePath(path);
            oaw.generate(pogo_class);
        } catch (PogoException e) {
            System.err.println(e);
        }
    }

    //===============================================================
    //===============================================================

    //===============================================================
    //===============================================================
}
