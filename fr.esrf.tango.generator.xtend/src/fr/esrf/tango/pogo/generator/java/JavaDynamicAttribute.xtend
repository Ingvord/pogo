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

package fr.esrf.tango.pogo.generator.java

import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import com.google.inject.Inject
import static extension fr.esrf.tango.pogo.generator.common.StringUtils.*
import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.generator.common.Headers

class JavaDynamicAttribute {

	@Inject extension JavaUtils
	@Inject extension Headers
	@Inject extension ProtectedArea

	//======================================================
	// define code to declare attributes class
	//======================================================
	def generateJavaDynamicAttributeClassFile(PogoDeviceClass cls, Attribute attribute) '''
		«cls.header(attribute)»

		/**
		 * Dynamic attribute «attribute.name», «attribute.strJavaType», «attribute.attType», «attribute.rwType»
		 * description:
		 *     «attribute.properties.description.comments("*     ")»
		 */
		public class «attribute.name» implements IAttributeBehavior {

			/**	The attribute name */
			private String  attributeName;

			«cls.protectedArea(attribute.name+"." + "dataMembers", "Put your data member declarations", true)»

			«cls.constructor(attribute)»

			«cls.getConfigurationMethod(attribute)»

			«cls.stateMachineMethod(attribute)»

			«cls.getValueMethod(attribute)»

			«cls.setValueMethod(attribute)»

			«cls.protectedArea(attribute.name+"." + "methods", "Put your own methods", true)»
		}
	'''
	//======================================================
	// define code for file header
	//======================================================
	def header(PogoDeviceClass cls, Attribute attribute) '''
		«cls.openProtectedArea(attribute.name+".java")»
		«(attribute.name+".java").fileHeader(
			"Java source for the dynamic attribute " + attribute.name +".\n" +
			"this attribute belongs to the " + cls.name + " class.",
			cls.description.title,
			cls.description.license,
			cls.description.copyright
		)»

		package «cls.javaDevicePackage»;

		import org.tango.server.StateMachineBehavior;
		import org.tango.server.attribute.IAttributeBehavior;
		import org.tango.server.attribute.AttributeValue;
		import org.tango.server.attribute.AttributeConfiguration;
		import org.tango.server.attribute.AttributePropertiesImpl;

		import fr.esrf.Tango.*;

		«cls.closeProtectedArea(attribute.name+".java")»

	'''

	//======================================================
	// define code for constructor
	//======================================================
	def constructor(PogoDeviceClass cls, Attribute attribute) '''
		/**
		 * Dynamic attribute «attribute.name» constructor
		 * @param attributeName The dynamic attribute name
		 */
		public «attribute.name»(String attributeName) {
			this.attributeName = attributeName;
			«cls.protectedArea(attribute.name+"." + attribute.name)»
		}
	'''


