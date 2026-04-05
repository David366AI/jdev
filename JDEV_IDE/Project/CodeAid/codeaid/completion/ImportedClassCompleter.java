/*
 * ImportedClassCompleter.java
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
import java.util.LinkedList;
import java.util.List;

import jane.ClassInfoFinder;
import jane.lang.*;


public class ImportedClassCompleter implements Completer
{
    private String[] allImports;
    private String startsWith;
    private ClassInfoFinder classInfoFinder;


    public ImportedClassCompleter(
            String[] allImports,
            String startsWith,
            ClassInfoFinder classInfoFinder
    ) {
        this.allImports = allImports;
        this.startsWith = startsWith;
        this.classInfoFinder = classInfoFinder;
    }


    public Collection complete() {
        Collection classList = new LinkedList();
        String actImport;

        for (int i = 0; i < allImports.length; i++) {
            actImport = allImports[i];

            if ((actImport.indexOf("*")) == -1) {
                if (actImport.indexOf(".") > -1) {
                    //is full qualified
                    String packageName = actImport.substring(0, actImport.indexOf(".") - 1);
                    String name = actImport.substring(actImport.lastIndexOf(".") + 1);
                    if (name.startsWith(startsWith)) {
                        classList.add(new ImportInfoBase(name, packageName, ImportInfo.CLASS));
                    }
                }
            } else {
                // has star -> get all possible imports which starts with 'expr'
                ClassesInPackageCompleter completer = new ClassesInPackageCompleter(
                    actImport.substring(0, actImport.length() - 2),
                    startsWith, false, classInfoFinder
                );
                List allPossibleImports = new LinkedList(completer.complete());
                classList.addAll(allPossibleImports);
            }
        }

        return classList;
    }
}

