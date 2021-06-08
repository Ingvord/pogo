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

package fr.esrf.tango.pogo.generator.cpp.utils


import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.pogoDsl.Pipe
import fr.esrf.tango.pogo.pogoDsl.Command
import static extension fr.esrf.tango.pogo.generator.cpp.utils.CppTypeDefinitions.*
import static extension fr.esrf.tango.pogo.generator.cpp.utils.CppStringUtils.*
import com.google.inject.Inject
import fr.esrf.tango.pogo.pogoDsl.PogoMultiClasses

class Headers extends fr.esrf.tango.pogo.generator.common.Headers{

	@Inject	extension fr.esrf.tango.pogo.generator.cpp.utils.CppStringUtils

	//======================================================
	// header for device.h
	//======================================================
	def deviceIncludeFileName(PogoDeviceClass cls) {
		cls.name+".h"
	}
	def deviceIncludeFileHeader(PogoDeviceClass cls) {
		fileHeader(deviceIncludeFileName(cls),
			"Include file for the " + cls.name + " class",
			 cls.description.title,
			cls.description.license,
			cls.description.copyright
		)
	}


	//======================================================
	// header for deviceClass.h
	//======================================================
	def deviceClassIncludeFileName(PogoDeviceClass cls) {
		cls.name + "Class.h"
	}
	def deviceClassIncludeFileHeader(PogoDeviceClass cls) {
		fileHeader(deviceClassIncludeFileName(cls),
			"Include for the " + cls.name +" root class.\n"+
			"This class is the singleton class for\n"+
			" the " + cls.name + " device class.\n"+
			"It contains all properties and methods which the\n" +
			cls.name + " requires only once e.g. the commands.",
			 cls.description.title,
			cls.description.license,
			cls.description.copyright
		)
	}


	//======================================================
	// header for device.cpp
	//======================================================
	def deviceSourceFileName(PogoDeviceClass cls) {
		cls.name + ".cpp"
	}
	def deviceSourceFileHeader(PogoDeviceClass cls) {
		fileHeader(deviceSourceFileName(cls), 
			"C++ source for the " + cls.name + " class and its commands.\n" +
			"The class is derived from Device. It represents the\n" +
			"CORBA servant object which will be accessed from the\n" +
			"network. All commands which can be executed on the\n" +
			cls.name + " are implemented in this file.",
			cls.description.title,
			cls.description.license,
			cls.description.copyright
		)
	}
	
	
	//======================================================
	// header for deviceClass.cpp
	//======================================================
	def deviceClassSourceFileName(PogoDeviceClass cls) {
		cls.name + "Class.cpp"
	}
	def deviceClassSourceFileHeader(PogoDeviceClass cls) {
		fileHeader(deviceClassSourceFileName(cls),
			"C++ source for the " + cls.name + "Class.\n" + 
			"A singleton class derived from DeviceClass.\n"+ 
			"It implements the command and attribute list\n" +
			"and all properties and methods required\n" +
			"by the " + cls.name + " once per process.",
			cls.description.title,
			cls.description.license,
			cls.description.copyright
		)
	}
	
	//======================================================
	// header for StateMachine.cpp
	//======================================================
	def stateMachineFileName(PogoDeviceClass cls) {
		cls.name + "StateMachine.cpp"
	}
	def stateMachineFileHeader(PogoDeviceClass cls) {
		fileHeader(stateMachineFileName(cls),
			"State machine file for the " + cls.name + " class",
			cls.description.title,
			cls.description.license,
			cls.description.copyright
		)
	}

	//======================================================
	// header for DynamicAttrUtils.cpp
	//======================================================
	def dynamicAttrUtilsFileName(PogoDeviceClass cls) {
		cls.name + "DynAttrUtils.cpp"
	}
	def dynamicAttrUtilsFileHeader(PogoDeviceClass cls) {
		fileHeader(dynamicAttrUtilsFileName(cls),
			"Dynamic attributes utilities file for the " + cls.name + " class",
			cls.description.title,
			cls.description.license,
			cls.description.copyright
		)
	}
	//======================================================
	// header for ClassFactory.cpp
	//======================================================
	def ClassFactoryFileHeader(PogoDeviceClass cls) {
		fileHeader("ClassFactory.cpp",
			"C++ source for the class_factory method of the DServer\n" +
			"device class. This method is responsible for the creation of\n" +
			"all class singleton for a device server. It is called\n" +
			"at device server startup.",
			cls.description.title,
			cls.description.license,
			cls.description.copyright
		 )
	}
	//======================================================
	// header for MultiClassFactory.cpp
	//======================================================
	def ClassFactoryFileHeader(PogoMultiClasses multi) {
		fileHeader("MultiClassessFactory.cpp",
			"C++ source for the class_factory method of the DServer\n" +
			"device class. This method is responsible for the creation of\n" +
			"all class singleton for a device server. It is called\n" +
			"at device server startup.", "",
			multi.license,
			multi.copyright
		)
	}
	
