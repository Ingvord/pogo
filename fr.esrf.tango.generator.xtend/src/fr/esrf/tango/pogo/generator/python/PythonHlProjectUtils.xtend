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

import fr.esrf.tango.pogo.pogoDsl.PogoDeviceClass
import static extension fr.esrf.tango.pogo.generator.common.StringUtils.*
import static extension fr.esrf.tango.pogo.generator.python.PythonTypeDefinitions.*
import com.google.inject.Inject

class PythonHlProjectUtils {
	
    @Inject extension fr.esrf.tango.pogo.generator.common.StringUtils
    @Inject extension ProtectedAreaHL
    @Inject	extension fr.esrf.tango.pogo.generator.python.PythonTypeDefinitions
    @Inject extension fr.esrf.tango.pogo.generator.python.PyUtils
    @Inject extension fr.esrf.tango.pogo.generator.python.PythonUtils
    
	//======================================================
	// Define PythonHl project readme code to be generated
	//======================================================
	def generatePythonHlProjectReadme(PogoDeviceClass cls) '''
## «cls.description.title»

«cls.description.description»

## Requirement

- PyTango >= 8.1.6
- devicetest (for using tests)
- sphinx (for building sphinx documentation)

## Installation

Run python setup.py install

If you want to build sphinx documentation,
run python setup.py build_sphinx

If you want to pass the tests, 
run python setup.py test

## Usage

Now you can start your device server in any
Terminal or console by calling it :

«cls.name» instance_name
	'''

