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

package fr.esrf.tango.pogo.generator.common;

import org.eclipse.emf.common.util.EList;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;

import fr.esrf.tango.pogo.pogoDsl.Attribute;
import fr.esrf.tango.pogo.pogoDsl.Property;
import fr.esrf.tango.pogo.pogoDsl.State;


public class StringUtils {

	//===========================================================
	/*
	 * Define the DeviceImpl used to generate
	 */
	//===========================================================
	public static String DeviceImpl() {
		return "TANGO_BASE_CLASS";
	}

	//===========================================================
	/**
	 * convert string to boolean
	 */
	//===========================================================
	public static boolean isTrue(String str) {
		return (str!=null && str.equals("true"));
	}
	//===========================================================
	/**
	 * convert string to boolean
	 */
	//===========================================================
	public static boolean isFalse(String str) {
		return !isTrue(str);
	}
	//===========================================================
	/**
	 * Print trace text if TRACE=true exported
	 */
	//===========================================================
	private static boolean trace;
	private static boolean traceNotSet = true;
	public static void printTrace(String s) {
		if (traceNotSet) {
			trace = isTrue(System.getenv("XTendTrace"));
			traceNotSet = false;
		}
		if (trace)
			System.out.println(s);
	}
	//===========================================================
	/**
	 * returns true if has been set
	 */
	//===========================================================
	public static boolean isSet(String str) {
		return (str!=null && !str.isEmpty());
	}
	//===========================================================
	/**
	 * returns string value as integer
	 */
	//===========================================================
	public static int getIntegerValue(String str) {
		if  (!isSet(str))
			return -1;
		else
			try {
				return Integer.parseInt(str);
			}
			catch (Exception e) {
				return -1;
			}
	}
	//===========================================================
	/**
	 * Convert name to data member name (first char to lower case
	 */
	//===========================================================
	public String dataMemberName(String s) {	
		return s.substring(0,1).toLowerCase()+s.substring(1, s.length());
	}
	//===========================================================
	/*
	 * Convert a list to a string with '\n' separator char
	 */
	//===========================================================
	public String list2String(EList<String> list) {
		StringBuilder sb = new StringBuilder();
		for (int i=0 ; i<list.size(); i++) {
			sb.append(escapeQuotes(list.get(i)));
			if (i<list.size()-1)
				sb.append("\\n"); 
		}
		return sb.toString();
	}
	//===========================================================
	/*
	 * Convert multi lines text to a one line text
	 */
	//===========================================================
	public String oneLineString(String text) {
		//return str.replaceAll("\n", "\\n");	-> does not work

		if (text==null)
			return "";
		StringBuilder sb = new StringBuilder();
		int	start = 0;
		int end;
		while ((end=text.indexOf('\n', start))>0){
			sb.append(text.substring(start, end)).append("\\n");
			start = end +1;
		}
		sb.append(text.substring(start));
		return sb.toString();
	}
	//===========================================================
	/*
	 * Convert a multi lines string to a multi push_back(line) 
	 */
	//===========================================================
	public String string2Vector(String text, String vectorName) {
		StringBuilder sb = new StringBuilder();
		int	start = 0;
		int end;
		while ((end=text.indexOf('\n', start))>0){
			sb.append(vectorName).append(".push_back(\"");
			sb.append(text.substring(start, end)).append("\");\n");		
			start = end +1;
		}
		sb.append(vectorName).append(".push_back(\"");
		sb.append(text.substring(start)).append("\");\n");		
		return sb.toString();
	}
	//===========================================================
	/*
	 * Escape double quotes in a string 
	 */
	//===========================================================
	public String escapeQuotes(String text) {
            return text.replace("\"", "\\\"");
	}
	//===========================================================
	/**
	 * Comment a String with more than one line
	 */
	//===========================================================
	public static String comments(String s, String tag) {
		return s.replace("\n", "\n" + tag);
	}
	//===========================================================
	/**
	 * build a "if" content from the specified list.
	 * 		used by StateMachine
	 * @param list specified list
	 * @return the "if" content from the specified list
	 */
	//===========================================================
	public String ifContentFromList(EList<String> list) {
		StringBuilder	sb = new StringBuilder();
		for (int i=0 ; i<list.size(); i++) {
			sb.append("get_state()==Tango::").append(list.get(i));
			if (i<list.size()-1)
				sb.append(" ||\n	");
		}
		return sb.toString();
	}
	
