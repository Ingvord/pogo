//+======================================================================
//
// Project:   Tango
//
// Description:  source code for Tango code generator.
//
// $Author: verdier $
//
// Copyright (C) :  2004,2005,2006,2007,2008,2009,2009,2010,2011,2012,2013
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

package fr.esrf.tango.pogo.generator.java;

import java.util.ArrayList;

import org.eclipse.emf.common.util.EList;

import fr.esrf.tango.pogo.generator.common.StringUtils;
import fr.esrf.tango.pogo.pogoDsl.Attribute;
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass;
import fr.esrf.tango.pogo.pogoDsl.Property;
import fr.esrf.tango.pogo.pogoDsl.Command;

public class JavaUtils extends StringUtils {

	//===========================================================
	/**
	 * Returns the device class package name
	 * @param cls	the class object
	 * @return the device class package name
	 */
	//===========================================================
	public String javaDevicePackage (PogoDeviceClass cls) {
		return "org.tango."+cls.getName().toLowerCase();
	}
	//===========================================================
	/**
	 * Returns the source file path (from package)
	 * @param cls	the class object
	 * @return the source file path (from package)
	 */
	//===========================================================
	public String javaDeviceSourceFile(PogoDeviceClass cls) {
		String pack =  javaDevicePackage(cls);
		return pack.replaceAll("\\.","/");
	} 
	
	//===========================================================
	/**
	 * Returns the full qualified name the for device class 
	 * @param cls	the class object
	 * @return the full qualified name the for device class 
	 */
	//===========================================================
	public String fullQualifiedJavaDeviceClassName(PogoDeviceClass cls) {
		return fullQualifiedJavaDeviceClassName(cls, cls.getName());
	} 
	//===========================================================
	/**
	 * Returns the full qualified name the for device class 
	 * @param className =the class to get file name
	 * @return the full qualified name the for device class 
	 */
	//===========================================================
	public String fullQualifiedJavaDeviceClassName(PogoDeviceClass cls, String className){
		return javaDevicePackage(cls) + "." + className;
	} 
	
	//===========================================================
	/**
	 * Returns the full qualified name the for device class file
	 * @param cls	the class object
	 * @param full  if false return name without path
	 * @return the full qualified name the for device class file
	 */
	//===========================================================
	public String javaDeviceClassFileName( PogoDeviceClass cls, boolean full ) {
		if (full) {
			String	fullName = fullQualifiedJavaDeviceClassName(cls);
			return fullName.replaceAll("\\.","/") + ".java";
		}
		else
			return cls.getName() + ".java";
	} 
	//===========================================================
	/**
	 * Returns the full qualified name the for device class file
	 * @param cls	the class object
	 * @return the full qualified name the for device class file
	 */
	//===========================================================
	public String javaDynamicAttributeFileName( PogoDeviceClass cls, String attributeName) {
		String	fullName = fullQualifiedJavaDeviceClassName(cls, attributeName);
		return fullName.replaceAll("\\.","/") + ".java";
	}
	//===========================================================
	public String strJavaType(Attribute attribute) {
		return JavaTypeDefinitions.javaType(attribute.getDataType());
	}
	//===========================================================
	public String strFullJavaType(Attribute attribute) {
		if (isScalar(attribute))
			return JavaTypeDefinitions.javaType(attribute.getDataType());
		else
		if (isSpectrum(attribute))
			return JavaTypeDefinitions.javaType(attribute.getDataType()) + "[]";
		else
			return JavaTypeDefinitions.javaType(attribute.getDataType()) + "[][]";
	}
	//===========================================================
	public String strJavaType(Property property) {
		return JavaTypeDefinitions.javaPropType(property.getType());
	}
	//===========================================================
	public String strArginType(Command command) {
		return JavaTypeDefinitions.javaType(command.getArgin().getType());
	}
	//===========================================================
	public String strArgoutType(Command command) {
		return JavaTypeDefinitions.javaType(command.getArgout().getType());
	}
	//===========================================================
	//===========================================================
	public String allocation(Attribute attribute) {
		if (attribute.getAttType().equals("Spectrum"))
			return " = new " +
				JavaTypeDefinitions.javaType(attribute.getDataType()) + "[" +
						attribute.getMaxX() + "]";
		else
		if (attribute.getAttType().equals("Image"))
			return " = new " +
				JavaTypeDefinitions.javaType(attribute.getDataType()) + "[" +
						attribute.getMaxX() + "][" + attribute.getMaxY() + "]";
		else
			return "";
	}
	
