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

package fr.esrf.tango.pogo.generator.cpp

import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import com.google.inject.Inject
import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.pogoDsl.Command
import static extension fr.esrf.tango.pogo.generator.cpp.utils.CppStringUtils.*
import fr.esrf.tango.pogo.generator.cpp.utils.ProtectedArea
import fr.esrf.tango.pogo.generator.cpp.utils.InheritanceUtils
import fr.esrf.tango.pogo.generator.cpp.utils.Headers
import fr.esrf.tango.pogo.generator.cpp.utils.Commands
import fr.esrf.tango.pogo.generator.cpp.utils.Attributes
import fr.esrf.tango.pogo.generator.cpp.utils.Pipes
import fr.esrf.tango.pogo.generator.cpp.utils.Properties
import fr.esrf.tango.pogo.pogoDsl.Pipe

//======================================================
// Define device source file to be generated
//======================================================
class DeviceSource {
	@Inject	extension ProtectedArea
	@Inject	extension fr.esrf.tango.pogo.generator.cpp.utils.CppStringUtils
	@Inject	extension Headers
	@Inject	extension Commands
	@Inject	extension Attributes
	@Inject	extension Pipes
	@Inject	extension Properties
	@Inject	extension InheritanceUtils


	//======================================================
	// Define device source file to be generated
	//======================================================
	def generateDeviceSourceFile (PogoDeviceClass cls) '''
		«cls.fileHeader»
		
		/**
		 *  «cls.name» class description:
		 *    «cls.description.description.comments("*    ")»
		 */
		
		«cls.commands.commandsTable»

		«cls.attributes.attributesTable»
		
		namespace «cls.name»_ns
		{
		«cls.protectedArea("namespace_starting", "static initializations", true)»
		«cls.constructors»
		«cls.initDeviceMethod»
		«cls.utilsMethods»
		«cls.attributeMethods»
		«cls.pipeMethods»
		«cls.commandMethods»

		«cls.protectedArea("namespace_ending", "Additional Methods", true)»
		} //	namespace
	'''

	//======================================================
	// define the header file
	//======================================================
	def fileHeader (PogoDeviceClass cls) '''
		«cls.protectedArea(".cpp",
			cls.deviceSourceFileHeader+
			"\n\n" +
			"#include <"+cls.name+".h>\n"+
			"#include <"+cls.name+"Class.h>", false)»
	'''


	//======================================================
	// Define constructors code
	//======================================================
	def constructors(PogoDeviceClass cls) '''
		
		«cls.simpleMethodHeader(cls.name,
			 "Constructors for a Tango device\nimplementing the class" + cls.name)»
		«cls.name»::«cls.name»(Tango::DeviceClass *cl, std::string &s)
		 : «cls.inheritedClassName»(cl, s.c_str())
		{
			«cls.protectedArea("constructor_1", "init_device();", false)»
		}
		//--------------------------------------------------------
		«cls.name»::«cls.name»(Tango::DeviceClass *cl, const char *s)
		 : «cls.inheritedClassName»(cl, s)
		{
			«cls.protectedArea("constructor_2", "init_device();", false)»
		}
		//--------------------------------------------------------
		«cls.name»::«cls.name»(Tango::DeviceClass *cl, const char *s, const char *d)
		 : «cls.inheritedClassName»(cl, s, d)
		{
			«cls.protectedArea("constructor_3", "init_device();", false)»
		}

		«cls.simpleMethodHeader("delete_device",
			 "will be called at device destruction or at init command")»
		void «cls.name»::delete_device()
		{
			DEBUG_STREAM << "«cls.name»::delete_device() " << device_name << std::endl;
			«cls.protectedArea("delete_device", "Delete device allocated objects", true)»
			«cls.attributes.deleteAttributeDataMembers»
			«IF cls.hasInheritanceClass»

				if (Tango::Util::instance()->is_svr_shutting_down()==false  &&
					Tango::Util::instance()->is_device_restarting(device_name)==false &&
					Tango::Util::instance()->is_svr_starting()==false)
				{
					//	If not shutting down call delete device for inherited object
					«cls.inheritedClassName»_ns::«cls.inheritedClassName»::delete_device();
				}
			«ENDIF»
		}
	'''
	
