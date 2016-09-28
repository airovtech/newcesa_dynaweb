<%
	/*============================================================================
	 * @ Description : 관리자 등록시 ID 체크
	 *
	 * 작성일 : 2011.04.18
	 * 작성자 : 이정순
	 ============================================================================*/
%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/header.jsp" %>
<%
	RowSetMapper cRowSet = null;
	String message = "success";
	boolean result = false;
	int resultCount = 0;
	ResultSet rs = null;
	int valueCount = Integer.parseInt(StringUtils.defaultString(request.getParameter("valueCount"),"0"));
	String rowId		= StringUtils.defaultString(request.getParameter("rowId"));
	String activity = StringUtils.defaultString(request.getParameter("activity"), "");
	String add_word = StringUtils.defaultString(request.getParameter("add_word"), "");
	int rowId1= Integer.parseInt(rowId);
	String[] word = request.getParameterValues("word");
	
	String check_seq="";
	String checkValue = "";
	List params = null;
	//log.debug("valueCount : "+valueCount);
	//log.debug("activity : "+activity);
	rs=MemberDAO.getInstance().getMemberCheckValueDetail(sMemberId,activity,sProjectSeq);
	rs.last();
	 int nRecord = rs.getRow();
	    rs.beforeFirst();
	if(nRecord==Integer.parseInt(rowId)&&!StringUtils.isEmpty(add_word)){
		cRowSet=MemberDAO.getInstance().getMemberCheckValueDetail2(sMemberId, activity, sProjectSeq, add_word);
	}else{
		cRowSet=MemberDAO.getInstance().getMemberCheckValueDetail2(sMemberId, activity, sProjectSeq, word[rowId1-1]);
	}
	while(cRowSet.next()){
		//System.out.println("aaaa"+cRowSet.getString("check_seq"));
		check_seq=cRowSet.getString("check_seq");
	}

	

		params = new ArrayList();

		params.add(0, check_seq);
		checkValue = StringUtils.defaultString(request.getParameter("checked_"+rowId1));
		if(StringUtils.isEmpty(checkValue)){
			checkValue = "0";
		}
		params.add(1, checkValue);
		//log.debug("value : "+StringUtils.defaultString(request.getParameter("checked_"+i),"0"));
		if(MemberDAO.getInstance().regMemberCheckInfoValue(params)){
			resultCount++;
		}
	

	

	if(StringUtils.isEmpty(add_word)){
		if(resultCount == valueCount){
			message = "success";
		}
		else{
			message = "fail";
		}
	}
	else{
		if(resultCount == (valueCount+1)){
			message = "success";
		}
		else{
			message = "fail";
		}
	}
	
	out.println("{\"result\":\""+message+"\"}");
%>
<%@ include file="/include/footer.jsp" %>