	//======================================================
	// Define PythonHl project release code to be generated
	//======================================================
	def generatePythonHlProjectRelease(PogoDeviceClass cls) '''
# -*- coding: utf-8 -*-
#
# This file is part of the «cls.name» project
#
#«IF cls.description.copyright.isSet»«cls.description.copyright.commentMultiLinesPythonStr»«ENDIF»
#
# Distributed under the terms of the «cls.description.license» license.
# See LICENSE.txt for more info.

"""Release information for Python Package"""

name = """tangods-«cls.name.toLowerCase()»"""
version = "1.0.0"
version_info = version.split(".")
description = """«cls.description.description»"""
author = "«cls.description.identification.author»"
author_email = "«cls.description.identification.author» at «cls.description.identification.emailDomain»"
license = """«cls.description.license»"""
url = """www.tango-controls.org"""
copyright = """«cls.description.copyright.commentMultiLinesPythonStr»"""
	'''
	//======================================================
	// Define PythonHl project init code to be generated
	//======================================================
	def generatePythonHlProjectInit(PogoDeviceClass cls) '''
# -*- coding: utf-8 -*-
#
# This file is part of the «cls.name» project
#
#«IF cls.description.copyright.isSet»«cls.description.copyright.commentMultiLinesPythonStr»«ENDIF»
#
# Distributed under the terms of the «cls.description.license» license.
# See LICENSE.txt for more info.

"""«cls.description.title»

«cls.description.description»
"""

from . import release
from .«cls.name» import «cls.name», main

__version__ = release.version
__version_info__ = release.version_info
__author__ = release.author
	'''	
	//======================================================
	// Define PythonHl project script code to be generated
	//======================================================
	def generatePythonHlProjectScript(PogoDeviceClass cls) '''
#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# This file is part of the «cls.name» project
#
#«IF cls.description.copyright.isSet»«cls.description.copyright.commentMultiLinesPythonStr»«ENDIF»
#
# Distributed under the terms of the «cls.description.license» license.
# See LICENSE.txt for more info.

try:
    from «cls.name» import main
except ImportError:
    import os, sys
    __this_dir = os.path.dirname(os.path.abspath(__file__))
    __package_dir = os.path.join(__this_dir, os.path.pardir)
    sys.path.append(__package_dir)
    from «cls.name» import main

if __name__ == "__main__":
    main()
	'''	
	//======================================================
	// Define PythonHl project license code to be generated
	//======================================================
	def generatePythonHlProjectLicenseGPL(PogoDeviceClass cls) '''
                    GNU GENERAL PUBLIC LICENSE
                       Version 2, June 1991

 Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

                            Preamble

  The licenses for most software are designed to take away your
freedom to share and change it.  By contrast, the GNU General Public
License is intended to guarantee your freedom to share and change free
software--to make sure the software is free for all its users.  This
General Public License applies to most of the Free Software
Foundation's software and to any other program whose authors commit to
using it.  (Some other Free Software Foundation software is covered by
the GNU Lesser General Public License instead.)  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
this service if you wish), that you receive source code or can get it
if you want it, that you can change the software or use pieces of it
in new free programs; and that you know you can do these things.

  To protect your rights, we need to make restrictions that forbid
anyone to deny you these rights or to ask you to surrender the rights.
These restrictions translate to certain responsibilities for you if you
distribute copies of the software, or if you modify it.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must give the recipients all the rights that
you have.  You must make sure that they, too, receive or can get the
source code.  And you must show them these terms so they know their
rights.

  We protect your rights with two steps: (1) copyright the software, and
(2) offer you this license which gives you legal permission to copy,
distribute and/or modify the software.

  Also, for each author's protection and ours, we want to make certain
that everyone understands that there is no warranty for this free
software.  If the software is modified by someone else and passed on, we
want its recipients to know that what they have is not the original, so
that any problems introduced by others will not reflect on the original
authors' reputations.

  Finally, any free program is threatened constantly by software
patents.  We wish to avoid the danger that redistributors of a free
program will individually obtain patent licenses, in effect making the
program proprietary.  To prevent this, we have made it clear that any
patent must be licensed for everyone's free use or not licensed at all.
  The precise terms and conditions for copying, distribution and
modification follow.
                    GNU GENERAL PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
  0. This License applies to any program or other work which contains
a notice placed by the copyright holder saying it may be distributed
under the terms of this General Public License.  The "Program", below,
refers to any such program or work, and a "work based on the Program"
means either the Program or any derivative work under copyright law:
that is to say, a work containing the Program or a portion of it,
either verbatim or with modifications and/or translated into another
language.  (Hereinafter, translation is included without limitation in
the term "modification".)  Each licensee is addressed as "you".
Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope.  The act of
running the Program is not restricted, and the output from the Program
is covered only if its contents constitute a work based on the
Program (independent of having been made by running the Program).
Whether that is true depends on what the Program does.
  1. You may copy and distribute verbatim copies of the Program's
source code as you receive it, in any medium, provided that you
conspicuously and appropriately publish on each copy an appropriate
copyright notice and disclaimer of warranty; keep intact all the
notices that refer to this License and to the absence of any warranty;
and give any other recipients of the Program a copy of this License
along with the Program.

You may charge a fee for the physical act of transferring a copy, and
you may at your option offer warranty protection in exchange for a fee.

  2. You may modify your copy or copies of the Program or any portion
of it, thus forming a work based on the Program, and copy and
distribute such modifications or work under the terms of Section 1
above, provided that you also meet all of these conditions:

    a) You must cause the modified files to carry prominent notices
    stating that you changed the files and the date of any change.

    b) You must cause any work that you distribute or publish, that in
    whole or in part contains or is derived from the Program or any
    part thereof, to be licensed as a whole at no charge to all third
    parties under the terms of this License.

    c) If the modified program normally reads commands interactively
    when run, you must cause it, when started running for such
    interactive use in the most ordinary way, to print or display an
    announcement including an appropriate copyright notice and a
    notice that there is no warranty (or else, saying that you provide
    a warranty) and that users may redistribute the program under
    these conditions, and telling the user how to view a copy of this
    License.  (Exception: if the Program itself is interactive but
    does not normally print such an announcement, your work based on
    the Program is not required to print an announcement.)

These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it.

Thus, it is not the intent of this section to claim rights or contest
your rights to work written entirely by you; rather, the intent is to
exercise the right to control the distribution of derivative or
collective works based on the Program.

In addition, mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.

  3. You may copy and distribute the Program (or a work based on it,
under Section 2) in object code or executable form under the terms of
Sections 1 and 2 above provided that you also do one of the following:

    a) Accompany it with the complete corresponding machine-readable
    source code, which must be distributed under the terms of Sections
    1 and 2 above on a medium customarily used for software interchange; or,

    b) Accompany it with a written offer, valid for at least three
    years, to give any third party, for a charge no more than your
    cost of physically performing source distribution, a complete
    machine-readable copy of the corresponding source code, to be
    distributed under the terms of Sections 1 and 2 above on a medium
    customarily used for software interchange; or,

    c) Accompany it with the information you received as to the offer
    to distribute corresponding source code.  (This alternative is
    allowed only for noncommercial distribution and only if you
    received the program in object code or executable form with such
    an offer, in accord with Subsection b above.)

The source code for a work means the preferred form of the work for
making modifications to it.  For an executable work, complete source
code means all the source code for all modules it contains, plus any
associated interface definition files, plus the scripts used to
control compilation and installation of the executable.  However, as a
special exception, the source code distributed need not include
anything that is normally distributed (in either source or binary
form) with the major components (compiler, kernel, and so on) of the
operating system on which the executable runs, unless that component
itself accompanies the executable.

If distribution of executable or object code is made by offering
access to copy from a designated place, then offering equivalent
access to copy the source code from the same place counts as
distribution of the source code, even though third parties are not
compelled to copy the source along with the object code.

  4. You may not copy, modify, sublicense, or distribute the Program
except as expressly provided under this License.  Any attempt
otherwise to copy, modify, sublicense or distribute the Program is
void, and will automatically terminate your rights under this License.
However, parties who have received copies, or rights, from you under
this License will not have their licenses terminated so long as such
parties remain in full compliance.

  5. You are not required to accept this License, since you have not
signed it.  However, nothing else grants you permission to modify or
distribute the Program or its derivative works.  These actions are
prohibited by law if you do not accept this License.  Therefore, by
modifying or distributing the Program (or any work based on the
Program), you indicate your acceptance of this License to do so, and
all its terms and conditions for copying, distributing or modifying
the Program or works based on it.

  6. Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions.  You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties to
this License.

  7. If, as a consequence of a court judgment or allegation of patent
infringement or for any other reason (not limited to patent issues),
conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot
distribute so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you
may not distribute the Program at all.  For example, if a patent
license would not permit royalty-free redistribution of the Program by
all those who receive copies directly or indirectly through you, then
the only way you could satisfy both it and this License would be to
refrain entirely from distribution of the Program.

If any portion of this section is held invalid or unenforceable under
any particular circumstance, the balance of the section is intended to
apply and the section as a whole is intended to apply in other
circumstances.

It is not the purpose of this section to induce you to infringe any
patents or other property right claims or to contest validity of any
such claims; this section has the sole purpose of protecting the
integrity of the free software distribution system, which is
implemented by public license practices.  Many people have made
generous contributions to the wide range of software distributed
through that system in reliance on consistent application of that
system; it is up to the author/donor to decide if he or she is willing
to distribute software through any other system and a licensee cannot
impose that choice.

This section is intended to make thoroughly clear what is believed to
be a consequence of the rest of this License.

  8. If the distribution and/or use of the Program is restricted in
certain countries either by patents or by copyrighted interfaces, the
original copyright holder who places the Program under this License
may add an explicit geographical distribution limitation excluding
those countries, so that distribution is permitted only in or among
countries not thus excluded.  In such case, this License incorporates
the limitation as if written in the body of this License.

  9. The Free Software Foundation may publish revised and/or new versions
of the General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

Each version is given a distinguishing version number.  If the Program
specifies a version number of this License which applies to it and "any
later version", you have the option of following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation.  If the Program does not specify a version number of
this License, you may choose any version ever published by the Free Software
Foundation.

  10. If you wish to incorporate parts of the Program into other free
programs whose distribution conditions are different, write to the author
to ask for permission.  For software which is copyrighted by the Free
Software Foundation, write to the Free Software Foundation; we sometimes
make exceptions for this.  Our decision will be guided by the two goals
of preserving the free status of all derivatives of our free software and
of promoting the sharing and reuse of software generally.

                            NO WARRANTY

  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
REPAIR OR CORRECTION.

  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES.

                     END OF TERMS AND CONDITIONS

            How to Apply These Terms to Your New Programs

  If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.

  To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
convey the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.

    <one line to give the program's name and a brief idea of what it does.>
    Copyright (C) <year>  <name of author>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

Also add information on how to contact you by electronic and paper mail.

If the program is interactive, make it output a short notice like this
when it starts in an interactive mode:

    Gnomovision version 69, Copyright (C) year name of author
    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
    This is free software, and you are welcome to redistribute it
    under certain conditions; type `show c' for details.

The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License.  Of course, the commands you use may
be called something other than `show w' and `show c'; they could even be
mouse-clicks or menu items--whatever suits your program.

You should also get your employer (if you work as a programmer) or your
school, if any, to sign a "copyright disclaimer" for the program, if
necessary.  Here is a sample; alter the names:

  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
  `Gnomovision' (which makes passes at compilers) written by James Hacker.

  <signature of Ty Coon>, 1 April 1989
  Ty Coon, President of Vice

This General Public License does not permit incorporating your program into
proprietary programs.  If your program is a subroutine library, you may
consider it more useful to permit linking proprietary applications with the
library.  If this is what you want to do, use the GNU Lesser General
Public License instead of this License.

	'''
	
