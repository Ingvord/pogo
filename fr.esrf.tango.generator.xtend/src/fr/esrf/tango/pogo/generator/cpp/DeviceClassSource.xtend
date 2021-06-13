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
import fr.esrf.tango.pogo.generator.cpp.utils.ProtectedArea
import fr.esrf.tango.pogo.generator.cpp.utils.Headers
import fr.esrf.tango.pogo.generator.cpp.utils.Attributes
import fr.esrf.tango.pogo.generator.cpp.utils.Commands
import fr.esrf.tango.pogo.generator.cpp.utils.Properties
import fr.esrf.tango.pogo.generator.cpp.utils.InheritanceUtils
import fr.esrf.tango.pogo.pogoDsl.ForwardedAttribute
import fr.esrf.tango.pogo.pogoDsl.Pipe
import fr.esrf.tango.pogo.generator.common.StringUtils;

class DeviceClassSource {

	@Inject	extension ProtectedArea
	@Inject	extension Headers
	@Inject	extension Attributes
	@Inject	extension Commands
	@Inject	extension Properties
	@Inject	extension InheritanceUtils
	@Inject	extension StringUtils

	//======================================================
	// Define deviceClass source file to be generated
	//======================================================
	def generateDeviceClassSourceFile (PogoDeviceClass cls) '''
		«cls.fileHeader»

		namespace «cls.name»_ns
		{
		«cls.constructors»

		//===================================================================
		//	Command execution method calls
		//===================================================================
		«cls.commandRelatedMethods»

		//===================================================================
		//	Properties management
		//===================================================================
		«cls.propertyRelatedMethod»

		//===================================================================
		//	Factory methods
		//===================================================================
		«cls.deviceFactory»
		«cls.attributeFactory»
		«cls.pipeFactory»
		«cls.commandFactory»
		«cls.dynamicAttributeMethods»

		«cls.protectedAreaClass("Additional Methods")»
		} //	namespace
	'''





	//======================================================
	// Define the header file
	//======================================================
	def fileHeader (PogoDeviceClass cls) '''
		«cls.protectedAreaClass(".cpp",
			cls.deviceClassSourceFileHeader+
			"\n\n" +
			"#include <"+cls.name+"Class.h>", false)»

		//-------------------------------------------------------------------
		/**
		 *	Create «cls.name»Class singleton and
		 *	return it in a C function for Python usage
		 */
		//-------------------------------------------------------------------
		extern "C" {
		#ifdef _TG_WINDOWS_
		
		__declspec(dllexport)
		
		#endif
		
			Tango::DeviceClass *_create_«cls.name»_class(const char *name) {
				return «cls.name»_ns::«cls.name»Class::init(name);
			}
		}
	'''


	//==========================================================
	// Define command related methods
	//==========================================================
	def commandRelatedMethods(PogoDeviceClass cls) '''
		«IF cls.commands.size>2»
			«FOR Command command : cls.commands»
				«IF command.isConcreteHere»
					«IF command.name.equals("State")==false && command.name.equals("Status")==false»
						«cls.classExecuteMethod(command)»
					«ENDIF»
				«ENDIF»
			«ENDFOR»
		«ENDIF»
		«FOR Command command : cls.dynamicCommands»
			«cls.classExecuteMethod(command)»
		«ENDFOR»
	'''

	//==========================================================
	// Define pipe factory
	//==========================================================
	def pipeFactory(PogoDeviceClass cls) '''
		«cls.simpleMethodHeaderClass("pipe_factory", "Create the pipe object(s)\nand store them in the pipe list")»
		void «cls.name»Class::pipe_factory()
		{
			«cls.protectedAreaClass("pipe_factory_before", "Add your own code", true)»
			«IF cls.pipes.size>0»
				Tango::UserDefaultPipeProp udpp;
				«FOR Pipe pipe : cls.pipes»
					«pipe.name»Class	*p«pipe.name» = new «pipe.name»Class("«pipe.name»",Tango::«pipe.displayLevel»);
					udpp.set_description("«pipe.description.oneLineString»");
					udpp.set_label("«pipe.label»");
					p«pipe.name»->set_default_properties(udpp);
					pipe_list.push_back(p«pipe.name»);

				«ENDFOR»
			«ENDIF»
			«cls.protectedAreaClass("pipe_factory_after", "Add your own code", true)»
		}
	'''
	
