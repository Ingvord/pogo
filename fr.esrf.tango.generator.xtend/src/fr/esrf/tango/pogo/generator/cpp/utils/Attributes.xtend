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

import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import com.google.inject.Inject
import static extension fr.esrf.tango.pogo.generator.cpp.utils.CppStringUtils.*
import static extension fr.esrf.tango.pogo.generator.cpp.utils.CppTypeDefinitions.*
import org.eclipse.emf.common.util.EList
import fr.esrf.tango.pogo.pogoDsl.ForwardedAttribute

//======================================================
//	Attribute utilities
//======================================================
class Attributes {
	@Inject	extension ProtectedArea
	@Inject	extension fr.esrf.tango.pogo.generator.cpp.utils.CppStringUtils
	@Inject	extension fr.esrf.tango.pogo.generator.cpp.utils.CppTypeDefinitions
	@Inject	extension InheritanceUtils

	//======================================================
	//	General methods
	//======================================================
	def writeAttrubuteMethod(Attribute attribute) {
		"write_" + attribute.name
	}
	//======================================================
	def readAttrubuteMethod(Attribute attribute) {
		"read_" + attribute.name
	}
	//======================================================
	def readAttributesConstants(Attribute attribute) {
		if (attribute.scalar) {
			""
		}
		else
		if (attribute.spectrum) {
			"constexpr static long" + attribute.name + "Attrib::X_DATA_SIZE;"
		}
		else
		if (attribute.image) {
			"constexpr static long" + attribute.name + "Attrib::X_DATA_SIZE;\n" +
			"constexpr static long" + attribute.name + "Attrib::Y_DATA_SIZE;"
		}
	}
	//======================================================
	def readAttrubuteSize(Attribute attribute) {
		if (attribute.scalar) {
			""
		}
		else
		if (attribute.spectrum) {
			", " + attribute.name + "Attrib::X_DATA_SIZE"
		}
		else
		if (attribute.image) {
			", " + attribute.name +"Attrib::X_DATA_SIZE, " + attribute.name + "Attrib::Y_DATA_SIZE"
		}
	}
	//======================================================
	def readAttrubuteSizeForAllocation(Attribute attribute) {
		if (attribute.scalar) {
			"[1]"
		}
		else
		if (attribute.spectrum) {
			"[" + attribute.maxX + "]"
		}
		else
		if (attribute.image) {
			"[" + attribute.maxX +"*" + attribute.maxY + "]"
		}
	}
	//======================================================
	def readAttrubuteDataMember(Attribute attribute) {
		 "attr_" + attribute.name + "_read"
	}
	
	//======================================================
	//	Delete attribute data member
	//======================================================
	def deleteAttributeDataMember(Attribute attribute) {
		"delete[] " +  attribute.readAttrubuteDataMember + ";"
	}
	//======================================================
	//	Delete attribute data members
	//======================================================
	def deleteAttributeDataMembers(EList<Attribute> attributes) '''
		«FOR Attribute attribute : attributes»
			«IF attribute.isConcreteHere»
				«IF isTrue(attribute.allocReadMember)»
					«attribute.deleteAttributeDataMember»
				«ENDIF»
			«ENDIF»
		«ENDFOR»
	'''

	//======================================================
	//	Allocate attribute data member
	//======================================================
	def allocateAttributeDataMember(Attribute attribute) {
		if (attribute.dataType.cppType.contains("Enum"))
			attribute.readAttrubuteDataMember + " = new " + 
					attribute.name + "Enum" + attribute.readAttrubuteSizeForAllocation + ";"
		else
			attribute.readAttrubuteDataMember + " = new " + 
					attribute.dataType.cppType + attribute.readAttrubuteSizeForAllocation + ";"
	}
	//======================================================
	//	Allocate attribute data members
	//======================================================
	def allocateAttributeDataMembers(EList<Attribute> attributes) '''

		«FOR Attribute attribute : attributes»
			«IF attribute.isConcreteHere»
				«IF attribute.allocReadMember.isTrue»
					«attribute.allocateAttributeDataMember»
				«ENDIF»
			«ENDIF»
		«ENDFOR»
	'''

	//======================================================
	// Define read attribute related method
	//======================================================
	def readAttributeMethod(PogoDeviceClass cls, Attribute attribute) '''
		void «cls.name»::«attribute.readAttrubuteMethod»(Tango::Attribute &attr)
		{
			DEBUG_STREAM << "«cls.name»::«attribute.readAttrubuteMethod»(Tango::Attribute &attr) entering... " << std::endl;
			«cls.protectedArea(attribute.readAttrubuteMethod,
				"//	Set the attribute value\n" +
				"attr.set_value("+attribute.readAttrubuteDataMember+
					attribute.readAttrubuteSize + ");", false)»
		}
	'''
	
