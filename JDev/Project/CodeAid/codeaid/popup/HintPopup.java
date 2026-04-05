/*
 * HintPopup.java
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

import java.awt.Container;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.Rectangle;
import javax.swing.*;

import jane.lang.MemberInfo;

import org.gjt.sp.jedit.textarea.JEditTextArea;


/**
 * A popup that show a simple hint for a member.
 */
public class HintPopup implements Hint
{
    private JToolTip popupComponent;

    private JEditTextArea textArea;
    
    private boolean visible = false;

    /**
     * Between JLayeredPane.DEFAULT_LAYER and JLayeredPane.PALETTE_LAYER.
     */
    public final static Integer HINT_LAYER = new Integer(
        (JLayeredPane.DEFAULT_LAYER.intValue() + JLayeredPane.PALETTE_LAYER.intValue()) / 2);


    /**
     * Create a new <code>HintPopup</code>.
     */
    public HintPopup(JEditTextArea ta) {
        this.textArea = ta;
    }


    /**
     * Sets the member to show information for.
     */
    public void setMember(MemberInfo mInfo) {
        popupComponent.setTipText(mInfo.getComment());
        popupComponent.setSize(popupComponent.getPreferredSize());
    }


    /**
     * Returns the size of this popup.
     */
    public Dimension getSize() {
        return popupComponent.getSize();
    }


    /**
     * Show the popup at the given location.
     */
    public void show(int x, int y) {
        show(new Point(x, y));
    }


    /**
     * Show the popup at the given location.
     */
    public void show(Point pt) {
        pt = SwingUtilities.convertPoint(
            textArea, pt, textArea.getRootPane().getLayeredPane()
        );
        popupComponent.setLocation(pt);
        if (!popupComponent.isVisible()) {
            textArea.getRootPane().getLayeredPane().add(popupComponent, HINT_LAYER, 0);
            popupComponent.setVisible(true);
            this.visible = true;
        }
    }


    /**
     * Show the popup relative to the given position of the text area.
     */
    public void showRelativeToTextArea(int line, int col) {
        int x = textArea.offsetToXY(line, col, new Point()).x;
        int y = textArea.offsetToXY(line - 1, 0, new Point()).y;
        show(x, y + 3);
    }


    /**
     * Hide this popup.
     */
    public void hide() {
        if (popupComponent.isVisible() && popupComponent.getParent() != null) {
            popupComponent.getParent().remove(popupComponent);
            Rectangle bounds = popupComponent.getBounds();
            popupComponent.getParent().repaint(bounds.x, bounds.y, bounds.width, bounds.height);
            popupComponent.setVisible(false);
            this.visible = false;
        }
    }
    
    public boolean isVisible() {
        return this.visible;
    }
}

