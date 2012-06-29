package fr.esrf.tango.pogo.generator.cpp.global

import fr.esrf.tango.pogo.pogoDsl.Property
import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import com.google.inject.Inject
import static extension fr.esrf.tango.pogo.generator.cpp.global.StringUtils.*
import static extension fr.esrf.tango.pogo.generator.cpp.global.ProtectedArea.*
import static extension fr.esrf.tango.pogo.generator.cpp.global.CppTypeDefinitions.*
import static extension fr.esrf.tango.pogo.generator.cpp.global.InheritanceUtils.*

//======================================================
//	Attribute utilities
//======================================================
class Properties {
	@Inject extension StringUtils
	@Inject extension InheritanceUtils
	@Inject	extension ProtectedArea
	@Inject	extension Headers


	//======================================================
	//	Define get_device_property  methods
	//======================================================
	def getDevicePropertiesMethod(PogoDeviceClass cls) '''
		«cls.simpleMethodHeader("get_device_property", "Read database to initialize property data members.")»
		void «cls.name»::get_device_property()
		{
			«cls.protectedArea("get_device_property_before", "Initialize property data members", true)»
		
			//	Read device properties from database.
			Tango::DbData	dev_prop;
			«FOR Property property : cls.deviceProperties»
				dev_prop.push_back(Tango::DbDatum("«property.name»"));
			«ENDFOR»
		
			//	is there at least one property to be read ?
			if (dev_prop.size()>0)
			{
				//	Call database and extract values
				if (Tango::Util::instance()->_UseDb==true)
					get_db_device()->get_property(dev_prop);
			
				//	get instance on «cls.name»Class to get class property
				Tango::DbDatum	def_prop, cl_prop;
				«cls.name»Class	*ds_class =
					(static_cast<«cls.name»Class *>(get_device_class()));
				int	i = -1;
		
				«FOR Property property : cls.deviceProperties»
				//	Try to initialize «property.name» from class property
				cl_prop = ds_class->get_class_property(dev_prop[++i].name);
				if (cl_prop.is_empty()==false)	cl_prop  >>  «property.name.dataMemberName»;
				else {
					//	Try to initialize «property.name» from default device value
					def_prop = ds_class->get_default_device_property(dev_prop[i].name);
					if (def_prop.is_empty()==false)	def_prop  >>  «property.name.dataMemberName»;
				}
				//	And try to extract «property.name» value from database
				if (dev_prop[i].is_empty()==false)	dev_prop[i]  >>  «property.name.dataMemberName»;
				«IF isTrue(property.mandatory)»
					//	Property StartDsPath is mandatory, check if has been defined in database.
					check_mandatory_property(cl_prop, dev_prop[i]);
				«ENDIF»

				«ENDFOR»
			}
		
			«cls.protectedArea("get_device_property_after", "Check device property data members init", true)»
		}
	'''


	//======================================================
	//	Define get_class_property  methods
	//======================================================
	def getClassPropertiesMethod(PogoDeviceClass cls) '''
		«cls.simpleMethodHeaderClass("get_class_property", "Read database to initialize class property data members.")»
		void «cls.name»Class::get_class_property()
		{
			«cls.protectedAreaClass("get_class_property_before", "Initialize class property data members", true)»
			//	Read class properties from database.
			«FOR Property property : cls.classProperties»
				cl_prop.push_back(Tango::DbDatum("«property.name»"));
			«ENDFOR»
			
			//	Call database and extract values
			if (Tango::Util::instance()->_UseDb==true)
				get_db_class()->get_property(cl_prop);
			Tango::DbDatum	def_prop;
			int	i = -1;
		
			«FOR Property property : cls.classProperties»
				//	Try to extract «property.name» value
				if (cl_prop[++i].is_empty()==false)	cl_prop[i]  >>  «property.name.dataMemberName»;
				else
				{
					//	Check default value for «property.name»
					def_prop = get_default_class_property(cl_prop[i].name);
					if (def_prop.is_empty()==false)
					{
						def_prop    >>  «property.name.dataMemberName»;
						cl_prop[i]  <<  «property.name.dataMemberName»;
					}
				}
			«ENDFOR»
			«cls.protectedAreaClass("get_class_property_after", "Check class property data members init", true)»

		}
	'''