	//===========================================================
	/**
	 * build a "if" content from the specified list.
	 * 		used by PythonUtils
	 * @param list specified list
	 * @return the "if" content from the specified list
	 */
	//===========================================================
	public String ifContentFromListPython(EList<String> list) {
		StringBuilder	sb = new StringBuilder();
		sb.append("self.get_state() in [");
		for (int i=0 ; i<list.size(); i++) {
			sb.append("PyTango.DevState.").append(list.get(i));
			if (i<list.size()-1)
				sb.append(",\n    ");
		}
		sb.append("]");
		return sb.toString();
	}
	//===========================================================
	/**
	 * build a "if" content from the specified list.
	 * 		used by PythonUtils
	 * @param list specified list
	 * @return the "if" content from the specified list
	 */
	//===========================================================
	public String ifContentFromListPythonHL(EList<String> list) {
		StringBuilder	sb = new StringBuilder();
		sb.append("self.get_state() not in [");
		for (int i=0 ; i<list.size(); i++) {
			sb.append("DevState.").append(list.get(i));
			if (i<list.size()-1)
				sb.append(",");
		}
		sb.append("]");
		return sb.toString();
	}
	
	//======================================================
	//	Check if at least one property is mandatory
	//======================================================
	public boolean hasMandatoryProperty(EList<Property> properties) {
		for (Property property : properties)
			if (isTrue(property.getMandatory()))
				return true;
		return false;
	}
	
	//======================================================
	public boolean isScalar(Attribute attr) {
		return (attr.getAttType().equals("Scalar"));
	}
	//======================================================
	public boolean isSpectrum(Attribute attr) {
		return (attr.getAttType().equals("Spectrum"));
	}
	//======================================================
	public boolean isImage(Attribute attr) {
		return (attr.getAttType().equals("Image"));
	}
	//======================================================
	//	Attribute utilities
	//======================================================
	public String attTypeDimentions(Attribute attr) {
		if (isSpectrum(attr))
			return " max = " + attr.getMaxX();
		else
		if (isImage(attr))
			return  " max = " + attr.getMaxX() + " x " + attr.getMaxY();
		else
			return "";
	}
	//===========================================================
	//===========================================================
	public static boolean isRead(Attribute attribute) {
		String	str = attribute.getRwType();
		return isSet(str) && str.contains("READ");
	}
	//===========================================================
	public static boolean isWrite(Attribute attribute) {
		String	str = attribute.getRwType();
		return isSet(str) && str.contains("WRITE");
	}
	//===========================================================

	
	
	//===========================================================
	/**
	 * build the states table
	 */
	//===========================================================
	@SuppressWarnings("unused")
	public static String statesTable(EList<State> states) {

		//	Build a list of state columns to build the table
		ArrayList<String[]>	list = new ArrayList<>();
		list.add(new String[] { "================================================================" });
		list.add(new String[] { "States", "Description" });
		list.add(new String[] { "================================================================" });
		for (State state : states) {
			list.add(new String[] { state.getName(), state.getDescription() });
		}
		return buildTable(list);
	}
	//===========================================================
	//===========================================================
	private static String buildTable(ArrayList<String[]> list) {
		StringBuilder	sb = new StringBuilder();
		//	Get the longest first element
		int	length = 0;
		for (String[] array : list) {
			if (array.length>1)
				if (array[0].length()>length)
					length = array[0].length();
		}
		
		for (String[] array : list) {
			if (array.length>1) {
				sb.append("//  ").append(buildTab(array[0], length)).append("  |  ").append(array[1]);
			}
			else
				sb.append("//").append(array[0]);
			sb.append('\n');
		}
		return sb.toString();
	}

	//===========================================================
	//===========================================================
	private static String buildTab(String str, int nbChar) {
		StringBuilder sb = new StringBuilder(str);
		for (int i=str.length() ; i<nbChar ; i++) {
			sb.append(' ');
		}
		return sb.toString();
	}
	//===========================================================
	//===========================================================







