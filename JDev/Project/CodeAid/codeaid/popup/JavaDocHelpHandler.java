/*
 * JavaDocHelpHandler.java
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


package codeaid.popup;

import java.io.*;
import java.lang.reflect.Modifier;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.gjt.sp.jedit.Buffer;
import org.gjt.sp.jedit.View;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.util.Log;

import jane.*;
import jane.lang.*;
import jane.parser.SourceParser;
import jane.parser.ccparser.SourceTree;

import codeaid.expression.*;
import codeaid.tools.CodeAidUtilities;


public class JavaDocHelpHandler
{
    public static final int ACTION_SHOW_POPUP_HELP  = 0;
    public static final int ACTION_GOTO_DEFINITION  = 1;

    public static JavaDocHelpHandler popupKey = new JavaDocHelpHandler();


    private JavaDocHelpHandler() {}



    public void showHelp(JEditTextArea ta, View view, int action) {
        long start = System.currentTimeMillis();
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "show help for member called");

        int offset = ta.getCaretPosition();

        String actualExpression = ExpressionFinder.getExpressionBeforeOffset(ta.getText(), offset);
        doActionOnPosition(
            offset, ta, action, view, actualExpression, Jane.getContextFinder()
        );
        long end = System.currentTimeMillis();
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "duration: " + (end - start) / 1000.0);

    }


    private void doActionOnPosition(int offset,
        JEditTextArea ta,
        int action, View view, String actualExpression,
        ClassInfoFinder classInfoFinder) {
        Buffer doc = ta.getBuffer();
        SourceTree sourceTree = Jane.getSourceTree(doc);

        String wholeBuffer = doc.getText(0, doc.getLength());
        int line = ta.getLineOfOffset(offset);
        int col = offset - ta.getLineStartOffset(line);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "actual Expression: " + actualExpression);

        if (actualExpression == null) {
            return;
        }

        try {
            JavaExpressionParser expParser = new JavaExpressionParser(sourceTree, classInfoFinder);
            Expression exp = expParser.parse(
                actualExpression, offset, line,
                offset - ta.getLineStartOffset(line), ta.getText()
            );

            MemberInfo mInfo = exp.findMatchingMember();
            if (mInfo == null) {
                return;
            }

            // the class of the variable before the member
            String originalType = "";
            if (exp instanceof MemberExpression) {
                originalType = ((MemberExpression) exp).objectReferenzClassname;
            } else if (exp instanceof NewExpression) {
                originalType = ((NewExpression) exp).objectReferenzClassname;
            } else if (exp instanceof ClassExpression) {
                originalType = ((ClassExpression) exp).fullQualifiedName;
            }

            // the class which declares the member (could be the same then originaltype)
            String className;
            if (exp instanceof ClassExpression) {
                className = ((ClassExpression) exp).fullQualifiedName;
            } else {
                className = mInfo.getDeclaringClass();
            }

            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "found member in class: " + className);
            ExpressionAction expAction = null;
            if (action == ACTION_SHOW_POPUP_HELP) {
                // show the docu with the hint-popup
                expAction = new JavaDocPopupAction(ta, mInfo, offset, originalType, classInfoFinder);
            } else if (action == ACTION_GOTO_DEFINITION) {
                expAction = new GotoDefinitionAction(
                    className,
                    mInfo,
                    view, classInfoFinder
                );
            } 

            expAction.action();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

