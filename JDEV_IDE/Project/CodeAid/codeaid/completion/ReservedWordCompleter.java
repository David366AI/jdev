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

import jane.lang.*;



public class ReservedWordCompleter implements Completer
{
    private String actExpression;
    private static String[] words = {
        "abstract", "assert", "boolean", "break", "byte ", "case", "catch", "char", "class",
        "const", "continue", "default", "do", "double", "else", "extends", "false",
        "final", "finally", "float", "for", "goto", "if", "implements", "import",
        "instanceof", "int", "interface", "long", "native", "new", "null", "package",
        "private", "protected", "public", "return", "short", "static", "strictfp",
        "super", "switch", "synchronized", "this", "throw", "throws", "transient",
        "true", "try", "void", "volatile", "while"
    };


    public ReservedWordCompleter(String actExpression) {
        this.actExpression = actExpression;
    }


    public Collection complete() {
        String word;
        List result = new LinkedList();

        for (int i = 0; i < words.length; i++) {
            word = words[i];
            if (word.startsWith(actExpression)) {
                result.add(new SimpleInfoBase(word));
            }
        }

        return result;
    }
}

