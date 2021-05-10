//+======================================================================
//
// Project:   Tango
//
// Description:  source code for Tango code generator.
//
// $Author: verdier $
//
// Copyright (C) :  2004,2005,2006,2007,2008,2009,2009,2010,2011,2012,2013,2014
//					European Synchrotron Radiation Facility
//                  BP 220, Grenoble 38043
//                  FRANCE
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

package fr.esrf.tango.pogo.generator.cpp.projects;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import org.eclipse.emf.common.util.EList;

import fr.esrf.tango.pogo.pogoDsl.AdditionalFile;
import fr.esrf.tango.pogo.pogoDsl.OneClassSimpleDef;
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass;
import fr.esrf.tango.pogo.pogoDsl.Inheritance;
import fr.esrf.tango.pogo.pogoDsl.PogoMultiClasses;
import fr.esrf.tango.pogo.generator.cpp.utils.InheritanceUtils;

public class MakefileUtils extends fr.esrf.tango.pogo.generator.common.StringUtils{

	InheritanceUtils	inheritanceUtils = new InheritanceUtils();
	//======================================================
	/**
	 * Include part header
	 * @return include part header
	 */
	//======================================================
	String makefileIncludesHeader() {
		return
			"#=============================================================================\n" +
			"# INC_DIR_USER is the list of all include path needed by your sources\n"          +
			"#   - for a device server, tango dependencies are automatically appended\n"       +
			"#   - '-I ../include' and '-I .' are automatically appended in all cases\n"       +
			"#\n" +
			"INC_DIR_USER= -I . ";
	}
	//======================================================
	/**
	 * include for specified class
	 * @param cls specified PogoDeviceClass object
	 * @return include for specified class
	 */
	//======================================================
	String makefileIncludes(PogoDeviceClass cls) {

		return  makefileIncludesHeader() +
				addInheritanceIncludeHome(cls.getDescription().getInheritances());
	}
	//======================================================
	/**
	 * include for specified classes
	 * @param multi specified PogoMultiClasses object
	 * @return include for specified classes
	 */
	//======================================================
	String makefileIncludes(PogoMultiClasses multi) {
		StringBuilder code = new StringBuilder(makefileIncludesHeader());
		for (OneClassSimpleDef cls : multi.getClasses()) {
			code.append(addClassIncludeHome(cls.getClassname()));
			code.append(addInheritanceIncludeHome(cls.getInheritances()));
		}
		return code.toString();
	}
	//======================================================
	//======================================================
	String addInheritanceIncludeHome(EList<Inheritance> inheritances) {
	 	// Add inheritance include files if any
		StringBuilder sb = new StringBuilder();
		for (Inheritance inheritance : inheritances) {
	 		if (inheritanceUtils.isInheritanceClass(inheritance)) {
	 			sb.append(addClassIncludeHome(inheritance.getClassname())); 
	 		}
		}
		return sb.toString();
	}
	//======================================================
	//======================================================
	String addClassIncludeHome(String className) {
		String code = "\\\n"; 
		code += "              -I $(" + classHomeDir(className) + ")";
		return code;
	}
	//=============================================================================
 	// Add inheritance include files reference if any
 	//=============================================================================
 	String addInheritancIncludeReference(PogoDeviceClass cls) {
		String code = "";
	 	for (Inheritance inheritance : cls.getDescription().getInheritances()) {
	 		if (inheritanceUtils.isInheritanceClass(inheritance)) {
				 code = "$(SVC_INHERITANCE_INCL)"; 
	 		}
	 	}
		return  code;
	}
	//======================================================
	//======================================================


	
	
	
	
