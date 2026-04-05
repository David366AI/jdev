/**
 * 此处插入类型描述。
 * 创建日期：(2003-5-24 0:04:13)
 * @author：Administrator
 */
import java.util.*;
import java.lang.reflect.* ;
public class AnanysisClass
{
    private String className = "";
    private String inWhichClass = "";
    private String packageName = "";
    private String[] importList = null;
    private static boolean isStatic = false;
    private Class c = null;
    /**
     * AnanysisClass 构造子注解。
     */
    public AnanysisClass()
    {
        super();
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 0:34:54)
     */
    public void doPrint(Class resultC)
    {
        if (resultC!=null)
        {
            System.out.println("className:"+resultC.getName());
            TreeMap map = new TreeMap();
            getFieldList(map,resultC,inWhichClass,packageName);
            Iterator t = map.keySet().iterator();
            while( t.hasNext())
            {
                Object o  = t.next();
                System.out.println( o +"\t"+ map.get(o));
            }
            map = new TreeMap();
            getMethodList(map,resultC,inWhichClass,packageName);
            t = map.keySet().iterator();
            while( t.hasNext())
            {
                Object o  = t.next();
                System.out.println( o +"\t"+ map.get(o));
            }

        }
        else
            System.out.println("Can not ananysis the class");
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getAnotherFieldList(TreeMap map, Class cname,String pname)
    {
        if ( cname  == null )
            return;
        String p ;
        String cn =cname.getName();
        int pos = cn.lastIndexOf(".");
        if ( pos > 0)
        {
            p = cn.substring(10).;
        }
        else
        {
            p = ""
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
                getAnotherFieldList(map,cname.getSuperclass(),pname);
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
                getAnotherFieldList(map,cname.getSuperclass(),pname);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getAnotherMethodList(TreeMap map, Class cname,String pname)
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
                getAnotherMethodList(map,cname.getSuperclass(),pname);
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
                getAnotherMethodList(map,cname.getSuperclass(),pname);
        }
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getFieldList(TreeMap map, Class cname, String inClass, String pname)
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
                getThisFieldList(map,cname,pname);
            else
                getAnotherFieldList(map,cname,pname);
        }
        else
        {
            getAnotherFieldList(map,cname,pname);
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
            return f.getName()+ "\t" +f.getType().getName();
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
                getThisMethodList(map,cname,pname);
            else
                getAnotherMethodList(map,cname,pname);
        }
        else
        {
            getAnotherMethodList(map,cname,pname);
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
        for (int j = m.getParameterTypes().length - 1; j >= 0; j--)
            s = m.getParameterTypes()[j].getName() + (s.equals("") ? s : "," + s);
        return m.getName() + "(" + s + ")\t" + m.getReturnType().getName();
    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getThisFieldList(
        TreeMap map,
        Class cname,
        String pname)
    {
        if (cname == null)
            return;
        Field[] fs = cname.getDeclaredFields();
        for (int i = 0; i < fs.length; i++)
        {
            if ( (isStatic) && (Modifier.toString(fs[i].getModifiers()).indexOf("static") < 0 ) )
                continue;

            map.put(getFieldString(fs[i]),Modifier.toString(fs[i].getModifiers()));
        }
        getThisSubFieldList(map,cname.getSuperclass(),pname);

    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getThisMethodList(
        TreeMap map,
        Class cname,
        String pname)
    {
        if (cname == null)
            return;
        Method[] ms = cname.getDeclaredMethods();
        for (int i = 0; i < ms.length; i++)
        {
            if ( (isStatic) && (Modifier.toString(ms[i].getModifiers()).indexOf("static") < 0 ) )
                continue;
            map.put(getMethodString(ms[i]),Modifier.toString(ms[i].getModifiers()));
        }
        getThisSubMethodList(map,cname.getSuperclass(),pname);

    }
    /**
     * 此处插入方法描述。
     * 创建日期：(2003-5-24 1:10:51)
     * @param list java.util.Hashtable
     * @param cname java.lang.String
     * @param pname java.lang.String
     */
    public static void getThisSubFieldList(
        TreeMap map,
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
                getThisSubFieldList(map,cname.getSuperclass(),pname);
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
                getThisSubFieldList(map,cname.getSuperclass(),pname);
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
        TreeMap map,
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
                getThisSubMethodList(map,cname.getSuperclass(),pname);
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
                getThisSubMethodList(map,cname.getSuperclass(),pname);
        }


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
        System.setProperty("java.class.path","c:\\cp;"+System.getProperty("java.class.path").toString());
        System.out.println(System.getProperty("java.class.path"));
        AnanysisClass owner = new AnanysisClass();
        if (args.length < 4)
        {
            System.out.println(
                "Usage:java AnanysisClass className inWhichClass PackageName isStatic <import list>");
            System.exit(0);
        }
        owner.className = args[0];
        if ((args[0] == null) || (args[0].trim().equals("")))
            return;
        owner.inWhichClass = args [1] ;

        if (args[2].equalsIgnoreCase("null"))
            owner.packageName = "";
        else
            owner.packageName = args[2];

        owner.isStatic = !(args[3].equals("0"));
        if (args.length - 4 > 0)
        {
            owner.importList = new String[args.length - 3];
            owner.importList[0] = "java.lang.*";
            for (int i = 0; i < args.length - 4; i++)
            {
                owner.importList[i+1] = args[i + 4];
            }
        }
        else
            owner.importList = new String[1];
        owner.importList[0] = "java.lang.*";


        if (isWholeClassName(owner.className))
        {
            try
            {
                owner.c = Class.forName(owner.className);
                owner.doPrint(owner.c);
            }
            catch (Exception e)
            {
                owner.c = null;
            }
        }
        else
        {
            if (owner.className.equals("this"))
            {
                try
                {
                    owner.className = owner.inWhichClass;
                    owner.c = Class.forName(owner.packageName+"."+owner.className);
                    owner.doPrint(owner.c);
                    return ;
                }
                catch(Exception e)
                {
                    owner.c = null;
                    return;
                }
            }

            try
            {
                owner.c = Class.forName(owner.className);
                owner.doPrint(owner.c);
            }
            catch (Exception e)
            {
                owner.c = null;
                //if (!owner.packageName.equals(""))
                try
                {
                    owner.c = Class.forName(owner.packageName + "." + owner.className);
                    owner.doPrint(owner.c);
                }
                catch (Exception e1)
                {
                    owner.c = null;
                    if ((owner.importList != null) && (owner.importList.length >= 1))
                        for (int i = 0; i < owner.importList.length; i++)
                        {
                            if (owner.importList[i].indexOf("*") > 0)
                            {
                                String s = replaceStarSymbol(owner.importList[i], owner.className);
                                try
                                {
                                    owner.c = Class.forName(s);
                                    owner.doPrint(owner.c);
                                    break;
                                }
                                catch (Exception e2)
                                {
                                    owner.c = null;
                                }

                            }
                        }
                }
            }

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



