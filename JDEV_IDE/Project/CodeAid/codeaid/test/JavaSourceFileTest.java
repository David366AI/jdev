/*
 * JavaSourceFileTest.java
 * Copyright (c) 2001, 2002 CodeAid team
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */


package codeaid.test;

import java.util.*;
import java.io.*;

//import junit.framework.TestCase;

import org.gjt.sp.util.Log;
import jane.*;
import jane.lang.*;
import jane.library.*;
import java.lang.reflect.*;
import codeaid.tools.JavaSourceFile;

public class JavaSourceFileTest  implements JaneConstants//extends TestCase
{
    /*
    public JavaSourceFileTest(String s) {
        super(s);
    }
      */
    /*
    public void test() throws Exception {
        Log.init(false, 0);
        List srcDirs = new LinkedList();
        srcDirs.add("/home/carsten/work/jedit/plugins/CodeAid/");
        String declaringClass = "codeaid.info.ClassTable";
        int mod = Modifier.PUBLIC + Modifier.STATIC;
        String ret = "codeaid.info.ClassTable";
        String name = "getInstance";
        String[] params = {};
        String[] paramNames = {};
        String[] exexpstions = {};
        String comment = "";

        MethodInfo mInfo = new MethodInfoBase(
            declaringClass, mod, ret, name,
            params, paramNames, exexpstions,
            comment
        );

        JavaSourceFile javaFile =
            new JavaSourceFile("codeaid.info.ClassTable", srcDirs, TestUtils.bufferFinder);
        MemberInfo newMInfo = javaFile.readMember(mInfo);
        assertNotNull(newMInfo);
        if (!(newMInfo instanceof MethodInfo)) {
            fail("wrong class");
        }

        MethodInfo method = (MethodInfo) newMInfo;
        assertEquals("/home/carsten/work/jedit/plugins/CodeAid/",
            javaFile.getPath()
        );

        assertTrue(method.getComment().startsWith("Gets a static instance"));
    }

    */
    public static void main(String[] argv) throws Exception {
        //Log.init(false, 0);
        List srcDirs = new LinkedList();

        srcDirs.add("d:\\jdk142\\src.zip");
        String declaringClass = "java.lang.String";
        int mod = Modifier.PUBLIC + Modifier.STATIC;
        String ret = "String";
        String name = "toString";
        String[] params = {};
        String[] paramNames = {};
        String[] exexpstions = {};
        String comment = "";

        MethodInfo mInfo = new MethodInfoBase(declaringClass, mod, ret, name,
            params, paramNames, exexpstions,
            comment);
            
        Library jdk = new Library("jane");
        jdk.setSourcePath("D:\\JDK142\\src.ZIP");
        jdk.setParseType(SOURCE_PARSE_TYPE);
        LibraryManager libManager = new LibraryManager();
        libManager.addLibrary(jdk);
        LibraryCodeHandler handler = new LibraryCodeHandler(libManager);
        jane.ClassInfoFinder finder = handler.getFinders(libManager.libraries());

        JavaSourceFile javaFile =
            new JavaSourceFile("java.lang.String", srcDirs, finder);
        MemberInfo newMInfo = javaFile.readMember(mInfo,finder);
        //assertNotNull(newMInfo);
        if (!(newMInfo instanceof MethodInfo)) {
        //    fail("wrong class");
        }
        MethodInfo method = (MethodInfo) newMInfo;
        //assertEquals("/usr/local/j2sdk1.4.0/src.zip!/java/lang/Integer.java",
        //    javaFile.getPath());
        //assertTrue(method.getComment().indexOf("Returns the value of this <code>Integer</code> as a") > -1);
    }
}