	//==========================================================
	// Define attribute factory
	//==========================================================
	def attributeFactory(PogoDeviceClass cls) '''
		«cls.simpleMethodHeaderClass("attribute_factory", "Create the attribute object(s)\nand store them in the attribute list")»
		void «cls.name»Class::attribute_factory(std::vector<Tango::Attr *> &att_list)
		{
			«cls.protectedAreaClass("attribute_factory_before", "Add your own code", true)»
			«IF cls.hasInheritanceClass»
				//	Call atribute_factory for inherited class
				«cls.inheritedClassNameForDeviceClass»::attribute_factory(att_list);

			«ENDIF»
			«FOR Attribute attribute : cls.attributes»
				«IF attribute.inherited»
					//	Attribute : «attribute.name» - Check if not concrete in inherited class
					Tango::Attr *«attribute.name»Attr = get_attr_object_by_name(att_list, "«attribute.name»");
					if («attribute.name»Attr == NULL)
					{
						«attribute.attributeFactory»
					}
				«ELSE»
					«attribute.attributeFactory»
				«ENDIF»

			«ENDFOR»
			«FOR ForwardedAttribute attribute : cls.forwardedAttributes»
				«attribute.forwardedAttributeFactory»
			«ENDFOR»

			«IF cls.concreteClass»
				//	Create a list of static attributes
				create_static_attribute_list(get_class_attr()->get_attr_list());
			«ENDIF»
			«cls.protectedAreaClass("attribute_factory_after", "Add your own code", true)»
		}
	'''
	//==========================================================
	//==========================================================
	def forwardedAttributeFactory(ForwardedAttribute attribute) '''
		
		//	Forwarded attribute «attribute.name»
		«attribute.name»Attrib *«attribute.name.toLowerCase» = new «attribute.name»Attrib("«attribute.name»");
		Tango::UserDefaultFwdAttrProp  «attribute.name.toLowerCase»_prop;
		«attribute.name.toLowerCase»_prop.set_label("«attribute.label»");
		«attribute.name.toLowerCase»->set_default_properties(«attribute.name.toLowerCase»_prop);
		att_list.push_back(«attribute.name.toLowerCase»);
	'''
	
	//==========================================================
	// Define command factory
	//==========================================================
	def commandFactory(PogoDeviceClass cls) '''
		«cls.simpleMethodHeaderClass("command_factory", "Create the command object(s)\nand store them in the command list")»
		void «cls.name»Class::command_factory()
		{
			«cls.protectedAreaClass("command_factory_before", "Add your own code", true)»
			«IF cls.hasInheritanceClass»
				//	Call command_factory for inherited class
				«cls.inheritedClassNameForDeviceClass»::command_factory();

			«ENDIF»
			«FOR Command command : cls.commands»
				«IF command.isConcreteHere &&
					command.name.equals("State")==false && command.name.equals("Status")==false»
					«IF command.inherited»
						//	Get inherited Command object «command.name» if already created
						try
						{
							get_cmd_by_name("«command.name»");
						}
						catch (Tango::DevFailed &e)
						{
							//	Create «command.name» command object
							«command.commandFactory»
						}
					«ELSE»
						//	Command «command.name»
						«command.commandFactory»
					«ENDIF»
				«ENDIF»

				«IF command.name.equals("State") || command.name.equals("Status")»
					«command.checkStateStatusPolling»
				«ENDIF»
			«ENDFOR»
			«cls.protectedAreaClass("command_factory_after", "Add your own code", true)»
		}
	'''

