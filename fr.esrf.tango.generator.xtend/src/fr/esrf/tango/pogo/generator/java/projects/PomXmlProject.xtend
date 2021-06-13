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

package fr.esrf.tango.pogo.generator.java.projects

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import static extension fr.esrf.tango.pogo.generator.java.JavaUtils.*

class IdeaProject  implements IGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		for (cls : resource.allContents.toIterable.filter(typeof(PogoDeviceClass))) {
			if (cls.description.language.toLowerCase.equals("java")) {
				if (cls.description.filestogenerate.contains("pom.xml")) {
					printTrace("Generating ../../../pom.xml")
					fsa.generateFile("../../../pom.xml", cls.generatePomXmlMain)
				}
			}
		}
	}	

	//======================================================
	// define the pom.xml project files
	//======================================================
	def generatePomXmlMain(PogoDeviceClass cls) '''
		<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		    <modelVersion>4.0.0</modelVersion>
		
		    <groupId>org.tango.server</groupId>
		    <artifactId>«cls.name»</artifactId>
		    <version>1.0</version>
		    <packaging>jar</packaging>
		
		    <name>«cls.name» Tango server</name>
		
		    <developers>
		        <developer>
		            <name>«getUser()»</name>
		            <email>«cls.description.identification.author»@«cls.description.identification.emailDomain»</email>
		            <organizationUrl>«cls.institute»</organizationUrl>
		            <roles>
		                <role>Developer</role>
		            </roles>
		        </developer>
		    </developers>
		
		    <scm>
		        <connection>scm:git:git@github.com:tango-controls/${project.artifactId}.git</connection>
		        <developerConnection>scm:git:git@github.com:tango-controls/${project.artifactId}.git</developerConnection>
		        <url>https://github.com/tango-controls/${project.artifactId}</url>
		        <tag>HEAD</tag>
		    </scm>
		
		    <dependencies>
		        <dependency>
		            <groupId>org.tango-controls</groupId>
		            <artifactId>JTangoServer</artifactId>
		            <version>«getRelease()»</version>
		        </dependency>
		    </dependencies>
		
		    <build>
		        <plugins>
		            <plugin>
		                <groupId>org.apache.maven.plugins</groupId>
		                <artifactId>maven-compiler-plugin</artifactId>
		                <configuration>
		                    <source>1.8</source>
		                    <target>1.8</target>
		                    <encoding>UTF-8</encoding>
		                </configuration>
		            </plugin>
		            <plugin>
		                <artifactId>maven-release-plugin</artifactId>
		                <version>2.5.3</version>
		                <configuration>
		                    <useReleaseProfile>false</useReleaseProfile>
		                    <releaseProfiles>release</releaseProfiles>
		                    <autoVersionSubmodules>true</autoVersionSubmodules>
		                </configuration>
		            </plugin>
		            <plugin>
		                <groupId>org.apache.maven.plugins</groupId>
		                <artifactId>maven-jar-plugin</artifactId>
		                <configuration>
		                    <archive>
		                        <manifest>
		                            <mainClass>org.tango.«cls.name.toLowerCase».«cls.name»</mainClass>
		                            <addDefaultImplementationEntries>true</addDefaultImplementationEntries>
		                            <addDefaultSpecificationEntries>true</addDefaultSpecificationEntries>
		                        </manifest>
		                    </archive>
		                </configuration>
		            </plugin>
		        </plugins>
		    </build>
		
		    <!-- access to snapshot version of JTango  -->
		    <repositories>
		        <repository>
		            <id>ossrh</id>
		            <url>https://oss.sonatype.org/content/repositories/snapshots</url>
		            <releases>
		                <enabled>false</enabled>
		            </releases>
		            <snapshots>
		                <enabled>true</enabled>
		            </snapshots>
		        </repository>
		    </repositories>
		</project>
	'''
}