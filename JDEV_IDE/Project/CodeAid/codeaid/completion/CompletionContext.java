/*
This file is part of [PROGRAM NAME] - [What it does in brief]
Copyright (c) 2001 [Author]

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/
/**
@p
*/
package codeaid.completion;
import java.util.*;

import org.gjt.sp.jedit.*;
import org.gjt.sp.jedit.textarea.JEditTextArea;
import org.gjt.sp.util.Log;
import jane.*;
import jane.lang.SourceLocation;
import jane.lang.TypeResolver;
import jane.parser.ccparser.*;

import codeaid.popup.ExpressionFinder;
import codeaid.popup.CompletionHandler;
import codeaid.tools.CompletionUtil;
//Todo capire se siamo in un commento




public class CompletionContext extends java.lang.Object
{
    private static final char DOT='.';
    private static final char STARTMETHOD='(';
    private static final char STARTJAVADOC='@';

    private boolean isImportStatement=false;
    private boolean isMethodStatement=false;
    private char lastChar;
    private String currentLine;
    private Buffer buffer;
    private ClassInfoFinder classInfoFinder;
    private SourceTree sourceTree;
    private Collection memberList= new ArrayList();
    private int line;
    private int offset;
    private int col;
    private String wholeBuffer;
    private String plusText;
    private JEditTextArea ta;
    
    public CompletionContext() {
    }
    
