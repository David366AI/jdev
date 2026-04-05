/*
 * ExpressionFinder.java
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


package codeaid.popup;

import java.io.*;

import org.gjt.sp.jedit.Buffer;

import codeaid.popup.*;


public class ExpressionFinder
{
    /**
         * Gets the entire expression that ends at offset.
         *
         * This method must be run inside a synchronization lock on the document.
         */
        public static String getExpression(String doc, int endOffset) {
            
            System.out.println("getExpression :'" + doc.substring(endOffset - 10, endOffset + 1) + "'");
            String expr = "";
            int lastAccept = endOffset;
            int state = States.START;
            int prevState = -1;
            int prevState2 = -1;
            Token token = new Token();

            ReverseStringReader rdr = new ReverseStringReader(doc, endOffset);
            PushbackReader r = new PushbackReader(rdr);

            while (state != States.ACCEPT && state != States.ERROR) {
                nextToken(r, rdr, token);

                prevState2 = prevState;
                prevState = state;
                state = States.table[state][token.type];

                if (state == States.ACCEPT || state == States.MORE) {
                    lastAccept = token.start;
                }

                // special case for just (expr).
                if (
                       (state == States.PAREN)
                    && (prevState == States.DOT)
                    && (prevState2 == States.START)
                ) {
                    lastAccept = token.start;
                }
            }

            if (lastAccept < endOffset) {
                return doc.substring(lastAccept, endOffset + 1);
            }

            return null;
        }
    
    /**
     * Gets the entire expression before the offset.
     *
     * This method must be run inside a synchronization lock on the document.
     */
    public static String getExpressionBeforeOffset(String doc, int endOffset) {
        String expr = "";
        int lastAccept = endOffset;
        int state = States.START;
        int prevState = -1;
        int prevState2 = -1;
        Token token = new Token();

        ReverseStringReader rdr = new ReverseStringReader(doc, endOffset);
        PushbackReader r = new PushbackReader(rdr);

        while (state != States.ACCEPT && state != States.ERROR) {
            nextToken(r, rdr, token);

            prevState2 = prevState;
            prevState = state;
            state = States.table[state][token.type];

            if (state == States.ACCEPT || state == States.MORE) {
                lastAccept = token.start;
            }

            // special case for just (expr).
            if (
                   (state == States.PAREN)
                && (prevState == States.DOT)
                && (prevState2 == States.START)
            ) {
                lastAccept = token.start;
            }
            if (
                   (state == States.PAREN)
                && (prevState == States.DOT)
                && (prevState2 == States.MORE)
            ) {
                lastAccept = token.start;
            }
        }

        if (lastAccept < endOffset) {
            return doc.substring(lastAccept, endOffset);
        }
        return null;
    }


    public static int findConstructorNew(String s) {
        int i;
        for (i = s.length() - 1; i >= 0; i--) {
            char c = s.charAt(i);
            if (!(Character.isWhitespace(c) ||
                Character.isJavaIdentifierPart(c) || c == '.')) {
                break;
            }
            if (i > 3 && c == 'w' && Character.isWhitespace(s.charAt(i + 1)) &&
                !Character.isJavaIdentifierPart(s.charAt(i - 3)) &&
                s.regionMatches(i - 2, "new", 0, 3)) {
                return i - 2;
            }
        }
        return -1;
    }


    private static void nextToken(PushbackReader r, ReverseStringReader rdr,
        Token t) {
        try {
            // peek
            int c;
            do {
                c = r.read();
            } while (Character.isWhitespace((char) c));
            if (c >= 0) {
                r.unread(c);
            }

            t.type = Token.ERROR;
            t.start = t.end = rdr.getOffset();

            if (Character.isJavaIdentifierPart((char) c)) {
                String ident = ident(r);
                if (ident != null) {
                    if (ident.equals("new")) {
                        t.type = Token.NEW;
                    } else {
                        t.type = Token.IDENT;
                    }
                    t.start = rdr.getOffset() + 1;
                    return;
                }
            } else {
                switch (c) {
                    case '"':
                        if (strlit(r)) {
                            t.type = Token.STRLIT;
                        }
                        t.start = rdr.getOffset() + 1;
                        break;

                    case ')':
                        if (bracket(r)) {
                            t.type = Token.PAREN;
                        }
                        t.start = rdr.getOffset();
                        break;

                    case ']':
                    case '}':
                        if (bracket(r)) {
                            t.type = Token.BRACKET;
                        }
                        t.start = rdr.getOffset();
                        break;

                    case '.':
                        if (r.read() == '.') {
                            t.type = Token.DOT;
                        }
                        break;

                    default:
                        break;
                }
            }
        } catch (IOException ioex) {
            // System.err.println(ioex);
        }
    }


    private static String ident(PushbackReader r) throws IOException {
        String ident = "";
        int c;
        while (true) {
            c = r.read();
            if (c < 0) {
                throw new EOFException();
            }
            if (!Character.isJavaIdentifierPart((char) c)) {
                break;
            }
            ident = "" + ((char) c) + ident;// reverse append
        }
        r.unread(c);
        if (ident.length() > 0 &&
            Character.isJavaIdentifierStart(ident.charAt(0))
        ) {
            if (!ident.equals("while") &&
                !ident.equals("for") &&
                !ident.equals("do") &&
                !ident.equals("if") &&
                !ident.equals("else") &&
                !ident.equals("synchronized") &&
                !ident.equals("try") &&
                !ident.equals("catch") &&
                !ident.equals("finally")
            ) {
                return ident;
            }
        }
        return null;
    }


    private static boolean strlit(PushbackReader r) throws IOException {
        int c = r.read();
        if (c < 0) {
            throw new EOFException();
        }
        if (c != '"') {
            r.unread(c);
            return false;
        }
        while (true) {
            c = 0;
            while (c != '"') {
                c = r.read();
                if (c < 0) {
                    throw new EOFException();
                }
            }
            c = r.read();
            if (c < 0) {
                throw new EOFException();
            }
            if (c != '\\') {
                r.unread(c);
                return true;
            }
        }
    }


    private static boolean bracket(PushbackReader r) throws IOException {
        int b = r.read();
        if (b < 0) {
            throw new EOFException();
        }
        if (b != ']' && b != '}' && b != ')') {
            return false;
        }
        r.unread(b);

        int c = 0;

        int prev = 0;

        int prev2 = 0;

        boolean cquote = false;
        boolean squote = false;
        boolean comment = false;
        int bracketLevel = 0;
        int parenLevel = 0;
        int braceLevel = 0;

        while (true) {
            prev2 = prev;
            prev = c;
            c = r.read();
            if (c < 0) {
                throw new EOFException();
            }

            switch (c) {
                case '\'':
                    if (!comment && !squote) {
                        cquote = !cquote;
                    }
                    break;

                case '"':
                    if (!comment && !cquote) {
                        squote = !squote;
                    }
                    break;

                case ']':
                    if (!comment && !squote && !cquote) {
                        bracketLevel++;
                    }
                    break;

                case '[':
                    if (!comment && !squote && !cquote) {
                        bracketLevel--;
                    }
                    break;
                case ')':
                    if (!comment && !squote && !cquote) {
                        parenLevel++;
                    }
                    break;

                case '(':
                    if (!comment && !squote && !cquote) {
                        parenLevel--;
                    }
                    break;
                case '}':
                    if (!comment && !squote && !cquote) {
                        braceLevel++;
                    }
                    break;

                case '{':
                    if (!comment && !squote && !cquote) {
                        braceLevel--;
                    }
                    break;

                case '/':
                    if (!squote && !cquote && prev == '*') {
                        comment = false;
                    }
                    break;

                case '*':
                    if (!squote && !cquote && prev == '/') {
                        comment = true;
                    }
                    break;

                case '\\':
                    if (!comment) {
                        switch (prev) {
                            case '\'':
                                if (!squote) {
                                    cquote = !cquote;
                                }
                                break;

                            case '"':
                                if (!cquote) {
                                    squote = !squote;
                                }
                                break;

                            default:
                                break;
                        }
                    }
                    break;

                default:
                    break;
            }

            if (bracketLevel < 0 || parenLevel < 0 || braceLevel < 0) {
                return false;
            }
            if (bracketLevel == 0 && parenLevel == 0 && braceLevel == 0) {
                return true;
            }
        }
    }


    static class Token
    {
        public int start;
        public int end;
        public int type;
        static final String[] names =
            {"ERROR", "DOT", "STRLIT", "IDENT", "PAREN", "BRACKET", "NEW"};

        static final int ERROR   = 0;
        static final int DOT     = 1;
        static final int STRLIT  = 2;
        static final int IDENT   = 3;
        static final int PAREN   = 4;
        static final int BRACKET = 5;
        static final int NEW     = 6;
    }


    static class States
    {
        static final int ERROR   = 0; // accept last more-accept, if any
        static final int START   = 1;
        static final int DOT     = 2;
        static final int BRACKET = 3;
        static final int PAREN   = 4;
        static final int MORE    = 5; // accept but maybe get more
        static final int ACCEPT  = 6; // accept as of this token

        static final int[][] table = {
        /*              ERROR, DOT, STRLIT, IDENT, PAREN, BRACKET,    NEW */
        /*  ERROR  */ {     0,   0,      0,     0,     0,       0,      0},
        /*  START  */ {     0, DOT,      0,  MORE,     0,       0,      0},
        /*   DOT   */ {     0,   0, ACCEPT,  MORE, PAREN, BRACKET,      0},
        /* BRACKET */ {     0,   0,      0,  MORE, PAREN,       0,      0},
        /*  PAREN  */ {     0,   0,      0,  MORE,     0,       0,      0},
        /*  MORE   */ {     0, DOT,      0,     0,     0,       0, ACCEPT}
        };
    }
}

