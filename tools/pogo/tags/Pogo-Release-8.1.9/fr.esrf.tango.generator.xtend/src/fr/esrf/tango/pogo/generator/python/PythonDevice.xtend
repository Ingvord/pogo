//+======================================================================
//
// Project:   Tango
//
// Description:  source code for Tango code generator.
//
// $Author: verdier $
//
// Copyright (C) :  2004,2005,2006,2007,2008,2009,2009,2010,2011,2012,2013
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

import org.eclipse.xtext.generator.IGenerator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import com.google.inject.Inject
import static org.eclipse.xtext.xtend2.lib.ResourceExtensions.*
import static extension fr.esrf.tango.pogo.generator.python.ProtectedArea.*
import static extension fr.esrf.tango.pogo.generator.python.PythonTypeDefinitions.*
import static extension fr.esrf.tango.pogo.generator.common.StringUtils.*

class PythonDevice implements IGenerator {
    @Inject    extension ProtectedArea
    @Inject    extension PythonUtils
    @Inject    extension PythonTypeDefinitions
    @Inject extension fr.esrf.tango.pogo.generator.common.StringUtils

    override void doGenerate(Resource resource, IFileSystemAccess fsa){
        //println("doGenerate for python")
        for(cls : allContentsIterable(resource).filter(typeof(PogoDeviceClass))){
            if (cls.description.language.toLowerCase.equals("python")) {
                println("doGenerate for python " + cls.name)
                fsa.generateFile(cls.name + '.py', cls.generate_pythonFile)
            }
        }
    }
    

    //====================================================
    //    The python file definition
    //====================================================
    def generate_pythonFile(PogoDeviceClass cls)'''
        «cls.pythonDevice»

        «cls.pythonDeviceClass»

        «cls.pythonMainMethod»
    '''

    //====================================================
    //    The python device 
    //====================================================
    def pythonDevice(PogoDeviceClass cls)'''
        «cls.pythonHeader»
        
        class «cls.name» («cls.inheritedPythonClassName»):
        
            #--------- Add you global variables here --------------------------
            «cls.protectedArea("global_variables")»
        
            «cls.pythonConstructors»
        
            «cls.pythonInitDevice»
        
            def always_executed_hook(self):
                self.debug_stream("In always_excuted_hook()")
                «cls.protectedArea("always_executed_hook")»
        
            «cls.pythonAttributes»
        
        
            «cls.pythonCommands»
    '''

    //====================================================
    //    The python deviceClass 
    //====================================================
    def pythonDeviceClass(PogoDeviceClass cls)'''
        class «cls.name»Class(«cls.inheritedPythonDeviceClassName»):
            #--------- Add you global class variables here --------------------------
            «cls.protectedArea("global_class_variables")»
        
            «cls.pythonDynamicAttributesClass»
        
        «cls.pythonProperties»
        
        «cls.pythonCommandDefinitions»
        
        «cls.pythonAttributeDefinitions»
        
    '''
    

    //====================================================
    //    File header
    //====================================================
    def pythonHeader(PogoDeviceClass cls) '''
        #!/usr/bin/env python
        # -*- coding:utf-8 -*- 
        
        
        ##############################################################################
        ## license :
        ##============================================================================
        ##
        ## File :        «cls.name + ".py"»
        ## 
        ## Project :     «cls.description.title»
        ##
        «cls.description.license.licenseText("## ")»
        ##
        ## $Author :      «cls.description.identification.author»$
        ##
        ## $Revision :    $
        ##
        ## $Date :        $
        ##
        ## $HeadUrl :     $
        ##============================================================================
        ##            This file is generated by POGO
        ##    (Program Obviously used to Generate tango Object)
        ##
        ##        (c) - Software Engineering Group - ESRF
        ##############################################################################

        """«cls.description.description»"""
        
        __all__ = ["«cls.name»", "«cls.name»Class", "main"]
        
        __docformat__ = 'restructuredtext'
        
        import PyTango
        import sys
        «cls.inheritedAdditionalImport»
        # Add additional import
        «cls.protectedArea("additionnal_import")»
        
        ## Device States Description
        «IF !cls.states.empty»«FOR state : cls.states»
        ## «state.name» : «state.description»
        «ENDFOR»
        «ELSE»
        ## No states for this device
        «ENDIF»
    '''

