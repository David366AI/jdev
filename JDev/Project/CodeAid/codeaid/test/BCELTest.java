/*
 * BCELTest.java
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

import org.apache.commons.logging.impl.SimpleLog;

import jane.*;
import jane.lang.*;
import jane.parser.BCELClassParser;

import logging.jEditLog;

import org.gjt.sp.util.Log;

import org.gjt.sp.util.Log;


public class BCELTest extends TestCase
{
    public BCELTest(String s) {
        super(s);
    }


    public void test() throws Exception {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"test", this);

        BCELClassInfoFinder finder1 = new BCELClassInfoFinder(
            JavaArtifactPath.resolvePath("/home/carsten/work/java/jars/jedit.jar")
        );

        long start = System.currentTimeMillis();

        ClassInfo info1 = finder1.findClass("org.gjt.sp.jedit.jEdit");

        Map classes = finder1.findClasses();

        for (Iterator it = classes.keySet().iterator(); it.hasNext(); ) {
            String className = (String) it.next();
            ClassInfo ci = (ClassInfo) classes.get(className);
            System.out.println("class: " + className);
            ci.getMethods();
            System.out.println(ci.getMethods());
        }

        long end = System.currentTimeMillis();
        System.out.println(end - start / 1000.0);
    }
}

