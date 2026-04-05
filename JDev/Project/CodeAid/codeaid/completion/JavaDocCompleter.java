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
 *
 */


package codeaid.completion;

import java.util.*;

import jane.lang.*;
import jane.parser.ccparser.*;

import org.gjt.sp.util.Log;


public class JavaDocCompleter implements Completer
{
    private String actExpression;
    private static String[] words = {
        "@author ", "@deprecated ", "@exception ", "@link ",
        "@param ", "@return ","@see ","@since ", "@version "
    };


    public JavaDocCompleter(String actExpression) {
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


