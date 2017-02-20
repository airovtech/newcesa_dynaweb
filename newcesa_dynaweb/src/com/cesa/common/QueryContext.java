package com.cesa.common;

import java.util.Iterator;
import org.apache.log4j.Logger;
import com.cesa.util.XMLConfiguration;

/**
 * QueryContext class
 * SqlMapConfig�� ���ǵ� SQL���� �о� ����Ѵ�.
 *
 * @version	1.0
 * @author	moon jong deok, 2008-10-22
 */
public class QueryContext {
	
	private static Logger logger = Logger.getLogger(QueryContext.class);
	
	/**
	 * �̱���. ������Ƽ ������ ��� �ִ�.
	 */
    private static QueryContext queryContext = null;
	
    /**
     * XML Configuration ������ ��� �ִ�.
     */
	public static XMLConfiguration config;
	
	/**
     * �̱������� �����ϵ��� �Ѵ�.
     * @return
     */
    public static synchronized QueryContext getInstance() {
    	System.out.println("queryContext=" + queryContext);
        if ( queryContext == null ) {
        	queryContext = new QueryContext();
        }
        
        return queryContext;
    }
	
    /**
     * ���������� �ε� �Ѵ�.
     *
     */
	private QueryContext () {
		System.out.println("QueryContext called = " + config);
		if(config==null){
			String basePath = SiteContext.getInstance().get("query.path");
			String cofigFilePath = SiteContext.getInstance().get("query.config");
			
			System.out.println("basePath=" + basePath);
			System.out.println("cofigFilePath=" + cofigFilePath);
			config = new XMLConfiguration();
			config.setBasePath(basePath);
			config.setConfigFilePath(cofigFilePath);
			config.load();
						
			System.out.println("config=" + config.toString());
			Iterator ks = config.getKeys();
			logger.debug("------------------- Print Key --------------------------");
			while(ks.hasNext()){
				String s = String.valueOf(ks.next());
				logger.debug("qid=["+s+"]");
				logger.debug("\r" + config.getString(s));
			}
			logger.debug("--------------------------------------------------------");
		}
	}
	
	/**
	 * ���Ǳ׸� ���ε� �Ѵ�.
	 *
	 */
	public synchronized void reloadConfig(){
		config = null;
		queryContext = new QueryContext();
	}
	
	/**
	 * Query
	 * @param key
	 * @return
	 */
	public String get(String key){
		return config.getString(key);
	}
}
