<%
	/*============================================================================
	 * @ Description : 관리자용 레이아웃 헤더
	 *
	 * 작성일 : 2010.12.16
	 * 작성자 : 우진호
	 ============================================================================*/
%>

<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/needAdminLogin.jsp" %>
<%
	int m1 = 0, m2 = 0, m3 = 0;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title> CESA : Admin </title>
<!--[if IE 6]>
	<script type="text/javascript" src="/js/minmax.js"></script>
<![endif]-->
<script type="text/javascript" src="/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js/jquery-ui-1.8.6.custom.min.js"></script>
<script type="text/javascript" src="/js/jquery-block-ui.js"></script>
<script type="text/javascript" src="/js/calendarpop.js"></script>
<script type="text/javascript" src="/js/strFunction.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

<script type="text/javascript" src="/js/jquery.form.js"></script>

<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>


<link rel="stylesheet" type="text/css" href="/backoffice/css/default.css" />
<link rel="stylesheet" type="text/css" href="/backoffice/css/layout.css" />
<link rel="stylesheet" type="text/css" href="/backoffice/css/btn_ui.css" />
<link rel="stylesheet" type="text/css" href="/backoffice/css/login.css" />
<link rel="stylesheet" type="text/css" href="/backoffice/css/popup.css" />

<link rel="stylesheet" type="text/css" href="/css/admin/extended.css" />

<script>
/* SBP서버로부터 데이터를 받아온다 */

//Create IE + others compatible event handler
var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
var eventer = window[eventMethod];
var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";



/* 데이터바구니 */
/* PSS와 SBP프로젝트 연결하는데 필요한 데이터를 담는 바구니역할을 변수들 */
var sbp_dt ="", sbpId_dt="", activityId_dt="", activityName_dt="";	
var count_dt = 0;
var activityId_Array = new Array();
var activityName_Array = new Array();
//var editMode = "";
var viewMode = false;

//Listen to message from child window
eventer(messageEvent,function(e) {
	
	var sbpMapData = e.data.split("||");
//	sbpMapData[0]	->	SBP
//	sbpMapData[1]	->	SBP id
//	sbpMapData[2]	->	activity 번호
//	sbpMapData[3]	->	activity id
//	sbpMapData[4]	->	activity name 
//	sbpMapData[5]	->  activity 메인 이름
// 	sbpMapData[4] += "(" + sbpMapData[5] + ")";		// activity이름과 메인이름을 합쳐준다. 


	/* 선택한 activityId 정렬과정 */
	var sign = false;
	var length_Id_dt = activityId_Array.length;
	if(length_Id_dt == 0) {
		activityId_Array.push(sbpMapData[3]);
	} else {
		var key = false;
		for(var i=0; i<length_Id_dt; i++) {
			if(activityId_Array[i] != sbpMapData[3]) {
				key = true;
			} else {
				key = false;
				activityId_Array.splice(i,1);
				i = length_Id_dt;
			} 	
		}
		if(key) {
			sign = true;
			activityId_Array.push(sbpMapData[3]);
		}
	}

	/* 선택한 activity Name 정렬과정 */
	var length_Name_dt = activityName_Array.length;
	if(length_Name_dt == 0) {
		activityName_Array.push(sbpMapData[4]);
	} else {
		var key = false;
		for(var i=0; i<length_Name_dt; i++) {
			if(activityName_Array[i] != sbpMapData[4]) {
				key = true;
			} else {
				if(sign == false) {
					key = false;
					activityName_Array.splice(i,1);
					i = length_Name_dt;
				} else {
					key = true;
					i = length_Name_dt;
				}
			}
		}
		if(key) {
			activityName_Array.push(sbpMapData[4]);
		}
	}


	/* SBP Map에서 선택되어진 activity 이름을 보여준다 */
	if(viewMode != true) {
		var activityName_Array_Impl = "";
		for(var i=0; i<activityName_Array.length; i++) {
			activityName_Array_Impl += activityName_Array[i];
			if((i+=1) != (activityName_Array.length)) {
				activityName_Array_Impl += ",&nbsp;&nbsp;&nbsp;&nbsp;";
				i-=1;
			}
			if((i!=0) && (i%7 == 0)) {
				activityName_Array_Impl += "<br/>";
			}
		}
		$(".activity_content").html(activityName_Array_Impl);
	}

	sbp_dt = sbpMapData[0];
	sbpId_dt = sbpMapData[1];
	activityId_dt = sbpMapData[3];
	activityName_dt = sbpMapData[4];
	
//	SBP_ActivityConnect();
//	$("#activityQuestion").html(sbpMapData[4]);
//	console.log("header" , sbp_dt, sbpId_dt, activityId_dt, activityName_dt);
},false)


</script>
</head>



<body>
	<div id="all" style="min-width:1200px;"><!-- all 시작 -->
	<div id="mask"></div>