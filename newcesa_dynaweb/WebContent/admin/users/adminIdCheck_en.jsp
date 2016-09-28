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
	String adminid = StringUtils.defaultString(request.getParameter("adminid"));

	int code = 0;
	String message = "ID is available.";

	if ( "".equals(adminid) ){
		code = 1;
		message = "Not available.";
	} else if ( adminid.length() < 3) {
		code = 1;
		message = "Enter your ID length at least three letters";

	} else {
		
		RowSetMapper cRowSet = null;
		cRowSet = AdminDAO.getInstance().chkAdminId(adminid);

		if(cRowSet.next()){
			if ( cRowSet.getInt("deleteYN") == 1 ) {
				code = 2;
				message = "ID is deleted.";
			} else {
				code = 3;
				message = "ID is in use.";
			}
		}
	}

	out.println("{\"code\":\""+code+"\", \"msg\":\""+message+"\"}");
	
%>
<%@ include file="/include/footer.jsp" %>
