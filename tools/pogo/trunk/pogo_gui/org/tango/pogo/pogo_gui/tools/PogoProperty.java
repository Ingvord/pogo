//+======================================================================
//
// Project:   Tango
//
// Description:	java source code  to read pogo properties file to load them.
//
// $Author: verdier $
//
// Copyright (C) :      2004,2005,2006,2007,2008,2009,2009,2010,2011
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

package org.tango.pogo.pogo_gui.tools;


/**
 *	This class is able to read pogo properties file to load them.
 *
 * @author verdier
 */

import fr.esrf.Tango.DevFailed;
import fr.esrf.TangoDs.Except;
import org.tango.pogo.pogo_gui.PogoConst;

import java.io.*;
import java.util.StringTokenizer;
import java.util.ArrayList;


public class PogoProperty {

    //---------------------- General definitions -----------------------------------
    private static final String packname = "org.tango.pogo";
    private static final String defPropFilename = "/Pogo.default_properties";
    private static final String sitePropFilename = "/Pogo.site_properties";

    private static PogoProperty instance = null;
    public static ArrayList<String> classFamilies = new ArrayList<String>();
    public static ArrayList<String> platformNames = new ArrayList<String>();
    public static ArrayList<String> busNames = new ArrayList<String>();
    private static final String docHomeProp = "doc_home";
    private static final String attrFreeProp = "attr_free";
    private static final String makefileHomeProp = "makefile_home";
    private static final String installHomeProp = "install_home";

    //---------------------- Class identification definitions -----------------------------------
    private static final String classFamiliesProp = "class_families";
    private static final String platformNamesProp = "platform_names";
    private static final String busNamesProp = "bus_names";
    private static final String siteNameProp = "site.name";
    private static final String siteClassFamiliesProp = "site.class_families";

    public static String siteName = null;
    public static String docHome = "./doc_html";
    public static boolean attrFree = false;
    public static String makefileHome = "$(TANGO_HOME)";
    public static String installHome = "$(TANGO_HOME)";
    public static ArrayList<String> siteClassFamilies = new ArrayList<String>();

    //---------------------- $HOME/.pogorc definitions -----------------------------------

    private static final int ownHistoSize = 20;
    private static final String ownInheritanceHome = "hinerit_home";
    private static final String ownContactAddress = "contact_address";
    private static final String ownLoadPrevious = "load_previous";
    private static final String ownProjectHistory = "project_history";
    private static final String multiProjectHistory = "multi_class_project_history";

    public static String inheritHome = null;
    public static String contactAddress = "";
    public static boolean loadPrevious = true;
    public static ArrayList<String> projectHistory = new ArrayList<String>();
    public static ArrayList<String> multiClassProjectHistory = new ArrayList<String>();

    //===============================================================
    //===============================================================
    public static PogoProperty getInstance() {
        return instance;
    }

    //===============================================================
    //===============================================================
    public static PogoProperty init() throws DevFailed {
        if (instance == null)
            instance = new PogoProperty();
        return instance;
    }

    //===============================================================
    //===============================================================
    private PogoProperty() throws DevFailed {
	
		checkEnvironment();
	
        loadDefaultProperties();
        loadSiteProperties();
        loadPogoRcProperties();
    }

    //===============================================================
    /**
     * Check the class path from environment.
     * Some Eclipse classes failed if at least one path is empty or does not exist.
     * This method get the classpath, and keep only the existing ones.
     */
    //===============================================================
	private void checkEnvironment() {
		String classpath = System.getProperty("java.class.path");
        //System.out.println("java.class.path=" + classpath);

        //  Get each path
        StringTokenizer stk = new StringTokenizer(classpath, ":");
        classpath = "";
        while (stk.hasMoreTokens()) {
            String  s = stk.nextToken();
            //  Check if exists
            File f = new File(s);
            if (f.exists())
                classpath += s + ":";
            else
                System.err.println(s + " found in classpath,  does not exist !!!");
        }
        if (classpath.endsWith(":")) {
            //  Remove it
            classpath = classpath.substring(0, classpath.length()-1);
        }
		//System.out.println("java.class.path=" + classpath);
		System.setProperty("java.class.path", classpath);

	}
    //===============================================================
    //===============================================================
    private void loadDefaultProperties() throws DevFailed {
        try {
            //	fill data members with default  properties if any
            ArrayList<String> vs = loadProperties(defPropFilename);
            classFamilies = getStringListProperty(classFamiliesProp, vs);
            platformNames = getStringListProperty(platformNamesProp, vs);
            busNames = getStringListProperty(busNamesProp, vs);
            installHome = checkOverwritingPropertyString(installHomeProp, installHome, vs);

            //	add an empty element as first for Lists
            classFamilies.add(0, "");
            busNames.add(0, "");

        } catch (Exception e) {
            if (e instanceof DevFailed)
                throw (DevFailed) e;
            else
                Except.throw_exception("LOAD_PROPERTY_FAILED",
                        e.toString(),
                        "PogoProperty.loadProperties()");
        }
    }