    //====================================================
    //    Constructors
    //====================================================
    def pythonConstructors(PogoDeviceClass cls)  '''
            def __init__(self,cl, name):
                PyTango.Device_4Impl.__init__(self,cl,name)
                self.debug_stream("In __init__()")
                «cls.name».init_device(self)
                «cls.protectedArea("__init__")»
                
            def delete_device(self):
                self.debug_stream("In delete_device()")
                «cls.protectedArea("delete_device")»
    '''
    //====================================================
    //    Constructors
    //====================================================
    def pythonInitDevice(PogoDeviceClass cls)  '''
        def init_device(self):
            self.debug_stream("In init_device()")
            self.get_device_properties(self.get_device_class())
        «FOR attr: cls.attributes»
            «IF attr.read»    self.attr_«attr.name»_read = «attr.defaultValueDim»«ENDIF»
        «ENDFOR»
            «cls.protectedArea("init_device")»
    '''

    //====================================================
    //    Attributes
    //====================================================
    def pythonAttributes(PogoDeviceClass cls)  '''
        #-----------------------------------------------------------------------------
        #    «cls.name» read/write attribute methods
        #-----------------------------------------------------------------------------
        
            «FOR attr: cls.attributes»
            «IF attr.isRead»
        «readAttributeMethod(cls, attr)»
            «ENDIF»
            «IF attr.isWrite»
        «writeAttributeMethod(cls, attr)»
            «ENDIF»
            «IF !attr.readExcludedStates.empty»
        «attributeMethodStateMachine(cls, attr)»
            «ENDIF»
        «ENDFOR»

        «cls.pythonDynamicAttributes»
        def read_attr_hardware(self, data):
            self.debug_stream("In read_attr_hardware()")
            «cls.protectedArea("read_attr_hardware")»
    '''
    //====================================================
    //    Dynamic Attributes
    //====================================================
    def pythonDynamicAttributes(PogoDeviceClass cls)  '''
            «FOR attr: cls.dynamicAttributes»
            «IF attr.isRead»
        «readAttributeMethod(cls, attr)»
            «ENDIF»
            «IF attr.isWrite»
        «writeAttributeMethod(cls, attr)»
            «ENDIF»
            «IF !attr.readExcludedStates.empty»
        «attributeMethodStateMachine(cls, attr)»
            «ENDIF»
        «ENDFOR»
        
        «IF !cls.dynamicAttributes.empty»
        def initialize_dynamic_attributes(self):
            self.debug_stream("In initialize_dynamic_attributes()")
        «FOR attr : cls.dynamicAttributes»
            «IF attr.scalar»    «attr.name» = PyTango.Attr('«attr.name»', «attr.dataType.pythonType», PyTango.«attr.rwType.toUpperCase»)«ENDIF»
            «IF attr.spectrum»    «attr.name» = PyTango.SpectrumAttr('«attr.name»', «attr.dataType.pythonType», PyTango.«attr.rwType.toUpperCase», «attr.maxX»)«ENDIF»
            «IF attr.image»    «attr.name» = PyTango.ImageAttr('«attr.name»', «attr.dataType.pythonType», PyTango.«attr.rwType.toUpperCase», «attr.maxX», «attr.maxY»)«ENDIF»
            «IF attr.write»
                «IF attr.memorized!=null»
                    «IF attr.memorized == "true"»    «attr.name».set_memorized()
                        «IF attr.memorizedAtInit == "true"»    «attr.name».set_memorized_init(True)
                        «ELSE»    «attr.name».set_memorized_init(False)
                        «ENDIF»
                    «ENDIF»
                «ENDIF»
            «ENDIF»
            «IF attr.displayLevel.equals("EXPERT")»    «attr.name».set_disp_level(PyTango.DispLevel.EXPERT)«ENDIF»
                self.add_attribute(«attr.name»,«IF attr.read»«cls.name».read_«attr.name»«ELSE»None«ENDIF», «IF attr.write»«cls.name».write_«attr.name»«ELSE»None«ENDIF», «IF !attr.readExcludedStates.empty»«cls.name».is_«attr.name»_allowed«ELSE»None«ENDIF»)
            «IF attr.read»    self.attr_«attr.name»_read = «attr.defaultValueDim»«ENDIF»
        «ENDFOR»
        «ENDIF»
            «cls.protectedArea("initialize_dynamic_attributes")»
                
    '''
    //====================================================
    //    Dynamic Attributes for class
    //====================================================
    def pythonDynamicAttributesClass(PogoDeviceClass cls)  '''
            def dyn_attr(self, dev_list):
                """Invoked to create dynamic attributes for the given devices.
                Default implementation calls
                :meth:`«cls.name».initialize_dynamic_attributes` for each device
            
                :param dev_list: list of devices
                :type dev_list: :class:`PyTango.DeviceImpl`"""
            
                for dev in dev_list:
                    try:
                        dev.initialize_dynamic_attributes()
                    except:
                        import traceback
                        dev.warn_stream("Failed to initialize dynamic attributes")
                        dev.debug_stream("Details: " + traceback.format_exc())
                «cls.protectedArea("dyn_attr")»
    '''

