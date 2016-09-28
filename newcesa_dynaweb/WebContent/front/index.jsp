<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/header.jsp" %>
<%@ include file="/include/headerFront.jsp" %>
<%
	RowSetMapper cRowSet = null;
	RowSetMapper cRowSetBG = null;
	//sMemberId = (String)session.getAttribute("sMemberId");
	//sMemberSeq = (String)session.getAttribute("sMemberSeq");
	//sProjectSeq = (String)session.getAttribute("sProjectSeq");

	//activity 가져오기
	cRowSet = ProjectDAO.getInstance().projectActivityList(sProjectSeq);
	cRowSetBG  = ProjectDAO.getInstance().getProjectDetail(sProjectSeq);
	//json 으로 만든다.
	//StringBuffer sbufActivityList = new StringBuffer();
	JSONObject activityJson = new JSONObject();
	JSONArray activityItems = new JSONArray();
	JSONArray projectItems = new JSONArray();
	JSONArray imageItems = new JSONArray();
	
	while(cRowSetBG.next()){
		projectItems.add(cRowSetBG.getString("project_name"));
		projectItems.add(cRowSetBG.getString("project_bg"));
		projectItems.add(cRowSetBG.getString("font_size"));
		projectItems.add(cRowSetBG.getString("font_color"));
	}
	
	activityJson.put("projectBG", projectItems);
	activityItems.add("");
	activityItems.add("");
	imageItems.add("empty");
	imageItems.add("empty");
	boolean imageExist = false;
	while(cRowSet.next()){
		//out.println(cRowSet.getString("activity"));
		activityItems.add(cRowSet.getString("activity"));
		String image = cRowSet.getString("activity_image");
		if(!StringUtils.isEmpty(image)) imageExist = true;
		imageItems.add(StringUtils.isEmpty(image)?"empty":sc.get("imageBanner.file.url")+"/"+image);
	}
	activityItems.add("");
	activityItems.add("");
	imageItems.add("empty");
	imageItems.add("empty");
	activityJson.put("activity", activityItems);
	activityJson.put("image", imageItems);
	
	//out.println(activityJson);

%>


<script type="text/javascript">

//global
var myJSONObject = <%=activityJson%>;
var selectedIndex = 2;
function checkValue(value){

	var btn = document.getElementById("div"+value).src;
	var colId = value.split("_")[0];
	var rowId = value.split("_")[1];
	
	//alert("1 : "+document.getElementById("checked_"+rowId).value);
	//alert("2 : "+document.getElementById("checked_"+rowId).value);
	
	if(btn.indexOf("_check")>0){
		for(var i=1;i<=5;i++){
			document.getElementById("div"+i+"_"+rowId).src = btn.split("_")[0]+"_0"+i+".png";
			
		}
		document.getElementById("checked_"+rowId).value = "0";
		
	}
	else{
		for(var i=1;i<=5;i++){
			if(value == ""+i+"_"+rowId){
				document.getElementById("div"+i+"_"+rowId).src = btn.split("_")[0]+"_0"+i+"_check.png";
				document.getElementById("checked_"+rowId).value = colId;
				
				//alert(document.getElementById("checked_"+rowId).value);
			}
			else{
				
				document.getElementById("div"+i+"_"+rowId).src = btn.split("_")[0]+"_0"+i+".png";
			}
		}
		
		//
	}
	setActivitySave();
	setCheckTime(rowId);
	
}
function setCheckTime(rowId){
	
	document.getElementById("activity").value = document.getElementById("activity03").innerHTML;
	var params = $("#actFrm").serialize()+"&rowId="+rowId;
	
	/*
	$.getJSON('regAjax_1.jsp', params, function(data) {
		//alert(data.result);
		
	});
	*/
	$.ajax({
		type:"POST",  
		url:"regAjax_1.jsp",
		data:params,      
		success:function(data){  
			var rdata = eval( '(' + data + ')' );
			//alert(rdata.result);
			if(rdata=="fail"){
				alert("관리자에게 문의하세요.");
			}else if(rdata="success"){
				//alert("저장");
			}
		}
	}); 
	
}
function shiftLeft(){
	//alert("left");
	if(selectedIndex==2){
		//alert("처음입니다.");
		return;
	}

	//$("#activity03").fadeIn(3500);
	$("#mask").fadeTo( 600, 0.3, function(){ 
		 
		
		selectedIndex--;
		printActivity();

		$('#mask').hide();
    });
}
function shiftLeft2(){
	//alert("left");
	if(selectedIndex==2){
		//alert("처음입니다.");
		return;
	}

	//$("#activity03").fadeIn(3500);
	$("#mask").fadeTo( 600, 0.3, function(){ 
		 
		
		selectedIndex--;
		selectedIndex--;
		printActivity();

		$('#mask').hide();
    });
}
function shiftRight(){
	if(myJSONObject.activity.length==(selectedIndex+3)){
		//alert("마지막 입니다."+myJSONObject.activity.length);
		return;
	}
	//$("#activity03").fadeIn(3500);
	$("#mask").fadeTo( 600, 0.3, function(){ 
		
		selectedIndex++;
		printActivity();

		$('#mask').hide(); 
    });

	
}
function shiftRight2(){
	if(myJSONObject.activity.length==(selectedIndex+3)){
		//alert("마지막 입니다.");
		return;
	}
	//$("#activity03").fadeIn(3500);
	$("#mask").fadeTo( 600, 0.3, function(){ 
		
		selectedIndex++;
		selectedIndex++;
		printActivity();

		$('#mask').hide(); 
    });

	
}

