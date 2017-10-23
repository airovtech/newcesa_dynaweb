/*
 * (@)# com.spalm.explm.kac Copyright (c) 1996-2011 S-PALM Soft Co., Ltd. All rights reserved.
 * 
 * This source code is digitised property of S-PALM Soft Company Limited ("S-PALM") and 
 * protected by copyright under the law of Republic of Korea and other foreign laws.
 * Reproduction and/or redistribution of the source code without written permission of 
 * S-PALM Soft is not allowed. Also, it is severely prohibited to register whole or specific 
 * part of the source code to any sort of information retrieval system.
 */

/* ******************************************************************************************
 * System 	: EX-PLM Web
 * Sub System	: PMS Section
 * File Name    : comm.js
 * Author      	: shin(<e-mail id>@s-palmsoft.com)
 * Since       	: 2011. 11. 22.
 * Description 	: 
 * ******************************************************************************************/

/* **************************************************************************************
 * textarea에 maxlength attribute 추가
* **************************************************************************************/
jQuery.fn.limitMaxlength = function(options){

	var settings = jQuery.extend({
		attribute: "maxlength",
		onLimit: function(){},
		onEdit: function(){}
	}, options);

	// Event handler to limit the textarea
	var onEdit = function(){
		var textarea = jQuery(this);
		var maxlength = parseInt(textarea.attr(settings.attribute));

		if(textarea.val().length > maxlength){
			textarea.val(textarea.val().substr(0, maxlength));

			// Call the onlimit handler within the scope of the textarea
			jQuery.proxy(settings.onLimit, this)();
		}

		// Call the onEdit handler within the scope of the textarea
		jQuery.proxy(settings.onEdit, this)(maxlength - textarea.val().length);
	}

	this.each(onEdit);

	return this.keyup(onEdit)
				.keydown(onEdit)
				.focus(onEdit)
				.live('input paste', onEdit);
}

/* **************************************************************************************
 * esc와 back-space 클릭 방지
* **************************************************************************************/
/*
document.onkeydown=checkKey;
function checkKey(){
	//alert("You pressed a following key: "+window.event.keyCode);
	// ESC Key 누를 때 데이터 사라지는 것 방지
	if(window.event.keyCode == 27){
		window.event.returnValue = false;
		return;
	}
	// back-space 누를 때 
	if(window.event.keyCode == 8){
		// TextEdit가 아니면 작동하지 않도록
		if(!window.event.srcElement.isTextEdit){
			window.event.returnValue = false;
			return;
		}else if(window.event.srcElement.readOnly || window.event.srcElement.disabled){
			// readOnly나 disabled인 경우 작동하지 않도록
			window.event.returnValue = false;
			return;
		}
	}
	event.returnValue = true;
}
*/

/* **************************************************************************************
* 입력 폼 스타일 초기화 함수
* **************************************************************************************/
function fnInitFormStyle(){
	
	//입력폼 설정
	// input class="read" 항목을 찾아 읽기 전용으로 변경
	$(".frm_read").attr("readonly", "true");
	
	// text field, textarea onfocus 
	$("input[type=text], textarea").bind({focusin:function(){
		$(this).addClass("frm_focusin");
	}, focusout:function(){
		$(this).removeClass("frm_focusin");
	}});
	
	//textarea 글자 제한 추가
	$('textarea[maxlength]').limitMaxlength();
		
	//목록 mouse over,out  설정
	$(".list1 tr td, .list2 tr td").not(".noEffect tr td").bind({mouseover:function(){
		$(this).parent().addClass("list_bg_over");
		$(".bb:eq(" +$(this).parent().index()+ ") div").addClass("list_bg_over");		
	}, mouseout:function(){
		$(this).parent().removeClass("list_bg_over");
		$(".bb:eq(" +$(this).parent().index()+ ") div").removeClass("list_bg_over");
	}, click:function(){
		$(".list1 tr, .list2 tr").removeClass("list_bg_select");
		$(this).parent().addClass("list_bg_select");
		
		$(".bb div").removeClass("list_bg_select");
		$(".bb:eq(" +$(this).parent().index()+ ") div").addClass("list_bg_select");
	}});
	
	//캘린더 mouse over,out  설정
	$(".calendar .month li").not("li.cheader").bind({mouseover:function(){
		$(this).addClass("list_bg_over");
	}, mouseout:function(){
		$(this).removeClass("list_bg_over");
	}, click:function(){
		$(".calendar .month li").removeClass("list_bg_select");
		$(this).addClass("list_bg_select");
	}});
	
	fnInitSelectListStyle();
	
	//폼 테이블 가로 설정(ie 렌더링 문제 처리)
	//fnInitFormTableWidth();
	
}

