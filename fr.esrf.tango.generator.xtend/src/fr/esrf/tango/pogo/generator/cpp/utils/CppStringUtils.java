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

package fr.esrf.tango.pogo.generator.cpp.utils;

import org.eclipse.emf.common.util.EList;
import java.util.ArrayList;

import fr.esrf.tango.pogo.generator.common.StringUtils;
import fr.esrf.tango.pogo.pogoDsl.Command;
import fr.esrf.tango.pogo.pogoDsl.Attribute;
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass;
import fr.esrf.tango.pogo.pogoDsl.State;


public class CppStringUtils extends fr.esrf.tango.pogo.generator.common.StringUtils{


	//===========================================================
	public String strType(Attribute attribute) {
		return CppTypeDefinitions.cppType(attribute.getDataType());
	}

	//===========================================================
	//	Dynamic attribute headers and signatures
	//===========================================================
	public String addDynamicAttributeHeaderComment(Attribute attribute) {
		 String comment = " *  parameter attname: attribute name to be cretated and added.\n";
		 if (isScalar(attribute) == false)
			 comment += " *  parameter ptr:     memory buffer used to set attribute value.\n" +
			            " *                     If NULL or not specified, buffer will be allocated.";
		 return comment;
	}
	//===========================================================
	public String removeDynamicAttributeHeaderComment(Attribute attribute) {
		 String comment = " *  parameter attname: attribute name to be removed.\n";
		 if (isScalar(attribute) == false)
			 comment += " *  parameter free_it: memory buffer will be freed if true or not specified.";
		 return comment;
	}
	//===========================================================
	public String addDynamicAttributeSignature(PogoDeviceClass cls, Attribute attribute, boolean prototype) {
		String	signature = "void ";
		if (prototype==false)
			signature += cls.getName() + "::";
		signature += "add_" + attribute.getName() + "_dynamic_attribute(std::string attname";
		if (isScalar(attribute) == false) {
			signature += ", " + strType(attribute) + " *ptr";
			if (prototype)
				signature += "=NULL";
		}
		signature += ")";
		if (prototype)
			signature += ";";
		return signature;
	}
	//===========================================================
	public String removeDynamicAttributeSignature(PogoDeviceClass cls, Attribute attribute, boolean prototype) {
		String	signature = "void ";
		if (prototype==false)
			signature += cls.getName() + "::";
		signature += "remove_" + attribute.getName() + "_dynamic_attribute(std::string attname";
		if (isScalar(attribute) == false) {
			signature += ", bool free_it";
			if (prototype)
				signature += "=true";
		}
		signature += ")";
		if (prototype)
			signature += ";";
		return signature;
	}
	
	//===========================================================
	//	Dynamic commands headers and signatures
	//===========================================================
	public String addDynamicCommandHeaderComment(Command command) {
		 String comment = " *  parameter cmdname: command name to be cretated and added.\n"+
				 		  " *  parameter device:  Set this flag to true if the command must be added for only this device.\n";
		 return comment;
	}
	//===========================================================
	public String removeDynamicCommandHeaderComment(Command command) {
		 String comment = " *  parameter cmdname: command name to be removed.\n";
		 return comment;
	}
	//===========================================================
	public String addDynamicCommandSignature(PogoDeviceClass cls, Command command, boolean prototype) {
		String	signature = "void ";
		if (prototype==false)
			signature += cls.getName() + "::";
		signature += "add_" + command.getName() + "_dynamic_command(std::string cmdname, bool device)";
		if (prototype)
			signature += ";";
		return signature;
	}
	//===========================================================
	public String removeDynamicCommandSignature(PogoDeviceClass cls, Command command, boolean prototype) {
		String	signature = "void ";
		if (prototype==false)
			signature += cls.getName() + "::";
		signature += "remove_" + command.getName() + "_dynamic_command(std::string cmdname)";
		if (prototype)
			signature += ";";
		return signature;
	}
	//===========================================================

