import java.applet.*;
import java.awt.*;
/**
 * 此处插入类型描述。
 * 创建日期：(02-11-20 17:29:43)
 * @author：Administrator
 */
public class AppletTest extends Hello {
	private Button ivjButton1 = null;
	IvjEventHandler ivjEventHandler = new IvjEventHandler();
	private Label ivjLabel1 = null;

class IvjEventHandler implements java.awt.event.ActionListener {
		public void actionPerformed(java.awt.event.ActionEvent e) {
			if (e.getSource() == AppletTest.this.getButton1()) 
				connEtoC1(e);
		};
	};
/**
 * Comment
 */
public void button1_ActionPerformed(java.awt.event.ActionEvent actionEvent) {
	getLabel1().setText("OK");
	return;
}
/**
 * connEtoC1:  (Button1.action.actionPerformed(java.awt.event.ActionEvent) --> AppletTest.button1_ActionPerformed(Ljava.awt.event.ActionEvent;)V)
 * @param arg1 java.awt.event.ActionEvent
 */
/* 警告：此方法将重新生成。 */
private void connEtoC1(java.awt.event.ActionEvent arg1) {
	try {
		// user code begin {1}
		// user code end
		this.button1_ActionPerformed(arg1);
		// user code begin {2}
		// user code end
	} catch (java.lang.Throwable ivjExc) {
		// user code begin {3}
		// user code end
		handleException(ivjExc);
	}
}
/**
 * 返回关于此小应用程序的信息。
 * @return 返回关于此小应用程序信息的字符串。
 */
public String getAppletInfo() {
	return "AppletTest\n" + 
		"\n" + 
		"此处插入类型描述。\n" + 
		"创建日期：(02-11-20 17:29:43)\n" + 
		"@author：Administrator\n" + 
		"";
}
/**
 * 返回 Button1 特性值。
 * @return java.awt.Button
 */
/* 警告：此方法将重新生成。 */
private java.awt.Button getButton1() {
	if (ivjButton1 == null) {
		try {
			ivjButton1 = new java.awt.Button();
			ivjButton1.setName("Button1");
			ivjButton1.setBounds(199, 57, 56, 20);
			ivjButton1.setLabel("Button1");
			// user code begin {1}
			// user code end
		} catch (java.lang.Throwable ivjExc) {
			// user code begin {2}
			// user code end
			handleException(ivjExc);
		}
	}
	return ivjButton1;
}
/**
 * 返回 Label1 特性值。
 * @return java.awt.Label
 */
/* 警告：此方法将重新生成。 */
private java.awt.Label getLabel1() {
	if (ivjLabel1 == null) {
		try {
			ivjLabel1 = new java.awt.Label();
			ivjLabel1.setName("Label1");
			ivjLabel1.setText("Label1");
			ivjLabel1.setBounds(67, 59, 50, 20);
			// user code begin {1}
			// user code end
		} catch (java.lang.Throwable ivjExc) {
			// user code begin {2}
			// user code end
			handleException(ivjExc);
		}
	}
	return ivjLabel1;
}
/**
 * 每当部件抛出异常时被调用
 * @param exception java.lang.Throwable
 */
private void handleException(java.lang.Throwable exception) {

	/* 除去下列各行的注释，以将未捕捉到的异常打印至 stdout。 */
	// System.out.println("--------- 未捕捉到的异常 ---------");
	// exception.printStackTrace(System.out);
}
/**
 * 初始化小应用程序。
 * 
 * @see #start
 * @see #stop
 * @see #destroy
 */
public void init() {
	try {
		super.init();
		setName("AppletTest");
		setLayout(null);
		setSize(426, 240);
		add(getButton1(), getButton1().getName());
		add(getLabel1(), getLabel1().getName());
		initConnections();
		// user code begin {1}
		// user code end
	} catch (java.lang.Throwable ivjExc) {
		// user code begin {2}
		// user code end
		handleException(ivjExc);
	}
}
/**
 * 初始化连接
 * @exception java.lang.Exception 异常说明。
 */
/* 警告：此方法将重新生成。 */
private void initConnections() throws java.lang.Exception {
	// user code begin {1}
	// user code end
	getButton1().addActionListener(ivjEventHandler);
}
/**
 * 主入口点 - 当部件作为应用程序运行时，启动这个部件。
 * @param args java.lang.String[]
 */
public static void main(java.lang.String[] args) {
	try {
		Frame frame = new java.awt.Frame();
		AppletTest aAppletTest;
		Class iiCls = Class.forName("AppletTest");
		ClassLoader iiClsLoader = iiCls.getClassLoader();
		aAppletTest = (AppletTest)java.beans.Beans.instantiate(iiClsLoader,"AppletTest");
		frame.add("Center", aAppletTest);
		frame.setSize(aAppletTest.getSize());
		frame.addWindowListener(new java.awt.event.WindowAdapter() {
			public void windowClosing(java.awt.event.WindowEvent e) {
				System.exit(0);
			};
		});
		frame.show();
		java.awt.Insets insets = frame.getInsets();
		frame.setSize(frame.getWidth() + insets.left + insets.right, frame.getHeight() + insets.top + insets.bottom);
		frame.setVisible(true);
	} catch (Throwable exception) {
		System.err.println("java.applet.Applet 的 main() 中发生异常");
		exception.printStackTrace(System.out);
	}
}
/**
 * 绘制小应用程序。
 * 如果此小应用程序不需要绘制（例如，如果它只是其他 
 * AWT 组件的一个容器），则可以安全地除去此方法。
 * 
 * @param g 指定的“图形”窗口
 * @see #update
 */
public void paint(Graphics g) {
	super.paint(g);

	//在此处插入用来绘制小应用程序的代码。
}
}
class Hello extends Applet{
}