	//======================================================
	/**
	 * Define the definition for all classes in project
	 * @param multi specified PogoDeviceClass object
	 * @return code to define all classes in project
	 */
	//======================================================
	String addClassesDefinitions(PogoMultiClasses multi) {
		inheritedObjectFiles = new ArrayList<>();
		StringBuilder code =
				new StringBuilder("#=============================================================================\n" +
						"# Tango Class list used by project\n" +
						"#\n");
		for (OneClassSimpleDef cls : multi.getClasses()) {
			code.append(addClassDefinition(cls.getClassname(), cls.getSourcePath()));
			
			//	Add inheritance class if any
			for (Inheritance inheritance : cls.getInheritances()) {
				if (inheritanceUtils.isInheritanceClass(inheritance)) {
					code.append("#------------ Inheritance from ").append(cls.getClassname()).append(" class ------------\n");
					code.append(addClassDefinition(inheritance.getClassname(), inheritance.getSourcePath()));
				}
			}
		}
		return code.toString();
	}
	//======================================================
	/**
	 * Define the definition for inherited classes
	 * @param cls specified PogoDeviceClass object
	 * @return code to define inherited classes
	 */
	//======================================================
	String addInheritanceDefinitions(PogoDeviceClass cls){
		StringBuilder code = new StringBuilder();
		if (inheritanceUtils.hasInheritanceClass(cls)) {
			code = new StringBuilder("#=============================================================================\n" +
					"# Following are names, pathes and files of the inherited classes used by project\n" +
					"#\n");
			for (Inheritance inheritance : cls.getDescription().getInheritances()) {
				if (inheritanceUtils.isInheritanceClass(inheritance)) {
					code.append("#------------ Inheritance from ").append(cls.getName()).append(" class ------------\n");
					code.append(addClassDefinition(inheritance.getClassname(), inheritance.getSourcePath()));
				}
			}
		}
		return code.toString();
	}
	//=============================================================================
 	/**
 	 *  Define the definition for inherited classes
 	 * @param className specified class name
 	 * @param sourcePath specified class source path
 	 * @return code 
 	 */
 	//=============================================================================
	String addClassDefinition(String className, String sourcePath) {
		return 
			className.toUpperCase() + "_CLASS = " + className + "\n" +
			classHomeDir(className) + "  = " + sourcePath + "\n\n";
	}
	//======================================================
	//======================================================

	
	
