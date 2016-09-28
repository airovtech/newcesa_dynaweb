<%
	/*============================================================================
	 * @ Description : 관리자 정보 등록, 수정 폼
	 *
	 * 작성일 : 2011.04.18
	 * 작성자 : 이정순
	 ============================================================================*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
	

	if(!"".equals(seq)){
		cRowSet = ProjectDAO.getInstance().getProjectDetail(seq);
		
		if(cRowSet.next()){
			projectName = cRowSet.getString("project_name");
			projectDesc = cRowSet.getString("project_desc");
			startDate = cRowSet.getString("start_date");
			endDate = cRowSet.getString("end_date");
			image = cRowSet.getString("image");

			groupSeq = cRowSet.getString("user_group");
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
	//activity 를 가져온다.
	StringBuffer sbufActivity = new StringBuffer();
	cRowSet = ProjectDAO.getInstance().projectActivityList(seq);
	sbufActivity.append("{\"activity\":[");
	while(cRowSet.next()){
		if(tempCount>0){
			sbufActivity.append(",");
		}
		sbufActivity.append("\""+cRowSet.getString("activity")+"\"");
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

	f.action = "projectProcStep02.jsp";
	f.submit();
}

function goSaveAs(){
	if(document.getElementById("newProjectName").style.display=="none"){
		document.getElementById("newProjectName").style.display = "inline";
		return;
	}

	var f = document.frm;	
	if ( isEmpty(f.newProjectName.value)) {
		alert("새로 저장할 프로젝트명을 입력하세요.");
		f.newProjectName.focus();
		return;
	}
	f.action = "projectProcSaveAs.jsp";
	f.submit();
}


$(document).ready(function() { 
	var options = { 
        beforeSubmit:  showRequest,  // pre-submit callback 
        success:       showResponse,  // post-submit callback 
		url:       'projectActivityUpload.jsp',         // override for form's 'action' attribute 
        dataType:  'json',        // 'xml', 'script', or 'json' (expected server response type) 
        clearForm: true,        // clear all form fields after successful submit 
        resetForm: true        // reset the form after successful submit 
    }; 
	var options1 = { 
	        target:        '#output2',   // target element(s) to be updated with server response 
	        beforeSubmit:  showRequest,  // pre-submit callback 
	        success:       showResponse,  // post-submit callback 
			url:       'projectImageUpload.jsp',         // override for form's 'action' attribute 
	        dataType:  'json',        // 'xml', 'script', or 'json' (expected server response type) 
	        clearForm: true,        // clear all form fields after successful submit 
	        resetForm: true        // reset the form after successful submit 
	    }; 

	$('#activityFileForm').submit(function() { 
        $(this).ajaxSubmit(options); 
        return false; 
    }); 
	
	$('#imageFileForm').submit(function() { 
        $(this).ajaxSubmit(options1); 
        return false; 
    }); 
	
	// pre-submit callback 
	function showRequest(formData, jqForm, options) { 
	    var queryString = $.param(formData); 
	    return true; 
	} 
	 
	// post-submit callback 
	function showResponse(responseText, statusText, xhr, $form)  { 
		document.getElementById("preImage").src = "<%=sc.get("imageBanner.file.url")%>/"+responseText.filename;
		document.getElementById("tempImage").value = responseText.filename;
		
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
});

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

function printActivity(data){
	for(var i=0;i<data.activity.length;i++){
		addCol(data.activity[i]);
	}
}

function sampleDownload(){
	location.href = "/upload/activity_sample.xlsx";
}

function groupSelect(){
	var seq = document.getElementById("vGroupSeq").value;
	$.getJSON('/admin/vocabulary/vocabularyAjaxList.jsp?seq='+seq, null, function(data) {

		if(data.word.length!=0){
			printWord(data);
		}
		else{
			alert("어휘가 없습니다.");
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
		alert("어휘를 입력하세요.");
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
			url : "../vocabulary/vocabularyProc.jsp",
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
		url : "../vocabulary/vocabularyCheck.jsp",
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



<div class="top_title">프로젝트 Activity / 어휘 등록 (Step 02)</div>


<div id="form_warp">
	<dl>
		<%
			if(sGroup.equals("0")){
		%>
		<dt class="inpt_dt">그룹</dt>
		<dd class="inpt_dd"><%=sbufSelect%><input type="hidden" name="groupSeq" id="groupSeq" value="<%=groupSeq%>" /></dd>
		<%
			}
			else{
		%>
			<input type="hidden" name="groupSeq" id="groupSeq" value="<%=sGroup%>" />
		<%
			}
		%>

		<dt class="inpt_dt">프로젝트명</dt>
		<dd class="inpt_dd">
			<%=projectName%>
		</dd>

		<dt class="inpt_dt" style="height:55px;">프로젝트 설명</dt>
		<dd class="inpt_dd" style="height:55px;">
			<%=projectDesc%>
		</dd>

		<dt class="inpt_dt">프로젝트 기간</dt>
		<dd class="inpt_dd">
			<%=startDate%> ~ <%=endDate%>
		</dd>
		
		<dt class="inpt_dt" style="height:100px;">이미지</dt>
		<dd class="inpt_dd" style="height:100px;">
			<img name="preImage" id="preImage" src="<%=sc.get("imageBanner.file.url")%>/<%=image%>" height="90" />
		</dd>

	</dl>         
</div>

<div id="form_warp">
	<dl>
		<dt class="inpt_dt">Activity 업로드</dt>
		<dd class="inpt_dd">
			<form name="activityFileForm" id="activityFileForm" action="projectActivityUpload.jsp" method="post" enctype="multipart/form-data">
				<input type="file" id="filename" name="filename" value="" size="15"/> <input type="submit" class="button blue" value="업로드" style="width:50px"/>
				&nbsp;&nbsp;&nbsp;<input type="button" class="button white" value="샘플파일 다운로드" style="width:120px" onclick='sampleDownload()'/>
			</form>
		</dd>
		<dt class="inpt_dt">경험어휘 그룹</dt>
		<dd class="inpt_dd">
			<%=sbufVocabulary%> 
			<input type="button" onclick="groupWordListPopup();" value="경험어휘 그룹 내용 보기" class="button blue" style="width:145px;" />
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


function addCol(activityText){
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
//			$(this).append('<th><input type="text" name="activityName'+tds+'" id="activityName'+tds+'" size="10" value="'+activityText+'" title="'+activityText+'" onchange="ovrlapChk(this)"/><br/><input type="checkbox" id="allCheck'+tds+'" checked onclick="checkAll()" /><img src="/images/button/pre_btn.png" onclick="left(this)"><img src="/images/button/next_btn.png" onclick="right(this)"><img src="/images/button/del_btn.png" onclick="colRemove(this)"></th></div>');
			$(this).append('<th><input type="text" name="activityName" id="activityName'+tds+'" size="10" value="'+activityText+'" title="'+activityText+'" onchange="ovrlapChk(this)"/><br/><input type="checkbox" id="allCheck'+tds+'" checked onclick="checkAll()" /><img src="/images/button/pre_btn.png" onclick="left(this)"><img src="/images/button/next_btn.png" onclick="right(this)"><img src="/images/button/del_btn.png" onclick="colRemove(this)"></th>');
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


//			html+='<td><input type="checkbox" name="checkVal" value="'+i+'-'+rowCount+'"></td>';
			
 			html+='<td><input type="checkbox" name="checkVal"  id="checkVal'+i+'-'+rowCount+'" value="'+i+'-'+rowCount+'" checked></td>';
			
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
        url:"/admin/vocabulary/vocabularyAjaxList.jsp",
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
	var popUrl = "../vocabulary/vocabularyForm2.jsp?seq="+seq;	//팝업창에 출력될 페이지 URL
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
			
// 			alert("iact:"+iact);
// 			alert("act"+act);
			if(iact == act){
				alert("Activity가 중복되었습니다.");
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
		alert("이동할 수 없습니다.");
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
		alert("이동할 수 없습니다.");
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
		alert("이동할 수 없습니다.");
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
		alert("이동할 수 없습니다.");
	}
	else{
		rows.eq(elem.rowIndex).insertBefore(rows.eq(elem.rowIndex - 1));
		moveChangeValue();
	}
}

function rowRemove(myId){
	var elem = myId.parentNode.parentNode;
	if(confirm("Row를 삭제합니다.")){
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
$(window).load(function() {
	/*
     addRow("1");
	 addRow("2");
	 addRow("3");
	 addCol("A");
	 addCol("B");
	 addCol("C");
	 */ 
	
	printActivity(<%=sbufActivity%>);
	printWord(<%=sbufWord%>);
	checkValue();
});
</script>

<form name="frm" method="post">
<input type="hidden" name="seq" value="<%=seq%>"/>
<div style="padding-top:100px;">
<div class="btn_group_left_align" style="float: right">
	<input  type="button" onclick="addCol('');" value="Activity 추가" class="button blue" />
</div>
<br>
<br>
<br>
<div class="activityMatrix" >
<table cellspacing="0" cellpadding="0" class="activityTable" id="activityTable" width="100%">
	<tr>
		<th id="firstColumn">Activity / 경험어휘를 추가하세요.</th>
	</tr>
	
</table>
</div>
</div>


<div class="btn_group_right_align">
	<input type="text" name="newProjectName" id="newProjectName" value="<%=projectName%>-복사본" size="30" style="display:none;vertical-align:-2px;" />
	<input type="button" onclick="goSaveAs();" value="다른이름으로저장" class="button red" style="width:130px;" />
	<input type="button" onclick="document.location.href='projectList.jsp'" value="취소" class="button white" style="width:50px;" />
	<input type="button" onclick="goSubmit();" value="저장" class="button black" style="width:50px;" />
</div>
<form>

<%@ include file="/include/footerAdmin.jsp" %>
<%@ include file="/include/footer.jsp" %>