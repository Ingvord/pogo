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

package fr.esrf.tango.pogo.generator.python

import fr.esrf.tango.pogo.pogoDsl.Command
import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.pogoDsl.ForwardedAttribute
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import fr.esrf.tango.pogo.pogoDsl.ForwardedAttribute
import fr.esrf.tango.pogo.pogoDsl.Property
import fr.esrf.tango.pogo.pogoDsl.Pipe
import com.google.inject.Inject
import static extension fr.esrf.tango.pogo.generator.python.PythonTypeDefinitions.*
import static extension fr.esrf.tango.pogo.generator.common.StringUtils.*
import org.eclipse.emf.common.util.BasicEList

class PythonUtils {
    @Inject extension fr.esrf.tango.pogo.generator.common.StringUtils
    @Inject extension ProtectedArea
    @Inject extension ProtectedAreaHL
    @Inject extension fr.esrf.tango.pogo.generator.python.PythonTypeDefinitions    
	@Inject	extension fr.esrf.tango.pogo.generator.python.PyUtils
        
   
    def commentMultiLinesPython(PogoDeviceClass cls){
        cls.description.description.replaceAll("\n","\n#                ");
    }
      
    def formatComaToPoint(String str){
    	if (str !== null)
    	{
	    	if (str.contains(","))
	    	{
	    		return str.replaceAll(",",".");
	    	}
	    	else
	    	{
	    		return str;
	    	}
    	}
    	else
    	{
    		return str;
    	}
    }   
      
    def stringListToStringArray(String str){
    	if (str !== null)
    	{
	    	if (str.contains(","))
	    	{
	    		return "[\"" + str.substring(1, str.length()-1).replaceAll(", ",",").replaceAll(",","\", \"") + "\"]";
	    	}
	    	else if (str.contains(" "))
	    	{
	    		return "[\"" + str.substring(1, str.length()-1)+"\"]";
	    	}
	    	else
	    	{
	    		return "[" + str + "]";
	    	}
    	}
    	else
    	{
    		return str;
    	}
    }
     
    def stringToPyth(String str){
    	if (str !== null)
    	{
	    	if (str == "true")
	    	{
	    		return "True";
	    	}
	    	else
	    	{
		    	if (str == "false")
		    	{
		    		return "False";
		    	}
		    	else
		    	{
	    			return str;
		    	}
	    	}
    	}
    	else
    	{
    		return str;
    	}
    }

    def commentMultiLinesPythonStr(String str){
    	if (str !== null)
    	{
    		if (!str.empty)
    		{
				return " " + myReplaceAll(str,"\n","\n# ");
    		}
    		else
    		{
    			return "";
    		}
    	}
    	else
    	{
    		return "";
    	}
    }
    def commentMultiLinesInputDescriptionStr(String str){
    	if (str !== null)
    	{
    		if (!str.empty)
    		{
				return "" + myReplaceAll(str,"\n","\"\n               \"");
    		}
    		else
    		{
    			return "" ;
    		}
    	}
    	else
    	{
    		return "" ;
    	}
    }
    
    def commentMultiLinesOutputDescriptionStr(String str){
    	if (str !== null)
    	{
    		if (!str.empty)
    		{
				return "" + myReplaceAll(str,"\n","\"\n                \"");
    		}
    		else
    		{
    			return "" ;
    		}
    	}
    	else
    	{
    		return "" ;
    	}
    }
        
    def commentCmdParamMultiLines(String str){
    	if (str.contains("\n"))
    	{
    		return "    " + myReplaceAll(str, "\n","\n    ");
    	}
    	else
    	{
    		return str;
    	}
    }
    
    def isMemorized(Attribute attr) {
        if (attr.write)    {
            if (attr.memorized!==null) {
                if (attr.memorized == "true") {
                    if(attr.memorizedAtInit == "true") {
                        return "    \'Memorized\':\"true\""; 
                    }
                    else {
                        return "    \'Memorized\':\"true_without_hard_applied\"";
                    }
                }
            }
        }
        return "";
    }
    
