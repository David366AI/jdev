import java.net.*;
import java.applet.*;
public class Office
{
   public static void main(String args[]) throws Exception
   {
      URL u = new URL("file:F:/jdev/JDEV_IDE/Project/TestProject/");
      URLClassLoader ucl = new URLClassLoader(new URL[]{u});
      Class c = ucl.loadClass(args[0]);
      System.out.println(c);
   }
}
