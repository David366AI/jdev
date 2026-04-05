/*
 * JavaDocPopup.java
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

import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyAdapter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.StringTokenizer;
import javax.swing.*;
import javax.swing.border.LineBorder;
import javax.swing.text.*;
import javax.swing.text.html.*;

import org.gjt.sp.jedit.GUIUtilities;
import org.gjt.sp.jedit.View;
import org.gjt.sp.jedit.jEdit;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.util.Log;

import codeaid.tools.*;

import jane.*;
import jane.lang.*;


/**
 * A popup for displaying java doc.
 *
 */
public class JavaDocPopup implements Hint
{
    private String commentToShow;

    private boolean autoClose;
    private JTextPane textPane;
    private KeyHandler keyEventInterceptor;
    private JEditTextArea textArea;
    private ClassInfoFinder finder;
    private JPanel popupComponent;
    private boolean visible = false;

    /**
     * The class name of the class that owns the given member.  This could be different from
     * the declaring class of the given member.  For example, the declaring class of
     * <code>toString()</code> is <code>java.lang.Object</code> but the original class could
     * be a super class, like <code>java.util.Map</code>.
     */
    private String originalClassName;

    public final static int WIDTH = 500;
    public final static int HEIGHT = 150;

    /**
     * Specify a layer between the default and paletter layers for displaying
     * hints.
     */
    public final static Integer HINT_LAYER =
        new Integer((JLayeredPane.DEFAULT_LAYER.intValue() + JLayeredPane.PALETTE_LAYER.intValue()) / 2);


    public JavaDocPopup(
            JEditTextArea aTextArea,
            boolean shouldAutoClose,
            ClassInfoFinder aFinder
    ) {
        finder = aFinder;
        textArea = aTextArea;
        autoClose = shouldAutoClose;

        popupComponent = new JPanel(new BorderLayout());
        popupComponent.setOpaque(true);
        popupComponent.setPreferredSize(new Dimension(WIDTH, HEIGHT));
        popupComponent.setSize(WIDTH, HEIGHT);
        popupComponent.setBackground(UIManager.getColor("ToolTip.background"));
        popupComponent.setBorder(BorderFactory.createCompoundBorder(
            new LineBorder(Color.black, 1, true),
            BorderFactory.createEmptyBorder(12, 12, 11, 11)
        ));

        try {
            Class clazz = Class.forName(getClass().getName() + "$Java14Initializer");
            PopupInitializer initializer = (PopupInitializer) clazz.newInstance();
            initializer.init(popupComponent);
        } catch (Exception e) {
        }

        textPane = new JTextPane();
        textPane.setBackground(UIManager.getColor("ToolTip.background"));
        textPane.setEditorKit(new HTMLEditorKit());
        textPane.setEditable(false);

        JScrollPane scroll = new JScrollPane(textPane);
        scroll.setViewportBorder(null);
        scroll.setBorder(null);
        popupComponent.add(scroll);
    }


    /**
     * Sets the member this popup is to generate information for.
     */
    public void setMember(MemberInfo member) {
        String name = (
              (member instanceof ClassInfo)
            ? member.getType()
            : member.getDeclaringClass()
        );
        setMember(member, name);
    }


    /**
     * Set the member this popup is to generate information for.
     */
    public void setMember(MemberInfo member, String anOriginalClassName) {
        originalClassName = anOriginalClassName;
        textPane.setText(formatComment(member));
        textPane.setCaretPosition(0);
    }


    /**
     * Returns the size of this popup.
     */
    public Dimension getSize() {
        return popupComponent.getSize();
    }


