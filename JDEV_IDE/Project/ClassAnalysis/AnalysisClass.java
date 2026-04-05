/**
 * 此处插入类型描述。
 * 创建日期：(2003-5-24 0:04:13)
 * @author：Administrator
 */
import java.io.*;
import java.util.*;
import java.net.*;
import java.lang.reflect.*;
public class AnalysisClass
{
    private static String paramCn = "";
    private static String className = "";
    private static String inWhichClass = "";
    private static String packageName ="";
    private static String needParseStr  = "";
    private static String[] importList = null;
    private static boolean isArray = false;
    private static boolean isStatic = false;
    private static boolean isSuper = false;
    private static Class c = null;
    private static TreeMap map = new TreeMap();
    private static int port = 7900;
    private static String srcPath = "";
    private static JDevJDKHelp jdevHelp ;
    private static java.io.PrintStream serverOutStream = null;
    private static java.io.BufferedReader serverReader = null;
    private static java.net.Socket analysisSocket = null;
    private static final String CONFIGFILENAME = "jdev.ini";
    private boolean parseAllSuccess = false;
    /**
     * AnanysisClass 构造子注解。
     */
    public AnalysisClass()
    {
        super();
        getCFG();

    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-7-11 0:34:41)
     */
    public void doAnalysis()
    {
        parseAllSuccess = false;
        if (isWholeClassName(needParseStr))
        {
            try
            {
                c = Class.forName(needParseStr);
                parseAllSuccess = true;
                return;
            }
            catch (Exception e)
            {
                parseAllSuccess = false;
            }
        }
        Object o = null;

        if (className.equals("null"))
        {
            className = needParseStr.substring(0, needParseStr.indexOf(".") );
        }

        if ((className.equals("this")) || (className.equals("super")))
        {
            try
            {
                if (className.equals("super"))
                    isSuper = true;
                else
                    isSuper = false;
                className = inWhichClass;
                if (packageName.equals(""))
                    c = Class.forName(className);
                else
                    c = Class.forName(packageName + "." + className);
                return;
            }
            catch (Exception e)
            {
                c = null;
                return;
            }
        }

        if (needParseStr.indexOf("[") != -1) //if name is array
        {
            if (className.indexOf("[") == -1) //但是原类型不是数组，什么都不做
            {
                c = null;
                return;
            } else //原类型是数组
            {
                isArray = false;
                className = className.substring(0,className.indexOf("["));
            }
        } else
        {
            if (className.indexOf("[") >= 0)
            {
                isArray = true;
                className = "java.lang.Object";
            }
            else
                isArray = false;
        }

        try
        {
            c = Class.forName(packageName + "." + className);
            return;
        }
        catch (Exception e)
        {
            c = null;
            //if (!owner.packageName.equals(""))
            try
            {
                c = Class.forName(className);
                return;
            }
            catch (Exception e1)
            {
                c = null;
                if ((importList != null) && (importList.length >= 1))
                    for (int i = 0; i < importList.length; i++)
                    {
                        if (importList[i].indexOf("*") > 0)
                        {
                            String s = replaceStarSymbol(importList[i], className);
                            try
                            {
                                c = Class.forName(s);
                                return;
                            }
                            catch (Exception e2)
                            {
                                c = null;
                            }

                        }
                    }
            }
        }

    }
    public void doAnotherAnalysis(ArrayList functionList, Class paramC)
    {
        if ((functionList.size() <= 0) || (c == null))
        {
            c = paramC;
            return;
        }
        boolean found = false;
        String name = functionList.get(0).toString();
        String mf = "";
        if (name.indexOf("(") >= 0) //如果是函数
        {
            String methodName = (name.substring(0, name.indexOf("("))).trim();
            Method[] ms = paramC.getMethods();
            for (int j = 0; j < ms.length; j++)
            {
                if (ms[j].getName().equals(methodName))
                {
                    paramC = ms[j].getReturnType();
                    mf = paramC.getName();
                    break;
                }
            }
        } else //如果是属性
        {
            String fieldName = name.trim();
            if (name.indexOf("[") != -1) //if name is array
                fieldName = name.substring(0, name.indexOf("[") );
            Field[] fs = paramC.getFields();
            for (int j = 0; j < fs.length; j++)
            {
                if (fs[j].getName().equals(fieldName))
                {
                    paramC = fs[j].getType();
                    mf = paramC.getName();
                    break;
                }
            }
        }


        if (name.indexOf("[") != -1) //if name is array
        {
            if (mf.indexOf("[") == -1) //但是原类型不是数组，什么都不做
            {
                c = null;
                return;
            } else //原类型是数组
            {
                paramC = getProtoClass(paramC);
                if (paramC == null)
                {
                    c = null;
                    return;
                }
                else
                {
                    found = true;
                }
            }
        } else
        {
            if (mf.indexOf("[") >= 0)
                isArray = true;
            else
                isArray = false;
            found = true;
        }

        if (found)
        {
            functionList.remove(0);
            doAnotherAnalysis(functionList, paramC);
        }
        else
        {
            c = null;
            return;
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 0:34:54)
     */
    public void doPrint()
    {

        if (c!=null)
        {
            System.out.println("className:"+c.getName());
            getFieldList(c,inWhichClass,packageName);
            String rs = getSendBackString();

            map.clear();
            getMethodList(c,inWhichClass,packageName);
            if ( isArray )
                map.put("length","protected");
            rs = rs + getSendBackString();
            doSend("<command>0</command><result>1</result>"+rs);
        }
        else
            doSend("<command>10</command><result>"+paramCn+"</result>");
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-7-11 1:12:08)
     */
    public static  void doSend(String s)
    {
        if (serverOutStream!=null )
        {
            serverOutStream.print("<package>"+s+"</package>");
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-7-11 0:35:26)
     * @param line java.lang.String
     */
    public void executeCommand(String line)
    {
        parsePackage(line);

        map.clear();
        doAnalysis();
        if (!isWholeClassName(needParseStr))
            doPrint();
        else
        {
            if (parseAllSuccess)
                doPrint();
            else if (c!=null)
            {
                isStatic = false;
                StringTokenizer st = new StringTokenizer(needParseStr,".");
                if ( st.countTokens() <= 1 )
                    return;
                ArrayList functionList = new ArrayList();
                int i = 0;
                st.nextToken();
                while (st.hasMoreTokens())
                    functionList.add(st.nextToken());
                doAnotherAnalysis(functionList,c);
                if (c!=null)
                {
                    inWhichClass = "";
                    packageName  = "";
                    doPrint();
                }
            }
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getAnotherFieldList(Class cname,String pname)
    {
        if ( cname  == null )
            return;
        String p ;
        String cn =cname.getName();
        int pos = cn.lastIndexOf(".");
        if ( pos > 0)
        {
            p = cn.substring(0,pos);
        }
        else
        {
            p = "";
        }

        if  ( p.equals(pname))
        {
            Field[] fs = cname.getDeclaredFields();
            for (int i=0 ; i<fs.length;i++)
            {
                if ( (isStatic) && (Modifier.toString(fs[i].getModifiers()).indexOf("static") < 0 ) )
                    continue;
                if ( Modifier.toString(fs[i].getModifiers()).indexOf("private") < 0)
                    if (!map.containsKey(getFieldString(fs[i])))
                        map.put(getFieldString(fs[i]),Modifier.toString(fs[i].getModifiers()));
            }
            if ( cname.getSuperclass() != null )
                getAnotherFieldList(cname.getSuperclass(),pname);
        }
        else
        {
            Field[] fs = cname.getDeclaredFields();
            for (int i=0 ; i<fs.length;i++)
            {
                if ( (isStatic) && (Modifier.toString(fs[i].getModifiers()).indexOf("static") < 0 ) )
                    continue;
                if ( Modifier.toString(fs[i].getModifiers()).indexOf("public") >=0 )
                    if (!map.containsKey(getFieldString(fs[i])))
                        map.put(getFieldString(fs[i]),Modifier.toString(fs[i].getModifiers()));
            }
            if ( cname.getSuperclass() != null )
                getAnotherFieldList(cname.getSuperclass(),pname);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getAnotherMethodList( Class cname,String pname)
    {
        if ( cname  == null )
            return;
        String p ;
        String cn =cname.getName();
        int pos = cn.lastIndexOf(".");
        if ( pos > 0)
        {
            p = cn.substring(0,pos);
        }
        else
        {
            p = "";
        }

        if  ( p.equals(pname))
        {
            Method[] ms = cname.getDeclaredMethods();
            for (int i=0 ; i<ms.length;i++)
            {
                if ( (isStatic) && (Modifier.toString(ms[i].getModifiers()).indexOf("static") < 0 ) )
                    continue;
                if ( Modifier.toString(ms[i].getModifiers()).indexOf("private") < 0)
                    if ( !map.containsKey(getMethodString(ms[i])) )
                        map.put(getMethodString(ms[i]),Modifier.toString(ms[i].getModifiers()));
            }
            if ( cname.getSuperclass() != null )
                getAnotherMethodList(cname.getSuperclass(),pname);
        }
        else
        {
            Method[] ms = cname.getDeclaredMethods();
            for (int i=0 ; i<ms.length;i++)
            {
                if ( (isStatic) && (Modifier.toString(ms[i].getModifiers()).indexOf("static") < 0 ) )
                    continue;
                if ( Modifier.toString(ms[i].getModifiers()).indexOf("public") >=0 )
                    if ( !map.containsKey(getMethodString(ms[i])) )
                        map.put(getMethodString(ms[i]),Modifier.toString(ms[i].getModifiers()));
            }
            if ( cname.getSuperclass() != null )
                getAnotherMethodList(cname.getSuperclass(),pname);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2002-9-20 10:35:16)
     * @return java.util.Properties
     * @param param java.lang.String
     */
    private void getCFG()
    {
        String line="";
        try
        {
            BufferedReader  br = new BufferedReader (new FileReader("..\\"+CONFIGFILENAME));
            while ( true )
            {
                line = br.readLine();
                if ( line == null )
                    break;
                int pos = line.indexOf("analysis_server_port=");
                if ( pos >=0 )
                {
                    port = Integer.parseInt(line.substring("analysis_server_port=".length()).trim());
                }
                pos = line.indexOf("jdk_srczip_path=");
                if ( pos >=0 )
                {
                    srcPath = line.substring("jdk_srczip_path=".length()).trim();
                }
            }
        }
        catch (Exception e)
        {
            System.out.println(e);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-6-26 18:03:47)
     * @param cn java.lang.String
     */
    public static boolean getClassList(String cn)
    {
        Class innerc;
        StringTokenizer st = new StringTokenizer(cn,";");
        String classname = "";

        if ( st.countTokens() >= 1)
        {
            classname = st.nextToken();
        }
        else
            return false;

        try
        {
            innerc = Class.forName(classname);
            while (true)
            {
                Class s = innerc.getSuperclass();
                if ( s == null )
                    break;
                //String ss = s.getName();

                if (s.getName().equals("java.applet.Applet")  )
                    return true;
                innerc = s;
            }
        }
        catch (Exception e)
        {
            System.out.println(e);
            //doSend("<command>10</command><result>"+cn+"</result>");
        }
        return false;
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 13:42:07)
     * @return java.lang.String
     * @param m java.lang.reflect.Method
     */
    public static String getConstructorString(String cn,Constructor ic)
    {
        String s = "";
        if ( ic == null)
            return s;
        for (int j = ic.getParameterTypes().length - 1; j >= 0; j--)
            s = getTypeProto(ic.getParameterTypes()[j]) + (s.equals("") ? s : ", " + s);
        return cn + "(" + s + ")\t";
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-7-1 20:50:29)
     * @param cs java.lang.String
     */
    public static void getDeclarations(String cs)
    {
        StringBuffer rs= new StringBuffer();
        int pos = cs.lastIndexOf('.');
        String csname = cs.substring(pos+1,cs.length());
        try
        {
            Class ic = Class.forName(cs);
            if ( ic !=null)
            {
                Constructor[] cslist = ic.getDeclaredConstructors();
                rs.append( "<cs name=\"cons\">");
                for (int i=0;i<cslist.length;i++)
                {
                    if ( Modifier.toString(cslist[i].getModifiers()).indexOf("public") >= 0 )
                        rs.append("<l>"+ getConstructorString(csname,cslist[i]) + Modifier.toString(cslist[i].getModifiers()) + "</l>");
                }
                rs.append("</cs>");
                Field[] fs = ic.getDeclaredFields();
                rs.append("<fs name=\"fs\">");
                for (int i=0;i<fs.length;i++)
                {
                    if (Modifier.toString(fs[i].getModifiers()).indexOf("public")  >= 0 )
                        rs.append("<l>" +getFieldString(fs[i])  + "\t" + Modifier.toString(fs[i].getModifiers()) + "</l>");
                }
                rs.append("</fs>");
                Method[] ms = ic.getDeclaredMethods();
                rs.append("<ms name=\"ms\">");
                for (int i=0;i<ms.length;i++)
                {
                    if (Modifier.toString(ms[i].getModifiers()).indexOf("public")  >= 0 )
                        rs.append("<l>"  + getMethodString(ms[i])  + "\t" +Modifier.toString(ms[i].getModifiers()) + "</l>");
                }
                rs.append("</ms>");

                doSend("<command>2</command><result>"+cs+"</result>"+rs.toString());
            }
        }
        catch(Exception e)
        {
            System.out.println(e);
            doSend("<command>10</command><result>"+cs+"</result>");
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getFieldList(Class cname, String inClass, String pname)
    {
        if ( cname  == null )
            return;
        String p ;
        String cn =cname.getName();
        int pos = cn.lastIndexOf(".");
        if ( pos > 0)
        {
            p = cn.substring(0,pos);
            cn = cn.substring(pos+1);
        }
        else
        {
            p = "";
        }

        if  ( p.equals(pname))
        {
            if ( inClass.equals(cn))
                getThisFieldList(cname,pname);
            else
                getAnotherFieldList(cname,pname);
        }
        else
        {
            getAnotherFieldList(cname,pname);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 13:42:07)
     * @return java.lang.String
     * @param m java.lang.reflect.Method
     */
    public static String getFieldString(Field f)
    {
        String s = "";
        if (f == null)
            return "";
        else
            return f.getName()+ "\t" + getTypeProto(f.getType());
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2004-1-12 0:03:59)
     * @return JDevJDKHelp
     */

    public static JDevJDKHelp getJDKHelp()
    {
        if (  jdevHelp == null  )
        {
            jdevHelp = new JDevJDKHelp(srcPath);
        }
        if ( jdevHelp.zipFile == null )
        {
            jdevHelp = new JDevJDKHelp(srcPath);
        }
        return jdevHelp;
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getMethodList( Class cname, String inClass, String pname)
    {
        if ( cname  == null )
            return;
        String p ;
        //String.valueOf(1).valueOf(true).
        //p.substring(1).substring(1).substring(0);
        //System.out.getClass().getClass().getClass()
        String cn =cname.getName();
        int pos = cn.lastIndexOf(".");
        if ( pos > 0)
        {
            p = cn.substring(0,pos);
            cn = cn.substring(pos+1);
        }
        else
        {
            p = "";
        }

        if  ( p.equals(pname))
        {
            if ( inClass.equals(cn))
                getThisMethodList(cname,pname);
            else
                getAnotherMethodList(cname,pname);
        }
        else
        {
            getAnotherMethodList(cname,pname);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getMethodList(TreeMap map, Class cname, String inClass, String pname)
    {
        if ( cname  == null )
            return;
        String p ;
        String cn =cname.getName();
        int pos = cn.lastIndexOf(".");
        if ( pos > 0)
        {
            p = cn.substring(0,pos);
            cn = cn.substring(pos+1);
        }
        else
        {
            p = "";
        }

        if  ( p.equals(pname))
        {
            if ( inClass.equals(cn))
                getThisMethodList(cname,pname);
            else
                getAnotherMethodList(cname,pname);
        }
        else
        {
            getAnotherMethodList(cname,pname);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 13:42:07)
     * @return java.lang.String
     * @param m java.lang.reflect.Method
     */
    public static String getMethodString(Method m)
    {
        String s = "";
        if ( m == null)
            return s;
        for (int j = m.getParameterTypes().length - 1; j >= 0; j--)
            s =getTypeProto( m.getParameterTypes()[j]) + (s.equals("") ? s : ", " + s);
        return m.getName() + "(" + s + ")\t" + getTypeProto(m.getReturnType());
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2004-2-3 17:06:20)
     * @return java.lang.Class
     * @param ct java.lang.Class
     */
    public static Class getProtoClass(Class ct)
    {
        Class innerc = ct;
        if (ct.isArray())
        {
            String ss = ct.getName();
            int i = 0;
            while (ss.charAt(i) == '[')
            {
                i++;
                innerc = innerc.getComponentType();
                if (i >= ss.length())
                    break;
            }
            if (innerc.isPrimitive() )
                return null;
        }
        else
            return null;

        return innerc;
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-7-11 1:12:08)
     */
    public String getSendBackString()
    {
        String s = "";
        Iterator t = map.keySet().iterator();
        while (t.hasNext())
        {
            Object o = t.next();
            s = s + "<l><n>"+o+"</n><m>"+map.get(o)+"</m></l>";
        }
        return s;
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getThisFieldList(Class cname, String pname)
    {
        if (cname == null)
            return;
        if (!isSuper)
        {
            Field[] fs = cname.getDeclaredFields();
            for (int i = 0; i < fs.length; i++)
            {
                if ((isStatic)
                        && (Modifier.toString(fs[i].getModifiers()).indexOf("static") < 0))
                    continue;

                map.put(getFieldString(fs[i]), Modifier.toString(fs[i].getModifiers()));
            }
        }
        getThisSubFieldList(cname.getSuperclass(), pname);

    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getThisMethodList(Class cname, String pname)
    {
        if (cname == null)
            return;
        if (!isSuper)
        {
            Method[] ms = cname.getDeclaredMethods();
            for (int i = 0; i < ms.length; i++)
            {
                if ((isStatic)
                        && (Modifier.toString(ms[i].getModifiers()).indexOf("static") < 0))
                    continue;
                map.put(getMethodString(ms[i]), Modifier.toString(ms[i].getModifiers()));
            }
        }
        getThisSubMethodList(cname.getSuperclass(), pname);

    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getThisSubFieldList(
        Class cname,
        String pname)
    {
        if ( cname  == null )
            return;
        String p ;
        String cn =cname.getName();
        int pos = cn.lastIndexOf(".");
        if ( pos > 0)
        {
            p = cn.substring(0,pos);
        }
        else
        {
            p = "";
        }

        if  ( p.equals(pname))
        {
            Field[] fs = cname.getDeclaredFields();
            for (int i=0 ; i< fs.length;i++)
            {
                if ( (isStatic) && (Modifier.toString(fs[i].getModifiers()).indexOf("static") < 0 ) )
                    continue;
                if ( Modifier.toString(fs[i].getModifiers()).indexOf("private") < 0)
                    if (!map.containsKey(getFieldString(fs[i])))
                        map.put(getFieldString(fs[i]),Modifier.toString(fs[i].getModifiers()));
            }
            if ( cname.getSuperclass() != null )
                getThisSubFieldList(cname.getSuperclass(),pname);
        }
        else
        {
            Field[] fs = cname.getDeclaredFields();
            for (int i=0 ; i< fs.length;i++)
            {
                if ( (isStatic) && (Modifier.toString(fs[i].getModifiers()).indexOf("static") < 0 ) )
                    continue;
                if ( ( Modifier.toString(fs[i].getModifiers()).indexOf("public") >=0 ) || (( Modifier.toString(fs[i].getModifiers()).indexOf("protected") >=0 )) )
                    if (!map.containsKey(getFieldString(fs[i])))
                        map.put(getFieldString(fs[i]),Modifier.toString(fs[i].getModifiers()));
            }
            if ( cname.getSuperclass() != null )
                getThisSubFieldList(cname.getSuperclass(),pname);
        }


    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getThisSubMethodList(
        Class cname,
        String pname)
    {
        if ( cname  == null )
            return;
        String p ;
        String cn =cname.getName();
        int pos = cn.lastIndexOf(".");
        if ( pos > 0)
        {
            p = cn.substring(0,pos);
        }
        else
        {
            p = "";
        }

        if  ( p.equals(pname))
        {
            Method[] ms = cname.getDeclaredMethods();
            for (int i=0 ; i<ms.length;i++)
            {
                if ( (isStatic) && (Modifier.toString(ms[i].getModifiers()).indexOf("static") < 0 ) )
                    continue;
                if ( Modifier.toString(ms[i].getModifiers()).indexOf("private") < 0)
                    if (!map.containsKey(getMethodString(ms[i])))
                        map.put(getMethodString(ms[i]),Modifier.toString(ms[i].getModifiers()));
            }
            if ( cname.getSuperclass() != null )
                getThisSubMethodList(cname.getSuperclass(),pname);
        }
        else
        {
            Method[] ms = cname.getDeclaredMethods();
            for (int i=0 ; i<ms.length;i++)
            {
                if ( (isStatic) && (Modifier.toString(ms[i].getModifiers()).indexOf("static") < 0 ) )
                    continue;

                if ( ( Modifier.toString(ms[i].getModifiers()).indexOf("public") >=0 ) || (( Modifier.toString(ms[i].getModifiers()).indexOf("protected") >=0 )) )
                    if (!map.containsKey(getMethodString(ms[i])))
                        map.put(getMethodString(ms[i]),Modifier.toString(ms[i].getModifiers()));
            }
            if ( cname.getSuperclass() != null )
                getThisSubMethodList(cname.getSuperclass(),pname);
        }


    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-7-2 12:46:08)
     * @return java.lang.String
     * @param ct java.lang.Class
     */
    public static String getTypeProto(Class ct)
    {
        Class innerc = ct;
        String rs = "";
        String s = "";
        if (ct.isArray())
        {
            String ss = ct.getName();
            int i = 0;
            while (ss.charAt(i) == '[')
            {
                i++;
                s = s + "[]";
                innerc = innerc.getComponentType();
                if (i >= ss.length())
                    break;
            }
            try
            {
                if (innerc.isPrimitive())
                {
                    if ( innerc.isAssignableFrom(Boolean.TYPE) )
                        s = "boolean" + s ;
                    if ( innerc.isAssignableFrom(Byte.TYPE) )
                        s = "byte" + s ;
                    if ( innerc.isAssignableFrom(Double.TYPE) )
                        s = "double" + s ;
                    if ( innerc.isAssignableFrom(Character.TYPE) )
                        s = "char" + s ;
                    if ( innerc.isAssignableFrom(Float.TYPE) )
                        s = "float" + s ;
                    if ( innerc.isAssignableFrom(Integer.TYPE) )
                        s = "int" + s ;
                    if ( innerc.isAssignableFrom(Long.TYPE) )
                        s = "long" + s ;
                    if ( innerc.isAssignableFrom(Short.TYPE) )
                        s = "short" + s ;
                }
                else
                    s = ss.substring(i + 1, ss.length() - 1) + s;
                rs =  s;
            }
            catch (Exception e)
            {
                System.out.println(e);
                rs =  ct.getName();
            }
        }
        else
            rs = ct.getName();
        if (rs.lastIndexOf(".") >= 0)
        {
            return rs.substring(rs.lastIndexOf(".")+1);
        }
        else
            return rs;
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 0:17:27)
     * @return boolean
     * @param name java.lang.String
     */
    public static boolean isWholeClassName(String name)
    {
        if ( ( name == null ) || (name.trim().equals("")) )
            return false;
        if ( ( name.indexOf(".") > 0 ) &&  ( name.indexOf(".") < name.length()-1 ) )
            return true;
        else
            return false;
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 0:05:26)
     * @param args java.lang.String[]
     */
    public static void main(String[] args)
    {
        AnalysisClass ac = new AnalysisClass();
        try
        {

            analysisSocket = new java.net.Socket("localhost", port);
            serverReader =
                new java.io.BufferedReader(
                    new java.io.InputStreamReader(analysisSocket.getInputStream()));

            serverOutStream = new java.io.PrintStream(analysisSocket.getOutputStream());
            String commandLine = null;
            while (true)
            {
                //注意，此时readLine阻塞，等待从调试中心读取一行数据
                commandLine = serverReader.readLine();
                if ((commandLine != null) && (commandLine.length() > 0))
                {

                    //解析数据,执行命令,
                    try
                    {
                        if (commandLine.equalsIgnoreCase("exit"))
                            break;
                        else if (commandLine.substring(0, 2).equals("!!"))
                        {   //测试是否是applet的子类
                            if (getClassList(commandLine.substring(2)))
                                ac.doSend("<command>1</command><result>1</result>");					  //command:1
                            else
                                ac.doSend("<command>1</command><result>0</result>");
                        }
                        else if (commandLine.substring(0, 2).equals("%%"))   //获取包列表       //command:4
                        {
                            ac.doSend(getJDKHelp().getPackage());

                        } else if (commandLine.substring(0, 2).equals("$$"))   //获取包列表       //command:6
                        {
                            ac.doSend(getJDKHelp().getComment(commandLine.substring(2)));

                        } else if (commandLine.substring(0, 2).equals("##"))   //获取包中的类和接口       //command:5
                        {
                            ac.doSend(getJDKHelp().getClassList(commandLine.substring(2)));

                        }else if (commandLine.substring(0, 2).equals("@@"))   //解析类
                        {
                            CheckClassGrammer.checkFile(commandLine.substring(2));						 //command:3
                        }else if (commandLine.substring(0, 2).equals("||"))
                        {  //获取类的声明属性和方法  //command:2
                            getDeclarations(commandLine.substring(2));
                        }
                        else
                            ac.executeCommand(commandLine);											 //command:0
                    }
                    catch (Exception e)
                    {																 //command:10
                    }

                } //end if
            } //end whild

        }
        catch (Exception e)
        {
            System.out.println(e);
        }
        finally
        {
            try
            {
                if (analysisSocket != null )
                    analysisSocket.close();
            }
            catch (Exception e )
            {
                System.out.println(e);
            }
        }

    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2002-9-25 11:08:11)
     * @return java.lang.String[]
     * @param inputStr java.lang.String
     */
    public String[] parseBigKuoHao(String inputStr)
    {
        String[] result = null;
        StringTokenizer params = new StringTokenizer(inputStr,"{}");
        result = new String[params.countTokens()];
        int paramCount = 0;
        while (params.hasMoreTokens())
        {
            result[paramCount] = params.nextToken();
            paramCount++;
        }
        return result;
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2002-9-25 11:08:11)
     * @return java.lang.String[]
     * @param inputStr java.lang.String
     */
    public String[] parseImports(String inputStr)
    {
        String[] result = null;
        StringTokenizer params = new StringTokenizer(inputStr,"<>");
        result = new String[params.countTokens()];

        int paramCount = 0;
        while (params.hasMoreTokens())
        {
            result[paramCount] = params.nextToken();
            paramCount++;
        }
        return result;
    }
    /**
     * 本方法解析从调试控制台发送过来的包的内容，
     * 将其分解为command,pid,content,其中content为命令列表，包的格式为{className}{inWhichClass}{packageName}{needParseStr}{isStatic}{<><>...}
     * 创建日期：(2002-9-24 16:09:47)
     */
    public void parsePackage(String pack)
    {
        String[] rs = parseBigKuoHao(pack);
        className = rs[0].trim();
        paramCn = className;
        inWhichClass = rs[1].trim();
        packageName = rs[2].trim();
        needParseStr = rs[3].trim();

        if (packageName.equals("null"))
            packageName="";
        isStatic = Integer.parseInt(rs[4].trim()) == 0 ? false:true;


        if (!(rs[5] == null) && (!rs[5].trim().equals("")))
        {
            importList = parseImports(rs[5].trim());
        }
        else
        {
            importList = new String[1];
            importList[0] = "java.lang.*";
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 0:47:24)
     * @param pack java.lang.String
     */
    public static String replaceStarSymbol(String pack,String cname)
    {
        int i=pack.length();
        String s = pack.substring(0,i-1);
        return s+cname;
    }
}

