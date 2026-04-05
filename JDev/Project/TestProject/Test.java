import java.util.*;
import java.io.*;
public class Gsh
{
    public static void main(String[] args) throws Exception
    {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));

        System.out.println(in.readLine());

        String test = "this is a test";
        args = new String[] {test};
        for (int i = args.length-1;i>=0; i--)
        {
            for(int j=args[i].length()-1; j>=0;j--)
            {
                System.out.print(args[i].charAt(j));
            }
            System.out.print(" ");
        }
    }
}


