/*
 * CollectorTest.java
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

import junit.framework.TestCase;

import jane.lang.*;

import codeaid.completion.*;


public class CollectorTest extends TestCase
{
    public CollectorTest(String s) {
        super(s);
    }


    public void setUp() throws Exception {
        TestUtils.setUpParser();
    }


    public void testWithThis() {
        String buffer = TestUtils.makeJavaFileText();
        DotTypedCollector collector = new DotTypedCollector(
            buffer,
            " this.",
            buffer.indexOf("this.") + 4,
            17, 1,
            TestUtils.getTestFileSourceTree(),
            TestUtils.bufferFinder
        );
        Collection members = collector.collect();
        String[] exspected = {
            "Inner1",
            "InnerClass",
            "Hallo",
            "aFMethod",
            "aField",
            "clone",
            "equals",
            "finalize",
            "getClass",
            "hashCode",
            "notify",
            "notifyAll",
            "test",
            "test1",
            "toString",
            "wait",
            "wait",
            "wait"
        };

        List was = new LinkedList();
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo ii = (MemberInfo) it.next();
            was.add(ii.getName());
            System.out.println(ii.getName());
        }
        assertTrue(Arrays.equals(was.toArray(), exspected));
    }


    public void testLocalSymbols() {
        String buffer = TestUtils.makeJavaFileText();
        Collector collector = new SomethingTypedCollector(
            buffer,
            "a",
            buffer.indexOf("aField=7") + 1,
            17, 1,
            TestUtils.getTestFileSourceTree(),
            false, TestUtils.bufferFinder
        );

        Collection members = collector.collect();
        String[] exspected = {
            "aFMethod", "aField", "aField1", "aField2",
        };

        List was = new LinkedList();
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo ii = (MemberInfo) it.next();
            was.add(ii.getName());
            System.out.println(ii.getName());
        }
        assertTrue(Arrays.equals(was.toArray(), exspected));
    }


    public void testImportedPlusLocal() {
        String buffer = TestUtils.makeJavaFileText();
        Collector collector = new SomethingTypedCollector(
            buffer,
            "Ha",
            buffer.indexOf("Hallo()") + 1,
            17, 1,
            TestUtils.getTestFileSourceTree(),
            false, TestUtils.bufferFinder
        );

        Collection members = collector.collect();
        String[] exspected = {
            "HashMap", "HashSet", "Hashtable", "Hallo",
        };

        List was = new LinkedList();
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo ii = (MemberInfo) it.next();
            was.add(ii.getName());
            System.out.println(ii.getName());
        }
        assertTrue(Arrays.equals(was.toArray(), exspected));
    }


    public void testInnerClass() {
        String buffer = TestUtils.makeJavaFileText();
        Collector collector = new SomethingTypedCollector(
            buffer,
            "Test.In",
            buffer.indexOf("Test.In") + 7,
            17, 1,
            TestUtils.getTestFileSourceTree(),
            false, TestUtils.bufferFinder
        );

        Collection members = collector.collect();
        String[] exspected = {"Inner1", };

        List was = new LinkedList();
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo ii = (MemberInfo) it.next();
            was.add(ii.getName());
            System.out.println(ii.getName());
        }
        assertTrue(Arrays.equals(was.toArray(), exspected));

        collector = new SomethingTypedCollector(
            buffer,
            "Test.Inner1.",
            buffer.indexOf("Test.Inner1.test") + 12,
            17, 1,
            TestUtils.getTestFileSourceTree(),
            false, TestUtils.bufferFinder
        );

        members = collector.collect();
        String[] exspected1 = {"test", };

        was = new LinkedList();
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo ii = (MemberInfo) it.next();
            was.add(ii.getName());
            System.out.println(ii.getName());
        }
        assertTrue(Arrays.equals(was.toArray(), exspected1));
    }
}