	//======================================================
	// Define PythonHl project license code to be generated
	//======================================================
	def generatePythonHlProjectLicenseLGPL(PogoDeviceClass cls) '''
	GNU LESSER GENERAL PUBLIC LICENSE

Version 3, 29 June 2007

Copyright © 2007 Free Software Foundation, Inc. <http://fsf.org/>

Everyone is permitted to copy and distribute verbatim copies of this 
license document, but changing it is not allowed.

This version of the GNU Lesser General Public License incorporates the 
terms and conditions of version 3 of the GNU General Public License, 
supplemented by the additional permissions listed below.

0. Additional Definitions.

As used herein, “this License” refers to version 3 of the GNU Lesser 
General Public License, and the “GNU GPL” refers to version 3 of the 
GNU General Public License.

“The Library” refers to a covered work governed by this License, other 
than an Application or a Combined Work as defined below.

An “Application” is any work that makes use of an interface provided by 
the Library, but which is not otherwise based on the Library. Defining a 
subclass of a class defined by the Library is deemed a mode of using an 
interface provided by the Library.

A “Combined Work” is a work produced by combining or linking an Application 
with the Library. The particular version of the Library with which the 
Combined Work was made is also called the “Linked Version”.

The “Minimal Corresponding Source” for a Combined Work means the 
Corresponding Source for the Combined Work, excluding any source code for 
portions of the Combined Work that, considered in isolation, are based on 
the Application, and not on the Linked Version.

The “Corresponding Application Code” for a Combined Work means the object 
code and/or source code for the Application, including any data and utility 
programs needed for reproducing the Combined Work from the Application, but 
excluding the System Libraries of the Combined Work.

1. Exception to Section 3 of the GNU GPL.

You may convey a covered work under sections 3 and 4 of this License without
 being bound by section 3 of the GNU GPL.

2. Conveying Modified Versions.

If you modify a copy of the Library, and, in your modifications, a facility 
refers to a function or data to be supplied by an Application that uses the 
facility (other than as an argument passed when the facility is invoked), 
then you may convey a copy of the modified version:

a) under this License, provided that you make a good faith effort to ensure that, 
in the event an Application does not supply the function or data, the facility still 
operates, and performs whatever part of its purpose remains meaningful, or
b) under the GNU GPL, with none of the additional permissions of this License 
applicable to that copy.

3. Object Code Incorporating Material from Library Header Files.

The object code form of an Application may incorporate material from a header file 
that is part of the Library. You may convey such object code under terms of your 
choice, provided that, if the incorporated material is not limited to numerical 
parameters, data structure layouts and accessors, or small macros, inline functions 
and templates (ten or fewer lines in length), you do both of the following:

a) Give prominent notice with each copy of the object code that the Library is used 
in it and that the Library and its use are covered by this License.
b) Accompany the object code with a copy of the GNU GPL and this license document.

4. Combined Works.

You may convey a Combined Work under terms of your choice that, taken together, 
effectively do not restrict modification of the portions of the Library contained 
in the Combined Work and reverse engineering for debugging such modifications, if 
you also do each of the following:

a) Give prominent notice with each copy of the Combined Work that the Library is used 
in it and that the Library and its use are covered by this License.
b) Accompany the Combined Work with a copy of the GNU GPL and this license document.
c) For a Combined Work that displays copyright notices during execution, include the 
copyright notice for the Library among these notices, as well as a reference directing 
the user to the copies of the GNU GPL and this license document.
d) Do one of the following:
0) Convey the Minimal Corresponding Source under the terms of this License, and the 
Corresponding Application Code in a form suitable for, and under terms that permit, 
the user to recombine or relink the Application with a modified version of the Linked 
Version to produce a modified Combined Work, in the manner specified by section 6 of 
the GNU GPL for conveying Corresponding Source.
1) Use a suitable shared library mechanism for linking with the Library. A suitable 
mechanism is one that (a) uses at run time a copy of the Library already present on 
the user's computer system, and (b) will operate properly with a modified version of 
the Library that is interface-compatible with the Linked Version.
e) Provide Installation Information, but only if you would otherwise be required to 
provide such information under section 6 of the GNU GPL, and only to the extent that 
such information is necessary to install and execute a modified version of the Combined 
Work produced by recombining or relinking the Application with a modified version of the 
Linked Version. (If you use option 4d0, the Installation Information must accompany the 
Minimal Corresponding Source and Corresponding Application Code. If you use option 4d1, 
you must provide the Installation Information in the manner specified by section 6 of 
the GNU GPL for conveying Corresponding Source.)

5. Combined Libraries.

You may place library facilities that are a work based on the Library side by side in a 
single library together with other library facilities that are not Applications and are 
not covered by this License, and convey such a combined library under terms of your choice, 
if you do both of the following:

a) Accompany the combined library with a copy of the same work based on the Library, 
uncombined with any other library facilities, conveyed under the terms of this License.
b) Give prominent notice with the combined library that part of it is a work based on 
the Library, and explaining where to find the accompanying uncombined form of the same work.
6. Revised Versions of the GNU Lesser General Public License.
The Free Software Foundation may publish revised and/or new versions of the GNU Lesser 
General Public License from time to time. Such new versions will be similar in spirit 
to the present version, but may differ in detail to address new problems or concerns.

Each version is given a distinguishing version number. If the Library as you received 
it specifies that a certain numbered version of the GNU Lesser General Public License 
“or any later version” applies to it, you have the option of following the terms and 
conditions either of that published version or of any later version published by the 
Free Software Foundation. If the Library as you received it does not specify a version 
number of the GNU Lesser General Public License, you may choose any version of the GNU 
Lesser General Public License ever published by the Free Software Foundation.

If the Library as you received it specifies that a proxy can decide whether future versions
 of the GNU Lesser General Public License shall apply, that proxy's public statement of acceptance
  of any version is permanent authorization for you to choose that version for the Library.
	'''
	//======================================================
	// Define PythonHl project license code to be generated
	//======================================================
	def generatePythonHlProjectLicenseMIT(PogoDeviceClass cls) '''
	The MIT License

Copyright (c) 2006-2010 Stephen M. McKamey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
	'''

