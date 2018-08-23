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
<!-- 	<link rel="stylesheet" type="text/css" href="http://ui.dnt7.com/backoffice/css/import.css"/> -->
	<link rel="stylesheet" type="text/css" href="/backoffice/css/login.css" />
	<link rel="stylesheet" type="text/css" href="/css/admin/extended.css" />
</head>
<style>
	@import url(http://fonts.googleapis.com/earlyaccess/hanna.css);
	@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);
	body {
		width:100%!important;
		height:100%!important;
		background-color: #e9e9e9;
		/*bisque; lavender; lightblue; lightgrey; lightsteelblue; silver;*/
	}
	#login_img_form {
		position : absolute;
		/*text-align: center;*/
	} 
	.solid_line {
		border-bottom:2px solid white; 
		margin-bottom:5px;
	}
	#login_img{
		margin-top:20px;
		margin-right:1500px;
	}
	.bottomLine {
		position: absolute;
		background-color:white;
		bottom : 0;
		width:100%;
	}
	.bottomLine > img {
		width:100%;
		height:100%;
	}
	.register {position:absolute; width:60px; height:20px; color:#142871; top:130px; margin-left:235px; cursor:pointer;}
	.register > div {font-size:14px; padding-left:5px; padding-top:1px;}
</style>
<body>

<script type="text/javascript">
var widthSize, heightSize;
$(window).resize(function() {
	widthSize = parseInt($(window).width());
	heightSize = parseInt($(window).height());
	console.log("widthSize : ", widthSize);
	console.log("heightSize : ", heightSize);
}).resize();

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

function goToRegister() {
	var left = (widthSize - 500)/2;
	var top = (heightSize - 300)/2;
	window.open("/admin/login/Login_Join.jsp", "CESA_Join", "width=530, height=370, top=" + top + ", left=" + left + ", toolbar=no, menubar=no, scrollbars=no, resizable=no" );  
}


</script>
	<div id="login_img_form">
		<div style=" background-color:; height:75px; float:left;">
			<div style="font-family:Nanum Gothic;font-weight:bold;font-size:25px;padding-top:15px;">Customer Experience Sampling & Analysis (CESA)</div>
		</div>
		<div style="border-bottom:2px solid white; margin-top:56px; margin-bottom:12px;"></div>
		<div style="background-color:white"> 
			<img id="login_img" src="/images/login_img.jpg" />
		</div>
	</div>
	<div class="solid_line"></div>
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
					<div class="login_btn" style="cursor:pointer;">
						<img src="../../images/button/login_btn.gif" class="abstop pointer" alt="로그인 버튼" onclick="loginCheck();"/>
					</div>
					<div class="register" onclick="goToRegister();">
						<div>Register</div>
					</div>
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
						%>Please Enter your Information<%
					}
					%>
				</dt>
			</dl>
		</div>
	</div>
	<div class="bottomLine">
		<img src="/backoffice/images/login/login_backbg.jpg" />
	</div>
<script>
	var windowWidth = $(window).width();
	var windowHeight = $(window).height();
	
	/* 이미지 크기 조절 */
	$("#login_img_form").css("width", windowWidth);
	$("#login_img").css("margin-left", (windowWidth - 602)/2);
	$("#login_img").css("width", 602);
	$("#login_img").css("height", 304.298);
	$(".solid_line").css("width", windowWidth);
	
	/* 가운데 로그인 입력창 위치 */
	var formHeight = $("#login_img_form").css("height").replace("px", "");
	formHeight = parseInt(formHeight);
	$("#login_div").css("margin-top", formHeight + 5);
	
	/* 바닥 흰 라인 위치 */
	$(".bottomLine").css("height", windowHeight - (formHeight + 190));
	
	if(windowWidth >= 1600) {
		/* 이미지 크기 조절 */
		$("#login_img").css("margin-left", (windowWidth - 800)/2);
		$("#login_img").css("width", 800);
		$("#login_img").css("height", 404.298);
		
		/* 가운데 로그인 입력창 위치 */
		var formHeight = $("#login_img_form").css("height").replace("px", "");
		formHeight = parseInt(formHeight);
		$("#login_div").css("margin-top", formHeight + 5);
		
		/* 로그인 입력창 내용 위치 조정 */
		$("#login_div").css("width", 800);
		$("#login_div").css("margin-right", 265);
		$("#login_con").css("margin-right", 265);
		
		/* 바닥 흰 라인 위치 */
		$(".bottomLine").css("height", windowHeight - (formHeight + 190));
	}
	
	$("body").css("overflow-x", "hidden");
</script>
</body>

</html>
<%@ include file="/include/footer.jsp" %>
