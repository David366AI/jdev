/*
 * FieldExpression.java
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
import java.util.Iterator;
import java.util.TreeSet;

import jane.ClassInfoFinder;
import jane.lang.*;

import org.gjt.sp.util.Log;


/**
 *  A field like "a.field"
 */
public class FieldExpression extends MemberExpression
{
    public FieldExpression(ClassInfoFinder classInfoFinder) {
        super(classInfoFinder);
    }


    /**
     *  Gets the members attribute of the FieldExpression object
     */
    public Set getMembers(ClassInfo classInfo) {
        Set result = new TreeSet();
        result.addAll(classInfo.getClasses());
        result.addAll(classInfo.getFields());
        return result;
    }


    public boolean doesMemberMatch(MemberInfo mInfo,
        String className) {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"check matching:", this);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,"mInfo.getName: " + mInfo.getName(), this);
        if (!mInfo.getName().equals(memberDescriptor.name)) {
            return false;
        }

        if (isStatic && java.lang.reflect.Modifier.isStatic(mInfo.getModifiers())) {
            return true;
        } else {
            return false;
        }
    }
}

