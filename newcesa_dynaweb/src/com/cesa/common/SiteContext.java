package com.cesa.common;

import java.util.Iterator;

import org.apache.log4j.Logger;

import com.cesa.base.TObject;
import com.cesa.util.PropertiesManager;

/**
 * ��ü �ý��� ���� ȯ�溯������ ������ �ִ� Ŭ����<br>
 * <br>
 * 
 * InitServlet ���� SiteContext �� �����Ѵ�. web.xml �� ����� ��ó��
 * init-file �̶�� �Ķ���ͷ� ���ǵ� ������ �о� ���δ�.<br>
 * <br>
 * 
 * web.xml �� ������ ����.<br>
 * 
 * <pre>
 * ...
 * &lt;servlet&gt;
 * &lt;servlet-name&gt;AFFL2 Init&lt;/servlet-name&gt;
 * &lt;servlet-class&gt;com.hyundai.affl.InitServlet&lt;/servlet-class&gt;
 *
 * &lt;init-param&gt;
 *   &lt;param-name&gt;init-file&lt;/param-name&gt;
 *   &lt;param-value&gt;/WEB-INF/conf/hyundai.properties&lt;/param-value&gt;
 * &lt;/init-param&gt;
 * 
 * &lt;load-on-startup&gt;1&lt;/load-on-startup&gt;
 * &lt;/servlet&gt;
 * ...
 * </pre>
 * 
 * �� �ν��Ͻ� �Ǵ� �� ���ؽ�Ʈ�� �ε��Ǹ鼭 web.xml �� �����ϰ�,
 * ���⿡ ����� ��ó�� com.hyundai.affl.InitServlet �� ȣ���ϰ�,
 * �Ķ���ͷ� init-file �� ���� �����ͼ� �ش� ������ �ε��ϰ� �ȴ�.
 * ���������� /WEB-INF/conf/hyundai.properties ������ �а� �ȴ�.
 * ������Ƽ(hyudau.properties) ������ commons-configuration ���� ���� �ϴ� ������Ƽ ������ 
 * ������ ��Ű�� �ȴ�.<br>
 * <br>
 * 
 * �Ϲ������� SiteContext �� ������ ����, ������ ���� ������� ����Ѵ�.<br>
 * <pre>
 * ...
 * import com.hyundai.affl.common.SiteContext;
 * ...
 * SiteContext sc = SiteContext.getInstance();
 * ...
 * </pre>
 * �Ϲ����� �̱��� ��ü�� �����ٰ� ���� ��İ� ���� �ٸ��� �ʴ�.
 * �ٸ�, �Լ� getInstance(filename) �� ��뿡�� ���ǰ� �ʿ��ϴ�.<br>
 * <pre>
 * <b>//�� �Լ��� �ݵ�� ���� Ŭ���� ������ �ѹ��� ����ؾ� �Ѵ�.</b> 
 * SiteContext sc = SiteContext.getIntance( filename );
 * </pre>
 * 
 * �̴� commons-configuration �� Ư¡ �������� ��ü�� �����ϸ鼭
 * ������ �������� ������, ��� ���Ͽ� ������ �־ �ν����� ���ϴ� ��������
 * �ذ��Ϸ��� ���� �Լ��̱� �����̴�.
 * ����, �ݵ�� �ּ� �����ÿ��� ����ϵ��� �Ѵ�.<br>
 *  <br>
 * 
 * @version 1.0
 * @author moon jong deok, 2008-10-22
 */
public class SiteContext extends TObject{
	
    private static Logger log = Logger.getLogger(SiteContext.class);
    
    /**
     * �̱���. SiteContext
     */
    private static SiteContext siteContext = null;
    
    /**
     * ������Ƽ�� ��� �ִ� ����.
     */
    PropertiesManager prop = null; 
    
    /**
     * �̱������� �����ϵ��� �Ѵ�.
     * @return
     */
    public static synchronized SiteContext getInstance() {
        if ( siteContext == null ) {
            siteContext = new SiteContext();
        }

        return siteContext;
    }
    
