/*============================================================================
 * Copyright(c) 2007 Dntech7
 * 
 * @BusinessType : Common
 * @File : DAOFactory.java
 * @FileName : DAO�� ������ �ش�. ��� DAO�� DAOFactory�� ���� �����ؾ� �Ѵ�.
 *
 * Note:
 *
 * Change history
 * @LastModifyDate : 20070309
 * @LastModifier   : Dntech7
 * @LastVersion    : 1.0
 *   2007-03-09 Dntech7
 *      1.0    ���ʻ��� 
 ============================================================================*/
package com.cesa.db;
import com.cesa.common.*;
import com.cesa.base.*;

public class DAOFactory extends BaseFactory {

    final static DAOFactory instance =  getDAOFactory();

    public DAOFactory() {

		super();
	}

    /**
     * DAOFactory �ν��Ͻ��� ��ȯ�Ѵ�.
	 *
     * @return DAOFactory
     */
    public static DAOFactory getInstance() {
        return instance;
    }

    /**
     * key�� �ش��ϴ� DAO�� instance�� ��ȸ�Ѵ�.
     *
     * @param key ��ü�� key
     * @return DAO�� instance
     */
	public BaseDAO getDAO(String key) {
		return (BaseDAO)getObject(key);
    }

    /**
     * DAOFactory�� ��ȯ�Ѵ�.
     *
     * @return DAOFactory
     */
    private static DAOFactory getDAOFactory() {

    	return new DAOFactory();
    }
}