    //    Commands
    //====================================================
    def pythonCommands(PogoDeviceClass cls)  '''
        #-----------------------------------------------------------------------------
        #    «cls.name» command methods
        #-----------------------------------------------------------------------------
        
            «FOR cmd: cls.commands»
            «IF cmd.name.equals("State")==false && cmd.name.equals("Status")==false»
        «commandExecution(cls, cmd)»
                «IF !cmd.excludedStates.empty»
        «commandMethodStateMachine(cls, cmd)»
                «ENDIF»
            «ENDIF»
        «ENDFOR»
        '''
    //====================================================
    //    Properties
    //====================================================
    def pythonProperties(PogoDeviceClass cls)'''
            #    Class Properties
            class_property_list = {
                «FOR prop : cls.classProperties»
        	«prop.pythonPropertyClass»
                «ENDFOR»
                }
            «cls.inheritanceClassPropertyList»
        
        
            #    Device Properties
            device_property_list = {
                «FOR prop : cls.deviceProperties»
            «prop.pythonPropertyClass»
                «ENDFOR»
                }
            «cls.inheritanceDevicePropertyList»
    '''
    //====================================================
    //    Command definitions
    //====================================================
    def pythonCommandDefinitions(PogoDeviceClass cls)'''
        
            #    Command definitions
            cmd_list = {
                «FOR cmd : cls.commands»
                    «IF cmd.name.equals("State")==false && cmd.name.equals("Status")==false»
            «cmd.pythonCommandClass»
                    «ENDIF»
                «ENDFOR»
                }
            «cls.inheritanceCmdList»
    '''
    //====================================================
    //    Attribute definitions
    //====================================================
    def pythonAttributeDefinitions(PogoDeviceClass cls)'''
        
            #    Attribute definitions
            attr_list = {
                «FOR attr : cls.attributes»
            «attr.pythonAttributeClass»
                «ENDFOR»
                }
            «cls.inheritanceAttrList»
    '''
        
    //====================================================
    //    Main method
    //====================================================
    def pythonMainMethod(PogoDeviceClass cls)'''
        def main():
            try:
                py = PyTango.Util(sys.argv)
                py.add_class(«cls.name»Class,«cls.name»,'«cls.name»')
        
                U = PyTango.Util.instance()
                U.server_init()
                U.server_run()
        
            except PyTango.DevFailed,e:
                print '-------> Received a DevFailed exception:',e
            except Exception,e:
                print '-------> An unforeseen exception occured....',e
        
        if __name__ == '__main__':
            main()
    '''
}