	//==========================================================
	// Define device factory
	//==========================================================
	def deviceFactory(PogoDeviceClass cls) '''

		«cls.simpleMethodHeaderClass("device_factory","Create the device object(s)\nand store them in the device list")»
		void «cls.name»Class::device_factory(const Tango::DevVarStringArray *devlist_ptr)
		{
		«IF cls.name.toLowerCase.equals("database")»
			device_list.push_back(new DataBase(this, DataBase::db_name.c_str(),
												"TANGO database device server"));
			export_device(device_list[0],"database");
		«ELSE»
			«IF cls.isConcreteClass»
				«cls.protectedAreaClass("device_factory_before", "Add your own code", true)»
			
				//	Create devices and add it into the device list
				for (unsigned long i=0 ; i<devlist_ptr->length() ; i++)
				{
					cout4 << "Device name : " << (*devlist_ptr)[i].in() << std::endl;
					device_list.push_back(new «cls.name»(this, (*devlist_ptr)[i]));
				}
			
				//	Manage dynamic attributes if any
				erase_dynamic_attributes(devlist_ptr, get_class_attr()->get_attr_list());
			
				//	Export devices to the outside world
				for (unsigned long i=1 ; i<=devlist_ptr->length() ; i++)
				{
					//	Add dynamic attributes if any
					«cls.name» *dev = static_cast<«cls.name» *>(device_list[device_list.size()-i]);
					dev->add_dynamic_attributes();
					«IF cls.dynamicCommands.size>0»
						dev->add_dynamic_commands();
					«ENDIF»
			
					//	Check before if database used.
					if ((Tango::Util::_UseDb == true) && (Tango::Util::_FileDb == false))
						export_device(dev);
					else
						export_device(dev, dev->get_name().c_str());
				}
			
				«cls.protectedAreaClass("device_factory_after", "Add your own code", true)»
			«ELSE»
				//	This class is not concrete and cannot implement devices
			«ENDIF»
		«ENDIF»
		}
	'''



	//==========================================================
	// Define dynamic attribuites relatedMthods
	//==========================================================
	def dynamicAttributeMethods(PogoDeviceClass cls) '''

		«IF cls.concreteClass»
			//===================================================================
			//	Dynamic attributes related methods
			//===================================================================
			
			//--------------------------------------------------------
			/**
			 * method : 		«cls.name»Class::create_static_attribute_list
			 * description : 	Create the a list of static attributes
			 *
			 * @param	att_list	the ceated attribute list
			 */
			//--------------------------------------------------------
			void «cls.name»Class::create_static_attribute_list(std::vector<Tango::Attr *> &att_list)
			{
				for (unsigned long i=0 ; i<att_list.size() ; i++)
				{
					std::string att_name(att_list[i]->get_name());
					transform(att_name.begin(), att_name.end(), att_name.begin(), ::tolower);
					defaultAttList.push_back(att_name);
				}
			
				cout2 << defaultAttList.size() << " attributes in default list" << std::endl;
			
				«cls.protectedAreaClass("create_static_att_list")»
			}
			
			
			//--------------------------------------------------------
			/**
			 * method : 		«cls.name»Class::erase_dynamic_attributes
			 * description : 	delete the dynamic attributes if any.
			 *
			 * @param	devlist_ptr	the device list pointer
			 * @param	list of all attributes
			 */
			//--------------------------------------------------------
			void «cls.name»Class::erase_dynamic_attributes(const Tango::DevVarStringArray *devlist_ptr, std::vector<Tango::Attr *> &att_list)
			{
				Tango::Util *tg = Tango::Util::instance();
			
				for (unsigned long i=0 ; i<devlist_ptr->length() ; i++)
				{
					Tango::DeviceImpl *dev_impl = tg->get_device_by_name(((std::string)(*devlist_ptr)[i]).c_str());
					«cls.name» *dev = static_cast<«cls.name» *> (dev_impl);
			
					std::vector<Tango::Attribute *> &dev_att_list = dev->get_device_attr()->get_attribute_list();
					std::vector<Tango::Attribute *>::iterator ite_att;
					for (ite_att=dev_att_list.begin() ; ite_att != dev_att_list.end() ; ++ite_att)
					{
						std::string att_name((*ite_att)->get_name_lower());
						if ((att_name == "state") || (att_name == "status"))
							continue;
						std::vector<std::string>::iterator ite_str = find(defaultAttList.begin(), defaultAttList.end(), att_name);
						if (ite_str == defaultAttList.end())
						{
							cout2 << att_name << " is a UNWANTED dynamic attribute for device " << (*devlist_ptr)[i] << std::endl;
							Tango::Attribute &att = dev->get_device_attr()->get_attr_by_name(att_name.c_str());
							dev->remove_attribute(att_list[att.get_attr_idx()], true, false);
							--ite_att;
						}
					}
				}
				«cls.protectedAreaClass("erase_dynamic_attributes")»
			}

			«cls.simpleMethodHeaderClass("get_attr_object_by_name", "returns Tango::Attr * object found by name")»
			Tango::Attr *«cls.name»Class::get_attr_object_by_name(std::vector<Tango::Attr *> &att_list, std::string attname)
			{
				std::vector<Tango::Attr *>::iterator it;
				for (it=att_list.begin() ; it<att_list.end() ; ++it)
					if ((*it)->get_name()==attname)
						return (*it);
				//	Attr does not exist
				return NULL;
			}

		«ENDIF»
	'''