	//======================================================
	// Define read dynamic attribute related method
	//======================================================
	def readDynamicAttributeMethod(PogoDeviceClass cls, Attribute attribute) '''
		void «cls.name»::«attribute.readAttrubuteMethod»(Tango::Attribute &attr)
		{
			DEBUG_STREAM << "«cls.name»::«attribute.readAttrubuteMethod»(Tango::Attribute &attr) entering... " << std::endl;
			«attribute.strType»	*att_value = get_«attribute.name»_data_ptr(attr.get_name());
			«cls.protectedArea(attribute.readAttrubuteMethod,
				"//	Set the attribute value\n" +
				"attr.set_value(att_value" + attribute.readAttrubuteSize + ");", false)»
		}
	'''
	
	//======================================================
	// Define write attribute related method
	//======================================================
	def writeAttributeMethod(PogoDeviceClass cls, Attribute attribute) '''
		void «cls.name»::«attribute.writeAttrubuteMethod»(Tango::WAttribute &attr)
		{
			DEBUG_STREAM << "«cls.name»::«attribute.writeAttrubuteMethod»(Tango::WAttribute &attr) entering... " << std::endl;
			«IF attribute.isScalar»
				//	Retrieve write value
				«IF attribute.dataType.cppType.contains("Enum")»
					«attribute.name»Enum	w_val;
				«ELSE»
					«attribute.strType»	w_val;
				«ENDIF»
			«ELSE»
				//	Retrieve number of write values
				int	w_length = attr.get_write_value_length();

				//	Retrieve pointer on write values (Do not delete !)
				«IF attribute.strType.contains("String")»
					const Tango::ConstDevString	*w_val;
				«ELSE»
					«IF attribute.dataType.cppType.contains("Enum")»
						const short *w_val;
					«ELSE»
						const «attribute.strType»	*w_val;
					«ENDIF»
				«ENDIF»
			«ENDIF»
			attr.get_write_value(w_val);
			«IF attribute.isScalar==false && attribute.dataType.cppType.contains("Enum")»
				«attribute.name»Enum enum_val[w_length];
				for (int i=0 ; i<w_length ; i++)  enum_val[i]=(«attribute.name»Enum) w_val[i];
			«ENDIF»
			«cls.protectedArea(attribute.writeAttrubuteMethod, "", false)»
		}
	'''

	//======================================================
	// Define constants for attributes
	//======================================================
	def attributeConstant(Attribute attribute) '''
		«IF attribute.isSpectrum»
			// Constants for «attribute.name» attribute
			constexpr static long X_DATA_SIZE = «attribute.maxX»;
		«ELSEIF attribute.isImage»
			// Constants for «attribute.name» attribute
			constexpr static long X_DATA_SIZE = «attribute.maxX»;
			constexpr static long Y_DATA_SIZE = «attribute.maxY»;
		«ENDIF»
	'''

	//======================================================
	// Define attribute classes
	//======================================================
	def attributeClass(PogoDeviceClass cls, Attribute attribute, boolean dynamic) '''
		//	Attribute «attribute.name» class definition
		class «attribute.name»Attrib: public Tango::«attribute.inheritance»
		{
		public:
			«attribute.attributeConstant»
			«attribute.Constructor(dynamic)»
			~«attribute.name»Attrib() {};
			«IF attribute.isRead»
				virtual void read(Tango::DeviceImpl *dev,Tango::Attribute &att)
					{(static_cast<«cls.name» *>(dev))->read_«attribute.name»(att);}
			«ENDIF»
			«IF attribute.isWrite»
				virtual void write(Tango::DeviceImpl *dev,Tango::WAttribute &att)
					{(static_cast<«cls.name» *>(dev))->write_«attribute.name»(att);}
			«ENDIF»
			virtual bool is_allowed(Tango::DeviceImpl *dev,Tango::AttReqType ty)
				{return (static_cast<«cls.name» *>(dev))->is_«attribute.name»_allowed(ty);}
			«IF attribute.dataType.cppType.toString().contains("Enum")»
				virtual bool same_type(const type_info &in_type) {return typeid(«attribute.name»Enum) == in_type;}
				virtual std::string get_enum_type() {return std::string("«attribute.name»Enum");}
			«ENDIF»
		};
		
	'''

	//======================================================
	// Define forwarded attribute classes
	//======================================================
	def forwardedAttributeClass(ForwardedAttribute attribute) '''
		//	Forwarded Attribute «attribute.name» class definition
		class «attribute.name»Attrib: public Tango::FwdAttr
		{
		public:
			«attribute.name»Attrib(const std::string &_n):FwdAttr(_n) {};
			~«attribute.name»Attrib() {};
		};
		
	'''

