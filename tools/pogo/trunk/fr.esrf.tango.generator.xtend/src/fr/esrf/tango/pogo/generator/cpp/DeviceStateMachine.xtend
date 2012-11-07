package fr.esrf.tango.pogo.generator.cpp

import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import com.google.inject.Inject
import static org.eclipse.xtext.xtend2.lib.ResourceExtensions.*
import static extension fr.esrf.tango.pogo.generator.cpp.utils.ProtectedArea.*
import static extension fr.esrf.tango.pogo.generator.cpp.utils.CppStringUtils.*
import fr.esrf.tango.pogo.generator.cpp.utils.ProtectedArea
import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.pogoDsl.Command
import fr.esrf.tango.pogo.generator.cpp.utils.InheritanceUtils
import fr.esrf.tango.pogo.generator.cpp.utils.Headers
import fr.esrf.tango.pogo.generator.cpp.utils.CppStringUtils


//======================================================
// Define Device state machine .cpp file to be generated
//======================================================
class DeviceStateMachine {
	
	@Inject	extension ProtectedArea
	@Inject	extension CppStringUtils
	@Inject	extension Headers
	@Inject	extension InheritanceUtils

	//======================================================
	// Define ClassFactory.cpp file to be generated
	//======================================================
	def generateStateMachineSourceFile (PogoDeviceClass cls) '''
		«cls.fileHeader»
		
		«cls.states.statesTable»


		namespace «cls.name»_ns
		{
		//=================================================
		//		Attributes Allowed Methods
		//=================================================
		«cls.attributesStateMachine»

		//=================================================
		//		Commands Allowed Methods
		//=================================================
		«cls.commandsStateMachine»

		}	//	End of namespace
	'''

	//======================================================
	// define the header file
	//======================================================
	def fileHeader (PogoDeviceClass cls) '''
		«(cls.name+"StateMachine").openProtectedArea(".cpp")»
		«cls.stateMachineFileHeader»
		
		#include <«cls.name».h>
		
		«cls.closeProtectedArea(cls.stateMachineFileName)»
	'''
	
	
	
	
	//======================================================
	// define commands State Machine
	//======================================================
	def commandsStateMachine(PogoDeviceClass cls) '''
		«FOR Command command : cls.commands»
			«IF command.name.equals("State")==false && command.name.equals("Status")==false»
				«IF command.overrides==false»
					«cls.commandStateMachine(command)»
				«ENDIF»
			«ENDIF»
		«ENDFOR»
	'''
	
	//======================================================
	// define one command State Machine
	//======================================================
	def commandStateMachine(PogoDeviceClass cls, Command command) '''
		
		«cls.simpleMethodHeader("is_"+command.name+"_allowed", "Execution allowed for "+command.name+" attribute")»
		bool «cls.name»::is_«command.name»_allowed(TANGO_UNUSED(const CORBA::Any &any))
		{
			«IF command.excludedStates.empty»
				//	Not any excluded states for «command.name» command.
				«cls.protectedArea(command.name+"StateAllowed")»
				return true;
			«ELSE»
				//	Compare device state with not allowed states.
				if («command.excludedStates.ifContentFromList»)
				{
				«cls.protectedArea(command.name+"StateAllowed")»
					return false;
				}
				return true;
			«ENDIF»
		}
	'''
	
	//======================================================
	// define attributes State Machine
	//======================================================
	def attributesStateMachine(PogoDeviceClass cls) '''
		«FOR Attribute attribute : cls.attributes»
			«IF attribute.alreadyOverloaded==false»
				«cls.attributeStateMachine(attribute)»
			«ENDIF»
		«ENDFOR»
		«FOR Attribute attribute : cls.dynamicAttributes»
			«cls.attributeStateMachine(attribute)»
		«ENDFOR»
	'''


	//======================================================
	// define one attribute State Machine
	//======================================================
	def attributeStateMachine(PogoDeviceClass cls, Attribute attribute) '''
		
		«cls.simpleMethodHeader("is_"+attribute.name+"_allowed", "Execution allowed for "+attribute.name+" attribute")»
		bool «cls.name»::is_«attribute.name»_allowed(TANGO_UNUSED(Tango::AttReqType type))
		{
			«IF attribute.isWrite»
				«IF attribute.writeExcludedStates.empty»
					//	Not any excluded states for «attribute.name» attribute in Write access.
					«cls.protectedArea(attribute.name+"StateAllowed_WRITE")»
				«ELSE»
					//	Check access type.
					if ( type!=Tango::READ_REQ )
					{
						//	Compare device state with not allowed states for WRITE 
						if («attribute.writeExcludedStates.ifContentFromList»)
						{
						«cls.protectedArea(attribute.name+"StateAllowed_WRITE")»
							return false;
						}
						return true;
					}
					«IF attribute.isRead»
					else
					«ENDIF»
				«ENDIF»
			«ENDIF»

			«IF attribute.isRead»
				«IF attribute.readExcludedStates.empty»
					//	Not any excluded states for «attribute.name» attribute in read access.
					«cls.protectedArea(attribute.name+"StateAllowed_READ")»
				«ELSE»
					//	Check access type.
					if ( type==Tango::READ_REQ )
					{
						//	Compare device state with not allowed states for READ 
						if («attribute.readExcludedStates.ifContentFromList»)
						{
						«cls.protectedArea(attribute.name+"StateAllowed_READ")»
							return false;
						}
						return true;
					}
				«ENDIF»
			«ENDIF»
			return true;
		}
	'''

	
	
}