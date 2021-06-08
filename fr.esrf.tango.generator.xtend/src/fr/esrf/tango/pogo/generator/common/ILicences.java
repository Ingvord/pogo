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


//======================================================
//	licenses for Tango classes
//======================================================
interface ILicences {

    static final int GPL    = 0;
    static final int LGPL   = 1;
    static final int APACHE = 2;
    static final int MIT    = 3;
    static final int BSD3   = 4;
    static final int NONE   = 5;
/*
	static String licenseText(String licence, String commentTag) {
		if (licence!=null && licence.equals("none"))
			return "";
		
		if (licence!=null && licence.equals("APACHE"))
	*/
    static final String	apacheLicenece =
					" This file is part of Tango device class.\n" +
					"\n"+
					" Tango is free software: you can redistribute it and/or modify\n" +
					" it under the terms of the APACHE licence.\n";
		
    static final String	mitLicenece =
					" This file is part of Tango device class.\n" +
					"\n"+
					" Tango is free software: you can redistribute it and/or modify\n" +
					" it under the terms of the MIT licence.\n";
    
    static final String	bsdLicenece =
					" This file is part of Tango device class.\n" +
					"\n"+
					" Tango is free software: you can redistribute it and/or modify\n" +
					" it under the terms of the BSD-3 Clause licence.\n";

    static final String	gplLicenece =
					" This file is part of Tango device class.\n" +
					"\n"+
					" Tango is free software: you can redistribute it and/or modify\n" +
					" it under the terms of the GNU General Public License as published by\n" +
					" the Free Software Foundation, either version 3 of the License, or\n" +
					" (at your option) any later version.\n" +
					"\n" +
					" Tango is distributed in the hope that it will be useful,\n" +
					" but WITHOUT ANY WARRANTY; without even the implied warranty of\n" +
					" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n" +
					" GNU General Public License for more details.\n" +
					"\n" +
					" You should have received a copy of the GNU General Public License\n" +
					" along with Tango.  If not, see <http://www.gnu.org/licenses/>.\n";
}
