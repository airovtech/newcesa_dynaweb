<%@ page language="java" contentType="text/html; charset=utf-8"%><%@ include file="/include/header.jsp" %><%@ include file="/include/needAdminLogin.jsp" %><%
	

	String groupSeq = StringUtils.defaultString(request.getParameter("groupSeq"));
	String seq = StringUtils.defaultString(request.getParameter("seq"));

	RowSetMapper cRowSet = null;
	String mode = "Modify";
	String word ;
	log.debug("groupSeq : "+groupSeq);
	log.debug("seq : "+seq);
	ArrayList arrData = new ArrayList();

	StringBuffer sbufTableChecked = new StringBuffer();
	StringBuffer sbufTable = new StringBuffer();
	int count = 0;

	try{

		cRowSet = VocabularyDAO.getInstance().getGroupSubList(seq);

		while(cRowSet.next()){
			arrData.add(cRowSet.getString("vocabulary_seq"));
		}

		//어휘 가져오기
		cRowSet = VocabularyDAO.getInstance().getVocabularyList(groupSeq);
		sbufTableChecked.append("<div style='padding-top:20px;padding-bottom:10px;font-weight:bold'>Selected vocabulary</div>");
		sbufTableChecked.append("<table cellspacing='0' cellpadding='0' class='layerTable'>");
		sbufTableChecked.append("<colgroup>");
		sbufTableChecked.append("<col width='100px' />");
		sbufTableChecked.append("<col width='200px'/>");
		sbufTableChecked.append("<col width='100px'/>");
		sbufTableChecked.append("<col width='100px' />");
		sbufTableChecked.append("<col width='200px'/>");
		sbufTableChecked.append("<col width='100px'/>");
		sbufTableChecked.append("</colgroup>");
		sbufTableChecked.append("<thead>");
		sbufTableChecked.append("<tr>");
		sbufTableChecked.append("<th>No.</th>");
		sbufTableChecked.append("<th colspan=2>Experience vocabulary</th>");
		sbufTableChecked.append("<th>No.</th>");
		sbufTableChecked.append("<th colspan=2>Experience vocabulary</th>");
		sbufTableChecked.append("</tr>");
		sbufTableChecked.append("</thead>");
		sbufTableChecked.append("<tbody>");
		while(cRowSet.next()){

			if(arrData.contains(cRowSet.getString("seq"))){
			
				count++;
				if(count%2==1){
					sbufTableChecked.append("<tr> \n");
				}
				word=cRowSet.getString("word");
				sbufTableChecked.append("<td>"+count+"<input type='hidden' id='hid_"+cRowSet.getString("seq")+"' value='"+cRowSet.getString("word")+"'><input type='hidden' id='shid_"+cRowSet.getString("seq")+"' value="+groupSeq+"></td> \n");
				sbufTableChecked.append("<td><input type='checkbox' name='checkValue' value='"+cRowSet.getString("word")+"' seq='"+cRowSet.getString("seq")+"' style='vertical-align:-2px' "+(arrData.contains(cRowSet.getString("seq")) ? "checked" : "" )+"> "+"<input size=18 readOnly style='border:0' id='"+cRowSet.getString("seq")+"' name='"+cRowSet.getString("seq")+"'type='text' onchange='duplCheck("+cRowSet.getString("seq")+");'  value='"+cRowSet.getString("word")+"'</td> \n");
				sbufTableChecked.append("<td onmouseover='modiover("+cRowSet.getString("seq")+");' onmouseout='modiout("+cRowSet.getString("seq")+");'><input type='button' id='btm_"+cRowSet.getString("seq")+"' style='display:none;' name='btm_"+cRowSet.getString("seq")+"'onclick='modi("+cRowSet.getString("seq")+");' value=' modify ' class='button white' /><input type='button' id='bts_"+cRowSet.getString("seq")+"' name='bts_"+cRowSet.getString("seq")+"'onclick='vsave("+cRowSet.getString("seq")+");' value=' save ' style='display:none; float:left;' class='button white' /><input type='button' id='btc_"+cRowSet.getString("seq")+"' name='btc_"+cRowSet.getString("seq")+"'onclick='cancel("+cRowSet.getString("seq")+");' value=' cancel ' style='display:none; float:left;' class='button white' /></td> \n");
				if(count%2==0){
					sbufTableChecked.append("</tr> \n");
				}
			}
		}
		
		if(count==0){
			if("0".equals(groupSeq)){
				sbufTableChecked.append("<tr><td colspan='6'>Select a group.</td></tr>");
			}
			else{
				sbufTableChecked.append("<tr><td colspan='6'>There is no registration vocabulary.</td></tr>");
			}
		}
		else{
			if(count%2==1){
				sbufTableChecked.append("<td>&nbsp;</td> \n");
				sbufTableChecked.append("<td>&nbsp;</td> \n");
				sbufTableChecked.append("<td>&nbsp;</td> \n");
				sbufTableChecked.append("</tr> \n");
			}
		}
		sbufTableChecked.append("</tbody>");
		sbufTableChecked.append("</table>");




		count=0;
		cRowSet.beforeFirst();
		sbufTable.append("<div style='padding-top:20px;padding-bottom:10px;font-weight:bold'>Additional vocabulary</div>");
		sbufTable.append("<table cellspacing='0' cellpadding='0'   class='layerTable'>");
		sbufTable.append("<colgroup>");
		sbufTable.append("<col width='100px' />");
		sbufTable.append("<col width='200px'/>");
		sbufTable.append("<col width='100px'/>");
		sbufTable.append("<col width='100px' />");
		sbufTable.append("<col width='200px'/>");
		sbufTable.append("<col width='100px'/>");
		sbufTable.append("</colgroup>");
		sbufTable.append("<thead>");
		sbufTable.append("<tr>");
		sbufTable.append("<th>No.</th>");
		sbufTable.append("<th colspan=2>Experience vocabulary</th>");
		sbufTable.append("<th>No.</th>");
		sbufTable.append("<th colspan=2>Experience vocabulary</th>");
		sbufTable.append("</tr>");
		sbufTable.append("</thead>");
		sbufTable.append("<tbody>");

		while(cRowSet.next()){
			if(!arrData.contains(cRowSet.getString("seq"))){	
				count++;
				if(count%2==1){
					sbufTable.append("<tr> \n");
				}
				
				sbufTable.append("<td>"+count+"<input type='hidden' id='hid_"+cRowSet.getString("seq")+"' value='"+cRowSet.getString("word")+"'><input type='hidden' id='shid_"+cRowSet.getString("seq")+"' value="+groupSeq+"></td> \n");
				sbufTable.append("<td><input type='checkbox' name='checkValue' value='"+cRowSet.getString("word")+"' seq='"+cRowSet.getString("seq")+"' style='vertical-align:-2px' "+(arrData.contains(cRowSet.getString("seq")) ? "checked" : "" )+"> "+"<input size=18 readOnly style='border:0' id='"+cRowSet.getString("seq")+"' name='"+cRowSet.getString("seq")+"'type='text' onchange='duplCheck("+cRowSet.getString("seq")+");'  value='"+cRowSet.getString("word")+"'</td> \n");
				sbufTable.append("<td onmouseover='modiover("+cRowSet.getString("seq")+");' onmouseout='modiout("+cRowSet.getString("seq")+");'><input type='button' id='btm_"+cRowSet.getString("seq")+"' name='btm_"+cRowSet.getString("seq")+"'onclick='modi("+cRowSet.getString("seq")+");'style='display:none;' value=' modify ' class='button white' /><input type='button' id='bts_"+cRowSet.getString("seq")+"' name='bts_"+cRowSet.getString("seq")+"'onclick='vsave("+cRowSet.getString("seq")+");' value=' save ' style='display:none; float:left;' class='button white' /><input type='button' id='btc_"+cRowSet.getString("seq")+"' name='btc_"+cRowSet.getString("seq")+"'onclick='cancel("+cRowSet.getString("seq")+");' value=' cancel ' style='display:none; float:left;' class='button white' /></td> \n");
				
				if(count%2==0){
					sbufTable.append("</tr> \n");
				}
			}
		}
		
		if(count==0){
			if("0".equals(groupSeq)){
				sbufTable.append("<tr><td colspan='6'>Select a group.</td></tr>");
			}
			else{
				sbufTable.append("<tr><td colspan='6'>There is no registration vocabulary.</td></tr>");
			}
		}
		else{
			if(count%2==1){
				sbufTable.append("<td>&nbsp;</td> \n");
				sbufTable.append("<td>&nbsp;</td> \n");
				sbufTable.append("<td>&nbsp;</td> \n");
				sbufTable.append("</tr> \n");
			}
		}
		sbufTable.append("</tbody>");
		sbufTable.append("</table>");
		sbufTable.append("<div style='padding-top:20px;padding-bottom:10px;text-align:center;font-weight:bold'><input style type='button' onclick='goWordCheck();' value='Select Experience vocabulary' class='button blue' style='width:145px;' /> <input type='button' onclick='layerClose();' value='Close' class='button white' style='width:65px;' /><div  style='float: right'><input type='button' onclick='vocabularyAddPopup("+seq+");' value='Add' class='button white' style='width:33px;''/></div></div>");

		

	}
	catch(Exception e){
		log.debug("Exception:"+e);
	}
	out.println(sbufTableChecked.toString());
	out.println(sbufTable.toString());
%><%@ include file="/include/footer.jsp" %>
