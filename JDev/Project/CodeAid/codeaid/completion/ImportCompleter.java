/*
 * ImportCompleter.java
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


package codeaid.completion;

import java.util.*;

import org.gjt.sp.util.Log;

import jane.ClassInfoFinder;
import jane.lang.Comparators;



public class ImportCompleter implements Completer
{
    private String actualLine;
    private ClassInfoFinder classInfoFinder;


    public ImportCompleter(String actualLine, ClassInfoFinder classInfoFinder) {
        this.actualLine = actualLine;
        this.classInfoFinder = classInfoFinder;
    }


    public Collection complete() {
        try {
            actualLine = actualLine.trim();
            // the start is the first character which is no javaPartIdentifier
            int i = actualLine.length() - 1;

            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "actualLine:" + actualLine);
            List memberList = new LinkedList();
            while (i >= 0 && !Character.isWhitespace((actualLine.charAt(i)))) {
                i--;
            }
            
            if (actualLine.lastIndexOf(".") > -1 && actualLine.lastIndexOf(".") > i+1 ) {
                // a dot in the expression
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "last index of non whitespace: " + i);
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "lastIndeofDot: " + actualLine.lastIndexOf("."));
                String packageExpr = actualLine.substring(i + 1,
                    actualLine.lastIndexOf("."));
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "packageExpression: '" + packageExpr + "'");
                String subPackagePart;
                if (actualLine.endsWith(".")) {
                    subPackagePart = null;
                } else {
                    subPackagePart = actualLine.substring(actualLine.lastIndexOf(".") + 1);
                }
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "subPackagePart: " + subPackagePart);
                ClassesInPackageCompleter classCompleter =
                    new ClassesInPackageCompleter(
                        packageExpr, subPackagePart, true, classInfoFinder
                    );
                memberList = new LinkedList(classCompleter.complete());

            } else {
                // not dot so, we have someting like "import jav"
                String packagePart = actualLine.substring(i + 1);
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "packageExpression: '" + packagePart + "'");
                if (packagePart.equals("import")) {
                    // just "import" was typed
                    ClassesInPackageCompleter classCompleter =
                        new ClassesInPackageCompleter("", "", true, classInfoFinder);
                    memberList = new LinkedList(classCompleter.complete());
                } else {
                    ClassesInPackageCompleter classCompleter =
                        new ClassesInPackageCompleter("", packagePart, true, classInfoFinder);
                    memberList = new LinkedList(classCompleter.complete());
                }
            }

            Set ret = new TreeSet(Comparators.simple);
            ret.addAll(memberList);
            return new ArrayList(ret);
        } catch (Exception e) {
            // ignore
            e.printStackTrace();
            return new TreeSet();
        }
    }
}

