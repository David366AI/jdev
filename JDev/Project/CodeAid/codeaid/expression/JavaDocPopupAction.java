/*
 * JavaDocPopupAction.java
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

import java.util.LinkedList;

import org.gjt.sp.jedit.textarea.JEditTextArea;

import jane.ClassInfoFinder;
import jane.lang.MemberInfo;

import codeaid.popup.*;


public class JavaDocPopupAction implements ExpressionAction
{
    private JEditTextArea ta;
    private MemberInfo mInfo;
    private int showOffset;
    private String originalObjectType;
    private ClassInfoFinder classInfoFinder;


    public JavaDocPopupAction(
            JEditTextArea ta,
            MemberInfo mInfo,
            int showOffset,
            String originalObjectType,
            ClassInfoFinder classInfoFinder
    ) {
        this.ta = ta;
        this.mInfo = mInfo;
        this.showOffset = showOffset;
        this.originalObjectType = originalObjectType;
        this.classInfoFinder = classInfoFinder;
    }


    public void action() {
        // opens the help popup alone
        System.out.println("show javadoc help for:" + originalObjectType);
        PopupHelper.showJavaDocPopup(
            ta, mInfo, showOffset, originalObjectType, classInfoFinder
        );
    }
}

