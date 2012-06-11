package fr.esrf.tango.pogo.generator.cpp

import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import com.google.inject.Inject
import static org.eclipse.xtext.xtend2.lib.ResourceExtensions.*
import org.eclipse.emf.ecore.resource.Resource
import static extension fr.esrf.tango.pogo.generator.cpp.global.ProtectedArea.*
import fr.esrf.tango.pogo.generator.cpp.global.ProtectedArea


//======================================================
// Define main.cpp file to be generated
//======================================================
class Main implements IGenerator {
	@Inject
	extension ProtectedArea
	@Inject
	extension fr.esrf.tango.pogo.generator.cpp.global.Headers

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		for (cls : allContentsIterable(resource).filter(typeof(PogoDeviceClass))) {
			fsa.generateFile("main.cpp", cls.generateMainFile)
		}
	}


	//======================================================
	// Define main.cpp file to be generated
	//======================================================
	def generateMainFile (PogoDeviceClass cls) '''
		«cls.openProtectedArea("main.cpp")»
		«cls.mainFileHeader»
		
		#include <tango.h>
		
		int main(int argc,char *argv[])
		{
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
				cout << "Ready to accept request" << endl;
				tg->server_run();
			}
			catch (bad_alloc)
			{
				cout << "Can't allocate memory to store device object !!!" << endl;
				cout << "Exiting" << endl;
			}
			catch (CORBA::Exception &e)
			{
				Tango::Except::print_exception(e);
				
				cout << "Received a CORBA_Exception" << endl;
				cout << "Exiting" << endl;
			}
			Tango::Util::instance()->server_cleanup();
			return(0);
		}
		«cls.closeProtectedArea("main.cpp")»
	'''

}