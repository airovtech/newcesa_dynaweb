
/*============================================================================
 * File Name : DBConnectedException.java
 * package   : com.adlinker.common.db
 * Desc      : Query Handling 
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
import com.cesa.common.*;



public class DBConnectedException extends RuntimeException {

    /**
     * Constructor
     */
	public DBConnectedException() {

		super();
	}

    /**
     * Constructor
     *
     * @param message �޼���
     */
	public DBConnectedException(String message) {

		super(message);
	}

    /**
     * Constructor
     *
     * @param cause Throwable
     */
	public DBConnectedException(Throwable cause) {

		super(cause);
	}

    /**
     * Constructor
     *
	 * @param message �޼���
     * @param cause Throwable
     */
	public DBConnectedException(String message, Throwable cause) {

		super(message, cause);
	}

}
