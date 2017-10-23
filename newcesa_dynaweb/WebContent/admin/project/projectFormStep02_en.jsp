<%
	/*============================================================================
	 * @ Description : 관리자 정보 등록, 수정 폼
	 *
	 * 작성일 : 2011.04.18
	 * 작성자 : 이정순
	 ============================================================================*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.net.URLEncoder" %>
<style type="text/css">

    .activityMatrix {
        width:778px;
        overflow-x:scroll;  
        overflow-y:visible;
    }
    .headcol {
        position:absolute;
        background-color:#ffffff;
    }
    
	.cursor {
		cursor:pointer;
	}
	
	.modal {
	    display: none; /* Hidden by default */
	    position: fixed; /* Stay in place */
	    z-index: 1; /* Sit on top */
	    left: 0;
	    top: 0;
	    width: 100%; /* Full width */
	    height: 100%; /* Full height */
	    overflow: auto; /* Enable scroll if needed */
	    background-color: rgb(0,0,0); /* Fallback color */
	    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
	}
	
	.sbp-project-modal-content {
		position: fixed;
	    background-color: #fefefe;
	    margin-left:25%;
	    padding: 20px;
	    border: 1px solid #888;
	    width: 50%;
	}
	.w3-table-all{
		border-collapse:collapse;
		border-spacing:0;
		width:100%;
		display:table;
		border:1px solid #ccc;
	}
	.w3-table-all tr{
		border-bottom:1px solid #ddd;
	}
	.w3-table-all tr:nth-child(odd){
		background-color:#fff;
	}
	.w3-table-all tr:nth-child(even){
		background-color:#f1f1f1;
	}
	.w3-table-all td,.w3-table-all th{
		padding:8px 8px;
		display:table-cell;
		text-align:left;
		vertical-align:top;
	}
	.w3-table-all th:first-child, .w3-table-all td:first-child{
		padding-left:16px
	}
	.w3-hover-light-blue:hover{
		color:#000!important;
		background-color:#87CEEB!important
	}
	
	.sbp-list-modal-content {
		position: fixed;
	    background-color: #fefefe;
	    margin-left:8%;
	    margin-top:1%;
	    padding:20px;	
	    width: 80%;
	    height:90%;
	}
	.sbp-map-modal-content {
		position: fixed;
	    background-color: #fefefe;
	    margin-left:8%;
	    margin-top:1%;
	    padding: 25px;
	    width: 80%;
	    height:90%;
	}
	.sbp-Activity-modal-content {
		position: fixed;
		border: 5px solid #0095cd;
		border-radius:5px;
	    background-color: #fefefe;
	    margin-left:42%;
	    margin-top:18%;
	    padding: 20px;
	    width: 200px;
	    height:80px;
	}
	.sbp-disconnect-modal-content {
		position: fixed;
		border: 5px solid #0095cd;
		border-radius:5px;
	    background-color: #fefefe;
	    margin-left:36%;
	    margin-top:18%;
	    padding: 20px;
	    width: 400px;
	    height:80px;
	}
	.sbp-activity-modal-content2 {
		position: fixed;
		border: 5px solid #0095cd;
		border-radius:5px;
	    background-color: #fefefe;
	    margin-left:25%;
	    margin-top:13%;
	    padding: 20px;
	    width: 710px;
	    height:365px;
	}
	.sbpproject-disconnect-modal-content {
		position: fixed;
		border: 5px solid #0095cd;
		border-radius:5px;
	    background-color: #fefefe;
	    margin-left:42%;
	    margin-top:18%;
	    padding: 20px;
	    width: 250px;
	    height:80px;
	}
	.sbp-list {
		margin-top:30px;
		width:100%;
		height:70%;
		border-top: 130px solid white;
	}
	.sbp-map {
		width:100%;
		height:70%;
		border-top: 130px solid white;
		
	}
	.sbp-activity {
		width:100%;
		height:90%;
	}
	.SBP_Activity_Connect_yes {
		position: fixed;
		bottom:0px;
		margin-bottom:45px;
		margin-left:39%;
		width:45px;
		height:30px;
		font-size:15px;
		background-color:black;
		color:white;
		text-align:center;
	}
	.disConnect {
		text-align:center!important;
	}
	.search {
		font-size:15px;
		width:90%;
		height:25px;		
		margin-right: 10px;
	}
	.title {
		position: fixed;
		z-index:1002;
		font-size:30px;
		margin-left:50px;
		margin-top:15px;
	}
	.activity_content_wrap {
		position: fixed;
		z-index:1002;
		font-size:15px;
		margin-left:30px;
		margin-top:90px;
	}
	.activity_content {
		position: fixed;
		z-index:1002;
		font-size:15px;
		margin-left:240px;
		margin-top:65px;
		height:33px;
		line-height:200%;
		font-size:13px;
				
		padding:16px;
		margin-bottom:16px!important;
		border:1px solid #ccc!important;
		border-color:#2196F3!important;
	}
</style>


<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/header.jsp" %>
<%@ include file="/include/headerAdmin.jsp" %>
<%
	m1 = 3;
	m2 = 1;
	m3 = 1;
