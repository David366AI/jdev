/*
 * CompletionTest.java
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

import junit.framework.*;
import junit.extensions.TestSetup;

import jane.*;
import jane.lang.*;
import jane.parser.*;

import codeaid.completion.ImportedClassCompleter;
import codeaid.completion.ImportCompleter;
import codeaid.completion.SymbolCompleter;

import java.util.zip.ZipFile;
import java.util.*;


public class CompletionTest extends TestCase
{
    public CompletionTest(String s) {
        super(s);
    }


    public void testClassCompleterWithImportedClasses() {
        ClassInfoFinder finder = TestUtils.bufferFinder;
        ImportedClassCompleter completer = new ImportedClassCompleter(
            ((SourceParser) TestUtils.analyzer.getParser(Analyzer.SOURCE_ARTIFACT_TYPE)).getJavaParser().getSourceTree().getImports(),
            "Ha", finder
        );

        Collection members = completer.complete();
        assertEquals(3, members.size());
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            ClassInfo ii = (ClassInfo) it.next();
            System.out.println(ii.getFullName());
            assertTrue(ii.getName().startsWith("Ha"));

        }
    }


    public void testImportCompleter() {
        ImportCompleter importCompleter = new ImportCompleter("ja",
            TestUtils.bufferFinder);
        Collection members = importCompleter.complete();
        assertEquals(2, members.size());
        assertEquals("java", ((ImportInfo) members.toArray()[0]).getName());
        assertEquals("javax", ((ImportInfo) members.toArray()[1]).getName());

        importCompleter = new ImportCompleter("java.", TestUtils.bufferFinder);
        members = importCompleter.complete();

        for (Iterator it = members.iterator(); it.hasNext(); ) {
            ImportInfo ii = (ImportInfo) it.next();
            System.out.println(ii.getName());
        }
        assertEquals(13, members.size());
        importCompleter = new ImportCompleter("java.lang.", TestUtils.bufferFinder);
        members = importCompleter.complete();

        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo ii = (MemberInfo) it.next();
            System.out.println(ii.getName());
        }
        assertEquals(93, members.size());
        assertEquals("reflect", ((ImportInfo) members.toArray()[92]).getName());

        importCompleter = new ImportCompleter("java.lang.Integ", TestUtils.bufferFinder);
        members = importCompleter.complete();
        assertEquals(1, members.size());
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo ii = (MemberInfo) it.next();
        }
        assertEquals("Integer", ((MemberInfo) members.toArray()[0]).getName());

        importCompleter = new ImportCompleter("testPackage.", TestUtils.bufferFinder);
        members = importCompleter.complete();
        assertEquals(1, members.size());
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo ii = (MemberInfo) it.next();
        }
        assertEquals("Test", ((MemberInfo) members.toArray()[0]).getName());
    }


    public void testSymbolCompletion() {
        SymbolCompleter symbolCompleter = new SymbolCompleter(
            TestUtils.getTestFileSourceTree(), 12, 1, "aF"
        );

        Collection members = symbolCompleter.complete();
        String exspected[] = {"aFMethod", "aField", "aField1", "aField2"};

        Set was = new TreeSet();
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo ii = (MemberInfo) it.next();
            was.add(ii.getName());
            System.out.println(ii.getName());
        }
        assertTrue(Arrays.equals(was.toArray(), exspected));
    }
}

