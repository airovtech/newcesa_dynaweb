package com.cesa.dao;

import java.sql.SQLException;
import org.apache.log4j.Logger;
import com.cesa.common.*;
import com.cesa.db.*;
import java.util.*;

public class GroupDAO extends BaseDAO {

	Logger log = Logger.getLogger(GroupDAO.class);

	public GroupDAO() {
		super();
	}

	/**
     * GroupDAO instance�� �����Ѵ�.
     *
     * @return GroupDAO
     */
    public static GroupDAO getInstance() {
        return (GroupDAO)lookupInstance(GroupDAO.class.getName());
    }

	/**
	 * �׷� ������ ���
	 *
	 * @param id �����ID
	 */
	public RowSetMapper groupList(int pageSize, int currPage) throws DataAccessException {

    	if( log.isDebugEnabled() ) {
			//log.debug("groupList() Start!");
    	}

		StringBuffer sbufQuery = new StringBuffer();
        try {

			sbufQuery.append(QueryContext.getInstance().get("group.groupList"));

			log.debug("query : "+sbufQuery.toString());

			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString(), pageSize, currPage);

			log.debug(query.toString());

			db.execute(query);

    		if(log.isDebugEnabled()) {
    			//log.debug("groupList() End!");
    		}

    		return db;

		} catch (DBConnectedException dce) {
			throw new DataAccessException(dce.getMessage(), dce);
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		} catch (Exception e) {
			if( log.isDebugEnabled() ) {
				log.debug("Exception : " + e);
			}
			throw new DataAccessException(e.getMessage(), e);
		}
	}
	

	/**
	 * ������ �� ������ ��ȸ�Ѵ�.
	 * @param String seq
	 * @return RowSetMapper
	 */
	public RowSetMapper getGroupDetail(String seq){
		if( log.isDebugEnabled() ) {
			//log.debug("getAdminDetail() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("group.groupDetail"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			db.setString(1, seq);
			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getAdminDetail() End");
			}

			return db;

		} catch (DBConnectedException dce) {
			throw new DataAccessException(dce.getMessage(), dce);
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		} catch (Exception e) {
			if( log.isDebugEnabled() ) {
				log.debug("Exception : " + e);
			}
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	/**
	 * Group  ����Ѵ�.
	 * @param ArrayList params
	 * @return boolean 
	 */
	public boolean regGroup(String groupName){

		boolean check_result = false;
		if( log.isDebugEnabled() ) {
			//log.debug("regGroup() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();
		try {

			sbufQuery.append(QueryContext.getInstance().get("group.regGroup"));

			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			db.setString(1, groupName);


			if(db.executeUpdate(query) == 1){
				check_result = true;
			}

		} catch(Exception e){
			if( log.isDebugEnabled() ) {
				check_result = false;
				log.debug("Exception : " + e);
			}
		}

		return check_result;
	}
	
	/**
	 * �׷� ������ �����Ѵ�.
	 * @param String groupName
	 * @return boolean 
	 */
	public boolean modGroup(String groupName, String seq){
		boolean check_result = false;
		if( log.isDebugEnabled() ) {
			//log.debug("modGroup() Start");
		}
		
		StringBuffer sbufQuery = new StringBuffer();
		try {

			sbufQuery.append(QueryContext.getInstance().get("group.modGroup"));


			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			db.setString(1, groupName);
			db.setString(2, seq);

			if(db.executeUpdate(query) == 1){
				check_result = true;
			}

		} catch(Exception e){
			if( log.isDebugEnabled() ) {
				check_result = false;
				log.debug("Exception : " + e);
			}
		}

		return check_result;
	}

	/**
	 * Group ������ �����Ѵ�.
	 * @param String seq
	 * @return int
	 */
	public boolean delGroup(String seq){
		boolean check_result = false;
		if( log.isDebugEnabled() ) {
			//log.debug("delGroup() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("group.delGroup"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			db.setString(1, "1");
			db.setString(2, seq);

			if(db.executeUpdate(query) == 1){
				check_result = true;
			}
			if( log.isDebugEnabled() ) {
				//log.debug("delGroup() End");
			}

		} catch (Exception e) {
			if( log.isDebugEnabled() ) {
				check_result = false;
				log.debug("Exception : " + e);
			}
		}
		return check_result;
	}
	

}