    /**
     * Show this popup.
     */
    public void show(Point pt) {
        // don't show Totaly empty javadoc (reserved words) 77 is the size of empty html generated 
        // from codeaid
        
        if (textPane.getText().trim().length()<=77) {
            return;
        }
        popupComponent.setLocation(pt);
        if (popupComponent.isVisible() && popupComponent.getParent() != null) {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "Hint already visible @ "
                 + popupComponent.getLocation() + " parent: " + popupComponent.getParent());
            return;
        }
        textArea.getRootPane().getLayeredPane().add(popupComponent, HINT_LAYER, 0);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "Showing hint @ " + popupComponent.getLocation());
        if (autoClose) {
            View view = GUIUtilities.getView(textArea);
            keyEventInterceptor = new KeyHandler();
            view.setKeyEventInterceptor(keyEventInterceptor);
        }
        popupComponent.setVisible(true);
        this.visible = false;
    }


    /**
     * Show this popup.
     */
    public void show(int x, int y) {
        show(new Point(x, y));
    }


    /**
     * Hide this popup.
     */
    public void hide() {
        if (!popupComponent.isVisible()) {
            return;
        }
        Rectangle bounds = popupComponent.getBounds();
        textArea.getRootPane().getLayeredPane().remove(popupComponent);
        textArea.getRootPane().getLayeredPane().repaint(bounds);
        View view = GUIUtilities.getView(textArea);
        if (autoClose && keyEventInterceptor == view.getKeyEventInterceptor()) {
            view.setKeyEventInterceptor(null);
        }
        popupComponent.setVisible(false);
        this.visible = false;
        textArea.requestFocus();
    }


    private String parseCommentAndFormatFromSrc(String fullQualifiedName, MemberInfo mInfo,
        ClassInfoFinder classInfoFinder) {
        if (mInfo instanceof ClassInfo) {
            fullQualifiedName = ((ClassInfo) mInfo).getFullName();
        } else {
            fullQualifiedName = MemberInfoUtils.findDeclaringClass(
                fullQualifiedName, mInfo, classInfoFinder
            );
        }

        return formatComment(mInfo);
    }


    /**
     * Reformats the javadoc comment, to produce valid HTML
     */
    private static String formatComment(final MemberInfo info) {
        if (info.getHtmlComment() != null) {
            return info.getHtmlComment();
        }

        StringBuffer sb = new StringBuffer();

        sb.append("<b>");
        sb.append(MemberInfoUtils.getModifiersString(info));
        sb.append("</b>");
        if (info instanceof MethodInfo) {
            sb.append(" <font color=\"#0000ff\">");
            sb.append(((MethodInfo) info).getReturnType());
            sb.append("</font> ");
        }
        sb.append(info.getName());
        if (info instanceof MethodInfo) {
            sb.append(renderParametersToHtml(
                ((MethodInfo) info).getParameterTypes(),
                ((MethodInfo) info).getParameterNames(),
                ((MethodInfo) info).getExceptionTypes()
            ));
        } else if (info instanceof ConstructorInfo) {
            sb.append(renderParametersToHtml(
                ((ConstructorInfo) info).getParameterTypes(),
                ((ConstructorInfo) info).getParameterNames(),
                ((ConstructorInfo) info).getExceptionTypes())
            );
        }

        String memberName = sb.toString();

        String comment = info.getComment();

        if (((comment == null) || (comment.trim().equals(""))) && info instanceof UpdatableMemberInfo ) {
            ((UpdatableMemberInfo) info).setHtmlComment(memberName);
            return memberName;
        }
        StringTokenizer tokenizer = new StringTokenizer(comment, "\n");
        StringBuffer newComment = new StringBuffer();
        String subString;
        boolean bFirstParam = false;
        boolean bFirstEX = false;
        while (tokenizer.hasMoreTokens()) {
            String line = tokenizer.nextToken();
            int aPos = line.indexOf('@');
            if (aPos == -1) {
                newComment.append(line);
                newComment.append(" ");
                continue;
            }
            subString = line.substring(aPos);
            if (subString.startsWith("@param")) {

                //buffer.insert(aPos,"<p>");
                int end = aPos + 8;
                String newLine = "";
                if (!bFirstParam) {
                    newLine += "<br><b>Parameter:</b><br>";
                    newLine += renderParameterToHtml(subString.substring(subString.indexOf(" ")));

                    bFirstParam = true;
                } else {
                    newLine += "<br>" + renderParameterToHtml(subString.substring(subString.indexOf(" ")));
                }

                newComment.append(newLine);
                newComment.append(" ");
            } else if (subString.startsWith("@return")) {
                int end = aPos + 8;
                String newLine = "<br><b>Return:</b><br>" + subString.substring(subString.indexOf(" "));
                newComment.append(newLine);
                newComment.append(" ");
            } else if ((subString.startsWith("@throws"))
                 || (subString.startsWith("@exception "))) {

                int end = aPos + 7;
                String newLine = "";
                if (!bFirstEX) {
                    newLine += "<br><b>Exception:</b><br>";
                    newLine += renderParameterToHtml(subString.substring(subString.indexOf(" ")));
                    bFirstEX = true;
                } else {
                    newLine += "<br>" + renderParameterToHtml(subString.substring(subString.indexOf(" ")));
                }

                newComment.append(newLine);
                newComment.append(" ");
            } else if (subString.startsWith("@since")) {
            } else if (subString.startsWith("@see")) {
            } else if (subString.startsWith("@beaninfo")) {
            } else if (subString.startsWith("@deprecated")) {
                newComment.append("<font color=\"#ff2020\">deprecated</font><br>" +
                    subString.substring(subString.indexOf(" ")));
            } else {
                newComment.append(line);
                newComment.append(" ");
            }
        }
        String commentToSet = memberName + "<p>" + newComment.toString();
        ((UpdatableMemberInfo) info).setHtmlComment(commentToSet);
        return commentToSet;
    }


    /**
     * Renders a single parameter expression or a Exception description 'int
     * hello' to html
     */
    private static String renderParameterToHtml(String paramExpression) {
        paramExpression = paramExpression.trim();
        int spacePos = paramExpression.indexOf(" ");
        if (spacePos == -1) {
            return paramExpression;
        }

        String paramName = paramExpression.substring(0, spacePos);
        String paramDocu = paramExpression.substring(spacePos + 1);
        return "<tt>" + paramName + "</tt>" + " : " + paramDocu;
    }


    /**
     * Renders the parameterType, parameterName, und exception lists to html
     */
    private static String renderParametersToHtml(String[] parameterTypes,
        String[] parameterNames,
        String[] exceptionTypes) {
        String p = "(";
        for (int i = 0; i < parameterTypes.length; i++) {
            p += "<font color=\"#0000ff\">" + parameterTypes[i] + "</font>";
            if ((parameterNames != null) && (parameterNames.length != 0)) {
                p += " " + parameterNames[i];
            }
            if (i != parameterTypes.length - 1) {
                p += ", ";
            }
        }
        p += ")";
        if (exceptionTypes.length > 0) {
            p += " throws ";
            for (int i = 0; i < exceptionTypes.length; i++) {
                p += "<font color=\"#ff1010\">" + exceptionTypes[i] + "</font>";
                if (i != exceptionTypes.length - 1) {
                    p += ", ";
                }
            }
        }

        return p;
    }

    public boolean isVisible() {
        return this.visible;
    }

    /**
     * Listens for key events to handle the auto closing of this hint.
     */
    protected class KeyHandler extends KeyAdapter
    {
        public void keyPressed(KeyEvent evt) {
            hide();
        }
    }


    /**
     * Initializes this popup for Java 1.4.
     */
    private class Java14Initializer implements PopupInitializer
    {
        /**
         * Initialize this panel for 1.4.
         */
        public void init(JPanel panel) {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "Setting up popup for JDK1.4");
            panel.setFocusable(false);
            panel.setFocusTraversalKeysEnabled(false);
        }
    }


    /**
     * An interface to support component initialization of a popup.
     */
    private interface PopupInitializer
    {
        /**
         * Initialize this panel.
         */
        void init(JPanel panel);
    }
}

