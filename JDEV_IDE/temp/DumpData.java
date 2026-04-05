
import java.io.*;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class DumpData
{

    public DumpData()
    {
        dbProp = new Properties();
        tableList = new ArrayList();
    }

    public void dumpdata()
    {
        log("begin dump data ...");
        log("source database is " + getConfigItem("sourceURL"));
        log("destination database is " + getConfigItem("desURL"));
        try
        {
            Connection connection = DriverManager.getConnection(getConfigItem("sourceURL"), getConfigItem("sourceDBUser"), getConfigItem("sourceDBPassword"));
            Connection connection1 = DriverManager.getConnection(getConfigItem("desURL"), getConfigItem("desDBUser"), getConfigItem("desDBPassword"));
            Object obj = null;
            Object obj1 = null;
            Object obj2 = null;
            for(int i = 0; i < tableList.size(); i++)
                try
                {
                    String s = tableList.get(i).toString();
                    PreparedStatement preparedstatement = connection.prepareStatement("select * from " + s);
                    ResultSet resultset = preparedstatement.executeQuery();
                    ResultSetMetaData resultsetmetadata = resultset.getMetaData();
                    int j = resultsetmetadata.getColumnCount();
                    String s1 = "insert into " + s + "(";
                    for(int k = 1; k <= j; k++)
                        if(k == j)
                            s1 = s1 + resultsetmetadata.getColumnName(k) + ")";
                        else
                            s1 = s1 + resultsetmetadata.getColumnName(k) + ",";

                    s1 = s1 + " values(";
                    for(int l = 1; l <= j; l++)
                        if(l == j)
                            s1 = s1 + "?)";
                        else
                            s1 = s1 + "?,";

                    try
                    {
                        PreparedStatement preparedstatement2 = connection1.prepareStatement("delete  from " + s);
                        preparedstatement2.executeUpdate();
                        preparedstatement2.close();
                    }
                    catch(Exception exception2)
                    {
                        log(exception2);
                    }
                    int i1 = 0;
                    int j1 = 0;
                    try
                    {
                        while(resultset.next()) 
                        {
                            i1++;
                            PreparedStatement preparedstatement1 = connection1.prepareStatement(s1);
                            for(int k1 = 1; k1 <= j; k1++)
                            {
                                Object obj3 = resultset.getObject(k1);
                                if(obj3 != null)
                                    preparedstatement1.setObject(k1, obj3);
                                else
                                    preparedstatement1.setNull(k1, resultsetmetadata.getColumnType(k1));
                            }

                            try
                            {
                                preparedstatement1.executeUpdate();
                                j1++;
                            }
                            catch(Exception exception4)
                            {
                                log(exception4.getMessage() + "\t error row is : number " + i1);
                            }
                            finally
                            {
                                if(preparedstatement1 != null)
                                    preparedstatement1.close();
                            }
                        }
                    }
                    catch(Exception exception3)
                    {
                        log(exception3);
                    }
                    log("table " + s + " has " + i1 + " rows ");
                    log("table " + s + " was dump " + j1 + " rows successfully");
                    if(connection != null)
                        preparedstatement.close();
                }
                catch(Exception exception1)
                {
                    log(exception1);
                }

            if(connection != null)
                connection.close();
            if(connection1 != null)
                connection1.close();
        }
        catch(Exception exception)
        {
            log(exception);
        }
        log("end dump data");
    }

    public String getConfigItem(String s)
    {
        if(dbProp != null)
            return dbProp.getProperty(s);
        else
            return null;
    }

    public String getDateString()
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy-MM-dd HHmmss");
        Date date = new Date();
        return simpledateformat.format(date);
    }

    public void init()
    {
        try
        {
            FileInputStream fileinputstream = new FileInputStream(db_cfg_file);
            dbProp.load(fileinputstream);
            fileinputstream.close();
        }
        catch(Exception exception)
        {
            log(exception);
            log("Can't read file " + db_cfg_file);
            log("Program exit!");
            System.exit(1);
        }
        try
        {
            BufferedReader bufferedreader = new BufferedReader(new InputStreamReader(new FileInputStream(tables_file)));
            String s = "";
            do
            {
                String s1 = bufferedreader.readLine();
                if(s1 == null)
                    break;
                tableList.add(s1);
            } while(true);
        }
        catch(Exception exception1)
        {
            log(exception1);
            log("Can't read file " + tables_file);
            log("Program exit!");
            System.exit(1);
        }
        loadDriver();
    }

    private void loadDriver()
    {
        try
        {
            Class.forName(getConfigItem("sourceDriver"));
            log("Registered JDBC driver " + getConfigItem("sourceDriver") + " ok");
            Class.forName(getConfigItem("desDriver"));
            log("Registered JDBC driver " + getConfigItem("desDriver") + " ok");
        }
        catch(Exception exception)
        {
            log(exception);
        }
    }

    public void log(Exception exception)
    {
        log(exception.getMessage());
    }

    public void log(String s)
    {
        System.out.println(getDateString() + ":\t" + s);
    }

    public static void main(String args[])
    {
        DumpData dumpdata1 = new DumpData();
        dumpdata1.init();
        dumpdata1.dumpdata();
    }

    public static String db_cfg_file = "db.cfg";
    public static String tables_file = "table.ini";
    Properties dbProp;
    ArrayList tableList;

}
