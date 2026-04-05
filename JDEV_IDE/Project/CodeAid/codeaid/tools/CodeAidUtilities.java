/*
 * CodeAidUtilities.java
 * Copyright (c) 2002 CodeAid team
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


package codeaid.tools;

import java.net.*;
import java.util.*;
import java.util.zip.*;
import javax.swing.JOptionPane;
import javax.swing.text.Document;

import org.gjt.sp.jedit.*;
import org.gjt.sp.jedit.io.VFSManager;
import org.gjt.sp.jedit.syntax.KeywordMap;
import org.gjt.sp.jedit.syntax.Token;
import org.gjt.sp.jedit.syntax.TokenMarker;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.util.Log;

import jane.*;
import jane.lang.*;
import java.io.*;
import jane.parser.*;
import jane.parser.ccparser.JavaParser;


public class CodeAidUtilities
{
    public static int getInteger(String value, int defaultVal) {
        int res = defaultVal;
        if (value != null) {
            try {
                res = Integer.parseInt(value);
            } catch (NumberFormatException nfe) {
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(
                    Log.WARNING, CodeAidUtilities.class,
                    "NumberFormatException caught: [" + value + "]"
                );
            }
        }
        return res;
    }


    /**
     * @return true if given path is path to jar file.
     */
    public static boolean isJarFile(String filename) {
        if (filename.endsWith("/")) {
            filename = filename.substring(0, filename.length() - 2);
        }
        // accepting as well 'src.jar!src'
        return (
               filename.toUpperCase().endsWith(".JAR")
            || (filename.toUpperCase().indexOf(".JAR!") > -1)
            || filename.toUpperCase().endsWith(".ZIP")
            || (filename.toUpperCase().indexOf(".ZIP!") > -1)
        );
    }


    /**
     * Go to the location of the given member.
     */
    public static void goToMember(View view, MemberInfo member) {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(
            Log.DEBUG, CodeAidUtilities.class,
            "Going to location of member '" + member + "'"
        );
        SourceLocation location = member.getSourceLocation();
        if (location == SourceLocation.UNKNOWN) {
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(
                Log.DEBUG, CodeAidUtilities.class,
                "Location to member '" + member + "'unknown, parsing source..."
            );
            member = parseFromSource(member);
            location = member.getSourceLocation();
        }
        if (location != SourceLocation.UNKNOWN) {
            CodeAidUtilities.openFile(
                view, location.getFile(), location.getEndLine()
            );
        } else {
            GUIUtilities.error(
                view, "codeaid.error.member-source-not-found",
                new String[] { member.getName() }
            );
        }
    }


    /**
     * Opens specified file in jEdit buffer and jumps to specified line.
     */
    public static void openFile(
            final View view, String filename, final int line
    ) {
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log( Log.DEBUG,view, "opening:"+filename+":"+line );
        if (filename.indexOf('!') >= 0) {
            // if in jar -> add protocol
            if (!filename.startsWith("jar:file:")) {
                filename = "jar:file:"+filename;
            }
        }

        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log( Log.DEBUG,view, "filename:" + filename);
        Buffer buffer = jEdit.openFile(view, filename);
        view.setBuffer(buffer);

        // Only do this after all I/O requests are complete
        Runnable runnable = new Runnable() {
            public void run() {
                int lineNo = line - 1;
                view.getTextArea().setCaretPosition(
                    view.getTextArea().getLineStartOffset(lineNo)
                );
            }
        };

        if (buffer.isPerformingIO()) {
            VFSManager.runInAWTThread(runnable);
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, view, "performing IO running in runInAWTThread");
        } else {
            runnable.run();
        }
    }


    public static List parseClassString(String dirs) {
        List l = new ArrayList();
        if (dirs != null) {
            StringTokenizer t = new StringTokenizer(dirs, File.pathSeparator);
            while (t.hasMoreTokens()) {
                String dir = t.nextToken();
                if (
                       !dir.endsWith(File.separator)
                    && !CodeAidUtilities.isJarFile(dir)
                ) {
                    dir += File.separator;
                }

                l.add(dir);
            }
        }

        return l;
    }


    public static List getSourcesDirs() {
        List l = new java.util.ArrayList();
        String dirs = jEdit.getProperty("options.codeaid.sourcepath");
        return parseClassString(dirs);
        
    }


    public static List getClassDirs() {
        List l = new ArrayList();
        String dirs = jEdit.getProperty("options.codeaid.classpath");
        return parseClassString(dirs);
    }


    public static MemberInfo parseFromSource(MemberInfo info) {
        String fullQualifiedName = info.getDeclaringClass();

        if (info instanceof ClassInfo) {
            fullQualifiedName = ((ClassInfo) info).getFullName();
        }
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, CodeAidUtilities.class, "trying to load:" + info);
        String actSrcDir;
        List sourceDirs = Jane.getContextSrcDirs();
        for (Iterator dirIterator = sourceDirs.iterator(); dirIterator.hasNext(); ) {
            actSrcDir = (String) dirIterator.next();
            String pathName = fullQualifiedName.replace('.', '/');
            String entryname = pathName;

            JavaArtifact artifact = null;
            if (!CodeAidUtilities.isJarFile(actSrcDir)) {
                File f = new File( actSrcDir );
                if (f.isDirectory()) {
                    entryname = pathName + ".java";
                    File ff = new File(actSrcDir + File.separator + entryname);
                    if (ff.exists()) {
                        try {
                            artifact = new FileArtifact(ff);
                        } catch (AnalyzerException e) {
                            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.ERROR, CodeAidUtilities.class, e);
                        }
                    }
                }
            } else {
                int pos;
                String additionalPath = "";
                if ((pos = actSrcDir.indexOf('!')) > -1) {
                    additionalPath = actSrcDir.substring(
                        pos + 1, actSrcDir.length()) + "/";
                    actSrcDir = actSrcDir.substring(0, pos);
                }

                ZipFile file = null;
                try {
                    file = new ZipFile(actSrcDir);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                // try to read from src jar
                entryname = additionalPath + pathName + ".java";
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(
                    Log.DEBUG, CodeAidUtilities.class,
                    "read from src:" + actSrcDir + " " + fullQualifiedName
                );

                ZipEntry entry=file.getEntry(entryname);
                if (entry != null) {
                    try {
                        artifact = new ArchivedArtifact(file, entry);
                    } catch (AnalyzerException e) {
                        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.ERROR, CodeAidUtilities.class, e);
                    }
                }
            }

            if (artifact == null) { continue; }

            Analyzer analyzer = new Analyzer();
            DefaultClassInfoFinder classInfoFinder=new DefaultClassInfoFinder();
            analyzer.setFinder(classInfoFinder);
            try {
                analyzer.analyze(artifact,Analyzer.SOURCE_ARTIFACT_TYPE);
                ClassInfo newInfo=classInfoFinder.findClass(fullQualifiedName);
                if (Comparators.compare(newInfo, info) == 0) {
                    return newInfo;
                } else {
                    Comparator comparator=Comparators.simple;
                    Iterator it = null;
                    if (info instanceof MethodInfo) {
                        it = newInfo.getMethods().iterator();
                        comparator = Comparators.methodInfo;
                    } else if (info instanceof ConstructorInfo) {
                        it = newInfo.getConstructors().iterator();
                        comparator = Comparators.constructorInfo;
                    } else if (info instanceof FieldInfo) {
                        it = newInfo.getFields().iterator();
                        comparator = Comparators.fieldInfo;
                    }
                    if (it != null) {
                        while (it.hasNext()) {
                            Object newMember = it.next();
                            if (comparator.compare(newMember, info) == 0) {
                                return (MemberInfo)newMember;
                            }
                        }
                        System.out.println("Can not find info in reparsed " + info);
                    }
                }
            } catch (AnalyzerException e) {
                e.printStackTrace();
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(
                    Log.DEBUG, CodeAidUtilities.class,
                    "analyzing of source failed"
                );
            }
        }

        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log( Log.DEBUG,CodeAidUtilities.class,"Reloading failed");
        return info;
    }


    public static List getByteCodeDirs() {
        return Jane.getContextClassDirs();
    }


    /**
     * Returns a list of classes starting with the given string.
     */
    public static Collection getClassesStartedWith(
            String s, ClassInfoFinder finder
    ) {
        return new Classes(finder).getClasses(new Classes.NameStartingWith(s));
    }

}