%>
<%@ include file="/admin/include/menu.jsp" %>
<%
	// Params
	String seq = StringUtils.defaultString(request.getParameter("seq"));
	String currPage = StringUtils.defaultString(request.getParameter("currPage"),"1");
	String mode = "".equals(seq) ? "Create" : "Modify";
	RowSetMapper cRowSet = null;
	
	// Vars
	String projectName = "";
	String projectDesc = "";
	String startDate = DateUtil.getToday("YYYY-MM-DD");
	String endDate = DateUtil.getToday("YYYY-MM-DD");
	String image = "";
	String tempImage = "";
	String groupSeq = "";
	String sbp_ProjectName = "";
	String sbp_project_puid = "";

	if(!"".equals(seq)){
		cRowSet = ProjectDAO.getInstance().getProjectDetail(seq);
		
		if(cRowSet.next()){
			projectName = cRowSet.getString("project_name");
			projectDesc = cRowSet.getString("project_desc");
			startDate = cRowSet.getString("start_date");
			endDate = cRowSet.getString("end_date");
			image = cRowSet.getString("image");

			groupSeq = cRowSet.getString("user_group");				

			/* 연결된 SBP 프로젝트가 있으면 이름을 보여주고 없으면 프로젝트를 선택하라는 문구를 띄어준다 */
			String impl = cRowSet.getString("sbp_project_name"); 
			if(impl.equals("")) {
				sbp_ProjectName = "Please select a SBP project.";
			} else {
				sbp_ProjectName = impl;
				sbp_project_puid = cRowSet.getString("sbp_project_puid");
			}

		}
	}
	if(StringUtils.isEmpty(image)){
		tempImage = "/images/blank.gif";
	}
	else{
		tempImage = sc.get("imageBanner.file.url")+"/"+image;
	}

	//그룹 select	1000으로 셋팅
	StringBuffer sbufSelect = new StringBuffer();
	cRowSet = GroupDAO.getInstance().groupList(1000, 1);
	//sbufSelect.append("<select name='groupSeq' id='groupSeq'>");
	while(cRowSet.next()){
		if(groupSeq.equals(cRowSet.getString("seq"))){
			sbufSelect.append(cRowSet.getString("group_name"));
		}
	}
	//sbufSelect.append("</select>");

	//경험어휘 select
	StringBuffer sbufVocabulary = new StringBuffer();
	cRowSet = VocabularyDAO.getInstance().getGroupList(groupSeq);
	sbufVocabulary.append("<select name='vGroupSeq' id='vGroupSeq'>");
	while(cRowSet.next()){
		sbufVocabulary.append("<option value='"+cRowSet.getString("seq")+"'>"+cRowSet.getString("group_name")+"</option>");
	}
	sbufVocabulary.append("</select>");

	
	int tempCount = 0;
	int activitySize=0;
	//activity 를 가져온다.
	StringBuffer sbufActivity = new StringBuffer();

	
	sbufActivity.append("{\"activity\":[");
	cRowSet = ProjectDAO.getInstance().projectActivityList(seq);
	
	activitySize=cRowSet.size();
	String[] tempActImages = new String[activitySize];
	
	while(cRowSet.next()){
		if(tempCount>0){
			sbufActivity.append(",");
		}
		sbufActivity.append("\""+cRowSet.getString("activity")+"\"");
		String actImage = "";//cRowSet.getString("image");
		if(StringUtils.isEmpty(actImage)){
			tempActImages[tempCount] = "/images/blank.gif";
		}
		else{
			tempActImages[tempCount] = sc.get("imageBanner.file.url")+"/"+actImage;
		}
		tempCount++;
	}
	sbufActivity.append("]}");

	//word 를 가져온다.
	tempCount = 0;
	StringBuffer sbufWord = new StringBuffer();
	cRowSet = ProjectDAO.getInstance().projectWordList(seq);
	sbufWord.append("{\"word\":[");
	while(cRowSet.next()){
		if(tempCount>0){
			sbufWord.append(",");
		}
		sbufWord.append("\""+cRowSet.getString("word")+"\"");
		tempCount++;
	}
	sbufWord.append("]}");
	
	tempCount = 0;
	//체크 리스트를 가져온다.
	StringBuffer sbufCheckValue = new StringBuffer();
	cRowSet = ProjectDAO.getInstance().projectActivityWordList(seq);
	while(cRowSet.next()){
		if(tempCount>0){
			sbufCheckValue.append(",");
		}
		sbufCheckValue.append("\""+cRowSet.getString("checked_activity")+"-"+cRowSet.getString("checked_word")+"\"");
		tempCount++;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
%>
<script type="text/javascript">
var over = '0';
function goSubmit(){
	var f = document.frm;

	f.action = "projectProcStep02_en.jsp";
	f.submit();
}

function goSaveAs(){
	if(document.getElementById("newProjectName").style.display=="none"){
		document.getElementById("newProjectName").style.display = "inline";
		return;
	}

	var f = document.frm;	
	if ( isEmpty(f.newProjectName.value)) {
		alert("Please enter a new project name to save.");
		f.newProjectName.focus();
		return;
	}
	f.action = "projectProcSaveAs_en.jsp";
	f.submit();
}


$(document).ready(function() { 
	
});
//pre-submit callback 
function showRequest(formData, jqForm, options) { 
    var queryString = $.param(formData); 
    return true; 
} 
 
// post-submit callback 
function showResponse(responseText, statusText, xhr, $form)  {
	console.log($form);
	$form.prev().attr('src',"<%=sc.get("imageBanner.file.url")%>/"+responseText.filename);
	$form.parent('th:first').find('input[name="tempActImage"]').attr('value',responseText.filename);
	
}
//검은 막 띄우기
$('.openMask').click(function(e){
	e.preventDefault();
	wrapWindowByMask();
});
//닫기 버튼을 눌렀을 때
$('.layerWindow .close').click(function (e) {  
	//링크 기본동작은 작동하지 않도록 한다.
	e.preventDefault();  
	$('#mask, .layerWindow').hide();  
});       
//검은 막을 눌렀을 때
$('#mask').click(function () {  
  $(this).hide();  
  $('.layerWindow').hide();  
});
/*
// pre-submit callback 
function showRequest(formData, jqForm, options) { 
    var queryString = $.param(formData); 
    return true; 
} 
 
// post-submit callback 
function showResponse(responseText, statusText, xhr, $form)  { 
	if(responseText.result == "success"){
		printActivity(responseText);
	}
	else{
		alert("실패했습니다. 엑셀파일을 확인하세요.");
	}
}
*/
function printActivity(data){
	for(var i=0;i<data.activity.length;i++){
		addCol(data.activity[i], '', '');
	}
}

function sampleDownload(){
	location.href = "/upload/activity_sample.xlsx";
}

function groupSelect(){
	var seq = document.getElementById("vGroupSeq").value;
	$.getJSON('/admin/vocabulary/vocabularyAjaxList_en.jsp?seq='+seq, null, function(data) {

		if(data.word.length!=0){
			printWord(data);
		}
		else{
			alert("No vocabularies stored.");
		}
	});
}

function printWord(data){
	for(var i=0;i<data.word.length;i++){
		addRow(data.word[i]);
	}
}



function goWordCheck(){
	var table = document.getElementById("activityTable");
	var rows = table.getElementsByTagName("tr");
	var tempLength = rows.length;
	
	for (var y=0;y<tempLength;y++) {
		if(y==0) continue;
		rows[1].remove();
	}

	var checkValue = document.wordForm.checkValue;

	for(i=0;i<checkValue.length;i++){
		if(checkValue[i].checked == true){
			//alert(checkValue[i].value);
			addRow(checkValue[i].value);
		}  
	}
	moveChangeValue();
	$('#mask').hide(); 
	$('.layerWindow').hide(); 
}
function layerClose(){
	$('#mask').hide(); 
	$('.layerWindow').hide(); 
}


function modi(seq){
	var seq1 = document.getElementById(seq);
	var seq2 = document.getElementById("btm_"+seq);
	var seq3 = document.getElementById("bts_"+seq);
	var seq4 = document.getElementById("btc_"+seq);
	
	//alert(seq+seq1.value+seq2.value+seq3.value+seq4.value);
	seq1.focus();
	seq1.style.border='1px solid gray';
	seq1.readOnly = false;
	
	if(over=='1'){
		seq2.style.display='none';
		over='2';
	}
	
	seq3.style.display='inline';
	seq4.style.display='inline';
}
function modiover(seq){
	var seq1 = document.getElementById(seq);
	var seq2 = document.getElementById("btm_"+seq);
	if(over=='0'){
		seq2.style.display='inline';
		over='1';
	}
	
}
function modiout(seq){
	var seq1 = document.getElementById(seq);
	var seq2 = document.getElementById("btm_"+seq);
	if(over=='1'){
		seq2.style.display='none';
		over='0';
	}
	
}
function vsave(seq){
	
	var seq1 = document.getElementById(seq);
	var seq2 = document.getElementById("btm_"+seq);
	var seq3 = document.getElementById("bts_"+seq);
	var seq4 = document.getElementById("btc_"+seq);
	var seq5 = document.getElementById("hid_"+seq);
	//alert(seq);
	
	if ( isEmpty(seq1.value)) {
		alert("Please enter your vocabulary.");
		seq1.focus();
		return;
	} else{
		seq1.style.border='0px solid gray';
		seq1.readOnly = true;
		seq2.style.display='block';
		seq3.style.display='none';
		seq4.style.display='none';
		seq5.value=seq1.value;
		var paramData = "mode=Modify"+"&seq="+seq+"&word="+seq1.value;
		//alert(paramData);
		/*
		$.getJSON('../vocabulary/vocabularyProc.jsp', paramData, function(data) {
			
		});
		*/
		$.ajax({
			type : "POST",
			url : "../vocabulary/vocabularyProc_en.jsp",
			data : paramData,
			dataType : "json",
			success : function(data){
			
			// function 처리!!

			}
		});
		if(over=='2'){
			seq2.style.display='none';
			over='0';
		}
		groupWordListPopup();
	}
	
}
function cancel(seq){
	var seq1 = document.getElementById(seq);
	var seq2 = document.getElementById("btm_"+seq);
	var seq3 = document.getElementById("bts_"+seq);
	var seq4 = document.getElementById("btc_"+seq);
	var seq5 = document.getElementById("hid_"+seq);
	//alert(seq5.value);
	seq1.style.border='0px solid gray';
	seq1.value=seq5.value;
	seq1.readOnly = true;
	seq2.style.display='block';
	seq3.style.display='none';
	seq4.style.display='none';
	if(over=='2'){
		seq2.style.display='none';
		over='0';
	}
}


function duplCheck(seq) {
	var seq1 = document.getElementById(seq);
	var seq5 = document.getElementById("hid_"+seq);
	var seq6 = document.getElementById("shid_"+seq);
	var paramData = "word="+seq1.value+"&groupSeq="+seq6.value;
	//alert(paramData);
	/*
	$.getJSON('../vocabulary/vocabularyCheck.jsp', paramData, function(data) {
		alert(data.msg);
		if(data.code==2){
			if(seq1.value==seq5.value){
				
			}else{
				seq1.value="";
				alert(data.msg);
			}
			
			seq1.focus();
		}
		
	});
	*/
	$.ajax({
		type : "POST",
		url : "../vocabulary/vocabularyCheck_en.jsp",
		data : paramData,
		dataType : "json",
		success : function(data){
			alert(data.msg);
			if(data.code==2){
				if(seq1.value==seq5.value){	
				}else{
					seq1.value="";
					alert(data.msg);
				}
				seq1.focus();
			}
		}
	});
}












</script>

<div id="mask"></div>
<div class="layerWindow">
	<form name="wordForm" id="wordForm" method="post" action="">
	<p style="width:100px;padding-left:90px;">
		<div style="overflow-y:scroll; width:1000px; height:600px;"> 
		<div id="wordList" style="text-align:center;width:1000px;border:1px;margin: 0 auto;text-align:left;width: 800px;"></div>
		</div>
	</p>
	</form>
</div>



<div class="top_title">Project Activity / Vocabulary Registration (Step 02)</div>


<div id="form_warp">
	<dl>
		<%
			if(sGroup.equals("0")){
		%>
		<dt class="inpt_dt">Group</dt>
		<dd class="inpt_dd"><%=sbufSelect%><input type="hidden" name="groupSeq" id="groupSeq" value="<%=groupSeq%>" /></dd>
		<%
			}
			else{
		%>
			<input type="hidden" name="groupSeq" id="groupSeq" value="<%=sGroup%>" />
		<%
			}
		%>

		<dt id="pjn" class="inpt_dt">Project Name</dt>
		<dd id="pjn_list" class="inpt_dd">
			<span id="pjn_name" style="font-size:12px; color:black;"><%=projectName%></span> | <span id="sbp_ProjectName" class="connect_SBP_Project" style="cursor:pointer; font-size:12px;"><%=sbp_ProjectName%></span>
		</dd>

		<dt class="inpt_dt" style="height:55px;">Project Description</dt>
		<dd class="inpt_dd" style="height:55px;">
			<%=projectDesc%>
		</dd>

		<dt class="inpt_dt">Project Period</dt>
		<dd class="inpt_dd">
			<%=startDate%> ~ <%=endDate%>
		</dd>
		
		<dt class="inpt_dt" style="height:100px;">Image</dt>
		<dd class="inpt_dd" style="height:100px;">
			<img name="preImage" id="preImage" src="<%=sc.get("imageBanner.file.url")%>/<%=image%>" height="90" />
		</dd>

	</dl>         
</div>
<!--  -->
<div id="form_warp">
	<dl>
	<!--
		<dt class="inpt_dt">Activity 업로드</dt>
		<dd class="inpt_dd">
			<form name="activityFileForm" id="activityFileForm" action="projectActivityUpload.jsp" method="post" enctype="multipart/form-data">
				<input type="file" id="filename" name="filename" value="" size="15"/> <input type="submit" class="button blue" value="업로드" style="width:50px"/>
				&nbsp;&nbsp;&nbsp;<input type="button" class="button white" value="샘플파일 다운로드" style="width:120px" onclick='sampleDownload()'/>
			</form>
		</dd>
	-->
		<dt class="inpt_dt">Experience Vocabulary Group</dt>
		<dd class="inpt_dd">
			<%=sbufVocabulary%> 
			<input type="button" onclick="groupWordListPopup();" value="View group information" class="button blue" style="width:145px;" />
		</dd>
	</dl>       
</div>

<script type="text/javascript">
var tempWidth = 1100;

jQuery.moveColumn = function (table, from, to) {
    var rows = jQuery('tr', table);
    var cols;
    rows.each(function() {
        cols = jQuery(this).children('th, td');
        cols.eq(from).detach().insertBefore(cols.eq(to));
    });
}

jQuery.moveRow = function (table, from, to) {
    var rows = jQuery('tr', table);
    var cols;
    rows.each(function() {
        cols = jQuery(this).children('th, td');
        cols.eq(from).detach().insertBefore(cols.eq(to));
    });
}

function onSubmitForm(target){
	$(target).ajaxSubmit({ 
        target:        '#output2',   // target element(s) to be updated with server response 
        beforeSubmit:  showRequest,  // pre-submit callback 
        success:       showResponse,  // post-submit callback 
		url:       'projectImageUpload.jsp',         // override for form's 'action' attribute 
        dataType:  'json',        // 'xml', 'script', or 'json' (expected server response type) 
        clearForm: true,        // clear all form fields after successful submit 
        resetForm: true        // reset the form after successful submit 
    }); 
}

function addCol(activityText, activityImageFullpath, activityImage, sbp_name, sbp_id, sbp_activityId){
	document.getElementById("firstColumn").innerHTML = "";
	var count = 0;
	var tds = $("#activityTable th").length;
	if(tds>=8){
		tempWidth = tempWidth+120;
	}
	document.getElementById("all").style.minWidth = tempWidth+"px";

	$('#activityTable tr').each(function()
    {
		count++;
		if(count==1){
			var htmlCode = "";
			if(sbp_activityId == "" || sbp_activityId == undefined) {
				htmlCode += '<th><input type="text" name="activityName" id="activityName'+tds+'" size="10" value="'+activityText+'" title="'+activityText+'" onchange="ovrlapChk(this)"/><br/>';
			} else {
				htmlCode += '<th><input type="text" name="activityName" id="activityName'+tds+'" size="10" value="'+activityText+'" title="'+activityText+'" onchange="ovrlapChk(this)" sbp_activityId="' + sbp_activityId + '" onclick="showActivity(this)" readonly /><br/>';	
			}
				$(this).append(htmlCode += '<input type="hidden" name="tempActImage" id="tempImage'+tds+'" value="' + activityImage + '" />' + 
								'<input type="hidden" name="sbp_name" id="sbp_name'+tds+'" value="' + sbp_name +'" />' +
								'<input type="hidden" name="sbp_id" id="sbp_id'+tds+'" value="' + sbp_id +'" />' +
								'<input type="hidden" name="sbp_activityId" id="sbp_activityId'+tds+'" value="' + sbp_activityId +'" />' +
								'<img name="preActImage" id="preActImage" src="' + activityImageFullpath + '" height="90" />' +
								'<form name="activityFileForm" method="post" enctype="multipart/form-data" onSubmit="onSubmitForm(this); return false;">' +
									'<input type="file" id="imageName'+tds+'" name="imageName" value="" size="15"/>' + 
									'<input type="submit" class="button blue" value="Upload" style="width:50px"/>' +
								'</form>' +
								'<input type="checkbox" id="allCheck'+tds+'" checked onclick="checkAll()" />' +
								'<img src="/images/button/pre_btn.png" onclick="left(this)"><img src="/images/button/next_btn.png" onclick="right(this)"><img src="/images/button/del_btn.png" onclick="colRemove(this)"></th>');
		}else{
			$(this).append('<td><input type="checkbox" name="checkVal" value="'+tds+'-'+(count-1)+'"></td>');

		}
    });
}
function addRow(word){

	document.getElementById("firstColumn").innerHTML = "";
	
	var rowCount =  $('#activityTable tr').length;
	var tds = $("#activityTable th").length;

	var html = "";

	html += "<tr>";

	for(var i=0;i<tds;i++){
		if(i==0){
			html+='<td id="headcol" class="headcol"><input type="text" name="wordName" value="'+word+'" size="10"/><br/><img src="/images/button/up_btn.png" onclick="up(this)"><img src="/images/button/down_btn.png" onclick="down(this)"><img src="/images/button/del_btn.png" onclick="rowRemove(this)"></td>';
		}
		else{
			html+='<td><input type="checkbox" name="checkVal"  id="checkVal'+i+'-'+rowCount+'" value="'+i+'-'+rowCount+'"></td>';		
		}
	}
	
	html+="</tr>";

	$('#activityTable').append(html);
	
	var firstColumnWidth = $($("#activityTable td.headcol:first")[0]).width();	
	$('#firstColumn').addClass('headcol').css('width', firstColumnWidth + 'px').css('margin-top', '-1px');
	$('.headcol').css('margin-left',(( firstColumnWidth+21)*-1) + 'px');
	$('.activityMatrix').css('margin-left', firstColumnWidth+21 + 'px');
}

function groupWordListPopup()
{
	var seq = document.getElementById("vGroupSeq").value;
	var groupSeq = document.getElementById("groupSeq").value;
	wrapWindowByMask();

	var params="seq="+seq+"&groupSeq="+groupSeq;


	 $.ajax({
	        type:"POST",  
	        url:"/admin/vocabulary/vocabularyAjaxList_en.jsp",
	        data:params,      
	        success:function(args){   
	            //$("#result").html(args);      
				document.getElementById("wordList").innerHTML = args;

	        }
	    }); 


}

function vocabularyAddPopup(seq)
{
	//alert(seq);
	var popUrl = "../vocabulary/vocabularyForm2_en.jsp?seq="+seq;	//팝업창에 출력될 페이지 URL
	var popOption = "width=400, height=150, resizable=no, scrollbars=no, status=no;";    //팝업창 옵션(optoin)
		window.open(popUrl,"",popOption);
	



}

function wrapWindowByMask(){
	//화면의 높이와 너비를 구한다.
	var maskHeight = $(document).height();  
	var maskWidth = $(window).width();  

	//마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다.
	//$('#mask').css({'width:100%','height':maskHeight});  
	//애니메이션 효과 - 일단 0초동안 까맣게 됐다가 60% 불투명도로 간다.
	$('#mask').fadeIn(0);      
	$('#mask').fadeTo("slow",0.6);    
	//윈도우 같은 거 띄운다.
	$('.layerWindow').show();
}

//전체체크
function checkAll()
{
	var tds = $("#activityTable th").length;
	var rowCount =  $('#activityTable tr').length;
	
	for(var j=1;j<tds;j++){
		
		if($("#allCheck"+j).is(":checked")){
			
			for(var i=1;i<rowCount;i++){

				$("input[id=checkVal"+j+'-'+i+"]").attr("checked", true);
				
			}
			
		}else{
			
			for(var i=1;i<rowCount;i++){
				
				$("input[id=checkVal"+j+'-'+i+"]").attr("checked", false);
							
			}
			
		}	
			
	}
}

//Activity 중복체크
function ovrlapChk(obj)
{
	var tds = $("#activityTable th").length;
	var iact;
	var act;

	for(var i=1;i<tds;i++){
		for(var j = 0; j < i ; j++){
		
			iact = $("#activityName"+i).val();
			act = $("#activityName"+j).val();
//			alert(icact + " : "  + act);
// 			alert("iact:"+iact);
// 			alert("act"+act);
			if(iact == act){
				alert("Activity is Duplicate.");
				$("#activityName"+i).val("");
				return false;
			}
		}
	}
}

function left(myId){
	var elem = myId.parentNode;
	var tbl = $("#activityTable");
	if(elem.cellIndex==1){
		alert("You can not move.");
	}
	else{
		jQuery.moveColumn(tbl, elem.cellIndex, elem.cellIndex-1);
		moveChangeValue();
	}
}
function right(myId){
	var elem = myId.parentNode;
	var tbl = $("#activityTable");
	var tds = $("#activityTable th").length;

	if((tds-1) == elem.cellIndex){
		alert("You can not move.");
	}
	else{
		jQuery.moveColumn(tbl, elem.cellIndex+1, elem.cellIndex);
		moveChangeValue();
	}
}
function down(myId)
{
	var elem = myId.parentNode.parentNode;
	var rows = $("#activityTable tr");

	var rowCount =  $('#activityTable tr').length;
	if(elem.rowIndex == rowCount-1){
		alert("You can not move.");
	}
	else{
		rows.eq(elem.rowIndex).insertAfter(rows.eq(elem.rowIndex + 1));
		moveChangeValue();
	}
}

function up(myId)
{	
	var elem = myId.parentNode.parentNode;
	var rows = $("#activityTable tr");

	if(elem.rowIndex == 1){
		alert("You can not move.");
	}
	else{
		rows.eq(elem.rowIndex).insertBefore(rows.eq(elem.rowIndex - 1));
		moveChangeValue();
	}
}

function rowRemove(myId){
	var elem = myId.parentNode.parentNode;
	if(confirm("Delete the Row.")){
		elem.remove();
		moveChangeValue();
	}
}
function colRemove(myId){
	var elem = myId.parentNode;
	var ptr = $("#activityTable").find("tr");
	ptr.find("td:eq("+elem.cellIndex+")").remove();
	ptr.find("th:eq("+elem.cellIndex+")").remove();
	moveChangeValue();
}

function moveChangeValue(){
	var data = [];
	var table = document.getElementById("activityTable");
	var rows = table.getElementsByTagName("tr");

	for ( var y = 0; y < rows.length; y++ ) {
		var td = rows[y].getElementsByTagName("td");
		for ( var x = 1; x < td.length; x++ ) {
			var input = td[x].getElementsByTagName("input");
			for ( var z = 0; z <input.length; z++ ) {
				data.push( input[z].value );
				input[z].value = x+"-"+y;
			}
		}
	}	
}

function checkValue(){
	var data = [<%=sbufCheckValue%>];
	var table = document.getElementById("activityTable");
	var rows = table.getElementsByTagName("tr");
	
	for ( var y = 0; y < rows.length; y++ ) {
		var td = rows[y].getElementsByTagName("td");
		for ( var x = 1; x < td.length; x++ ) {
			var input = td[x].getElementsByTagName("input");
			for ( var z = 0; z <input.length; z++ ) {
				if(jQuery.inArray( x+"-"+y, data )>-1){
					input[z].checked = true;
				}
			}
		}
	}	
}



//temp
/* 페이지 처음 들어왔을 때, activity에 대한 정보들을 가져와 보여준다. */
$(window).load(function() {
	
	<%
	StringBuffer html = new StringBuffer();
	int count = 0;
	List<String> sbpName_List = new ArrayList<String>();
	//Map<String, List<String>> activity_data = new HashMap<String, List<String>>();
	RowSetMapper activityRowSet = ProjectDAO.getInstance().projectActivityList(seq);
	while(activityRowSet.next()){
		String impl = "";
		String sbp_Name_Impl = "";
		String actName = activityRowSet.getString("activity");
		String actImage = activityRowSet.getString("activity_image");
		String actImageFullpath = StringUtils.isEmpty(actImage)?"/images/blank.gif":(sc.get("imageBanner.file.url")+"/"+actImage);
		
		/* SBP 프로젝트 및 SBP, activity와 연결된 정보가 있으면 보여준다. */
		String project_Seq = "";
		impl = activityRowSet.getString("project_seq");
		if(!impl.equals("")) {
			project_Seq = impl;
		} 
		
		String sbp_Name = "";
		sbp_Name_Impl = activityRowSet.getString("sbp_name");
		if(!sbp_Name_Impl.equals("")) {
			sbp_Name = sbp_Name_Impl;
			if(!sbpName_List.contains(sbp_Name)) {
				sbpName_List.add(sbp_Name);
			} else {
				sbp_Name = "";
			}
		}
		
		String sbp_Id = "";
		impl = activityRowSet.getString("sbp_id");
		if(!impl.equals("")) {
			sbp_Id = impl;
		} 
				
		String sbp_activityId = "";
		impl = activityRowSet.getString("sbp_activityId");
		if(!impl.equals("")) {
			sbp_activityId = impl;
		} 
		
		/* 어떤 SBP Project 및 어떤 SBP와 연결되어있는지 보여준다. */
		if(!(sbp_Name.equals(""))) {

			/* SBP Map모달을 띄어줄때 보여줄 activity 정보들 */
			/*if(activity_data.size() != 0) {
				for(String mapKey : activity_data.keySet()) {
					if(sbpName_List.contains(mapKey)) {
						List<String> data_impl = activity_data.get(sbp_Name);
						data_impl.add(actName);
						activity_data.put(sbp_Name, data_impl);
					} else {
						List<String> data_impl = new ArrayList<String>();
						data_impl.add(actName);
						activity_data.put(sbp_Name, data_impl);
					}
				}
			} else {
				List<String> data_impl = new ArrayList<String>();
				data_impl.add(actName);
				activity_data.put(sbp_Name, data_impl);
			}*/

			if(count == 0) {
				html.append("<span id='firstSBP' class='cursor show_Sbp_Map' sbpId='").append(sbp_Id).append("' sbp_Name='").append(sbp_Name).append("' >");
			} else {
				html.append("<span class='cursor show_Sbp_Map' sbpId='").append(sbp_Id).append("' sbp_Name='").append(sbp_Name).append("' >");
			}
			html.append(sbp_ProjectName).append("_").append(sbp_Name).append("</span><br/>");
			count++;
		}
	%>
		addCol("<%=actName%>", "<%=actImageFullpath%>", "<%=actImage%>", "<%=sbp_Name_Impl%>", "<%=sbp_Id%>", "<%=sbp_activityId%>");
	<%
	}
	/* SBP프로젝트만 연결되어있을 경우 */
	if((!sbp_ProjectName.equals("Please select a SBP project.")) && (count == 0)) {
		html.append("<span id='").append(sbp_ProjectName).append("' class='cursor' style='font-size:12px;' onclick='SBP_Project_disConnect(this)'>").append(sbp_ProjectName).append("</span>");
	%>
		var htmlCode = "<%=html.toString()%>";
		$("#sbp_ProjectName").attr("class", "");
		$("#sbp_ProjectName").attr("style", "");	
		$("#sbp_ProjectName").html(htmlCode);
	<%
	/* SBP Activity까지 연결되어있을 경우 */
	} else if((!sbp_ProjectName.equals("Please select a SBP project.")) && (count > 0)) {
	%>
		var htmlCode = "<%=html.toString()%>";
		$("#sbp_ProjectName").attr("class", "");
		$("#sbp_ProjectName").attr("style", "");	
		$("#sbp_ProjectName").html(htmlCode);
		
		var width = $("#pjn_name").css("width");
		width = width.split("px");
		width = parseInt(width[0]);
		width = width + 14;
		$(".show_Sbp_Map").css("margin-left", width);
		$(".show_Sbp_Map").css("font-size", "12px");
		$("#firstSBP").css("margin-left", 0);
	<%
	/* SBP프로젝트와 연결되어 있지 않을 경우 : 원래 코드대로 실행 */
	} else {}
	%>
	count = 0;
	printWord(<%=sbufWord%>);
	checkValue();
	
	var height = $("#pjn_list").css("height");
	$("#pjn").css("height", height);
});

/* SBP프로젝트 리스트를 보여준다 */
$(".connect_SBP_Project").live("click", function() {
	<%
		String result = ServletUtil.request("http://sbp.pssd.or.kr/sbp/sbpListForHvm.jsp?hvm=true&memberId=sbpAdmin");		// SBP Project & puid
	%>
	
	var projectName = "<%=projectName%>";				// CESA 프로젝트 이름
	var seq = "<%=seq%>";								// CESA 프로젝트 이름 번호(id)
	var result = <%=result%>;						
	var sbpProjectList = result.list;					// JSON에서 list만 추출 
	var html = "<table class='w3-table-all'>";
		html += 	"<thead>"
			+			"<tr>"
			+				"<th style='font-size:15px; text-align:center;'>SBP가 소속된 프로젝트를 선택하세요</th>"
			+				"<th>"
			+					"<a class='cursor' title='Close' style='float:right; margin-right:5px;' onclick='SBPProject_Close();'>"
			+						"<img style='width:15px; height:15px;' src='/upload/imageBanner/btn_close.png'/>"
			+					"</a>"
			+				"</th>"
			+			"</tr>"
			+			"<tr>"
			+				"<th colspan='2'>"
			+					"<input id='search' class='search' type='text' placeholder='검색해주세요.' onkeydown='javascript:if( event.keyCode == 13 ) search();' />"
			+					"<button class='button blue' style='width:40px;' onclick='search();'>검색</button>"
			+				"</th>"
			+			"</tr>"
			+		"</thead>"
		$(sbpProjectList).each(function() {
			html +=	"<tr class='w3-hover-light-blue cursor' cesa_project_name='" + projectName + "' sbp_project_name='" + this.project_name + "' sbp_project_puid='" + this.project_puid +"' onclick='connectSBP_Project(this)'>" 
				+		"<td colspan='2' style='font-size:15px; height:30px;'>"
				+		"Project_Name : " + this.project_name + "</td>"
				+	"</tr>";
		});
			+ 	"</table>";
	
		/* modal에 SBP ProjectList 보여주기 and 닫기 */
		document.getElementById("sbp-project-modal-content").innerHTML = html;
		$(".sbp-project-modal-content").css("overflow", "scroll");
		
		var height = $(window).height();
		var margin = height*(0.1);
		$(".sbp-project-modal-content").css("height",height*(0.9));
		$(".sbp-project-modal-content").css("margin-top",margin*(0.3));
		var modal = $("#SBP_Project_List_Modal");
		modal.css("display", "block");
});
/* SBP프로젝트 리스트를 닫는다.  */
function SBPProject_Close() {
	$("#SBP_Project_List_Modal").css("display", "none");
}

/* SBP프로젝트를 검색해준다 */
function search() {
	var result = <%=result%>;						
	var sbpProjectList = result.list;					// JSON에서 list만 추출 
	var search_value = $("#search").val();
	var result_Pn_list =  new Array();
	var result_Puid_list =  new Array();
	var projectName = "<%=projectName%>";
	
	$(sbpProjectList).each(function() {
		if(this.project_name.includes(search_value)) {
			result_Pn_list.push(this.project_name);
			result_Puid_list.push(this.project_puid);
		}
	});
	
	var html = "<table class='w3-table-all'>";
	html += 	"<thead>"
		+			"<tr>"
		+				"<th style='font-size:15px; text-align:center;'>Please select a project.</th>"
		+				"<th>"
		+					"<a class='close cursor' title='Close' style='float:right; margin-right:5px;' onclick='SBPProject_Close();'>"
		+						"<img style='width:15px; height:15px;' src='/upload/imageBanner/btn_close.png'/>"
		+					"</a>"
		+				"</th>"
		+			"</tr>"
		+			"<tr>"
		+				"<th colspan='2'>"
		+					"<input id='search' class='search' type='text' placeholder='search' onkeydown='javascript:if( event.keyCode == 13 ) search();' />"
		+					"<button class='button blue' style='width:40px;' onclick='search();'>search</button>"
		+				"</th>"
		+			"</tr>"
		+		"</thead>";
		for(var i=0; i<result_Pn_list.length; i++) {
	html +=		"<tr class='w3-hover-light-blue cursor close' cesa_project_name='" + projectName + "' sbp_project_name='" + result_Pn_list[i] + "' sbp_project_puid='" + result_Puid_list[i] +"' onclick='connectSBP_Project(this)'>" 
		 +			"<td colspan='2' style='font-size:15px; height:30px;'> Project_Name : " + result_Pn_list[i] + "</td>"
		 +		"</tr>";
		}

		+ 	"</table>";
	document.getElementById("sbp-project-modal-content").innerHTML = html;
}

/* SBP프로젝트와 연결시켜준다 */
function connectSBP_Project(target) {
	var cpn = $(target).attr("cesa_project_name"); 
	var spn = $(target).attr("sbp_project_name");
	var spp = $(target).attr("sbp_project_puid");
	var seq = "<%=seq%>";

	var frm2 = $("#frm2");
	$("#cpn").val(cpn);
	$("#spn").val(spn);
	$("#spp").val(spp);	
	$("#seq").val(seq);
	frm2.attr('action','projectProcStep02_en.jsp').submit();
}

/* SBP List를 보여준다.  */
function showSBPList() {
	var sbp_project_puid = "<%=sbp_project_puid%>";
	var sbp_ProjectName = "<%=sbp_ProjectName%>";
	if(sbp_ProjectName != "Please select a SBP project.") {
		//var sbplist_url = "http://wine.smartworks.net:8095/sbp/listForHvm.jsp?hvm=true&memberId=sbpAdmin&sPUID=" + sbp_project_puid + "&sProjectName=" + encodeURI(sbp_ProjectName,"UTF-8");	// SBP list를 보려면 SBP프로젝트이름과 SBP Puid가 필요하다
		var sbplist_url = "http://sbp.pssd.or.kr/sbp/listForHvm.jsp?hvm=true&memberId=sbpAdmin&sPUID=" + sbp_project_puid + "&sProjectName=" + encodeURI(sbp_ProjectName,"UTF-8");	// SBP list를 보려면 SBP프로젝트이름과 SBP Puid가 필요하다
		sbplist_url += "&editMode=true&fromClient=cesa";
			
		$(".sbp-list").attr("src", sbplist_url);

		var modal = $("#SBP_List_Modal");
		modal.css("display", "block");
	} else {
		alert("Please select a SBP project.");
	}
	
	var width = $(window).width()*0.6;
	$(".activity_content").css("width", width);
	
	width = $(".sbp-list").width()*0.5;
	$(".sact").css("margin-left", width);
	
	var height = $(".sbp-list").height();
	if(height > 500) {
		$(".sact").css("margin-top", height*0.05);
	} else {
		$(".sact").css("margin-top", height*0.015);
	}
}
/* SBP List를 닫는다 */
function showSBPList_Close() {	
	var modal = $("#SBP_List_Modal");
	modal.css("display", "none");
	sbp_dt = "";
	sbpId_dt = "";
	activityId_dt = "";
	activityName_dt = "";
	activityId_Array = new Array();
	activityName_Array = new Array();
	activityName_Array_Impl = 
	$(".activity_content").html("");
}

/* SBP activity 연결확인 Modal를 보여준다 */
function SBP_ActivityConnect() {
	var modal = $("#SBP_ActivityConnect_Modal");
	modal.css("display", "block");
}
/* SBP activity 연결을 등록 한다. */
/*
function SBP_Activity_Connect(certification) {
	if(certification == "true") {
		addCol(activityName_dt, '/images/blank.gif', '', sbp_dt, sbpId_dt, activityId_dt);
		$("#SBP_ActivityConnect_Modal").css("display", "none");		
		$("#SBP_List_Modal").css("display", "none");
	} else {
		$("#SBP_ActivityConnect_Modal").css("display", "none");				
	}
}
*/

/* SBP activity 연결을 등록 한다. */
function SBP_Activity_Connect() {
	for(var i=0; i<activityName_Array.length; i++) {
		addCol(activityName_Array[i], '/images/blank.gif', '', sbp_dt, sbpId_dt, activityId_Array[i]);
	}
	$(".activity_content").html("");
	sbp_dt = "";
	sbpId_dt = "";
	activityId_dt = "";
	activityName_dt = "";
	activityId_Array = new Array();
	activityName_Array = new Array();
	$("#SBP_List_Modal").css("display", "none");
	$(".activity_content").html("");
}

/* SBP Map을 보여준다. */
$(".show_Sbp_Map").live("click", function(e) {
	viewMode = true;
	
	var target = $(this);
	var sbpId = target.attr("sbpId");
	sbp_dt = target.attr("sbp_name");
	var sbp_ProjectName = "<%=sbp_ProjectName%>";
	//var sbpMap_Url = "http://wine.smartworks.net:8095/sbp/panel8ForHvm.jsp?seq=" + sbpId + "&hvm=true&memberId=sbpAdmin&sPUID=&docTitle=" + encodeURI(sbp_dt, "UTF-8") +"&sProjectName=" + encodeURI(sbp_ProjectName,"UTF-8") + "&mapShow=true";		// sbp map
	var sbpMap_Url = "http://sbp.pssd.or.kr/sbp/panel8ForHvm.jsp?seq=" + sbpId + "&hvm=true&memberId=sbpAdmin&sPUID=&docTitle=" + encodeURI(sbp_dt, "UTF-8") +"&sProjectName=" + encodeURI(sbp_ProjectName,"UTF-8") + "&mapShow=true";		// sbp map
	$(".sbp-map").attr("src", sbpMap_Url);
	console.log(sbpMap_Url);
	
	
	/* 연결되어있는 activity 정보를 가져온다. */
	$.ajax({
		type: 'GET',
		url: "projectProcStep02_forAjax.jsp?ajax_project_seq=" + <%=seq%> + "&ajax_sbp_name=" + escape(encodeURIComponent(sbp_dt)),
		dataType : "text",
		success : function(result) {
			var mapActivityArray = result.split(",");
			var mapActivityArray_Impl = "";
			
			for(var i=0; i<mapActivityArray.length; i++) {
				mapActivityArray_Impl += mapActivityArray[i] + ", ";
/*				if((i+=1) != (mapActivityArray.length)) {
					mapActivityArray_Impl += ",&nbsp;&nbsp;&nbsp;&nbsp;";
					i-=1;
				}
				if((i!=0) && (i%4 == 0)) {
					mapActivityArray_Impl += "<br/>";
				}
*/
			}
			mapActivityArray_Impl = mapActivityArray_Impl.substring(0, mapActivityArray_Impl.length-2);
			$(".activity_content").html(mapActivityArray_Impl);
		},
		error : function(result){
			alert("error : " + result);
		}
	});
	
	var width = $(window).width()*0.6;
	$(".activity_content").css("width", width);
	
	var modal = $("#SBP_Map_Modal");
	modal.css("display", "block");
	
	var height = $(window).height() * 0.025;
	$("#button_position").css("margin-top", height);
	
});
/* SBP Map을 을 닫아준다. */
function SBP_Map_Modal_Close() {
	$("#SBP_Map_Modal").css("display", "none");
	sbp_dt = "";
	sbpId_dt = "";
	activityId_dt = "";
	activityName_dt = "";
	activityId_Array = new Array();
	activityName_Array = new Array();
	$(".activity_content").html("");
	viewMode = false;
}


/* SBP와의 연결을 끊는 확인 modal를 띄어준다 .  */
function SBP_disConnect() {
	var modal = $("#SBP_DisConnect_Modal");
	modal.css("display", "block");
}
/* SBP와의 연결을 끊는다. (해당 activity까지 모두) */
function SBP_disConnect_yes() {
	var seq = "<%=seq%>";
	var sbp_Name = sbp_dt;
	
	var frm3 = $("#frm3");
	$("#project_seq").val(seq);
	$("#sbp_name").val(sbp_Name);
	frm3.attr('action','projectProcStep02_en.jsp').submit();
}
/* SBP와의 연결을 끊는 확인 modal를 닫아준다. */
function SBP_disConnect_no() {
	var modal = $("#SBP_DisConnect_Modal");
	modal.css("display", "none");
}

/* SBP Project와의 연결을 끊는 modal를 띄어준다.  */
function SBP_Project_disConnect() {	
	var modal = $("#SBPProject_DisConnect_Modal");
	modal.css("display", "block");
}
/* SBP Project와의 연결을 끊는다. */
function SBP_Project_disConnect_yes() {
	var seq = "<%=seq%>";
	$("#project_seq2").val(seq)
	var frm4 = $("#frm4");
	frm4.attr("action", "projectProcStep02_en.jsp").submit();
}
/* SBP Project와의 연결을 끊는 modal를 닫는다. */
function SBP_Project_disConnect_no() {
	var modal = $("#SBPProject_DisConnect_Modal");
	modal.css("display", "none");
}


/* sbp activity를 보여준다 */
function showActivity(target) {
	var sbp_activityId = $(target).attr("sbp_activityId");
	var srcUrl = "http://wine.smartworks.net:9095/AMT_SYSTEM/otherActivityUpdate.runa?user_seq=1&sysType=SBP&operType=SR02&activity_name=" + sbp_activityId + "&united_user_seq=tester&user_id=tester&user_name=tester&project_name=test&project_puid=test"
	$(".sbp-activity").attr("src", srcUrl);
	
	var modal = $("#SBP_Activity_Modal");
	modal.css("display", "block");
}
/* sbp activity를 닫는다. */
function close_activity_modal() {
	var modal = $("#SBP_Activity_Modal");
	modal.css("display", "none");
}
</script>

<form name="frm" id="frm" method="post">
<input type="hidden" name="seq" value="<%=seq%>"/>
<div style="padding-top:100px;">
<div class="btn_group_left_align" style="float: right">
	<input  type="button" onclick="addCol('', '/images/blank.gif', '');" value="Add Activity" class="button blue" />
	<input  type="button" onclick="showSBPList();" value="Add SBP Activity" class="button blue" />
</div>
<br/>
<br/>
<br/>
<div class="activityMatrix" >
<table cellspacing="0" cellpadding="0" class="activityTable" id="activityTable" width="100%">
	<tr>
		<th id="firstColumn">Activity / Add your vocabulary experience.</th>
	</tr>
	
</table>
</div>
</div>
<div class="btn_group_right_align">
	<input type="text" name="newProjectName" id="newProjectName" value="<%=projectName%>-Copy" size="30" style="display:none;vertical-align:-2px;" />
	<input type="button" onclick="goSaveAs();" value="Save as" class="button red" style="width:130px; display:none;" />
	<input type="button" onclick="document.location.href='projectList_en.jsp'" value="cancel" class="button white" style="width:50px;" />
	<input type="button" onclick="goSubmit();" value="save" class="button black" style="width:50px;" />
	
</div>
</form>






<!-- SBP Project List modal -->
<div id="SBP_Project_List_Modal" class="modal" style="display:none;">
	<div id="sbp-project-modal-content" class="sbp-project-modal-content"></div>
</div>

<!-- SBP Project 등록 form -->
<form name="frm2" id="frm2" method="post">
	<input id="cpn" type="hidden" name="cesa_project_name" value=""></input>
	<input id="spn" type="hidden" name="sbp_project_name" value=""></input>
	<input id="spp" type="hidden" name="sbp_project_puid" value=""></input>
	<input id="seq" type="hidden" name="seq" value=""></input>
</form>

<!-- SBP List modal -->
<div id="SBP_List_Modal" class="modal" style="display:none;">
	<div class="sbp-list-modal-content">
		<span class='title'>SBP</span>
		<span class="activity_content_wrap">
			Connected SBP_Activity : 
		</span>
		<span class="activity_content" style='overflow:scroll; overflow-x:hidden'></span>
		<span>
			<a class='cursor' title='Close' style='float:right; margin-right:5px;' onclick="showSBPList_Close();">
				<img style='width:15px; height:15px;' src='/upload/imageBanner/btn_close.png'/>
			</a>
		</span>
		<iframe class="sbp-list" src="" style='overflow:scroll; overflow-x:hidden;' frameborder="0"></iframe>
		<button type="button" class="button blue sact" style="width:55px;" onclick="SBP_Activity_Connect();">Confirm</button>
	</div>
</div>

<!--SBP Activity 연결 확인 modal -->
<!-- 
<div id="SBP_ActivityConnect_Modal" class="modal" style="display:none;">
	<div class="sbp-Activity-modal-content">
		<div id="activityQuestion" style="text-align:center;"></div> 
		<div style="text-align:center; margin-top:5px;">을(를) 선택하시겠습니까?</div>
		<div style="margin-top:20px; text-align:center;">
			<button type="button" class="button blue" style="width:35px;" onclick="SBP_Activity_Connect('true');">예</button>
			<button type="button" class="button blue" style="width:40px;" onclick="SBP_Activity_Connect('false');">아니오</button>
		</div>
	</div>
</div>
-->

<!-- SBP Map modal -->
<div id="SBP_Map_Modal" class="modal" style="display:none;">
	<div class="sbp-map-modal-content">
		<span class='title'>SBP</span>
		<span class="activity_content_wrap">
			Connected SBP_Activity : 
		</span>
		<span class="activity_content" style='overflow:scroll; overflow-x:hidden'></span>
		<span>
			<a class="cursor" title='Close' style='float:right; margin-right:5px; padding-bottom:10px;' onclick="SBP_Map_Modal_Close();">
				<img style='width:15px; height:15px;' src='/upload/imageBanner/btn_close.png'/>
			</a>
		</span>
		<iframe class="sbp-map" src="" style='overflow:scroll; overflow-x:hidden' frameborder="0";></iframe>
		<div id="button_position" style="text-align:center;">
			<button type="button" class="button blue" style="width:140px;" onclick="SBP_disConnect();">SBP Disconnection</button>
		</div>
	</div>
</div>

<!--SBP 연결 끊기 확인 modal -->
<div id="SBP_DisConnect_Modal" class="modal" style="display:none;">
	<div class="sbp-disconnect-modal-content">
		<div style="text-align:center;">All corresponding activityties will be deleted.</div> 
		<div style="text-align:center; margin-top:5px;">continue?</div>
		<div style="margin-top:20px; text-align:center;">
			<button type="button" class="button blue" style="width:35px;" onclick="SBP_disConnect_yes();">OK</button>
			<button type="button" class="button blue" style="width:40px;" onclick="SBP_disConnect_no();">Cancel</button>
		</div>
	</div>
</div>

<!-- SBP 연결끊기 form -->
<form name="frm3" id="frm3" method="post">
	<input id="project_seq" type="hidden" name="project_seq" value=""></input>
	<input id="sbp_name" type="hidden" name="sbp_name" value=""></input>
</form>

<!--SBP Project 연결 끊기 확인 modal -->
<div id="SBPProject_DisConnect_Modal" class="modal" style="display:none;">
	<div class="sbpproject-disconnect-modal-content">
		<div style="text-align:center;">will disconnect from SBP Project.</div> 
		<div style="text-align:center; margin-top:5px;">continue?</div>
		<div style="margin-top:20px; text-align:center;">
			<button type="button" class="button blue" style="width:35px;" onclick="SBP_Project_disConnect_yes();">OK</button>
			<button type="button" class="button blue" style="width:40px;" onclick="SBP_Project_disConnect_no();">Cancel</button>
		</div>
	</div>
</div>

<!-- SBP Project연결끊기 form -->
<form name="frm4" id="frm4" method="post">
	<input id="project_seq2" type="hidden" name="project_seq2" value=""></input>
</form>


<!--SBP Activity modal -->
<div id="SBP_Activity_Modal" class="modal" style="display:none;">
	<div class="sbp-activity-modal-content2">
		<a class='close' title='Close' style='float:right; margin-right:5px; padding-bottom:10px;' onclick="close_activity_modal()">
			<img style='width:15px; height:15px;' src='/upload/imageBanner/btn_close.png'/>
		</a>
		<iframe class="sbp-activity" src=""></iframe>
	</div>
</div>
<%@ include file="/include/footerAdmin.jsp" %>
<%@ include file="/include/footer.jsp" %>