function fnSetPositionMSGbar(){
	//var t_width = $(window).width()-37;
	var t_width = $("#container").width()-37;
	/*
	if($(".content").length){
		t_width = $(".content").width();
	}
	else if($(".page_title").length){
		t_width = $(".page_title").width();
	}
	else if($(".page_info").length){
		t_width = $(".page_info").width();
	}
	else{
		t_width = $(window).width() - 200;
	}*/
	/* , "width": t_width */
	//t_width = $(".content").innerWidth() -20;
	//t_width = "100%";
	$("#NOTICE_MSG").css( {"top": $(window).height() + ($(window).scrollTop() - 31)+"px", "width": t_width+"px"} );	
}
function fnInitFormTableWidth(){
	$(".table_left, .table_right").width( $(".table_left, .table_right").parent().parent().width() /2 );
}
function fnInitSelectListStyle(){
	$(".frm_list option").removeClass("list_bg_over");
	$(".frm_list option:odd").addClass("list_bg_over");	
}
function fnInitListStyle(){
	$(".list1 tr, .list2 tr").removeClass("list_bg_select");	
}
function fnSetLineSelected(id){
	$("#" + id).removeClass("list_bg_select").addClass("list_bg_select");
}

/* **************************************************************************************
* 입력 폼 클리어 함수 : hidden 등 제외
* **************************************************************************************/
function fnClearForm(formID){
	$(":input", "#"+formID).not(':button, :submit, :reset, :hidden').val('').removeAttr('checked').removeAttr('selected');	
}

/* **************************************************************************************
* 입력 폼 클리어 함수 : hidden 포함
* **************************************************************************************/
function fnClearFormAll(formID){
	$(":input", "#"+formID).val('').removeAttr('checked').removeAttr('selected');	
}

/* **************************************************************************************
* 메세지 바 클래스, 메세지 설정
* **************************************************************************************/
function fnSetPageMSG(type, msg){
	if( $("#NOTICE_MSG").length ){
		//if( (type == "INFORM" || type == "ERROR" || type == "WARNING") && (msg != null && msg != "") )
			$("#NOTICE_MSG").removeClass().addClass("bg" + type).html(msg);
	}

}
/* **************************************************************************************
* 화면 사이즈 가로 스크롤 설정
* **************************************************************************************/
function fnAdjustPageWidth(){
	var minWidth = 1000;
	
	if($(window).width() < minWidth){
		$("#container, #globalTopToggleBtn").not(".popupWin").css("width", minWidth);
	}
	else{
		$("#container, #globalTopToggleBtn").not(".popupWin").css("width",$(window).width());
	}
}

/* **************************************************************************************
* 로딩 이미지 제어
* **************************************************************************************/
function showLoader(){
	$("#loadingBarBG").show();
	$("#loadingBar").show();
}

function hideLoader(){
	$("#loadingBarBG").hide();
	$("#loadingBar").hide();
}

/* **************************************************************************************
* 상단 여닫기 제어
* **************************************************************************************/
function toggleTopNavi(){
	if($.cookie("spalmNaviHide") != "Y"){
		$.cookie("spalmNaviHide", "Y", { expires: 30 , path :'/' });
		hideTopNavi();
	}
	else{
		$.cookie("spalmNaviHide", "", { expires: -1 , path : '/' });
		showTopNavi();
	}
}

function showTopNavi(){
	if($("#globalTopNavi").length > 0){
		$("#globalTopNavi, .page_title").show();
		$("#btnTopToggle").attr("src", "/images/icon_rollup.gif");
	}
}

function hideTopNavi(){
	if($("#globalTopNavi").length > 0){
		$("#globalTopNavi, .page_title").hide();
		$("#btnTopToggle").attr("src", "/images/icon_rolldown.gif");
	}
}

/* **************************************************************************************
* 플래시 최소 사이즈 스크롤 설정
* **************************************************************************************/
function fnAdjustFlashDiv(w, h){
	var minWidth = 1200 - w;
	var minHeight = 700 - h;
	if($(window).width() < minWidth){
		$("#flashContent").css("width",minWidth);
	}
	else{
		$("#flashContent").css("width",$(window).width());
	}
	if($(window).height() < minWidth){
		$("#flashContent").css("height",minHeight);
	}
	else{
		$("#flashContent").css("height",$(window).height());
	}		
}

