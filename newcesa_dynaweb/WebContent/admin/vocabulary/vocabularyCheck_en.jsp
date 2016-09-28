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
<%@ include file="/include/needAdminLogin.jsp" %>
<%
	String word = StringUtils.defaultString(request.getParameter("word"));
	String groupSeq = StringUtils.defaultString(request.getParameter("groupSeq"));
	
	if(!sGroup.equals("0")){
		groupSeq = sGroup;
	}

	log.debug(word);

	int code = 0;
	String message = "The available vocabulary.";
	
	if ("".equals(word) ){
		code = 1;
		message = "Not available.";
	} else {
		
		RowSetMapper cRowSet = null;
		cRowSet = VocabularyDAO.getInstance().chkVocabulary(groupSeq, word);

		if(cRowSet.next()){
			code = 2;
			message = "The vocabulary has already been registered.";
		}
		
	}

	out.println("{\"code\":\""+code+"\", \"msg\":\""+message+"\"}");
	
%>
<%@ include file="/include/footer.jsp" %>