	//===========================================================
	/**
	 * build the states table
	 */
	//===========================================================
	public static String statesTable(EList<State> states) {

		//	Build a list of state columns to build the table
		ArrayList<String[]>	list = new ArrayList<String[]>();
		list.add(new String[] { "================================================================" });
		list.add(new String[] { "States", "Description" });
		list.add(new String[] { "================================================================" });
		for (State state : states) {
			list.add(new String[] { state.getName(), state.getDescription() });
		}
		return buildTable(list);
	}
	//===========================================================
	/**
	 * build the commands table
	 */
	//===========================================================
	public String commandsTable(EList<Command> commands) {

		InheritanceUtils	inher = new InheritanceUtils();
		//	Build a list of command columns to build the table
		ArrayList<String[]>	list = new ArrayList<String[]>();
		list.add(new String[] { "================================================================" });
		list.add(new String[] { "  The following table gives the correspondence" });
		list.add(new String[] { "  between command and method names." });
		list.add(new String[] { "" });
		list.add(new String[] { "Command name", "Method name" });
		list.add(new String[] { "================================================================" });
		for (Command command : commands) {
			if (inher.isConcreteHere(command))
				list.add(new String[] { command.getName(), command.getExecMethod() });
			else
				list.add(new String[] { command.getName(), "Inherited (no method)" });
		}
		list.add(new String[] { "================================================================" });
		return buildTable(list);
	}
	//===========================================================
	/**
	 * build the commands table
	 */
	//===========================================================
	public  String attributesTable(EList<Attribute> attributes) {

		String title = "  Attributes managed ";
		if (attributes.size()>1)
			title += "are:";
		else
			title += "is:";
		//	Build a list of command columns to build the table
		ArrayList<String[]>	list = new ArrayList<String[]>();
		list.add(new String[] { "================================================================" });
		list.add(new String[] { title });
		list.add(new String[] { "================================================================" });
		for (Attribute attribute : attributes) {
			//	Build description
			String	desc = CppTypeDefinitions.cppType(attribute.getDataType()) + "	" +
						attribute.getAttType();
			if (attribute.getAttType().equals("Scalar")==false)
				desc += "  (" + attTypeDimentions(attribute) + ")";

			list.add(new String[] { attribute.getName(), desc });
		}
		list.add(new String[] { "================================================================" });
		return buildTable(list);
	}
	//===========================================================
	//===========================================================
	private static String buildTable(ArrayList<String[]> list) {
		StringBuffer	sb = new StringBuffer();
		//	Get the longest first element
		int	length = 0;
		for (String[] array : list) {
			if (array.length>1)
				if (array[0].length()>length)
					length = array[0].length();
		}
		String	emptyTab = "//  ";
		for (int i=0 ; i<length ; i++)
			emptyTab += " ";
		
		for (String[] array : list) {
			if (array.length>1) {
				String	comments = comments(array[1], emptyTab+"  |  ");
				sb.append("//  ").append(buildTab(array[0], length)).append("  |  ").append(comments);
			}
			else
				sb.append("//").append(array[0]);
			sb.append('\n');
		}
		return sb.toString();
	}

	//===========================================================
	private static String buildTab(String str, int nbChar) {
		StringBuffer	sb = new StringBuffer(str);
		for (int i=str.length() ; i<nbChar ; i++) {
			sb.append(' ');
		}
		return sb.toString();
	}
	//===========================================================
	public static String readWithWrite(Attribute attribute) {
		if (attribute.getRwType().contains("WITH_WRITE"))
			return ", \"" + attribute.getAssociatedAttr() + "\"";
		else
			return "";
	}
	//===========================================================
	public static boolean hasWritableAttribute(PogoDeviceClass cls) {
		EList<Attribute>	attributes = cls.getAttributes();
		for (Attribute attribute : attributes) {
			String	str = attribute.getRwType();
			if (isSet(str) && str.contains("WRITE"))
				return true;
		}
		return false;
	}
	//===========================================================

	//===========================================================
	public static String commandParameterHeader(Command command) {
		String	str = "";
		if (CppTypeDefinitions.cppType(command.getArgin().getType()).equals("void")==false) {
			str += " *	@param argin " +
					StringUtils.comments(command.getArgin().getDescription(), " *               ") + "\n";
		}
		if (CppTypeDefinitions.cppType(command.getArgout().getType()).equals("void")==false) {
			str += " *	@returns " +
					StringUtils.comments(command.getArgout().getDescription(), " *           ") + "\n";
		}

		return str;
	}
	
	//===========================================================
	public String manageEnumForMethodHeader(Attribute attribute) {
		String	returnStr = "";
		if (strType(attribute).contains("DevEnum")) {
			returnStr = " (" + attribute.getName() + "Enum)";
		}
		return returnStr;
	}
	//===========================================================
	public String buildEnum(Attribute attribute) {
		if (strType(attribute).contains("DevEnum")) {
			StringBuilder	sb = new StringBuilder("enum class _" + attribute.getName() + "Enum {\n");
			for (String label : attribute.getEnumLabels()) {
				sb.append("\t").append(label2enum(label)).append(",\n");
			}
			sb.append("} ").append(";\n");
			sb.append("typedef _").append(attribute.getName())
				.append("Enum ").append(attribute.getName()).append("Enum;\n\n");
			return sb.toString();
		}
		else
			return "";
		
	}
	//===========================================================
	public String buildEnums(PogoDeviceClass pogoClass) {
		StringBuilder	sb = new StringBuilder();
		for (Attribute attribute : pogoClass.getAttributes()) {
			sb.append(buildEnum(attribute));
		}
		for (Attribute attribute : pogoClass.getDynamicAttributes()) {
			sb.append(buildEnum(attribute));
		}
		return sb.toString();
	}
	//===========================================================
}