    //===============================================================
    //===============================================================
    private void loadSiteProperties() {
        try {
            //	fill data members with site properties if any
            ArrayList<String> vs = loadProperties(sitePropFilename);
            siteName = getStringProperty(siteNameProp, vs);
            docHome = checkOverwritingPropertyString(docHomeProp, docHome, vs);
            String s = Boolean.toString(attrFree);
            attrFree = checkOverwritingPropertyString(attrFreeProp, s, vs).equals("true");
            makefileHome = checkOverwritingPropertyString(makefileHomeProp, makefileHome, vs);
            siteClassFamilies = getStringListProperty(siteClassFamiliesProp, vs);
        } catch (Exception e) {
            //	Display only a warning, but start normaly
            System.err.println("\nWARNING:	No site specific properties file found !\n");
        }
    }

    //===============================================================
    //===============================================================
    private void loadPogoRcProperties() {
        try {
            //	fill data members with own properties if any
            String rc_file = getPogoRCname();
            if (rc_file != null) {
                System.out.println(rc_file);
                ArrayList<String> vs = loadPropertiesRC(rc_file);
                projectHistory = getStringListProperty(ownProjectHistory, vs);
                multiClassProjectHistory =
                        getStringListProperty(multiProjectHistory, vs);
                inheritHome = getStringProperty(ownInheritanceHome, vs);
                contactAddress = getStringProperty(ownContactAddress, vs);

                String tmp = getStringProperty(ownLoadPrevious, vs);
                loadPrevious = Utils.isTrue(tmp);

                //	remove first one if is empty
                if (projectHistory.size() > 0 && projectHistory.get(0).length() == 0)
                    projectHistory.remove(0);
                if (multiClassProjectHistory.size() > 0 && multiClassProjectHistory.get(0).length() == 0)
                    multiClassProjectHistory.remove(0);
            }
        } catch (Exception e) {
            if (e instanceof DevFailed)
                System.err.println("\nWARNING:	" + ((DevFailed) e).errors[0].desc);
            else
                System.err.println("\nWARNING:	" + e);
        }
    }

    //===============================================================
    //===============================================================
    private String checkOverwritingPropertyString(String propname, String propvalue, ArrayList<String> vs) {
        String tmp = getStringProperty(propname, vs);
        if (tmp != null) propvalue = tmp;
        return propvalue;
    }

    //===============================================================
    //===============================================================
    private static String getPogoRCname() {
        String env = System.getenv("HOME");
        if (env == null)
            env = System.getenv("TANGO_ROOT");
        if (env == null)
            return null;
        return env + "/.pogorc";
    }

    //===============================================================
    //===============================================================
    private ArrayList<String> loadProperties(String filename) throws DevFailed, IOException {
        //	Get file URL and load it
        java.net.URL url =
                getClass().getResource(filename);
        //System.out.println("URL file="+url.getFile());
        if (url == null) {
            Except.throw_exception("LOAD_PROPERTY_FAILED",
                    "URL for property file (" + filename + ") is null !",
                    "PogoProperty.loadProperties()");
            return null;    //  impossible but removing warning
        }

        InputStream is = url.openStream();
        BufferedReader br =
                new BufferedReader(new InputStreamReader(is));

        ArrayList<String> vs = new ArrayList<String>();
        String str;
        while ((str = br.readLine()) != null) {
            str = str.trim();
            if (!str.startsWith("#")) {
                if (str.length() > 0) {
                    vs.add(str);
                    //System.out.println("vs:"+str);
                }
            }
        }
        br.close();

        return vs;

    }

