<%
	/*============================================================================
	 * @ Description : SBP Map - 연결된 activity 보여주기
	 *
	 * 작성일 : 2016.12.28
	 * 작성자 : 조재일
	 ============================================================================*/
%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.net.*"%>
<%@ include file="/include/header.jsp" %>
<%@ include file="/include/needAdminLogin.jsp" %>
<%
	/* 연결된 activity 정보를 가져온다. */	
	String ajax_project_seq = request.getParameter("ajax_project_seq");
	String ajax_sbp_name = request.getParameter("ajax_sbp_name");
	ajax_sbp_name = URLDecoder.decode(ajax_sbp_name, "UTF-8");
	if(!(ajax_project_seq.equals("") || ajax_sbp_name.equals("") )) { 
		RowSetMapper activityRowSet = ProjectDAO.getInstance().get_SBPActivity(ajax_project_seq, ajax_sbp_name);	
		StringBuffer result = new StringBuffer();;
		int count = 0;
		while(activityRowSet.next()) {
			String impl = activityRowSet.getString("activity");
			if(count != 0) {
				result.append(",");
			}
			result.append(impl);
			count++;
		}
		out.print(result);
	}
	
%>
<%@ include file="/include/footer.jsp" %>
