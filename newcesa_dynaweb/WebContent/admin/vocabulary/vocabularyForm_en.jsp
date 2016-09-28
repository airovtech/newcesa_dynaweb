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
<%@ include file="/include/headerAdmin.jsp" %>
<%
	m1 = 2;
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
		alert("Please enter the vocabulary.");
		f.word.focus();
		return;
	} else if ( f.checkWord.value != "1")	{
		alert("Please duplicate check vocabulary.");
		return;
	}


	f.action = "vocabularyProc_en.jsp";
	f.submit();
}

function duplCheck(checkWord) {
	var groupSeq = document.frm.groupSeq.value;
	var paramData = $("#frm").serialize();
	//alert(groupSeq);
	/*
	$.getJSON('vocabularyCheck.jsp', paramData, function(data) {
		if(data.code == 0)	{
			$("#checkWord").val(1);
		}
		alert(data.msg);
	});
	*/
	$.ajax({

		type : "POST",

		url : "vocabularyCheck_en.jsp",

		data : paramData,

		dataType : "json",

		success : function(data){

			if(data.code == 0)	{
				$("#checkWord").val(1);
			}
			alert(data.msg);

		}

		});
	
}
</script>

<div class="top_title">Vocabulary <%="".equals(seq) ? "Registration" : "Revise"%></div>

<form name="frm" id="frm" method="post" action="">
<div>
	<input type="hidden" name="checkWord" id="checkWord" value="" />
	<input type="hidden" name="mode" value="<%=mode%>" />
	<input type="hidden" name="seq" value="<%=seq%>" />
</div>
<div id="form_warp">
	<dl>
		<dt class="inpt_dt">Vocabulary</dt>
		<dd class="inpt_dd">
			<input type="text" name="word" id="word" value="<%=word%>" maxlength="20" onchange="$('#checkWord').val('');" />
			<input type="button" onclick="duplCheck($('#word').val())" value="Duplicate Check" class="button white" />
		</dd>
		<%
			if(sGroup.equals("0")){
		%>
		<dt class="inpt_dt">Group</dt>
		<dd class="inpt_dd"><%=sbufSelect%></dd>
		<%
			}
			else{
		%>
			<input type="hidden" name="groupSeq" id="groupSeq" value="<%=sGroup%>" />
		<%
			}
		%>
	</dl>         
</div>

</form>

<div class="btn_group_right_align">
	<input type="button" onclick="document.location.href='vocabularyList_en.jsp'" value="cancel" class="button white" style="width:50px;" />
	<input type="button" onclick="goSubmit();" value="save" class="button black" style="width:50px;" />
</div>

<%@ include file="/include/footerAdmin.jsp" %>
<%@ include file="/include/footer.jsp" %>
