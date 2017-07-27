//+======================================================================
// $Source$
//
// Project:   Tango
//
// Description:  java source code for the Module class definition .
//
// $Author$
//
// Copyright (C) :      2004,2005,2006,2007,2008
//						European Synchrotron Radiation Facility
//                      BP 220, Grenoble 38043
//                      FRANCE
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
// $Revision$
//
// $Log$
// Revision 1.2  2008/11/20 13:05:55  pascal_verdier
// Methods moved from Utils to PogoUtils class.
//
// Revision 1.1  2008/11/10 15:21:46  pascal_verdier
// *** empty log message ***
//
//-======================================================================

package pogo.class2www;

import pogo.gene.PogoClass;
import pogo.gene.PogoDefs;
import pogo.gene.PogoUtil;


/**
 *	This class is able to
 *
 * @author  verdier
 */

public class  Module
{
	public String		name;
	public String		cvs_path;
	public String		html_path;
	public PogoClass	server;
	public Family		family;
	public Repository	repository;
	public int			repos_type=Repository.CVS;
	public boolean		doc_done = false;
	public String		tag = "";

	//===============================================================
	//===============================================================
	public Module(String name, String cvs_path, Repository repository, Family family, int repos_type)
	{
		this.name       = name;
		this.cvs_path   = cvs_path;
		this.repository = repository;
		this.family     = family;
		this.repos_type = repos_type;
	}
	//===============================================================
	//===============================================================
	public void setHtmlPath(String path)
	{
		this.html_path = path;
	}
	//===============================================================
	//===============================================================
	public String getSummary()
	{
		String	description = server.class_desc;
		if (description==null || description.length()==0)
			description = "Tango Device Class";
		String	doc_url = Class2www.web_home + "/" + html_path + "/" + IHtmlTemplates.html_index;
		String	hosted_url;
		if (repository.remote)
		{
			hosted_url = repository.url + cvs_path;		//	Repository link
			if (repos_type==Repository.SVN)
				hosted_url = PogoUtil.strReplace(hosted_url, "cvs", "svn");
		}
		else
			hosted_url = doc_url;	//	ESRF case (server doc)

		//	Build author and institute address.
		String	author = (server.author==null)? "........" : server.author;
		InstituteList.Institute	in = Class2www.instituteList.getInstituteByAuthor(author);
		String	institute;
		if (in==null)
			institute = "??";
		else
		{
			institute =	in.name;
			if (in.address!=null)
			{
				institute += ":  " + "<a href=mailto:"+ in.address + "?subject="+server.class_name+
						"> "+ in.address + "</a>";
			}
		}
		String	revision = server.revision;
		if (revision==null)
			revision = "";

		String	str = IHtmlTemplates.summary;
		str = PogoUtil.strReplace(str, "$CLASS_NAME",  server.class_name);
		str = PogoUtil.strReplace(str, "$MODULE_NAME", name);
		str = PogoUtil.strReplace(str, "$AUTHOR",      author);
		str = PogoUtil.strReplace(str, "$INSTITUTE",   institute);
		str = PogoUtil.strReplace(str, "$REVISION",    revision);
		str = PogoUtil.strReplace(str, "$HOSTED_URL",  hosted_url);
		str = PogoUtil.strReplace(str, "$FAMILY",      family.name);
		str = PogoUtil.strReplace(str, "$LANGUAGE",    PogoDefs.languageStr[server.language]);
		str = PogoUtil.strReplace(str, "$REPOSITORY",  repository.name);
		str = PogoUtil.strReplace(str, "$REPOS_TYPE",  Repository.RepositoryTypeStr[repos_type].toLowerCase());
		str = PogoUtil.strReplace(str, "$DESCRIPTION", description);
		str = PogoUtil.strReplace(str, "$WEB_URL", doc_url);

		//	If not ESRF (local) -> add check out command
		if (repository.remote)
		{
			StringBuffer	sb = new StringBuffer("<Br><b>Check out command:</b>\n<ul>\t");
			if (repos_type==Repository.CVS)
			{
				//	CVS command -> check if tag known
				sb.append("cvs  -d:pserver:anonymous@").append(repository.name)
					.append(".cvs.sourceforge.net:/cvsroot/").append(repository.name)
					.append(" co &nbsp&nbsp ");

				if (server.revision!=null && server.revision.length()>0)
					sb.append("  -r ").append(server.revision).append(" &nbsp&nbsp ");
				sb.append(name);
				sb.append("\n</ul>\n");
				str += sb.toString();
			}
			else
			{
				//	SVN
				int start = cvs_path.indexOf(family.name);
				if (start>0)
				{
					start += family.name.length() + 1;	//	+1 for '/'
					int	end= cvs_path.indexOf('/', start);
					String	svn_path;
					if (end>0)
						svn_path = cvs_path.substring(start, end);
					else
						svn_path = cvs_path.substring(start);

					sb.append("svn co http://tango-ds.svn.sourceforge.net/svnroot/tango-ds/Servers/");
					sb.append(family.name).append("/").append(svn_path);
					sb.append("\n</ul>\n");
					str += sb.toString();
				}
			}
		}

		return str;
	}
	//===============================================================
	//===============================================================
	public String getTableLine()
	{
		if (server==null)
		{
			System.err.println(name + "  server field is null !!!!");
			return "";
		}
		String	hosted_url;
		if (repository.name.toLowerCase().indexOf("esrf")<0)	//	Not ESRF repos
		{
			hosted_url = repository.url + cvs_path + "/";		//	Repository link
			if (repos_type==Repository.SVN)
				hosted_url = PogoUtil.strReplace(hosted_url, "cvs", "svn");
		}
		else
			hosted_url = name + "/" + IHtmlTemplates.html_index;	//	ESRF case (server doc)

		String	description =  Utils.removeHtmlTag(server.class_desc);
		if (description==null || description.length()==0)
			description = "Tango Device Class";
		else
		if (description.length()>180)
			description = description.substring(0, 180) + "...";

		String	str_repos_type = Repository.RepositoryTypeStr[repos_type];
		String	alpha_home = (repository.remote)? "../.." : "..";

		String	str = IHtmlTemplates.table_line;
		str = PogoUtil.strReplace(str, "$LANGUAGE",    PogoDefs.languageStr[server.language]);
		str = PogoUtil.strReplace(str, "$REPOS_TYPE",  str_repos_type);
		str = PogoUtil.strReplace(str, "$REPOS_HOME",  alpha_home);
		str = PogoUtil.strReplace(str, "$CLASS_NAME",  server.class_name);
		str = PogoUtil.strReplace(str, "$DESCRIPTION", description);
		str = PogoUtil.strReplace(str, "$DOC_URL",     name+"/" + IHtmlTemplates.html_index);
		str = PogoUtil.strReplace(str, "$HOSTED_URL",  hosted_url);
		return str;
	}
	//===============================================================
	//===============================================================
	public String toString()
	{
		return name;
	}
	//===============================================================
	//===============================================================
}
