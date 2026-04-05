/*
 * MethodPopup.java
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

import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.Frame;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.List;
import javax.swing.*;

import org.gjt.sp.jedit.View;
import org.gjt.sp.jedit.gui.InputHandler;
import org.gjt.sp.jedit.textarea.JEditTextArea;

import jane.lang.MemberInfo;


public class MethodPopup extends CodeAidPopup
{
    private JList list;
    private HintPopup hint;


    public MethodPopup(List listData) {
        this((MemberInfo[]) listData.toArray(new MemberInfo[listData.size()]));
    }


    public MethodPopup(MemberInfo[] listData) {
        this.list = new JList(listData);
        list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        setVisibleRowCount(Math.min(listData.length, 5));
        list.setCellRenderer(new MethodListCellRenderer(listData));
    }


    /**
     * Sets the ListFont attribute of the MethodPopup object
     */
    public void setListFont(Font f) {
        ((MethodListCellRenderer) list.getCellRenderer()).setFont(f);
    }


    /**
     * Sets the VisibleRowCount attribute of the MethodPopup object
     */
    public void setVisibleRowCount(int visibleRowCount) {
        list.setVisibleRowCount(visibleRowCount);
    }


    /**
     * Gets the NameOffset attribute of the MethodPopup object
     */
    public int getNameOffset() {
        return 1 + ((MethodListCellRenderer) list.getCellRenderer()).getNameOffset();
    }


    /**
     * Gets the VisibleRowCount attribute of the MethodPopup object
     */
    public int getVisibleRowCount() {
        return list.getVisibleRowCount();
    }


    /**
     * Create the component that the popup will display.
     */
    protected JComponent createPopupComponent() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.add(new JScrollPane(list), BorderLayout.CENTER);
        return panel;
    }


    protected KeyListener createKeyEventInterceptor() {
        return new KeyHandler();
    }


    protected void updateTypedText() {
    }


    protected class KeyHandler extends CodeAidPopup.KeyHandler
    {
        public void keyTyped(KeyEvent evt) {
            super.keyTyped(evt);

            int parenCount = 1;
            boolean quote = false;
            boolean quote1 = false;
            for (int i = 0; i < typedText.length(); i++) {
                switch (typedText.charAt(i)) {
                    case '(':
                        if (!quote && !quote1) {
                            parenCount++;
                        }
                        break;

                    case ')':
                        if (!quote && !quote1) {
                            parenCount--;
                        }
                        break;

                    case '"':
                        if (
                               !quote1
                            && !(
                                   (i > 0 && typedText.charAt(i - 1) == '\\')
                                && (i > 1 && typedText.charAt(i - 2) != '\\')
                            )
                        ) {
                            quote = !quote;
                        }
                        break;

                    case '\'':
                        if (
                               !quote
                            && !(
                                   (i > 0 && typedText.charAt(i - 1) == '\\')
                                && (i > 1 && typedText.charAt(i - 2) != '\\')
                            )
                        ) {
                            quote1 = !quote1;
                        }
                        break;
                }
            }
            if (parenCount <= 0) {
                dispose();
            }
        }


        public void keyPressed(KeyEvent evt) {
            switch (evt.getKeyCode()) {
                case KeyEvent.VK_UP:
                    break;

                case KeyEvent.VK_DOWN:
                    break;

                case KeyEvent.VK_TAB:
                case KeyEvent.VK_ENTER:
                    dispose();
                    break;

                default:
                    super.keyPressed(evt);
                    break;
            }
        }
    }
}