	//======================================================
	// Define init_device() method
	//======================================================
	def initDeviceMethod(PogoDeviceClass cls) '''

		«cls.simpleMethodHeader("init_device", "will be called at device initialization.")»
		void «cls.name»::init_device()
		{
			DEBUG_STREAM << "«cls.name»::init_device() create device " << device_name << std::endl;
			«cls.protectedArea("init_device_before", "Initialization before get_device_property() call", true)»

			«IF cls.hasInheritanceClass»
				if (Tango::Util::instance()->is_svr_starting() == false  &&
					Tango::Util::instance()->is_device_restarting(device_name)==false)
				{
					//	If not starting up call init device for inherited object
					«cls.inheritedClassName»_ns::«cls.inheritedClassName»::init_device();
				}
			«ENDIF»
			«IF cls.deviceProperties.size>0 && isTrue(cls.description.hasConcreteProperty)»

				//	Get the device properties from database
				get_device_property();
			«ELSE»
				//	No device property to be read from database
			«ENDIF»

			«cls.attributes.allocateAttributeDataMembers»
			«IF cls.deviceProperties.hasMandatoryProperty»
				//	No longer if mandatory property not set. 
				if (mandatoryNotDefined)
					return;

			«ENDIF»
			«cls.protectedArea("init_device", "Initialize device", true)»
		}

	'''

	//======================================================
	// Define get_device_properies() and always_executed_hook() methods
	//======================================================
	def utilsMethods(PogoDeviceClass cls) '''
		«IF cls.deviceProperties.size>0 && isTrue(cls.description.hasConcreteProperty)»
			«cls.getDevicePropertiesMethod»
			«IF cls.deviceProperties.hasMandatoryProperty»
				«cls.simpleMethodHeader("check_mandatory_property", "For mandatory properties check if defined in database.")»
				void «cls.name»::check_mandatory_property(Tango::DbDatum &class_prop, Tango::DbDatum &dev_prop)
				{
					//	Check if all properties are empty
					if (class_prop.is_empty() && dev_prop.is_empty())
					{
						TangoSys_OMemStream	tms;
						tms << std::endl <<"Property \'" << dev_prop.name;
						if (Tango::Util::instance()->_UseDb==true)
							tms << "\' is mandatory but not defined in database";
						else
							tms << "\' is mandatory but cannot be defined without database";
						append_status(tms.str());
						mandatoryNotDefined = true;
						«cls.protectedArea("check_mandatory_property",
							"std::cerr << tms.str() << \" for \" << device_name << std::endl;", false)»
					}
				}

			«ENDIF»
		«ENDIF»
		
		«cls.simpleMethodHeader("always_executed_hook", "method always executed before any command is executed")»
		void «cls.name»::always_executed_hook()
		{
			DEBUG_STREAM << "«cls.name»::always_executed_hook()  " << device_name << std::endl;
			«IF cls.deviceProperties.hasMandatoryProperty»
				if (mandatoryNotDefined)
				{
					Tango::Except::throw_exception(
								(const char *)"PROPERTY_NOT_SET",
								get_status().c_str(),
								(const char *)"«cls.name»::always_executed_hook()");
				}
			«ENDIF»
			«cls.protectedArea("always_executed_hook", "code always executed before all requests", true)»
		}

	'''

	//======================================================
	// Define pipe related methods
	//======================================================
	def pipeMethods(PogoDeviceClass cls) '''
		«IF cls.pipes.size()>0»
			«FOR Pipe pipe: cls.pipes»
				«cls.readPipeMethod(pipe)»
				«IF pipe.rwType.contains("WRITE")»
					«cls.writePipeMethod(pipe)»
				«ENDIF»
			«ENDFOR»
		«ENDIF»
	'''
	
