/*
 * MethodExpression.java
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

import java.util.Set;

import org.gjt.sp.util.Log;

import jane.ClassInfoFinder;
import jane.lang.*;

import org.gjt.sp.util.Log;


/**
 *  A method call ,like   "a.test(...)"
 */
public class MethodExpression extends MemberExpression
{
    public MethodExpression(ClassInfoFinder classInfoFinder) {
        super(classInfoFinder);
    }


    /**
     *  Gets the members attribute of the MethodExpression object
     *
     * @param classInfo  Description of Parameter
     * @return           The members value
     */
    public Set getMembers(ClassInfo classInfo) {
        return classInfo.getMethods();
    }


    public boolean doesMemberMatch(MemberInfo mInfo, String className) {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"check parameter", this);
        String[] parameterTypes = null;
        parameterTypes = ((MethodInfo) mInfo).getParameterTypes();
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"check name " + memberDescriptor.name, this);

        if (!mInfo.getName().equals(memberDescriptor.name)) {
            return false;
        }

        // only static with methods
        if ((isStatic) && !java.lang.reflect.Modifier.isStatic(mInfo.getModifiers())) {
            return false;
        }
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"check parameter ", this);
        if (JavaExpressionParser.matchMethodParams(((MethodDescriptor) memberDescriptor).parameter,
            parameterTypes, classInfoFinder)) {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"found", this);
            return true;
        } else {
            return false;
        }
    }
}

