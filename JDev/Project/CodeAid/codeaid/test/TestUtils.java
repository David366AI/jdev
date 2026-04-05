/*
 * TestUtils.java
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
import java.util.zip.ZipFile;

import org.gjt.sp.util.Log;
import org.gjt.sp.jedit.jEdit;

import jane.*;
import jane.library.*;
import jane.parser.SourceParser;
import jane.parser.ccparser.SourceTree;


public class TestUtils implements JaneConstants
{
    public static DefaultClassInfoFinder bufferFinder;
    static Analyzer analyzer;


    public static void setUpParser() throws Exception {

        Log.init(false, 0);
        String rtName = System.getProperty("java.rt");

        Library lib = new Library("jdk");
        lib.setClassPath(rtName);
        lib.setParseType(CLASS_PARSE_TYPE);
        JanePlugin.getPlugin().getLibraryManager().addLibrary(lib);

        analyzer = new Analyzer();
        JavaArtifactPath artifactPath = JavaArtifactPath.resolvePath(rtName);
        BCELClassInfoFinder parent = new BCELClassInfoFinder(artifactPath);
        bufferFinder = new DefaultClassInfoFinder();
        bufferFinder.setParent(parent);
        JavaArtifact artifact = JavaArtifact.newFileArtifact(
            new File("/tmp"), makeFile()
        );
        analyzer.setFinder(bufferFinder);
        analyzer.analyze(artifact, Analyzer.SOURCE_ARTIFACT_TYPE);
        System.out.println();

        //TODO:
        //ClassTable.getInstance().preLoad(new ZipFile(rtName));

        //docParser=new JavaParser();
        //docParser.init(makeFile());
        //docParser.generateClassInfo=true;
        //TODO:
        //docParser.parse(new FileReader(makeFile()),"");
        //expressionParser = new JavaParser();
    }


    public static SourceTree getTestFileSourceTree() {
        return ((SourceParser) analyzer.getParser(Analyzer.SOURCE_ARTIFACT_TYPE)).getSourceTree();
    }


    static File makeFile() throws IOException {
        File file = new File("/tmp/Test.java");
        file.delete();
        file.createNewFile();
        FileWriter writer = new FileWriter(file);
        writer.write(makeJavaFileText());
        writer.close();
        return file;
    }


    static String makeJavaFileText() {
        StringBuffer sb = new StringBuffer();
        sb.append("package testPackage;\n");
        sb.append("import java.util.*;\n");
        sb.append("public class Test { \n");
        sb.append(" int aField;\n ");
        sb.append("public void aFMethod() {} \n");
        sb.append("public void test() { \n");
        sb.append(" System.out.println(); \n");
        sb.append("Hashtable ht = new Hashtable();\n");
        sb.append(" ht.clone();\n");
        sb.append("Hashtable ht1 = new java.util.Hashtable();\n");
        sb.append(" int aField1=1;\n");
        sb.append(" int aField2=2;\n");
        sb.append(" aField=5;\n");
        sb.append(" test();\n");
        sb.append(" test1();\n");
        sb.append(" this.test();\n");
        sb.append(" aField=7;\n");
        sb.append(" Hallo();\n");
        sb.append(" new InnerClass().test2();\n");
        sb.append(" Test.Inner1 a;\n");
        sb.append(" Test.Inner1.test ;\n");
        sb.append("} \n");
        sb.append("private static void test1() {}\n");
        sb.append("private static void Hallo() {}\n");
        sb.append("public class InnerClass { \n");
        sb.append("public void test2() {}\n");
        sb.append("}\n");
        sb.append("public static class Inner1 { \n");
        sb.append("public static String test;\n");
        sb.append("}\n");
        sb.append("}\n");

        return sb.toString();
    }
}