	//======================================================
	// Define attribute related methods
	//======================================================
	def attributeMethods(PogoDeviceClass cls) '''
		«cls.simpleMethodHeader("read_attr_hardware", "Hardware acquisition for attributes")»
		void «cls.name»::read_attr_hardware(TANGO_UNUSED(std::vector<long> &attr_list))
		{
			DEBUG_STREAM << "«cls.name»::read_attr_hardware(std::vector<long> &attr_list) entering... " << std::endl;
			«cls.protectedArea("read_attr_hardware", "Add your own code", true)»
		}
		«IF cls.hasWritableAttribute»
		«cls.simpleMethodHeader("write_attr_hardware", "Hardware writing for attributes")»
		void «cls.name»::write_attr_hardware(TANGO_UNUSED(std::vector<long> &attr_list))
		{
			DEBUG_STREAM << "«cls.name»::write_attr_hardware(std::vector<long> &attr_list) entering... " << std::endl;
			«cls.protectedArea("write_attr_hardware", "Add your own code", true)»
		}
		«ENDIF»
		
		«FOR Attribute attribute : cls.attributes»
			«IF attribute.isConcreteHere»
				«IF attribute.isRead»
					«attribute.attributeMethodHeader("Read")»
					«cls.readAttributeMethod(attribute)»
				«ENDIF»
				«IF attribute.isWrite»
					«attribute.attributeMethodHeader("Write")»
					«cls.writeAttributeMethod(attribute)»
				«ENDIF»
			«ENDIF»
		«ENDFOR»
		
		«FOR Attribute attribute : cls.dynamicAttributes»
			«IF attribute.isRead»
				«attribute.attributeMethodHeader("Read")»
				«cls.readDynamicAttributeMethod(attribute)»
			«ENDIF»
			«IF attribute.isWrite»
				«attribute.attributeMethodHeader("Write")»
				«cls.writeAttributeMethod(attribute)»
			«ENDIF»
		«ENDFOR»
		«cls.simpleMethodHeader("add_dynamic_attributes", "Create the dynamic attributes if any\nfor specified device.")»
		void «cls.name»::add_dynamic_attributes()
		{
			«IF cls.dynamicAttributes.size>0»
				//	Example to add dynamic attribute:
				//	Copy inside the following protected area to create instance(s) at startup.
				«FOR Attribute attribute : cls.dynamicAttributes»
					//	add_«attribute.name»_dynamic_attribute("My«attribute.name»Attribute");
				«ENDFOR»

			«ENDIF»
			«cls.protectedArea("add_dynamic_attributes", "Add your own code to create and add dynamic attributes if any", true)»
		}
		
	'''
		
	//======================================================
	// Define Command related methods
	//======================================================
	def commandMethods(PogoDeviceClass cls) '''
		«FOR Command command : cls.commands»
			«IF isTrue(command.status.concreteHere)»
				//--------------------------------------------------------
				«command.commandExecutionMethodHeader»
				//--------------------------------------------------------
				«cls.commandExecutionMethod(command)»
			«ENDIF»
		«ENDFOR»
		«IF cls.dynamicCommands.size()>0»
			«FOR Command command : cls.dynamicCommands»
				«IF isTrue(command.status.concreteHere)»
					//--------------------------------------------------------
					«command.commandExecutionMethodHeader»
					//--------------------------------------------------------
					«cls.commandExecutionMethod(command)»
				«ENDIF»
			«ENDFOR»
		«ENDIF»
		«cls.simpleMethodHeader("add_dynamic_commands", "Create the dynamic commands if any\nfor specified device.")»
		void «cls.name»::add_dynamic_commands()
		{
			«IF cls.dynamicCommands.size>0»
				//	Example to add dynamic command:
				//	Copy inside the following protected area to instantiate at startup.
				«FOR Command command : cls.dynamicCommands»
					//	add_«command.name»_dynamic_command("My«command.name»Command", true);
				«ENDFOR»
				
			«ENDIF»
			«cls.protectedArea("add_dynamic_commands", "Add your own code to create and add dynamic commands if any", true)»
		}
	'''
}