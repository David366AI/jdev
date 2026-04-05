/*
 * GotoDefinitionAction.java
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


package codeaid.expression;

import java.io.*;
import java.util.zip.*;
import java.util.*;

import org.gjt.sp.jedit.View;
import org.gjt.sp.util.Log;

import jane.ClassInfoFinder;
import jane.Jane;
import jane.lang.*;

import codeaid.popup.*;
import codeaid.tools.CodeAidUtilities;
import codeaid.tools.JavaSourceFile;
import codeaid.tools.NoSourceFileFoundException;


public class GotoDefinitionAction implements ExpressionAction
{
    private View view;
    private String fullQualifiedName;
    private MemberInfo mInfo;
    private ClassInfoFinder classInfoFinder;


    public GotoDefinitionAction(
            String fullQualifiedName,
            MemberInfo mInfo,
            View view,
            ClassInfoFinder classInfoFinder
    ) {
        this.view = view;
        this.fullQualifiedName = fullQualifiedName;
        this.mInfo = mInfo;
        this.classInfoFinder = classInfoFinder;
    }


    public void action() {
        MemberInfo foundInfo;
        try {
            if (mInfo.getSourceLocation() != null) {
                foundInfo = mInfo;
            } else {
                fullQualifiedName = MemberInfoUtils.findDeclaringClass(
                    fullQualifiedName, mInfo, classInfoFinder
                );

                JavaSourceFile javaSource = new JavaSourceFile(
                    fullQualifiedName, Jane.getContextSrcDirs(), classInfoFinder
                );

                foundInfo = javaSource.readMember(mInfo);
            }
            CodeAidUtilities.goToMember(view, foundInfo);
        } catch (NoSourceFileFoundException e) {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.WARNING, this, e);
        }
    }
}