	//======================================================
	//======================================================
	String addObjectFiles(PogoMultiClasses multi) {
		StringBuilder code =
				new StringBuilder("#=============================================================================\n" +
						"# SVC_OBJS is the list of all objects needed to make the output\n" +
						"#\n" +
						"SVC_OBJS =  ");
	
		int	i=0;
		for (OneClassSimpleDef cls : multi.getClasses()) {
			if (i++>0)
				code.append("            ");
			code.append("$(SVC_").append(cls.getClassname().toUpperCase()).append("_OBJS) \\\n");
		}
		code.append("            $(OBJDIR)/MultiClassesFactory.o \\\n" + "            $(OBJDIR)/main.o");

		code.append("\n\n");
		for (OneClassSimpleDef cls : multi.getClasses()) {
			code.append(addObjectFileList(cls));
		}
		
		return code.toString();
	}
	//======================================================
	//======================================================
	private String addObjectFileList(OneClassSimpleDef cls) {
		StringBuilder code = new StringBuilder("#------------  Object files for " + cls.getClassname() + " class  ------------\n");
		code.append("SVC_").append(cls.getClassname().toUpperCase()).append("_OBJS = \\\n");
		code.append(addObjectFileList(cls.getClassname()));

		//	Add dynamic attribute tools file if needed.
		if (isTrue(cls.getHasDynamic())) {
			code.append(" \\\n");
			code.append("		$(OBJDIR)/").append(cls.getClassname()).append("DynAttrUtils.o");
		}

		//	Additional files
		for (AdditionalFile file : cls.getAdditionalFiles()) {
			code.append(" \\\n");
			code.append("		$(OBJDIR)/").append(file.getName()).append(".o");
		}
		
		//	Inheritance files
		for (Inheritance inheritance : cls.getInheritances()) {
			if (inheritanceUtils.isInheritanceClass(inheritance)) {
				code.append(" \\\n").append(addObjectFileList(inheritance.getClassname()));
			}
		}
		code.append("\n\n");
		return code.toString();
	}
	//======================================================
	//======================================================
	private static List<String> inheritedObjectFiles;
	private String addObjectFileList(String classname) {
		String	classObjectFile = classname +".o";
		String code = "";

		//	If class already declared, do not re-do it (e.g. inheritance)
		if (alreadyDeclared(classObjectFile, inheritedObjectFiles))
			return "";
		
		code += "		$(OBJDIR)/" + classname +".o \\\n";
		code += "		$(OBJDIR)/" + classname +"Class.o \\\n";
		code += "		$(OBJDIR)/" + classname +"StateMachine.o";
		inheritedObjectFiles.add(classObjectFile);
		return code;
	}
	//======================================================
	//======================================================
	private boolean alreadyDeclared(String str, List<String> list) {
		for (String s : list)
			if (s.equals(str))
				return true;
		return false;
	}
	//======================================================
	//======================================================
	String dependencies(PogoMultiClasses multi) {
		StringBuilder code = new StringBuilder();
		for (OneClassSimpleDef cls : multi.getClasses()) {
			code.append("#------------  Object files dependencies for ").append(cls.getClassname()).append(" class  ------------\n");
			code.append(dependenciesIncludes(cls.getClassname(), cls.getInheritances()));
			code.append(dependanciesObject(cls.getClassname(), ""));
			code.append(dependanciesObject(cls.getClassname(), "Class"));
			code.append(dependanciesObject(cls.getClassname(), "StateMachine"));

			//	Add dynamic attribute tools file if needed.
			if (isTrue(cls.getHasDynamic())) {
				code.append(dependanciesObject(cls.getClassname(), "DynAttrUtils"));
			}

			//	Additional files
			for (AdditionalFile file : cls.getAdditionalFiles()) {
				code.append(dependanciesObjectAddFile(cls.getClassname(), file.getPath(), file.getName(), false));
			}

			//	Inheritance files
			for (Inheritance inheritance : cls.getInheritances()) {
				if (inheritanceUtils.isInheritanceClass(inheritance)) {
					if (!alreadyDeclared(inheritance.getClassname(), inheritedDependenciesFiles)) {
						code.append(dependanciesObject(inheritance.getClassname(), ""));
						code.append(dependanciesObject(inheritance.getClassname(), "Class"));
						code.append(dependanciesObject(inheritance.getClassname(), "StateMachine"));
						inheritedDependenciesFiles.add(inheritance.getClassname());
					}
				}
			}
			code.append("\n");
		}
		return code.toString();
	}
	//======================================================
	//======================================================
	private static ArrayList<String> inheritedDependenciesFiles = new ArrayList<>();
	String dependenciesIncludes(String classname, EList<Inheritance> inheritances) {
		StringBuilder code = new StringBuilder();
		if (inheritances!=null) {
			code.append(classIncludeDir(classname)).append(" = \\\n");
			for (Inheritance inheritance : inheritances) {
				if (inheritanceUtils.isInheritanceClass(inheritance)) {
					code.append(dependenciesIncludes(inheritance.getClassname(), null));
					code.append(" \\\n");
				}
			}
		}

		code.append("		$(").append(classHomeDir(classname)).append(")/").append(classname).append(".h \\\n");
		code.append("		$(").append(classHomeDir(classname)).append(")/").append(classname).append("Class.h");
		
		if (inheritances!=null) {
			code.append("\n\n");
		}
		return code.toString();
	}
	//======================================================
	/**
	 * Generate something like (for Serial class)
	 *	$(OBJDIR)/Serial.o: $(SERIAL_HOME)/SerialClass.cpp $(SERIAL_INCL)
	 *	$(CC) $(CFLAGS) -c $< -o $(OBJDIR)/SerialClass.o
	 *
	 * @param classname specified class name
	 * @param sufix		(Class, Statemachine, ...)
	 * @return generated code
	 */
	//======================================================
	private String dependanciesObject(String classname, String sufix) {
		String code = 
			"$(OBJDIR)/" + classname + sufix + ".o:"+
				"  $(" +  classHomeDir(classname) + ")/"+classname+sufix+".cpp $("+classIncludeDir(classname)+")\n";
		code += "	$(CXX) $(CXXFLAGS) -c $< -o $(OBJDIR)/" + classname + sufix + ".o\n";
		return code;
	}
	//======================================================
	private String dependanciesObjectAddFile(String classname, String path, String filename, boolean mainClass) {
		String code = "$(OBJDIR)/" + filename + ".o:";
		if (mainClass)
			code += "  " + path + " $(SVC_INCL)\n";
		else
			code += "  $(" +  classHomeDir(classname) + ")/"+filename+".cpp $("+classIncludeDir(classname)+")\n";

		code += "	$(CXX) $(CXXFLAGS) -c $< -o $(OBJDIR)/" + filename + ".o\n";
		return code;
	}
	//======================================================
	//======================================================
	private String classIncludeDir(String classname) {
		return classname.toUpperCase()+"_INCLUDES";
	}
	//======================================================
	//======================================================
	private String classHomeDir(String classname) {
		return classname.toUpperCase()+"_HOME";
	}
	//======================================================
	//======================================================

