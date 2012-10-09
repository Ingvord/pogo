package fr.esrf.tango.pogo.generator.python

import fr.esrf.tango.pogo.pogoDsl.Command
import fr.esrf.tango.pogo.pogoDsl.Attribute
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import fr.esrf.tango.pogo.pogoDsl.Property
import com.google.inject.Inject
import static extension fr.esrf.tango.pogo.generator.python.PythonTypeDefinitions.*
import static extension fr.esrf.tango.pogo.generator.python.ProtectedArea.*
import static extension fr.esrf.tango.pogo.generator.common.StringUtils.*

class PythonUtils {
    @Inject extension fr.esrf.tango.pogo.generator.common.StringUtils
    @Inject extension ProtectedArea
    @Inject extension fr.esrf.tango.pogo.generator.python.PythonTypeDefinitions    
        
    def commentMultiLinesPython(PogoDeviceClass cls){
        cls.description.description.replaceAll("\n","\n#                ");
    }
    
    def commentMultiLinesPythonStr(String str){
        str.replaceAll("\n","\n#                ");
    }
    
    def isMemorized(Attribute attr) {
    	if (attr.write)	{
    		if (attr.memorized!=null) {
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
        	!attr.properties.label.empty       ||
        	!attr.properties.unit.empty        ||
	        !attr.properties.standardUnit.empty||
	        !attr.properties.displayUnit.empty ||
	        !attr.properties.format.empty      || 
	        !attr.properties.maxValue.empty    ||
	        !attr.properties.minValue.empty    ||
	        !attr.properties.maxAlarm.empty    || 
        	!attr.properties.minAlarm.empty    ||
        	!attr.properties.maxWarning.empty  ||
        	!attr.properties.minWarning.empty  ||
        	!attr.properties.deltaTime.empty   ||
        	!attr.properties.deltaValue.empty  ||
        	!attr.properties.description.empty ||
        	attr.displayLevel.equals("EXPERT") ||
        	!attr.polledPeriod.equals("0")     ||
        	attr.eventCriteria!=null           ||
	        attr.eventCriteria!=null);
    }
    
    def hasCmdPropertySet(Command cmd){
        return (cmd.displayLevel.equals("EXPERT") || !cmd.polledPeriod.equals("0"));
    }
    
    def commandExecution(PogoDeviceClass cls, Command cmd) '''
#------------------------------------------------------------------
#    «cmd.name» command:
#------------------------------------------------------------------
    def «cmd.name»(self«IF !cmd.argin.type.voidType», argin«ENDIF»):
        """ «cmd.description»
        
        :param «IF !cmd.argin.type.voidType»argin«ENDIF»: «cmd.argin.description»
        :type: «cmd.argin.type.pythonType»
        :return: «cmd.argout.description»
        :rtype: «cmd.argout.type.pythonType» """
        self.debug_stream("In " + self.get_name() +  ".«cmd.name»()")
        «IF !cmd.argout.type.voidType»argout = «cmd.argout.type.defaultValue»«ENDIF»
        «protectedArea(cls, cmd.name)»
        «IF !cmd.argout.type.voidType»return argout«ENDIF»
        
        '''
        
    def commandMethodStateMachine(Command cmd) '''
#------------------------------------------------------------------
#    Is «cmd.name» command allowed
#------------------------------------------------------------------
    def is_«cmd.name»_allowed(self):
        self.debug_stream("In " + self.get_name() + ".is_«cmd.name»_allowed()")
        return not(«cmd.excludedStates.ifContentFromListPython»)
        '''
    
    def writeAttributeMethod(PogoDeviceClass cls, Attribute attribute) '''
#------------------------------------------------------------------
#    Write «attribute.name» attribute
#------------------------------------------------------------------
    def write_«attribute.name»(self, attr):
        self.debug_stream("In " + self.get_name() + ".write_«attribute.name»()")
        data=attr.get_write_value()
        self.debug_stream("Attribute value = " + str(data))
        «protectedArea(cls, attribute.name + "_write")»
        
    '''
        
    def readAttributeMethod(PogoDeviceClass cls, Attribute attribute) '''
#------------------------------------------------------------------
#    Read «attribute.name» attribute
#------------------------------------------------------------------
    def read_«attribute.name»(self, attr):
        self.debug_stream("In " + self.get_name() + ".read_«attribute.name»()")
        «protectedArea(cls, attribute.name + "_read")»
        attr.set_value(self.attr_«attribute.name»_read)
        
    '''
    
    def attributeMethodStateMachine(Attribute attribute) '''
#------------------------------------------------------------------
#    Is «attribute.name» attribute allowed
#------------------------------------------------------------------
    def is_«attribute.name»_allowed(self, attr):
        self.debug_stream("In " + self.get_name() + ".is_«attribute.name»_allowed()")
        return not(«attribute.readExcludedStates.ifContentFromListPython»)
        
    '''

    def pythonPropertyClass(Property prop) '''        '«prop.name»':
            [«prop.type.pythonPropType»«IF !prop.description.empty»,
            "«prop.description»"«ENDIF»«IF !prop.defaultPropValue.empty»,
            «IF prop.type.pythonPropType.equals("PyTango.DevString")»["«prop.defaultPropValue.get(0)»"] «ELSE»«prop.defaultPropValue»«ENDIF»«ELSE»,
            [] «ENDIF»],
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
    		return ", «attr.maxX», «attr.maxY";
   		}
    	else
    	if (attr.spectrum) {
    		return ", «attr.maxX";
    	}
    	else
			return "";
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
            «IF attr.eventCriteria!=null»
                «setAttrProperty("period", attr.eventCriteria.period)»
                «setAttrProperty("rel_change", attr.eventCriteria.relChange)»
                «setAttrProperty("abs_change", attr.eventCriteria.absChange)»
            «ENDIF»
            «IF attr.evArchiveCriteria!=null»
                «setAttrProperty("archive_period", attr.evArchiveCriteria.period)»
                «setAttrProperty("archive_rel_change", attr.evArchiveCriteria.relChange)»
                «setAttrProperty("archive_abs_change", attr.evArchiveCriteria.absChange)»
             «ENDIF»
            «attr.isMemorized»
            } ],
            «ELSE»],«ENDIF»
    '''
    
    //======================================================
    def setEventCriteria(Attribute attribute) '''
        «IF attribute.dataReadyEvent!=null»
            «IF attribute.dataReadyEvent.fire!=null && attribute.dataReadyEvent.fire.equals("true")»
                «attribute.name».set_data_ready_event(«attribute.dataReadyEvent.fire»);
            «ENDIF»
        «ENDIF»
        «IF attribute.changeEvent!=null»
            «IF attribute.changeEvent.fire!=null && attribute.changeEvent.fire.equals("true")»
                 «attribute.name».set_change_event(«attribute.changeEvent.fire», «attribute.changeEvent.libCheckCriteria»);
            «ENDIF»
        «ENDIF»
        «IF attribute.archiveEvent!=null»
            «IF attribute.archiveEvent.fire!=null && attribute.archiveEvent.fire.equals("true")»
                 «attribute.name».set_archive_event(«attribute.archiveEvent.fire», «attribute.archiveEvent.libCheckCriteria»);
            «ENDIF»
        «ENDIF»
    '''
}