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
import fr.esrf.tango.pogo.pogoDsl.PogoMultiClasses


//======================================================
// Define main.cpp file to be generated
//======================================================
class Main {
	@Inject	extension ProtectedArea
	@Inject	extension fr.esrf.tango.pogo.generator.cpp.utils.Headers

	//======================================================
	// Define main.cpp file to be generated
	//======================================================
	def generateMainFile (PogoDeviceClass cls) '''
		«cls.openProtectedArea("main.cpp")»
		«cls.mainFileHeader»
		«mainCode»

		«cls.closeProtectedArea("main.cpp")»
	'''

	//======================================================
	// Define main.cpp file to be generated
	//======================================================
	def generateMainFile (PogoMultiClasses multi) '''
		«multi.mainFileHeader»
		«mainCode»
	'''

	def mainCode() '''
		#include <tango.h>
		
		// Check if crash reporting is used.
		#if defined(ENABLE_CRASH_REPORT)
		#  include <crashreporting/crash_report.h>
		#else
		#  define DECLARE_CRASH_HANDLER
		#  define INSTALL_CRASH_HANDLER
		#endif
		
		DECLARE_CRASH_HANDLER

		int main(int argc,char *argv[])
		{
			INSTALL_CRASH_HANDLER
			try
			{
				// Initialise the device server
				//----------------------------------------
				Tango::Util *tg = Tango::Util::init(argc,argv);
		
				// Create the device server singleton
				//	which will create everything
				//----------------------------------------
				tg->server_init(false);
		
				// Run the endless loop
				//----------------------------------------
				std::cout << "Ready to accept request" << std::endl;
				tg->server_run();
			}
			catch (std::bad_alloc &)
			{
				std::cout << "Can't allocate memory to store device object !!!" << std::endl;
				std::cout << "Exiting" << std::endl;
			}
			catch (CORBA::Exception &e)
			{
				Tango::Except::print_exception(e);
		
				std::cout << "Received a CORBA_Exception" << std::endl;
				std::cout << "Exiting" << std::endl;
			}
			Tango::Util::instance()->server_cleanup();
			return(0);
		}
	'''
}