	//==========================================================
	// Define Property related methods for DeviceClass.cpp
	//==========================================================
	def propertyRelatedMethod(PogoDeviceClass cls) '''
		«cls.simpleMethodHeaderClass("get_class_property",
			"Get the class property for specified name.")»
		Tango::DbDatum «cls.name»Class::get_class_property(string &prop_name)
		{
			for (unsigned int i=0 ; i<cl_prop.size() ; i++)
				if (cl_prop[i].name == prop_name)
					return cl_prop[i];
			//	if not found, returns  an empty DbDatum
			return Tango::DbDatum(prop_name);
		}
		
		«cls.simpleMethodHeaderClass("get_default_device_property",
			"Return the default value for device property.")»
		Tango::DbDatum «cls.name»Class::get_default_device_property(string &prop_name)
		{
			for (unsigned int i=0 ; i<dev_def_prop.size() ; i++)
				if (dev_def_prop[i].name == prop_name)
					return dev_def_prop[i];
			//	if not found, return  an empty DbDatum
			return Tango::DbDatum(prop_name);
		}
		
		«cls.simpleMethodHeaderClass("get_default_class_property",
			"Return the default value for class property.")»
		Tango::DbDatum «cls.name»Class::get_default_class_property(string &prop_name)
		{
			for (unsigned int i=0 ; i<cl_def_prop.size() ; i++)
				if (cl_def_prop[i].name == prop_name)
					return cl_def_prop[i];
			//	if not found, return  an empty DbDatum
			return Tango::DbDatum(prop_name);
		}
		
		«IF cls.classProperties.size>0»
			«cls.getClassPropertiesMethod»
		«ENDIF»
		
		«cls.setDefaultPropertiesForWizard»

		«cls.writeClassProperties»
	'''

	//==========================================================
	// Define class property wizzard related for DeviceClass.cpp
	//==========================================================
	def setDefaultPropertyForWizard(Property property, String target)  '''
		prop_name = "«property.name»";
		prop_desc = "«property.description.oneLineString»";
		prop_def  = "«property.defaultPropValue.list2String»";
		vect_data.clear();
		«FOR String value : property.defaultPropValue»
			vect_data.push_back("«value»");
		«ENDFOR»
		if (prop_def.length()>0)
		{
			Tango::DbDatum	data(prop_name);
			data << vect_data ;
			dev_def_prop.push_back(data);
			add_wiz_«target»_prop(prop_name, prop_desc,  prop_def);
		}
		else
			add_wiz_«target»_prop(prop_name, prop_desc);
	'''
	
