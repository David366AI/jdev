/*
 * CodeAidPopup.java
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

import java.awt.Dimension;
import java.awt.Point;
import java.awt.Window;
import java.awt.Component;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyListener;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import javax.swing.*;



import org.gjt.sp.jedit.GUIUtilities;
import org.gjt.sp.jedit.View;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.jedit.Buffer;
import org.gjt.sp.util.Log;
import org.gjt.sp.jedit.jEdit;
import codeaid.completion.CompletionContext;
import codeaid.completion.UncompletedException;
import java.util.*;
import codeaid.popup.MemberPopup;
import jane.lang.*;

/**
     * A singleton that represent the unique pop up in teh program
     */
public class ContextPopup implements MouseListener
{
    protected Hint hint;
    private PopupWindow window;
    
    private JEditTextArea textArea;
    private static ContextPopup me = null;
    private List contextList= new ArrayList();
    private CompletionContext currentContext;
    private int x;
    private int y;
    private JList list;
    private JLabel className;

    private static ImageIcon classIcon = new ImageIcon(ContextPopup.class.getResource("/class.gif"));
    
    private ContextPopup(JEditTextArea _textArea) {
        this.textArea = _textArea;
        
    }
    
    /**
     * Get the Popup Instance.
     */
    public static synchronized ContextPopup getInstance(JEditTextArea _textArea) {
        if ( me ==null) {
            me = new ContextPopup(_textArea);
        }
        if (me.getTextArea() != _textArea ) {
            me.textArea = _textArea;
        }
        return me;
    }
   
