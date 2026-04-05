/*
 * JavaSourceFile.java
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

import java.io.*;
import java.util.*;
import java.util.zip.*;

import org.gjt.sp.util.Log;

import jane.*;
import jane.lang.*;
import jane.parser.ccparser.JavaParser;

import codeaid.expression.JavaExpressionParser;
import codeaid.tools.CodeAidUtilities;


/**
 * Gives acces to the members of a JavaSourceFile
 */
public class JavaSourceFile
{
    private JavaArtifact artifact;

    private String sourcePath;
    private String fullQualifiedName;
    private List sourceDirs;


    private ClassInfoFinder classInfoFinder;


    /**
     * Searches in the src-classpath for the source file for the given
     * full qualified class name
     */
    public JavaSourceFile(
            String fullQualifiedName,
            List srcDirs,
            ClassInfoFinder classInfoFinder
    ) throws NoSourceFileFoundException {
        this.fullQualifiedName=fullQualifiedName;
        this.sourceDirs=srcDirs;
        this.classInfoFinder=classInfoFinder;

        System.out.println("sourceDirs :" + srcDirs);

        String actSrcDir = null;
        // iterate over all source dirs/jars
        ZipEntry entry = null;
        ZipFile zipFile = null;
        String originalActSrcDir = "";

        // check if inner class
        int posDollar;
        String additionalPath="";
        if ((posDollar = fullQualifiedName.indexOf('$')) > -1) {
            fullQualifiedName=fullQualifiedName.substring(0, posDollar);
        }
        for (Iterator dirIterator = sourceDirs.iterator(); dirIterator.hasNext();) {
            actSrcDir=(String)dirIterator.next();
            //if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(
            //    Log.DEBUG, this, "read from src:" + actSrcDir + " " + fullQualifiedName
            //);
            originalActSrcDir = actSrcDir;

            int pos;
            additionalPath = "";
            if ((pos = actSrcDir.indexOf('!')) > -1) {
                additionalPath = actSrcDir.substring(pos + 1) + "/";
                actSrcDir = actSrcDir.substring(0, pos);
            }
            String pathName = fullQualifiedName.replace('.', '/');
            String entryname = additionalPath + pathName + ".java";
            //if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "entry/file Name: " + entryname);

            if (CodeAidUtilities.isJarFile(actSrcDir)) {
                try {
                    zipFile = new ZipFile(actSrcDir);
                } catch (IOException e) {}
                // try to read from src jar
                entry = zipFile.getEntry(entryname);

                if (entry == null) { continue; }

                try {
                    artifact = new ArchivedArtifact(zipFile, entry);
                } catch (AnalyzerException e) {
                    //if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.ERROR, CodeAidUtilities.class, e);
                }
            } else {
                // read from java file
                try {
                    File javaFile = new File(actSrcDir + File.separator + entryname);
                    artifact = new FileArtifact(javaFile);
                    break;
                } catch (AnalyzerException e) {
                    continue;
                }
            }
        }
        if (artifact==null) {
            throw new NoSourceFileFoundException(
                "no source found for :" + fullQualifiedName
            );
        }
        this.sourcePath = originalActSrcDir;

        if (entry != null) {
            sourcePath += "!" + additionalPath;
            sourcePath += "/" + entry.getName();
        }
    }


    public MemberInfo readMember(MemberInfo mInfo,ClassInfoFinder finder) {
        // parse the source file
        MemberInfo foundInfo = null;

        //if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "actSrcDir: " + sourcePath);
        int pos;
        String additionalPath = "";
        String newSourcePath = "";
        if ((pos = sourcePath.indexOf('!')) > -1) {
            additionalPath = sourcePath.substring(pos + 1,sourcePath.length());
            newSourcePath = sourcePath.substring(0, pos);
        } else {
            newSourcePath = sourcePath;
        }
        // try to read from src jar
        //if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(
        //    Log.DEBUG, this,
        //    "read from src:" + newSourcePath + " " + fullQualifiedName
        //);
        String pathName = fullQualifiedName.replace('.', '/');

        String entryname = pathName + ".java";
        //if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "entryName: " + entryname);
        Analyzer analyzer = new Analyzer();
        //DefaultClassInfoFinder finder = new DefaultClassInfoFinder();
        /*analyzer.setFinder(finder);
        try {
            analyzer.analyze(artifact, Analyzer.SOURCE_ARTIFACT_TYPE);
        } catch (AnalyzerException e) {
            e.printStackTrace();
            return mInfo;
        }
        */
        ClassInfo ci = finder.findClass(fullQualifiedName);
        String comment = ci.getComment();
        //if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "fullQualifiedName = " + fullQualifiedName);
        //if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG, this, "mInfo = " + mInfo.getClass());

        Set members = new TreeSet();
        if (mInfo instanceof MethodInfo) {
            members = ci.getMethods();
        } else if (mInfo instanceof ConstructorInfo) {
            members = ci.getConstructors();
        } else if (mInfo instanceof FieldInfo) {
            members = ci.getFields();
        }else if (mInfo instanceof ClassInfo) {
            foundInfo = ci;
        }

        for (Iterator it = members.iterator(); it.hasNext(); ) {
            MemberInfo mi = (MemberInfo) it.next();

            if (Comparators.simple.compare(mi, mInfo) == 0) {
                foundInfo = mi;
                break;
            }
        }
        System.out.println("comment: " + foundInfo.getComment());
        if (foundInfo == null) {
            System.out.println("Error, no member found for" + mInfo.getName());
            return mInfo;
        }

        if (mInfo instanceof UpdatableMemberInfo) {
            if (
                   (foundInfo.getComment() == null)
                || (foundInfo.getComment().trim().equals(""))
            ) {
                ((UpdatableMemberInfo) mInfo).setComment(
                    "<em>No comment available</em>"
                );
            } else {
                ((UpdatableMemberInfo) mInfo).setComment(
                    foundInfo.getComment()
                );
            }
        } else {
            throw new IllegalArgumentException("no updatable");
        }

        return mInfo;
    }


    public String getPath() {
        return sourcePath;
    }
}

