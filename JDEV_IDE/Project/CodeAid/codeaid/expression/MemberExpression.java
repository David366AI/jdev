/*
 * MemberExpression.java
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

import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;

import org.gjt.sp.util.Log;

import jane.lang.*;
import jane.*;

import org.gjt.sp.util.Log;


/**
 *  Base class of New/Field/Method expression
 */
public abstract class MemberExpression extends Expression
{
    public String objectReferenzClassname;
    public boolean isStatic;
    public MemberDescriptor memberDescriptor;
    protected ClassInfoFinder classInfoFinder;


    public MemberExpression(ClassInfoFinder classInfoFinder) {
        this.classInfoFinder = classInfoFinder;
    }


    /**
     * Gets the members attribute of the MemberExpression object
     */
    public abstract Set getMembers(ClassInfo info);


    public abstract boolean doesMemberMatch(MemberInfo info, String className);


    public MemberInfo findMatchingMember() {
        return findMatchingMember(objectReferenzClassname);
    }


    private MemberInfo findMatchingMember(String className) {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "search in: " + className);

        ClassInfo classInfo = classInfoFinder.findClass(className);
        if (classInfo == null) {
            return null;
        }
        Set members = new TreeSet();
        String lastName;
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"get members of " + classInfo.getFullName(),this);

        members = getMembers(classInfo);
        MemberInfo mInfo;
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"look for member '" + memberDescriptor.name + "' in class :" + classInfo.getFullName(),this);
        String memberInfoName;
        for (Iterator it = members.iterator(); it.hasNext(); ) {
            mInfo = (MemberInfo) it.next();
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"member: " + mInfo.getName(),this);

            if (doesMemberMatch(mInfo, classInfo.getFullName())) {
                if (MemberInfoUtils.isAccessAllowed(classInfo, mInfo, false,
                    classInfoFinder,
                    true)) {
                    return mInfo;
                } else {
                    if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "member found, but acces is not allowed :" + mInfo.getName() + " " + classInfo.getFullName());
                }
            }
        }
        lastName = className;
        // what about innerClasses ?
        // if actual class is a inner class??
        String declaringClass = classInfo.getDeclaringClass();
        // get declaring class and iterates over all its classes
        if (declaringClass != null) {
            MemberInfo mi = findMatchingMember(declaringClass);
            if (mi != null) {
                return mi;
            }
        }
        if (classInfo.isInterface()) {
            // we might have severall superinterfaces
            String superInterfaces[] = classInfo.getInterfaces();
            if (superInterfaces.length == 0) {
                return null;
            } else {
                for (int i = 0; i < superInterfaces.length; i++) {
                    MemberInfo mi = findMatchingMember(superInterfaces[i]);
                    if (mi != null) {
                        return mi;
                    }
                }
                return null;
            }
        } else {
            String superClass = classInfo.getSuperclass();
            if (superClass == null) {
                return null;
            } else {
                return findMatchingMember(superClass);
            }
        }
    }
}