    //===============================================================
    //===============================================================
    private ArrayList<String> loadPropertiesRC(String filename) throws DevFailed, IOException {
        ArrayList<String> vs = new ArrayList<String>();
        String code = ParserTool.readFile(filename);
        StringTokenizer stk = new StringTokenizer(code, "\n");
        while (stk.hasMoreTokens())
            vs.add(stk.nextToken());
        return vs;
    }

    //===============================================================
    //===============================================================
    private ArrayList<String> getStringListProperty(String propname, ArrayList<String> vs) {
        ArrayList<String> result = new ArrayList<String>();
        boolean found = false;
        for (String line : vs) {
            if (!line.trim().startsWith("#")) {   //  Not a comment {
                if (!found) {
                    if (line.startsWith(packname + "." + propname)) {
                        int pos = line.indexOf(':');
                        if (pos > 0) {
                            found = true;
                            result.add(line.substring(pos + 1).trim());
                        }
                    }
                } else {
                    //  Check if it is a property name
                    if (line.trim().indexOf(':') > 2)// cannot be >0, could be like c:\..\..
                        found = false;
                    else
                        result.add(line.trim());
                }
            }
        }
        return result;
    }

    //===============================================================
    //===============================================================
    private String getStringProperty(String propname, ArrayList<String> vs) {
        for (String s : vs)
            if (s.startsWith(packname + "." + propname)) {
                int pos = s.indexOf(':');
                if (pos > 0) {
                    String str = s.substring(pos + 1).trim();
                    if (str.length() > 0)
                        return str;
                    else
                        return null;
                }
            }
        return null;
    }

    //===============================================================
    //===============================================================
    public void displayProperties() {
        String debug = System.getProperty("DEBUG_PROP");
        if (debug != null && debug.equals("true")) {
            displayProperty(classFamiliesProp, classFamilies);
            displayProperty(platformNamesProp, platformNames);
            displayProperty(busNamesProp, busNames);
        }
        displayProperty(docHomeProp, docHome);
        displayProperty(attrFreeProp, Boolean.toString(attrFree));
        displayProperty(makefileHomeProp, makefileHome);
        displayProperty(installHomeProp, installHome);
        displayProperty(siteNameProp, siteName);

        if (debug != null && debug.equals("true")) {
            displayProperty(siteClassFamiliesProp, siteClassFamilies);
        }
    }

    //===============================================================
    //===============================================================
    private void displayProperty(String name, String value) {
        System.out.println(name + ":	" + value);
    }

    //===============================================================
    //===============================================================
    private void displayProperty(String name, ArrayList<String> values) {
        System.out.print(name + ":");
        for (String s : values)
            System.out.println("	" + s);
        System.out.println();
    }

    //===============================================================
    //===============================================================
    public static void addProject(String projname, int type) {
        if (type == PogoConst.SINGLE_CLASS) {
            //	Check if already exists -> remove
            for (int i = 0; i < projectHistory.size(); i++)
                if (projectHistory.get(i).equals(projname))
                    projectHistory.remove(i);
            //	Add the new one in first index
            projectHistory.add(0, projname);

            //	Check if size is not too big
            while (projectHistory.size() > ownHistoSize)
                projectHistory.remove(ownHistoSize - 1);
        } else {
            //	Check if already exists -> remove
            for (int i = 0; i < multiClassProjectHistory.size(); i++)
                if (multiClassProjectHistory.get(i).equals(projname))
                    multiClassProjectHistory.remove(i);
            //	Add the new one in first index
            multiClassProjectHistory.add(0, projname);

            //	Check if size is not too big
            while (multiClassProjectHistory.size() > ownHistoSize)
                multiClassProjectHistory.remove(ownHistoSize - 1);
        }
        //	Then update file.
        updatePogoRC();
    }