    /**
     * �̱������� �����ϸ鼭, �����̸��� �����ϵ��� �� ��, ����Ѵ�.<br>
     * <br>
     * 
     * ��κ��� ����� SiteContext.getInstance() �� ���� ������� ��������,
     * commons-configuration �� Ư������ ������ ��, ������ ���� ������,
     * ��Ÿ�ӿ��� ������ ���������� �ݿ����� �ʴ� ���� ����Ͽ�, ���� �����ÿ���
     * ����ϴ� ������ getInstance() �Լ��� �������.<br>
     * <br>
     * 
     * ����, �Ϲ����� ��뿡���� ����ϸ� �ȵǸ�, com.hyundai.affl.InitServlet �� ����
     * �ʱ�ȭ ���� Ŭ���� �� ���������� �� �ѹ� ȣ��ǵ��� ���α׷��� �ؾ� �Ѵ�.
     * @param filename
     * @return SiteContext ��ü
     */
    public static synchronized SiteContext getInstance( String filename ) {
        if ( siteContext == null ) {
            siteContext = new SiteContext( filename );
        }

        return siteContext;
    }
    
    /**
     * InitConfig ���Ͽ� ������ ������Ƽ ������ �о�´�.
     * �̱������� ���� ������ �� ����.
     */
    private SiteContext( ) {
    	super();
   		prop = new PropertiesManager();
    }
    
    /**
     * getInstance(filename) �Լ����� ����ϴ� ������ ������.<br>
     * commons-configuration �� Ư�� ��, �����ÿ� ������ �����ؾ� ������,
     * �̸� �����ϱ� ���� ���� �̸��� �޴� ������ �����ڸ� �������. 
     * @param filename
     */
    private SiteContext( String filename ) {
    	super();
    	try {
    		prop = new PropertiesManager( filename );
    	} catch ( Exception e ) {
    		log.fatal( e );
    	}
    }
    
    /**
     * ���ο� ���Ϸ� �����Ѵ�.<br>
     * ������ �ε�� ������, ���� ���Ͽ� ������ ���� ��, �ڵ����� �ε���� �ʴ´�.
     * ����, �� �ʿ��� ��츸 ����ϵ��� �ϸ�, ��� �ÿ� ����� �׽�Ʈ�� �ʿ��ϴ�.
     * @param path
     */
    public synchronized void set( String path ) {
        try { 
			prop.load( path );
		} catch ( Exception e ) {
		    log.debug( e );
		}  
		
    }
    
    /**
     * key �� �ش��ϴ� ��Ʈ�� ���� �����Ѵ�.
     * @param key
     * @return
     */
    public String		get( String key )				{ return prop.getString(key);	}
    
    /**
     * key �� �ش��ϴ� ���� ���� �����Ѵ�.
     * @param key
     * @return
     */
    public int			getInt( String key )			{ return prop.getInt(key);		}
    
    /** 
     * key �� �ش��ϴ� float ���� �����Ѵ�.
     * @param key
     * @return
     */
    public float		getFloat( String key )		{ return prop.getFloat(key);		}
    
    /**
     * key �� �ش��ϴ� double ���� �����Ѵ�.
     * @param key
     * @return
     */
    public double	getDouble( String key )	{ return prop.getDouble(key);	}

	public void set(String key, String value){
		prop.setProperty(key, value);
		/*
		try{
			prop.save();
		}
		catch(Exception e) {
			log.fatal(e, e);
		}
		*/
	}
    
    /**
     * PropertiesManager ���� �����Ѵ�.
     * @return
     */
    public PropertiesManager getProperties() { return prop; }
    
    /**
     * ���� SiteContext �� ���� ��Ʈ������ ��ȯ�Ѵ�.
     * �ַ� ����� ������ ���ȴ�.
     */
    public String toString(){
    	StringBuffer sb = new StringBuffer();
    	
    	Object obj = null;
    	Iterator en = prop.getKeys();
        while ( en.hasNext()  ) {
            obj = en.next();
            sb.append( obj + "=" +prop.getString((String)obj) + "\n");
        }
        
        return sb.toString();
    }
    
    /**
     * �� �󿡼� �׽�Ʈ�� SiteContext �� ���� Ȯ���� ��, ����Ѵ�.
     * toString() ���� �ϸ�, �� �ٷ� �پ� ���� ������ �� ���� ����. ^^;
     * @return String HTML 
     */
    public String toHtml(){
    	StringBuffer sb = new StringBuffer();
    	
    	Object obj = null;
    	Iterator en = prop.getKeys();
        while ( en.hasNext()  ) {
            obj = en.next();
            sb.append( obj + "=" +prop.getString((String)obj) +"<br>\n" );
        }
        
        return sb.toString();
    }
}
