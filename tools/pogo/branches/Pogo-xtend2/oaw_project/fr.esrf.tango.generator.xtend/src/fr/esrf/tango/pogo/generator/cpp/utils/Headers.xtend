package fr.esrf.tango.pogo.generator.cpp.utils


import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import static org.eclipse.xtext.xtend2.lib.ResourceExtensions.*
import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.pogoDsl.Command
import static extension fr.esrf.tango.pogo.generator.common.StringUtils.*
import static extension fr.esrf.tango.pogo.generator.cpp.utils.CppTypeDefinitions.*
import com.google.inject.Inject
import fr.esrf.tango.pogo.pogoDsl.PogoMultiClasses

class Headers extends fr.esrf.tango.pogo.generator.common.Headers{

	@Inject	extension fr.esrf.tango.pogo.generator.common.StringUtils

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
			cls.description.license
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
			"It contains all properties and methods which the \n" +
			cls.name + " requires only once e.g. the commands.",
			 cls.description.title,
			cls.description.license
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
			cls.description.license
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
			cls.description.license
			
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
			cls.description.license
			 
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
			cls.description.license
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
			cls.description.license
		 )
	}
	//======================================================
	// header for MultiClassFactory.cpp
	//======================================================
	def ClassFactoryFileHeader(PogoMultiClasses cls) {
		fileHeader("MultiClassessFactory.cpp",
			"C++ source for the class_factory method of the DServer\n" +
			"device class. This method is responsible for the creation of\n" +
			"all class singleton for a device server. It is called\n" +
			"at device server startup.", "",
			cls.license)
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
			cls.description.license)
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
			multi.license)
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
		" *	Description : " + description.comments(" *                ") + "\n" +
		" */\n" +
		"//--------------------------------------------------------"
	}
	//======================================================
	def simpleMethodHeaderClass(PogoDeviceClass cls, String method, String description) {
		"//--------------------------------------------------------\n" +
		"/**\n" +
		" *	Method      : "+ cls.name + "Class::" + method + "()\n" +
		" *	Description : " + description.comments(" *                ") + "\n" +
		" */\n" +
		"//--------------------------------------------------------"
	}


	//======================================================
	//	Read attribute method header
	//======================================================
	def attributeMethodHeader(Attribute attr, String rw) {
		"//--------------------------------------------------------\n" +
		"/**\n" +
		" *	" + rw +" attribute " + attr.name + " related mehod\n" +
		" *	Description: " + attr.properties.description.comments(" *               ") + "\n" +
		" *\n" +
		" *	Data type:	" + attr.dataType.cppType + "\n" +
		" *	Attr type:	" + attr.attType + attr.attTypeDimentions + "\n" + 
		" */\n"	+
		"//--------------------------------------------------------\n"
	}	

	//======================================================
	//	Attribute declaration method header
	//======================================================
	def attributePrototypeMethodHeader(Attribute attr) {
		"/**\n" +
		" *	Attribute " + attr.name + " related mehods\n" +
		" *	Description: " + attr.properties.description.comments(" *               ") + "\n" +
		" *\n" +
		" *	Data type:	" + attr.dataType.cppType + "\n" +
		" *	Attr type:	" + attr.attType + attr.attTypeDimentions + "\n" + 
		" */\n"		
	}


	//======================================================
	//	Command method header
	//======================================================
	def commandExecutionMethodHeader(Command cmd) {
		"/**\n" +
		" *	Command " + cmd.name + " related mehod\n" +
		" *	Description: " + cmd.description.comments(" *               ") + "\n" +
		" *\n" +
		" *	@param argin " + cmd.argin.description + "\n" +
		" *	@returns " + cmd.argout.description + "\n" +
		" */\n"		
	}

}