    //===============================================================
    private static String buildPropertyLine(String propname) {
        StringBuilder sb = new StringBuilder();
        sb.append(packname).append('.').append(propname).append(":\t");
        return sb.toString();
    }

    //===============================================================
    //===============================================================
    public static void updatePogoRC() {
        StringBuilder sb = new StringBuilder();
        sb.append("#\n");
        sb.append("#       This is the Pogo user preferences file\n");
        sb.append("#\n\n");

        sb.append(buildPropertyLine(ownInheritanceHome)).append(inheritHome);
        sb.append("\n");
        sb.append(buildPropertyLine(ownContactAddress)).append(contactAddress);
        sb.append("\n");
        sb.append(buildPropertyLine(ownLoadPrevious)).append(loadPrevious);
        sb.append("\n\n");
        sb.append(buildPropertyLine(ownProjectHistory)).append('\n');
        for (String project : projectHistory)
            sb.append('\t').append(project).append('\n');
        sb.append("\n\n");
        sb.append(buildPropertyLine(multiProjectHistory)).append('\n');
        for (String project : multiClassProjectHistory)
            sb.append('\t').append(project).append('\n');

        //  Try to read to compare
        String rc_file = getPogoRCname();
        String code = "";
        try {
            code = ParserTool.readFile(rc_file);
        } catch (Exception e) {
            //	Display only a warning, but start normaly
            if (e instanceof DevFailed)
                System.err.println("\nWARNING:	" + ((DevFailed) e).errors[0].desc);
            else
                System.err.println("\nWARNING:	" + e);
        }


        try {
            //  If different -> save.
            if (!code.equals(sb.toString())) {
                ParserTool.writeFile(rc_file, sb.toString());
                System.out.println(rc_file + " updated");
            }
        } catch (Exception e) {
            //	Display only a warning, but start normaly
            if (e instanceof DevFailed)
                System.err.println("\nWARNING:	" + ((DevFailed) e).errors[0].desc);
            else
                System.err.println("\nWARNING:	" + e);
        }
    }
    //===============================================================
    //===============================================================

    //===============================================================
    //===============================================================
    public void updateSitePropertyFile() throws DevFailed {
        java.net.URL url =
                getClass().getResource(sitePropFilename);
        //System.out.println("URL file="+url.getFile());
        if (url == null) {
            Except.throw_exception("LOAD_PROPERTY_FAILED",
                    "URL for property file (" + sitePropFilename + ") is null !",
                    "PogoProperty.loadProperties()");
            return;    //  impossible but removing warning
        }
        String filename = url.toString();
        if (filename.startsWith("file:"))
            filename = filename.substring("file:".length());


        //  Read file
        String code = ParserTool.readFile(filename);
        boolean writeIt = false;
        //  Insert Site name
        int start = code.indexOf(siteNameProp);
        if (start > 0) {
            start = code.indexOf(':', start) + 1;
            int end = code.indexOf('\n', start);
            code = code.substring(0, start) + "  " +
                    ((siteName == null) ? "" : siteName) + code.substring(end);
            writeIt = true;
        }

        //  Insert Site families
        start = code.indexOf(siteClassFamiliesProp);
        if (start > 0) {
            //  Build string to be inserted for families
            StringBuilder indent = new StringBuilder();
            for (int i = 0; i < siteClassFamiliesProp.length() + packname.length() + 3; i++)
                indent.append(' ');
            StringBuilder sb = new StringBuilder("  ");
            for (String family : siteClassFamilies)
                sb.append(family).append('\n').append(indent);
            String property = "  " + sb.toString().trim() + '\n';

            //  Get position to insert
            start = code.indexOf(':', start) + 1;
            int end = code.indexOf('#', start);
            code = code.substring(0, start) + property + code.substring(end);
            writeIt = true;
        }

        //  Then write file.
        if (writeIt) {
            System.out.println("writing  " + filename);
            ParserTool.writeFile(filename, code);
        }
    }
    //===============================================================
    //===============================================================

    //===============================================================
    //===============================================================
    public static void main(String[] args) {
        try {
            PogoProperty.init().displayProperties();
        } catch (Exception e) {
            System.err.println(e);
            e.printStackTrace();
        }
    }
}
