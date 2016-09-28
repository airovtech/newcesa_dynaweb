package com.cesa.util;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.configuration.reloading.FileChangedReloadingStrategy;


/**
 * PropertiesManager class
 * Commons Configuration �� PropertiesConfiguration �� Ȯ���Ѵ�.
 * <br/>
 * 
 * delimiter �� �⺻������ ';' �� �����ȴ�. 
 * ���, ������Ƽ ������ ���� ��, ';' �� ����� �� ������,
 * �ݵ�� ����Ϸ��� '\;' �� ���� �̽������� ó���ϸ� ��밡���ϴ�.
 * 
 * @version	1.0
 * @author	moon jong deok, 2008-10-22
 */
public class PropertiesManager extends PropertiesConfiguration {

	private char delimiter = ';';
	
	public PropertiesManager() {
		setEncoding("UTF-8");
		setDelimiter( delimiter );
	}
	
	/**
	 * ������ �о� ���δ�. �����ݷ��� �⺻ delimiter �̴�.
	 * 
	 * @param filename
	 * @throws ConfigurationException
	 */
	public PropertiesManager( String filename )
		throws ConfigurationException
	{
		super( filename );
		setEncoding("UTF-8");
		setDelimiter( delimiter );
		setReloadingStrategy( new FileChangedReloadingStrategy() );
	}
}
