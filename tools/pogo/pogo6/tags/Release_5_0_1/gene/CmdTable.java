//+======================================================================
// $Source$
//
// Project:   Tango
//
// Description:	java source code to build Command Table from server code.
//
// $Author$
//
// $Version$
//
// $Log$
// Revision 3.12  2006/11/02 11:41:00  pascal_verdier
// Python code generation added.
//
// Revision 3.11  2006/09/19 13:20:52  pascal_verdier
// Allow boolean attribute for java servers.
// Bug in command factory for abstract class generation fixed.
// Bug in changing class name fixed.
// Abstarct classes sorted.
//
// Revision 3.10  2006/06/26 09:22:47  pascal_verdier
// ango-5.5 compatiblity.
// extern C method added to be used as shared library.
// VCC 6 project file generated if running on Win32.
// .obj, .so, executable files generated in separated directories.
//
// Revision 3.9  2005/12/20 11:17:17  pascal_verdier
// If StateMachine file not found, display warning message
// and generate a new one at next code generation.
//
// Revision 3.8  2005/11/24 08:29:16  pascal_verdier
// Analized with intelliJid.
//
// Revision 3.7  2005/06/14 08:44:25  pascal_verdier
// SuperClass is replaced by AbstractClass.
//
// Revision 3.6  2005/01/28 08:06:53  pascal_verdier
// Bug on ; char in command description fixed.
//
// Revision 3.5  2004/12/01 13:59:06  pascal_verdier
// addCommentsTable() modified (tab -> spaces).
//
// Revision 3.4  2004/11/22 11:07:46  pascal_verdier
// First revision to generate a super class.
// User code managed in device_factory().
//
// Revision 3.3  2004/09/07 11:59:28  pascal_verdier
// Remove CVS log messages and info from templates.
//
// Revision 3.2  2004/08/26 07:13:06  pascal_verdier
// Attributes are now generated as class.
//
// Revision 3.1  2003/09/10 08:11:30  pascal_verdier
// Minor bugs fixed.
// HTML doc generated with more details.
//
// Revision 3.0  2003/04/29 10:39:50  pascal_verdier
// TANGO 3.0 compatibility
// little bugs fixed.
//
// Revision 1.33  2003/01/16 14:32:36  verdier
// Tango classe files detected for open JFileChooser.
//
// Revision 1.32  2002/10/03 13:53:47  verdier
// Pogo has been used without known bug.
// Put class description as class property.
//
// Revision 1.31  2002/04/25 12:05:08  verdier
// IDL 2 implemented for c++ servers
//
// Revision 1.30  2002/02/06 15:20:20  verdier
// Java code generation updated.
//
// Revision 1.26  2001/12/18 10:12:22  verdier
// Attribute user default property code added.
//
// Revision 1.25  2001/11/09 09:46:13  verdier
// Many bugs fixed.
//
// Revision 1.24  2001/04/04 12:21:27  verdier
// Property management added for cpp.
//
// Revision 1.23  2000/10/24 06:20:13  verdier
// The compatibility with TANGO2 has been tested on DatabaseDs.
//
// Revision 1.22  2000/10/02 05:52:20  verdier
// Attribute code generated is now compatible with Tango 2.
//
// Revision 1.21  2000/09/22 08:54:31  verdier
// DevState & DevStatus are virtual.
// First tests with Tango2
// Taco import utility added.
//
// Revision 1.20  2000/07/07 13:29:17  verdier
// Utilities added after first users.
//
// Revision 1.18  2000/06/20 07:01:38  verdier
// Right button double click management added for :
// editing src code, creating item, editing class....
// Little bugs fixed on generation/re-read src code.
//
// Revision 1.17  2000/05/12 07:35:41  verdier
// Attributes management added for java generation.
//
// Revision 1.16  2000/04/26 06:06:52  verdier
// The save/restore file (.pogo) does not exist anymore.
// DevStates and DevStates allowed management is now available for java.
//
// Revision 1.15  2000/04/18 08:13:48  verdier
// Management of DevStates to allow command added.
//
// Revision 1.14  2000/04/12 09:24:10  verdier
// Methods to manage attributes are now generated
// Only if at leat one attribute exists.
//
// Revision 1.13  2000/04/11 09:34:13  verdier
// Attributes Management Added.
//
// Revision 1.12  2000/03/29 13:14:00  verdier
// Doc generation added.
//
// Revision 1.11  2000/03/21 12:52:37  verdier
// Command and class description from cpp source file.
// States (name and description) from cpp source file.
//
// Revision 1.10  2000/03/03 09:45:56  verdier
// States Management has been added (for .pogo files).
//
// Revision 1.8  2000/01/12  10:23:28  verdier
// Set as description the methods where the arguments have been modified.
//
// Revision 1.7  1999/12/29 10:30:35  verdier
// The data members are not owerwritten during re-generation.
//
// Revision 1.6  1999/12/28  13:30:10  verdier
// After Regeneration of DataBase device server OK.
//
// Revision 1.5  1999/12/22  13:30:21  verdier
// C++ file first generation compiled
//
// Revision 1.4  1999/12/20  13:00:05  verdier
// Argin and Argout's description added for java.
//
// Revision 1.3  1999/12/09  15:30:59  verdier
// Java code generation for first tango version.
//
// Revision 1.2  1999/12/07  16:03:58  verdier
// *** empty log message ***
//
// Revision 1.1  1999/12/06  08:40:46  verdier
// Initial revision
//
//
// copyleft 1995 by European Synchrotron Radiation Facility, Grenoble, France
//							 All Rights Reversed
//-======================================================================

