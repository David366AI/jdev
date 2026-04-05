/*
 * JavaExpressionParser.java
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

import java.lang.reflect.Modifier;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import jane.ClassInfoFinder;
import jane.ExpressionParser;
import jane.Jane;
import jane.lang.*;
import jane.parser.ccparser.*;

import org.gjt.sp.util.Log;


public class JavaExpressionParser
{
    private SourceTree sourceTree;
    private ClassInfoFinder classInfoFinder;


    public JavaExpressionParser(
            SourceTree sourceTree, ClassInfoFinder classInfoFinder
    ) {
        this.sourceTree = sourceTree;
        this.classInfoFinder = classInfoFinder;
    }


    /**
     *  Does the parsing of the buffer at the given position
     *
     * @param actualExpression                The expression we are on. Its the String from the
     *                                        cursor position back to the start of the expression.
     * @param offset                          The position of the cursor.
     * @return                                Returns a subclass of Expression , which contains the information
     *                                        of the expression "actual expression".
     * @exception NotOnAnIdentifierException  If "offset" is not part of an identifier.
     */
    public Expression parse(
            String actualExpression, int offset, int line, int col, String wholeBuffer
    ) throws NotOnAnIdentifierException {
        System.out.println("actualExpression = " + actualExpression);
        if (actualExpression.indexOf(".") != -1) {
            return parseDotExpression(actualExpression, offset, line, col, wholeBuffer);
        } else {
            return parseNonDotExpression(actualExpression, offset, line, col, wholeBuffer);
        }
    }


    /**
     *  Parses a expression without dot.
     *
     * @param actualExpression                The expression to parse
     * @param offset                          cursor position
     * @return                                The expression at "offset"
     * @exception NotOnAnIdentifierException  Description of Exception
     */
    private Expression parseNonDotExpression(
            String actualExpression, int offset, int line, int col, String wholeBuffer
    ) throws NotOnAnIdentifierException {
        String memberName;
        String memberType;
        memberName = memberType = "";
        ExpressionParser expParser = new ExpressionParser(sourceTree, classInfoFinder);

        boolean hasParenthesis;

        String params;
        try {
            params = findParentExpression(wholeBuffer, offset);
            hasParenthesis = true;
        } catch (NoParenthesisException e) {
            params = "";
            hasParenthesis = false;
        }
        Expression exp = null;

        if (actualExpression.startsWith("new")) {

            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"on a constructor",this);
            // on a Constructor
            // find classname
            exp = new NewExpression(classInfoFinder);
            try {
                String className = findActualIdentifier(wholeBuffer, offset);
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"class: " + className,this);
                int posOfOpenParenthesis = wholeBuffer.indexOf("(", offset);

                memberType = expParser.getResultType(className, line + 1, col);
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"fullQuall. class:" + memberType,this);
                memberName = memberType;
                if (memberName.startsWith("*")) {
                    memberName = memberName.substring(1);
                }
            } catch (NotOnAnIdentifierException e) {
                e.printStackTrace();

            }
            ((NewExpression) exp).isStatic = false;
            ((NewExpression) exp).objectReferenzClassname = memberName;
            NewDescriptor memberDescriptor = new NewDescriptor();
            memberDescriptor.parameter = parseParameterList(params, col, line);
            memberDescriptor.name = memberName;
            ((NewExpression) exp).memberDescriptor = memberDescriptor;
        } else {
            // might be a local method, a local field a className
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"on a local expression",this);
            memberName = findActualIdentifier(wholeBuffer, offset);
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"identifier: " + memberName,this);

            System.out.println("sourceTree :" + sourceTree);
            memberType = TypeResolver.resolve(memberName,
                sourceTree.getImports(),
                sourceTree.getClass(line, col),
                classInfoFinder).getType();

            if (memberType.equals(memberName) && memberName.indexOf('.') < 0) {
                // try with this
                memberType = expParser.getResultType("this", line + 1, col);
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"type: " + memberType,this);
                if (!memberType.trim().equals("")) {
                    boolean isStatic = false;
                    if (memberType.startsWith("*")) {
                        isStatic = true;
                        memberType = memberType.substring(1);
                    }
                    if (hasParenthesis) {
                        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"on a local method",this);
                        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"params: " + params,this);
                        exp = new MethodExpression(classInfoFinder);
                        ((MethodExpression) exp).isStatic = isStatic;
                        ((MethodExpression) exp).objectReferenzClassname = memberType;
                        MethodDescriptor memberDescriptor = new MethodDescriptor();
                        memberDescriptor.parameter = parseParameterList(params, col, line);
                        memberDescriptor.name = memberName;
                        ((MethodExpression) exp).memberDescriptor = memberDescriptor;
                    } else {
                        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"on a local variable/field",this);
                        exp = new FieldExpression(classInfoFinder);
                        ((FieldExpression) exp).isStatic = isStatic;

                    }
                }
            } else {
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"on a class name/other ",this);

                exp = new ClassExpression(classInfoFinder);
                ((ClassExpression) exp).fullQualifiedName = memberType;
            }
        }
        if (exp == null) {
            throw new IllegalArgumentException("expression could no get parsed" + actualExpression);
        }
        return exp;
    }



    /**
     *  Parses an expression, which contains a dot.
     */
    private Expression parseDotExpression(String actualExpression, int offset, int line, int col, String wholeBuffer) {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"on a dot expression", this);

        boolean hasParenthesis;

        String params;
        try {
            params = findParentExpression(wholeBuffer, offset);
            hasParenthesis = true;
        } catch (NoParenthesisException e) {
            params = "";
            hasParenthesis = false;
        }

        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"params: " + params, this);
        // member with something before was typed
        int posOfLastDot = actualExpression.lastIndexOf('.');
        String memberPart = actualExpression.substring(posOfLastDot + 1);
        String memberName;
        int expressionType;

        try {
            memberName = findActualIdentifier(wholeBuffer, offset);
        } catch (NotOnAnIdentifierException e) {
            e.printStackTrace();
            memberName = "";
        }
        Expression expression;
        if (hasParenthesis) {
            expression = new MethodExpression(classInfoFinder);
        }
        else {
            expression = new FieldExpression(classInfoFinder);
        }
        String objectExpression = actualExpression.substring(0, posOfLastDot);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"object expression:" + objectExpression, this);

        String memberType = Jane.getResultTypeOfExpression(
            objectExpression, line + 1, col, sourceTree, classInfoFinder
        );
        if (memberType.trim().equals("")) {
            memberType = sourceTree.findVariableType(objectExpression, line + 1, col);
        }
        System.out.println("memberType = " + memberType);
        if (memberType.trim().equals("")) {
            String name = "";
            int posOfNew;
            if ((posOfNew = objectExpression.indexOf("new ")) > -1) {
                name = objectExpression.substring(posOfNew + 4) +
                    "." + memberName;
                System.out.println("fullname  = " + name);

            } else {
                name = objectExpression + "." + memberName;
                System.out.println("fullname  = " + name);
            }
            String fullName = Jane.resolveClassName(name, sourceTree, line, col, classInfoFinder);
            ClassInfo ci = classInfoFinder.findClass(fullName);
            if (ci != null) {
                expression = new ClassExpression(classInfoFinder);
                ((ClassExpression) expression).fullQualifiedName = fullName;
                return expression;
            }
        } else {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"type: " + memberType, this);
            boolean isStatic = false;
            if (memberType.startsWith("*")) {
                isStatic = true;
                memberType = memberType.substring(1);
            }
            MethodDescriptor descriptor = new MethodDescriptor();
            descriptor.name = memberName;
            descriptor.parameter = parseParameterList(params, col, line);

            ((MemberExpression) expression).memberDescriptor = descriptor;
            ((MemberExpression) expression).isStatic = isStatic;
            ((MemberExpression) expression).objectReferenzClassname = memberType;
        }
        return expression;
    }


    /**
     *  Parses a colon separated parameter list of a method or constructor.
     *
     * @param params     The parameter to parse
     * @return           An array of String wich contains the full qualified
     *                   parameter types.
     */
    private String[] parseParameterList(String params, int col, int line) {
        String actParam;
        java.util.List classes = new java.util.LinkedList();
        for (java.util.Iterator it = kommatokenizer(params).iterator(); it.hasNext(); ) {
            actParam = (String) it.next();
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"actParam: " + actParam,this);
            ExpressionParser expParser = new ExpressionParser(sourceTree, classInfoFinder);
            String paramType = expParser.getResultType(actParam, line + 1, col);

            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"paramType: " + paramType, this);
            classes.add(paramType);

        }
        String[] paramTypes = new String[classes.size()];
        for (int j = 0; j < classes.size(); j++) {
            paramTypes[j] = (String) classes.get(j);
        }
        return paramTypes;
    }


    /**
     *  Finds the identifier at give position.
     *
     * @param buffer                          The buffer to use.
     * @param offset                          The position.
     * @return                                Name of the indentifier.
     * @exception NotOnAnIdentifierException  If there is no identifier at the offset.
     */
    private String findActualIdentifier(String buffer, int offset)
         throws NotOnAnIdentifierException {
        int start = 0;
        int end = 0;
        char ch;
        for (int i = offset; i < buffer.length(); i++) {
            ch = buffer.charAt(i);
            if (!Character.isJavaIdentifierPart(ch)) {
                end = i - 1;
                break;
            }
        }
        for (int i = offset; i > 0; i--) {
            ch = buffer.charAt(i);
            if (!Character.isJavaIdentifierPart(ch)) {
                start = i + 1;
                break;
            }
        }
        if ((end + 1) >= start) {
            return buffer.substring(start, end + 1);
        } else {
            throw new NotOnAnIdentifierException("cursor is not an on java identifier");
        }
    }


    /**
     *  Finds the next pairs of open / close bracket. (...)
     *
     * @param wholeBuffer                 The buffer.
     * @param offset                      The position, to start the serach from.
     * @return                            Returns the bracket expression (...)
     * @exception NoParenthesisException  If there is no (..) at the actual position.
     */
    private String findParentExpression(String wholeBuffer, int offset) throws NoParenthesisException {
        int anzOpenParent = 0;
        int i = offset;
        int endOffset = 0;
        int startOffset = -1;
        char ch;
        boolean parenthesisStarted = false;
        while (true) {
            ch = wholeBuffer.charAt(i);
            if (ch == '(') {
                anzOpenParent++;
                parenthesisStarted = true;
                if (startOffset == -1) {
                    startOffset = i;
                }
            } else if (ch == ')') {
                anzOpenParent--;
                if (anzOpenParent == 0) {
                    endOffset = i;
                    break;
                }
            } else if (!Character.isJavaIdentifierPart(ch)) {
                if (Character.isWhitespace(ch) && parenthesisStarted == false) {
                    // if no java part and no space -> break;
                    throw new NoParenthesisException();
                }
            }
            if (i > wholeBuffer.length()) {
                break;
            }

            i++;

        }
        if ((startOffset > -1) || (endOffset > 0)) {
            return wholeBuffer.substring(startOffset + 1, endOffset);
        } else {
            return "";
        }
    }


    /**
     * Checks if the two parameter lists for a method/constructor matches.
     * It checks if the parameterList given by "realParamtypes" could be appllied
     * to params giveb by args.
     *
     * @param args            The parameters of the declaration.
     * @param realParamTypes  The given parameter.
     */
    public static boolean matchMethodParams(
        String[] args, String[] realParamTypes,
        ClassInfoFinder classInfoFinder
        ) {
        logParamTypes(args);
        logParamTypes(realParamTypes);
        if (realParamTypes.length != args.length) {
            return false;
        }
        for (int i = 0; i < args.length; i++) {
            if (!MemberInfoUtils.isAssignableTo(args[i], realParamTypes[i],
                classInfoFinder,
                true)) {
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,args[i] + " not assignable to " + realParamTypes[i],null);
                return false;
            }
        }
        return true;
    }


    /**
     * Parses a given text to its pars seperated by "'".
     * If they are inside of comments, they are ignored.
     *
     * @param text  The text to parse.
     * @return      A list of Strings.
     */
    private static List kommatokenizer(String text) {
        List resultList = new LinkedList();
        if (text.equals("")) {
            return resultList;
        }
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"text to parse:" + text, null);
        int anzOpenParent = 0;
        int i = 0;
        int endOffset = 0;
        int startOffset = 0;
        char ch;
        while (true) {
            ch = text.charAt(i);
            if (ch == '(') {
                anzOpenParent++;
            } else if (ch == ')') {
                anzOpenParent--;
            } else if (ch == ',') {
                if (anzOpenParent == 0) {
                    endOffset = i;
                    resultList.add(text.substring(startOffset, endOffset));
                    startOffset = i + 1;
                    endOffset = 0;
                }
            }
            i++;
            if (i > text.length() - 1) {
                break;
            }
        }
        resultList.add(text.substring(startOffset));

        return resultList;
    }


    /**
     *  Writes a parameter list to the Log. (for debug only)
     *
     * @param params  The array to write
     */
    private static void logParamTypes(String params[]) {
        StringBuffer s = new StringBuffer();
        for (int i = 0; i < params.length; i++) {
            s.append(params[i] + " ");
        }
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"param: " + s.toString(), null);
    }
}

