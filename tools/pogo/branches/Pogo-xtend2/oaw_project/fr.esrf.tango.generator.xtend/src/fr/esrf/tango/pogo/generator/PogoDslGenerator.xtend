/*
 * generated by Xtext
 */
package fr.esrf.tango.pogo.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import com.google.inject.Inject
import fr.esrf.tango.pogo.generator.java.JavaDevice
//import fr.esrf.tango.pogo.generator.python.PythonDevice
//import fr.esrf.tango.pogo.generator.graphviz.GraphvizDiagram

class PogoDslGenerator implements IGenerator {
	@Inject
	fr.esrf.tango.pogo.generator.cpp.cppMain cppDeviceGenerator
	@Inject
	JavaDevice javaDeviceGenerator
//	@Inject
//	PythonDevice pythonDeviceGenerator
//	@Inject
//	GraphvizDiagram diagramGenerator
	

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		cppDeviceGenerator.doGenerate(resource,fsa)
		javaDeviceGenerator.doGenerate(resource,fsa)
//		pythonDeviceGenerator.doGenerate(resource,fsa)
//		diagramGenerator.doGenerate(resource,fsa)
	}
}