	//======================================================
	//======================================================
	String makeEnv(PogoMultiClasses multi, boolean cmake) {
		String	dbg = System.getProperty("DEBUG_MAKE");
		String code = 
				"# MAKE_ENV is the path to find the common environment to build the project\n" +
				"#\n";
		if (cmake)
			code += "set(MAKE_ENV ";
		else
			code += "MAKE_ENV ?= ";

		if (dbg!=null) //	To force it under development
			code += dbg;
		else
		if (isSet(multi.getPreferences().getMakefileHome()))
			code += multi.getPreferences().getMakefileHome();
		else
			code += "$(TANGO_HOME)";
		if (cmake)
			code += ")";
		return code;
	}
	//======================================================
	//======================================================
	String makeEnv(PogoDeviceClass cls, boolean cmake) {
		String	dbg = System.getProperty("DEBUG_MAKE");
		String code = 
				"# MAKE_ENV is the path to find the common environment to build the project\n" +
				"#\n";
		if (cmake)
			code += "set(MAKE_ENV ";
		else
			code += "MAKE_ENV ?= ";

		if (dbg!=null) //	To force it under development
			code += dbg;
		else
		if (isSet(cls.getPreferences().getMakefileHome()))
			code += cls.getPreferences().getMakefileHome();
		else
			code += "$(TANGO_HOME)";
		if (cmake)
			code += ")";
		return code;
	}
	//======================================================
	//======================================================

	
	
	
	//======================================================
	//======================================================
	String inheritanceDependencies(PogoDeviceClass cls) {
		StringBuilder code =
				new StringBuilder("#=============================================================================\n" +
						"# Following are dependencies of the inherited classes used by project\n" +
						"#\n");
		for (Inheritance inher : cls.getDescription().getInheritances()) {
			if (inheritanceUtils.isInheritanceClass(inher)) {
				code.append("\n" + "#------------  Object files dependencies for ").append(inher.getClassname()).append(" class  ------------\n");
				code.append(classIncludeDir(inher.getClassname())).append(" = \\\n");
				code.append("		$(").append(classHomeDir(inher.getClassname())).append(")/").append(inher.getClassname()).append(".h \\\n");
				code.append("		$(").append(classHomeDir(inher.getClassname())).append(")/").append(inher.getClassname()).append("Class.h\n");
				code.append(dependanciesObject(inher.getClassname(), ""));
				code.append(dependanciesObject(inher.getClassname(), "Class"));
				code.append(dependanciesObject(inher.getClassname(), "StateMachine"));

				/*	ToDo additional for inheritance ?
				for (AdditionalFile file : cls.getAdditionalFiles()) {
					code += dependenciesObjectAddFile(cls.getName(), file.getName());
				}
				*/
			}
		}

		code.append("\nSVC_INHERITANCE_INCL = ");
		for (Inheritance inheritance : cls.getDescription().getInheritances()) {
			if (inheritanceUtils.isInheritanceClass(inheritance)) {
				code.append(" $(").append(classIncludeDir(inheritance.getClassname())).append(")");
			}
		}
		code.append("\n");

		return code.toString();
	}
	//=============================================================================
	// Add dynamic attribute util if any
	//=============================================================================
 	String dynamicAttrObjects(PogoDeviceClass cls) {
 		String code = "";
 		if (cls.getDynamicAttributes().size()>0 || cls.getDynamicCommands().size()>0) {
 			code = "$(OBJDIR)/$(PACKAGE_NAME)DynAttrUtils.o \\\n";
 		}
 		return code;
 	}
 	//=============================================================================
	// Add inheritance object if any
	//=============================================================================
 	String inheritanceObjects(PogoDeviceClass cls) {
 		String code = "";
 		if (inheritanceUtils.hasInheritanceClass(cls)) {
 			code = "$(SVC_INHERITANCE_OBJ) \\\n";
 			/*
 			for (Inheritance inheritance : cls.getDescription().getInheritances()) {
				if (inheritanceUtils.isInheritanceClass(inheritance)) {
 					code = "$(SVC_" + inheritance.getClassname().toUpperCase() + "_OBJ) \\\n";
				}
 			}
 			*/
 		}
 		return code;
 	}
 