    public CompletionContext(JEditTextArea _ta) throws UncompletedException {
        
        
        this.ta=_ta;
        this.buffer = ta.getBuffer();
        
        this.offset = ta.getCaretPosition();
        if (offset < 2) {
            throw new UncompletedException("OFFSET <2");
        }
        this.lastChar= buffer.getText(offset - 2, 2).charAt(1);
        this.line = ta.getLineOfOffset(offset);
        this.col = offset - ta.getLineStartOffset(line);
        this.currentLine = ta.getLineText(line);
        this.wholeBuffer = ta.getText();
        
        
        
        
        if (this.currentLine.trim().startsWith("import")) {
            isImportStatement = true;
        }
        if (this.lastChar==STARTMETHOD) {
            isMethodStatement=true;
        }
        
        
        if (Character.isJavaIdentifierPart(lastChar) ||
        lastChar == DOT || lastChar == STARTMETHOD || lastChar == STARTJAVADOC ) {
            prepareJaneContext();
            prepareList();
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"-----------currentLine="+currentLine);
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"-----------lastChar="+lastChar);
        }
    }
    
    private void prepareJaneContext() throws UncompletedException {
        sourceTree= Jane.getSourceTree(buffer);
        classInfoFinder= Jane.getContextFinder();
        if (sourceTree == null  ) {
            throw new UncompletedException("sourceTree is NULL");
        }
        if ( classInfoFinder == null) {
            throw new UncompletedException("classInfoFinder is NULL");
        }
    }
    
    private void prepareList() {
        
        
        
        if (this.isContextInLiteralOrComment()) {
            return;
        }
        
        ImportCompleter importCompleter = new ImportCompleter(currentLine.substring(0,this.col) , classInfoFinder);
        String textTillCurrPos = "";
        if (isMethodStatement) {
            ConstructorCompleter completer= new ConstructorCompleter( classInfoFinder, buffer, offset,line,col,wholeBuffer);
            memberList=completer.complete();
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,memberList);
            if (memberList!=null) {
                return;
            }
            
        }
        try {
            if (isMethodStatement) {
                textTillCurrPos = wholeBuffer.substring(0, offset-1);
            } else {
                textTillCurrPos = wholeBuffer.substring(0, offset);
            }
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"textTillCurrPos");
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"offset"+offset);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        // find the current identifier by going back till the last non-java character
        CompletionHandler.FindResult result = CompletionHandler.findJavaIdentifierBackwards(textTillCurrPos);

        String methodPart = result.expression;
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"methodPart="+methodPart);
        
        if (this.isContextInJavaDoc()) {
            JavaDocCompleter javaDocCompleter = new JavaDocCompleter(methodPart);
            memberList.addAll(javaDocCompleter.complete());
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"JavaDocCompleter --- " + memberList);
            plusText = methodPart;
            return;
        }
        
        if (isImportStatement) {
            memberList = importCompleter.complete();
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"isImportStatement");
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,memberList);
            plusText= methodPart;
            return;
        }
        
        
        try {
            
            MemberCompleter memberCompleter = new MemberCompleter(
                    line, col, sourceTree, wholeBuffer, methodPart, textTillCurrPos, offset, result.offset,
                    classInfoFinder);
            memberList = memberCompleter.complete();
        } catch (Exception e) {}
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"memberCompleter --- " + memberList);
        
        if (isMethodStatement) {
            if (memberList.size() == 0) {
                isMethodStatement = false;
                return;
            }
            CompletionUtil.keepOnlyThisName((List) memberList,methodPart);
        }
        
        if (memberList.size() == 0 && lastChar != DOT && 
            (currentLine.trim().length()==methodPart.length() ||
            currentLine.charAt(currentLine.length() - methodPart.length()-1)!=DOT)) {
            
            
            SymbolCompleter symbolCompleter = new SymbolCompleter(sourceTree, line, col, result.expression);
            Collection allAccessibleSymbol = symbolCompleter.complete();
            memberList.addAll(allAccessibleSymbol);
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"SymbolCompleter --- " + memberList);
            
            ImportedClassCompleter importedClassCompleter =
                new ImportedClassCompleter(sourceTree.getImports(), result.expression, classInfoFinder);
            Collection allImportedClasses = importedClassCompleter.complete();
            memberList.addAll(allImportedClasses);
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"ImportedClassCompleter --- " + memberList);

            ClassesInPackageCompleter completer = new ClassesInPackageCompleter("", result.expression, true,
                classInfoFinder);
            Collection allClassesInDefaultPackage = completer.complete();
            memberList.addAll(allClassesInDefaultPackage);
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"ClassesInPackageCompleter --- " + memberList);
        
            ReservedWordCompleter wordCompleter = new ReservedWordCompleter(result.expression);
            memberList.addAll(wordCompleter.complete());
            if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"ReservedWordCompleter --- " + memberList);
        
        }
        
        if (memberList.size() == 0) {
            memberList = importCompleter.complete();
        }
        
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,memberList);
        plusText=result.expression;   
    }
    

    
    public boolean isImportStatement() {
        return isImportStatement;
    }
    
    public boolean isMethodContext(){
        return isMethodStatement;
    }
    
    public void setMemberList(Collection memberList)
    {
        this.memberList = memberList;
    }
    public Collection getMemberList()
    {
        return memberList;
    }

    public String getPlusText()
    {
        return plusText;
    }
    
    public char getLastChar()
    {
        return lastChar;
    }
    public String getCurrentLine()
    {
        return currentLine;
    }
    public Buffer getBuffer()
    {
        return buffer;
    }
    public ClassInfoFinder getClassInfoFinder()
    {
        return classInfoFinder;
    }
    public SourceTree getSourceTree()
    {
        return sourceTree;
    }
    
    public int getLine()
    {
        return line;
    }
    public int getOffset()
    {
        return offset;
    }
    public int getCol()
    {
        return col;
    }
    public String getWholeBuffer()
    {
        return wholeBuffer;
    }
    
    public JEditTextArea getTa()
    {
        return ta;
    }

    public boolean isContextInJavaDoc() {
        if (this.getCurrentLine().trim().startsWith("//")) {
            return true;
        }
        
        String text=buffer.getText(0,offset);
        if (text.lastIndexOf("/**") > text.lastIndexOf("*/")) {
            return true;
        }
        
        return false;
    }

    public boolean isContextInLiteralOrComment() {
        //take a look if jedit have an API for that
        org.gjt.sp.jedit.syntax.DefaultTokenHandler tokenHandler= new org.gjt.sp.jedit.syntax.DefaultTokenHandler();
        buffer.markTokens(this.getLine(),tokenHandler);
        org.gjt.sp.jedit.syntax.Token token= tokenHandler.getTokens();
        if (token != null) {
            while( token.offset+token.length < this.offset - buffer.getLineStartOffset(this.line)) {
             
                token= token.next;
                if(token == null) {
                    if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"NULL--return false");
                    return false;
                }
            }
            if (token.id == token.LITERAL1 || token.id == token.LITERAL2 ||
                token.id == token.COMMENT1 ) {
                if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"return true");
                return true;
            }
        }
        if (codeaid.CodeAidPlugin.isDebugEnabled() ) Log.log(Log.DEBUG,this,"DEFAULT--return false");
        return false;
        
    }


    
} // -- end class CompletionContext

