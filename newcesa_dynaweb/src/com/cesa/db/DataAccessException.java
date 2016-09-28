
/*============================================================================
 * File Name : DataAccessException.java
 * package   : com.adlinker.common.db
 * Desc      : Data Access ���� Exception
 * Auther    : ��ȿ��
 * Date      : 2007/11/23 �����ۼ�
 * Copyright (c) 2007 dnt7.com. All Rights Reserved.
 *
 * ��������
 *
 ============================================================================*/

package com.cesa.db;

import java.io.*;
import java.sql.*;
import org.apache.log4j.Logger;


public class DataAccessException extends RuntimeException {

    /**
     * Constructor
     */
	public DataAccessException() {

		super();
	}

    /**
     * Constructor
	 *
	 * @param message �޼���
     */
	public DataAccessException(String message) {

		super(message);
	}

    /**
     * Constructor
	 *
	 * @param cause Throwable
     */
	public DataAccessException(Throwable cause) {

		super(cause);
	}

    /**
     * Constructor
	 *
	 * @param message �޼���
	 * @param cause Throwable
     */
	public DataAccessException(String message, Throwable cause) {

		super(message, cause);
	}

}