 	//=============================================================================
	// Add Additional object files if any (Utils, threads, ...)
	//=============================================================================
 	String addAdditionalObjectFiles(PogoDeviceClass cls) {
 		String code = "";
 		if (cls.getAdditionalFiles().size()>0) {
			code = "#------------ Object files for additional files ------------\n" +
					"ADDITIONAL_OBJS = \\\n" +
					buildAdditionalFileListForMakefile(cls.getAdditionalFiles(), "		$(OBJDIR)/", ".o");
 		}
 		return code;
 	}
	//===========================================================
 	public String additionalDependencies(PogoDeviceClass cls) {
 		StringBuilder code = new StringBuilder();
 		for (AdditionalFile file : cls.getAdditionalFiles()) {
			code.append(dependanciesObjectAddFile(cls.getName(), file.getPath(), file.getName(), true));
		}
 		return code.toString();
 	}
	//===========================================================
	public String buildAdditionalFileListForMakefile(EList<AdditionalFile> list, String startTag, String endTag) {
		List<String> files = new ArrayList<>();
		for (AdditionalFile file : list)
			files.add(file.getName());
		return buildFileListForMakefile(files, startTag, endTag);
	}
	//===========================================================
	@SuppressWarnings("unused")
	public String buildInheritanceFileListForMakefile(EList<Inheritance> list, String startTag, String endTag) {
		List<String> files = new ArrayList<>();
		for (Inheritance inheritance : list)
			files.add(inheritance.getClassname());
		return buildFileListForMakefile(files, startTag, endTag);
	}
	//===========================================================
	//	Build a string with specified strings for Makefile
	//===========================================================
	private String buildFileListForMakefile(List<String> list, String startTag, String endTag) {
		StringBuilder sb = new StringBuilder();
		for (int i=0 ; i<list.size();i++) {
			sb.append(startTag).append(list.get(i)).append(endTag);
			if (i<list.size()-1)
				sb.append(" \\").append('\n');
		}
		return sb.toString();
	}



