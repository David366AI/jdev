import jane.*;
import jane.lang.*;
import jane.library.*;
import java.util.*;


public class Test  implements JaneConstants
{
    public Test() {
        super();
    }


    public static void main(String[] argv) throws Exception {
        //Library jdk = new Library("jdk");
        //jdk.setClassPath("d:\\jdk142\\lib\\dt.jar");
        //jdk.setParseType(CLASS_PARSE_TYPE);
        Library jane = new Library("jane");
        jane.setSourcePath("D:\\JDK142\\src.ZIP");
        jane.setParseType(SOURCE_PARSE_TYPE);
        LibraryManager libManager = new LibraryManager();
        //libManager.addLibrary(jdk);
        libManager.addLibrary(jane);
        LibraryCodeHandler handler = new LibraryCodeHandler(libManager);
        jane.ClassInfoFinder finder = handler.getFinders(libManager.libraries());

        //ClassInfo ll = finder.findClass("java.lang.Character");
        /*if  ( finder.containsClass("java.lang.System") )
          System.out.println("true");
        System.out.println(ll); */

        Iterator t = finder.findClasses().keySet().iterator();
        while (t.hasNext())
        {
            System.out.println(t.next());
        }
        /*
        t = clses.iterator();
        while (t.hasNext())
        {
            System.out.println(t.next());

        }   */

    }
}