	//======================================================
	// Define PythonHl project license code to be generated
	//======================================================
	def generatePythonHlProjectLicenseAPACHE(PogoDeviceClass cls) '''
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright [yyyy] [name of copyright owner]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
	'''
	//======================================================
	// Define PythonHl project manifest code to be generated
	//======================================================
	def generatePythonHlProjectManifest(PogoDeviceClass cls) '''
recursive-include «cls.name» *.py
recursive-include test *.py
include *.rst
include «cls.name».xmi
include *.txt
graft docs

global-exclude *.pyc
global-exclude *.pyo
	'''
    //======================================================
	// Define PythonHl project sphinx conf.py
	//======================================================
	def generatePythonHlSphinxConf(PogoDeviceClass cls) '''
# -*- coding: utf-8 -*-

# Imports
import sys
import os
# Path handling
conf_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(conf_dir, os.path.pardir))
sys.path.insert(0, os.path.join(conf_dir, os.path.pardir, os.path.pardir))

# Configuration
extensions = ['sphinx.ext.autodoc', 'devicedoc']
master_doc = 'index'

# Data
project = u'«cls.name»'
copyright = u"""«cls.description.copyright.commentMultiLinesPythonStr»"""
	'''
    //======================================================
	// Define PythonHl project sphinx index.rst
	//======================================================
	def generatePythonHlSphinxIndex(PogoDeviceClass cls) '''
.. automodule:: «cls.name»
    :members: «cls.name»
	'''
    //======================================================
	// Define PythonHl project setup.cfg
	//======================================================
	def generatePythonHlSetupCfg(PogoDeviceClass cls) '''
[bdist_rpm]
release = 1%{?dist}.
requires = python-pytango
build_requires = python-setuptools
[build_sphinx]
source-dir = docs/source
build-dir  = docs/build
all_files  = 1
	'''
	//======================================================
	// Define PythonHl project setup code to be generated
	//======================================================
	def generatePythonHlProjectSetupOld(PogoDeviceClass cls) '''
# -*- coding: utf-8 -*-
#
# This file is part of the «cls.name» project
#
#«IF cls.description.copyright.isSet»«cls.description.copyright.commentMultiLinesPythonStr»«ENDIF»
#
# Distributed under the terms of the «cls.description.license» license.
# See LICENSE.txt for more info.

import os
import sys

setup_dir = os.path.dirname(os.path.abspath(__file__))

# make sure we use latest info from local code
sys.path.insert(0, setup_dir)

from «cls.name» import release

from distutils.core import setup


def main():
    packages = ['«cls.name»']

    opts = dict(
        name=Release.name,
        version=Release.version,
        description=Release.description,
        url=Release.url,
        packages=packages,
        scripts=['scripts/«cls.name»'],
        test_suite="test",
        )

    setup(**opts)


if __name__ == "__main__":
    main()
'''