	//==========================================================
	//	Define write_class_proerty method
	//==========================================================
	def writeClassProperties(PogoDeviceClass cls)  '''
		«cls.simpleMethodHeaderClass("write_class_property", "Set class description fields as property in database")»
		void «cls.name»Class::write_class_property()
		{
		«IF cls.isConcreteClass»
			//	First time, check if database used
			if (Tango::Util::_UseDb == false)
				return;
		
			Tango::DbData	data;
			string	classname = get_name();
			string	header;
			string::size_type	start, end;

			//	Put title
			Tango::DbDatum	title("ProjectTitle");
			string	str_title("«cls.description.title»");
			title << str_title;
			data.push_back(title);
		
			//	Put Description
			Tango::DbDatum	description("Description");
			vector<string>	str_desc;
			«cls.description.description.string2Vector("str_desc")»
			description << str_desc;
			data.push_back(description);

			//	put cvs or svn location
			string	filename("«cls.name»");
			filename += "Class.cpp";

			// check for cvs information
			string	src_path(CvsPath);
			start = src_path.find("/");
			if (start!=string::npos)
			{
				end   = src_path.find(filename);
				if (end>start)
				{
					string	strloc = src_path.substr(start, end-start);
					//	Check if specific repository
					start = strloc.find("/cvsroot/");
					if (start!=string::npos && start>0)
					{
						string	repository = strloc.substr(0, start);
						if (repository.find("/segfs/")!=string::npos)
							strloc = "ESRF:" + strloc.substr(start, strloc.length()-start);
					}
					Tango::DbDatum	cvs_loc("cvs_location");
					cvs_loc << strloc;
					data.push_back(cvs_loc);
				}
			}

			// check for svn information
			else
			{
				string	src_path(SvnPath);
				start = src_path.find("://");
				if (start!=string::npos)
				{
					end = src_path.find(filename);
					if (end>start)
					{
						header = "$HeadURL: ";
						start = header.length();
						string	strloc = src_path.substr(start, (end-start));
						
						Tango::DbDatum	svn_loc("svn_location");
						svn_loc << strloc;
						data.push_back(svn_loc);
					}
				}
			}
		
			//	Get CVS or SVN revision tag
			
			// CVS tag
			string	tagname(TagName);
			header = "$Name: ";
			start = header.length();
			string	endstr(" $");
			
			end   = tagname.find(endstr);
			if (end!=string::npos && end>start)
			{
				string	strtag = tagname.substr(start, end-start);
				Tango::DbDatum	cvs_tag("cvs_tag");
				cvs_tag << strtag;
				data.push_back(cvs_tag);
			}
			
			// SVN tag
			string	svnpath(SvnPath);
			header = "$HeadURL: ";
			start = header.length();
			
			end   = svnpath.find(endstr);
			if (end!=string::npos && end>start)
			{
				string	strloc = svnpath.substr(start, end-start);
				
				string tagstr ("/tags/");
				start = strloc.find(tagstr);
				if ( start!=string::npos )
				{
					start = start + tagstr.length();
					end   = strloc.find(filename);
					string	strtag = strloc.substr(start, end-start-1);
					
					Tango::DbDatum	svn_tag("svn_tag");
					svn_tag << strtag;
					data.push_back(svn_tag);
				}
			}
		
			//	Get URL location
			string	httpServ(HttpServer);
			if (httpServ.length()>0)
			{
				Tango::DbDatum	db_doc_url("doc_url");
				db_doc_url << httpServ;
				data.push_back(db_doc_url);
			}
		
			//  Put inheritance
			Tango::DbDatum	inher_datum("InheritedFrom");
			vector<string> inheritance;
			inheritance.push_back("«DeviceImpl»");
			inher_datum << inheritance;
			data.push_back(inher_datum);
		
			//	Call database and and values
			get_db_class()->put_property(data);
		«ENDIF»
		}
	'''


	//==========================================================
	//	Define set default values for wizard method
	//==========================================================
	def setDefaultPropertiesForWizard(PogoDeviceClass cls)  '''
		«cls.simpleMethodHeaderClass("set_default_property", "Set default property (class and device) for wizard.\n"+
			"For each property, add to wizard property name and description.\n"+
			"If default value has been set, add it to wizard property and\nstore it in a DbDatum."
		)»
		void «cls.name»Class::set_default_property()
		{
			string	prop_name;
			string	prop_desc;
			string	prop_def;
			vector<string>	vect_data;

			//	Set Default Class Properties
			«FOR Property property : cls.classProperties»
				«IF property.concreteHere»
					«property.setDefaultPropertyForWizard("class")»
				«ENDIF»
			«ENDFOR»

			//	Set Default device Properties
			«FOR Property property : cls.deviceProperties»
				«IF property.concreteHere»
					«property.setDefaultPropertyForWizard("dev")»
				«ENDIF»
			«ENDFOR»
		}
	'''


	//==========================================================
	// Define class property related delarations for DeviceClass.cpp
	//==========================================================
	def classPropertyDeclarations(PogoDeviceClass cls)  '''
		«IF cls.classProperties.size>0»
		//	Class properties data members
		public:
			«FOR Property property : cls.classProperties»
				//	«property.name»:	«property.description.comments("//  ")»
				«property.type.cppPropType»	«property.name.dataMemberName»;
			«ENDFOR»
		«ENDIF»
		public:
			//	write class properties data members
			Tango::DbData	cl_prop;
			Tango::DbData	cl_def_prop;
			Tango::DbData	dev_def_prop;
	'''
	
}