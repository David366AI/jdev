/**
 * 此处插入类型描述。
 * 创建日期：(2004-1-1 17:20:07)
 * @author：Administrator
 */
import java.sql.*;
import java.util.*;
import java.io.*;
import java.text.*;

public class DumpData {
    public static String db_cfg_file = "db.cfg";
    public static String tables_file = "table.ini";
    Properties dbProp = new Properties();
    ArrayList tableList = new ArrayList();
    /**
     * DumpData 构造子注解。
     */
    public DumpData() {
        super();
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2004-1-1 17:40:54)
     */
    public void dumpdata() {
        log("begin dump data ...");
        log("source database is " + getConfigItem("sourceURL"));
        log("destination database is " + getConfigItem("desURL"));

        try {
            Connection sourceCon =
                DriverManager.getConnection(
                    getConfigItem("sourceURL"),
                    getConfigItem("sourceDBUser"),
                    getConfigItem("sourceDBPassword"));
            Connection desCon =
                DriverManager.getConnection(
                    getConfigItem("desURL"),
                    getConfigItem("desDBUser"),
                    getConfigItem("desDBPassword"));
            ResultSet sourceRS = null;

            PreparedStatement sourceStmt = null;
            PreparedStatement desStmt = null;

            for (int i = 0; i < tableList.size(); i++) {
                try {
                    String tableName = tableList.get(i).toString();
                    sourceStmt = sourceCon.prepareStatement("select * from " + tableName);
                    sourceRS = sourceStmt.executeQuery();
                    ResultSetMetaData rsmd = sourceRS.getMetaData();
                    int numberOfColumns = rsmd.getColumnCount();
                    String insertString = "insert into " + tableName + "(";
                    for (int j = 1; j <= numberOfColumns; j++) {
                        if (j == numberOfColumns)
                            insertString = insertString + rsmd.getColumnName(j) + ")";
                        else
                            insertString = insertString + rsmd.getColumnName(j) + ",";
                    }
                    insertString = insertString + " values(";
                    for (int j = 1; j <= numberOfColumns; j++) {
                        if (j == numberOfColumns)
                            insertString = insertString + "?)";
                        else
                            insertString = insertString + "?,";
                    }

                    try {
                        PreparedStatement deleteStmt =
                            desCon.prepareStatement("delete  from " + tableName);
                        ;
                        int totalRows = 0;
                        deleteStmt.executeUpdate();
                        deleteStmt.close();
                    } catch (Exception e) {
                        log(e);
                    }
                    int totalRows = 0;
                    int successRows = 0;
                    try {

                        while (sourceRS.next()) {
                            totalRows = totalRows + 1;
                            desStmt = desCon.prepareStatement(insertString);
                            for (int j = 1; j <= numberOfColumns; j++) {
	                            Object o =sourceRS.getObject(j);
                                if (o != null)
                                    desStmt.setObject(j, o);
                                else
                                    desStmt.setNull(j, rsmd.getColumnType(j));
                            }
                            try {
                                desStmt.executeUpdate();
                                successRows = successRows + 1;
                                if (desStmt != null)
                                    desStmt.close();
                            } catch (Exception e) {
                                log(e.getMessage() +"\t error row is : number " + totalRows);

                            }
                        }
                    } catch (Exception e) {
                        log(e);
                    }
                    log("table " + tableName + " has " + totalRows + " rows ");
                    log("table " + tableName + " was dump " + successRows + " rows successfully");

                    if (sourceCon != null)
                        sourceStmt.close();
                } catch (Exception e) {
                    log(e);
                }
            }

            if (sourceCon != null)
                sourceCon.close();
            if (desCon != null)
                desCon.close();
        } catch (Exception e) {
            log(e);
        } finally {

        }

        log("end dump data");
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-12-1 17:11:54)
     */
    public String getConfigItem(String itemName) {
        if (dbProp != null)
            return dbProp.getProperty(itemName);
        else
            return null;
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-12-1 19:34:04)
     * @return java.lang.String
     */
    public String getDateString() {
        SimpleDateFormat bartDateFormat = new SimpleDateFormat("yyyy-MM-dd HHmmss");
        java.util.Date date = new java.util.Date();
        return bartDateFormat.format(date);
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-12-1 17:11:54)
     */
    public void init() {

        try {
            InputStream rsFile = new FileInputStream(db_cfg_file);
            dbProp.load(rsFile);
            rsFile.close();
        } catch (Exception e1) {
            log(e1);
            log("Can't read file " + db_cfg_file);
            log("Program exit!");
            System.exit(1);
        }

        try {
            BufferedReader br =
                new BufferedReader(new InputStreamReader(new FileInputStream((tables_file))));
            String tablename = "";
            while (true) {
                tablename = br.readLine();
                if (tablename == null)
                    break;
                tableList.add(tablename);
            }
        } catch (Exception e1) {
            log(e1);
            log("Can't read file " + tables_file);
            log("Program exit!");
            System.exit(1);
        }

        // init driver
        loadDriver();
    }
    private void loadDriver() {
        try {
            Class.forName(getConfigItem("sourceDriver"));
            log("Registered JDBC driver " + getConfigItem("sourceDriver") + " ok");
            Class.forName(getConfigItem("desDriver"));
            log("Registered JDBC driver " + getConfigItem("desDriver") + " ok");
        } catch (Exception e) {
            log(e);
        }

    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-12-1 17:35:14)
     */
    public void log(Exception e) {
        log(e.getMessage());
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-12-1 17:35:14)
     */
    public void log(String s) {
        System.out.println(getDateString() + ":\t" + s);
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2004-1-1 17:22:42)
     * @param args java.lang.String[]
     */
    public static void main(String[] args) {
        DumpData dumpData = new DumpData();
        dumpData.init();
        dumpData.dumpdata();
    }
}