	//==========================================================
	// Define singleton constructor, get_intance and init methods
	//==========================================================
	def constructors(PogoDeviceClass cls) '''
		//===================================================================
		//	Initialize pointer for singleton pattern
		//===================================================================
		«cls.name»Class *«cls.name»Class::_instance = NULL;
		//===================================================================
		//	Class constants
		//===================================================================
		«FOR Attribute attribute : cls.attributes»
			«attribute.readAttributesConstants»
		«ENDFOR»
		//--------------------------------------------------------
		/**
		 * method : 		«cls.name»Class::«cls.name»Class(std::string &s)
		 * description : 	constructor for the «cls.name»Class
		 *
		 * @param s	The class name
		 */
		//--------------------------------------------------------
		«cls.name»Class::«cls.name»Class(std::string &s):«cls.inheritedClassNameForDeviceClass»(s)
		{
			cout2 << "Entering «cls.name»Class constructor" << std::endl;
			set_default_property();
			«IF cls.classProperties.size>0»
				get_class_property();
			«ENDIF»
			write_class_property();
		
			«cls.protectedAreaClass("constructor")»
		
			cout2 << "Leaving «cls.name»Class constructor" << std::endl;
		}

		//--------------------------------------------------------
		/**
		 * method : 		«cls.name»Class::~«cls.name»Class()
		 * description : 	destructor for the «cls.name»Class
		 */
		//--------------------------------------------------------
		«cls.name»Class::~«cls.name»Class()
		{
			«cls.protectedAreaClass("destructor")»

			_instance = NULL;
		}
		
		
		//--------------------------------------------------------
		/**
		 * method : 		«cls.name»Class::init
		 * description : 	Create the object if not already done.
		 *                  Otherwise, just return a pointer to the object
		 *
		 * @param	name	The class name
		 */
		//--------------------------------------------------------
		«cls.name»Class *«cls.name»Class::init(const char *name)
		{
			if (_instance == NULL)
			{
				try
				{
					std::string s(name);
					_instance = new «cls.name»Class(s);
				}
				catch (std::bad_alloc &)
				{
					throw;
				}
			}
			return _instance;
		}
		
		//--------------------------------------------------------
		/**
		 * method : 		«cls.name»Class::instance
		 * description : 	Check if object already created,
		 *                  and return a pointer to the object
		 */
		//--------------------------------------------------------
		«cls.name»Class *«cls.name»Class::instance()
		{
			if (_instance == NULL)
			{
				std::cerr << "Class is not initialised !!" << std::endl;
				exit(-1);
			}
			return _instance;
		}


	'''
}