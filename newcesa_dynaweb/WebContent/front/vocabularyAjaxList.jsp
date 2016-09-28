<%@ page language="java" contentType="text/html; charset=utf-8"%><%@ include file="/include/header.jsp" %><%
	

	String activityIndex = StringUtils.defaultString(request.getParameter("activityIndex"));
	String activityName = StringUtils.defaultString(request.getParameter("activityName"));
	String isEnd = StringUtils.defaultString(request.getParameter("isEnd"));

	
	//log.debug("activityIndex : "+activityIndex);
	//log.debug("activityName : "+activityName);
	//log.debug("isEnd : "+isEnd);
	
	RowSetMapper cRowSet = null;
	
	//TcpIpClient client = new TcpIpClient(Byte.parseByte(activityIndex));
	
	List arrData = new ArrayList();

	StringBuffer sbufTable = new StringBuffer();

	int count = 0;
	int rowCount = 0;
	int colCount = 0;
	int totalCount = 0;
	
	String btnImage = "";
	int checkTempData = 0;

	String etcWord = "";
	int etcCheck = 0;

	try{
		
		if(isEnd.equals("Y")){
			sbufTable.append("<div style=\"padding-bottom:50px;padding-top:80px;text-align:center\"><img src=\"/img/front/end_img.png\" width=\"40%\" /></div>");
			sbufTable.append("<div style=\"padding-bottom:50px;text-align:center\"></div>");
		}
		else{
			

			cRowSet = MemberDAO.getInstance().getMemberCheckValueDetail(sMemberId, activityName, sProjectSeq);
			while(cRowSet.next()){

				if(cRowSet.getString("add_yn").equals("Y")){
					etcWord = cRowSet.getString("word");
					etcCheck = cRowSet.getInt("check_value");
				}
				else{
					arrData.add(count, cRowSet.getInt("check_value"));
					count++;
				}
			}
			count = 0;

			cRowSet = ProjectDAO.getInstance().projectActivityWordFrontList(sProjectSeq, activityIndex);

			totalCount = cRowSet.size();

			while(cRowSet.next()){
				colCount = 1;
				rowCount++;
				
				if(totalCount/2 < rowCount){
					btnImage = "g";
				}
				else{
					btnImage = "b";
				}
				
				if(arrData.size()>=rowCount){
					checkTempData = (Integer)arrData.get(rowCount-1);
				}
				else{
					checkTempData = 0;
				}
				
				sbufTable.append("<input type=\"hidden\" id=\"checked_"+rowCount+"\" name=\"checked_"+rowCount+"\" value=\""+checkTempData+"\" /> \n");
				sbufTable.append("<input type=\"hidden\" id=\"word\" name=\"word\" value=\""+cRowSet.getString("word")+"\" /> \n");
				sbufTable.append("<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" class=\"wordTable\"> \n");
				sbufTable.append("<colgroup><col width=\"4%\"/><col width=\"92%\"/><col width=\"4%\"/></colgroup> \n");
				sbufTable.append("<tr> \n");
				sbufTable.append("	<td></td> \n");
				sbufTable.append("	<td valign=\"top\"> \n");
				sbufTable.append("		<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"> \n");
				sbufTable.append("			<colgroup> \n");
				sbufTable.append("				<col width=\"18%\"/><col width=\"3%\"/><col /><col width=\"3%\"/><col /><col width=\"3%\"/><col /><col width=\"3%\"/><col /><col width=\"3%\"/><col /><col width=\"3%\"/> \n");
				sbufTable.append("			</colgroup> \n");
				sbufTable.append("			<tr> \n");
				sbufTable.append("				<td class=\"td_bold\">"+cRowSet.getString("word")+"</td> \n");


				for(int i=1;i<=5;i++){
					sbufTable.append("				<td><img src=\"/img/front/18_blank.png\" width=\"9\" /></td> \n");
					sbufTable.append("				<td valign=\"middle\" style=\"text-align:center;\"> \n");			
					
					
					if(checkTempData==i){
						sbufTable.append("					<img id=\"div"+(colCount)+"_"+rowCount+"\" class=\"img\" src=\"/img/front/"+btnImage+"_0"+i+"_check.png\" onclick=\"checkValue('"+(colCount++)+"_"+rowCount+"')\"/> \n");
						
					}
					else{
						sbufTable.append("					<img id=\"div"+(colCount)+"_"+rowCount+"\" class=\"img\" src=\"/img/front/"+btnImage+"_0"+i+".png\" onclick=\"checkValue('"+(colCount++)+"_"+rowCount+"')\"/> \n");
					}


					sbufTable.append("				</td> \n");
				}

				sbufTable.append("				<td><img src=\"/img/front/18_blank.png\" width=\"9\" /></td> \n");
				sbufTable.append("			</tr> \n");
				sbufTable.append("		</table> \n");
				sbufTable.append("	</td> \n");
				sbufTable.append("	<td></td> \n");
				sbufTable.append("</tr> \n");
				sbufTable.append("</table> \n");
			}
			
			rowCount++;
			colCount = 1;
			//log.debug("last rowCount : "+rowCount);
			//log.debug("last colCount : "+colCount);

			
			//log.debug("etcWord : "+etcWord);
			//log.debug("etcCheck : "+etcCheck);


			
			

			sbufTable.append("<div id=\"etcInputDiv\" style=\"display:"+(StringUtils.isEmpty(etcWord) ? "none" : "block" )+"\"> \n");
			sbufTable.append("<input type=\"hidden\" id=\"checked_"+rowCount+"\" name=\"checked_"+rowCount+"\" value=\""+etcCheck+"\" /> \n");
			sbufTable.append("<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" class=\"wordTable\"> \n");
			sbufTable.append("<colgroup><col width=\"4%\"/><col width=\"92%\"/><col width=\"4%\"/></colgroup> \n");
			sbufTable.append("<tr> \n");
			sbufTable.append("	<td></td> \n");
			sbufTable.append("	<td valign=\"top\"> \n");
			sbufTable.append("		<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"> \n");
			sbufTable.append("			<colgroup> \n");
			sbufTable.append("				<col width=\"18%\"/><col width=\"3%\"/><col /><col width=\"3%\"/><col /><col width=\"3%\"/><col /><col width=\"3%\"/><col /><col width=\"3%\"/><col /><col width=\"3%\"/> \n");
			sbufTable.append("			</colgroup> \n");
			sbufTable.append("			<tr> \n");
			sbufTable.append("				<td class=\"td_bold\"><input type=\"text\" name=\"add_word\" value=\""+etcWord+"\" style=\"height:25px;width:45px;\"/></td> \n");


			for(int i=1;i<=5;i++){
				sbufTable.append("				<td><img src=\"/img/front/18_blank.png\" width=\"9\" /></td> \n");
				sbufTable.append("				<td valign=\"middle\" style=\"text-align:center;\"> \n");
				if(etcCheck == i){
					sbufTable.append("					<img id=\"div"+(colCount)+"_"+rowCount+"\" class=\"img\" src=\"/img/front/y_0"+i+"_check.png\" onclick=\"checkValue('"+(colCount++)+"_"+rowCount+"')\"/> \n");
					sbufTable.append("				</td> \n");
				}
				else{
					sbufTable.append("					<img id=\"div"+(colCount)+"_"+rowCount+"\" class=\"img\" src=\"/img/front/y_0"+i+".png\" onclick=\"checkValue('"+(colCount++)+"_"+rowCount+"')\"/> \n");
					sbufTable.append("				</td> \n");
				}
			}


			sbufTable.append("				<td><img src=\"/img/front/18_blank.png\" width=\"9\" /></td> \n");
			sbufTable.append("			</tr> \n");
			sbufTable.append("		</table> \n");
			sbufTable.append("	</td> \n");
			sbufTable.append("	<td></td> \n");
			sbufTable.append("</tr> \n");
			sbufTable.append("</table> \n");
			sbufTable.append("</div> \n");


			
			
			
			
			
			
			
			
			sbufTable.append("<div id=\"etcBtnDiv\" style=\"display:padding-top:10px;\"> \n");
			sbufTable.append("<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"margin-top:10%;\"> \n");
			sbufTable.append("<colgroup><col width=\"2%\"/><col width=\"92%\"/><col width=\"6%\"/></colgroup>\n");
			sbufTable.append("<tr> \n");
			sbufTable.append("	<td valign=\"top\" align=\"left\"> \n");
			sbufTable.append("	<input type=\"button\" onclick=\"inputEtc();\" value=\"Etc\" class=\"button green\" style=\"font-size:20px;font-weight:bold; font-family:Malgun Gothic, Tahoma, Verdana, Arial, Helvetica; width:155px; height:40px;\" /> \n");
			
			sbufTable.append("	</td> \n");
			sbufTable.append("	<td></td> \n");
			sbufTable.append("	<td style=\"text-align:right;\" valign=\"top\"> \n");
			sbufTable.append("	<input type=\"button\" onclick=\"end();\" value=\"END\" class=\"button green\" style=\"font-size:20px; font-weight:bold; font-family:Malgun Gothic, Tahoma, Verdana, Arial, Helvetica; width:155px; height:40px;\" /> \n");
			sbufTable.append("	</td> \n");
			sbufTable.append("</tr> \n");
			sbufTable.append("</table> \n");
			sbufTable.append("</div> \n");
			
			sbufTable.append("<input type=\"hidden\" id=\"valueCount\" name=\"valueCount\" value=\""+totalCount+"\" /> \n");
		}

	}
	catch(Exception e){
		log.debug("Exception:"+e);
	}

	out.println(sbufTable.toString());


%><%@ include file="/include/footer.jsp" %>
