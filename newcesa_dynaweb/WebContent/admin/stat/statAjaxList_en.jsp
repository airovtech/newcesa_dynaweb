<%
	/*============================================================================
	 * @ Description : 관리자 관리 프로세스
	 *
	 * 작성일 : 2011.04.18
	 * 작성자 : 이정순
	 ============================================================================*/
%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/header.jsp" %>
<%@ include file="/include/needAdminLogin.jsp" %>
<%@ page import="java.util.*, java.text.*"  %>
<%
	// Param
	String projectSeq = StringUtils.defaultString(request.getParameter("projectSeq"));	
	String userList = StringUtils.defaultString(request.getParameter("userList"));
	
	String type = StringUtils.defaultString(request.getParameter("type"));
	
	 java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd / HH시mm분");
	 String today = formatter.format(new java.util.Date());


	//log.debug("userList : "+userList);
	String [] userLists = userList.split(",");
	int value=0;
	

	ArrayList arrUserList = new ArrayList();
	for(int i=0;i<userLists.length;i++){
		log.debug("userLists : "+userLists[i]);
		arrUserList.add(userLists[i]);
	}
	
	//System.out.println(userLists[3]);
	//log.debug("size : "+arrUserList.size());


	JSONObject json = new JSONObject();
	JSONObject wordJson = new JSONObject();
	JSONArray items = new JSONArray();
	JSONArray jaPoint = new JSONArray();
	JSONArray chartList = new JSONArray();
	JSONArray chartList2 = new JSONArray();
	JSONObject etcList = new JSONObject();


	log.debug("count : "+userLists.length);
	//log.debug("type : "+type);

	int userCount = userLists.length;
	int point = 0;
	int zeroCount = 0;
	int maxPoint = 0;
	float avg = 0.0f;
	DecimalFormat exFormat = new DecimalFormat("#.#"); 

	RowSetMapper cRowSet = null;
	RowSetMapper pRowSet = null;
	RowSetMapper tRowSet = null;
	RowSetMapper sRowSet = null;
	

	ArrayList arrCheckedData = new ArrayList();
	ArrayList arrTotalWordData = new ArrayList();
	ArrayList arrEtcWordData = new ArrayList();
	ArrayList arrActivityData = new ArrayList();
	ArrayList arrEActivityData = new ArrayList();
	ArrayList arrWordData = new ArrayList();
	ArrayList arrPointData = new ArrayList();
	ArrayList arrEtcPointData = new ArrayList();

	//체크 리스트를 가져온다.

	cRowSet = ProjectDAO.getInstance().projectActivityWordList(projectSeq);
	pRowSet = ProjectDAO.getInstance().projectWordList(projectSeq);
	tRowSet = ProjectDAO.getInstance().projectWordTotalList(projectSeq);
	
	
	while(cRowSet.next()){
		arrCheckedData.add(cRowSet.getString("checked_activity")+"_"+cRowSet.getString("checked_word"));
	}
		
	StringBuffer sbufTable = new StringBuffer();
	StringBuffer psnalsbufTable = new StringBuffer();
	StringBuffer sbufEtcTable = new StringBuffer();
	StringBuffer sbufJsonData = new StringBuffer();
	int etempRow = 0;
	int tempRow = 0;
	int tempCol = 0;
	int arrPointCount = 0;
	int etcPointCount = 0;
	boolean bEtcData = false;
	try {
	
		cRowSet = ProjectDAO.getInstance().projectActivityList(projectSeq);

		sbufTable.append("<div style='font-weight:bold;padding-top:10px;padding-bottom:5px;'>Personnel : "+userCount+"Persons ("+(type.equals("sum") ? "Sum": "Average" )+")&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
		sbufTable.append("<div>Date/Time : "+today+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
		sbufTable.append("<input type=\"button\" onclick=\"changeChart('line');\" value=\"Line Charts\" class=\"button white\" style=\"width:80px;\" />&nbsp;&nbsp;");
		sbufTable.append("<input type=\"button\" onclick=\"changeChart('column');\" value=\"Bar Charts\" class=\"button white\" style=\"width:80px;\" />&nbsp;&nbsp;");
		sbufTable.append("<input type=\"button\" onclick=\"changeChart('curve_chart');\" value=\"Choose vocabulary\" class=\"button white\" style=\"width:120px;\" />&nbsp;&nbsp;");
		sbufTable.append("<input type=\"button\" onclick=\"changeChart('all_chart');\" value=\"All the words\" class=\"button white\" style=\"width:80px;\" />&nbsp;&nbsp;");
		sbufTable.append("<input type=\"button\" onclick=\"goDownload();\" value=\"Excel download\" class=\"button black\" style=\"width:100px;\" />");
		
		
		
		sbufTable.append("</div>");
		sbufTable.append("</div>");

		//sbufTable.append("<div class=\"btn_group_right_align\" style=\"pading-top:10px;\">");
		//sbufTable.append("</div>");

		sbufTable.append("<table cellspacing=\"0\" cellpadding=\"0\" id=\"resultTable\" class=\"propertiesTable\"> \n");
		sbufTable.append("<tr> \n");
		sbufTable.append("<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th> \n");


		//activity
		while(cRowSet.next()){
			arrActivityData.add(tempCol, cRowSet.getString("activity"));
			sbufTable.append("<th>"+cRowSet.getString("activity")+"</th> \n");

			

			tempCol++;
		}
		sbufTable.append("</tr> \n");
		

		
		cRowSet = ProjectDAO.getInstance().projectWordList(projectSeq);

		//word 및 point
		while(cRowSet.next()){

			sbufTable.append("<tr> \n");
			sbufTable.append("<td>"+cRowSet.getString("word")+"</td> \n");
			arrWordData.add(tempRow, cRowSet.getString("word"));

			tempRow++;
			for(int i=1;i<=tempCol;i++){
				if(arrCheckedData.contains(i+"_"+tempRow)){
					//점수를 가져온다.
					point = MemberDAO.getInstance().getMemberCheckedStatPoint(projectSeq, userList,(String)arrActivityData.get((i-1)), cRowSet.getString("word"));
					zeroCount = MemberDAO.getInstance().getMemberZeroCheckedCount(projectSeq, userList,(String)arrActivityData.get((i-1)), cRowSet.getString("word"));
					//유저수를 구해서 나눠줄것 userCount=MemberDAO.getInstance().getMemberCheckedStatPoint(projectSeq, userList,(String)arrActivityData.get((i-1)), cRowSet.getString("word"));
					if(type.equals("sum")){
						sbufTable.append("<td>"+point+"</td> \n");
						arrPointData.add(arrPointCount, point);
						
						if(point>=maxPoint){
							maxPoint = point;
						}
					}
					else{
						if(zeroCount==0){
							avg = 0;
							sbufTable.append("<td>"+exFormat.format(avg)+"</td> \n");
							arrPointData.add(arrPointCount, exFormat.format(avg));
						}else{
						avg = (float)point/zeroCount;
						sbufTable.append("<td>"+exFormat.format(avg)+"</td> \n");
						arrPointData.add(arrPointCount, exFormat.format(avg));
						}
					}
					
					arrPointCount++;
				}else{
					sbufTable.append("<td>-</td> \n");
					arrPointData.add(arrPointCount, 0);
					arrPointCount++;
				}
				
			}
		
			sbufTable.append("</tr> \n");
			

		}
		
		//기타를 리스트를 가져온다.
		sbufTable.append("<tr> \n");
		sbufTable.append("<td>기타</td> \n");

		sbufEtcTable.append("<div style='font-weight:bold;padding-top:10px;padding-bottom:5px;'>Other words</div>");
		sbufEtcTable.append("<table cellspacing=\"0\" cellpadding=\"0\" id=\"resultTable\" class=\"propertiesTable\"> \n");
		sbufEtcTable.append("<tr> \n");
		sbufEtcTable.append("<th>participant</th> \n");
		sbufEtcTable.append("<th>Activity</th> \n");
		sbufEtcTable.append("<th>Vocabulary</th> \n");
		sbufEtcTable.append("<th>Scores</th> \n");
		sbufEtcTable.append("</tr> \n");


		for(int i=1;i<=tempCol;i++){
			point = 0;
			cRowSet = MemberDAO.getInstance().getMemberCheckedEtcStatPoint(projectSeq, (String)arrActivityData.get((i-1)));

			while(cRowSet.next()){
				if(arrUserList.contains(cRowSet.getString("memberid"))){
					//sbufEtcTable.append(cRowSet.getString("memberid")+" - "+(String)arrActivityData.get((i-1))+" - "+cRowSet.getString("word")+ "-"+cRowSet.getString("check_value")+"</br>");
					sbufEtcTable.append("<tr> \n");
					sbufEtcTable.append("<td>"+cRowSet.getString("memberid")+"</td> \n");
					sbufEtcTable.append("<td>"+cRowSet.getString("activity")+"</td> \n");
					sbufEtcTable.append("<td>"+cRowSet.getString("word")+"</td> \n");
					sbufEtcTable.append("<td>"+cRowSet.getString("check_value")+"</td> \n");
					sbufEtcTable.append("</tr> \n");
					arrEtcWordData.add(etempRow, cRowSet.getString("word"));
					arrEActivityData.add(etempRow, Integer.parseInt(cRowSet.getString("check_value")));
					etempRow++;
					point += cRowSet.getInt("check_value");
					bEtcData = true;
				}
			}
			
			log.debug("point : "+point);
			if(point>=maxPoint){
				maxPoint = point;
			}

			if(type.equals("sum")){
				sbufTable.append("<td>"+point+"</td> \n");
				arrPointData.add(arrPointCount, point);
			}
			else{


				avg = (float)point/userCount;
				sbufTable.append("<td>"+exFormat.format(avg)+"</td> \n");
				arrPointData.add(arrPointCount, exFormat.format(avg));
			}
			arrPointCount++;
			
		}

		sbufTable.append("</tr> \n");
		sbufTable.append("</table> \n");

		sbufEtcTable.append("</table> \n");
		
		//개별 사용자
// 		for(int n=1;n<=userCount;n++){
			
			
// 			cRowSet = ProjectDAO.getInstance().projectActivityList(projectSeq);
			
			
// 			psnalsbufTable.append("<div style='font-weight:bold;padding-top:10px;padding-bottom:5px;'>참여인원 : "+n+"명"+")&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			
// 			psnalsbufTable.append("</div>");

// 			//psnalsbufTable.append("<div class=\"btn_group_right_align\" style=\"pading-top:10px;\">");
// 			//psnalsbufTable.append("</div>");

// 			psnalsbufTable.append("<table cellspacing=\"0\" cellpadding=\"0\" id=\"resultTable\" class=\"propertiesTable\"> \n");
// 			psnalsbufTable.append("<tr> \n");
// 			psnalsbufTable.append("<th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th> \n");


// 			//activity
// 			while(cRowSet.next()){
// //				arrActivityData.add(tempCol, cRowSet.getString("activity"));
// 				psnalsbufTable.append("<th>"+cRowSet.getString("activity")+"</th> \n");

				

// 				tempCol++;
// 			}
// 			psnalsbufTable.append("</tr> \n");
			
			//word
//  			while(pRowSet.next()){

// 				psnalsbufTable.append("<tr> \n");
// 				psnalsbufTable.append("<td>"+pRowSet.getString("word")+"</td> \n");
// 				arrWordData.add(tempRow, pRowSet.getString("word"));

// 				tempRow++;
			
			
				
// 				psnalsbufTable.append("</tr> \n");
//  			}
//		}

		arrPointCount = 0;
		for(int i=0;i<arrWordData.size();i++){
			wordJson = new JSONObject();
			jaPoint = new JSONArray();
			items = new JSONArray();
			items.add("Activity");
			items.add(arrWordData.get(i));
			jaPoint.add(items);

			//log.debug("================================================");
			for(int j=0;j<arrActivityData.size();j++){

				items = new JSONArray();
				items.add(arrActivityData.get(j));
				if(type.equals("sum")){
					items.add(arrPointData.get(arrPointCount));
					
				}
				else{
					items.add(Float.parseFloat(""+arrPointData.get(arrPointCount)));
				}
				
				arrPointCount++;
				jaPoint.add(items);
			}
			wordJson.put("title", arrWordData.get(i));
			wordJson.put("data",jaPoint);
						
			chartList.add(wordJson);

		}
		
			
		
		////////////chart2
		arrPointCount = 0;
		wordJson = new JSONObject();
		jaPoint = new JSONArray();
		items = new JSONArray();
		items.add("Activity");
		for(int i=0;i<arrWordData.size();i++){
			items.add(arrWordData.get(i));
		}
		items.add("기타");
		jaPoint.add(items);
				
			for(int j=0;j<arrActivityData.size();j++){
				
				items = new JSONArray();
				items.add(arrActivityData.get(j));
				for(int k=0;k<arrWordData.size();k++){
					if(type.equals("sum")){
						items.add(arrPointData.get(arrActivityData.size()*k+j));
						
					}
					else{
						items.add(Float.parseFloat(""+arrPointData.get(arrActivityData.size()*k+j)));
					}
				}
				if(type.equals("sum")){
					items.add(arrPointData.get(arrWordData.size()*arrActivityData.size()+arrPointCount));
				}else{
					items.add(arrPointData.get(arrWordData.size()*arrActivityData.size()+arrPointCount));
				}
				arrPointCount++;
				jaPoint.add(items);
				
			}
			wordJson.put("title", "chart2");
			wordJson.put("data",jaPoint);
						
			chartList2.add(wordJson);
			
		
		
		
		
		//기타 추가
			wordJson = new JSONObject();
			jaPoint = new JSONArray();

			items = new JSONArray();
			items.add("Activity");
	
			items.add("기타");
			jaPoint.add(items);

			//log.debug("================================================");
			for(int j=0;j<arrActivityData.size();j++){

				items = new JSONArray();
				items.add(arrActivityData.get(j));

				if(type.equals("sum")){
					items.add(arrPointData.get(arrWordData.size()*arrActivityData.size()+j));
				}
				else{
					items.add(Float.parseFloat(""+arrPointData.get(arrPointCount)));
				}
			
				arrPointCount++;
				jaPoint.add(items);
			}

			wordJson.put("title", "기타");
			wordJson.put("data", jaPoint);

			chartList.add(wordJson);

////////////////////////////////////////////////////////////////////////////////////////////////		
			arrPointCount = 0;
			for(int i=0;i<arrEtcWordData.size();i++){
				//System.out.println(arrEtcWordData.size()+" "+i);
				wordJson = new JSONObject();
				jaPoint = new JSONArray();
				items = new JSONArray();
				items.add("Activity");
				items.add(arrEtcWordData.get(i));
				jaPoint.add(items);

				//log.debug("================================================");
				for(int j=0;j<1;j++){
					items = new JSONArray();
					items.add(arrActivityData.get(arrPointCount));
					
					if(type.equals("sum")){
						items.add(arrEActivityData.get(arrPointCount)  );
					}
					else{
						items.add(Float.parseFloat(""+arrEActivityData.get(arrPointCount)));
					}
					
					arrPointCount++;
					jaPoint.add(items);
				}
				wordJson.put("title", arrEtcWordData.get(i));
				wordJson.put("data",jaPoint);
							
				chartList.add(wordJson);
				

			}




		/*
	 	while(tRowSet.next()){
		arrTotalWordData.add(tRowSet.getString("word"));
		}


	 	 	ArrayList  total = new ArrayList(arrTotalWordData);
		 	ArrayList  word = new ArrayList(arrWordData);
			Set ovrap = new LinkedHashSet<String>(); 
	
		 	outerLoop :
			for(int n=0;n<arrEtcWordData.size();n++){
				word.add(arrEtcWordData.get(n));
			
				for(int m=0;m<arrTotalWordData.size();m++){
					
					total.add(arrTotalWordData.get(m));
					
				    ovrap.addAll(word);
					
					ovrap.addAll(total);

					ArrayList  intersection = new ArrayList(total); 
					intersection.retainAll(word); 

					ovrap.removeAll(intersection);
					
					arrEtcWordData.addAll(ovrap);
 		
		 			
						for(int i=0;i<arrEtcWordData.size();i++){
							
							wordJson = new JSONObject();
							jaPoint = new JSONArray();

							items = new JSONArray();
							items.add("Activity");
							items.add(arrEtcWordData.get(i));
							
							jaPoint.add(items);
	
								log.debug("================================================");
								for(int j=0;j<arrActivityData.size();j++){
			
									items = new JSONArray();
									items.add(arrActivityData.get(j));
			
									if(type.equals("sum")){

										items.add(arrPointData.get(etcPointCount));
										
									}
									else{
										items.add(Float.parseFloat(""+arrPointData.get(etcPointCount)));
									}
									
									etcPointCount++;
									jaPoint.add(items);
								}
								
								if(i<arrEtcWordData.size()){

								wordJson.put("title", arrEtcWordData.get(i));
								wordJson.put("data",jaPoint);
											
								chartList.add(wordJson); 
								}else {
									break;
								}
								
							}
							break outerLoop;					
						}
					
				}	
		*/
			
	}
	
	catch(Exception e){
		log.debug("admin register Exception:"+e);
	} 

	//out.println(sbufTable);
	json.put("html", sbufTable.toString());
	json.put("htmlPsnal", psnalsbufTable.toString());

	json.put("maxPoint", maxPoint);
	if(bEtcData){
		json.put("htmlEtc", sbufEtcTable.toString());
	}
	else{
		json.put("htmlEtc", "");
	}

	json.put("chartData2", chartList2);
	json.put("chartData", chartList);


	//log.debug(json);
	out.println(json);

%>
<%@ include file="/include/footer.jsp" %>
