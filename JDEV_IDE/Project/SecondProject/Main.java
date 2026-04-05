import java.io.*;
import java.util.*;
public class Main{
  int i,j,k;
  public static void main(String[] argv)
  {
  	Test.getInstance();
  	Test.getInstance();
  }
}
class Test{
  static {
  	System.out.println("实例化 static 段1");
  }
  private static final Test test = new Test();
  static {
  	System.out.println("实例化 static 段2");
  }
  private Test()
  {
  	System.out.println("构造函数");
  }
  public static Test getInstance()
  {
     return test;
  }
}