    def hasAttrPropertySet(Attribute attr){
        return (
        	(attr.memorized!==null && !attr.memorized.empty) ||
            (attr.properties.label !== null && !attr.properties.label.empty)         		||
            (attr.properties.unit !== null && !attr.properties.unit.empty)       		||
            (attr.properties.standardUnit !== null && !attr.properties.standardUnit.empty)		||
            (attr.properties.displayUnit !== null && !attr.properties.displayUnit.empty) 		||
            (attr.properties.format !== null && !attr.properties.format.empty )     		||
            (attr.properties.maxValue !== null && !attr.properties.maxValue.empty )   		||
            (attr.properties.minValue !== null && !attr.properties.minValue.empty )    		||
            (attr.properties.maxAlarm !== null && !attr.properties.maxAlarm.empty )   		||
            (attr.properties.minAlarm !== null && !attr.properties.minAlarm.empty )   		||
            (attr.properties.maxWarning !== null && !attr.properties.maxWarning.empty ) 		||
            (attr.properties.minWarning !== null && !attr.properties.minWarning.empty ) 		||
            (attr.properties.deltaTime !== null && !attr.properties.deltaTime.empty  ) 		||
            (attr.properties.deltaValue !== null && !attr.properties.deltaValue.empty ) 		||
            (attr.properties.description !== null && !attr.properties.description.empty ) 		||
            !attr.polledPeriod.equals("0")     		||
            attr.eventCriteria!==null           		||
            attr.eventCriteria!==null);
    }
    
    def hasAttrPropertySetHL(Attribute attr){
        return (
        	(attr.memorized!==null && !attr.memorized.empty) ||
            (attr.properties.label !== null && !attr.properties.label.empty)         		||
            (attr.properties.unit !== null && !attr.properties.unit.empty)       		||
            (attr.properties.standardUnit !== null && !attr.properties.standardUnit.empty)		||
            (attr.properties.displayUnit !== null && !attr.properties.displayUnit.empty) 		||
            (attr.properties.format !== null && !attr.properties.format.empty )     		||
            (attr.properties.maxValue !== null && !attr.properties.maxValue.empty )   		||
            (attr.properties.minValue !== null && !attr.properties.minValue.empty )    		||
            (attr.properties.maxAlarm !== null && !attr.properties.maxAlarm.empty )   		||
            (attr.properties.minAlarm !== null && !attr.properties.minAlarm.empty )   		||
            (attr.properties.maxWarning !== null && !attr.properties.maxWarning.empty ) 		||
            (attr.properties.minWarning !== null && !attr.properties.minWarning.empty ) 		||
            (attr.properties.deltaTime !== null && !attr.properties.deltaTime.empty  ) 		||
            (attr.properties.deltaValue !== null && !attr.properties.deltaValue.empty ) 		||
            (attr.properties.description !== null && !attr.properties.description.empty ) 		||
            attr.displayLevel.equals("EXPERT") 		||
            !attr.polledPeriod.equals("0")     		||
            attr.eventCriteria!==null           		||
            attr.getAttType().equals("Spectrum")	||
            attr.getAttType().equals("Image")		||
            attr.eventCriteria!==null)				||
            (attr.enumLabels !== null && attr.enumLabels.size > 0);
    }
    
    def hasCmdPropertySet(Command cmd){
        return (cmd.displayLevel.equals("EXPERT") || !cmd.polledPeriod.equals("0"));
    }
    
    def hasCmdArginOrArgoutSet(Command cmd){
        return (!cmd.argin.type.voidType || !cmd.argout.type.voidType );
    }
    
    def hasPipePropertySetHL(Pipe pip){
        return (
            (pip.label !== null && !pip.label.empty) 		||
            (pip.description !== null && !pip.description.empty ) 		||
            pip.displayLevel.equals("EXPERT") 		||
            (pip.rwType.contains("WRITE"))
            )
    }
    
    def enumLabelsWithNumber(Attribute attr){
    	var enumVal = 0
    	var String labelList = ""
    	for(label: attr.enumLabels){
    		labelList = labelList + label + " = " + enumVal.toString +"\n"
    		enumVal = enumVal +1
   		}
    	return labelList
    }
    
    def enumLabelWithInvalidChars (Attribute attr){
    	var enumVal = 0
    	var String labelList = ""
    	for(label: attr.enumLabels){
    		labelList = labelList + "(\""+ label + "\", " + enumVal.toString +"),\n"
    		enumVal = enumVal +1
   		}
	    return labelList
    }
    
    def String checkEnumLabels (Attribute attr){
    	var flag = "valid"
    	for(label: attr.enumLabels){
    	 	if(label.contains("-")||label.contains("+")||label.contains("=")||label.contains("%")||label.contains("*")||label.charAt(0).toString.matches("[0-9]")){
    	 	flag = "invalid"
    		}
    	}
    	return flag
    }
    
    def enumAttrCheck (PogoDeviceClass cls){
    	var enumAttr = false
    	for(attr:cls.attributes){
    		if(attr.dataType.pythonTypeHL.equalsIgnoreCase("'DevEnum'")){
    			enumAttr = true
    		}
    	}
    	return enumAttr    	
    }
     
