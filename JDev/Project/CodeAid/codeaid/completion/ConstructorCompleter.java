/*
 * ReservedWordCompleter.java
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

import java.util.Collection;
import java.util.List;
import java.util.LinkedList;
import java.util.Collection;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.jedit.*;
import jane.lang.*;
import jane.*;
import jane.parser.ccparser.SourceTree;

import org.gjt.sp.util.Log;
import jane.lang.*;
import codeaid.tools.*;
import codeaid.popup.ExpressionFinder;


public class ConstructorCompleter implements Completer
{
    private ClassInfoFinder classInfoFinder;
    private Buffer doc;
    private int currentPos;
    private int line;
    private int col;
    private String wholeBuffer;
    private String s;
    public ConstructorCompleter( ClassInfoFinder _classInfoFinder, Buffer _doc, int _currentPos, int _line, int _col, String _wholeBuffer) {
        this.classInfoFinder = _classInfoFinder;
        this.doc = _doc;
        this.currentPos = _currentPos;
        this.line = _line;
        this.col = _col;
        this.wholeBuffer = _wholeBuffer;
    } 

    
    public Collection complete() {
        
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,new Integer(currentPos));
        List memberList = findMembers(doc, currentPos, classInfoFinder);
        return memberList;
        
    }
    public List findMembers(Buffer doc, int offset, ClassInfoFinder classInfoFinder) {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "offset=" + offset);
        int showOffset = offset;
        String name = null;
        List memberList = null;
        int start = Math.max(0, offset - 100);
        name = doc.getText(start, offset - start );
        name = name.substring(name.lastIndexOf(";"));
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "+name=[" + name + "]");
        if (name != null && name.endsWith("(")) {
            name = name.substring(0, name.length() - 1);
            int newIndex = ExpressionFinder.findConstructorNew(name);
            if (newIndex >= 0) {
                name = name.substring(newIndex + 3).trim();
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,name);
                String newExpr = "new " + name + "()";
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,newExpr);
                String type = Jane.getResultTypeOfExpression(
                    newExpr, line + 1, col, Jane.getSourceTree(doc), classInfoFinder
                );
                ClassInfo ci = Jane.getContextFinder().findClass(type);
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"ci= "+ci);

                if (ci == null) {
                    return null;
                }

                memberList = new LinkedList(ci.getConstructors());
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"member list= " + memberList);
                
            }
        }
        return memberList;
    }
    
    
}
