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

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import fr.esrf.tango.pogo.generator.java.JavaAttribute
import fr.esrf.tango.pogo.generator.java.JavaDynamicAttribute
import fr.esrf.tango.pogo.generator.java.JavaCommand
import com.google.inject.Inject
import static extension fr.esrf.tango.pogo.generator.common.StringUtils.*
import fr.esrf.tango.pogo.generator.common.Headers
import fr.esrf.tango.pogo.pogoDsl.Property
import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.pogoDsl.Command

class JavaDevice  implements IGenerator {

	@Inject extension JavaUtils
	@Inject extension JavaAttribute
	@Inject extension JavaPipe
	@Inject extension JavaDynamicAttribute
	@Inject extension JavaDynamicCommand
	@Inject extension JavaCommand
	@Inject extension ProtectedArea
	@Inject extension Headers

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		for (cls : resource.allContents.toIterable.filter(typeof(PogoDeviceClass))) {
			//	Code files
			if (cls.description.language.toLowerCase.equals("java")) {
					if (cls.description.filestogenerate.contains("Code files")) {
					printTrace("Generating " + cls.javaDeviceClassFileName(true))
					fsa.generateFile(cls.javaDeviceClassFileName(true),     cls.generateJavaDeviceFile)
					
					//	Check for dynamic commands
					if (cls.dynamicCommands.empty==false) {
						for (Command command : cls.dynamicCommands) {
							printTrace("Generating " + cls.javaDynamicObjectFileName(command.name))
							fsa.generateFile(cls.javaDynamicObjectFileName(command.name),
												cls.generateJavaDynamicCommandClassFile(command))
						}
					}
					//	Check for dynamic attributes
					if (cls.dynamicAttributes.empty==false) {
						for (Attribute attribute : cls.dynamicAttributes) {
							printTrace("Generating " + cls.javaDynamicObjectFileName(attribute.name))
							fsa.generateFile(cls.javaDynamicObjectFileName(attribute.name),
												cls.generateJavaDynamicAttributeClassFile(attribute))
						}
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
		public class «cls.name»«cls.getInheritance» {
		
			«IF cls.hasInheritanceClass==false»
			    protected static final Logger logger = LoggerFactory.getLogger(«cls.name».class);
			    protected static final XLogger xlogger = XLoggerFactory.getXLogger(«cls.name».class);
			«ENDIF»

			//=========================================
			// Define constants for attributes
			//=========================================
			«cls.attributeConstants»

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
			«IF cls.forwardedAttributes.size>0»
				«cls.addForwardedAttributes»
			«ENDIF»

			«cls.deleteDeviceMethod»

			«cls.aroundInvokeMethod»

			«cls.dynamicManagerMethod»


			«IF cls.attributes.size>0»
				//========================================================
				//	Attribute data members and related methods
				//========================================================
				«cls.attributeMethods»
			«ENDIF»
		
			«IF cls.pipes.size>0»
				//========================================================
				//	Pipe data members and related methods
				//========================================================
				«cls.pipeMethods»
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
			cls.name + " are implemented in this file.",
			cls.description.title,
			cls.description.license,
			cls.description.copyright
		)»

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
				"import org.tango.server.annotation.DeviceManagement;\n" +
				"import org.tango.server.annotation.Pipe;\n" +
				"import org.tango.server.attribute.ForwardedAttribute;" +
				"import org.tango.server.pipe.PipeValue;\n"+ 
				"import org.tango.server.dynamic.DynamicManager;\n" +
				"import org.tango.server.device.DeviceManager;\n" +
				"import org.tango.server.dynamic.DynamicManager;\n" +
				"import org.tango.server.events.EventManager;\n" +
				"import org.tango.server.events.EventType;\n" +
				"import org.tango.utils.DevFailedUtils;\n" +
				"\n" +
				"//	Import Tango IDL types\n" +
				"import fr.esrf.Tango.*;\n" +
				"import fr.esrf.TangoDs.Except;\n"+
				"import fr.esrf.TangoApi.PipeBlob;\n" +
				"import fr.esrf.TangoApi.PipeDataElement;"+
				cls.inheritancePackage,
				false)»
	'''

	//======================================================
	// define constants for attributes
	//======================================================
	def attributeConstants(PogoDeviceClass cls) '''
		«FOR Attribute attribute : cls.attributes»
			«IF attribute.concreteHere»
				«attribute.attributeConstant»
			«ENDIF»
		«ENDFOR»
	'''

	//======================================================
	// define code for class properties
	//======================================================
	def addClassProperties(PogoDeviceClass cls) '''
		«FOR Property property : cls.classProperties»
			«IF property.isConcreteHere»
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
					this.«property.name.dataMemberName» = «property.name.dataMemberName»;
					«cls.protectedArea("set" + property.name, "Check property value here", true)»
				}

			«ENDIF»
		«ENDFOR»
	'''

	//======================================================
	// define code for device properties
	//======================================================
	def addDeviceProperties(PogoDeviceClass cls) '''
		«FOR Property property : cls.deviceProperties»
			«IF property.isConcreteHere»
				/**
				 * Device Property «property.name»
				 * «property.description.comments("* ")»
				 */
				@DeviceProperty(name="«property.name»", description="«property.description.oneLineString»" «property.defaultValue» «property.isMandatory»)
				private «property.strJavaType» «property.name.dataMemberName»;
				/**
				 * set property «property.name»
				 * @param  «property.name.dataMemberName»  see description above.
				 */
				public void set«property.name»(«property.strJavaType» «property.name.dataMemberName») {
					this.«property.name.dataMemberName» = «property.name.dataMemberName»;
					«cls.protectedArea("set" + property.name, "Check property value here", true)»
				}

			«ENDIF»
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
		public void initDevice() throws DevFailed {
			xlogger.entry();
			logger.debug("init device " + deviceManager.getName());
			«IF cls.hasInheritanceClass»super.initDevice();«ENDIF»
			«cls.protectedArea("initDevice", "Put your device initialization code here", true)»
			«IF cls.forwardedAttributes.size>0»
				addForwardedAttributes();
			«ENDIF»
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
		 * @throws DevFailed if something fails during the device object deletion.
		 */
		@Delete
		public void deleteDevice() throws DevFailed {
			xlogger.entry();
			«IF cls.hasInheritanceClass»super.deleteDevice();«ENDIF»
			«cls.protectedArea("deleteDevice", "Put your device clearing code here", true)»
			xlogger.exit();
		}
	'''
	//======================================================
	// define code for always_executed_hook method like
	//======================================================
	def aroundInvokeMethod(PogoDeviceClass cls) '''
		«IF cls.hasInheritanceClass==false»
			/**
			 * Method called before and after command and attribute calls.
			 * @param ctx the invocation context
			 * @throws DevFailed if something fails during this method execution.
			 */
			@AroundInvoke
			public void aroundInvoke(final InvocationContext ctx) throws DevFailed {
				xlogger.entry();
				«IF cls.hasInheritanceClass»
					«cls.protectedArea("aroundInvoke", "super.aroundInvoke(ctx);", false)»
				«ELSE»
					«cls.protectedArea("aroundInvoke", "Put aroundInvoke code here", true)»
				xlogger.exit();
				«ENDIF»
			}
		«ENDIF»
	'''
	//======================================================
	// define code for setDynamicManager method like
	//======================================================
	def dynamicManagerMethod(PogoDeviceClass cls) '''

		/**
		 * dynamic command and attribute management. Will be injected by the framework.
		 */
		@DynamicManagement
		protected DynamicManager dynamicManager;
		/**
		 * @param dynamicManager the DynamicManager instance 
		 * @throws DevFailed if something fails during this method execution.
		 */
		public void setDynamicManager(final DynamicManager dynamicManager) throws DevFailed {
			this.dynamicManager = dynamicManager;
			«IF cls.hasInheritanceClass»super.setDynamicManager(dynamicManager);«ENDIF»
			«cls.protectedArea("setDynamicManager", "Put your code here", true)»
		}

		/**
		 * Device management. Will be injected by the framework.
		 */
		@DeviceManagement
		DeviceManager deviceManager;
		public void setDeviceManager(DeviceManager deviceManager){
			this.deviceManager= deviceManager ;
			«IF cls.hasInheritanceClass»super.setDeviceManager(deviceManager);«ENDIF»
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
			«cls.protectedArea("main")»
			ServerManager.getInstance().start(args, «cls.name».class);
			System.out.println("------- Started -------------");
		}
	'''

}