/*
 * CompletionTestWrapper.java
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

import junit.framework.*;
import junit.extensions.*;


public class CompletionTestWrapper extends TestCase
{
    public CompletionTestWrapper(String s) {
        super(s);
    }


    public static Test suite() {
        TestSuite suite = new TestSuite();
        suite.addTestSuite(CompletionTest.class);
        TestSetup wrapper =
            new TestSetup(suite)
            {
                public void setUp() throws Exception {
                    TestUtils.setUpParser();
                }
            };
        return wrapper;
    }
}