	//======================================================
	// Define PythonHl project setup code to be generated
	//======================================================
	def generatePythonHlProjectSetup(PogoDeviceClass cls) '''
#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# This file is part of the «cls.name» project
#
#«IF cls.description.copyright.isSet»«cls.description.copyright.commentMultiLinesPythonStr»«ENDIF»
#
# Distributed under the terms of the «cls.description.license» license.
# See LICENSE.txt for more info.

import os
import sys
from setuptools import setup

setup_dir = os.path.dirname(os.path.abspath(__file__))

# make sure we use latest info from local code
sys.path.insert(0, setup_dir)

readme_filename = os.path.join(setup_dir, 'README.rst')
with open(readme_filename) as file:
    long_description = file.read()

release_filename = os.path.join(setup_dir, '«cls.name»', 'release.py')
exec(open(release_filename).read())

pack = ['«cls.name»']

setup(name=name,
      version=version,
      description='«cls.description.description.oneLineString»',
      packages=pack,
      include_package_data=True,
      test_suite="test",
      entry_points={'console_scripts':['«cls.name» = «cls.name»:main']},
      author='«cls.description.identification.author»',
      author_email='«cls.description.identification.author» at «cls.description.identification.emailDomain»',
      license='«cls.description.license»',
      long_description=long_description,
      url='www.tango-controls.org',
      platforms="«cls.description.identification.platform»"
      )
'''
	//======================================================
	// Define PythonHl pyunit test script code to be generated
	//======================================================
	def generatePythonHlTestGwt(PogoDeviceClass cls) '''
#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# This file is part of the «cls.name» project
#
#«IF cls.description.copyright.isSet»«cls.description.copyright.commentMultiLinesPythonStr»«ENDIF»
#
# Distributed under the terms of the «cls.description.license» license.
# See LICENSE.txt for more info.
"""Contain the tests for the «cls.description.title»."""

# Path
import sys
import os
path = os.path.join(os.path.dirname(__file__), os.pardir)
sys.path.insert(0, os.path.abspath(path))

# Imports
from time import sleep
from mock import MagicMock
from PyTango import DevFailed, DevState
from devicetest import DeviceTestCase, main
from «cls.name» import «cls.name»

# Note:
#
# Since the device uses an inner thread, it is necessary to
# wait during the tests in order the let the device update itself.
# Hence, the sleep calls have to be secured enough not to produce
# any inconsistent behavior. However, the unittests need to run fast.
# Here, we use a factor 3 between the read period and the sleep calls.
#
# Look at devicetest examples for more advanced testing

# Scenario example
# Scenario(
#     "Simple read in STANDBY state",
#     Given(state=DevState.STANDBY),
#     When(read=True),
#     Then(expected=0)),


# Scenario class
class Scenario:
    def __init__(self, desc, given, when, then):
        self.desc = desc
        self.given, self.when, self.then = given, when, then

    def __iter__(self):
        list = [self.given.kwargs, self.when.kwargs, self.then.kwargs]
        return iter(list)


# GWT base class
class GwtBase:
    def __init__(self, **kwargs):
        self.kwargs = kwargs


# Given class
class Given(GwtBase):
    pass


# When class
class When(GwtBase):
    pass


# Then class
class Then(GwtBase):
    pass


# Device test case
class «cls.name»DeviceTestCase(DeviceTestCase):
    """Test case for packet generation."""
    device = «cls.name»
    properties = {«FOR property : cls.deviceProperties»'«property.name»': '«property.defaultPropValue.get(0)»',«ENDFOR»
                  «IF !cls.classProperties.empty»«FOR property : cls.classProperties»'«property.name»': '«property.defaultPropValue.get(0)»'«ENDFOR»«ENDIF»}
    empty = None  # Should be []

    «FOR attr : cls.attributes»
    «attr.name»_scenari = [
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,attr.name + "_scn")»«ENDIF»
    ]
    «ENDFOR»

    «FOR cmd : cls.commands»
    «cmd.name»_scenari = [
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,cmd.name + "_scn")»«ENDIF»
    ]
    «ENDFOR»

    @classmethod
    def mocking(cls):
        """Mock external libraries."""
        # Example : Mock numpy
        # cls.numpy = «cls.name».numpy = MagicMock()
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,"mocking")»«ENDIF»

    def test_properties(self):
        # test the properties
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,"test_properties")»«ENDIF»
        pass

    «FOR attr : cls.attributes»
    def given_«attr.name»(self, state=DevState.STANDBY, **kwargs):
        """'Given' statement for «attr.name»"""
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,"given_" + attr.name)»«ENDIF»
        self.assertEqual(self.device.State(), state)

    def when_«attr.name»(self, read=True, write=False, value=None, **kwargs):
        """'When' statement for «attr.name»"""
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,"when_" + attr.name)»«ENDIF»
        if write:
            self.device.«attr.name» = value
        if read:
            return self.device.«attr.name»

    def then_«attr.name»(self, result=None, expected=None, **kwargs):
        """'Then' statement for «attr.name»"""
        self.assertEqual(result, expected)
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,"then_" + attr.name)»«ENDIF»

    def test_«attr.name»(self):
        """Test for «attr.name»"""
        for given, when, then in self.«attr.name»_scenari:
            self.given_«attr.name»(**given)
            try:
                result = self.when_«attr.name»(**when)
            except Exception as exc:
                result = exc
            self.then_«attr.name»(result=result, **then)

    «ENDFOR»
    «FOR command: cls.commands»
    «IF isTrue(command.status.concreteHere)»
    def given_«command.name»(self, state=DevState.STANDBY, **kwargs):
        """'Given' statement for «command.name»"""
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,"given_" + command.name)»«ENDIF»
        self.assertEqual(self.device.State(), state)

    def when_«command.name»(self, value=None, **kwargs):
        """'When' statement for «command.name»"""
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,"when_" + command.name)»«ENDIF»
«IF !command.argin.type.voidType»
«IF !command.argout.type.voidType»        return self.device.«command.name»(value)
«ELSE»        self.device.«command.name»(value)«ENDIF»
«ELSE»«IF !command.argout.type.voidType»        self.device.«command.name»()«ELSE»        return self.device.«command.name»()«ENDIF»
        «ENDIF»

    def then_«command.name»(self, result=None, expected=None, **kwargs):
        """'Then' statement for «command.name»"""
        self.assertEqual(result, expected)
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»«protectedAreaHL(cls,"then_" + command.name)»«ENDIF»

    def test_«command.name»(self):
        """Test for «command.name»"""
        for given, when, then in self.«command.name»_scenari:
            self.given_«command.name»(**given)
            try:
                result = self.when_«command.name»(**when)
            except Exception as exc:
                result = exc
            self.then_«command.name»(result=result, **then)

    «ENDIF»
    «ENDFOR»

# Main execution
if __name__ == "__main__":
    main()
'''	