	//======================================================
	// Define attribute class inheritance
	//======================================================
	def inheritance(Attribute attribute) {
		if (attribute.isScalar)
			"Attr"
		else
		if (attribute.isSpectrum)
			"SpectrumAttr"
		else
		if (attribute.isImage)
			"ImageAttr"
	}
	//======================================================
	// Define attribute Constructor
	//======================================================
	def Constructor(Attribute attribute, boolean dynamic) '''
		«IF dynamic»
			«IF attribute.isScalar»
				«attribute.name»Attrib(const std::string &att_name):«attribute.inheritance»(att_name.c_str(),
						«attribute.dataType.cppTypeEnum», Tango::«attribute.rwType») {};
			«ELSEIF attribute.isSpectrum»
				«attribute.name»Attrib(const std::string &att_name):«attribute.inheritance»(att_name.c_str(),
						«attribute.dataType.cppTypeEnum», Tango::«attribute.rwType», «attribute.name»Attrib::X_DATA_SIZE) {};
			«ELSE»
				«attribute.name»Attrib(const std::string &att_name):«attribute.inheritance»(att_name.c_str(),
						«attribute.dataType.cppTypeEnum», Tango::«attribute.rwType», «attribute.name»Attrib::X_DATA_SIZE, «attribute.name»Attrib::Y_DATA_SIZE) {};
			«ENDIF»
		«ELSE»
			«IF attribute.isScalar»
				«attribute.name»Attrib():«attribute.inheritance»("«attribute.name»",
						«attribute.dataType.cppTypeEnum», Tango::«attribute.rwType»«attribute.readWithWrite») {};
			«ELSEIF attribute.isSpectrum»
				«attribute.name»Attrib():«attribute.inheritance»("«attribute.name»",
						«attribute.dataType.cppTypeEnum», Tango::«attribute.rwType», «attribute.name»Attrib::X_DATA_SIZE) {};
			«ELSE»
				«attribute.name»Attrib():«attribute.inheritance»("«attribute.name»",
						«attribute.dataType.cppTypeEnum», Tango::«attribute.rwType», «attribute.name»Attrib::X_DATA_SIZE, «attribute.name»Attrib::Y_DATA_SIZE) {};
			«ENDIF»
		«ENDIF»
	'''
	
	//======================================================
	// Define attribute Constructor
	//	If cls not null -> dynamic attribute
	//======================================================
	def attributeFactory(Attribute attribute) '''
		«IF attribute.concreteHere»
			«attribute.attributeFactory(null)»
		«ENDIF»
	'''
		