    public void addCompletionContext() {
        
        //ToDo use exception?
        //Todo move some control to completionContext?
        if (currentContext != null || getView().getKeyEventInterceptor() == null) {
            try {
                CompletionContext cc= new CompletionContext(textArea);
                List memberList = (List) cc.getMemberList();
                if (memberList.size()!=0 && 
                  (memberList.size()!=1 || cc.isMethodContext()|| 
                   ! ((MemberInfo) memberList.get(0)).getName().equals(cc.getPlusText()) ) ) {
                    this.addCompletionContext(cc);
                } else {
                    this.removeCompletionContext(false);
                    
                }
            } catch (UncompletedException e) {
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,e.getMessage() );
            }
        }
    }
    
    public void addCompletionContext(CompletionContext cc) {
        contextList.add(cc);
        if (contextList.size()!=1 || currentContext != null) {
            this.refresh();
        } else {
            this.updateCurrentContext();
            this.updateX();
            this.updateY();
            this.show();
            
        }
    }
    
    public void removeCompletionContext(boolean force) {
        if (contextList.size()>0 && (force || (contextList.size()>0 && !((CompletionContext) contextList.get(contextList.size()-1)).isMethodContext()))) {
            contextList.remove(contextList.size()-1);
            
        }
        
        if(contextList.isEmpty()) {
            this.hide();
        }
        this.refresh();
    }
    
    public void removePreviousCompletionContext() {
        if(contextList.size()>1 && ( ! ((CompletionContext) this.contextList.get(this.contextList.size()-2)).isMethodContext())) {
            this.contextList.remove(this.contextList.size()-2);
        }
        
    }
    
    private void updateCurrentContext() {
        if (contextList.size()==0) {
            currentContext = null;
        } else {
            currentContext = (CompletionContext) contextList.get(contextList.size()-1);
        }
    }
  
    public boolean isIncompletion() {
        if (currentContext == null) {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"Not in completion");
            return false;
        }
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"In completion");
        return true;
    }

    private void refresh() {
        
        this.updateCurrentContext();
       
        if (currentContext!= null) {
            this.updateX();
            this.updateY();
            window.setContentPane(createPopupComponent());
            window.pack();
            if (hint != null && hint.isVisible() ) {
                hint.hide();
            }
            if (!window.isVisible()) { 
                window.show();
                
            }
        }
    }
    private void hide() {
        
        if (hint != null) {
            hint.hide();
            hint = null;
        }
        if (window != null) {
            
            window.dispose();
            window = null;
        }
        
        getTextArea().requestFocus();
        
        
    }
    
    /**
     * Show this popup at the given location.
     */
    public void show() {
        
        
        getPopupWindow(getView());
        calculateBounds();
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "Showing popup at " + window.getLocation());
        
    
        window.setVisible(true);
        
        
        hint = new JavaDocPopup(textArea, false, currentContext.getClassInfoFinder());
        
        
         SwingUtilities.invokeLater(
            new Runnable()
            {
                public void run() {
                    textArea.requestFocus();
                }
            });
    }
    
    private void updateX() {
        if (currentContext == null ) {
            x = 0;
        } else {
            x = (int) currentContext.getTa().offsetToXY(currentContext.getLine(), currentContext.getCol() + 1, new Point()).getX();// - popup.getNameOffset();
        }
    }
    
    private void updateY() {
        if (currentContext == null ) {
            y = 0;
        } else {
            y = (int) currentContext.getTa().offsetToXY(currentContext.getLine() + 2, currentContext.getCol() + 1, new Point()).getY();
        }
    }
    
    /**
     * Sets the SelectedIndex attribute of the MemberPopup object
     */
    public void setSelectedIndex(int index) {
        
        // for some reason this line makes it much faster
        list.ensureIndexIsVisible(index);
        list.setSelectedIndex(index);
        int rowCount = list.getVisibleRowCount();
        list.ensureIndexIsVisible(Math.max(index - (rowCount - 1) / 2, 0));
        list.ensureIndexIsVisible(
            Math.min(index + rowCount / 2, list.getModel().getSize() - 1)
        );
        if (hint != null) {
            hint.setMember((MemberInfo) list.getSelectedValue());
        }
        if (jEdit.getBooleanProperty("codeaid.autoHintDisplay", true)) {
            showHint();
        }
        
    }

    protected void useCurrentSelection(EventObject evt) {
        Object value = list.getSelectedValue();
        if (value != null) {
            String s;
            if (value instanceof ClassInfo) {
                ClassInfo cInfo = (ClassInfo) value;
                s = cInfo.getName();
                // check , if in an import line --> no auto-import
                int actLine = textArea.getCaretLine();
                String line = textArea.getLineText(actLine);
            } else
                if (value instanceof MethodInfo) {
                s = ((MemberInfo) value).getName();
                if (((MethodInfo) value).getParameterTypes().length == 0) {
                    s += "()";
                }
            } else if (value instanceof MemberInfo) {
                s = ((MemberInfo) value).getName();
            } else {
                s = value.toString();
            }

            String text = currentContext.getPlusText();
            textArea.requestFocus();
            if (text.length() > 0) {
                
                s= s.substring(text.length() );
            }
            
            textArea.getBuffer().insert(textArea.getCaretPosition(), s);
            if (value instanceof MethodInfo &&
                ((MethodInfo) value).getParameterTypes().length > 0
                ) {
                View v = getView();
                textArea.userInput('(');
            }
            
            if (currentContext.isImportStatement() && value instanceof ClassInfo ) {
                textArea.userInput(';');
            }
            textArea.requestFocus();
            removeCompletionContext(false);
        }
    }

    /**
     * Gets the NameOffset attribute of the MemberPopup object
     */
    /* TEST public int getNameOffset() {
        return 1 + ((MemberListCellRenderer) list.getCellRenderer()).getNameOffset();
    } */

    public void mouseClicked(MouseEvent evt) {
        if (! currentContext.isMethodContext()) {
            useCurrentSelection(evt);
        } else {
            this.removeCompletionContext(true);
            SwingUtilities.invokeLater(
            new Runnable()
            {
                public void run() {
                    textArea.requestFocus();
                }
            });
        }
    }


    public void mouseReleased(MouseEvent evt) {}


    public void mousePressed(MouseEvent evt) {}


    public void mouseEntered(MouseEvent evt) {}


    public void mouseExited(MouseEvent evt) {}


    
    
    
    private JComponent createPopupComponent() {
        
        list = new JList(currentContext.getMemberList().toArray());
        list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        if(! currentContext.isMethodContext()) {
            list.setCellRenderer(new MemberListCellRenderer(currentContext.getMemberList().toArray()));
        } else {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,
                this,
                currentContext.getMemberList());
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,
                this,
                ((List) currentContext.getMemberList()).get(0).getClass() );
            list.setCellRenderer(new MethodListCellRenderer((MemberInfo[]) currentContext.getMemberList().toArray(new MemberInfo[currentContext.getMemberList().size()])));
        }
        if (list.getModel().getSize() > 0) {
            className = new JLabel(((MemberInfo) list.getModel()
                .getElementAt(0)).getDeclaringClass());
        } else {
            className = new JLabel("N/A");
        }
        
        
        JPanel panel = new JPanel(new GridBagLayout());
        panel.setBorder(BorderFactory.createLoweredBevelBorder());
        GridBagConstraints gbc = new GridBagConstraints();
    
        className.setIcon(classIcon);
        className.setHorizontalAlignment(JLabel.LEFT);
        gbc.gridy = 0;
        gbc.fill = gbc.HORIZONTAL;
        gbc.weightx = 1;
        gbc.weighty = .001;
        panel.add(className, gbc);
    
        list.addMouseListener(this);
        list.setVisibleRowCount(Math.min(currentContext.getMemberList().size(), 5));
        ((Component) list.getCellRenderer()).setFont(textArea.getPainter().getFont());
        JScrollPane scroll = new JScrollPane(list);
        scroll.setBorder(null);
        gbc.gridy++;
        gbc.fill = gbc.BOTH;
        gbc.weighty = .999;
        panel.add(scroll, gbc);
        return panel;
    
    }
    
    /**
     * Sets the Hint attribute of the CodeAidPopup object
     */
    /* public void setHint(Hint aHint) {
        hint = aHint;
    } */

    /**
     * Returns the text area that this popup belongs to.
     */
    protected JEditTextArea getTextArea() {
        return textArea;
    }

    /**
     * Returns the view that of the text area that invoked this popup.
     */
    protected View getView() {
        return GUIUtilities.getView(textArea);
        //return ((Buffer)textArea.getBuffer()).getView();
    }

    /**
     * Returns a popup window.
     */
    protected PopupWindow getPopupWindow(View view) {
        if (window == null) {
            window = new PopupWindow(view);
            try {
                Class clazz = Class.forName(getClass().getName() + "$Java14Initializer");
                PopupInitializer initializer = (PopupInitializer) clazz.newInstance();
                initializer.init(window);
            } catch (Exception e) {
            }
            window.setContentPane(createPopupComponent());
            window.pack();
        }
        return window;
    }
   
    /**
     * Create a key listener to intercept key events.
     */
    protected KeyListener createKeyEventInterceptor() {
        return new KeyHandler();
    }

    /**
     * Returns the height of a line in the text area.
     */
    private int getLineHeight() {
        return textArea.getPainter().getFontMetrics(textArea.getPainter().getFont()).getHeight();
    }

    /**
     * Show the hint popup.
     */
    private void showHint() {
        
        if (hint != null && (! hint.isVisible())) {
        
            JLayeredPane layeredPane = textArea.getRootPane().getLayeredPane();
            Point pt = window.getLocation();
            SwingUtilities.convertPointFromScreen(pt, layeredPane);
    
            Dimension space = layeredPane.getSize();
            int heightAbovePopup = pt.y - (getLineHeight() * 2);
            int heightBelowPopup = (int) (space.getHeight() - (pt.y + window.getHeight() + 11));
    
            Dimension hintSize = hint.getSize();
            if (heightAbovePopup > heightBelowPopup) {
                pt.y -= hint.getSize().height + (getLineHeight() * 2);
            } else {
                pt.y += window.getHeight() + 11;
            }
            hint.show(pt);
        }
    }

    /**
     * Calculate the bounds for this popup.
     */
    private void calculateBounds() {
        Dimension size = window.getSize();
        updateX();
        updateY();
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"X="+x+";Y="+y);
        if (x < 0) {
            x = (textArea.getWidth() - size.width) / 2;
        }
        if (y < 0) {
            y = (textArea.getHeight() - size.height) / 2;
        }
        if (size.width > textArea.getWidth() - x) {
            size.width = textArea.getWidth() - x;
        }
        size.width = Math.max(size.width, 250);
        Point pt = new Point(x, y);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, CodeAidPopup.class, "pt before translation: " + pt);
        Point textAreaPointOnScreen = textArea.getLocationOnScreen();
        pt.translate(textAreaPointOnScreen.x, textAreaPointOnScreen.y);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, CodeAidPopup.class, "pt after translation: " + pt);
        window.setLocation(pt);
        window.setSize(size);
        window.pack();
    }
    
    protected class KeyHandler extends KeyAdapter
    {
        public void keyTyped(KeyEvent evt) {
            char c = evt.getKeyChar();
            if (c != '\b' && c != '\t') {
                textArea.userInput(c);
            }
            
            if (c == ')' && currentContext.isMethodContext() ) {
                
                int bracketOffset = org.gjt.sp.jedit.TextUtilities.findMatchingBracket(currentContext.getBuffer(), 
                        currentContext.getLine(), currentContext.getOffset()-currentContext.getBuffer().getLineStartOffset(currentContext.getLine())-1);
                if(bracketOffset == textArea.getCaretPosition()-1) {
                    if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"removeall (closed bracket) ");
                    removeCompletionContext(true);
                }
            }
            
            if (c != KeyEvent.CHAR_UNDEFINED && c != '\b' &&  c != '\t' ) {
                removePreviousCompletionContext();
            }
            
            
        }

        public void keyPressed(KeyEvent evt) {
            if (evt.getModifiers()== 0 || (evt.getModifiers()== 1 && evt.isShiftDown())) {
                switch (evt.getKeyCode()) {
                    case KeyEvent.VK_BACK_SPACE:
                        textArea.backspace();
                        removeCompletionContext(false);
                        break;
    
                    case KeyEvent.VK_ESCAPE:
                        removeCompletionContext(true);
                        evt.consume();
                        break;
    
                    case KeyEvent.VK_UP:
                        setSelectedIndex(Math.max(list.getSelectedIndex() - 1, 0));
                        evt.consume();
                        break;
    
                    case KeyEvent.VK_DOWN:
                        setSelectedIndex(Math.min(list.getSelectedIndex() + 1,
                            list.getModel().getSize() - 1));
                        evt.consume();
                        break;
                    case KeyEvent.VK_PAGE_UP:
                        setSelectedIndex(Math.max(list.getSelectedIndex() -
                            list.getVisibleRowCount(), 0));
                        evt.consume();
                        break;
    
                    case KeyEvent.VK_PAGE_DOWN:
                        setSelectedIndex(Math.min(list.getSelectedIndex() +
                            list.getVisibleRowCount(),
                            list.getModel().getSize() - 1));
                        evt.consume();
                        break;
    
                    case KeyEvent.VK_ENTER:// Fall-through, enter or tab have the same behaviour
                    case KeyEvent.VK_TAB:
                        if (! currentContext.isMethodContext() && list.getSelectedIndex()!=-1) {
                            useCurrentSelection(evt);
                            evt.consume();
                        } else {
                            CompletionContext cc = currentContext;
                            removeCompletionContext(true);
                            getView().processKeyEvent(evt);
                            addCompletionContext(cc);
                        }
                        
                        break;
                        
                    case KeyEvent.VK_DELETE:
                        if (! currentContext.isMethodContext() && list.getSelectedIndex()!=-1) {
                            removeCompletionContext(false);
                            evt.consume();
                        } else {
                            CompletionContext cc = currentContext;
                            removeCompletionContext(true);
                            getView().processKeyEvent(evt);
                            addCompletionContext(cc);
                        }
                        
                        break;
                    case KeyEvent.VK_F1:
                        showHint();
                        break;
                    
                    default:
                        if (! Character.isLetterOrDigit(Character.toLowerCase(evt.getKeyChar()))) {
                            removeCompletionContext(true);
                            getView().processKeyEvent(evt);
                        } else {
                            if (contextList.size()>0 && 
                                 ! ((CompletionContext) contextList.get(contextList.size()-1)).isMethodContext() ) {
                                contextList.remove(contextList.size()-1);
                            }
                        }
                        
                        
                        break;
                }
            } else {
                removeCompletionContext(true);
                getView().processKeyEvent(evt);
            }
            
        }
        
    }


    /**
     * The popup window.
     */
    private class PopupWindow extends JWindow
    {
        private KeyListener keyListener;

        /**
         * Create a new <code>PopupWindow</code>.
         */
        public PopupWindow(View aView) {
            super(aView);
        }

        /**
         * Set whether this window is visible.
         */
        public void setVisible(boolean visible) {
            if (visible) {
                installKeyHandler();
            } else {
                uninstallKeyHandler();
            }
            super.setVisible(visible);
        }

        /**
         * Install a handler for handling key events.
         */
        private void installKeyHandler() {
            keyListener = createKeyEventInterceptor();
            addKeyListener(keyListener);
            getView().setKeyEventInterceptor(keyListener);
        }

        /**
         * Uninstall a handler from handling key events.
         */
        private void uninstallKeyHandler() {
            View view = getView();
            if (view == null) {
                return;
            }
            if (view.getKeyEventInterceptor() != keyListener) {
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.WARNING, this, "Key event interceptor does not belong to popup");
            } else {
                view.setKeyEventInterceptor(null);
            }
            removeKeyListener(keyListener);
        }
    }

    /**
     * Initializes this popup for Java 1.4.
     */
    private class Java14Initializer implements PopupInitializer
    {
        public void init(PopupWindow window) {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "Setting up popup for JDK1.4");
            window.setFocusable(false);
            window.setFocusTraversalKeysEnabled(false);
        }
    }

    /**
     * An interface to support component initialization of a popup.
     */
    private interface PopupInitializer
    {
        void init(PopupWindow popup);
    }
    
    private class Remover extends TimerTask implements Runnable {
        public void run() {
            if(contextList.isEmpty()) {
                hide();
            }
            refresh();
        }
    }
}

