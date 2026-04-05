/*
 * CodeAidPlugin.java - main class of the CodeAid plugin for jEdit
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

package codeaid;


import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.TimerTask;
import java.util.Vector;
import javax.swing.*;

import org.gjt.sp.jedit.Buffer;
import org.gjt.sp.jedit.EBMessage;
import org.gjt.sp.jedit.EBPlugin;
import org.gjt.sp.jedit.GUIUtilities;
import org.gjt.sp.jedit.jEdit;
import org.gjt.sp.jedit.View;
import org.gjt.sp.jedit.buffer.BufferChangeAdapter;
import org.gjt.sp.jedit.gui.OptionsDialog;
import org.gjt.sp.jedit.msg.BufferUpdate;
import org.gjt.sp.jedit.msg.ViewUpdate;
import org.gjt.sp.jedit.msg.PropertiesChanged;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.util.Log;

import codeaid.options.CodeAidOptionPane;
import codeaid.popup.CodeAidPopup;
import codeaid.popup.CompletionHandler;
import codeaid.popup.ContextPopup;


public class CodeAidPlugin extends EBPlugin
{
    /** Decides if full autocompletion during typing is activated */
    private static boolean autoIdentifierHelpPopup =
        jEdit.getBooleanProperty("codeaid.autoidentifier", true);
    private static int autoIdentifierHelpDelay     =
        jEdit.getIntegerProperty("codeaid.autoidentifier-delay", 500);
    private static boolean debugEnabled =
        jEdit.getBooleanProperty("codeaid.debug", false);

    private static java.util.Timer completionTimer = new java.util.Timer();
    private static DocumentHandler characterHandler = new DocumentHandler();


    public CodeAidPlugin() {

    }


    public void start() {

    }

    /**
      @author
    */
    public void stop() {}

    /**
    * gigi
    */
    public void createMenuItems(Vector menuItems) {
        menuItems.addElement(GUIUtilities.loadMenu("codeaid-menu"));
    }


    public void createOptionPanes(OptionsDialog od) {
        od.addOptionPane(new CodeAidOptionPane());
    }


    public void handleMessage(EBMessage message) {
        if (message instanceof BufferUpdate) {
            BufferUpdate bu = (BufferUpdate) message;
            String name = bu.getBuffer().getName().toLowerCase();

            if (name.endsWith(".java")) {
                // TODO: Handle a situation where a file is later saved as a java file.
                if (bu.getWhat() == BufferUpdate.CREATED) {
                    bu.getBuffer().addBufferChangeListener(characterHandler);
                } else if (bu.getWhat() == BufferUpdate.CLOSED) {
                    bu.getBuffer().removeBufferChangeListener(characterHandler);
                }
            }
        } else if (message instanceof ViewUpdate) {
            ViewUpdate vu = (ViewUpdate) message;
            if (vu.getWhat() == ViewUpdate.CREATED) {
                vu.getView().addKeyListener(characterHandler);
            } else if (vu.getWhat() == ViewUpdate.CLOSED) {
                vu.getView().removeKeyListener(characterHandler);
            }
        } else if (message instanceof PropertiesChanged) {
            propertiesChanged();
        }
    }


    private static View getViewWithFocus() {

        return jEdit.getActiveView();

    }


    private static void propertiesChanged() {
        autoIdentifierHelpPopup =
            jEdit.getBooleanProperty("codeaid.autoidentifier", true);
        autoIdentifierHelpDelay =
            jEdit.getIntegerProperty("codeaid.autoidentifier-delay", 500);
    }
    
    public static boolean isDebugEnabled() {
        return debugEnabled;
    }


    private static class SomethingTypedPopupTask extends TimerTask implements Runnable
    {
        private Buffer doc;
        private int offset;
        private JEditTextArea textArea;


        public SomethingTypedPopupTask(Buffer doc, int offset, JEditTextArea textArea) {
            this.doc = doc;
            this.offset = offset;
            this.textArea = textArea;
        }


        /**
         *  Main processing method for the SomethingTypedPopupTask object
         */
        public void run() {
            SwingUtilities.invokeLater(
                new Runnable()
                {
                    public void run() {
                        try {
                            synchronized (doc) {
                                if (getViewWithFocus().getTextArea().hasFocus()) {
                                    ContextPopup.getInstance(getViewWithFocus().getTextArea()).addCompletionContext();
                                }
                                /* if (!CodeAidPopup.isPopupVisible()) {
                                    CompletionHandler.popupKey.complete(textArea);
                                } */
                            }
                        } catch (Throwable t) {
                            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, CodeAidPlugin.class, "Error invoking popup");
                            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, CodeAidPlugin.class, t);
                        }
                    }
                }
            );
        }
    }


    private static class DocumentHandler extends BufferChangeAdapter
        implements KeyListener
    {
        public void contentRemoved(Buffer buffer, int startLine, int offset,
            int numLines, int length) {
            if (length == 0) {
                return;
            }
            completionTimer.cancel();

            /* if (!autoIdentifierHelpPopup) {
                return;
            } */

            View viewWithFocus = getViewWithFocus();
            //if (autoIdentifierHelpPopup || ContextPopup.getInstance(view.getEditPane().getTextArea()).isIncompletion()) {

            if (viewWithFocus != null &&
              (autoIdentifierHelpPopup ||
              ContextPopup.getInstance(viewWithFocus.getTextArea()).isIncompletion())) {
                completionTimer = new java.util.Timer();
                if (ContextPopup.getInstance(viewWithFocus.getTextArea()).isIncompletion()) {
                    completionTimer.schedule(
                        new SomethingTypedPopupTask(
                            buffer, offset - 1,
                            viewWithFocus.getTextArea()
                        ),
                        1
                    );
                } else {
                    completionTimer.schedule(
                        new SomethingTypedPopupTask(
                            buffer, offset - 1,
                            viewWithFocus.getTextArea()
                        ),
                        autoIdentifierHelpDelay
                    );
                }
            }
        }


        public void contentInserted(
                Buffer buffer, int startLine, int offset, int numLines, int length
        ) {
            completionTimer.cancel();

            Buffer doc = buffer;
            /* if (!autoIdentifierHelpPopup) {
                return;
            } */

            View view = getViewWithFocus();

            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "something of a java identifier was typed");
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "InCompletion: "+ContextPopup.getInstance(view.getTextArea()).isIncompletion());
            if (autoIdentifierHelpPopup || ContextPopup.getInstance(view.getTextArea()).isIncompletion()) {
                completionTimer = new java.util.Timer();
                if (ContextPopup.getInstance(view.getTextArea()).isIncompletion()) {
                    completionTimer.schedule(
                        new SomethingTypedPopupTask(
                            buffer, offset, view.getTextArea()
                        ),
                        1
                    );
                } else {
                    completionTimer.schedule(
                        new SomethingTypedPopupTask(
                            buffer, offset, view.getTextArea()
                        ),
                        autoIdentifierHelpDelay
                    );
                }
            }
        }


        /**
         * Handle a key press.  Cancels the timer so that non buffer modifying
         * key presses can cancel the popup window.
         */
        public void keyPressed(KeyEvent evt) {
            completionTimer.cancel();
        }


        public void keyTyped(KeyEvent evt) {}


        public void keyReleased(KeyEvent evt) {}
    }
}

