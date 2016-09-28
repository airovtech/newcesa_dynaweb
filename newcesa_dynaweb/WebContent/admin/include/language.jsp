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
	String language = StringUtils.defaultString(request.getParameter("language"));
	
	session.setAttribute("language", language);

	out.println("{\"language\":\""+language+"\"}");
	
%>
<%@ include file="/include/footer.jsp" %>
