
/*
 * PopupHelper.java
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
import java.awt.Dimension;

import java.awt.Point;
import java.io.File;
import java.io.InputStream;
import java.io.Reader;
import java.io.InputStreamReader;
import java.lang.reflect.Modifier;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Vector;
import java.util.Iterator;
import java.net.URL;
import java.net.MalformedURLException;
import java.util.StringTokenizer;
import javax.swing.SwingUtilities;

import org.gjt.sp.jedit.GUIUtilities;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.util.Log;
import org.gjt.sp.jedit.jEdit;

import jane.lang.*;
import jane.*;

import codeaid.tools.CodeAidUtilities;


public class PopupHelper
{
    private PopupHelper() {}


    public static void showJavaDocPopup(JEditTextArea ta, MemberInfo mInfo, int showOffset,
        String originalObjectType, ClassInfoFinder classInfoFinder) {
        
        JavaDocPopup popup = new JavaDocPopup(ta, true, classInfoFinder);
        popup.setMember(mInfo, originalObjectType);
        popup.show(ta.offsetToXY(showOffset));
    }


    public static void showMemberList(Collection memberList, JEditTextArea ta, int showOffset, String plusText,
        ClassInfoFinder classInfoFinder,
        MemberInfo memberInfo,
        String originalClassName) {

        
        int line = ta.getLineOfOffset(showOffset);
        int col = showOffset - ta.getLineStartOffset(line);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, PopupHelper.class, "line = " + line);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, PopupHelper.class, "col = " + col);
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, PopupHelper.class, "showOffset = " + showOffset);
        MemberPopup popup = new MemberPopup(new LinkedList(memberList));

        Point p = new Point();
        int x = (int) ta.offsetToXY(line, col + 1, p).getX() - popup.getNameOffset();
        int y = (int) ta.offsetToXY(line + 2, col + 1, p).getY();

        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, PopupHelper.class, "x = " + p.x);

        JavaDocPopup hint = new JavaDocPopup(ta, false, classInfoFinder);
        if (memberInfo != null) {
            hint.setMember(memberInfo, originalClassName);
        }
        popup.setHint(hint);
        popup.setStartingText(plusText);
        popup.show(ta, x, y);
        popup.setSelectedIndex(0);
        
        

    }


    public static void showMethodHelp(List memberList, int showOffset, JEditTextArea ta, String plusText,
        ClassInfoFinder classInfoFinder) {
        if (memberList != null && memberList.size() > 0) {
            int line = ta.getLineOfOffset(showOffset);
            int col = showOffset - ta.getLineStartOffset(line);

            MethodPopup popup = new MethodPopup(memberList);
            popup.setListFont(ta.getPainter().getFont());
            Point p = new Point();
            int x = new Double(ta.offsetToXY(line, col + 1, p).getX()).intValue()
                - popup.getNameOffset();

            int virtualLine = ta.getFoldVisibilityManager().physicalToVirtual(line);
            JavaDocPopup hint = new JavaDocPopup(ta, false, classInfoFinder);
            popup.setHint(null);
            popup.setStartingText(plusText);
            popup.show(ta, x, new Double(ta.offsetToXY(virtualLine + 1, 0, new Point()).getY()).intValue()
                 + 5);
        } 
    }


    /**
     * Converts a String in the format of the 'classpath'
     * containing jars/zips and directories to an aray of URL objects
     */
    public static URL[] convertPathToURLs(String classPath) {
        StringTokenizer tokenizer = new StringTokenizer(classPath, File.pathSeparator);
        String classPathElement;
        Vector urls = new Vector();
        URL url;
        while (tokenizer.hasMoreElements()) {
            classPathElement = tokenizer.nextToken();

            try {
                if (!(classPathElement.toLowerCase().endsWith(".jar")) &&
                    !(classPathElement.toLowerCase().endsWith(".zip"))
                ) {
                    // is a diretory
                    // ensure that dirname contains ending '/'
                    if (!(classPathElement.endsWith(File.separator))) {
                        classPathElement += File.separator;
                    }
                }
                url = new URL("file:" + classPathElement);
                urls.add(url);
            } catch (MalformedURLException e) {
                e.printStackTrace();
            }
        }
        URL[] urlArray = new URL[urls.size()];
        int i = 0;
        for (Iterator it = urls.iterator(); it.hasNext(); ) {
            urlArray[i++] = (URL) it.next();
        }
        return urlArray;
    }
}

