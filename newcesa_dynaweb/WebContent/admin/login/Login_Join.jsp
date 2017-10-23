<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<!doctype html>
<html>
<head>
		<title></title>
		<meta name="Title" content="">
		<meta name="Description" content="">
		<meta name="Keywords" content="">
		<meta name="Robots" content="all">
		<meta http-equiv="content-Type" content="text/html; charset=utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8,chrome=1">
		<meta http-equiv="Cache-Control" content="no-cache"/> 
		<meta http-equiv="Expires" content="0"/> 
		<meta http-equiv="Pragma" content="no-cache"/> 
		<meta name="MSSmartTagsPreventParsing" content="TRUE" />

		<link rel="stylesheet" href="/css/login/style.css" media="all">
		<link rel="stylesheet" href="/css/login/jquery-ui-1.8.16.custom.css" media="all">	
		<script type="text/javascript" src="/js/login/jquery-1.4.2.js"></script>
		<script type="text/javascript" src="/js/login/comm.js"></script>
		<script type="text/javascript" src="/js/login/jquery.cookie.js"></script>
</head>
<body>
<script>
//<![CDATA[				
	$(window).ready(function(){
		//로딩 이미지
		hideLoader();
		$('body').ajaxStart(function () {
			showLoader();
		}).ajaxStop(function () {
			hideLoader();
		});
		
		//화면 최소 사이즈 유지
		fnAdjustPageWidth();
		$(window).resize(fnAdjustPageWidth).scroll(fnAdjustPageWidth);
		/* 
		//메세지 바 위치 설정
		fnSetPositionMSGbar();
		$(window).resize(fnSetPositionMSGbar).scroll(fnSetPositionMSGbar); */
		
		
		//상단 여닫기 - 쿠키 적용
		if($.cookie("spalmNaviHide") == "Y"){
			hideTopNavi();
		}
	});

//]]>
</script>
<div id="loadingBarBG"></div>
<div id="loadingBar"><img src="/img/loader.gif"></div>

<div id="container popupWin">
<form id="frm" name="frm" action="/admin/login/Login_Join_proc.jsp" method="post">
<input type="hidden" id="hCRUD_FLAG" name="hCRUD_FLAG" value="C">
<input type="hidden" id="POSITION_GB_DETAIL_CD" name="POSITION_GB_DETAIL_CD" value="" />
<input type="hidden" id="EDU_LEVEL_GB_DETAIL_CD" name="EDU_LEVEL_GB_DETAIL_CD" value="" />
<input type="hidden" id="MAJOR_FIELD_GB_DETAIL_CD" name="MAJOR_FIELD_GB_DETAIL_CD" value="" />
<input type="hidden" id="RETIRED_GB_DETAIL_CD" name="RETIRED_GB_DETAIL_CD" value="" />
<input type="hidden" id="hUSE_YN" name="hUSE_YN" value="Y" />
	
	<!-- (s) title -->
	<div class="page_title">Sign up</div>
	
	<!-- (s) content -->
	<section class="content">
		<article>
			<div>(*)sign is mandatory.</div>

			<table summary="user register form" class="type1 register">
				<caption>user register form</caption>
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>				
				<tbody>
					<tr>
						<th>* User ID</th>
						<td>
							<input type="text" id="USER_ID" name="USER_ID" value="" maxlength="25">
						</td>
					</tr>
					<tr>
						<th>* Password</th>
						<td>
							<input type="password" id="USER_PWD" name="USER_PWD" value="" maxlength="20">
						</td>
					</tr>
					<tr>
						<th>* Chk Password</th>
						<td>
							<input type="password" id="USER_PWD_RE" name="USER_PWD_RE" value="" maxlength="20">
						</td>
					</tr>
					<tr>
						<th>* name</th>
						<td>
							<input type="text" id="USER_NM" name="USER_NM" value="" maxlength="25">
						</td>
					</tr>
					<tr>
						<th>* email</th>
						<td>
							<input type="text" id="EMAIL_ADDR1" name="EMAIL_ADDR1" value="" maxlength="25">
							@
							<input type="text" id="EMAIL_ADDR2" name="EMAIL_ADDR2" value="" size="30" maxlength="25">
						</td>
					</tr>
					<tr>
						<th>Mobile Number </th>
						<td>
							<input type="text" id="HP1" name="HP1" value="" size="5" maxlength="4"> 
							-
							<input type="text" id="HP2" name="HP2" value="" size="5" maxlength="4">
							-
							<input type="text" id="HP3" name="HP3" value="" size="5" maxlength="4">
						</td>
					</tr>
				</tbody>	
			</table>

			<!-- (s) btn -->			
			<div class="btn right pdT15">
				<span class="type2"><a href="#none" onclick="fnSave();">OK</a></span>
				<span class="type2"><a href="#none" onclick="self.close();">Cancel</a></span>
			</div>
			
		</article>
	</section>
	<!-- (e) content -->

</form>
<script>
	$(document).ready(function() {	
		fnSetFormStyle();
		fnInitFormStyle();
	});
	
	/* **************************************************************************************
	 * 회원 가입
	 * ************************************************************************************* */
	 /*
	function fnSave(){
		var url = "/pssiu/siu01002/updUserDetail.do";
		var options = {
					  	beforeSubmit: fnBeforeSubmit
					  , success: fnReturnSubmit
					  , url: url
					  , dataType: 'json'
				      };
		$("#frmSpalm").ajaxSubmit(options);
	}
	*/

	function fnSave() {
		if (fnBeforeSubmit()) {
			var f = document.frm;
			f.USER_ID.value = $("#USER_ID").val();
			f.USER_PWD.value = $("#USER_PWD").val();
			f.USER_NM.value = $("#USER_NM").val();
			f.EMAIL_ADDR1.value = $("#EMAIL_ADDR1").val();
			f.EMAIL_ADDR2.value = $("#EMAIL_ADDR2").val();
			f.HP1.value = $("#HP1").val();
			f.HP2.value = $("#HP2").val();
			f.HP3.value = $("#HP3").val();
			f.submit();
		}
	}


    // Vaidation
	function fnBeforeSubmit(){
		var msg = "Would you like to register?";
		
		// 필수 입력항목 확인
		if( $("#USER_ID").val() == "" || $("#USER_PWD").val() == "" || $("#USER_PWD_RE").val() == "" || $("#USER_NM").val() == "" || $("#EMAIL_ADDR1").val() == "" || $("#EMAIL_ADDR2").val() == "" ){
			//msg = replaceAll("{0}란의 값은 필수 값입니다. {0}값을 입력하십시오.", "{0}", "이름");
			msg = "Mandatory input missing.";
			alert(msg);
			return false;
		} else if( $("#USER_PWD").val() != $("#USER_PWD_RE").val() ){
			msg = "Password and password check values do not match.";
			alert(msg);
			return false;
		}
		
		if(confirm(msg)){
			return true;
		} else {
			return false;
		}
	}
	
    // Result
	function fnReturnSubmit(data){
		if(data.RTN_CD == "ERROR"){
			alert(data.RTN_MSG);
		}
		else{
			//alert(data.RTN_MSG);
			alert("Joined.");
			self.close();
		}		
	}
	
	/* **************************************************************************************
	 * 권한에 따른 폼 CSS 세팅
	 * ************************************************************************************* */
	function fnSetFormStyle(){
		$("#USER_ID, #USER_PWD, #USER_PWD_RE, #USER_NM, #EMAIL_ADDR1, #EMAIL_ADDR2").addClass("frm_must");
	}

</script>
</body>
</html>
  