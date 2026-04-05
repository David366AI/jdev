/*
 * ReverseStringReaderTest.java
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


package codeaid.test;

import java.util.Arrays;

import junit.framework.TestCase;

import codeaid.popup.ReverseStringReader;


public class ReverseStringReaderTest extends TestCase
{
    public ReverseStringReaderTest(String s) {
        super(s);
    }


    public void test() throws Exception {
        String s = "1234567890";
        ReverseStringReader reader = new ReverseStringReader(s, 9);
        assertTrue(reader.ready());
        assertEquals('0', reader.read());
        assertEquals('9', reader.read());
        assertEquals('8', reader.read());
        assertEquals('7', reader.read());

        assertEquals(6, reader.getOffset());

        assertEquals('6', reader.read());
        assertEquals('5', reader.read());
        assertEquals('4', reader.read());
        assertEquals('3', reader.read());
        assertTrue(reader.ready());
        assertEquals('2', reader.read());
        assertEquals('1', reader.read());
        assertTrue(!reader.ready());
        assertEquals(-1, reader.read());
        reader.reset(9);
        assertEquals('0', reader.read());
        reader.reset(9);

        char[] buf = new char[5];
        reader.read(buf, 10, 5);
        char[] exspected_buf = {'0', '9', '8', '7', '6'};
        for (int i = 0; i < buf.length; i++) {
            System.out.print(buf[i] + " ");
        }
        System.out.println();
        for (int i = 0; i < buf.length; i++) {
            System.out.print(exspected_buf[i] + " ");
        }
        assertEquals(5, reader.getOffset());

        assertTrue(Arrays.equals(buf, exspected_buf));
    }
}