/* **************************************************************************************
* 스크롤바 width 구하기
* **************************************************************************************/
function getScrollbarWidth() 
{
	var scrollbarWidth = 0;
	if (scrollbarWidth) return scrollbarWidth;
	var div = $('<div style="width:50px;height:50px;overflow:hidden;position:absolute;top:-200px;left:-200px;"><div style="height:100px;"></div></div>'); 
	$('body').append(div); 
	var w1 = $('div', div).innerWidth(); 
	div.css('overflow-y', 'auto'); 
	var w2 = $('div', div).innerWidth(); 
	$(div).remove(); 
	scrollbarWidth = (w1 - w2);
	return scrollbarWidth;
}

/* ***************************************************************************************
* 구분코드 ajax 로딩 함수
* obj						: selectbox id
* key					: 프로퍼티명
* parentOb			: 상위 구분코드에 따라 로드 되는 경우 상위 구분코드 selectbox의 id
* parentKey			: 상위 구분코드의 프로퍼티명
* selectedValue	: 선택 값
* defaultText			: 값 없는 첫번째 옵션 텍스트(예: 전체 또는 선택)
* **************************************************************************************/
function fnLoadGbDetailCd( obj, key, parentObj, parentKey, selectedValue, defaultText){
	var url;
	var selectedCd = selectedValue;
	
	
	if(parentObj != "" && parentKey != ""){
		url = "/explm/mcm01001/jsonDetailCd.do?key=" + key + "&parentKey=" + parentKey + "&parentValue=" +$("#"+parentObj).val();
	}
	else{
		url = "/explm/mcm01001/jsonDetailCd.do?key=" + key;
	}
	
	$.getJSON( url,function(data, textStatus) {
		jsonData = data;
		
		if(textStatus == "error"){
			alert("error " + obj);
		}
		else{
			alert(jsonData.length);
		}
		
		if( defaultText != ""){
			$('#'+obj).html("<option value=''>" + defaultText + "</option>");
		}
		else{
			$('#'+obj).html("");
		}
						
		for(i = 0 ; i < jsonData.length ; i++){
			if( selectedCd == jsonData[i].GB_DETAIL_CD){						
				$('#'+obj).append("<option value='" + jsonData[i].GB_DETAIL_CD + "' selected>" + jsonData[i].GB_DETAIL_NM + "</option>");
			}
			else{
				$('#'+obj).append("<option value='" + jsonData[i].GB_DETAIL_CD + "'>" + jsonData[i].GB_DETAIL_NM + "</option>");
			}					
		}
	});
	
}


function replaceAll(srcStr,rgExp,replaceText){
	while(srcStr.indexOf(rgExp) != -1)	srcStr = srcStr.replace(rgExp, replaceText);
	return srcStr;
}

function getFormatDatebyString(yyyymmdd, format){
	
	var yyyy = yyyymmdd.substring(0,4);
	var mm = yyyymmdd.substring(4,6);
	var dd = yyyymmdd.substring(6);
	
	return getFormatDate(yyyy, mm, dd, format);
}

function getFormatDate(yyyy, mm, dd, format){
	var ret_str = "";
	var tmp_date = "";
	
	switch(format.toUpperCase())
	{
		case "YYYY":
			ret_str = yyyy;
			break;
		case "MM":
			ret_str = lpad(mm,2,"0");
			break;
		case "DD":
			ret_str = lpad(dd,2,"0");
			break;
		case "YYYYMM":
			ret_str = yyyy + lpad(mm,2,"0");
			break;
		case "YYYYMMDD":
			ret_str = yyyy + lpad(mm,2,"0") + lpad(dd,2,"0");
			break;
		case "YYYY/MM/DD":
			ret_str = yyyy + "/" + lpad(mm,2,"0") + "/" + lpad(dd,2,"0");
			break;
		case "YYYY-MM-DD":
			ret_str = yyyy + "-" + lpad(mm,2,"0") + "-" + lpad(dd,2,"0");
			break;
		case "YYYY.MM.DD":
			ret_str = yyyy + "." + lpad(mm,2,"0") + "." + lpad(dd,2,"0");
			break;
		default:
			ret_str = yyyy + "." + lpad(mm,2,"0") + "." + lpad(dd,2,"0");
			break;
	}
	return ret_str;

}

function lpad(str, length, charstr)
{
	if (str == '' || str == null)
		return '';
	
	str = str.toString();
	
	for(i=0;i<length;i++){
		if(str.length < length)
			str = charstr + str;
	}

	return str;
}	
