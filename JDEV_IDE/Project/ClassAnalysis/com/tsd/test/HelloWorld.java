package com.tsd.test ;

import java.lang.*;
import java.io.*;

public class HelloWorld extends Object
{
    private String name = "gsh";
    /*
    method:       main
    params:
                  1. String[] args
    return type:  void
    create time:  2004-03-04 17:26:54
    author:       gsh
    */
    public  static void main(String[] args)
    {
        HelloWorld hw = new HelloWorld();
        System.out.println("Hello world,"+hw.name);
    }
    class InnerClass
    {
    }
}

class BrotherClass
{
}

