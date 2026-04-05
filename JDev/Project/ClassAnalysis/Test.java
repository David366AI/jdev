
import java.lang.*;

public class Test extends Object
{
    /*
    method:       main
    params:
                  1. String[] args
    return type:  void
    create time:  2004-02-06 10:00:09
    author:       gsh
    */
    public  static void main(String[] args)
    {
        String[] a = {"11","12","13","14"};
        Test t = new Test();
        t.change(a);
        for(int i=0;i<a.length;i++)
            System.out.println(a[i]);
    }
    public void change(String[] a)
    {
        for(int i=0;i<a.length;i++)
            a[i]="CH"+a[i];
    }

}

