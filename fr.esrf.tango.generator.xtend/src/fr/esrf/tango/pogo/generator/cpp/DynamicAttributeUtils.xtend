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
import fr.esrf.tango.pogo.generator.cpp.utils.ProtectedArea
import fr.esrf.tango.pogo.generator.cpp.utils.Headers
import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.generator.cpp.utils.Attributes
import fr.esrf.tango.pogo.generator.cpp.utils.Commands
import fr.esrf.tango.pogo.pogoDsl.Command


//======================================================
// Define DynamicAttributeUtils.cpp file to be generated
//======================================================
class DynamicAttributeUtils {
	@Inject	extension ProtectedArea
	@Inject	extension Headers
	@Inject	extension fr.esrf.tango.pogo.generator.cpp.utils.CppStringUtils
	@Inject	extension Attributes
	@Inject	extension Commands

	//======================================================
	// Define DynamicAttributeUtils.cpp file to be generated
	//======================================================
	def generateDynamicAttrUtilsFile (PogoDeviceClass cls) '''
		«cls.fileHeader»

		«cls.dynamicAttributes.attributesTable»
		
		//	For compatibility reason, this file («cls.name»DynAttrUtils)
		//	manage also the dynamic command utilities.
		«cls.dynamicCommands.commandsTable»
		
		namespace «cls.name»_ns
		{
		«cls.addAndRemoveAttributeMethods»


		//============================================================
		//	Tool methods to get pointer on attribute data buffer
		//============================================================
		«FOR Attribute attribute : cls.dynamicAttributes»
			«cls.dynamicAttributeTools(attribute)»
		«ENDFOR»


		«cls.addAndRemoveCommandMethods»

		} //	namespace
	'''

	//======================================================
	// define the header file
	//======================================================
	def fileHeader (PogoDeviceClass cls) '''
		«cls.protectedArea("DynAttrUtils.cpp",
			cls.dynamicAttrUtilsFileHeader+
			"\n\n" +
			"#include <"+cls.name+".h>\n"+
			"#include <"+cls.name+"Class.h>", false)»
	'''


	//======================================================
	// define the add/remove attribute methods
	//======================================================
	def addAndRemoveAttributeMethods(PogoDeviceClass cls) '''
		//=============================================================
		//	Add/Remove dynamic attribute methods
		//=============================================================
		
		«FOR Attribute attribute : cls.dynamicAttributes»
			«cls.addDynamicAttribute(attribute)»
			«cls.removeDynamicAttribute(attribute)»
		«ENDFOR»
	'''

	//======================================================
	// define the add dynamic attribute method
	//======================================================
	def addDynamicAttribute(PogoDeviceClass cls, Attribute attribute) '''
		//--------------------------------------------------------
		/**
		 *	Add a «attribute.name» dynamic attribute.
		 *
		«attribute.addDynamicAttributeHeaderComment»
		 */
		//--------------------------------------------------------
		«cls.addDynamicAttributeSignature(attribute, false)»
		{
			«attribute.attributeFactory(cls)»
		}
	'''

	//======================================================
	// define the remove dynamic attribute method
	//======================================================
	def removeDynamicAttribute(PogoDeviceClass cls, Attribute attribute) '''
		//--------------------------------------------------------
		/**
		 *	remove a «attribute.name» dynamic attribute.
		 *
		«attribute.removeDynamicAttributeHeaderComment»
		 */
		//--------------------------------------------------------
		«cls.removeDynamicAttributeSignature(attribute, false)»
		{
			remove_attribute(attname, true, Tango::Util::instance()->_UseDb);
			«IF attribute.isScalar»
			    map<std::string,«attribute.strType»>::iterator ite;
			«ELSE»
			    map<std::string,«attribute.strType» *>::iterator ite;
			«ENDIF»
			if ((ite=«attribute.name»_data.find(attname))!=«attribute.name»_data.end())
			{
				«cls.protectedArea("remove_" + attribute.name + "_dynamic_attribute", "Add your own code", true)»
				«IF attribute.attType.equals("Scalar")==false»
					if (free_it)
						delete[] ite->second;
				«ENDIF»
				«attribute.name»_data.erase(ite);
			}
		}
	'''

	//======================================================
	// define the tools for dynamic attribute
	//======================================================
	def dynamicAttributeTools(PogoDeviceClass cls, Attribute attribute) '''
		//--------------------------------------------------------
		/**
		 *	Return a pointer on «attribute.name» data.
		 *
		 *  parameter attname: the specified attribute name.
		 */
		//--------------------------------------------------------
		«attribute.strType» *«cls.name»::get_«attribute.name»_data_ptr(std::string &name)
		{
			«IF attribute.isScalar»
				map<std::string,«attribute.strType»>::iterator ite;
			«ELSE»
				map<std::string,«attribute.strType» *>::iterator ite;
			«ENDIF»
			if ((ite=«attribute.name»_data.find(name))==«attribute.name»_data.end())
			{
				TangoSys_OMemStream	tms;
				tms << "Dynamic attribute " << name << " has not been created";
				Tango::Except::throw_exception(
							(const char *)"ATTRIBUTE_NOT_FOUND",
							tms.str().c_str(),
							(const char *)"«cls.name»::get_«attribute.name»_data_ptr()");
			}
			«IF attribute.isScalar»
				return  &(ite->second);
			«ELSE»
				return  ite->second;
			«ENDIF»
		}
	'''


	//======================================================
	// define the add/remove command methods
	//======================================================
	def addAndRemoveCommandMethods(PogoDeviceClass cls) '''
		//=============================================================
		//	Add/Remove dynamic command methods
		//=============================================================
		
		«FOR Command command : cls.dynamicCommands»
			«cls.addDynamicCommand(command)»
			«cls.removeDynamicCommand(command)»
		«ENDFOR»
	'''

	//======================================================
	// define the add dynamic command method
	//======================================================
	def addDynamicCommand(PogoDeviceClass cls, Command command) '''
		//--------------------------------------------------------
		/**
		 *	Add a «command.name» dynamic command.
		 *
		«command.addDynamicCommandHeaderComment»
		 */
		//--------------------------------------------------------
		«cls.addDynamicCommandSignature(command, false)»
		{
			«command.dynamicCommandFactory»
		}
	'''

	//======================================================
	// define the remove dynamic attribute method
	//======================================================
	def removeDynamicCommand(PogoDeviceClass cls, Command command) '''
		//--------------------------------------------------------
		/**
		 *	remove a «command.name» dynamic command.
		 *
		«command.removeDynamicCommandHeaderComment»
		 */
		//--------------------------------------------------------
		«cls.removeDynamicCommandSignature(command, false)»
		{
			remove_command(cmdname, true);
		}
	'''



}