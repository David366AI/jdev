
import java.lang.*;
import java.applet.*;
import java.awt.*;

public class FirstApplet extends java.applet.Applet
{
    private Button button1 = null;
    private Label label1 = null;
    public void init()
    {
        try
        {
            super.init();
            setName("AppletTest");
            setLayout(null);
            setSize(400, 240);
            button1 = new java.awt.Button();
            button1.setName("button");
            button1.setBounds(199, 57, 56, 20);
            button1.setLabel("button");
            add
                (button1, button1.getName());

            label1 = new java.awt.Label();
            label1.setName("label");
            label1.setText("label");
            label1.setBounds(67, 59, 50, 20);
            add
                (label1, label1.getName());

            //initConnections();
        }
        catch (java.lang.Throwable ivjExc)
        {
            ;//handleException(ivjExc);
        }
    }
    class IvjEventHandler implements java.awt.event.ActionListener
    {
        public void actionPerformed(java.awt.event.ActionEvent e)
        {
            if (e.getSource() == AppletTest.this.getButton1())
                connEtoC1(e);
        };
    };
}
