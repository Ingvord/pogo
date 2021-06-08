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

import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass;
import fr.esrf.tango.pogo.pogoDsl.PogoMultiClasses;




public class ProtectedArea {

	//======================================================================
	// Define cpp protected areas for device
	//======================================================================
	public String openProtectedArea(PogoDeviceClass cls, String method) {
		return openProtectedArea(cls.getName(), method);
	}
	public String openProtectedArea(String className, String method) {
		if (method.startsWith("."))	//	Not method, it is a file name
			return "/*----- PROTECTED REGION ID(" + className + method + ") ENABLED START -----*/\n";
		else
			return "/*----- PROTECTED REGION ID(" + className + "::" + method + ") ENABLED START -----*/\n";
	}
	//======================================================================
	public String closeProtectedArea(PogoDeviceClass cls, String method) {
		return closeProtectedArea(cls.getName(), method);
	}
	public String closeProtectedArea(String className, String method) {
		if (method.startsWith("."))
			return "/*----- PROTECTED REGION END -----*/	//	" + className + method + "\n";
		else
			return "/*----- PROTECTED REGION END -----*/	//	" + className + "::" + method + "\n";
	}
	//======================================================================
	public String protectedArea(PogoDeviceClass cls, String method, String code, boolean comments) {
		if (comments)
			return openProtectedArea(cls, method) +
					"//	" + CppStringUtils.comments(code, "	//	") + "\n" +
					closeProtectedArea(cls, method);
		else
			return	openProtectedArea(cls, method) +
					code + "\n" +
					closeProtectedArea(cls, method);
	}
	//======================================================================
	public String protectedArea(PogoDeviceClass cls, String method) {
		return openProtectedArea(cls.getName(), method) +
				closeProtectedArea(cls.getName(), method);
	}
	//======================================================================
	
	
	
	
	
	
	
	//======================================================================
	// Define cpp protected areas for deviceClass
	//======================================================================
	public String protectedAreaClass(PogoDeviceClass cls, String method, String code, boolean comments) {
		if (comments)
			return openProtectedArea(cls.getName() + "Class", method) +
					"//	" + CppStringUtils.comments(code, "	//	") + "\n" +
					closeProtectedArea(cls.getName() + "Class", method);
		else
			return	openProtectedArea(cls.getName()+"Class", method) +
					code + "\n" +
					closeProtectedArea(cls.getName()+"Class", method);
	}
	//======================================================================
	public String protectedAreaClass(PogoDeviceClass cls, String method) {
		return openProtectedArea(cls.getName() + "Class", method) +
				closeProtectedArea(cls.getName() + "Class", method);
	}



	//======================================================================
	// Define cpp protected areas for Multi Classes
	//======================================================================
	public String openProtectedArea(PogoMultiClasses multi, String method) {
		return openProtectedArea("multi-"+multi.getName(), method);
	}
	//======================================================================
	public String closeProtectedArea(PogoMultiClasses multi, String method) {
		return closeProtectedArea("multi-"+multi.getName(), method);
	}
}
