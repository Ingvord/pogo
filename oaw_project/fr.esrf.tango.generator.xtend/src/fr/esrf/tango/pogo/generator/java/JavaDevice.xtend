package fr.esrf.tango.pogo.generator.java

import static org.eclipse.xtext.xtend2.lib.ResourceExtensions.*
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import static extension fr.esrf.tango.pogo.generator.java.JavaUtils.*
import static extension fr.esrf.tango.pogo.generator.java.ProtectedArea.*
import static extension fr.esrf.tango.pogo.generator.java.JavaTypeDefinitions.*
import fr.esrf.tango.pogo.generator.java.JavaAttribute
import fr.esrf.tango.pogo.generator.java.JavaDynamicAttribute
import fr.esrf.tango.pogo.generator.java.JavaCommand
import com.google.inject.Inject
import static extension fr.esrf.tango.pogo.generator.common.StringUtils.*
import fr.esrf.tango.pogo.generator.common.StringUtils
import fr.esrf.tango.pogo.generator.common.Headers
import fr.esrf.tango.pogo.pogoDsl.Property
import fr.esrf.tango.pogo.pogoDsl.Attribute

class JavaDevice  implements IGenerator {

	@Inject extension JavaUtils
	@Inject extension JavaAttribute
	@Inject extension JavaDynamicAttribute
	@Inject extension JavaCommand
	@Inject extension ProtectedArea
	@Inject extension StringUtils
	@Inject extension Headers

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		for (cls : allContentsIterable(resource).filter(typeof(PogoDeviceClass))) {
			//	Code files
			if (cls.description.language.toLowerCase.equals("java")) {
					if (cls.description.filestogenerate.contains("Code files")) {
					printTrace("Generating " + cls.javaDeviceClassFileName(true))
					fsa.generateFile(cls.javaDeviceClassFileName(true),     cls.generateJavaDeviceFile)
					
					//	Check for dynamic attributes
					if (cls.dynamicAttributes.empty==false)
						for (Attribute attribute : cls.dynamicAttributes) {
							printTrace("Generating " + cls.javaDynamicAttributeFileName(attribute.name))
							fsa.generateFile(cls.javaDynamicAttributeFileName(attribute.name),
												cls.generateJavaDynamicAttributeClassFile(attribute))
						}
				}
			}
		}
	}



	//======================================================
	// define the java file for class
	//======================================================
	def generateJavaDeviceFile (PogoDeviceClass cls) '''
		«cls.javaHeader»

		/**
		 *  «cls.name» class description:
		 *    «cls.description.description.comments("*    ")»
		 */
		
		@Device
		public class «cls.name» {
		
		    private static final Logger logger = LoggerFactory.getLogger(«cls.name».class);
		    private static final XLogger xlogger = XLoggerFactory.getXLogger(«cls.name».class);
			//========================================================
			//	Programmer's data members
			//========================================================
		    «cls.protectedArea("variables", "Put static variables here", true)»
			«cls.protectedArea("private", "Put private variables here", true)»
		
			//========================================================
			//	Property data members and related methods
			//========================================================
			«cls.addClassProperties»
			«cls.addDeviceProperties»


			//========================================================
			//	Miscellaneous methods
			//========================================================
			«cls.initDeviceMethod»

			«cls.deleteDeviceMethod»

			«cls.aroundInvokeMethod»

			«cls.dynamicManagerMethod»


			«IF cls.attributes.size>0»
				//========================================================
				//	Attribute data members and related methods
				//========================================================
				«cls.attributeMethods»
			«ENDIF»

			«IF cls.commands.size>0»
				//========================================================
				//	Command data members and related methods
				//========================================================
				«cls.stateAndStatusMethods»
				
				«cls.executeCommandMethods»
			«ENDIF»

			//========================================================
			//	Programmer's methods
			//========================================================
			«cls.protectedArea("methods", "Put your own methods here", true)»


			«cls.mainMethod»
		}
	'''

	
	
	//======================================================
	// define the header file and imports
	//======================================================
	def javaHeader(PogoDeviceClass cls) '''
		«cls.openProtectedArea(".java")»
		«cls.javaDeviceClassFileName(false).fileHeader(
			"Java source for the " + cls.name + " class and its commands.\n" +
			"The class is derived from Device. It represents the\n" +
			"CORBA servant object which will be accessed from the\n" +
			"network. All commands which can be executed on the\n" +
			cls.name + " are implemented in this file.",  cls.description.title)»

		«cls.closeProtectedArea(".java")»

		package «cls.javaDevicePackage»;

		«cls.protectedArea("imports", 
				"import org.slf4j.Logger;\n" +
				"import org.slf4j.LoggerFactory;\n" +
				"import org.slf4j.ext.XLogger;\n" +
				"import org.slf4j.ext.XLoggerFactory;\n" +
				"import org.tango.DeviceState;\n" +
				"import org.tango.server.InvocationContext;\n" +
				"import org.tango.server.ServerManager;\n" +
				"import org.tango.server.annotation.AroundInvoke;\n" +
				"import org.tango.server.annotation.Attribute;\n" +
				"import org.tango.server.annotation.AttributeProperties;\n" +
				"import org.tango.server.annotation.ClassProperty;\n" +
				"import org.tango.server.annotation.Command;\n" +
				"import org.tango.server.annotation.Delete;\n" +
				"import org.tango.server.annotation.Device;\n" +
				"import org.tango.server.annotation.DeviceProperty;\n" +
				"import org.tango.server.annotation.DynamicManagement;\n" +
				"import org.tango.server.annotation.Init;\n" +
				"import org.tango.server.annotation.State;\n" +
				"import org.tango.server.annotation.StateMachine;\n" +
				"import org.tango.server.annotation.Status;\n" +
				"import org.tango.server.dynamic.DynamicManager;\n" +
				"import org.tango.utils.DevFailedUtils;\n" +
				"\n" +
				"//	Import Tango IDL types\n" +
				"import fr.esrf.Tango.*;",
				false)»
	'''


	//======================================================
	// define code for class properties
	//======================================================
	def addClassProperties(PogoDeviceClass cls) '''
		«FOR Property property : cls.classProperties»
			/**
			 * Class Property «property.name»
			 * «property.description.comments("* ")»
			 */
			@ClassProperty(name="«property.name»", description="«property.description.oneLineString»" «property.defaultValue»)
			private «property.strJavaType» «property.name.dataMemberName»;
			/**
			 * set property «property.name»
			 * @param  «property.name.dataMemberName»  see description above.
			 */
			public void set«property.name»(«property.strJavaType» «property.name.dataMemberName») {
				«cls.protectedArea("set" + property.name, "Check property value here", true)»
				this.«property.name.dataMemberName» = «property.name.dataMemberName»;
			}
			
		«ENDFOR»
	'''

	//======================================================
	// define code for device properties
	//======================================================
	def addDeviceProperties(PogoDeviceClass cls) '''
		«FOR Property property : cls.deviceProperties»
			/**
			 * Device Property «property.name»
			 * «property.description.comments("* ")»
			 */
			@DeviceProperty(name="«property.name»", description="«property.description.oneLineString»" «property.defaultValue»)
			private «property.strJavaType» «property.name.dataMemberName»;
			/**
			 * set property «property.name»
			 * @param  «property.name.dataMemberName»  see description above.
			 */
			public void set«property.name»(«property.strJavaType» «property.name.dataMemberName») {
				«cls.protectedArea("set" + property.name, "Check property value here", true)»
				this.«property.name.dataMemberName» = «property.name.dataMemberName»;
			}
			
		«ENDFOR»
	'''

	//======================================================
	// define code for init device method
	//======================================================
	def initDeviceMethod(PogoDeviceClass cls) '''
		/**
		 * Initialize the device.
		 * 
		 * @throws DevFailed if something fails during the device initialization.
		 */
		@Init(lazyLoading = false)
		public final void initDevice() throws DevFailed {
			xlogger.entry();
			logger.debug("init");
			«cls.protectedArea("initDevice", "Put your device initialization code here", true)»
			xlogger.exit();
		}
	'''
	//======================================================
	// define code for delete device method
	//======================================================
	def deleteDeviceMethod(PogoDeviceClass cls) '''
		/**
		 * all resources may be closed here. Collections may be also cleared.
		 * 
		 * @throws DevFailed if something fails during the device object delation.
		 */
		@Delete
		public final void deleteDevice() throws DevFailed {
			xlogger.entry();
			«cls.protectedArea("deleteDevice", "Put your device clearing code here", true)»
			xlogger.exit();
		}
	'''
	//======================================================
	// define code for always_executed_hook method like
	//======================================================
	def aroundInvokeMethod(PogoDeviceClass cls) '''
		/**
		 * Method called before and after command and attribute calls.
		 * @param ctx the invocation context
		 * @throws DevFailed if something fails during the this method execution.
		 */
		@AroundInvoke
		public final void aroundInvoke(final InvocationContext ctx) throws DevFailed {
			xlogger.entry(ctx);
			«cls.protectedArea("aroundInvoke", "Put aroundInvoke code here", true)»
			xlogger.exit();
		}
	'''
	//======================================================
	// define code for setDynamicManager method like
	//======================================================
	def dynamicManagerMethod(PogoDeviceClass cls) '''

		/**
		 * dynamic command and attribute management. Will be injected by the framework.
		 */
		@DynamicManagement
		private DynamicManager dynamicManager;
		/**
		 * @param dynamicManager the DynamicManager instance 
		 */
		public void setDynamicManager(final DynamicManager dynamicManager) {
			this.dynamicManager = dynamicManager;
			«cls.protectedArea("setDynamicManager", "Put your code here", true)»
		}
	'''

	//======================================================
	// define code for main method
	//======================================================
	def mainMethod(PogoDeviceClass cls) '''




		/**
		 * Starts the server.
		 * @param args program arguments (instance_name [-v[trace level]]  [-nodb [-dlist <device name list>] [-file=fileName]])
		 */
		public static void main(final String[] args) {
			ServerManager.getInstance().start(args, «cls.name».class);
			System.out.println("------- Started -------------");
		}
	'''

}