    def commandExecution(PogoDeviceClass cls, Command cmd) '''
		def «cmd.methodName»(self«IF !cmd.argin.type.voidType», argin«ENDIF»):
		    """ «cmd.description»
		    «IF !cmd.argin.type.voidType»
		    :param argin: «cmd.argin.description.commentCmdParamMultiLines»
		    :type argin: «cmd.argin.type.pythonType»
		    «ENDIF»
		    «IF !cmd.argout.type.voidType»
		    «IF cmd.argout.description.empty»
		    :rtype: «cmd.argout.type.pythonType»
		    «ELSE»
		    :return: «cmd.argout.description.commentCmdParamMultiLines»
		    :rtype: «cmd.argout.type.pythonType»
		    «ENDIF»
		    «ENDIF»
		    """
		    self.debug_stream("In «cmd.methodName»()")
		    «IF !cmd.argout.type.voidType»argout = «cmd.argout.type.defaultValue»«ENDIF»
		    «protectedArea(cls, cmd.name)»
		    «cmd.returnMethodCode»
		    
        '''
        
    def commandExecutionHL(PogoDeviceClass cls, Command cmd) '''
«IF isTrue(cmd.status.concreteHere)»
	«IF cmd.name != "State"»
		«IF cmd.name != "Status"»    @command«IF cmd.hasCommandArg»(«ENDIF»
		«IF !cmd.argin.type.voidType»        dtype_in=«cmd.argin.type.pythonTypeHL»,
		«IF !cmd.argin.description.empty»        doc_in="«cmd.argin.description.commentMultiLinesInputDescriptionStr»",
		«ENDIF»
		«ENDIF»
		«IF !cmd.argout.type.voidType»        dtype_out=«cmd.argout.type.pythonTypeHL»,
		«IF !cmd.argout.description.empty»        doc_out="«cmd.argout.description.commentMultiLinesOutputDescriptionStr»",
		«ENDIF»
		«ENDIF»
        «setAttrPropertyHL("display_level", cmd.displayLevel, false)»
        «setAttrPropertyHL("polling_period", cmd.polledPeriod, false)»
		«IF cmd.hasCommandArg»    )
		«ENDIF»
		«ENDIF»
	«ENDIF»
    @DebugIt()
    def «cmd.methodName»(self«IF !cmd.argin.type.voidType», argin«ENDIF»):
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
        «openProtectedAreaHL(cls,cmd.name)»
        """
        «cmd.description.commentCmdParamMultiLines»
        «IF !cmd.argin.type.voidType»

        :param argin: «cmd.argin.type.pythonTypeHL»
        «cmd.argin.description.commentCmdParamMultiLines»
        «ENDIF»
        «IF !cmd.argout.type.voidType»

        :return:«cmd.argout.type.pythonTypeHL»
        «cmd.argout.description.commentCmdParamMultiLines»
        «ELSE»

        :return:None
        «ENDIF»
        """
        «cmd.argout.type.defaultValueReturnHL»
        «closeProtectedAreaHL(cls,cmd.name)»
        «ELSE»
        «IF !cmd.argout.type.voidType»
        return «cmd.argout.type.defaultValueTestHL»
        «ELSE»
        pass
        «ENDIF»
        «ENDIF»
«ENDIF»

'''
    
    def commandMethodStateMachine(PogoDeviceClass cls, Command cmd) '''
		def is_«cmd.name»_allowed(self):
		    self.debug_stream("In is_«cmd.name»_allowed()")
		    state_ok = not(«cmd.excludedStates.ifContentFromListPython»)
		    «protectedArea(cls, "is_" + cmd.name + "_allowed")»
		    return state_ok
		    
    '''
    
    def commandMethodStateMachineHL(PogoDeviceClass cls, Command cmd) '''
		def is_«cmd.name»_allowed(self):
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,"is_" + cmd.name + "_allowed", "return " + cmd.excludedStates.ifContentFromListPythonHL, false)»«ELSE»return «cmd.excludedStates.ifContentFromListPythonHL»«ENDIF»
		
'''
    