	def attributeFactory(Attribute attribute, PogoDeviceClass cls) '''
		//	Attribute : «attribute.name»
		«IF cls!==null»
			«attribute.allocateDynamicAttrubutePointer»
			«attribute.name»Attrib	*«attribute.name.toLowerCase» = new «attribute.name»Attrib(attname);
		«ELSE»
			«attribute.name»Attrib	*«attribute.name.toLowerCase» = new «attribute.name»Attrib();
		«ENDIF»
		Tango::UserDefaultAttrProp	«attribute.name.toLowerCase»_prop;
		«attribute.setProperty("description", attribute.properties.description)»
		«attribute.setProperty("label", attribute.properties.label)»
		«attribute.setProperty("unit", attribute.properties.unit)»
		«attribute.setProperty("standard_unit", attribute.properties.standardUnit)»
		«attribute.setProperty("display_unit", attribute.properties.displayUnit)»
		«attribute.setProperty("format", attribute.properties.format)»
		«attribute.setProperty("max_value", attribute.properties.maxValue)»
		«attribute.setProperty("min_value", attribute.properties.minValue)»
		«attribute.setProperty("max_alarm", attribute.properties.maxAlarm)»
		«attribute.setProperty("min_alarm", attribute.properties.minAlarm)»
		«attribute.setProperty("max_warning", attribute.properties.maxWarning)»
		«attribute.setProperty("min_warning", attribute.properties.minWarning)»
		«attribute.setProperty("delta_t", attribute.properties.deltaTime)»
		«attribute.setProperty("delta_val", attribute.properties.deltaValue)»
		«IF attribute.eventCriteria!==null»
			«attribute.setEventProprty("event_period", attribute.eventCriteria.period)»
			«attribute.setEventProprty("event_rel_change", attribute.eventCriteria.relChange)»
			«attribute.setEventProprty("event_abs_change", attribute.eventCriteria.absChange)»
		«ENDIF»
		«IF attribute.evArchiveCriteria!==null»
			«attribute.setEventProprty("archive_event_period", attribute.evArchiveCriteria.period)»
			«attribute.setEventProprty("archive_event_rel_change", attribute.evArchiveCriteria.relChange)»
			«attribute.setEventProprty("archive_event_abs_change", attribute.evArchiveCriteria.absChange)»
		«ENDIF»

		«IF cls!==null»
			«cls.protectedArea("att_" + attribute.name + "_dynamic_attribute", "", false)»
		«ENDIF»
		«attribute.manageEnumLabels»
		«attribute.name.toLowerCase»->set_default_properties(«attribute.name.toLowerCase»_prop);
		«IF attribute.polledPeriod.integerValue>0»
			«attribute.setExtendedProprty("polling_period", attribute.polledPeriod, "Not Polled")»
		«ELSE»
			//	Not Polled
		«ENDIF»
		«attribute.setExtendedProprty("disp_level", attribute.displayLevel, "Tango::OPERATOR")»
		«attribute.setAttributeMemorized("Not Memorized")»
		«attribute.setEventCriteria»
		«IF cls===null»
			att_list.push_back(«attribute.name.toLowerCase»);
		«ELSE»
			«attribute.declareIfNeeded»
			«attribute.name»_data.insert(make_pair(attname, «attribute.defaultValue»));
			add_attribute(«attribute.name.toLowerCase»);
		«ENDIF»
	'''
	//======================================================
	def setProperty(Attribute attribute, String propertyName, String strValue) '''
		«IF strValue.isSet»
			«attribute.name.toLowerCase»_prop.set_«propertyName»("«strValue.oneLineString»");
		«ELSE»
			//	«propertyName»	not set for «attribute.name»
		«ENDIF»
	'''
	//======================================================
	def setExtendedProprty(Attribute attribute, String propertyName, String strValue, String comment) '''
		«IF strValue.isSet»
			«IF propertyName=="disp_level"»
				«attribute.name.toLowerCase»->set_«propertyName»(Tango::«strValue»);
			«ELSE»
				«attribute.name.toLowerCase»->set_«propertyName»(«strValue»);
			«ENDIF»
		«ELSE»
			//	«comment»
		«ENDIF»
	'''
	//======================================================
	def setEventProprty(Attribute attribute, String propertyName, String strValue) '''
		«IF strValue.isSet»
			«attribute.name.toLowerCase»_prop.set_«propertyName»("«strValue»");
		«ENDIF»
	'''
	//======================================================
	def manageEnumLabels(Attribute attribute) '''
		«IF attribute.dataType.cppType.toString().contains("Enum")»
			«IF attribute.enumLabels!==null && attribute.enumLabels.size>0»
				{
					vector<std::string> labels;
					«FOR String label : attribute.enumLabels»
						labels.push_back("«label»");
					«ENDFOR»
					«attribute.name.toLowerCase»_prop.set_enum_labels(labels);
				}
			«ENDIF»
		«ENDIF»
	'''
	//======================================================
	def setEventCriteria(Attribute attribute) '''
		«IF attribute.dataReadyEvent!==null»
			«IF attribute.dataReadyEvent.fire.isTrue»
				«attribute.name.toLowerCase»->set_data_ready_event(«attribute.dataReadyEvent.fire»);
			«ENDIF»
		«ENDIF»
		«IF attribute.changeEvent!==null»
			«IF attribute.changeEvent.fire.isTrue»
				«attribute.name.toLowerCase»->set_change_event(«attribute.changeEvent.fire», «attribute.changeEvent.libCheckCriteria»);
			«ENDIF»
		«ENDIF»
		«IF attribute.archiveEvent!==null»
			«IF attribute.archiveEvent.fire.isTrue»
				«attribute.name.toLowerCase»->set_archive_event(«attribute.archiveEvent.fire», «attribute.archiveEvent.libCheckCriteria»);
			«ENDIF»
		«ENDIF»
	'''

	//======================================================
	//	Do not add parameter true :-)
	def setAttributeMemorized(Attribute attribute, String comment) '''
		«IF attribute.memorized.isSet»
			«attribute.name.toLowerCase»->set_memorized();
			«IF attribute.memorizedAtInit.isSet»
				«attribute.name.toLowerCase»->set_memorized_init(«attribute.memorizedAtInit»);
			«ELSE»
				«attribute.name.toLowerCase»->set_memorized_init(false);
			«ENDIF»
		«ELSE»
			//	«comment»
		«ENDIF»
	'''
	//======================================================
	//	Allocate memory for dynamic attribute 
	//======================================================
	def allocateDynamicAttrubutePointer(Attribute attribute) '''
		«IF attribute.isSpectrum»
			if (ptr==NULL)
				ptr = new «attribute.dataType.cppType»[«attribute.maxX»];
		«ELSEIF attribute.isImage»
			if (ptr==NULL)
				ptr = new «attribute.dataType.cppType»[«attribute.maxX»*«attribute.maxY»];
		«ENDIF»
	'''
}