	//======================================================
	// Define PythonHl pyunit init test script code 
	//======================================================
	def generatePythonHlTestInit(PogoDeviceClass cls) '''
	'''
	//======================================================
	// Define PythonHl __main__.py file 
	//======================================================
	def generatePythonHlProjectMain(PogoDeviceClass cls) '''
# -*- coding: utf-8 -*-
#
# This file is part of the «cls.name» project
#
#«IF cls.description.copyright.isSet»«cls.description.copyright.commentMultiLinesPythonStr»«ENDIF»
#
# Distributed under the terms of the «cls.description.license» license.
# See LICENSE.txt for more info.

from «cls.name» import main
main()
	'''
	//======================================================
	// Define PythonHl pyunit test script code to be generated
	//======================================================
	def generatePythonHlTest(PogoDeviceClass cls) '''
#########################################################################################
# -*- coding: utf-8 -*-
#
# This file is part of the «cls.name» project
#
#«IF cls.description.copyright.isSet»«cls.description.copyright.commentMultiLinesPythonStr»«ENDIF»
#
# Distributed under the terms of the «cls.description.license» license.
# See LICENSE.txt for more info.
#########################################################################################
"""Contain the tests for the «cls.description.title»."""

# Path
import sys
import os
path = os.path.join(os.path.dirname(__file__), os.pardir)
sys.path.insert(0, os.path.abspath(path))

# Imports
import pytest
from mock import MagicMock

from PyTango import DevState

«IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
        «protectedAreaHL(cls, "test_additional_imports")»
«ENDIF»


# Device test case
@pytest.mark.usefixtures("tango_context", "initialize_device")
«IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
        «protectedAreaHL(cls, "test_" + cls.name + "_decorators")»
«ENDIF»
class Test«cls.name»(object):
    """Test case for packet generation."""

    properties = {
        «IF !cls.deviceProperties.empty»
            «FOR property : cls.deviceProperties»
                '«property.name»': '«IF !property.defaultPropValue.empty»«property.defaultPropValue.get(0)»«ENDIF»',
            «ENDFOR»
        «ENDIF»
        «IF !cls.classProperties.empty»
            «FOR property : cls.classProperties»
                '«property.name»': '«IF !property.defaultPropValue.empty»«property.defaultPropValue.get(0)»«ENDIF»',
            «ENDFOR»
        «ENDIF»
        }

    @classmethod
    def mocking(cls):
        """Mock external libraries."""
        # Example : Mock numpy
        # cls.numpy = «cls.name».numpy = MagicMock()
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
            «protectedAreaHL(cls,"test_mocking")»
        «ENDIF»

    def test_properties(self, tango_context):
        # Test the properties
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
            «protectedAreaHL(cls,"test_properties")»
        «ENDIF»
        pass

    «FOR command: cls.commands»
    «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
        «protectedAreaHL(cls, "test_" + command.name + "_decorators")»
    «ENDIF»
    def test_«command.name»(self, tango_context):
        """Test for «command.name»"""
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
            «IF !command.argout.type.voidType»
                «IF command.name=="Status"»
                    «protectedAreaHL(cls, "test_" + command.name, "assert " + command.methodTest(command.argin.type.defaultValueTestHL) + " == \"The device is in UNKNOWN state.\"", false)»
                «ELSE»
                    «protectedAreaHL(cls, "test_" + command.name, "assert " + command.methodTest(command.argin.type.defaultValueTestHL) + " == " + command.argout.type.defaultValueTestHL, false)»
                «ENDIF»
            «ELSE»
                «protectedAreaHL(cls, "test_" + command.name, "assert " + command.methodTest(command.argin.type.defaultValueTestHL) + " == None", false)»
            «ENDIF»
        «ELSE»
            «IF !command.argout.type.voidType»
                «IF command.name=="Status"»
                    assert «command.methodTest(command.argin.type.defaultValueTestHL)» == "The device is in UNKNOWN state."
                «ELSE»
                    assert «command.methodTest(command.argin.type.defaultValueTestHL)» == «command.argout.type.defaultValueTestHL»
                «ENDIF»
            «ELSE»
                assert «command.methodTest(command.argin.type.defaultValueTestHL)» == None
            «ENDIF»
        «ENDIF»

    «ENDFOR»

    «FOR attr : cls.attributes»
    «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
        «protectedAreaHL(cls, "test_" + attr.name + "_decorators")»
    «ENDIF»
    def test_«attr.name»(self, tango_context):
        """Test for «attr.name»"""
        «IF cls.description.filestogenerate.toLowerCase.contains("protected regions")»
            «protectedAreaHL(cls, "test_" + attr.name, "assert tango_context.device." + attr.name + " == " + attr.defaultValueHL, false)»
        «ELSE»
            assert tango_context.device.«attr.name» == «attr.defaultValueHL»
        «ENDIF»

    «ENDFOR»

'''
}