    def writeAttributeMethod(PogoDeviceClass cls, Attribute attribute) '''
		def write_«attribute.name»(self, attr):
		    self.debug_stream("In write_«attribute.name»()")
		    data = attr.get_write_value()
		    «protectedArea(cls, attribute.name + "_write")»
		    
    '''
    def writeAttributeMethodHL(PogoDeviceClass cls, Attribute attribute, boolean isDynamic) '''
        def write_«attribute.name»(self, «IF isDynamic»w_attr«ELSE»value«ENDIF»):
                «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
                «openProtectedAreaHL(cls, attribute.name + "_write")»
                """Set the «attribute.name» attribute."""
                «IF isDynamic==false»
                pass
                «ELSE»
                """Example implementation:
                name = w_attr.get_name()
                Hint: self.attr_«attribute.name» should be define on the top level
                (initialize_dynamic_attributes, init_device method or constructor)
                self.attr_«attribute.name» = w_attr.get_write_value()
                """
                pass
                «ENDIF»
                «closeProtectedAreaHL(cls, attribute.name + "_write")»
                «ELSE»
                pass
                «ENDIF»

    '''
        
    def readAttributeMethod(PogoDeviceClass cls, Attribute attribute) '''
		def read_«attribute.name»(self, attr):
		    self.debug_stream("In read_«attribute.name»()")
		    «protectedArea(cls, attribute.name + "_read", attribute.setAttrVal, false)»
		    
    '''
    def readAttributeMethodHL(PogoDeviceClass cls, Attribute attribute, boolean isDynamic) '''
        def read_«attribute.name»(self«IF isDynamic», attr«ENDIF»):
                «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
                «openProtectedAreaHL(cls, attribute.name + "_read")»
                «IF isDynamic==false»
                """Return the «attribute.name» attribute."""
                return self._«attribute.pythonAttributeVariableNameHL»
                «ELSE»
                """Return the «attribute.name»_read attribute."""
                """Example implementation:
                Hint: self.attr_«attribute.name» should be define on the top level
                (initialize_dynamic_attributes, init_device method or constructor)
                attr.set_value(self.attr_«attribute.name»)
                return attr
                """
                attr.set_value(«attribute.defaultValueDim»)
                return attr
                «ENDIF»
                «closeProtectedAreaHL(cls, attribute.name + "_read")»
                «ELSE»
                return «attribute.defaultValueDim»
                «ENDIF»

    '''
      
    def readPipeMethodHL(PogoDeviceClass cls, Pipe pip) '''
        def read_«pip.name»(self):
                «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls, pip.name + "_read", "return dict(x=0, y=0)", false)»«ELSE»return dict(x=0, y=0)»«ENDIF»

    '''
    
    def writePipeMethodHL(PogoDeviceClass cls, Pipe pip) '''
        def write_«pip.name»(self, value):
                «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls, pip.name + "_write","print dict(value)", false)»«ELSE»print dict(value)»«ENDIF»

    '''
    def attributeMethodStateMachine(PogoDeviceClass cls, Attribute attribute) '''
		def is_«attribute.name»_allowed(self, attr):
		    self.debug_stream("In is_«attribute.name»_allowed()")
		    if attr==PyTango.AttReqType.READ_REQ:
		        state_ok = not(«attribute.readExcludedStates.ifContentFromListPython»)
		    else:
		        state_ok = not(«attribute.writeExcludedStates.ifContentFromListPython»)
		    «protectedArea(cls, "is_" + attribute.name + "_allowed")»
		    return state_ok
		    
    '''
    def readWriteStateMachine(PogoDeviceClass cls, Attribute attribute)
    {
    	if (!attribute.readExcludedStates.empty)
    	{
    		if (!attribute.writeExcludedStates.empty)
    		{
    			return "if attr==attr.READ_REQ:\n    return " + attribute.readExcludedStates.ifContentFromListPythonHL + "\nelse:\n    return " + attribute.writeExcludedStates.ifContentFromListPythonHL;
    		}
    		else
    		{
    			return "if attr==attr.READ_REQ:\n    return " + attribute.readExcludedStates.ifContentFromListPythonHL + "\nelse:\n    return True";
    		}
    		
    	}
    	else
    	{
    		
    		if (!attribute.writeExcludedStates.empty)
    		{
    			return "if attr==attr.READ_REQ:\n    return True\nelse:\n    return " + attribute.writeExcludedStates.ifContentFromListPythonHL;
    		}
    		else
    		{
    			return "if attr==attr.READ_REQ:\n    return True\nelse:\n    return True";
    		}
    	}
    }
    
