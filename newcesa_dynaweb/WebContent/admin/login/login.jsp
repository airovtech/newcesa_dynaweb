<%
	/*============================================================================
	 * @ Description : 로그인 폼
	 *
	 * 작성일 : 2011.04.14
	 * 작성자 : 최형범
	 ============================================================================*/
%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/header.jsp" %>
<%
	// Params
	String check_result = request.getParameter("check_result");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title><%=sc.get("site.name")%></title>
	<script type="text/javascript" src="/js/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="/js/strFunction.js"></script>
	<link rel="stylesheet" type="text/css" href="http://ui.dnt7.com/backoffice/css/import.css"/>
	<link rel="stylesheet" type="text/css" href="/css/admin/extended.css" />
</head>
<body>

<script type="text/javascript">
$(function(){
	$("#adminid").focus();

	$("#password").keyup(function(event) {
		if (event.keyCode == 13) {
			if( $("#adminid").val()  && $("#password").val() ) {
				loginCheck();
			}
		}
	});

});

function loginCheck(){

	var f = document.frm;

	if ( !f.adminid.value ) {
		alert("Please enter ID");
		f.adminid.focus();
		return;
	}

	if ( !f.password.value)  {
		alert("Please enter password");
		f.password.focus();
		return;
	}

	f.submit();
	
}
</script>
	<div id="login_div">
		<div id="logo_div">
			<div>
				<img src="/images/login_bgH.gif" style="height:38px;" />
			</div>
		</div>
		<div id="login_con">
			<dl>
				<dt class="member_tit"><img src="http://ui.dnt7.com/backoffice/images/login/member_login_tit.gif" class="abstop" alt="멤버 로그인"/></dt>
				<dd class="input_con">
					<form name="frm" method="get" action="loginProc.jsp">
					<div class="input">
						<dl>
							<dt class="tit"><img src="../../images/button/id_tit.gif" class="abstop" alt="아이디"/></dt>
							<dt class="txtbox"><input type="text" id="adminid" name="adminid" class="loginTBox"/></dt>
						</dl>
						<dl>
							<dt class="tit"><img src="../../images/button/pwd_tit.gif" class="abstop" alt="패스워드"/></dt>
							<dt class="txtbox"><input type="password" id="password" name="password" class="loginTBox" /></dt>
						</dl>
					</div>
					</form>
					<div class="login_btn"><img src="../../images/button/login_btn.gif" class="abstop pointer" alt="로그인 버튼" onclick="loginCheck();"/></div>

				</dd>
				<dt class="login_guide">
					
					<%
					if(check_result != null){
						if(check_result.equals("fail_1")){
							check_result = "Please check your ID";
						}
						else if(check_result.equals("fail_2")){
							check_result = "Please confirm your password";
						}
					%><span class="red_font"><%=check_result%></span><%
					}
					else{
						%>Please enter your ID and password<%
					}
					%>
				</dt>
			</dl>
		</div>

	</div>
</body>
</html>

<%@ include file="/include/footer.jsp" %>