    //===============================================================
    //===============================================================
	public void insertInProtectedRegion(String fileName, String key, String textToInsert) throws Exception{
		String	code = readFile(fileName);
		int	start = code.indexOf("PROTECTED REGION ID(" + key + ") ENABLED START");
		if (start>0) {
			start = code.indexOf("\n", start)+1;
			int end = code.indexOf("PROTECTED REGION END", start);
			end = code.lastIndexOf("\n", end);
			
			code = code.substring(0, start) + textToInsert + code.substring(end);
			writeFile(fileName, code);
		}
		else
			System.err.println("PROTECTED REGION ID(" + key + ") ENABLED START" + " not found !!");
	}
    //===============================================================
    //===============================================================
	public String getProtectedRegionContent(String fileName, String key) throws Exception{
		String	code = readFile(fileName);
		int	start = code.indexOf("PROTECTED REGION ID(" + key + ") ENABLED START");
		if (start>0) {
			start = code.indexOf("\n", start)+1;
			int end = code.indexOf("PROTECTED REGION END", start);
			end = code.lastIndexOf("\n", end);
			return code.substring(start, end);
		}
		else
			return null;
	}
    //===============================================================
    /**
     * Open a file and return text read.
     *
     * @param filename file to be read.
     * @return the file content read.
     * @throws Exception in case of failure during read file.
     */
    //===============================================================
    public static String readFile(String filename) throws Exception {
        String str = "";
        FileInputStream fid = new FileInputStream(filename);
        int nb = fid.available();
        byte[] inStr = new byte[nb];
        nb = fid.read(inStr);
        fid.close();

        if (nb > 0)
            str = takeOffWindowsChar(inStr);
        return str;
    }
    //===============================================================
    /**
     * Take off Cr eventually added by Windows editor.
     *
     * @param b_in specified byte array to be modified.
     * @return the modified byte array as String.
     */
    //===============================================================
    protected static String takeOffWindowsChar(byte[] b_in) {
        //	Take off Cr (0x0d) eventually added by Windows editor
        int nb = 0;
        for (byte b : b_in)
            if (b != 13)
                nb++;
        byte[] b_out = new byte[nb];
        for (int i = 0, j = 0; i < b_in.length; i++)
            if (b_in[i] != 13)
                b_out[j++] = b_in[i];
        return new String(b_out);
    }
    //===============================================================
    //===============================================================
    public static void writeFile(String filename, String code) throws Exception {
        FileOutputStream fidout = new FileOutputStream(filename);
        fidout.write(code.getBytes());
        fidout.close();
    }
    //===============================================================
    //===============================================================
    public static boolean fileExists(String fileName) {
    	return new File(fileName).exists();
    }
    //===============================================================
    /**
     * Replace special characters 
     * @param label enum label
     * @return the enum with expected characters
     */
    //===============================================================
    public static String label2enum(String label) {
    	String	enumStr = label.toUpperCase();
    	enumStr = myReplaceAll(enumStr, "*", "mult");
    	enumStr = myReplaceAll(enumStr, "/", "div");
    	enumStr = myReplaceAll(enumStr, "+", "plus");
    	enumStr = myReplaceAll(enumStr, "-", "minus");
    	enumStr = myReplaceAll(enumStr, ".", "point");
    	enumStr = myReplaceAll(enumStr, "=", "equal");
    	enumStr = myReplaceAll(enumStr, "%", "percent");
    	enumStr = myReplaceAll(enumStr, ">", "sup");
    	enumStr = myReplaceAll(enumStr, "<", "inf");
    	return "_"+enumStr.replaceAll(" ", "_");
    }
    //===============================================================
    //===============================================================
    public static String myReplaceAll(String inCode, String oldStr, String newStr) {
		StringBuilder sb = new StringBuilder();
		
		int start = 0;
		int end;
		while ((end=inCode.indexOf(oldStr, start))>0) {
			sb.append(inCode.substring(start, end)).append(newStr);
			start = end + oldStr.length();
		}
		sb.append(inCode.substring(start));
		return sb.toString();
    }
    //===============================================================
    //===============================================================

    
	//======================================================
	//	GPL license
	//======================================================
	public static String licenseText(String licence, String commentTag) {
		if (licence!=null && licence.equals("none"))
			return "";
		
		if (licence!=null && licence.equals("APACHE"))
			return commentTag + comments(ILicences.apacheLicenece, commentTag) + "\n";
		
		if (licence!=null && licence.equals("MIT"))
			return commentTag + comments(ILicences.mitLicenece, commentTag) + "\n";

		if (licence!=null && licence.equals("BSD3"))
			return commentTag + comments(ILicences.bsdLicenece, commentTag) + "\n";
		
		//	default IS GPL
		if (licence!=null && licence.equals("LGPL")) {
			// convert gpl to lgpl
			String gpl = ILicences.gplLicenece;
			String str = "General Public License";
			StringBuilder sb = new StringBuilder();
			int start = 0;
			int end;
			while ((end=gpl.indexOf(str, start+str.length()))>0) {
				sb.append(gpl, start, end).append("Lesser ");
				start = end;
			}
			sb.append(gpl.substring(start));
			return commentTag + comments(sb.toString(), commentTag)+"\n";
		}
		else
			//	GPL
			return commentTag + comments(ILicences.gplLicenece, commentTag)+"\n";
	}
    //===============================================================
    //===============================================================
	public static String getCopyrightCommented(String copyright) {
		if (copyright==null || copyright.isEmpty())
			return "";
		StringBuilder sb = new StringBuilder();
		int start = 0;
		int end;
		while ((end=copyright.indexOf('\n', start))>0) {
			end++;
			String line = "// " + copyright.substring(start, end);
			sb.append(line);
			start = end;
		}
		sb.append("// ").append(copyright.substring(start)).append("\n");
		return sb.toString();
	}
    //===============================================================
    //===============================================================
	public static String getIncludePath() {
		String tangoInclude = System.getenv("TANGO_INCLUDE");
		if (tangoInclude==null)
			return "$TANGO_ROOT/include";
		return tangoInclude;
	}
}