	//===========================================================
	//===========================================================
	public String upperClassName(PogoDeviceClass cls) {
		return cls.getName().toUpperCase();
	}
	//===========================================================
	//===========================================================
	private String getTab(String header) {
		StringBuilder sb = new StringBuilder("\n");
		for (int i=0 ; i<header.length() ; i++)
			sb.append(" ");
		return sb.toString();
	}
	//===========================================================
	//	Build list of source files for cmake
	//===========================================================
	public String cmakeSourceFileList(PogoDeviceClass cls) {
		String header = "set(" + upperClassName(cls) + "_SRC  ";
		String tab  = getTab(header);
		String code = header + "${" + upperClassName(cls) +  "}.cpp" +
					  tab    + "${" + upperClassName(cls)  + "}Class.cpp" +
					  tab    + "${" + upperClassName(cls)  + "}StateMachine.cpp";
		if (cls.getDynamicAttributes().size()>0 || cls.getDynamicCommands().size()>0)
			code += tab + "${" + upperClassName(cls) + "}DynAttrUtils.cpp";
		code += cmakeAdditionalFiles(cls, tab);
		return code + ")";
	}
	//===========================================================
	//	Build list of source files for cmake
	//===========================================================
	public String cmakeSourceFileList(String path, String upperClassName, boolean hasDynamic) {
		String header = "set(" + upperClassName + "_SRC  ";
		String tab  = getTab(header);
		String code = header + path + "${" + upperClassName +  "}.cpp" +
					  tab    + path + "${" + upperClassName  + "}Class.cpp" +
					  tab    + path + "${" + upperClassName  + "}StateMachine.cpp";
		if (hasDynamic)
			code += tab + "${" + upperClassName + "}DynAttrUtils.cpp";
		return code + ")";
	}
	//===========================================================
	//===========================================================
	public String cmakeAdditionalFiles(PogoDeviceClass cls, String tab) {
		EList<AdditionalFile> additionalFiles = cls.getAdditionalFiles();
		StringBuilder sb = new StringBuilder();
		for (AdditionalFile additionalFile : additionalFiles) {
			// Get relative path between project and additional file
			String relativeFile = getRelativePath(cls, additionalFile);
			sb.append(tab).append(relativeFile);
		}
		return sb.toString();
	}
	//===========================================================
	//===========================================================
	public String cmakeClassParameters(PogoDeviceClass cls) {
		return 
			"#\n" +
			"# Files for "+cls.getName() + " TANGO class\n" +
			"#\n" +
			"set(" + upperClassName(cls) + " " + cls.getName() + ")\n" +
			"set(" + upperClassName(cls) + "_INCLUDE ${CMAKE_SOURCE_DIR})\n" +
			cmakeSourceFileList(cls);
	}
	//===========================================================
	//===========================================================
	public String cmakeInheritanceClassParameters(PogoDeviceClass cls) {
		EList<Inheritance> inheritances = cls.getDescription().getInheritances();
		StringBuilder sb = new StringBuilder();
		for (Inheritance inheritance : inheritances) {
			if (inheritanceUtils.isInheritanceClass(inheritance)) {
				String path = inheritance.getSourcePath();
				String upperClassName = inheritance.getClassname().toUpperCase();
				String str = "#\n" + "# Files for " + inheritance.getClassname() + " TANGO class\n" + "#\n";
				str += "set(" + upperClassName + "_PATH " + path + ")\n";
				str += "set(" + upperClassName + " " + inheritance.getClassname() + ")\n";
				str += "set(" + upperClassName + "_INCLUDE " + path + ")\n";
				
				str += cmakeSourceFileList("${"+upperClassName+"_PATH}/", upperClassName, false) + "\n";
				
				sb.append(str);
			}
		}
		return sb.toString();
	}
	//===========================================================
	//===========================================================
	public String cmakeInheritanceFileList(PogoDeviceClass cls, String fileType) {
		EList<Inheritance> inheritances = cls.getDescription().getInheritances();
		StringBuilder sb = new StringBuilder();
		for (Inheritance inheritance : inheritances) {
			if (inheritanceUtils.isInheritanceClass(inheritance)) {
				sb.append("${").append(inheritance.getClassname().toUpperCase()).append(fileType).append("} ");
			}
		}
		return sb.toString();
	}
	//===========================================================
	//===========================================================

	
	
