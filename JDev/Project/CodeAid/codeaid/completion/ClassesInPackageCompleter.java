/*
 * ClassesInPackageCompleter.java
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

import jane.*;
import jane.lang.*;

import org.gjt.sp.util.Log;


/**
 * Completes to all classes of a package.
 */
public class ClassesInPackageCompleter implements Completer
{
    private String packName;
    private String startsWith;
    private boolean withSubpackages;
    private ClassInfoFinder classInfoFinder;


    public ClassesInPackageCompleter(
            String packName,
            String startsWith,
            boolean withSubpackages,
            ClassInfoFinder classInfoFinder
    ) {
        this.packName = packName;
        this.startsWith = startsWith;
        this.withSubpackages = withSubpackages;
        this.classInfoFinder = classInfoFinder;
    }


    public Collection complete() {
        List result = new LinkedList();
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"packagename: " + packName);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"startswith: " + startsWith);
        Collection packages = classInfoFinder.findPackages();
        String actPackageName;
        if (packages == null) {
            return result;
        }
        // add matching subpackages
        String name;
        // for speeding up
        Set alreadyAdded = new TreeSet();
        // Iteration over all packges in the classTable
        for (Iterator it = packages.iterator(); it.hasNext(); ) {
            actPackageName = (String) it.next();
            // check if match with actual package name
            if (((actPackageName.startsWith(packName)) &&
                (packName.length() + 1) <= actPackageName.length())
                 || packName.trim().equals("")
            ) {
                if (!packName.trim().equals("")) {
                    actPackageName = actPackageName.substring(packName.length() + 1,
                        actPackageName.length());
                }

                if (actPackageName.indexOf('.') > -1) {
                    name = actPackageName.substring(0, actPackageName.indexOf('.'));
                } else {
                    name = actPackageName;
                }

                if (name.trim().equals("")) {
                    continue;
                }
                if (alreadyAdded.contains(name)) {
                    continue;
                }

                // put matching subpackages to result
                if (startsWith == null) {
                    result.add(new ImportInfoBase(name, actPackageName, ImportInfo.SUBPACKAGE));
                } else if (actPackageName.startsWith(startsWith)) {
                    result.add(new ImportInfoBase(name, actPackageName, ImportInfo.SUBPACKAGE));
                }

                alreadyAdded.add(name);
            }
        }
        // add matching classes
        Collection classesInPackage = classInfoFinder.findClassesByPackage(packName);
        if (classesInPackage == null) {
            return result;
        }
        String actClassName;
        for (Iterator it = classesInPackage.iterator(); it.hasNext(); ) {
            Object next = it.next();
            if (next instanceof ClassInfo) {
                actClassName = ((ClassInfo) next).getName();
            } else if (next instanceof CdbClassInfoFinder.LazyClassInfo) {
                CdbClassInfoFinder.LazyClassInfo info =
                    (CdbClassInfoFinder.LazyClassInfo) next;
                actClassName = info.getName();
            } else {
                System.out.println("class: " + next.getClass());
                throw new IllegalStateException("wrong class");
            }
            if (startsWith == null) {
                result.add(new ClassInfoBase(actClassName, packName));
            } else if (actClassName.startsWith(startsWith)) {
                result.add(new ClassInfoBase(actClassName, packName));
            }

        }
        return result;
    }
}

