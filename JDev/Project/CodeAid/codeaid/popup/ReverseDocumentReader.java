/*
 * ReverseDocumentReader.java - a Reader that reads backwards from a Document.
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
import javax.swing.text.Position;
import javax.swing.text.Segment;

import org.gjt.sp.jedit.Buffer;


final class ReverseDocumentReader extends Reader
{
    private Buffer doc;
    private int endOffset; // offset from which backwards reading begins
    private Position pos; // pos in document
    private Segment segment;
    private int index; // index into array of the segment


    public ReverseDocumentReader(Buffer doc, int endOffset) {
        this.doc = doc;
        this.segment = new Segment();
        reset(endOffset);
    }


    /**
     * Returns the Document offset of the last character read.
     */
    public int getOffset() {
        return pos.getOffset() - segment.offset + index + 1;
    }


    // Avoids having to re-create lots of DocumentReader instances.
    public void reset(int endOffset) {
        this.endOffset = endOffset;
        pos = doc.createPosition(endOffset);
        segment.offset = segment.count = 0;
        index = segment.offset - 1;
    }


    public int read() throws IOException {
        if (index < segment.offset) {
            if (pos.getOffset() == 0) {
                return -1;
            }
            loadSegment();
            if (segment.count == 0) {
                return -1;
            }
        }
        return segment.array[index--];
    }


    public int read(char[] cbuf, int off, int len) throws IOException {
        int count = 0;
        int copyCount = 0;
        while (count < len) {
            if (index < segment.offset) {
                if (pos.getOffset() == 0) {
                    break;
                }
                loadSegment();
                if (segment.count == 0) {
                    break;
                }
            }
            copyCount = Math.min(len - count, index + 1 - segment.offset);
            for (int i = 0; i < copyCount; i++) {
                cbuf[off + count + i] = segment.array[index - i];
            }
            count += copyCount;
            index -= copyCount;
        }
        return (count > 0) ? count : -1;
    }


    public boolean ready() throws IOException {
        return index >= segment.offset;
    }


    public void close() throws IOException {
        // Do nothing.
        // This technically violates the spec for java.io.Reader,
        // but this method should never be called anyway.
    }


    private void loadSegment() throws IOException {
        synchronized (doc) {
            int offset = pos.getOffset();
            int n = Math.min(256, offset);

            doc.getText(offset - n, n, segment);
            pos = doc.createPosition(offset - n);
        }

        index = segment.offset + segment.count - 1;
    }
}

