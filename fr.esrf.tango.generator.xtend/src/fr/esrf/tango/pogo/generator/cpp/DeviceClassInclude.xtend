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
import fr.esrf.tango.pogo.generator.cpp.utils.Properties
import fr.esrf.tango.pogo.generator.cpp.utils.Attributes
import fr.esrf.tango.pogo.generator.cpp.utils.Pipes
import fr.esrf.tango.pogo.generator.cpp.utils.Commands
import fr.esrf.tango.pogo.generator.cpp.utils.Headers
import fr.esrf.tango.pogo.generator.cpp.utils.InheritanceUtils
import fr.esrf.tango.pogo.pogoDsl.ForwardedAttribute
import fr.esrf.tango.pogo.pogoDsl.Pipe

//======================================================
//	Define deviceClass include file to be generated
//======================================================
class DeviceClassInclude {

	@Inject	extension ProtectedArea
	@Inject	extension Headers
	@Inject	extension Commands
	@Inject	extension Attributes
	@Inject	extension Pipes
	@Inject	extension Properties
	@Inject	extension InheritanceUtils
	
	//======================================================
	// Define device include file to be generated
	//======================================================
	def generateDeviceClassIncludeFile (PogoDeviceClass cls) '''
		«cls.fileHeader»
		
		
		namespace «cls.name»_ns
		{
		«cls.protectedAreaClass("classes for dynamic creation", "", false)»
		«IF cls.attributes.size>0»
			
			//=========================================
			//	Define classes for attributes
			//=========================================
			«cls.attributeClasses»
		«ENDIF»
		«IF cls.dynamicAttributes.size>0»

			//=========================================
			//	Define classes for dynamic attributes
			//=========================================
			«cls.dynamicAttributeClasses»
		«ENDIF»
		«IF cls.forwardedAttributes.size>0»

			//=========================================
			//	Define classes for forwarded attributes
			//=========================================
			«cls.forwardedAttributeClasses»
		«ENDIF»
		«IF cls.pipes.size>0»

			//=========================================
			//	Define classes for pipes
			//=========================================
			«cls.pipeClasses»
		«ENDIF»
		«IF cls.commands.size>2»
			
			//=========================================
			//	Define classes for commands
			//=========================================
			«cls.commandClasses»
		«ENDIF»
		«IF cls.dynamicCommands.size>0»
			
			//=========================================
			//	Define classes for dynamic commands
			//=========================================
			«cls.dynamicCommandClasses»
		«ENDIF»

		/**
		 *	The «cls.name»Class singleton definition
		 */
		
		#ifdef _TG_WINDOWS_
		class __declspec(dllexport)  «cls.name»Class : public «cls.inheritedClassNameForDeviceClass»
		#else
		class «cls.name»Class : public «cls.inheritedClassNameForDeviceClass»
		#endif
		{
			«cls.protectedAreaClass("Additional DServer data members", "Add your own code", true)»

			«cls.classPropertyDeclarations»

				«cls.publicMethodPrototypes»

				«cls.protectedMethodPrototypes»

				«cls.privateMethodPrototypes»
		};
		
		}	//	End of namespace
		
		#endif   //	«cls.name»_H
	'''

	//======================================================
	// define the header file
	//======================================================
	def fileHeader (PogoDeviceClass cls) '''
		«cls.protectedAreaClass(".h",
			cls.deviceClassIncludeFileHeader+
			"\n\n" +
			"#ifndef " + cls.name + "Class_H\n"+
			"#define " + cls.name + "Class_H\n\n"+
			"#include <tango.h>\n"+
			cls.inheritanceIncludeList(true) +
			"#include <" + cls.name + ".h>\n",
			 false)»
	'''
	
	//======================================================
	//	Define attribute Classes 
	//======================================================
	def attributeClasses(PogoDeviceClass cls) '''
		«FOR Attribute attribute : cls.attributes»
			«IF attribute.isConcreteHere»
				«cls.attributeClass(attribute, false)»
			«ENDIF»
		«ENDFOR»
	'''
	
	//======================================================
	//	Define dynamic attribute Classes 
	//======================================================
	def dynamicAttributeClasses(PogoDeviceClass cls) '''
		«FOR Attribute attribute : cls.dynamicAttributes»
			«cls.attributeClass(attribute, true)»
		«ENDFOR»
	'''
	
	//======================================================
	//	Define dynamic attribute Classes 
	//======================================================
	def forwardedAttributeClasses(PogoDeviceClass cls) '''
		«FOR ForwardedAttribute attribute : cls.forwardedAttributes»
			«attribute.forwardedAttributeClass()»
		«ENDFOR»
	'''
	
	//======================================================
	//	Define pipe Classes 
	//======================================================
	def pipeClasses(PogoDeviceClass cls) '''
		«FOR Pipe pipe : cls.pipes»
			«pipe.pipeClass(cls.getName)»
		«ENDFOR»
	'''
	
	//======================================================
	//	Define command Classes 
	//======================================================
	def commandClasses(PogoDeviceClass cls) '''
		«FOR Command command : cls.commands»
			«IF command.concreteHere»
				«IF command.name.equals("State")==false && command.name.equals("Status")==false»
					«cls.commandClass(command)»
				«ENDIF»
			«ENDIF»
		«ENDFOR»
	'''
	
	
	//======================================================
	//	Define command Classes 
	//======================================================
	def dynamicCommandClasses(PogoDeviceClass cls) '''
		«FOR Command command : cls.dynamicCommands»
			«cls.commandClass(command)»
		«ENDFOR»
	'''
	
	
	//======================================================
	// Define public methods prototypes
	//======================================================
	def publicMethodPrototypes(PogoDeviceClass cls) '''
			//	Method prototypes
			static «cls.name»Class *init(const char *);
			static «cls.name»Class *instance();
			~«cls.name»Class();
			Tango::DbDatum	get_class_property(std::string &);
			Tango::DbDatum	get_default_device_property(std::string &);
			Tango::DbDatum	get_default_class_property(std::string &);
	'''
	
	//======================================================
	// Define protected methods prototypes
	//======================================================
	def protectedMethodPrototypes(PogoDeviceClass cls) '''
			protected:
				«cls.name»Class(std::string &);
				static «cls.name»Class *_instance;
				void command_factory();
				void attribute_factory(std::vector<Tango::Attr *> &);
				void pipe_factory();
				void write_class_property();
				void set_default_property();
				void get_class_property();
				std::string get_cvstag();
				std::string get_cvsroot();
	'''
	
	//======================================================
	// Define private methods prototypes
	//======================================================
	def privateMethodPrototypes(PogoDeviceClass cls) '''
		private:
			void device_factory(const Tango::DevVarStringArray *);
			«IF cls.concreteClass»
				void create_static_attribute_list(std::vector<Tango::Attr *> &);
				void erase_dynamic_attributes(const Tango::DevVarStringArray *,std::vector<Tango::Attr *> &);
				std::vector<std::string>	defaultAttList;
				Tango::Attr *get_attr_object_by_name(std::vector<Tango::Attr *> &att_list, std::string attname);
			«ENDIF»
	'''
}