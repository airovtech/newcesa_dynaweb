package com.cesa.common;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

/**
 * �� �ν��Ͻ��� ���۵� ��, ����Ǵ� �ʱ�ȭ ����<br>
 * <br>
 * 
 * InitServlet �� �����ϰ� �ִ� web.xml �� ����,<br>
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
 * ���⼭ ���� ��ó�� init-file �� �����ؾ� �Ѵ�. ������ �������� �ʰų�,
 * ���� �� ���� ������ ���, ����Ʈ �������� ������ �߻� �� �� ��������,
 * �ݵ�� Ȯ���ϱ� �ٶ���.<br>
 * <br>
 * 
 * init-file �� ������ ������Ƽ ������ �ε��Ͽ�, <b>query.config</b> ���� �о,
 * QueryContext �� �ε��ϵ��� �Ǿ� �ִ�. ����, QueryContext �� �����ϴ� ������ �ٲٰų�,
 * key ���� �ٲٷ���, �Ʒ��� QueryContext�� query.config �κ��� �����ؾ� �Ѵ�.<br>
 * <br>
 * 
 * ����� "query.config" ��� ���� ����ϵ��� �Ǿ� ������, init-file �� ������ ���Ͽ���
 * �ݵ�� query.config Ű���� �����̸��� �����Ǿ� �־�� �Ѵ�.
 * �׷��� ������, ������ ������ �� ����.<br>
 * <br>
 * 
 * @version	1.0
 * @author	woo jin ho, 2008-10-22
 *
 */
public class InitServlet extends HttpServlet {
	
	
	Logger log = Logger.getLogger(InitServlet.class);
    
    public void init() {
    	
    	String prefix = getServletContext().getRealPath("/");
        String file = getInitParameter("init-file");
       
        String path = prefix + file;
        
        //-------------------------------------------------------------------
    	// log4j �α� ����
        // log4j.properties �� ������ ���� �ʰ�, �ϳ��� ������Ƽ ���Ͽ��� ó���ϵ��� �ߴ�.
        //-------------------------------------------------------------------
    	PropertyConfigurator.configure( path );
    	
    	log.info("InitServlet Start!");
    	log.info("prefix : " + prefix);
    	log.info("path : " + path);

        //-------------------------------------------------------------------
    	// Application Configration Loading
        //-------------------------------------------------------------------
	
    	log.info("--------------------------------------------------------------");
    	log.info("Application Config Loading...");
    	log.info( path );
    	log.info("SiteContext Loading...");
    	SiteContext sc = SiteContext.getInstance( path );
    	log.info(sc.toString());

        //-------------------------------------------------------------------
    	// query.properties �� �ش��ϴ� ���� �о QueryContext �� �����Ѵ�.
    	// �ٸ� Ű���� ����Ϸ���, �� �κ��� �����ϵ��� �Ѵ�.
        //-------------------------------------------------------------------
    	log.info("QueryContext Loading...");
    	log.info( prefix );
    	QueryContext qc = QueryContext.getInstance();
    	log.debug( qc.toString() );


    	log.info("--------------------------------------------------------------");
    }
    
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    	throws ServletException, IOException {
    	super.doGet(req, res);
    }
}
