/*
 * SymbolCompleter.java
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
import java.util.TreeSet;
import java.util.Arrays;

import jane.lang.*;
import jane.parser.ccparser.*;

import org.gjt.sp.util.Log;


public class SymbolCompleter implements Completer
{
    private SourceTree sourceTree;
    private int line;
    private int col;
    private String expr;


    public SymbolCompleter(SourceTree sourceTree, int line, int col, String expr) {
        this.sourceTree = sourceTree;
        this.line = line;
        this.col = col;
        this.expr = expr;
    }


    public Collection complete() {
        Collection memberList = new TreeSet(Comparators.simple);

        if (sourceTree != null) {
            MemberInfo[] localMembers = null;
            MemberInfo[] globalMembers = null;

            // first all local symbols
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "line :" + line);
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "col: " + col);

            // TODO: what about global, local symbols
            // TODO: add method for looking for members starts with ''

            globalMembers = sourceTree.getSymbolsStartsWith(expr, line, col);

            memberList.addAll(Arrays.asList(globalMembers));
        }

        return memberList;
    }
}

