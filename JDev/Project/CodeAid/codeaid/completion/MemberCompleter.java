/*
 * MemberCompleter.java
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

import org.gjt.sp.jedit.*;
import codeaid.popup.ExpressionFinder;
import codeaid.tools.*;
import org.gjt.sp.util.Log;

import jane.*;
import jane.lang.*;
import jane.parser.ccparser.*;




public class MemberCompleter implements Completer
{
    private int line;
    private int col;
    private SourceTree sourceTree;
    private String wholeBuffer;
    private String textTillCurrPos;
    private int offset;
    private String methodPart;
    private int i;
    private ClassInfoFinder classInfoFinder;


    public MemberCompleter(
            int line,
            int col,
            SourceTree sourceTree,
            String wholeBuffer,
            String methodPart,
            String textTillCurrPos,
            int offset,
            int i,
            ClassInfoFinder classInfoFinder
    ) {
        this.line = line;
        this.col = col;
        this.sourceTree = sourceTree;
        this.wholeBuffer = wholeBuffer;
        this.methodPart = methodPart;
        this.textTillCurrPos = textTillCurrPos;
        this.offset = offset;
        this.i = i;
        this.classInfoFinder = classInfoFinder;
    }


    public Collection complete() {
        JavaParser expressionParser = new JavaParser();
        String[] allImports = sourceTree.getImports();
        StringBuffer sbVariable = new StringBuffer();
        char c;
        i--;
        c = textTillCurrPos.charAt(i--);
        while (Character.isJavaIdentifierPart(c)) {
            sbVariable.insert(0, c);
            c = textTillCurrPos.charAt(i--);
        }
        // now we have the variable
        String var = sbVariable.toString();
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "var::: " + var);

        // the remaining part should be complete->try it to parse
        String type = Jane.getResultTypeOfExpression(var, line + 1, col-methodPart.length() , sourceTree, classInfoFinder);
        
        if (type == null || type.trim() == "") {
            while (Character.isJavaIdentifierPart(c) || 
                c =='(' || c ==')'||
                c =='[' || c ==']'||
                c =='.'||c ==',' ||
                c =='\'' || c =='\"' ) {
                    sbVariable.insert(0, c);
                    c = textTillCurrPos.charAt(i--);
            }
            // now we have the variable
            var = sbVariable.toString();
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "var::: " + var);
    
            // the remaining part should be complete->try it to parse
            type = Jane.getResultTypeOfExpression(var, line + 1, col-methodPart.length() , sourceTree, classInfoFinder);
        }
        
        
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "type: " + type);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "methodPart: " + methodPart);
        
        boolean isThis;
        if (var.equals("this")) {
            isThis = true;
        } else {
            isThis = false;
        }
        Collection methodList;
        if (type != null && type.trim().length()!=0) {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,offset - methodPart.length() -1 +"," +
            line+"," +col+",");
            methodList = /* PopupKeyHandler.popupKey. */collectMembers(
                offset - methodPart.length() -1, line, col-methodPart.length(), sourceTree, wholeBuffer, classInfoFinder
            );
        } else {
            methodList = new LinkedList();
        }
        if(methodPart==null || methodPart.length()==0) {
            return methodList;
        }
        Iterator iter = methodList.iterator();
        LinkedList returnList = new LinkedList();
        MemberInfo current = null;
        
        while (iter.hasNext()) {
            current = (MemberInfo) iter.next();
            if (current.getName().startsWith(methodPart)) {
                returnList.add(current);
            }
        }
        return returnList;
        
        // Not needed I think
        //return filterWithMethodPart(methodList, methodPart);
    }


    private Collection filterWithMethodPart(Collection methodList, String methodPart) {
        Collection newList = new LinkedList();
        for (Iterator it = methodList.iterator(); it.hasNext(); ) {
            MemberInfo info = (MemberInfo) it.next();
            if (info.getName().startsWith(methodPart)) {
                newList.add(info);
            }
        }
        
        return newList;
    }
    
    public List collectMembers(int offset, int line, int col,
        SourceTree sourceTree, String doc,
        ClassInfoFinder classInfoFinder) {
        String expr = ExpressionFinder.getExpression(doc, offset).trim();
        if (expr == null) {
            return Collections.EMPTY_LIST;
        }
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "expr1:'" + expr + "'");
        expr = expr.substring(0, expr.length() - 1);// remove the '.'
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "Finding type of variable '" + expr + "' @ " + (line + 1) + "," + col);
        String type = Jane.getVariableType(expr, line + 1, col, sourceTree);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "Variable type: '" + type);
        if (type.trim().equals("")) {
            type = Jane.getResultTypeOfExpression(expr, line + 1, col, sourceTree, classInfoFinder);
        }
        
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "type:" + type);
        ClassInfo enclosingClass = sourceTree.getClass(line + 1, col);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "enclosing class:" + enclosingClass);
        return collectMembers(type, enclosingClass, expr);
    }

    private List collectMembers(String type, ClassInfo enclosingClass, String expr) {
        boolean staticMembers = false;
        if (type.startsWith("*")) {
            staticMembers = true;
            type = type.substring(1);
        }

        List memberList = null;

        ClassInfo exprClass = (ClassInfo) Jane.findClass(type);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "class info:" + exprClass);
        if (exprClass != null) {
            memberList = CompletionUtil.getMemberList(exprClass, enclosingClass,
                staticMembers, null);
        } else {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "can not find class for:" + type);
        }
        if (memberList == null) {
            memberList = new LinkedList();
            String packageName = expr;

            // remove any beginning new
            if (packageName.startsWith("new") &&
                Character.isWhitespace(packageName.charAt(3))) {
                packageName = packageName.substring(3).trim();
            }

            // remove all spaces
            int space;
            while ((space = packageName.indexOf(' ')) >= 0) {
                packageName = packageName.substring(0, space)
                     + packageName.substring(space + 1);
            }

            for (Iterator i = Jane.getContextFinder().findPackages().iterator(); i.hasNext(); ) {
                String p = (String) i.next();
                if (p.startsWith(packageName + '.')) {
                    p = p.substring(packageName.length() + 1);
                    int dot = p.indexOf('.');
                    if (dot >= 0) {
                        p = p.substring(0, dot);
                    }
                    memberList.add(new ImportInfoBase(p, packageName, ImportInfo.SUBPACKAGE));
                }
            }

            Collection classesInPackage = Jane.getContextFinder()
                .findClassesByPackage(packageName);
            List classes = new LinkedList(classesInPackage);
            Collections.sort(classes, Comparators.simple);
            memberList.addAll(classes);

        }

        return memberList;
    }

    
    

    
}