	/*=========    For multiple classes project   ==========*/
	
	
	//======================================================
	/**
	 * Define the definition for all classes in project
	 * @param multi specified PogoMultiClasses object
	 * @return code to define all classes in project
	 */
	//======================================================
	String cmakeAddClassesDefinitions(PogoMultiClasses multi) {
		inheritedObjectFiles = new ArrayList<>();
		StringBuilder code =
				new StringBuilder("#\n" +
						"# Tango Class list used by project\n" +
						"#\n");
		for (OneClassSimpleDef simple : multi.getClasses()) {
			code.append("\n#\n" + "# Files for ").append(simple.getClassname()).append(" TANGO class\n").append("#\n");
			//	Add inheritance class if any
			for (Inheritance inheritance : simple.getInheritances()) {
				if (inheritanceUtils.isInheritanceClass(inheritance)) {
					code.append("#------------ Inheritance from ").append(inheritance.getClassname()).append(" class ------------\n");
					code.append(cmakeAddClassDefinition(inheritance.getClassname(), inheritance.getSourcePath()));
				}
			}
			
			code.append("set(").append(upperClassName(simple)).append("  ").append(simple.getClassname()).append(")\n");
			code.append("set(").append(upperClassName(simple)).append("_PATH  ").append(simple.getSourcePath()).append(")\n");
			code.append("set(").append(upperClassName(simple)).append("_INCLUDE  ");
			for (Inheritance inheritance : simple.getInheritances()) {
				if (inheritanceUtils.isInheritanceClass(inheritance)) {
					code.append("${").append(inheritance.getClassname().toUpperCase()).append("_INCLUDE} ");
				}
			}
			code.append(simple.getSourcePath()).append(")\n");
			
			code.append(cmakeSourceFileList(simple));
		}
		return code.toString();
	}
	//===========================================================
	//===========================================================
	public String upperClassName(OneClassSimpleDef simple) {
		return simple.getClassname().toUpperCase();
	}
	//===========================================================
	//===========================================================
	public String cmakeFileList(PogoMultiClasses multi, String fileType) {
		StringBuilder sb = new StringBuilder();
		for (OneClassSimpleDef simple : multi.getClasses()) {
			sb.append("${").append(simple.getClassname().toUpperCase()).append(fileType).append("} ");
		}
		return sb.toString();
	}
	//===========================================================
	//	Build list of source files for cmake
	//===========================================================
	public String cmakeSourceFileList(OneClassSimpleDef simple) {
		String path = "${" + upperClassName(simple) + "_PATH}/";
		String code = "set(" + upperClassName(simple) + "_SRC  " +
					  cmakeInheritanceFileList(simple) +
					  path + "${" + upperClassName(simple) +  "}.cpp " +
					  path + "${" + upperClassName(simple) + "}Class.cpp " +
					  path + "${" + upperClassName(simple) + "}StateMachine.cpp ";
		if (isTrue(simple.getHasDynamic()))
			code += path + "${" + upperClassName(simple) + "}DynAttrUtils.cpp " ;
		code += cmakeAdditionalFiles(simple);
		return code.trim()+")";
	}
	//===========================================================
	//===========================================================
	public String cmakeAdditionalFiles(OneClassSimpleDef simple) {
		String path = "${" + upperClassName(simple) + "_PATH}/";
		EList<AdditionalFile> additionalFiles = simple.getAdditionalFiles();
		StringBuilder str = new StringBuilder();
		for (AdditionalFile additionalFile : additionalFiles) {
			str.append(path).append(additionalFile.getName()).append(".cpp ");
		}
		return str.toString();
	}
	//=============================================================================
 	/**
 	 *  Define the definition for inherited classes
 	 * @param className specified class name
 	 * @param sourcePath specified class source path
 	 * @return code 
 	 */
 	//=============================================================================
	public String cmakeAddClassDefinition(String className, String sourcePath) {
		String path = "${" + className.toUpperCase() + "_PATH}/";
		return 
			"set("  + className.toUpperCase() + "_CLASS " + className + ")\n" +
			"set("  + className.toUpperCase() + "_PATH "  + sourcePath + ")\n" +
			"set("  + className.toUpperCase() + "_INCLUDE " + sourcePath + ")\n"+
			"set("  + className.toUpperCase() + "_SRC " +
			path +  className + ".cpp " +
			path +  className + "Class.cpp " +
			path +  className + "StateMachine.cpp)\n";
	}
	//======================================================
	//======================================================
	public String cmakeInheritanceFileList(OneClassSimpleDef simple) {
		StringBuilder code = new StringBuilder();
		for (Inheritance inheritance : simple.getInheritances()) {
			if (inheritanceUtils.isInheritanceClass(inheritance)) {
				code.append("${").append(inheritance.getClassname().toUpperCase()).append("_SRC} ");
			}
		}
		return code.toString();
	}
	//======================================================
	//======================================================



