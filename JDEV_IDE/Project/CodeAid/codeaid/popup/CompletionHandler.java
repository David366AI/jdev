/*
 * CompletionHandler.java
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

import java.awt.*;
import java.util.*;

import org.gjt.sp.jedit.*;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.util.Log;

import jane.parser.ccparser.JavaParser;
import jane.*;
import jane.parser.SourceParser;

import codeaid.completion.*;
import codeaid.tools.CodeAidUtilities;


/**
 * collects static functions related to "completion" 
 */
public final class CompletionHandler
{
    JavaParser expressionParser;
    public static CompletionHandler popupKey = new CompletionHandler();


    private CompletionHandler() {
        expressionParser = new JavaParser();
    }



    public void complete(JEditTextArea ta) { }
        /* if (CodeAidPopup.isPopupVisible()) {
            System.out.println("already showing popup");
            return;
        }
        
        // for measuring performance
        long start = System.currentTimeMillis();
        CompletionContext context= this.makeContext(ta);
        
    
        if ( context.isMethodContext() ) {
              PopupHelper.showMethodHelp(
                (java.util.List) context.getMemberList(), offset,ta, context.getPlusText(), null
                );
        } else {// show the list with all members
          PopupHelper.showMemberList(
            context.getMemberList(), ta, offset, context.getPlusText(), Jane.getContextFinder(), null, null
            );
        }
        
        long end = System.currentTimeMillis();
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "duration: " + (end - start) / 1000.0);
    }

    private CompletionContext makeContext(JEditTextArea ta) {
        
        String s = null;
        Buffer doc = ta.getBuffer();
        Collection memberList = new LinkedList();
        int offset = ta.getCaretPosition();
        s = doc.getText(offset - 2, 2);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "showhelp1: " + s);
        String plusText = "";
        int line = ta.getLineOfOffset(offset);
        int col = offset - ta.getLineStartOffset(line);
        String actualLine = ta.getLineText(line).trim();
        String wholeBuffer = ta.getText();
        
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"Starting a CompletionContext");
        return new CompletionContext(s.charAt(1),doc,wholeBuffer,actualLine,line,offset,col,ta);
    
    }
 */
public static FindResult findJavaIdentifierBackwards(String textTillCurrPos) {
        StringBuffer partIndentifier = new StringBuffer();
        char ch = ' ';
        int i = 0;
        for (i = textTillCurrPos.length() - 1; i > 0; i--) {
            ch = textTillCurrPos.charAt(i);
            if (Character.isJavaIdentifierPart(ch) || ch == '@') {
                partIndentifier.insert(0, ch);
                // maybe new was typed
            } else {
                break;
            }

        }
        FindResult result = new FindResult();
        result.expression = partIndentifier.toString();
        result.lastNonJavaCharacter = ch;
        result.offset = i;
        return result;
    }


    public static class FindResult
    {
        public String expression;
        public char lastNonJavaCharacter;
        public int offset;
    }
}