package pogo.gene;


import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Vector;

//-======================================================================
/**
 * This class is a just a vector containing the <i>Cmd</i> objects,
 * for the PogoClass object.
 *
 * @author	$Author$
 * @version	$Revision$
 */
//-======================================================================
public class CmdTable extends Vector implements PogoDefs
{
	Exception	except = null;
	private void createVirtualStatusCmd()
	{
		//	If do not exist, create 2 dummy methods, DevState and DevStatus
		//	They will NOT be able to be deleted or modified.
		//	Used only to display or override the DeviceImpl class virtual method.
		//--------------------------------------------------------------------
		Cmd cmd1 = new Cmd("State", "StateCmd",
							"Tango::DEV_VOID", 
							"Tango::DEV_STATE", 
							"none.", 
							"State Code",
							state_desc);
		cmd1.virtual_method = true;
		cmd1.override_method = NOT_OVERRIDE;
		addElement(cmd1);
		
		Cmd cmd2 = new Cmd("Status", "StatusCmd",
							"Tango::DEV_VOID", 
							"Tango::CONST_DEV_STRING", 
							"none.", 
							"Status description",
							status_desc);
		cmd2.virtual_method = true;
		cmd2.override_method = NOT_OVERRIDE;
		addElement(cmd2);
	}
//============================================================================
/**
 * Constructor for Command Table from a <i>java.util.Vector</i> class.
 *
 */
//============================================================================
	public CmdTable()
	{
		createVirtualStatusCmd();
	}
//============================================================================
/**
 * Constructor for Command Table from a <i>java.util.Vector</i> class.
 *
 * @param v_in	The input commands vector to be copied.
 */
//============================================================================
	public CmdTable(Vector v_in)
	{
		if (v_in.size()==0)
		{
			createVirtualStatusCmd();
		}
		for (int i=size() ; i<v_in.size() ; i++)
			addElement(v_in.elementAt(i));
	}
//============================================================================
/**
 * Constructor for Command Table from an input file (.pogo, .cpp or .java).
 *
 * @param filename	Name of the file to read commands list and parameters.
 * @exception FileNotFoundException if occured when reading file.
 * @exception SecurityException if occured when reading file.
 * @exception IOException if occured when reading file.
 * @exception PogoException if a synthax error occured when reading file.
 */
//============================================================================
	public CmdTable(String filename, int deviceImpl)
								throws	FileNotFoundException,
										SecurityException,
										IOException,
										PogoException
	{
		//	Check langage to know the key word
		//----------------------------------------
		String	add_list_str;
		int		lang;
		if (filename.indexOf(cppExtention)>0)
		{
			lang = cppLang;
			add_list_str = cppAddCommands;
		}
		else
		if (filename.indexOf(javaExtention)>0)
		{
			lang = javaLang;
			add_list_str = javaAddCommands;
		}
		else
        if (filename.indexOf(pyExtention)>0)
        {
            lang = pyLang;
            add_list_str = pyAddCommands;
        }
        else
            throw new PogoException("Unrecognised file type !");

		//	Open reading file and read it
		//----------------------------------------
		PogoString code = new PogoString(PogoUtil.readFile(filename));

		//	Then Fill objects
		//---------------------------------------------
		createVirtualStatusCmd();

        if (lang==pyLang)
            parsePyCommands(code);
        else
        {
            int	start = code.str.indexOf("::command_factory()");
            start = code.str.indexOf("{", start);

            int end = code.outMethod(start);

            String	cmd_factory = code.str.substring(start, end);

            for (int i=0 ; (i=cmd_factory.indexOf(add_list_str, i))>0 ; i++)
            {
                //	Get the command_factory line source
                //-----------------------------------------
                start = cmd_factory.indexOf(NEW_STR, i) + NEW_STR.length();

                while (cmd_factory.charAt(start)<=' ')
                    start++;
                end = cmd_factory.indexOf("));", start);

                //	Create a new command object
                //------------------------------------------------
                Cmd	cmd = new Cmd(cmd_factory.substring(start, end));
                cmd.setPolledPerriod(cmd_factory, lang);

                //	Get the allowed States
                //-------------------------------
                switch(lang)
                {
                case cppLang:
                    if (deviceImpl<3)
                        cmd.setNotAllowedFor(code.str, lang);
                    break;
                case javaLang:
                    //	Build Java command file
                    //---------------------------------
                    String	path = new PogoString(filename).extractPathFromFullPath();
                    String	jcode = PogoUtil.readFile(path +
                                        "/" + cmd.cmd_class + javaExtention);
                    cmd.setNotAllowedFor(jcode, lang);
                    break;
                }
                //	Add the new command to the vector
                //------------------------------------------------
                addElement(cmd);
            }
        }
    }
//===============================================================
/**
 * Parse Python file for command list
 */
//===============================================================
    private void parsePyCommands(PogoString code) throws PogoException
    {
        //  In python the convention has changed !!!! exec method i the command's name
        ((Cmd)cmdAt(0)).exec_method = "State";
        if (code.indexOf("def State(self):")>0)
            ((Cmd)cmdAt(0)).override_method = ALREADY_OVERRIDED;

        ((Cmd)cmdAt(1)).exec_method = "Status";
        if (code.indexOf("def Status(self):")>0)
            ((Cmd)cmdAt(1)).override_method = ALREADY_OVERRIDED;

        //  Search command list
        int start = code.str.indexOf("Class(PyTango.PyDeviceClass):");
        if (start<0)
            throw new PogoException("No DeviceClass class found !");
        start = code.str.indexOf(pyAddCommands, start);
        if (start<0)
            throw new PogoException("No command list found !");
        start += pyAddCommands.length();

        int end = code.outMethod(start);
        String  cmd_list = code.str.substring(start, end);
        end = 0;
        String  target = "[[";
        //  Check for each cmd
        while ((start=cmd_list.indexOf(target, end))>0)
        {
            //  Get name
            end   = cmd_list.lastIndexOf("\'", start-1);
            start = cmd_list.lastIndexOf("\'", end-1);
            String  name = cmd_list.substring(start+1, end).trim();
            //  Get argin type
            start = end+target.length();
            end   = cmd_list.indexOf(",", start);
            start = cmd_list.lastIndexOf(".", end);
            String  argin_type = "Tango::"+cmd_list.substring(start+1, end).trim();

            //  get argin desc
            start = cmd_list.indexOf("\"", end);
            start++;
            end   = cmd_list.indexOf("\"", start);
            String  argin_desc = cmd_list.substring(start, end).trim();

            //  Get argout type
            start = cmd_list.indexOf("[", end);
            end   = cmd_list.indexOf(",", start);
            start = cmd_list.lastIndexOf(".", end);
            String  argout_type = "Tango::"+cmd_list.substring(start+1, end).trim();

            //  get argout desc
            start = cmd_list.indexOf("\"", end);
            start++;
            end   = cmd_list.indexOf("\"", start);
            String  argout_desc = cmd_list.substring(start, end).trim();

            //  Get kind of property (polling, display level...) if any
            start = cmd_list.indexOf("]", end) + 1;
            end   = cmd_list.indexOf("]", start);
            String  props = cmd_list.substring(start, end);

            //	Create a new command object
            Cmd	cmd = new Cmd(name, name, argin_type, argout_type, argin_desc, argout_desc, "");
            cmd.exec_method = name;
            cmd.parsePyDescription(code.str);
            if (props.length()>2) // not an empty space
                cmd.parsePyProperties(props);
            cmd.setNotAllowedFor(code.str, pyLang);

            //  In python the convention has changed !!!! exec method i the command's name
            cmd.exec_method = name;

            //	Add the new command to the vector
            addElement(cmd);
        }

        //System.out.println();
    }
//===============================================================
/**
 *	Set notAllowedFor table from file allowed.cpp
 */
//===============================================================
	void setAllowedState(String class_name, String filename, boolean is_abstractclass)
				throws	FileNotFoundException, SecurityException,
						IOException, PogoException
	{
		//	Read the description file
		//---------------------------------
		PogoString	readcode;
		
		try
		{
			readcode = new PogoString(PogoUtil.readFile(filename));
		}
		catch (FileNotFoundException e)
		{
			if (is_abstractclass)
				return;
			else
			{
				except = e;
				return;
				//throw e;
			}
		}
		for(int i=0 ; i<size() ; i++)
		{
			Cmd	cmd = cmdAt(i);
			String	signature = cmd.allowedFullSignatureMethod(class_name);
			int	start;
			if ((start=readcode.indexOf(signature))>0)
			{
				String	method = readcode.extractMethodCore(start);
				cmd.notAllowedFor = new DevStateTable(method);
				//System.out.println(cmd.name + ":\n" + cmd.notAllowedFor);
			}
		}
	}
//============================================================================
/**
 * Build or Modify the command factory method.
 *
 * @param	lang	Language to be generated.
 * @return the command factory method core.
 */
//============================================================================
	public String buildCommandFactoryMethod(int lang)
									throws PogoException
	{
        String	retStr = "";

        //	build commands
        for (int i=0 ; i<size(); i++)
        {
            Cmd		cmd = cmdAt(i);
            //	Don't forget to skip dummy status Cmds.
            if (!cmd.virtual_method)
                retStr += cmd.AddCmdFactoryLine(lang);
        }
        if (lang==pyLang)
            return retStr;

        retStr = "{\n" + retStr;
        //	if cpp -> add polling
        switch(lang)
        {
        case javaLang:
            retStr += "\n		//	add polling if any\n" +
                        "		for (int i=0 ; i<command_list.size(); i++)\n\t\t{\n" +
                        "			Command	cmd = (Command)command_list.elementAt(i);\n";
            break;
        case cppLang:
            retStr += "\n	//	add polling if any\n" +
                      "	for (unsigned int i=0 ; i<command_list.size(); i++)\n	{\n";
            break;
        }

        for (int i=0 ; i<size(); i++)
        {
            Cmd		cmd = cmdAt(i);
            //	Don't forget to skip dummy status Cmds.
            if (!cmd.virtual_method)
                retStr += cmd.AddCmdPollingLine(lang);
        }
        if (lang==javaLang)
            retStr += "\t";
        retStr += "	}\n";

        if (lang==javaLang)
            retStr += "\t";
        retStr += "}\n";

        return retStr;
	}
//============================================================================
/**
 * Initilize commands desciption from file
 *
 * @param descFile		Input file name.	
 * @param serverClass	server class name to check good exec method name..	
 * @param lang			Input language.	
 * @exception FileNotFoundException if occured when reading file.
 * @exception SecurityException if occured when reading file.
 * @exception IOException if occured when reading file.
 * @exception PogoException if a synthax error occured when reading file.
 */
//============================================================================
	public void getDescriptions(String descFile, String serverClass, int lang)
								throws	FileNotFoundException,
										SecurityException,
										IOException,
										PogoException
	{
		//	Open File and read it
		//--------------------------------------
		String	readcode = PogoUtil.readFile(descFile);

		//	Get the command's description
		//----------------------------------------
		for (int i=0 ; i<size(); i++)
		{
			if (!cmdAt(i).virtual_method)
				cmdAt(i).getExecMethodDescription(readcode, lang);
		}
	}
//============================================================================
/**
 * 	Check for each command if argin and argout have a correct type.
 *	If argin or argout has an unknown type, a message is prepeared.
 *
 * @return the message with command and args unknown.
 */
//============================================================================
	public String checkArgsType()
	{
		String  str = "";
		
		for (int i=0 ; i<size(); i++)
		{
			Cmd	cmd = cmdAt(i);
			if (cmd.argin.code==Tango_TYPE_UNKNOWN)
				str += "Argin type ("+ cmd.argin.cpp +") unknown for command " +
												cmd.name + "!\n";
			if (cmd.argout.code==Tango_TYPE_UNKNOWN)
				str += "Argout type ("+ cmd.argout.cpp +") unknown for command " +
												cmd.name + "!\n";
		}
		if (str.length()>0)
			return str;
		else
			return null;
	}
//============================================================================
/**
 * Return a the command class for an index.
 *
 * @param idx	index of the command.	
 * @return the command class for this index.
 */
//============================================================================
	public Cmd cmdAt(int idx)
	{
		return ((Cmd)(elementAt(idx)));
	}

//=======================================================================
    /**
     *  Update code for commands exec and state machine methods
     *
     *  @param  code        generated code
     *  @param  readcode    read existing code
     *  @param  template    command template code
     */
//=======================================================================
    String updatePyCommands(String code, String readcode, String template, String class_name) throws PogoException
    {
        //  Split template
        String  target = "return argout";
        int start = template.indexOf(target);
        if (start<0)
            throw new PogoException("Command template syntax error.");
        start += target.length()+1;
        String  exec_templ = template.substring(0, start);
        String  stm_templ  = "\t" + template.substring(start).trim();

        //  Get position to insert
        int insert_pos = code.indexOf(class_name + " command methods");
        insert_pos = code.indexOf("#=========", insert_pos);
        insert_pos = code.indexOf("\n", insert_pos) + 1;

        for (int i=size()-1 ; i>=0 ; i--)
        {
            Cmd cmd = cmdAt(i);
            if (!cmd.virtual_method || cmd.override_method!=NOT_OVERRIDE)
            {
                //  Check if exec method exists
                String  exe_method;
                String  signature = cmd.buildPyExecCmdMethodSignature();
                //  Check if already exists
                if (readcode.indexOf(signature)>0)
                {
                    //  Get it
                    exe_method = PogoUtil.pythonMethod(readcode, signature);
                    exe_method = cmd.pyUpdateDescription(exe_method);
                }
                else
                    exe_method = cmd.buildPyExecMethod(exec_templ);
                exe_method = "\n" + exe_method.trim() + "\n\n";

                String  stm_method = null;
                if (!cmd.virtual_method)
                {
                    //  Check for state machine method
                    signature = "def is_" + cmd.name + "_allowed(self):";
                    stm_method = PogoUtil.pythonMethod(readcode, signature);
                    if (stm_method!=null || cmd.notAllowedFor.size()>0)
                    {
                        if (stm_method==null)
                        {
                            stm_method = stm_templ;
                            target = "TemplCmd";
                            while ((start=stm_method.indexOf(target))>0)
                                stm_method = stm_method.substring(0, start) + cmd.name +
                                       stm_method.substring(start+target.length());
                        }
                        stm_method = cmd.pyUpdateAllowedStates(stm_method, signature);
                        stm_method = "\n" + stm_method.trim() + "\n\n";
                    }
                }
                //  Insert methods
                if (stm_method!=null)
                    code = code.substring(0, insert_pos) + stm_method +
                           code.substring(insert_pos);
                code = code.substring(0, insert_pos) + exe_method +
                       code.substring(insert_pos);
            }
        }
        return code;
    }
//=======================================================================
/**
 *	Buid description table to give correspondance between commands and method's name.
 *
 *	@return Comments table to give correspondance between commands and method's name.
 */
 //=======================================================================
	protected String addCommentsTable()
	{
		//	First time, search max length
		int	max = 0;
		for (int i=0 ; i<size() ; i++)
		{
			Cmd		cmd = cmdAt(i);
			if (cmd.name.length()>max)
				max = cmd.name.length();
		}
		max += 2;

		String  str =
		"//===================================================================\n" +
		"//\n"  +
		"//	The following table gives the correspondance\n" +
		"//	between commands and method's name.\n" +
		"//\n" +
		"//  Command's name";

        for (int j="Command's name".length() ; j<max ; j++)
			str += " ";
		str += "|  Method's name\n";
		str += "//	----------------------------------------\n";
		for (int i=0 ; i<size() ; i++)
		{
			Cmd		cmd = cmdAt(i);
			str += "//  " + cmd.name;
			for (int j=cmd.name.length() ; j<max ; j++)
				str += " ";
			str += "|  " + cmd.exec_method + "()\n";
		}
		str += "//\n" +
		"//===================================================================";

		return str;
	}



//============================================================================
/**
 * Build a String including some parameters for the command at the index.
 *
 * @param idx	The command's index.	
 * @return A String containing name, class name, argin type and argout type
 *			for the command at <i>idx</i> index.
 * @exception	PogoException if the index input parameter is more than 
 *					the number of commands.
 */
//============================================================================
	public String toString(int idx) throws PogoException
	{
		if (idx >= size())
		{
			throw new PogoException("Command index out of bounds !");
		}
		else
		{
			String	str;
			Cmd		cmd = cmdAt(idx);

			str = cmd.name + ", "   + cmd.cmd_class+", " +
							cmd.argin.cpp_code_str+", " + cmd.argout.cpp_code_str;
			return str;
		}
	}

//============================================================================
/**
 * Build a String including some parameters for all commands.
 *
 * @return A String containing name, class name, argin type and argout type
 * 				for all commands.
 */
//============================================================================
	public String toString()
	{
		String	str = "";
		for (int i=0 ; i<size(); i++)
		{
			Cmd		cmd = cmdAt(i);

			str += "--------------------------------------------\n";
			str += cmd.name + ", "   + cmd.cmd_class+", " +
						cmd.argin.cpp_code_str+", " + cmd.argout.cpp_code_str;

			if (cmd.argin.description!=null)
				str += ",\n\t" + cmd.argin.description +
							"\n\t" + cmd.argout.description + "\n";
			else
				str += "\n";
		}
		return str;
	}
}
//-----------------------------------------------------------------------------
/* end of $Source$ */
