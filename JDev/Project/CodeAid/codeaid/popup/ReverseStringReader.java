/*
 * ReverseStringReader.java - a Reader that reads backwards from a String
 * Copyright (c) 1999, 2000, 2001, 2002 CodeAid team
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


package codeaid.popup;

import java.io.IOException;
import java.io.Reader;


public final class ReverseStringReader extends Reader
{
    private String doc;
    private int endOffset;// offset from which backwards reading begins
    private int index;


    public ReverseStringReader(String doc, int endOffset) {
        this.doc = doc;
        reset(endOffset);
    }


    /**
     * Returns the Document offset of the last character read.
     */
    public int getOffset() {
        return index + 1;
    }


    // Avoids having to re-create lots of DocumentReader instances.
    public void reset(int endOffset) {
        this.endOffset = endOffset;
        index = endOffset;
    }


    public int read() throws IOException {
        if (index > -1) {
            return doc.charAt(index--);
        } else {
            return -1;
        }
    }


    public int read(char[] cbuf, int off, int len) throws IOException {
        String reverse = "";
        try {
            System.out.println("doc = " + doc);
            System.out.println("off = " + off);
            System.out.println("len = " + len);
            String part = doc.substring(off - len, off);
            System.out.println("part = " + part);
            reverse = new StringBuffer(part).reverse().toString();
        } catch (Exception e) {
            return -1;
        }
        reverse.getChars(0, reverse.length(), cbuf, 0);
        index = index - reverse.length();
        return reverse.length();
    }


    public boolean ready() throws IOException {
        return ((index <= endOffset) && (index > -1));
    }


    public void close() throws IOException {
        // Do nothing.
        // This technically violates the spec for java.io.Reader,
        // but this method should never be called anyway.
    }
}

