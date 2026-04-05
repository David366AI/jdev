
//import java.lang.*;
import java.applet.Applet;
import java.awt.Graphics;

public class helloworld extends Applet
{
    public void init()
    {
        resize(250,250);
    }
    public void paint(Graphics g)
    {
        g.drawString("hello world",25,25);
    }

}