    def readWriteStateMachinePipe(PogoDeviceClass cls, Pipe pip)
    {
    	if (!pip.readExcludedStates.empty)
    	{
    		if (!pip.writeExcludedStates.empty)
    		{
    			return "if attr==attr.READ_REQ:\n    return " + pip.readExcludedStates.ifContentFromListPythonHL + "\nelse:\n    return " + pip.writeExcludedStates.ifContentFromListPythonHL;
    		}
    		else
    		{
    			return "if attr==attr.READ_REQ:\n    return " + pip.readExcludedStates.ifContentFromListPythonHL + "\nelse:\n    return True";
    		}
    		
    	}
    	else
    	{
    		
    		if (!pip.writeExcludedStates.empty)
    		{
    			return "if attr==attr.READ_REQ:\n    return True\nelse:\n    return " + pip.writeExcludedStates.ifContentFromListPythonHL;
    		}
    		else
    		{
    			return "if attr==attr.READ_REQ:\n    return True\nelse:\n    return True";
    		}
    	}
    }

    def attributeMethodStateMachineHL(PogoDeviceClass cls, Attribute attribute) '''
		def is_«attribute.name»_allowed(self, attr):
        «IF attribute.rwType.equals("READ")»«IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls, "is_" + attribute.name + "_allowed","return " + attribute.readExcludedStates.ifContentFromListPythonHL, false)»«ELSE»return «attribute.readExcludedStates.ifContentFromListPythonHL»«ENDIF»«ENDIF»
        «IF attribute.rwType.equals("WRITE")»«IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls, "is_" + attribute.name + "_allowed","return " + attribute.writeExcludedStates.ifContentFromListPythonHL, false)»«ELSE»return «attribute.writeExcludedStates.ifContentFromListPythonHL»«ENDIF»«ENDIF»
        «IF attribute.rwType.equals("READ_WRITE") || attribute.rwType.equals("READ_WITH_WRITE")»«IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls, "is_" + attribute.name + "_allowed",cls.readWriteStateMachine(attribute), false)»«ELSE»«cls.readWriteStateMachine(attribute)»«ENDIF»«ENDIF»

    '''
    def pipeMethodStateMachineHL(PogoDeviceClass cls, Pipe pip) '''
		def is_«pip.name»_allowed(self, attr):
        «IF pip.rwType.equals("READ")»«IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls, "is_" + pip.name + "_allowed","return " + pip.readExcludedStates.ifContentFromListPythonHL, false)»«ELSE»return «pip.readExcludedStates.ifContentFromListPythonHL»«ENDIF»«ENDIF»
        «IF pip.rwType.equals("WRITE")»«IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls, "is_" + pip.name + "_allowed","return " + pip.writeExcludedStates.ifContentFromListPythonHL, false)»«ELSE»return «pip.writeExcludedStates.ifContentFromListPythonHL»«ENDIF»«ENDIF»
        «IF pip.rwType.equals("READ_WRITE") || pip.rwType.equals("READ_WITH_WRITE")»«IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls, "is_" + pip.name + "_allowed",cls.readWriteStateMachinePipe(pip), false)»«ELSE»«cls.readWriteStateMachinePipe(pip)»«ENDIF»«ENDIF»

    '''
    def pythonPropertyClass(Property prop) '''        '«prop.name»':
            [«prop.type.pythonPropType», 
            «IF !prop.description.empty»"«prop.description.oneLineString»"«ELSE» ''«ENDIF»«IF !prop.defaultPropValue.empty»,
            «IF prop.type.pythonPropType.equals("PyTango.DevString")»["«prop.defaultPropValue.get(0).escapeQuotes»"] «ELSEIF prop.type.pythonPropType.equals("PyTango.DevVarStringArray")»«prop.defaultPropValue.toString.stringListToStringArray»«ELSE»«prop.defaultPropValue»«ENDIF»«ELSE»,
             []«ENDIF»,
            «IF prop.mandatory.isTrue» mandatory=True«ENDIF»]
    '''
    
    def pythonPropertyClassHL(Property prop) '''
«IF isTrue(prop.status.concreteHere)»
        «prop.name» = class_property(
                dtype=«prop.type.pythonPropTypeHL»,
                «IF !prop.defaultPropValue.empty»
                default_value=«IF prop.type.pythonPropTypeHL.equals("'DevString'")»"«prop.defaultPropValue.get(0).escapeQuotes»"
        «ELSEIF prop.type.pythonPropTypeHL.equals("'DevVarStringArray'")»
        «prop.defaultPropValue.toString.stringListToStringArray»
        «ELSEIF ( prop.type.pythonPropTypeHL.equals("'DevVarShortArray'") || prop.type.pythonPropTypeHL.equals("'DevVarLongArray'") || prop.type.pythonPropTypeHL.equals("'DevVarFloatArray'") || prop.type.pythonPropTypeHL.equals("'DevVarDoubleArray'") )»
        «prop.defaultPropValue.toString»
        «ELSE»
        «prop.defaultPropValue.get(0).stringToPyth»
        «ENDIF»
        «ENDIF»
        «IF prop.mandatory.isTrue»        mandatory=True«ENDIF»
            )
«ENDIF»
    '''
    
