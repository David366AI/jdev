import java.lang.*;
import jane.lang.*;
import java.io.*;
import java.util.zip.*;
import java.util.*;
public class Java extends Object
{

    // field:testStr
    private short testStr ;
    /*
    method:       main
    params:
                  1. String[] args
    return type:  void
    create time:  2003-10-07 09:18:37
    author:       gshgsh
    */
    public  static void main(String[] args)
    {
        try
        {
            ZipFile zf = new ZipFile("c:\\jedit41\\jars\\Jane.jar");
            Enumeration e = zf.entries();
            while (e.hasMoreElements())
            {
                ZipEntry ze = (ZipEntry) e.nextElement();
                System.out.println(ze.getName());
            }
            ZipEntry z = zf.getEntry("jane/lang/ClassInfo.class");
            System.out.println(z);
        }
        catch(Exception e)
        {
            System.out.println(e);
            ClassInfo ci;
            ci.
        }
    }
}