	//======================================================
	// header for main.cpp
	//======================================================
	def mainFileHeader(PogoDeviceClass cls) {
		fileHeader("main.cpp",
			"C++ source for the " + cls.name + " device server main.\n"  +
			"The main rule is to initialise (and create) the Tango\n" +
			"system and to create the DServerClass singleton.\n" +
			"The main should be the same for every Tango device server.",
			cls.description.title,
			cls.description.license,
			cls.description.copyright
		)
	}

	//======================================================
	// header for main.cpp
	//======================================================
	def mainFileHeader(PogoMultiClasses multi) {
		fileHeader("main.cpp",
			"C++ source for the " + multi.name + " device server main.\n"  +
			"The main rule is to initialise (and create) the Tango\n" +
			"system and to create the DServerClass singleton.\n" +
			"The main should be the same for every Tango device server.",
			multi.title,
			multi.license,
			multi.copyright
		)
	}

	//======================================================
	/*
	 * Methods headers
	 */
	//======================================================
	//======================================================
	//	Simple method header
	//======================================================
	def simpleMethodHeader(PogoDeviceClass cls, String method, String description) {
		"//--------------------------------------------------------\n" +
		"/**\n" +
		" *	Method      : "+ cls.name + "::" + method + "()\n" +
		" " + generateMethodDescription(description.comments(" *                ")) +
		" */\n" +
		"//--------------------------------------------------------"
	}
	//======================================================
	def simpleMethodHeader1(PogoDeviceClass cls, String method, String description) {
		"//--------------------------------------------------------\n" +
		"/*\n" +
		" *	Method      : "+ cls.name + "::" + method + "()\n" +
		" " + generateMethodDescription(description.comments(" *                ")) +
		" */\n" +
		"//--------------------------------------------------------"
	}
	//======================================================
	def simpleMethodHeaderClass(PogoDeviceClass cls, String method, String description) {
		"//--------------------------------------------------------\n" +
		"/**\n" +
		" *	Method      : "+ cls.name + "Class::" + method + "()\n" +
		" " + generateMethodDescription(description.comments(" *                ")) +
		" */\n" +
		"//--------------------------------------------------------"
	}


	//======================================================
	//	Read attribute method header
	//======================================================
	def attributeMethodHeader(Attribute attr, String rw) {
		"//--------------------------------------------------------\n" +
		"/**\n" +
		" *	" + rw +" attribute " + attr.name + " related method\n" +
		" " + generateMethodDescription(attr.properties.description.comments(" *               ")) +
		" *\n" +
		" *	Data type:	" + attr.dataType.cppType + attr.manageEnumForMethodHeader + "\n" +
		" *	Attr type:	" + attr.attType + attr.attTypeDimentions + "\n" + 
		" */\n"	+
		"//--------------------------------------------------------\n"
	}	

	//======================================================
	//	Read pipe method header
	//======================================================
	def pipeMethodHeader(Pipe pipe, String rw) {
		"//--------------------------------------------------------\n" +
		"/**\n" +
		" *	" + rw +" pipe " + pipe.name + " related method\n" +
		" " + generateMethodDescription(pipe.description.comments(" *               ")) +
		" */\n"	+
		"//--------------------------------------------------------\n"
	}	

	//======================================================
	//	Attribute declaration method header
	//======================================================
	def attributePrototypeMethodHeader(Attribute attr) {
		"/**\n" +
		" *	Attribute " + attr.name + " related methods\n" +
		" " + generateMethodDescription(attr.properties.description.comments(" *               ")) +
		" *\n" +
		" *	Data type:  " + attr.dataType.cppType + "\n" +
		" *	Attr type:	" + attr.attType + attr.attTypeDimentions + "\n" + 
		" */\n"		
	}


	//======================================================
	//	Command method header
	//======================================================
	def commandExecutionMethodHeader(Command cmd) {
		"/**\n" +
		" *	Command " + cmd.name + " related method\n" +
		" " + generateMethodDescription(cmd.description.comments(" *               ")) +
		" *\n" + cmd.commandParameterHeader +
		" */\n"		
	}
	
	def generateMethodDescription(String desc) '''
        «IF desc != ""»
            * Description:  «desc»
        «ELSE»
            *
        «ENDIF»
	'''

}