     def pythonPropertyClassDocsHL(Property prop) '''
«IF isTrue(prop.status.concreteHere)»
            «prop.name»
        «IF !prop.description.empty»        - «prop.description.oneLineString»«ENDIF»
                - Type:«prop.type.pythonPropTypeHL»
«ENDIF»
    '''
    
    def pythonPropertyDeviceHL(Property prop) '''
«IF isTrue(prop.status.concreteHere)»
        «prop.name» = device_property(
                dtype=«prop.type.pythonPropTypeHL»,
                «IF !prop.defaultPropValue.empty» 
                default_value=«IF prop.type.pythonPropTypeHL.equals("'DevString'")»"«prop.defaultPropValue.get(0).escapeQuotes»"
        «ELSEIF prop.type.pythonPropTypeHL.equals("'DevVarStringArray'")»
        «prop.defaultPropValue.toString.stringListToStringArray»
        «ELSEIF ( prop.type.pythonPropTypeHL.equals("'DevVarShortArray'") || prop.type.pythonPropTypeHL.equals("'DevVarLongArray'") || prop.type.pythonPropTypeHL.equals("'DevVarFloatArray'") || prop.type.pythonPropTypeHL.equals("'DevVarDoubleArray'") )»
        «prop.defaultPropValue.toString»
        «ELSE»
        «prop.defaultPropValue.get(0).stringToPyth»
        «ENDIF»
        «ENDIF»
        «IF prop.mandatory.isTrue»        mandatory=True«ENDIF»
            )
«ENDIF»
    '''
    
         def pythonPropertyDeviceDocsHL(Property prop) '''
«IF isTrue(prop.status.concreteHere)»
            «prop.name»
        «IF !prop.description.empty»        - «prop.description.oneLineString»«ENDIF»
                - Type:«prop.type.pythonPropTypeHL»
«ENDIF»
    '''
    
    def pythonCommandClass(Command cmd) '''        '«cmd.name»':
            [[«cmd.argin.type.pythonType», "«getArgDescription(cmd.argin.description.oneLineString)»"],
            [«cmd.argout.type.pythonType», "«getArgDescription(cmd.argout.description.oneLineString)»"]«IF cmd.hasCmdPropertySet»,
            {
            «setAttrProperty("Polling period", cmd.polledPeriod)»
            «setAttrProperty("Display level", cmd.displayLevel)»
            } ],
    «ELSE»],«ENDIF»
    '''
    
    def String pythonAttributeSize(Attribute attr) {
        if (attr.image) {
            return ", " + attr.name + "_X_DATA_SIZE" + ", " + attr.name + "_Y_DATA_SIZE";
        }
        else
        if (attr.spectrum) {
            return ", " + attr.name + "_X_DATA_SIZE";
        }
        else
            return "";
    }
    
    def String pythonAttributeSizeHL(Attribute attr) {
        if (attr.image) {
            return "max_dim_x=" + attr.maxX + ", max_dim_y=" + attr.maxY + ",";
        }
        else
        if (attr.spectrum) {
            return "max_dim_x=" + attr.maxX + ",";
        }
        else
            return "";
    }
    