	//===============================================================
	//===============================================================
	public static String getRelativePath(PogoDeviceClass cls, AdditionalFile additionalFile) {
		// Split path and file name with extension
		String path = additionalFile.getPath();
		int idx = path.lastIndexOf(additionalFile.getName());
		String fileName = path.substring(idx);
		path = path.substring(0, --idx);

		String referencePath = cls.getDescription().getSourcePath();
		try {
			// Get relative path between project and additional file
			path = getRelativePath(path, referencePath);
			if (path.endsWith("/"))
				return path + fileName;
			else
				return path + '/' + fileName;
		}
		catch (Exception e) {
			// low probability
			e.printStackTrace();
			//	return absolute
			return additionalFile.getPath();
		}
	}
	//===============================================================
	/**
	 * Compute relative path between a path and a reference
	 * @param path          specified path
	 * @param referencePath reference path
	 * @return the relative path
	 */
	//===============================================================
	public static String getRelativePath(String path, String referencePath) throws Exception {
		String separator = System.getProperty("file.separator");
		path = getCanonicalPath(path);
		referencePath = getCanonicalPath(referencePath);

		//System.out.println("Check relative between \n" + referencePath + "\n" + path + "\n");

		StringTokenizer stk = new StringTokenizer(path, separator);
		List<String> pathList = new ArrayList<>();
		while (stk.hasMoreTokens()) pathList.add(stk.nextToken());
		stk = new StringTokenizer(referencePath, separator);
		List<String> refList = new ArrayList<>();
		while (stk.hasMoreTokens()) refList.add(stk.nextToken());

		//  Special case for Windows
		//  If file come from different disk (e.g. c: end d:)
		if (refList.get(0).endsWith(":") && pathList.get(0).endsWith(":")) {
			if (!refList.get(0).equalsIgnoreCase(pathList.get(0))) {
				//  Cannot compute a relative path
				//      --> return absolute
				return path;
			}
		}

		//  Check common part from start
		int idx;
		if (refList.get(0).equalsIgnoreCase(pathList.get(0)))
			idx = 1;
		else
			idx = 0;
		while (idx<refList.size() && idx<pathList.size() &&
				refList.get(idx).equals(pathList.get(idx)))
			idx++;
		//  Add up part
		StringBuilder sb = new StringBuilder();
		for (int i = idx ; i<refList.size() ; i++)
			sb.append("..").append(separator);
		//  Add down part
		for (int i = idx ; i<pathList.size() ; i++)
			sb.append(pathList.get(i)).append(separator);

		//  Remove last separator
		String relative = sb.toString();
		if (relative.endsWith(separator))
			relative = relative.substring(0, relative.length() - 1);

		//  if no .. part add relative to ./
		if (!relative.startsWith(".."))
			relative = "./" + relative;

		//  Convert to Linux format
		relative = strReplace(relative, "\\", "/");
		while (relative.startsWith("././")) {
			relative = relative.substring("./".length());
		}
		return relative;
	}
	//===============================================================
	//===============================================================
	private static String getCanonicalPath(String path) throws Exception {
		//  Check original path
		File file = new File(path);
		if (file.isFile()) {
			//  If file, get only pah
			return new File(file.getParent()).getCanonicalPath();
		} else
			return file.getCanonicalPath();
	}
	//===================================================================
	//===================================================================
	public static String strReplace(String text, String old_str, String new_str) {
		if (text == null) return "";
		for (int pos = 0; (pos = text.indexOf(old_str, pos)) >= 0; pos += new_str.length())
			text = text.substring(0, pos) + new_str +
					text.substring(pos + old_str.length());
		return text;
	}
}
