<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/header.jsp" %>
<%
	//DB 연결
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String query = null;

	// Var
	String adminid = request.getParameter("USER_ID");
	String password = request.getParameter("USER_PWD");
	String name = request.getParameter("USER_NM");
	String email_addr1 = request.getParameter("EMAIL_ADDR1");
	String email_addr2 = request.getParameter("EMAIL_ADDR2");
	String email = email_addr1 + "@" + email_addr2;
	String hp1 = request.getParameter("HP1");
	String hp2 = request.getParameter("HP2");
	String hp3 = request.getParameter("HP3");
	String phone = hp1 + "-" + hp2 + "-" + hp3;

	// MD5
	if(!"".equals(password)){
		password = DigestUtils.md5Hex(password);
	}

	// proc variable
	List params = new ArrayList();
	boolean result = false;
	int userGroupNumber = -1;

	try {
		if( "".equals(adminid) || "".equals(password) || "".equals(email) || "".equals(name)) {
		} else {
			// 회원 가입 조회
			RowSetMapper cRowSet = null;
	        cRowSet = AdminDAO.getInstance().chkAdminId(adminid);

	        if(cRowSet.next()){
	        	out.println("<script language='javascript'>");
	        	out.println("alert('User ID is already exists.');");
				out.println("self.location.replace('Login_Join.jsp');");
				out.println("</script>");
			} else {
			
				// user_group 다음 번호 가져옴
				userGroupNumber = AdminDAO.getInstance().getUserGroupNumber();
				userGroupNumber++;
				
				params.add(0, adminid);
				params.add(1, password);
				params.add(2, email);
				params.add(3, Integer.toString(userGroupNumber));
				params.add(4, name);
				params.add(5, phone);

				// 회원 정보 등록
				result = AdminDAO.getInstance().regUserAdmin(params);
			
				if(result){
					// 회원 가입 완료
					out.println("<script language='javascript'>");
					out.println("alert('It has been registered.');");
					out.println("self.close();");
					out.println("</script>");
				} else {
					out.println("<script language='javascript'>");
					out.println("alert('Registration failed.');");
					out.println("self.location.replace('Login_Join.jsp');");
					out.println("</script>");
				}
			}
		}
	}           
	catch(Exception e){
		log.debug("admin register Exception:"+e);
	} 
%>
<%@ include file="/include/footer.jsp" %>