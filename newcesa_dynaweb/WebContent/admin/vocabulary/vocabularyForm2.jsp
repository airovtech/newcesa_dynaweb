<%
	/*============================================================================
	 * @ Description : 관리자 정보 등록, 수정 폼
	 *
	 * 작성일 : 2011.04.18
	 * 작성자 : 이정순
	 ============================================================================*/
%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/header.jsp" %>
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
</head>

<body>
	<div><!-- all 시작 -->
	
<%
	m1 = 2;
	m2 = 1;
	m3 = 1;
%>
<%
	// Params
	String seq = StringUtils.defaultString(request.getParameter("seq"));
	//String currPage = StringUtils.defaultString(request.getParameter("currPage"),"1");
	String mode = "".equals(seq) ? "Create" : "Modify";
	RowSetMapper cRowSet = null;
	
	// Vars
	String word = "";
	String groupSeq = "";


	if(!"".equals(seq)){
		cRowSet = VocabularyDAO.getInstance().getVocabularyDetail(seq);
		
		if(cRowSet.next()){
			word = cRowSet.getString("word");
			groupSeq = cRowSet.getString("user_group");
		}
	}
	

	//그룹 select	1000으로 셋팅
	StringBuffer sbufSelect = new StringBuffer();
	cRowSet = GroupDAO.getInstance().groupList(1000, 1);
	sbufSelect.append("<select name='groupSeq' id='groupSeq'>");
	while(cRowSet.next()){
		if(groupSeq.equals(cRowSet.getString("seq"))){
			sbufSelect.append("<option value='"+cRowSet.getString("seq")+"' selected>"+cRowSet.getString("group_name")+"</option>");
		}
		else{
			sbufSelect.append("<option value='"+cRowSet.getString("seq")+"'>"+cRowSet.getString("group_name")+"</option>");
		}
	}
	sbufSelect.append("</select>");

%>
<script type="text/javascript">
function goSubmit(){
	var f = document.frm;

	if ( isEmpty(f.word.value)) {
		alert("어휘를 입력하세요.");
		f.word.focus();
		return;
	} else if ( f.checkWord.value != "1")	{
		alert("어휘 중복검사를 해주세요.");
		return;
	}else if(f.checkWord.value == "1"){
		//alert("aaaaaseq="+f.seq.value+f.word.value);
		var paramData = "mode=Create"+"&seq="+f.seq.value+"&word="+f.word.value;
		
		/*
		$.getJSON('../vocabulary/vocabularyProc.jsp', paramData, function(data) {
			
		});
		*/
		$.ajax({
			type : "POST",
			url : "vocabularyProc.jsp",
			data : paramData,
			dataType : "json",
			success : function(data){
			}
		});
		opener.groupWordListPopup(); 
		windowClose();
	}
	

	

}


function windowClose(){
	window.close();
	
}
function duplCheck(word) {
	
	var groupSeq = document.frm.groupSeq.value;
	var paramData = "word="+word.value+"&groupSeq="+groupSeq;
	//alert("aa"+groupSeq);
	$.ajax({
		type : "POST",
		url : "vocabularyCheck.jsp",
		data : paramData,
		dataType : "json",
		success : function(data){
			if(data.code==0){
				document.frm.checkWord.value = "1"
			}else if(data.code==2){
				document.frm.word.value=""
			}
			alert(data.msg);
		}
	});
}
</script>
<form name="frm" id="frm" method="post" action="">
<div>
	<input type="hidden" name="checkWord" id="checkWord" value="" />
	<input type="hidden" name="mode" value="<%=mode%>" />
	<input type="hidden" name="groupSeq" value="<%=groupSeq%>" />
	<input type="hidden" name="seq" value="<%=seq%>" />
</div>
<table cellspacing='0' cellpadding='0' class='layerTable' width=100%>
	<tr>
		<th colspan=2>어휘 <%="".equals(seq) ? "등록" : "수정"%></th>
	</tr>
	<tr>
		<td width=20%; style="text-align:center">어휘</td>
		<td><input type="text" name="word" id="word" value="" maxlength="20" />
			<input type="button" onclick="duplCheck(word)" value="중복확인" class="button white" />
		</td>
	</tr>
</table>

</form>

<div style="width:100%; text-align:center; margin-top:5px;">
	<input type="button" onclick="goSubmit();" value="저장" class="button black" style="width:50px;" />
	<input type="button" onclick="window.close();" value="닫기" class="button white" style="width:50px;" />
</div>
</div>
				</div>
			</div><!-- content 끝 -->
		</div><!-- all_content 끝 -->
	</div><!-- all 끝 -->
</body>
</html>
<%@ page language="java" pageEncoding="utf-8"%><%
	}
	catch(Exception e){
		log.fatal(e.getMessage(), e);
	}
	finally{
	}
%>