    def String pythonAttributeVariableNameHL(Attribute attr) {
    	var attrVariableName = attr.name
    	var indexList = new BasicEList<Integer>
    	var ch =0 
    	var stringSize = (attr.name.length -1)
    	for (ch =0; ch < attrVariableName.length; ch++){
    		if(Character.isUpperCase(attrVariableName.charAt(ch))){
    			indexList.add(ch);
    		}
    	}
    	var checkNxtIndex = 0
    	var position = 0
    	var count = 0
    	for (index:indexList){
    		if(checkNxtIndex !== stringSize)
    		{   			
	    		if(index==checkNxtIndex){
	    			checkNxtIndex = (index +1)
	    			if(Character.isLowerCase(attr.name.charAt((checkNxtIndex)))){
	    				position = (index + count)
	    				attrVariableName = attrVariableName.substring(0, position)+ '_' + attrVariableName.substring(position)
	    				count+=1
	    			}
	    		}
	    		else{
	    			position = (index + count)
	    			attrVariableName = attrVariableName.substring(0, position)+ '_' + attrVariableName.substring(position)
	    			checkNxtIndex = (index +1)
	    			count+=1
	    		}
    		}
    	}
    	return attrVariableName.toLowerCase
	}

    
    def pythonAttributeClass(Attribute attr) '''        '«attr.name»':
            [[«attr.dataType.pythonType»,
            PyTango.«attr.attType.toUpperCase»,
            PyTango.«attr.rwType.toUpperCase»«pythonAttributeSize(attr)»]«IF attr.hasAttrPropertySet»,
            {
            «setAttrProperty("label", attr.properties.label)»
            «setAttrProperty("unit", attr.properties.unit)»
            «setAttrProperty("standard unit", attr.properties.standardUnit)»
            «setAttrProperty("display unit", attr.properties.displayUnit)»
            «setAttrProperty("format", attr.properties.format)»
            «setAttrProperty("max value", attr.properties.maxValue)»
            «setAttrProperty("min value", attr.properties.minValue)»
            «setAttrProperty("max alarm", attr.properties.maxAlarm)»
            «setAttrProperty("min alarm", attr.properties.minAlarm)»
            «setAttrProperty("max warning", attr.properties.maxWarning)»
            «setAttrProperty("min warning", attr.properties.minWarning)»
            «setAttrProperty("delta time", attr.properties.deltaTime)»
            «setAttrProperty("delta value", attr.properties.deltaValue)»
            «setAttrProperty("description", attr.properties.description.oneLineString)»
            «setAttrProperty("Polling period", attr.polledPeriod)»
            «setAttrProperty("Display level", attr.displayLevel)»
            «IF attr.eventCriteria!==null»
            «setAttrProperty("period", attr.eventCriteria.period)»
            «setAttrProperty("rel_change", attr.eventCriteria.relChange)»
            «setAttrProperty("abs_change", attr.eventCriteria.absChange)»
            «ENDIF»
            «IF attr.evArchiveCriteria!==null»
            «setAttrProperty("archive_period", attr.evArchiveCriteria.period)»
            «setAttrProperty("archive_rel_change", attr.evArchiveCriteria.relChange)»
            «setAttrProperty("archive_abs_change", attr.evArchiveCriteria.absChange)»
             «ENDIF»
            «attr.isMemorized»
            } ],
            «ELSE»],«ENDIF»
    '''
    def pythonConstant(Attribute attr) '''
        «IF attr.spectrum»
            #    Constants for «attr.name» attribute
            «attr.name»_X_DATA_SIZE = «attr.maxX»
        «ELSEIF attr.image»
            #    Constants for «attr.name» attribute
            «attr.name»_X_DATA_SIZE = «attr.maxX»
            «attr.name»_Y_DATA_SIZE = «attr.maxY»
        «ENDIF»
    '''
    def pythonAttributeClassHL(Attribute attr) '''
«attr.name» = attribute(
        dtype=«attr.pythonTypeAttrHL»,
        «IF !attr.rwType.toUpperCase.equals("READ")»access=AttrWriteType.«attr.rwType.toUpperCase»,«ENDIF»
        «IF attr.hasAttrPropertySetHL»
        «pythonAttributeSizeHL(attr)»
        «setAttrPropertyHL("display_level", attr.displayLevel, false)»
        «setAttrPropertyHL("label", attr.properties.label, true)»
        «setAttrPropertyHL("unit", attr.properties.unit, true)»
        «setAttrPropertyHL("standard_unit", attr.properties.standardUnit, true)»
        «setAttrPropertyHL("display_unit", attr.properties.displayUnit, true)»
        «setAttrPropertyHL("format", attr.properties.format.formatComaToPoint, true)»
        «setAttrPropertyHL("polling_period", attr.polledPeriod, false)»
        «IF attr.eventCriteria!==null»
        «setAttrPropertyHL("period", attr.eventCriteria.period, false)»
        «setAttrPropertyHL("rel_change", attr.eventCriteria.relChange, false)»
        «setAttrPropertyHL("abs_change", attr.eventCriteria.absChange, false)»
        «ENDIF»
        «IF attr.evArchiveCriteria!==null»
        «setAttrPropertyHL("archive_period", attr.evArchiveCriteria.period, false)»
        «setAttrPropertyHL("archive_rel_change", attr.evArchiveCriteria.relChange, false)»
        «setAttrPropertyHL("archive_abs_change", attr.evArchiveCriteria.absChange, false)»
        «ENDIF»
        «setAttrPropertyHL("max_value", attr.properties.maxValue, false)»
        «setAttrPropertyHL("min_value", attr.properties.minValue, false)»
        «setAttrPropertyHL("max_alarm", attr.properties.maxAlarm, false)»
        «setAttrPropertyHL("min_alarm", attr.properties.minAlarm, false)»
        «setAttrPropertyHL("max_warning", attr.properties.maxWarning, false)»
        «setAttrPropertyHL("min_warning", attr.properties.minWarning, false)»
        «setAttrPropertyHL("memorized", attr.memorized, false)»
        «setAttrPropertyHL("hw_memorized", attr.memorizedAtInit, false)»
        «setAttrPropertyHL("delta_t", attr.properties.deltaTime, false)»
        «setAttrPropertyHL("delta_val", attr.properties.deltaValue, false)»
        «setAttrPropertyHL("doc", attr.properties.description.oneLineString, true)»
		«ENDIF»
    )
    '''
    def pythonPipeClassHL(Pipe pip) '''
«pip.name» = pipe(
«IF pip.hasPipePropertySetHL»        «setPipePropertyHL("label", pip.label, true)»
        «setPipePropertyHL("display_level", pip.displayLevel, false)»
        «setPipePropertyHL("doc", pip.description.oneLineString, true)»
        «IF pip.rwType.contains("WRITE")»access=PipeWriteType.PIPE_READ_WRITE«ENDIF»
«ENDIF»
    )
    '''
    
    
    def pythonForwardedAttributeClassHL(ForwardedAttribute attr) '''
«attr.name» = attribute(
        «setAttrPropertyHL("name", attr.name, true)»
        «setAttrPropertyHL("label", attr.label, true)»
        forwarded=True
    )
    '''
    //======================================================
    def setEventCriteria(PogoDeviceClass cls) '''
     «FOR attribute: cls.attributes»
        «IF attribute.dataReadyEvent!==null»
            «IF attribute.dataReadyEvent.fire!==null && attribute.dataReadyEvent.fire.equals("true")»
                self.«attribute.name».set_data_ready_event(True)
            «ENDIF»
        «ENDIF»
        «IF attribute.changeEvent!==null»
            «IF attribute.changeEvent.fire!==null && attribute.changeEvent.fire.equals("true")»
                 self.set_change_event("«attribute.name»", True, «IF attribute.changeEvent.libCheckCriteria.equals("true")»True«ELSE»False«ENDIF»)
            «ENDIF»
        «ENDIF»
        «IF attribute.archiveEvent!==null»
            «IF attribute.archiveEvent.fire!==null && attribute.archiveEvent.fire.equals("true")»
                 self.set_archive_event("«attribute.name»", True, «IF attribute.archiveEvent.libCheckCriteria.equals("true")»True«ELSE»False«ENDIF»)
            «ENDIF»
        «ENDIF»
     «ENDFOR»
    '''
    //======================================================
    /**
     * Code to generate dynamic attribute example.
     */
    //======================================================
    def dynamicAttributeCreationExample(Attribute attr) '''
        «IF attr.scalar»
            my«attr.name» = PyTango.Attr('My«attr.name»', «attr.dataType.pythonType», PyTango.«attr.rwType.toUpperCase»)
        «ENDIF»
        «IF attr.spectrum»
            my«attr.name» = PyTango.SpectrumAttr('My«attr.name»', «attr.dataType.pythonType», PyTango.«attr.rwType.toUpperCase», «attr.maxX»)
        «ENDIF»
        «IF attr.image»
            my«attr.name» = PyTango.ImageAttr('My«attr.name»', «attr.dataType.pythonType», PyTango.«attr.rwType.toUpperCase», «attr.maxX», «attr.maxY»)
        «ENDIF»
    '''
    //======================================================
    def dynamicAttributeDefaultValueExample(PogoDeviceClass cls, Attribute attr) '''
        «IF attr.displayLevel.equals("EXPERT")»
            my«attr.name».set_disp_level(PyTango.DispLevel.EXPERT)
        «ENDIF»
        «cls.addDynamicAttributeExample(attr)»
        «IF attr.read»
            self.attr_«attr.name»_read = «attr.defaultValueDim»
        «ENDIF»
    '''
    //======================================================
    def dynamicAttributeSetMemorizedExample(Attribute attribute) '''
        «IF attribute.write»
            «IF attribute.memorized!==null»
                «IF attribute.memorized == "true"»
                    my«attribute.name».set_memorized()
                    «IF attribute.memorizedAtInit == "true"»
                        my«attribute.name».set_memorized_init(True)
                    «ELSE»
                        my«attribute.name».set_memorized_init(False)
                    «ENDIF»
                «ENDIF»
            «ENDIF»
        «ENDIF»
    '''
    //======================================================
}