	//===========================================================
	/**
	 * Returns the default property values with expected format
	 * @param property the specified property
	 * @return the default property values with expected format
	 */
	//===========================================================
	public String defaultValue(Property property) {
		EList<String>	defaultValues = property.getDefaultPropValue();
		if (defaultValues==null || defaultValues.isEmpty())
			return "";
		else {
			String	str = ", defaultValue=\"[";
			for (int i=0 ; i<defaultValues.size() ; i++) {
				str += defaultValues.get(i);
				if (i<defaultValues.size()-1)
					str += ", ";
			}
			str += "]\"";
			return str;
		}
	}

	//===========================================================
	/**
	 * Returns the command parameters with expected format
	 * @param command the specified command
	 * @return the command parameters with expected format
	 */
	//===========================================================
	public String declareParameters(Command command) {
		//	Put in a list parameters value only if has been set
		ArrayList<String>	list = new ArrayList<String>();
		list.add("name=\"" + command.getName() + "\"");
		list.add("inTypeDesc=\""  + oneLineString(command.getArgin().getDescription())  + "\"");
		list.add("outTypeDesc=\"" + oneLineString(command.getArgout().getDescription()) + "\"");

		if (isSet(command.getDisplayLevel())) {
			if (command.getDisplayLevel().equals("EXPERT"))
				list.add("displayLevel=DispLevel._"+command.getDisplayLevel());
		}
		if (isSet(command.getPolledPeriod())) {
			if (command.getPolledPeriod().equals("0")==false) {
				list.add("isPolled=true");
				list.add("pollingPeriod=" + command.getPolledPeriod());
			}
		}
		
		return propertiesInOneLine("@Command(", list, ")");
	}
	//===========================================================
	//===========================================================
	public String stateMachine(Command command) {

		ArrayList<String>	list = new ArrayList<String>();
		for (String state : command.getExcludedStates())
			list.add("DeviceState."+state);

		if (list.isEmpty())
			return "";
		else
			return propertiesInOneLine("@StateMachine(deniedStates={", list, "})");

	}
	//===========================================================
	/**
	 * Returns the attribute parameters with expected format
	 * @param attribute the specified attribute
	 * @return the attribute parameters with expected format
	 */
	//===========================================================
	public String declareParameters(Attribute attribute) {
		//	Put in a list parameters value only if has been set
		ArrayList<String>	list = new ArrayList<String>();

		list.add("name=\"" + attribute.getName() + "\"");
		
		if (isTrue(attribute.getMemorized())) {
			list.add("isMemorized=true");
			if (isTrue(attribute.getMemorizedAtInit())) {
				list.add("isMemorizedAtInit=true");
			}
		}
		if (isSet(attribute.getDisplayLevel())) {
			if (attribute.getDisplayLevel().equals("EXPERT"))
				list.add("displayLevel=DispLevel._"+attribute.getDisplayLevel());
		}
		if (isSet(attribute.getPolledPeriod())) {
			if (attribute.getPolledPeriod().equals("0")==false) {
				list.add("isPolled=true");
				list.add("pollingPeriod=" + attribute.getPolledPeriod());
			}
		}
		//	Event management
		if (attribute.getDataReadyEvent()!=null) {
			if (isTrue(attribute.getDataReadyEvent().getFire())) {
				list.add("pushDataReady=true");
			}
		}
		
		if (attribute.getArchiveEvent()!=null) {
			if (isTrue(attribute.getArchiveEvent().getFire())) {
				list.add("pushArchiveEvent=true");
				if (isTrue(attribute.getArchiveEvent().getLibCheckCriteria())) {
					list.add("checkArchivingEvent=true");
				}
			}
		}

		if (attribute.getChangeEvent()!=null) {
			if (isTrue(attribute.getChangeEvent().getFire())) {
				list.add("pushChangeEvent=true");
				if (isTrue(attribute.getChangeEvent().getLibCheckCriteria())) {
					list.add("checkChangeEvent=true");
				}
			}
		}

		return propertiesInOneLine("@Attribute(",  list, ")");
	}
	//===========================================================
	/**
	 * Returns the attribute properties with expected format
	 * @param attribute the specified attribute
	 * @return the attribute properties with expected format
	 */
	//===========================================================
	public String declareProperties(Attribute attribute) {
		
		//	Put in a list property value only if has been set
		ArrayList<String>	list = new ArrayList<String>();
		if (isSet(attribute.getProperties().getDescription()))
			list.add("description=\"" + oneLineString(attribute.getProperties().getDescription()) + "\"");
		if (isSet(attribute.getProperties().getLabel()))
			list.add("label=\"" + attribute.getProperties().getLabel() + "\"");
		if (isSet(attribute.getProperties().getUnit()))
			list.add("unit=\"" + attribute.getProperties().getUnit() + "\"");
		if (isSet(attribute.getProperties().getStandardUnit()))
			list.add("standardUnit=\"" + attribute.getProperties().getStandardUnit() + "\"");
		if (isSet(attribute.getProperties().getDisplayUnit()))
			list.add("displayUnit=\"" + attribute.getProperties().getDisplayUnit() + "\"");
		if (isSet(attribute.getProperties().getFormat()))
			list.add("format=\"" + attribute.getProperties().getFormat() + "\"");
		if (isSet(attribute.getProperties().getMaxValue()))
			list.add("maxValue=\"" + attribute.getProperties().getMaxValue() + "\"");
		if (isSet(attribute.getProperties().getMinValue()))
			list.add("minValue=\"" + attribute.getProperties().getMinValue() + "\"");
		if (isSet(attribute.getProperties().getMaxAlarm()))
			list.add("maxAlarm=\"" + attribute.getProperties().getMaxAlarm() + "\"");
		if (isSet(attribute.getProperties().getMinAlarm()))
			list.add("minAlarm=\"" + attribute.getProperties().getMinAlarm() + "\"");
		if (isSet(attribute.getProperties().getMaxWarning()))
			list.add("maxWarning=\"" + attribute.getProperties().getMaxWarning() + "\"");
		if (isSet(attribute.getProperties().getMinWarning()))
			list.add("minWarning=\"" + attribute.getProperties().getMinWarning() + "\"");
		if (isSet(attribute.getProperties().getDeltaTime()))
			list.add("deltaTime=\"" + attribute.getProperties().getDeltaTime() + "\"");
		if (isSet(attribute.getProperties().getDeltaValue()))
			list.add("deltaValue=\"" + attribute.getProperties().getDeltaValue() + "\"");
		
		//	Event properties
		if (attribute.getEventCriteria()!=null) {
			if (isSet(attribute.getEventCriteria().getPeriod()))
				list.add("periodicEvent=\"" + attribute.getEventCriteria().getPeriod() + "\"");
			if (isSet(attribute.getEventCriteria().getAbsChange()))
				list.add("changeEventAbsolute=\"" + attribute.getEventCriteria().getAbsChange() + "\"");
			if (isSet(attribute.getEventCriteria().getRelChange()))
				list.add("changeEventRelative=\"" + attribute.getEventCriteria().getRelChange() + "\"");
		}
		if (attribute.getEvArchiveCriteria()!=null) {
			if (isSet(attribute.getEvArchiveCriteria().getPeriod()))
				list.add("archiveEventPeriod=\"" + attribute.getEvArchiveCriteria().getPeriod() + "\"");
			if (isSet(attribute.getEvArchiveCriteria().getAbsChange()))
				list.add("archiveEventAbsolute=\"" + attribute.getEvArchiveCriteria().getAbsChange() + "\"");
			if (isSet(attribute.getEvArchiveCriteria().getRelChange()))
				list.add("archiveEventRelative=\"" + attribute.getEvArchiveCriteria().getRelChange() + "\"");
		}

		if (list.isEmpty())
			return "";
		else
			return propertiesInOneLine("@AttributeProperties(", list, ")");
	}
	
