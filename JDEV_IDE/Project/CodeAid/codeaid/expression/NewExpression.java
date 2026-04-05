/*
 * NewExpression.java
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

import jane.lang.*;
import jane.ClassInfoFinder;

import org.gjt.sp.util.Log;


/**
 * A constructor, like   "new Integer(...)"
 */
public class NewExpression extends MemberExpression
{
    public NewExpression(ClassInfoFinder classInfoFinder) {
        super(classInfoFinder);
    }


    /**
     *  Gets the members attribute of the NewExpression object
     */
    public Set getMembers(ClassInfo classInfo) {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"get constructors", this);
        return classInfo.getConstructors();
    }


    public boolean doesMemberMatch(MemberInfo mInfo,
        String className) {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"check parameter", this);
        String[] parameterTypes = null;
        parameterTypes = ((ConstructorInfo) mInfo).getParameterTypes();
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"check name" + memberDescriptor.name, this);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"class name" + className, this);
        if (!className.equals(memberDescriptor.name)) {
            return false;
        }

        // only static with methods
        if ((isStatic) && !java.lang.reflect.Modifier.isStatic(mInfo.getModifiers())) {
            return false;
        }
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"check parameter ", this);
        if (JavaExpressionParser.matchMethodParams(((NewDescriptor) memberDescriptor).parameter,
            parameterTypes, classInfoFinder)) {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "found");
            return true;
        } else {
            return false;
        }

    }
}