function printActivity(){
	var index = 0;
	var startIndex = selectedIndex-2;
	var endIndex = selectedIndex+3;
	var count = 0;
	
	for(var i=startIndex;i<endIndex;i++){
		count++;
		document.getElementById("activity0"+count).innerHTML = myJSONObject.activity[i];
	}
	if(myJSONObject.image[selectedIndex]!='empty'){
		$('.activityImageTarget').attr('src', myJSONObject.image[selectedIndex]);	
	}
	document.getElementById("title").innerHTML = myJSONObject.projectBG[0];
	document.getElementById("title").style.background=myJSONObject.projectBG[1];
	document.getElementById("title").style.fontSize = (myJSONObject.projectBG[2] == '선택' || myJSONObject.projectBG[2] == 'Select the font size') ? '10px' : myJSONObject.projectBG[2];
	document.getElementById("title").style.color = myJSONObject.projectBG[3];
	getWordList();

	
}

function getWordList(){
	var isEnd = "N";

	if(myJSONObject.activity.length==(selectedIndex+3)){
		isEnd = "N";
	}
	var params="activityIndex="+(selectedIndex-1)+"&activityName="+document.getElementById("activity03").innerHTML+"&isEnd="+isEnd;

	$.ajax({
		type:"POST",  
		url:"/front/vocabularyAjaxList.jsp",
		data:params,      
		success:function(args){   
			//$("#result").html(args); 
			document.getElementById("wordList").innerHTML = args;
		}
	}); 
}

function setActivitySave(){
	//alert(document.getElementById("valueCount").value);
	document.getElementById("activity").value = document.getElementById("activity03").innerHTML;
	var params = $("#actFrm").serialize();
	/*
	$.getJSON('regAjax.jsp', params, function(data) {
		//alert(data.result);
		if(data.result=="fail"){
			alert("관리자에게 문의하세요.");
		}
	});
	*/
	$.ajax({
		type:"POST",  
		url:"regAjax.jsp",
		data:params,      
		success:function(data){  
			var rdata = eval( '(' + data + ')' );
			//alert(rdata.result);
			if(rdata=="fail"){
				alert("관리자에게 문의하세요.");
			}else if(rdata="success"){
				//alert("저장");
			}
		}
	}); 
	
}

$(window).load(function() {
	
	if(myJSONObject.activity.length>0){
		printActivity();
		//getWordList();
	}
});

function inputEtc(){
	//document.getElementById("etcBtnDiv").style.display  = "none";
	var count=0;
	document.getElementById("etcInputDiv").style.display  = "block";
}

function end(){
	//alert("종료합니다.");
	location.replace('/login/index.jsp?p='+<%=sProjectSeq%>);
}
</script>
<div id="mask"></div>

<div id="title" align="center">제목을 입력하세요</div>
<div>
	<table cellpadding="0" cellspacing="0" width="100%" >
		<colgroup>
			<col width="12%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="16%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="12%"/>
		</colgroup>
		<tbody>
			<tr>
				<td bgcolor="#9ea7b3" align="left"><a href="#" onclick="shiftLeft();"><img src="/img/front/left_arrow.png" width="100%"/></a></td>
				<td bgcolor="#c5cad1" align="center">
					<a href="#" onclick="shiftLeft2();"><div id="activity01" class="activity_bold_white"></div></a>
				</td>
				<td bgcolor="#ecedf0" align="center">
					<a href="#" onclick="shiftLeft();"><div id="activity02" class="activity_bold_gray"></div></a>
				</td>
				<td bgcolor="#ffffff" align="center" style="border:4px solid #4377f9;">
					<a href="#" onclick=""><div id="activity03" class="activity_bold_black" ></div></a>
				</td>
				<td bgcolor="#ecedf0" align="center">
					<a href="#" onclick="shiftRight();"><div id="activity04" class="activity_bold_gray"></div></a>
				</td>
				<td bgcolor="#c5cad1" align="center">
					<a href="#" onclick="shiftRight2();"><div id="activity05" class="activity_bold_white"></div></a>
				</td>
				<td bgcolor="#9ea7b3" align="right"><a href="#" onclick="shiftRight();"><img src="/img/front/right_arrow.png" width="100%"/></a></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align:center"><img class="activityImageTarget" src="" style="height:160px;padding:3px 0px<%if(!imageExist){%>;display:none<%}%>"/></div>
<div><img src="/img/front/mark.jpg" width="100%" /></div>
<div style="width:100%; height:2px; background:url('/img/front/top_div_bg.png') top left repeat-x;"></div>
<form name="actFrm" id="actFrm" method="post">
<input type="hidden" id="activity" name="activity" value="" />
<div id="wordList" style="width:100%;">

</div>

</form>

<%@ include file="/include/footer.jsp" %>
<%@ include file="/include/footerFront.jsp" %>