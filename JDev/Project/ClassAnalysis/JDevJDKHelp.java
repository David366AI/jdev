/**
 * 此处插入类型描述。
 * 创建日期：(2003-7-4 12:32:37)
 * @author：Administrator
 */
import java.io.*;
import java.util.*;
import java.net.*;
import java.util.zip.*;
import java.lang.reflect.*;
import com.jdev.common.debug.server.*;

public class JDevJDKHelp
{
    /**
     * JDevClassLoader 构造子注解。
     */
    private final static int FIELD_TYPE = 1;
    private final static int METHOD_TYPE = 2;
    private final static int CONSTRUCTOR_TYPE = 3;
    private   String packClassName = "";
    String srcPath = "";
    Enumeration en;
    static ZipFile zipFile ;
    ArrayList entryList = new ArrayList();
    /**
     * 此处插入方法描述。
     * 创建日期：(2004-1-11 23:55:34)
     * @param srcPath java.lang.String
     */
    public JDevJDKHelp(String srcPath)
    {
        super();
        this.srcPath = srcPath;
        try
        {
            zipFile = new ZipFile(srcPath);
            //ZipFile zipFile = new ZipFile(srcPath);
            en = zipFile.entries();
            while (en.hasMoreElements())
                entryList.add(en.nextElement());
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2004-1-12 12:04:59)
     * @return java.lang.String
     * @param packageName java.lang.String
     */
    public String getClassList(String pn)
    {

        String packageName = pn.replace('.', '/');
        StringBuffer sb = new StringBuffer();
        try
        {
            ArrayList packageList = new ArrayList();
            if (en == null)
                throw new Exception("");

            for (int i = 0; i < entryList.size(); i++)
            {
                String line = entryList.get(i).toString();
                int pos = line.indexOf(".java");
                if (pos >= 0)
                {
                    String pack = line.substring(0, line.lastIndexOf("/"));
                    if (pack.equals(packageName))
                    {
                        String className =
                            line.substring(line.lastIndexOf("/") + 1, line.lastIndexOf(".java"));
                        packageList.add(className);
                    }
                }
            }

            for (int i = 0; i < packageList.size(); i++)
            {
                if (i == 0)
                    sb.append(packageList.get(i).toString());
                else
                    sb.append(";" + packageList.get(i).toString());
            }

        }
        catch (Exception e)
        {
            System.out.println(e);
            return "<command>5</command><result>" + pn + "</result><p></p>";
        }
        return "<command>5</command><result>"
               + pn
               + "</result><p>"
               + sb.toString()
               + "</p>";

    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2004-1-22 18:14:36)
     * @return java.lang.String
     * @param re java.lang.String
     * @param proto java.lang.String
     */
    public String getComment(String des)
    {
        String rs = "";
        String reStr = "";
        String result = "1";

        try
        {
            if (!packClassName.equals(des))
            {
                packClassName = des;
                String className = packClassName.replace('.', '/') + ".java";
                if (zipFile != null)
                {
                    ZipEntry entry = zipFile.getEntry(className);
                    if (entry != null)
                    {
                        BufferedReader br =
                            new BufferedReader(
                                new java.io.InputStreamReader(zipFile.getInputStream(entry)));
                        StringBuffer sb = new StringBuffer();
                        char[] cs = new char[2048];
                        while (true)
                        {
                            int readNumber = br.read(cs, 0, 2048);
                            if (readNumber == -1 )
                                break;
                            sb.append(cs,0,readNumber);
                        }
                        rs = XmlUtil.replace(sb.toString());
                        result = "1";
                    }
                    else
                    {
                        rs = "Can't find file of " + className;
                        result = "0";
                    }
                }
                else
                {
                    rs = "Can't find jdk src zip file.";
                    result = "0";
                }
            }
        }
        catch (Exception e)
        {
            rs = "Unknown error when get src html.";
            result = "0";
            System.out.println(e);
        }
        return "<command>6</command><result>" + result + "</result><p>" + rs + "</p>";
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-12-5 11:42:02)
     * @param args java.lang.String[]
     */
    public String getPackage()
    {

        StringBuffer sb = new StringBuffer();

        try
        {
            ArrayList packageList = new ArrayList();
            if (en == null)
                throw new Exception("");

            for (int j = 0; j < entryList.size(); j++)
            {
                String line = entryList.get(j).toString();
                int pos = line.indexOf(".java");
                if (pos >= 0)
                {
                    line = line.substring(0, line.lastIndexOf("/"));
                    line = line.replace('/', '.');
                    boolean found = false;
                    for (int i = 0; i < packageList.size(); i++)
                    {
                        if (line.equals(packageList.get(i).toString()))
                        {
                            found = true;
                            break;
                        }
                    }
                    if (!found)
                        packageList.add(line);
                }
            }

            sb.append("<command>4</command><result>0</result><p>");
            for (int i = 0; i < packageList.size(); i++)
            {
                if (i == 0)
                    sb.append(packageList.get(i).toString());
                else
                    sb.append(";" + packageList.get(i).toString());
            }
            sb.append("</p>");
        }
        catch (Exception e)
        {
            System.out.println(e);
            return "<command>4</command><result>1</result><p></p>";
        }
        return sb.toString();
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-11-26 1:01:31)
     * @return boolean
     * @param file java.lang.String
     */
    public static boolean isJarZip(String file)
    {
        if (file == null)
            return false;
        if (!(file.toLowerCase().endsWith(".jar"))
                && !(file.toLowerCase().endsWith(".zip")))
            return false;
        else
            return true;
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-12-5 11:42:02)
     * @param args java.lang.String[]
     */
    public static void main(String[] args)
    {
        JDevJDKHelp jdkhelp = new JDevJDKHelp("d:\\jdk142\\src.zip");
        try
        {
            //jdkhelp.getComment(
            //    "java.lang.String|public String\\(byte [a-zA-Z\\-_\\$]+\\[\\], int [a-zA-Z\\-_\\$]+, int [a-zA-Z\\-_\\$]+, String [a-zA-Z\\-_\\$]+\\)|public String(byte[], int, int, String)");
            //ZipFile zipFile = new ZipFile("d:\\jdk142\\src.zip");
            //jdkhelp.getClassList("java.io");
            ZipEntry entry = zipFile.getEntry("java/lang/String.java");
            BufferedReader br= new BufferedReader(new java.io.InputStreamReader(zipFile.getInputStream(entry)));
            while (true)
            {
                String line = br.readLine() ;
                if (line==null)
                    break;
                System.out.println(line);
            }
            //System.out.println(entry.);
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }
}
