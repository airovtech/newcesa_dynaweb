
/*============================================================================
 * File Name : BaseFactory.java
 * package   : com.adlinker.common
 * Desc      : Properties ������ ���� Ŭ������ �������ִ� Factory
 * Auther    : ����ȣ
 * Date      : 2007-01-02 �����ۼ�
 * Copyright (c) 2007 dnt7.com. All Rights Reserved.
 *
 * ��������
 *
 ============================================================================*/

package com.cesa.base;

import java.lang.reflect.Constructor;
import org.apache.log4j.Logger;


public abstract class BaseFactory {

	protected static final Logger logger = Logger.getLogger(BaseFactory.class);

    /**
     * className�� �ش��ϴ� Ŭ������ �����Ѵ�.
     *
     * @param className Ŭ������ �̸�
     * @return className�� �ش��ϴ� Class ��ü
     */
    protected Class getClass(String className) {

    	if(logger.isDebugEnabled()) {
    		//logger.debug("className="+className);
		}

        Class clazz = null;
        try {
        	clazz = Class.forName(className);
        } catch (ClassNotFoundException e) {
            logger.error("Can't find the class "+className, e);
        }
        return clazz;
    }

    /**
     * className�� �ش��ϴ� ��ü�� �����Ѵ�.<br>
     * className�� ������ ��ü�� default contructor�� ���ǵǾ� �־�� �Ѵ�.
     *
     * @param className Ŭ������ �̸�
     * @return className�� �ش��ϴ� Class ��ü
     */
    protected Object getObject(String className) {

        Class clazz = getClass(className);
        Object instance = null;
        if (clazz != null) {

            try {
                instance=clazz.newInstance();
            } catch (Throwable e) {
                logger.error("Can't create class", e);
            }
        }
        return instance;
    }

    /**
     * className�� �ش��ϴ� ��ü�� �����Ѵ�.<br>
     * �ش� ��ü�� constructor�� parameter�� ���� ��� ����Ѵ�.
     *
     * @param className ��ü�� �̸�
     * @param parameterTypes constructor�� parameter types
     * @param params constructor�� parameter values
     * @return className�� �ش��ϴ� ��ü
     */
    protected Object getObject(String className, Class[] parameterTypes,Object[] params) {

        Class clazz = getClass(className);
        Object instance=null;
        if (clazz!=null) {
            try {
                Constructor constructor = clazz.getConstructor(parameterTypes);
                instance = constructor.newInstance(params);
            } catch (Throwable e) {
                logger.error("Can't create class",e);
            }
        }
        return instance;
    }
}