	//======================================================
	// define code for getConfiguration() method
	//======================================================
	def getConfigurationMethod(PogoDeviceClass cls, Attribute attribute) '''
		/**
		 * Build and return the configuration for dynamic attribute «attribute.name».
		 * @return the configuration for dynamic attribute «attribute.name».
		 * @throws DevFailed in case of configuration error.
		 */
		@Override
		public AttributeConfiguration getConfiguration() throws DevFailed {
			AttributeConfiguration  config = new AttributeConfiguration();
			«setDynamicAttributeConfig("Name", "attributeName")»
			«setDynamicAttributeConfig("Type", attribute.strJavaType + ".class")»
			«setDynamicAttributeConfig("Format", attribute.attType.toUpperCase, "AttrDataFormat.")»
			«setDynamicAttributeConfig("Writable", attribute.rwType, "AttrWriteType.")»
			«setDynamicAttributeConfig("DispLevel", attribute.displayLevel, "DispLevel.")»
			«IF attribute.polledPeriod!==null && attribute.polledPeriod!="0"»
				«setDynamicAttributeConfig("Polled", "true")»
				«setDynamicAttributeConfig("PollingPeriod", attribute.polledPeriod)»
			«ENDIF»
			«setDynamicAttributeConfig("Memorized", attribute.memorized)»
			«setDynamicAttributeConfig("MemorizedAtInit", attribute.memorizedAtInit)»

			«attribute.buildSetProperties»
			return config;
		}
	'''
	//======================================================
	// define code to set properties for getConfigurationMethod() method
	//======================================================
	def buildSetProperties(Attribute attribute) '''
		//	Set attribute properties
		AttributePropertiesImpl	properties = new AttributePropertiesImpl();
		«IF attribute.properties!==null»
			«setDynamicAttributePropertyConfig("Description",  attribute.properties.description)»
			«setDynamicAttributePropertyConfig("Label",        attribute.properties.label)»
			«setDynamicAttributePropertyConfig("Unit",         attribute.properties.unit)»
			«setDynamicAttributePropertyConfig("StandardUnit", attribute.properties.standardUnit)»
			«setDynamicAttributePropertyConfig("DisplayUnit",  attribute.properties.displayUnit)»
			«setDynamicAttributePropertyConfig("Format",       attribute.properties.format)»
			«setDynamicAttributePropertyConfig("MaxValue",     attribute.properties.maxValue)»
			«setDynamicAttributePropertyConfig("MinValue",     attribute.properties.minValue)»
			«setDynamicAttributePropertyConfig("MaxAlarm",     attribute.properties.maxAlarm)»
			«setDynamicAttributePropertyConfig("MinAlarm",     attribute.properties.minAlarm)»
			«setDynamicAttributePropertyConfig("MaxWarning",   attribute.properties.maxWarning)»
			«setDynamicAttributePropertyConfig("MinWarning",   attribute.properties.minWarning)»
			«setDynamicAttributePropertyConfig("DeltaT",       attribute.properties.deltaTime)»
			«setDynamicAttributePropertyConfig("DeltaVal",     attribute.properties.deltaValue)»
		«ENDIF»
		«IF attribute.eventCriteria!==null»
			«setDynamicAttributePropertyConfig("EventAbsChange", attribute.eventCriteria.absChange)»
			«setDynamicAttributePropertyConfig("EventRelChange", attribute.eventCriteria.relChange)»
			«setDynamicAttributePropertyConfig("EventPeriod",    attribute.eventCriteria.period)»
		«ENDIF»
		«IF attribute.evArchiveCriteria!==null»
			«setDynamicAttributePropertyConfig("ArchivingEventAbsChange", attribute.evArchiveCriteria.absChange)»
			«setDynamicAttributePropertyConfig("ArchivingEventRelChange", attribute.evArchiveCriteria.relChange)»
			«setDynamicAttributePropertyConfig("ArchivingEventPeriod",    attribute.evArchiveCriteria.period)»
		«ENDIF»
		«setDynamicAttributeConfig("AttributeProperties", "properties")»
	'''

	//======================================================
	// define code for stateMachine() method
	//======================================================
	def stateMachineMethod(PogoDeviceClass cls, Attribute attribute) '''
		/**
		 * Get dynamic attribute state machine
		 * @return the attribute state machine
		 * @throws DevFailed if the state machine computation failed.
		 */
		@Override
		public StateMachineBehavior getStateMachine() throws DevFailed {
			StateMachineBehavior stateMachine = new StateMachineBehavior();
			«attribute.stateMachineForDynamic»
			«cls.protectedArea(attribute.name+"." + "getStateMachine")»
			return stateMachine;
		}
	'''


	//======================================================
	// define code for getValue() method
	//======================================================
	def getValueMethod(PogoDeviceClass cls, Attribute attribute) '''
		/**
		 * Get dynamic attribute value
		 * @return the attribute value
		 * @throws DevFailed if the read value failed.
		 */
		@Override
		public AttributeValue getValue() throws DevFailed {
			«attribute.strFullJavaType»	readValue;
			«cls.protectedArea(attribute.name + "." + "getValue", "readValue = null;", false)»
			return new AttributeValue(readValue);
		}
	'''

	//======================================================
	// define code for setValue() method
	//======================================================
	def setValueMethod(PogoDeviceClass cls, Attribute attribute) '''
		/**
		 * Set dynamic attribute value
		 * @param writeValue the attribute value
		 * @throws DevFailed if the set value failed.
		 */
		@Override
		public void setValue(AttributeValue writeValue) throws DevFailed {
			«cls.protectedArea(attribute.name+"." + "setValue",
				"System.out.println(\"Writing \" + writeValue + \"to hardware\");", false)»
		}
	'''
}