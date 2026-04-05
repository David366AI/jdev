/*
 * CodeAidOptionPane.java - Panel in jEdit's Global Options dialog
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


package codeaid.options;

import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.util.*;
import javax.swing.*;

import org.gjt.sp.jedit.AbstractOptionPane;
import org.gjt.sp.jedit.jEdit;
import org.gjt.sp.jedit.browser.*;
import org.gjt.sp.util.Log;

import jane.lang.*;

import codeaid.tools.*;


public class CodeAidOptionPane extends AbstractOptionPane
{
    private JCheckBox  autoIdentifierHelpCB;
    private JCheckBox  autoHintDisplayCB;
    private JTextField autoIdentifierDelayTF;

    private JCheckBox fullAutoCompleteCB;
    private JCheckBox completeNotImported;
    private JCheckBox highlightClassesCB;

    private JRadioButton generatePackageImports;
    private JRadioButton generateClassImports;
    private JRadioButton generateNoImports;


    public CodeAidOptionPane() {
        super("codeaid");
        

    }


    public void _init() {
        this.autoIdentifierHelpCB  = this.createCheckBox("codeaid.autoidentifier", true);
        this.autoHintDisplayCB  = this.createCheckBox("codeaid.autoHintDisplay", true);
        this.autoIdentifierDelayTF = this.createTextField(4, "codeaid.autoidentifier-delay", "500");

        //this.completeNotImported = this.createCheckBox("codeaid.complete-not-imported", false);

        addComponent(this.autoIdentifierHelpCB);
        addComponent(this.autoHintDisplayCB);
        addComponent(
            jEdit.getProperty("options.codeaid.autoidentifier-delay"),
            this.autoIdentifierDelayTF
        );

        //addComponent(this.completeNotImported);

    }


    /**
     * Called when the options dialog's `OK' button is pressed.
     * This should save any properties saved in this option pane.
     */
    public void _save() {
        jEdit.setBooleanProperty(
            "codeaid.autoidentifier", this.autoIdentifierHelpCB.isSelected()
        );
        jEdit.setBooleanProperty(
            "codeaid.autoHintDisplay", this.autoHintDisplayCB.isSelected()
        );
        jEdit.setProperty(
            "codeaid.autoidentifier-delay",
            "" + CodeAidUtilities.getInteger(this.autoIdentifierDelayTF.getText(), 500)
        );

        jEdit.setBooleanProperty(
            "codeaid.complete-not-imported",
            this.completeNotImported.isSelected()
        );
        
    }


    private JCheckBox createCheckBox(String property, boolean defaultValue) {
        JCheckBox cb = new JCheckBox(jEdit.getProperty("options." + property));
        cb.setSelected(jEdit.getBooleanProperty(property, defaultValue));
        return cb;
    }


    private JTextField createTextField(int size, String property, String defaultValue) {
        JTextField tf = new JTextField(jEdit.getProperty(property, defaultValue), size);
        return tf;
    }
}

