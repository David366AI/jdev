/*
 * ExpressionTest.java
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
import java.util.Arrays;
import java.util.Map;
import java.util.Iterator;

import junit.framework.TestCase;

import org.gjt.sp.jedit.Buffer;
import org.gjt.sp.jedit.View;
import org.gjt.sp.jedit.jEdit;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.util.Log;

import jane.Jane;
import jane.lang.*;
import jane.parser.ccparser.*;

import codeaid.expression.*;
import codeaid.popup.ExpressionFinder;


public class ExpressionTest extends TestCase
{
    public ExpressionTest(String s) {
        super(s);
    }


    public void setUp() throws Exception {
        TestUtils.setUpParser();
    }


    public void testOnFullClassname() throws Exception {
        int offset = TestUtils.makeJavaFileText().indexOf("java.util.Hashtable") + 12;
        System.out.println("offset: " + TestUtils.makeJavaFileText().substring(offset, offset + 5));
        JavaExpressionParser exParser = new JavaExpressionParser(TestUtils.getTestFileSourceTree(),
            TestUtils.bufferFinder);
        Expression exp = exParser.parse("java.util.Hashtable", offset, 4, 1, TestUtils.makeJavaFileText());
        if (!(exp instanceof ClassExpression)) {
            fail("wrong expression class");
        }
        ClassExpression classEXp = (ClassExpression) exp;
        assertEquals("java.util.Hashtable", classEXp.fullQualifiedName);
        MemberInfo mi = classEXp.findMatchingMember();
        if (!(mi instanceof ClassInfo)) {
            fail("wrong info class");
        }
        ClassInfo ci = (ClassInfo) mi;
        assertEquals("Hashtable", ci.getName());
    }


    public void testOnClassname() throws Exception {
        int offset = TestUtils.makeJavaFileText().indexOf("Hashtable") + 2;
        System.out.println("offset: " + TestUtils.makeJavaFileText().substring(offset, offset + 2));
        JavaExpressionParser exParser = new JavaExpressionParser(TestUtils.getTestFileSourceTree(),
            TestUtils.bufferFinder);
        Expression exp = exParser.parse("Hashtable", offset, 4, 1, TestUtils.makeJavaFileText());
        if (!(exp instanceof ClassExpression)) {
            fail("wrong expression class");
        }
        ClassExpression classEXp = (ClassExpression) exp;
        assertEquals("java.util.Hashtable", classEXp.fullQualifiedName);
        MemberInfo mi = classEXp.findMatchingMember();
        if (!(mi instanceof ClassInfo)) {
            fail("wrong info class");
        }
        ClassInfo ci = (ClassInfo) mi;
        assertEquals("Hashtable", ci.getName());
    }


    public void testOnLocalStaticMethod() throws Exception {
        int offset = TestUtils.makeJavaFileText().indexOf("test1()") + 2;
        System.out.println("offset: " + TestUtils.makeJavaFileText().substring(offset, offset + 2));
        JavaExpressionParser exParser = new JavaExpressionParser(TestUtils.getTestFileSourceTree(),
            TestUtils.bufferFinder);
        Expression exp = exParser.parse("test1()", offset, 4, 1, TestUtils.makeJavaFileText());
        if (!(exp instanceof MethodExpression)) {
            fail("wrong expression type");
        }
        MethodExpression mExp = (MethodExpression) exp;
        assertEquals("testPackage.Test", mExp.objectReferenzClassname);
        MethodDescriptor descriptor = (MethodDescriptor) mExp.memberDescriptor;
        assertEquals("test1", descriptor.name);
        String expParams[] = new String[0];
        //assertEquals(expParams,descriptor.parameter);
        assertTrue(Arrays.equals(expParams, descriptor.parameter));
    }


    public void testOnInnerClassMethod() throws Exception {
        int offset = TestUtils.makeJavaFileText().indexOf("test2()") + 2;
        System.out.println("offset: " + TestUtils.makeJavaFileText().substring(offset, offset + 2));
        JavaExpressionParser exParser = new JavaExpressionParser(TestUtils.getTestFileSourceTree(),
            TestUtils.bufferFinder);
        Expression exp = exParser.parse("new InnerClass().test2()", offset, 4, 1, TestUtils.makeJavaFileText());
        if (!(exp instanceof MethodExpression)) {
            fail("wrong expression type");
        }
        MethodExpression mExp = (MethodExpression) exp;
        assertEquals("testPackage.Test$InnerClass", mExp.objectReferenzClassname);
        MethodDescriptor descriptor = (MethodDescriptor) mExp.memberDescriptor;
        assertEquals("test2", descriptor.name);
        String expParams[] = new String[0];
        //assertEquals(expParams,descriptor.parameter);
        assertTrue(Arrays.equals(expParams, descriptor.parameter));
        ClassInfo ci = TestUtils.bufferFinder.findClass(mExp.objectReferenzClassname);
        assertNotNull(ci);
        Classes classes = Jane.getClassesInContext();
    }


    public void testOnLocalMethod() throws Exception {
        int offset = TestUtils.makeJavaFileText().indexOf("test()") + 2;
        System.out.println("offset: " + TestUtils.makeJavaFileText().substring(offset, offset + 2));
        JavaExpressionParser exParser = new JavaExpressionParser(TestUtils.getTestFileSourceTree(),
            TestUtils.bufferFinder);
        Expression exp = exParser.parse("test()", offset, 4, 1, TestUtils.makeJavaFileText());
        if (!(exp instanceof MethodExpression)) {
            fail("wrong expression type");
        }
        MethodExpression mExp = (MethodExpression) exp;
        assertEquals("testPackage.Test", mExp.objectReferenzClassname);
        MethodDescriptor descriptor = (MethodDescriptor) mExp.memberDescriptor;
        assertEquals("test", descriptor.name);
        String expParams[] = new String[0];
        assertTrue(Arrays.equals(expParams, descriptor.parameter));
    }


    public void testOnStaticMethodOfObject() throws Exception {
        int offset = TestUtils.makeJavaFileText().indexOf("System.out.println()") + 13;
        System.out.println("offset: " + TestUtils.makeJavaFileText().substring(offset, offset + 2));
        JavaExpressionParser exParser = new JavaExpressionParser(TestUtils.getTestFileSourceTree(),
            TestUtils.bufferFinder);
        Expression exp = exParser.parse("System.out.println()", offset, 7, 1, TestUtils.makeJavaFileText());
        if (!(exp instanceof MethodExpression)) {
            fail("wrong expression type");
        }
        MethodExpression mExp = (MethodExpression) exp;
        assertEquals("java.io.PrintStream", mExp.objectReferenzClassname);
        MethodDescriptor descriptor = (MethodDescriptor) mExp.memberDescriptor;
        assertEquals("println", descriptor.name);
        String expParams[] = new String[0];
        assertTrue(Arrays.equals(expParams, descriptor.parameter));
        MemberInfo mi = exp.findMatchingMember();
        if (!(mi instanceof MethodInfo)) {
            fail("wrong info class");
        }
        MethodInfo methodInfo = (MethodInfo) mi;
        assertEquals("println", methodInfo.getName());
        assertEquals("java.io.PrintStream", methodInfo.getDeclaringClass());
    }


    public void testOnMethodOfObject() throws Exception {
        int offset = TestUtils.makeJavaFileText().indexOf("ht.clone()") + 4;
        System.out.println("offset: " + TestUtils.makeJavaFileText().substring(offset, offset + 2));
        JavaExpressionParser exParser = new JavaExpressionParser(TestUtils.getTestFileSourceTree(),
            TestUtils.bufferFinder);
        Expression exp = exParser.parse("ht.clone()", offset, 7, 1, TestUtils.makeJavaFileText());
        if (!(exp instanceof MethodExpression)) {
            fail("wrong expression type");
        }
        MethodExpression mExp = (MethodExpression) exp;
        assertEquals("java.util.Hashtable", mExp.objectReferenzClassname);
        MethodDescriptor descriptor = (MethodDescriptor) mExp.memberDescriptor;
        assertEquals("clone", descriptor.name);
        String expParams[] = new String[0];
        assertTrue(Arrays.equals(expParams, descriptor.parameter));
        MemberInfo mi = exp.findMatchingMember();
        if (!(mi instanceof MethodInfo)) {
            fail("wrong info class");
        }
        MethodInfo methodInfo = (MethodInfo) mi;
        assertEquals("clone", methodInfo.getName());
        assertEquals("java.util.Hashtable", methodInfo.getDeclaringClass());
    }
}

