/**
 * 此处插入类型描述。
 * 创建日期：(2002-8-30 17:33:59)
 * @author：Administrator
 */
import java.io.*;
import java.sql.*;
import java.util.*;
public class DbTest
{
    private Driver driver;
    private String password = "";
    private String user = "sa"
    private String url ="jdbc:microsoft:sqlserver://192.168.0.223:1433;DatabaseName=ebd_city";
    //private String password = "ebd_city";
    //private String user = "ebd";
    //private String url ="jdbc:oracle:thin:@127.0.0.1:1521:gzebd";
    private String testStr= "詩共中文";
    private Connection con;
    private ArrayList tbldata;
    protected String gsh="";

    String gshgsh="";
    static boolean  exitFlag=false;
    /**
     * DbTest 构造子注解。
     */
    public DbTest()
    {
        super();
    }
    int ggg;
    /**
     * 此处插入方法描述。
     * 创建日期：(2002-8-30 17:39:28)
     */
    public void init() throws Exception
    {
        loadDriver();
        int[] is = new int[1500];
        System.out.println("hello");
        //con = DriverManager.getConnection(url, user, password);
    }
    public void test()
    {
        ;
    }
    public void newMethod()
    {
        ;
    }
    public static void getStr(String[][]  s)
    {}
    private void loadDriver()
    {
        try
        {
            //            Class.forName(driverClassName);
            // Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");

            //DriverManager.registerDriver(driver);
            // System.out.println("Registered JDBC driver com.microsoft.jdbc.sqlserver.SQLServerDriver" );
            //Class.forName("oracle.jdbc.driver.OracleDriver");

            //System.out.println("Registered JDBC driver oracle.jdbc.driver.OracleDriver" );
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
    }
    /**
     * 启动应用程序。
     * @param args 命令行自变量数组
     */
    public static void main(java.lang.String[] args) throws Exception
    {
        //在此处插入用来启动应用程序的代码。
        DbTest dt = new DbTest();
        ClassLoader bv = dt.getClass().getClassLoader();
        try
        {
            //初始化
            dt.init();

            dt.query();
            exitFlag=true;

            //释放
            dt.release();
            // input.readLine();


        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2002-8-31 0:01:18)
     * @exception java.lang.Exception 异常说明。
     */
    public void query() throws java.lang.Exception
    {
        //ResultSet rs = null;
        try
        {
            Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
            con = DriverManager.getConnection(url, user, password);
            String query = "select id from DM_BJLX  ";

            //PreparedStatement stmt = con.prepareStatement(query);
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("select * from DM_BJLX");
            //rs = stmt.executeQuery();

            ResultSetMetaData rsmd =rs.getMetaData();

            int numberOfColumns = rsmd.getColumnCount();
            //System.out.println(numberOfColumns);
            tbldata= new ArrayList();
            while ( rs.next() )
            {
                Object[] obj = new Object[numberOfColumns];
                for (int i = 0; i < numberOfColumns; i++)
                {
                    Object  tempObj = rs.getObject(i+1);
                    obj[i] =  (tempObj == null) ? "":tempObj.toString().trim();
                    System.out.print("\t"+obj[i].toString());
                }
                System.out.println("");
                tbldata.add(obj);
            }
        }
        catch(Exception e)
        {
            System.out.println(e);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2002-8-30 23:53:08)
     */
    public void release() throws Exception
    {
        con.close();
        DriverManager.deregisterDriver(driver);
        System.out.println("释放");
    }
}


