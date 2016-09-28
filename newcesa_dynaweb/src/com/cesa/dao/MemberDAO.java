package com.cesa.dao;

import java.sql.SQLException;
import org.apache.log4j.Logger;
import com.cesa.common.*;
import com.cesa.db.*;
import java.util.*;

public class MemberDAO extends BaseDAO {

	Logger log = Logger.getLogger(MemberDAO.class);

	public MemberDAO() {
		super();
	}

	/**
     * MemberDAO instance�� ���Ѵ�.
     *
     * @return MemberDAO
     */
    public static MemberDAO getInstance() {
        return (MemberDAO)lookupInstance(MemberDAO.class.getName());
    }

	/**
	*
	* Ư�� ������ ��й�ȣ�� ��ġ�ϴ��� Ȯ���Ѵ�.
	*
	* @param memberId, memberPasswd, projectSeq
	* @return String 
	*/
	public String isMember(String memberId , String memberPasswd, String projectSeq) {

		String check_result = "";

		if( log.isDebugEnabled() ) {
			//log.debug("isMember() Start");
		}
		
		StringBuffer sbufQuery = new StringBuffer();
		try{
			sbufQuery.append(QueryContext.getInstance().get("member.memberCheck"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			db.setString(1, memberId);
			db.setString(2, projectSeq);

			db.execute(query);

			if( !db.next()) {
				// �ش� ������ ����. ���
				if(regMember(projectSeq, memberId, memberPasswd)){
					check_result = "success";
				}
				else{
					check_result = "fail";
				}
			}
			else {
				if(memberPasswd.equals(db.getString("password"))){
					// �ش� ������ ��й�ȣ�� ��ġ�ϹǷ�,  ������ �α��� �Ͻ� ������Ʈ �Ѵ�.
					check_result = "success";
					//setMemberLoginUpdate(db.getString("seq"));
				}
				else {
					// �ش� ������ ��й�ȣ�� ����ġ ��.
					check_result = "fail";
				}
			}

		} catch(Exception e){
			if( log.isDebugEnabled() ) {
				log.debug("Exception : " + e);
			}
		}
		

		return check_result;
	}
	/**
	*
	* Ư�� ������ ��й�ȣ�� ��ġ�ϴ��� Ȯ���Ѵ�.
	*
	* @param memberId, memberPasswd, projectSeq
	* @return String 
	*/
	public String isMember_coffee(String memberId , String memberPasswd, String projectSeq) {

		String check_result = "";

		if( log.isDebugEnabled() ) {
			//log.debug("isMember() Start");
		}
		
		StringBuffer sbufQuery = new StringBuffer();
		try{
			sbufQuery.append(QueryContext.getInstance().get("member.memberCheck_Coffee"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			db.setString(1, memberId);
			db.setString(2, projectSeq);

			db.execute(query);

			if( !db.next()) {
				// �ش� ������ ����. ���
				if(regMember_coffee(projectSeq, memberId, memberPasswd)){
					check_result = "success";
				}
				else{
					check_result = "fail";
				}
			}
			else {
				if(memberPasswd.equals(db.getString("password"))){
					// �ش� ������ ��й�ȣ�� ��ġ�ϹǷ�,  ������ �α��� �Ͻ� ������Ʈ �Ѵ�.
					check_result = "success";
					//setMemberLoginUpdate(db.getString("seq"));
				}
				else {
					// �ش� ������ ��й�ȣ�� ����ġ ��.
					check_result = "fail";
				}
			}

		} catch(Exception e){
			if( log.isDebugEnabled() ) {
				log.debug("Exception : " + e);
			}
		}
		

		return check_result;
	}
	/**
	* ������ ������ �α��� �ð��� ������Ʈ�Ѵ�.
	*
	* @param adminid
	*
	*/
	public void setMemberLoginUpdate(String seq){
		if( log.isDebugEnabled() ) {
			//log.debug("setMemberLoginUpdate() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();
		try {
			sbufQuery.append(QueryContext.getInstance().get("member.updateMemberLogin"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			db.setString(1, seq);

			db.executeUpdate(query);

		} catch(Exception e){
			if( log.isDebugEnabled() ) {
				log.debug("Exception : " + e);
			}
		}
	}
	
	/**
	 * ���� �� ������ ��ȸ�Ѵ�.
	 * @param String seq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberCheckSeq(String seq){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberDetail() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberCheckSeq"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			db.setString(1, seq);
			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberDetail() End");
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
	 * ���� �� ������ ��ȸ�Ѵ�.
	 * @param String seq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberDetail(String seq){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberDetail() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberDetail"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			db.setString(1, seq);
			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberDetail() End");
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
	 * ���� �� ������ ��ȸ�Ѵ�.
	 * @param String memberId, String memberPasswd, String projectSeq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberDetail(String memberId, String memberPasswd, String projectSeq){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberDetail() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberDetail2"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			db.setString(1, memberId);
			db.setString(2, memberPasswd);
			db.setString(3, projectSeq);

			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberDetail() End");
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
	 * ���� �� ������ ��ȸ�Ѵ�.
	 * @param String memberId, String memberPasswd, String projectSeq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberDetail_coffee(String memberId, String memberPasswd, String projectSeq){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberDetail() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberDetail2_Coffee"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			db.setString(1, memberId);
			db.setString(2, memberPasswd);
			db.setString(3, projectSeq);

			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberDetail() End");
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
	 * member ����Ѵ�.
	 * @param String memberId, String memberPasswd, String projectSeq
	 * @return boolean 
	 */
	public boolean regMember(String projectSeq, String memberId, String memberPasswd){

		boolean check_result = false;
		if( log.isDebugEnabled() ) {
			//log.debug("regMember() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();
		try {

			sbufQuery.append(QueryContext.getInstance().get("member.regMember"));

			RowSetMapper db = new RowSetMapper();

			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, projectSeq);
			db.setString(2, memberId);
			db.setString(3, memberPasswd);
			
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
	 * member ����Ѵ�.
	 * @param String memberId, String memberPasswd, String projectSeq
	 * @return boolean 
	 */
	public boolean regMember_coffee(String projectSeq, String memberId, String memberPasswd){

		boolean check_result = false;
		if( log.isDebugEnabled() ) {
			//log.debug("regMember() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();
		try {

			sbufQuery.append(QueryContext.getInstance().get("member.regMember_Coffee"));

			RowSetMapper db = new RowSetMapper();

			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, projectSeq);
			db.setString(2, memberId);
			db.setString(3, memberPasswd);
			
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
	 * üũ�� ������ �����Ѵ�.
	 * @param ArrayList params
	 * @return boolean 
	 */
	public boolean regMemberCheckValue(List params){
		boolean check_result = false;
		if( log.isDebugEnabled() ) {
			//log.debug("regMemberCheckValue() Start");
		}
		
		StringBuffer sbufQuery = new StringBuffer();
		try {

			sbufQuery.append(QueryContext.getInstance().get("member.regMemberCheckValue"));


			
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			for(int i = 1; i <= params.size() ; i++){
				db.setString(i, (String)params.get(i-1));
				
			}
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
	 * üũ�� ������ �����Ѵ�.
	 * @param ArrayList params
	 * @return boolean 
	 */
	public boolean regMemberCheckInfoValue(List params){
		boolean check_result = false;
		if( log.isDebugEnabled() ) {
			//log.debug("regMemberCheckValue() Start");
		}
		
		StringBuffer sbufQuery = new StringBuffer();
		try {

			sbufQuery.append(QueryContext.getInstance().get("member.regMemberCheckInfoValue"));


			
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			for(int i = 1; i <= params.size() ; i++){
				db.setString(i, (String)params.get(i-1));
				
			}
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
	 * ȸ���� üũ�� ������ �����´�.
	 * @param String memberId, String activity, String projectSeq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberCheckValueDetail(String memberId, String activity, String projectSeq){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberCheckValueDetail() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberCheckValueList"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, projectSeq);
			db.setString(2, activity);
			db.setString(3, memberId);

			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberCheckValueDetail() End");
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
	 * ȸ���� üũ�� ������ �����´�.
	 * @param String memberId, String activity, String projectSeq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberCheckValueDetail2(String memberId, String activity, String projectSeq, String word){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberCheckValueDetail() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();
		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberCheckValueList2"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, projectSeq);
			db.setString(2, activity);
			db.setString(3, memberId);
			db.setString(4, word);
			
			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberCheckValueDetail() End");
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
	 * üũ�� ȸ�� ������ �����´�.
	 * @param String memberId, String activity, String projectSeq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberCheckList(String memberId, String activity, String projectSeq){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberCheckValueDetail() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberCheck2"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, projectSeq);
			db.setString(2, activity);
			db.setString(3, memberId);

			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberCheckValueDetail() End");
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
	 * üũ�� ������ �����Ѵ�.
	 * @param ArrayList params
	 * @return boolean 
	 */
	public boolean delMemberCheckValue(String memberId, String activity, String projectSeq){
		boolean check_result = false;
		if( log.isDebugEnabled() ) {
			//log.debug("delMemberCheckValue() Start");
		}
		
		StringBuffer sbufQuery = new StringBuffer();
		try {

			sbufQuery.append(QueryContext.getInstance().get("member.delMemberCheckValue"));

			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());


			db.setString(1, projectSeq);
			db.setString(2, activity);
			db.setString(3, memberId);

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
	 * üũ�� ������ �����Ѵ�.
	 * @param ArrayList params
	 * @return boolean 
	 */
	public boolean updateMemberCheckValue(List params){
		boolean check_result = false;
		if( log.isDebugEnabled() ) {
			//log.debug("regMemberCheckValue() Start");
		}
		
		StringBuffer sbufQuery = new StringBuffer();
		try {

			sbufQuery.append(QueryContext.getInstance().get("member.updateMemberCheckValue"));


			
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			/*
			for(int i = 1; i <= params.size() ; i++){
				db.setString(i, (String)params.get(i-1));
			}
			*/
			db.setString(1, (String)params.get(4));
			db.setString(2, (String)params.get(0));
			db.setString(3, (String)params.get(1));
			db.setString(4, (String)params.get(2));
			db.setString(5, (String)params.get(3));
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
	 * ȸ�� ������Ƽ�� �����´�.
	 * @param String projectSeq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberPropertiesList( String projectSeq){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberPropertiesList() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberPropertiesList"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, projectSeq);

			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberPropertiesList() End");
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
	 * ȸ�� ������Ƽ�� �����´�.
	 * @param String projectSeq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberPropertiesList1( String projectSeq){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberPropertiesList() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberPropertiesList1"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, projectSeq);

			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberPropertiesList() End");
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
	 * ȸ�� ������Ƽ�� �����Ѵ�.
	 * @param String projectSeq
	 * @return boolean
	 */
	public boolean regMemberProperties(List params){

		boolean check_result = false;

		if( log.isDebugEnabled() ) {
			//log.debug("regMemberProperties() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {

			sbufQuery.append(QueryContext.getInstance().get("member.regMemberProperties"));

			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			for(int i = 1; i <= params.size() ; i++){
				db.setString(i, (String)params.get(i-1));
			}

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
	 * ȸ�� ������Ƽ�� �����Ѵ�.
	 * @param String memberid, String projectSeq
	 * @return boolean
	 */
	public boolean delMemberProperties(String memberid, String projectSeq){

		boolean check_result = false;

		if( log.isDebugEnabled() ) {
			//log.debug("delMemberProperties() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {

			sbufQuery.append(QueryContext.getInstance().get("member.delMemberProperties"));

			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());

			db.setString(1, projectSeq);
			db.setString(2, memberid);

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
	 * üũ�� ������ �����Ѵ�.
	 * @param ArrayList params
	 * @return int 
	 */
	public int getMemberCheckedStatPoint(String projectSeq, String memberid, String activity, String word){
		int result = 0;
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberCheckedStatPoint() Start");
		}

		int memberLength = 0;
		
		StringBuffer sbufQuery = new StringBuffer();
		StringBuffer whereQuery = new StringBuffer();

		int index = 1;
		try {



			sbufQuery.append(QueryContext.getInstance().get("member.memberCheckedStatPoint"));

			whereQuery.append("WHERE project_seq=? AND activity=? AND word=? \n");
			if(memberid!=null && memberid.trim().length()>0){
				
				memberLength = memberid.split(",").length;
				whereQuery.append(" AND memberid In (");
				for(int i=0;i<memberLength;i++){
					if(i>0){
						whereQuery.append(", ");
					}
					whereQuery.append("?");
				}
				whereQuery.append(") \n");

			}


			sbufQuery.replace(sbufQuery.indexOf("$$WHERE$$"), sbufQuery.indexOf("$$WHERE$$")+9, whereQuery.toString());

			//log.debug(sbufQuery);

			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());


			db.setString(index++, projectSeq);
			db.setString(index++, activity);
			db.setString(index++, word);

			if(memberid!=null && memberid.trim().length()>0){
				for(int i=0;i<memberLength;i++){
					//whereQuery.append("?");
					db.setString(index++, memberid.split(",")[i]);
				}
			}

			if(db.next()){
				result = db.getInt(1);
			}



		} catch(Exception e){
			if( log.isDebugEnabled() ) {
				log.debug("Exception : " + e);
			}
		}

		return result;
	}
	
	/**
	 * üũ�� ������ �����Ѵ�.
	 * @param ArrayList params
	 * @return int 
	 */
	public int getMemberZeroCheckedCount(String projectSeq, String memberid, String activity, String word){
		int result = 0;
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberCheckedStatPoint() Start");
		}

		int memberLength = 0;
		
		StringBuffer sbufQuery = new StringBuffer();
		StringBuffer whereQuery = new StringBuffer();

		int index = 1;
		try {



			sbufQuery.append(QueryContext.getInstance().get("member.memberZeroCheckedCount"));

			whereQuery.append("WHERE project_seq=? AND activity=? AND word=? \n");
			if(memberid!=null && memberid.trim().length()>0){
				
				memberLength = memberid.split(",").length;
				whereQuery.append(" AND memberid In (");
				for(int i=0;i<memberLength;i++){
					if(i>0){
						whereQuery.append(", ");
					}
					whereQuery.append("?");
				}
				whereQuery.append(") \n");

			}


			sbufQuery.replace(sbufQuery.indexOf("$$WHERE$$"), sbufQuery.indexOf("$$WHERE$$")+9, whereQuery.toString());

			//log.debug(sbufQuery);

			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());


			db.setString(index++, projectSeq);
			db.setString(index++, activity);
			db.setString(index++, word);

			if(memberid!=null && memberid.trim().length()>0){
				for(int i=0;i<memberLength;i++){
					//whereQuery.append("?");
					db.setString(index++, memberid.split(",")[i]);
				}
			}


			db.execute(query);

			if(db.next()){
				result = db.getInt(1);
			}



		} catch(Exception e){
			if( log.isDebugEnabled() ) {
				log.debug("Exception : " + e);
			}
		}

		return result;
	}

	/**
	 * ��Ÿ ������ �����´�.
	 * @param String seq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberCheckedEtcStatPoint(String projectSeq, String activity){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberCheckedEtcStatPoint() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberCheckedEtcStatPoint"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, projectSeq);
			db.setString(2, activity);
			
			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberCheckedEtcStatPoint() End");
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
	 * ��Ÿ ������ �����´�.
	 * @param String seq
	 * @return RowSetMapper
	 */
	public RowSetMapper getMemberCheckedInfo(String check_seq){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberCheckedEtcStatPoint() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberCheckedInfo"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, check_seq);
			
			db.execute(query);
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberCheckedEtcStatPoint() End");
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
	 * ��Ÿ ������ �����´�.
	 * @param String seq
	 * @return RowSetMapper
	 */
	
	public RowSetMapper getMemberCheckedEtcStatPoint1(String projectSeq, String activity){
		if( log.isDebugEnabled() ) {
			//log.debug("getMemberCheckedEtcStatPoint() Start");
		}
		StringBuffer sbufQuery = new StringBuffer();

		try {
			sbufQuery.append(QueryContext.getInstance().get("member.memberCheckedEtcStatPoint1"));
			RowSetMapper db = new RowSetMapper();
			QueryManager query = new QueryManager(sbufQuery.toString());
			
			db.setString(1, projectSeq);
			db.setString(2, activity);
			db.execute(query);
			
			if( log.isDebugEnabled() ) {
				//log.debug("getMemberCheckedEtcStatPoint() End");
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

}
