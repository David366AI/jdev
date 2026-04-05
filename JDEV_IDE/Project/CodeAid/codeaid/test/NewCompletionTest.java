/*
 * NewCompletionTest.java
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

import java.io.*;
import java.util.*;

import junit.framework.TestCase;

import jane.*;
import jane.lang.*;
import jane.parser.*;
import jane.parser.ccparser.*;

import codeaid.completion.*;
import codeaid.expression.*;


public class NewCompletionTest extends TestCase
{
    public NewCompletionTest(String s) {
        super(s);
    }


    public void testSymbolCompletion() throws Exception {
        File file = makeFile();
        DefaultClassInfoFinder finder = new DefaultClassInfoFinder();
        finder.setParent(new ReflectiveClassInfoFinder());
        SourceParser parser = new SourceParser();
        parser.setClassInfoFinder(finder);
        parser.parse(JavaArtifact.newFileArtifact(file.getParentFile(), file));
        List nodes = parser.getSourceTree().getNodePath(9, 1);
        for (int j = 0; j < nodes.size(); j++) {
            SourceNode node = (SourceNode) nodes.get(j);
            for (int i = 0; i < node.getMembers().length; i++) {
                MemberInfo info = node.getMembers()[i];
                System.out.println("member: " + info.getName() + " : " + info.getClass().getName());
                if (info instanceof FieldInfo) {
                    String type = ((FieldInfo) info).getType();
                    ClassInfo cInfo = finder.findClass(type);
                    System.out.print("type: " + type);
                    if (cInfo != null) {
                        System.out.println("  cInfo: " + cInfo.getFullName());
                        System.out.println("methods: " + cInfo.getMethods().toString());
                    }
                }
            }
        }

        System.out.println(parser.getSourceTree().getMemberPath(5, 8).toString());
        DotTypedCollector collector = new DotTypedCollector(makeJavaFileText(), "aString.",
            makeJavaFileText().indexOf("aString.clone()") + 7,
            9, 1,
            parser.getSourceTree(),
            TestUtils.bufferFinder);
        collector.collect();

    }


    private static File makeFile() throws IOException {
        File file = new File("/tmp/Test.java");
        file.delete();
        file.createNewFile();
        FileWriter writer = new FileWriter(file);
        writer.write(makeJavaFileText());
        writer.close();
        return file;
    }


    private static String makeJavaFileText() {
        StringBuffer sb = new StringBuffer();
        sb.append("package testPackage;\n");
        sb.append("import java.util.Hashtable;\n");
        sb.append("public class Test { \n");
        sb.append(" String  s1;\n ");
        sb.append(" Hashtable ht; \n");
        sb.append("public void aFMethod(String aString) { \n");
        sb.append("aString.clone(); \n");
        sb.append(" for (int i=0;i<10;i++) { \n");
        sb.append("int j=0; \n");
        sb.append("} } }\n");
        return sb.toString();
    }
}