	//===========================================================
	//===========================================================
	public String stateMachine(Attribute attribute) {

		ArrayList<String>	list = new ArrayList<String>();
		for (String state : attribute.getReadExcludedStates())
			list.add("DeviceState."+state);

		if (list.isEmpty())
			return "";
		else
			return propertiesInOneLine("@StateMachine(deniedStates={", list, "})");

	}
	//===========================================================
	//===========================================================
	public String stateMachineForDynamic(Attribute attribute) {

		ArrayList<String>	list = new ArrayList<String>();
		for (String state : attribute.getReadExcludedStates())
			list.add("DeviceState."+state);

		if (list.isEmpty())
			return "";
		else
			return  propertiesInOneLine("stateMachine.setDeniedStates(", list, ");");

	}
	//===========================================================
	/**
	 * Returns the properties with expected format
	 * @param list the specified properties
	 * @return the properties with expected format
	 */
	//===========================================================
	public String propertiesInOneLine(String header, ArrayList<String> list, String ending) {

		//	append all set properties with comma separator (not at end !)
		//	And a break line when too long
		StringBuffer	sb = new StringBuffer(header);
		int	length = header.length();
		for (int i=0 ; i<list.size() ; i++) {
			sb.append(list.get(i));
			length += list.get(i).length();
			
			//	is end of list ?
			if (i<list.size()-1) {
				sb.append(",");
				length++;
				//	is end of line ?
				if (length<76) { //	80 - '\t'
					sb.append(" ");
					length++;
				}
				else {
					sb.append("\n");
					for (int x=0 ; x<header.length() ; x++)
						sb.append(" ");
					length = header.length();
				}
			}
		}
		sb.append(ending);
		return sb.toString();
	}

	
	//===========================================================
	//===========================================================
	public String headerParameters(Command command) {
		String	params = "";
		if (JavaTypeDefinitions.javaType(command.getArgin().getType()).equals("void")==false) {
			params += "* @param " + parameter(command, "In") + " " + StringUtils.comments(
					command.getArgin().getDescription(), "*" + parameterInBlanks(command)) + "\n";
		}
		if (JavaTypeDefinitions.javaType(command.getArgout().getType()).equals("void")==false) {
			params += "* @return " + StringUtils.comments(
					command.getArgout().getDescription(), "*         ") + "\n";
		}
		params += "* @throws DevFailed if command execution failed.";
		return params;
	}
	//===========================================================
	//===========================================================
	public String strArginTypeDeclare(Command command) {
		String type = JavaTypeDefinitions.javaType(command.getArgin().getType());
		if (type.equals("void"))
			return "";
		else
			return type + " " + parameter(command, "In");
	}
	//===========================================================
	//===========================================================
	public String strArgoutTypeDeclare(Command command) {
		String type = JavaTypeDefinitions.javaType(command.getArgout().getType());
		if (type.equals("void"))
			return "";
		else
			return type + " " + parameter(command, "Out;");
	}
	//===========================================================
	//===========================================================
	public String strArgoutTypeReturn(Command command) {
		String type = JavaTypeDefinitions.javaType(command.getArgout().getType());
		if (type.equals("void"))
			return "";
		else
			return "return " + parameter(command, "Out;");
	}
	//===========================================================
	//===========================================================
	public String parameter(Command command, String inout) {
		return new StringUtils().dataMemberName(command.getName()) + inout;
	}
	//===========================================================
	//===========================================================
	public String parameterInBlanks(Command command) {
		String param = " @param " + parameter(command, "In ");
		StringBuilder sb = new StringBuilder();
		for (int i=0 ; i<param.length() ; i++)
			sb.append(' ');
		return sb.toString();
	}
	//===========================================================
	//===========================================================
	String setDynamicAttributeConfig(String setWhat, String strValue) {
		return setDynamicAttributeConfig(setWhat, strValue, "");
	}
	//===========================================================
	//===========================================================
	String setDynamicAttributeConfig(String setWhat, String strValue, String valueHeader) {
		if (isSet(strValue))
			return "config.set" + setWhat + "(" + valueHeader + strValue + ");";
		else
			return "";
	}
	//===========================================================
	//===========================================================
	String setDynamicAttributePropertyConfig(String setWhat, String strValue) {
		if (isSet(strValue))
			return "properties.set" + setWhat + "(\"" + oneLineString(strValue) + "\");";
		else
			return "";
	}
	//===========================================================
	//===========================================================
	public static String getJserverJarFile() {
		String jarFile   = System.getenv("JSERVER_JAR_FILE");
		if (jarFile!=null)
			return jarFile;

		String tangoRoot = System.getenv("TANGO_ROOT");
		if (tangoRoot==null)
			return "%TANGO_ROOT%/share/tango/java/JTangoServer.jar";
		return tangoRoot + "/share/tango/java/JTangoServer.jar";
	}
	
	//===========================================================
	//===========================================================
	public static String attributeMethodName(Attribute attribute, Boolean read) {
		String attName = attribute.getName().substring(0, 1).toUpperCase() + 
				attribute.getName().substring(1);
		String s;
		if (read) {
			if (attribute.getDataType().toString().contains("Boolean"))
				s = "is";
			else
				s = "get";
		}
		else
			s = "set";
		return s + attName;
	}
	//===========================================================
	//===========================================================
}
