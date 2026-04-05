package	p3 ;

/**
 * 此处插入类型描述。
 * 创建日期：(2002-7-24 13:49:29)
 * @author：Administrator
 */
public class GenerateSerials {
/**
 * GenerateSerials 构造子注解。
 */
public GenerateSerials() {
	super();
}
/**
 * 此处插入方法描述。
 * 创建日期：(2002-7-24 13:50:19)
 * @return java.lang.String
 */
public synchronized static String getUploadFileID() {
	String x = Long.toString(new java.util.Date().getTime());	
	return x;
}
}
