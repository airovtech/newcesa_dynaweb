/*============================================================================
 * Copyright(c) 2007 Dntech7
 * 
 * @BusinessType : Common
 * @File : BaseDAO.java
 * @FileName : DAO Super Class
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

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;

public abstract class BaseDAO {

    private static DAOFactory daoFactory = DAOFactory.getInstance();


	/**
	 * Constructor
	 */
    public BaseDAO() {

		super();
	}

    /**
     * DAOFactory���� ���� daoName���� ������ �ν��Ͻ��� ��ȸ�Ѵ�.
	 *
     * @param daoName ��ȸ�� ������ �̸�
	 *
     * @return daoName���� ������ DAO �ν��Ͻ�
     */
    public static BaseDAO lookupInstance(String daoName) {
        return daoFactory.getDAO(daoName);
    }

    /**
     * Connection �� �ݴ´�.
	 *
     * @param con Connection
	 *
     * @return daoName���� ������ DAO �ν��Ͻ�
     */
    protected static void close(Connection con) throws Exception {
		
			if(con != null)	con.close();
	}

    /**
     * PreparedStatement�� �ݴ´�.
	 *
     * @param pstmt PreparedStatement
	 *
     * @return daoName���� ������ DAO �ν��Ͻ�
     */
	protected static void close(PreparedStatement pstmt) throws Exception {
		
			if(pstmt != null)	pstmt.close();
	}

    /**
     * Statement�� �ݴ´�.
	 *
     * @param stmt Statement
	 *
     * @return daoName���� ������ DAO �ν��Ͻ�
     */
	protected static void close(Statement stmt) throws Exception {
		
			if(stmt != null)	stmt.close();
	}

    /**
     * ResultSet�� �ݴ´�.
	 *
     * @param rs ResultSet
	 *
     * @return daoName���� ������ DAO �ν��Ͻ�
     */
	protected static void close(ResultSet rs) throws Exception {
		
			if(rs != null)	rs.close();
	}

    /**
     * Connection, PreparedResultSet�� �ݴ´�.
	 *
     * @param con Connection
	 * @param pstmt PreparedStatement
	 *
     * @return daoName���� ������ DAO �ν��Ͻ�
     */
	protected static void close(Connection con, PreparedStatement pstmt) throws Exception {

		close(con, pstmt, null);
	}

    /**
     * Connection, ResultSet�� �ݴ´�.
	 *
     * @param con Connection
	 * @param stmt Statement
	 *
     * @return daoName���� ������ DAO �ν��Ͻ�
     */
	protected static void close(Connection con, Statement stmt) throws Exception {

		close(con, stmt, null);
	}

    /**
     * Connection, PreparedResultSet, ResultSet�� �ݴ´�.
	 *
     * @param con Connection
	 * @param pstmt PreparedStatement
	 * @param rs ResultSet
	 *
     * @return daoName���� ������ DAO �ν��Ͻ�
     */
	protected static void close(Connection con, PreparedStatement pstmt, ResultSet rs) throws Exception {

		close(con);
		close(pstmt);
		close(rs);
	}

    /**
     * Connection, ResultSet, ResultSet�� �ݴ´�.
	 *
     * @param con Connection
	 * @param stmt Statement
	 * @param rs ResultSet
	 *
     * @return daoName���� ������ DAO �ν��Ͻ�
     */
	protected static void close(Connection con, Statement stmt, ResultSet rs) throws Exception {

		close(con);
		close(stmt);
		close(rs);
	}

    /**
     * ���� Timestamp�� ��ȯ�Ѵ�.
	 *
     * @return Timestamp
     */
	public static java.sql.Timestamp getTimestamp() {

		Calendar cal = Calendar.getInstance();
		java.util.Date date = cal.getTime();

		return new java.sql.Timestamp(date.getTime());
	}

}
