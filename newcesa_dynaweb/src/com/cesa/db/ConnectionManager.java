
/*============================================================================
 * File Name : ConnectionManager.java
 * package   : com.adlinker.common.db
 * Desc      : DB Connection Manager
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
import java.util.*;
import javax.sql.rowset.*;
import org.apache.log4j.Logger;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.cesa.common.*;


public class ConnectionManager {


	private static Logger log = Logger.getLogger(ConnectionManager.class);


    private static InitialContext initialContext;
	private static Map cache;

	static {

		try {
			initialContext = new InitialContext();
			cache = Collections.synchronizedMap(new HashMap());
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * Constructor
	 */
	private ConnectionManager() {

	}

	/**
	 * DataSource�� ��ȯ�Ѵ�.
	 *
	 * @return DataSource
	 */
	public static DataSource getDataSource() throws DBConnectedException {
		SiteContext sc = SiteContext.getInstance();

		DataSource dataSource = null;
		try {
			if(cache.containsKey(sc.get("datasource.cesa"))) {
				dataSource = (DataSource) cache.get(sc.get("datasource.cesa"));
			} else {
				dataSource = (DataSource) initialContext.lookup(sc.get("datasource.cesa"));
				cache.put(sc.get("datasource.cesa"), dataSource);
			}
		} catch (NamingException en) {
			en.printStackTrace();
		}

		return dataSource;
	}

	/**
	 * Connection�� ��ȯ�Ѵ�.
	 *
	 * @return Connection
	 */
	public static Connection getConnection() throws DBConnectedException {

		try {
			return getDataSource().getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DBConnectedException(e.getMessage(), e);
		}

	}

	/**
	 * Connection�� �ݴ´�.
	 *
	 * @param con Connection
	 */
	public static void close(Connection con) throws DBConnectedException {
		try {
			if(con != null)	con.close();
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	/**
	 * PreparedStatement�� �ݴ´�.
	 *
	 * @param pstmt PreparedStatement
	 */
	public static void close(PreparedStatement pstmt) throws DBConnectedException {
		try {
			if(pstmt != null)	pstmt.close();
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	/**
	 * Statement�� �ݴ´�.
	 *
	 * @param stmt Statement
	 */
	public static void close(Statement stmt) throws DBConnectedException {
		try {
			if(stmt != null)	stmt.close();
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	/**
	 * ResultSet�� �ݴ´�.
	 *
	 * @param rs ResultSet
	 */
	public static void close(ResultSet rs) throws DBConnectedException {
		try {
			if(rs != null)	rs.close();
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	/**
	 * Connection, PreparedStatement�� �ݴ´�.
	 *
	 * @param con Connection
	 * @param pstmt PreparedStatement
	 */
	public static void close(Connection con, PreparedStatement pstmt) throws DBConnectedException {

		close(con, pstmt, null);
	}

	/**
	 * Connection, Statement�� �ݴ´�.
	 *
	 * @param con Connection
	 * @param stmt Statement
	 */
	public static void close(Connection con, Statement stmt) throws DBConnectedException {

		close(con, stmt, null);
	}

	/**
	 * Connection, PreparedStatement, ResultSet�� �ݴ´�.
	 *
	 * @param con Connection
	 * @param pstmt PreparedStatement
	 * @param rs ResultSet
	 */
	public static void close(Connection con, PreparedStatement pstmt, ResultSet rs) throws DBConnectedException {

		close(con);
		close(pstmt);
		close(rs);
	}

	/**
	 * Connection, Statement, ResultSet�� �ݴ´�.
	 *
	 * @param con Connection
	 * @param stmt Statement
	 * @param rs ResultSet
	 */
	public static void close(Connection con, Statement stmt, ResultSet rs) throws DBConnectedException {

		close(con);
		close(stmt);
		close(rs);
	}

}
