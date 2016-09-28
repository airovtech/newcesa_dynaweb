/*============================================================================
 * Copyright(c) 2007 Dntech7
 * 
 * @BusinessType : Common
 * @File : QueryManager.java
 * @FileName : Query Handling 
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

import java.io.*;
import java.sql.*;
import com.cesa.common.*;
import javax.servlet.http.*;


public class QueryManager {

	private String sql;
	private Object[] parameters;
 
	private boolean bPage;


	// ������ �ڷ��� ���� ��ü ������������..
	private int maxPageSize;
	private int maxRowSize;

	// ���������� ����� �ڷ��Ǽ�
	private int pageSize;

	// ���° �������� ����Ұ�����;
	private int currPage;

    /**
     * Constructor
	 *
	 * @param sql ����
     */
	public QueryManager(String sql) {

		setQueryManager(sql, -1, -1);
	}

    /**
     * Constructor
	 *
	 * @param sql ����
	 * @param pageSize ���������� ���Ե� ����
	 * @param currPage ���� ������
     */
	public QueryManager(String sql, int pageSize, int currPage) {

		setQueryManager(sql, pageSize, currPage);
	}

    /**
     * Constructor
	 *
	 * @param sql ����
	 * @param pageSize ���������� ���Ե� ����
	 * @param request HttpServletRequest
     */
	public QueryManager(String sql, int pageSize, HttpServletRequest request) {

		setQueryManager(sql, pageSize, this.getCurrentPage(request));
	}

    /**
     * ���� �������� ��ȯ
	 *
	 * @param request HttpServletRequest
	 * @return int
     */
	private int getCurrentPage(HttpServletRequest request) {
		return request.getParameter("currentPage")	==	null ? 1 : Integer.parseInt(request.getParameter("currentPage"));
	}

    /**
     * ������ �����Ѵ�.
	 *
	 * @param sql ����
     */
	public void setQueryManager(String sql) {

		setQueryManager(sql, -1, -1);
	}

    /**
     * ������ �����Ѵ�.
	 *
	 * @param sql ����
	 * @param pageSize ���������� ���Ե� ����
	 * @param request HttpServletRequest
     */
	public void setQueryManager(String sql, int pageSize, HttpServletRequest request) {

		setQueryManager(sql, pageSize, this.getCurrentPage(request));
	}

    /**
     * ������ �����Ѵ�.
	 *
	 * @param sql ����
	 * @param pageSize ���������� ���Ե� ����
	 * @param currPage ���� ������
     */
	public void setQueryManager(String sql, int pageSize, int currPage) {

		init();

		this.pageSize = pageSize;
		this.currPage = currPage;
		if(pageSize > 0) {
			this.bPage = true;
		}

		this.sql = sql;

		this.parameters = null;
	}

    /**
     * ������ �ʱ�ȭ�Ѵ�.
     */
	public void init() {

		this.sql = "";
		this.parameters = null;

		this.bPage = false;

		this.maxPageSize = -1;
		this.maxRowSize = 0;
		// ���������� ����� �ڷ��Ǽ�
		this.pageSize = -1;

		// ���° �������� ����Ұ�����;
		this.currPage = -1;
	}

    /**
     * ���� ������ ��ȯ�Ѵ�.
	 *
	 * @return int
     */
	public int getParameterSize() {
		return this.parameters == null ? 0 : this.parameters.length;
	}

    /**
     * ���ڸ� ��ȯ�Ѵ�.
	 *
	 * @param idx ���� ��ȣ
	 * @return Object
     */
	public Object getParameter(int idx) throws Exception {

		if(idx >= this.getParameterSize())
			throw new Exception("INDEX���� �Ķ������ �������� ŭ�ϴ�.");

		return this.parameters[idx];
	}

    /**
     * ���ڸ� �����Ѵ�.
	 *
	 * @param obj ���� ����Ʈ
     */
	public void setParameters(Object[] obj) {
		this.parameters = obj;
	}

    /**
     * ������ ��ȯ�Ѵ�.
	 *
	 * @return String
     */
	public String getSql() {
		return this.sql;
	}

    /**
     * ������ ����Ѵ�.
	 *
	 * @return String
     */
	public String print() {

		String sqlStr = sql;
		StringBuffer buf = new StringBuffer();
		Object oVec = null;

		try {
		
			for(int i, seq = 0; (i = sqlStr.indexOf("?")) >= 0; seq++) {
				buf.append(sqlStr.substring(0, i));
				oVec = getParameter(seq);
				if(oVec instanceof String)
					buf.append("'"+oVec.toString()+"'");
				else
					buf.append(oVec.toString());
				sqlStr = sqlStr.substring(i + "?".length());
			}
			buf.append(sqlStr);

			return buf.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}


    /**
     * String ��ü�� �����.
	 *
	 * @return String
     */
	public String toString() {

		try {
			StringBuffer strBuff = new StringBuffer();

			strBuff.append("QueryManager SQL : ").append(this.sql).append("\n");

			if(parameters != null) {
				strBuff.append("QueryManager Parameters : [");
				for(int i = 0; i < parameters.length; i++) {
					strBuff.append(parameters[i].toString()).append(", ");
				}
				return strBuff.toString().substring(0, strBuff.toString().lastIndexOf(",")) + "]\n";
			} else
				return strBuff.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

    /**
     * page Ÿ������ ��ȯ�Ѵ�.
	 *
	 * @return boolean
     */
	public boolean isPage() {
		return bPage;
	}

	/**
	 * currPage�� �����մϴ�.
	 *
	 * @return int
	 */
	public int getCurrPage() {
		return currPage;
	}

	/**
	 * ������������ �����Ѵ�.
	 * 
	 * @param currPage �����Ϸ��� currPage�Դϴ�.
	 */
	public void setCurrPage(int currPage) {
		this.currPage = currPage;
	}

	/**
	 * @return pageSize�� �����մϴ�.
	 */
	public int getPageSize() {
		return pageSize;
	}

	/**
	 * @param pageSize �����Ϸ��� pageSize�Դϴ�.
	 */
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	/**
	 * @param sql �����Ϸ��� sql�Դϴ�.
	 */
	public void setSql(String sql) {
		this.sql = sql;
	}

	/**
	 * @return maxPageSize�� �����մϴ�.
	 */
	public int getMaxPageSize() {
		return maxPageSize;
	}

	/**
	 * @param maxPageSize �����Ϸ��� maxPageSize�Դϴ�.
	 */
	public void setMaxPageSize(int maxPageSize) {
		this.maxPageSize = maxPageSize;
	}

	/**
	 * @return maxRowSize�� �����մϴ�.
	 */
	public int getMaxRowSize() {
		return maxRowSize;
	}

	/**
	 * @param maxRowSize �����Ϸ��� maxRowSize�Դϴ�.
	 */
	public void setMaxRowSize(int maxRowSize) {
		this.maxRowSize = maxRowSize;
	}

	/**
	 * ������ ������ ��ȯ�Ѵ�.
	 *
	 * @return String
	 */
	public String getPageQuery() {

		if(this.getSql().equals("")) return "";

		/*
		return new StringBuffer()
							.append("select * from ")
							.append("		(select sub_query.*, ceil(rownum/").append(this.getPageSize()).append(") page from ")
							.append("			( ").append(this.getSql()).append("			) sub_query ")
							.append("		) ")
							.append("where page = ").append(this.getCurrPage())
						.toString();
		*/
		String newQuery = new StringBuffer()
							.append(this.getSql())
							.append(" limit "+((this.getCurrPage()-1) * this.getPageSize()))
							.append(" , "+this.getPageSize())
						.toString();

		//System.out.println(newQuery);

		return newQuery;
	}

	/**
	 * split ������ ��ȯ�Ѵ�.
	 *
	 * @return String
	 */
	public String getQuerySplitFrom() {

		int selectIdx = 0;
		int fromIdx = 0;
		int idx = 0;
		int pos = 0;
		String orgString = this.getSql().trim();					// ���� ���ڿ�
		String tmpString = this.getSql().toLowerCase().trim();	// �ҹ��ڷ� ��ȯ�� ���ڿ�

		if(tmpString.equals("")) return "";

		while(idx < tmpString.length()) {
			selectIdx = tmpString.indexOf("select");
			fromIdx = tmpString.indexOf("from");
			if(selectIdx < fromIdx) {
				pos++;
				if(selectIdx == -1)
					idx = fromIdx + 4;
				else idx = selectIdx + 6;
			} else {
				pos--;
				idx = fromIdx + 4;
			}

			tmpString = tmpString.substring(idx);
			orgString = orgString.substring(idx);

			if(selectIdx == -1) {
				fromIdx = tmpString.indexOf("from");
				if(fromIdx > 0)
				{
					tmpString = tmpString.substring(fromIdx+4);
					orgString = orgString.substring(fromIdx+4);
				}
				break;
			}

			if(pos == 0) {
				break;
			}
		}
		tmpString = "from" + tmpString;
		orgString = "from" + orgString;

		int wherePos = tmpString.lastIndexOf("where ");
		if(wherePos==-1)		// ���� ��� where + tab ���� ã�´�.
			wherePos = tmpString.lastIndexOf("where	");

		String tmpWhere = "";
		if(wherePos!=-1)
			tmpWhere = tmpString.substring(wherePos);


		if(tmpWhere.indexOf("order ") > 0)
			return orgString.substring(0, tmpString.indexOf("order "));
//			return tmpString.substring(0, tmpString.indexOf("order "));
		else
			return orgString;
//			return tmpString;

	}
}
