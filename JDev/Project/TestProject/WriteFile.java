
import java.lang.*;
import java.io.*;

public class WriteFile extends Object
{

    /*
    method:       main
    params:
                  1. String[] args
    return type:  void
    create time:  2003-08-28 13:11:27
    author:       gshgsh
    */
    public  static void main(String[] args) throws Exception
    {

        PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter("c:\\test.txt")));
        out.println("≤‚ ‘÷–Œƒ");
        out.println("test");
        out.close();
    }
}

