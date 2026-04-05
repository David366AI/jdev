package com.jdev.common.debug.server;

/**
 * 此处插入类型描述。
 * 创建日期：(2002-9-28 10:26:29)
 * @author：Administrator
 */
import java.util.*;
import java.io.*;
import org.w3c.dom.*;
import org.xml.sax.*;
import org.xml.sax.helpers.ParserFactory;
import org.jdom.output.XMLOutputter;
import com.tsd.test.*;
public class XmlUtil {
/**
 * XmlUtil 构造子注解。
 */
public XmlUtil() {
	super();

}
/**
 * 此处插入方法描述。
 * 创建日期：(2002-10-17 17:02:01)
 * @param args java.lang.String[]
 */
public static void main(String[] args) {
	String[][] array_s = {{"1","2","3"},{"11","22","33"},{"111","222","333"}};
    XMLOutputter out = new XMLOutputter(" ", true);
    String strOut = out.outputString("asljfdaslfd,.<>&\n\r&lt");
    System.out.println(strOut);  
	
//	XmlUtil.generatePackage(12,12,"",null);
}
/**
 * 此处插入方法描述。
 * 创建日期：(2002-9-28 14:48:22)
 * @return java.lang.String
 * @param s java.lang.String
 */
public static String replace(String s) {
	  /*String chStr = replace(s,"&","&amp;");
	  chStr = replace(chStr,"<","&lt;");
	  chStr = replace(chStr,">","&gt;");
	  return chStr;
	  //return s;*/
    XMLOutputter out = new XMLOutputter(" ", true,"GBK");
    return out.outputString(s.replace('\u0000','.'));	  
}
public static String replace(String strSource, String strFrom, String strTo)
{
    if(strFrom == null || strFrom.equals(""))
        return strSource;
    String strDest = "";
    int intFromLen = strFrom.length();
    int intPos;

    while((intPos = strSource.indexOf(strFrom)) != -1)
    {
        strDest = strDest + strSource.substring(0,intPos);
        strDest = strDest + strTo;
        strSource = strSource.substring(intPos + intFromLen);
    }
    strDest = strDest + strSource;

    return strDest;
}
}
