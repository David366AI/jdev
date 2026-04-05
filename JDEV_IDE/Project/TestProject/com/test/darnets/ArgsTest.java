package com.test.darnets;
public class ArgsTest
{
    public static void main(String[] args)
    {
        for (int i=0 ; i<args.length;i++)
            System.out.println(args[i]);
        change(args[0],args[1]);
        for (int i=0 ; i<args.length;i++)
            System.out.println(args[i]);

    }
    private static void change(String s1,String s2)
    {
        String s = s2;
        s2 = s1;
        s1 = s;
    }
}






