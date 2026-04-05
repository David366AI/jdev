import java.io.*;
import com.jdev.parser.collections.AST;
import com.jdev.parser.collections.impl.*;
import com.jdev.parser.debug.misc.*;
import com.jdev.parser.*;
import java.awt.event.*;

public class CheckClassGrammer {

    public static void checkFile(String  args) {
		// Use a try/catch block for parser exceptions
		try {
			// if we have at least one command-line argument
				if (( args!=null) && !(args.equals("")) )
				 doFile(args,new File(args)); // parse it
		}
		catch(Exception e) {
			System.err.println("exception: "+e);
		}
	}
	public static void doFile(File f)
							  throws Exception {
		if ((f.getName().length()>5) &&
				f.getName().substring(f.getName().length()-5).equals(".java")) {

			parseFile(f.getName(), new FileInputStream(f));
			
		}
	}
	public static void doFile(String fn,File f)
							  throws Exception {
		if ((f.getName().length()>5) &&
				f.getName().substring(f.getName().length()-5).equals(".java")) {
            FileInputStream s = new FileInputStream(f);
			parseFile(fn,s );
			s.close();
		}
	}
public static void main(String[] args) {
	checkFile("T.java");
}
	public static void parseFile(String f, InputStream s)
								 throws Exception {
        JavaRecognizer parser = null;  									 
		try {
			// Create a scanner that reads from the input stream passed to us
			JavaLexer lexer = new JavaLexer(s);
			lexer.setFilename(f);

			// Create a parser that reads from the scanner
			parser = new JavaRecognizer(lexer);
			parser.setFilename(f);
			parser.errorMsg = "";

			// start parsing at the compilationUnit rule
			parser.compilationUnit();
		    AnalysisClass.doSend("<command>3</command><result>" + parser.errorMsg + "</result>");			    	
		}
		catch (Exception e) {
			System.err.println("parser exception: "+e);
			if ( parser != null )
	        	AnalysisClass.doSend("<command>3</command><result>" + parser.errorMsg + e + "\n" + "</result>");
	        else 
	        	AnalysisClass.doSend("<command>3</command><result>" + e + "\n" + "</result>");	
		}
	}
}
