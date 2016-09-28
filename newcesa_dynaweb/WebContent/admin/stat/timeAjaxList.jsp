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
	String activityList = StringUtils.defaultString(request.getParameter("activityList"));
	String wordList = StringUtils.defaultString(request.getParameter("wordList"));
	String type = StringUtils.defaultString(request.getParameter("type"));
	
	 java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd / HH시mm분");
	 String today = formatter.format(new java.util.Date());
	 
	//log.debug("userList : "+userList);
	String [] userLists = userList.split(",");
	String [] activityLists = activityList.split(",");
	String [] wordLists = wordList.split(",");
	
	TreeSet ts=new TreeSet();
	ArrayList arrUserList = new ArrayList();
	for(int i=0;i<userLists.length;i++){
		log.debug("userLists : "+userLists[i]);
		arrUserList.add(userLists[i]);
		ts.add(userLists[i]);
	}
	
	ArrayList arrActivityList = new ArrayList();
	for(int i=0;i<activityLists.length;i++){
		log.debug("activityLists : "+activityLists[i]);
		arrActivityList.add(activityLists[i]);
	}
	
	ArrayList arrWordList = new ArrayList();
	for(int i=0;i<wordLists.length;i++){
		log.debug("wordLists : "+wordLists[i]);
		arrWordList.add(wordLists[i]);
	}
	
	//log.debug("size : "+arrUserList.size());


	JSONObject json = new JSONObject();
	JSONObject wordJson = new JSONObject();
	JSONArray items = new JSONArray();
	JSONArray jaPoint = new JSONArray();
	JSONArray chartList = new JSONArray();
	JSONObject etcList = new JSONObject();


	log.debug("count : "+userLists.length);
	//log.debug("type : "+type);

	int userCount = ts.size();
	int point = 0;
	int maxPoint = 0;
	float avg = 0.0f;
	DecimalFormat exFormat = new DecimalFormat("#.#"); 

	RowSetMapper cRowSet = null;
	RowSetMapper pRowSet = null;
	RowSetMapper tRowSet = null;
	RowSetMapper iRowSet = null;


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
		
		sbufTable.append("<div style='font-weight:bold;padding-top:10px;padding-bottom:5px;'>참여인원 : "+userCount+"명 ("+(type.equals("time") ? "시간정보": "평균" )+")&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
		sbufTable.append("<div>날짜/시간 : "+today+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
		
		sbufTable.append("</div>");
		sbufTable.append("</div>");

		//sbufTable.append("<div class=\"btn_group_right_align\" style=\"pading-top:10px;\">");
		//sbufTable.append("</div>");

		sbufTable.append("<table cellspacing=\"0\" cellpadding=\"0\" id=\"resultTable\" class=\"propertiesTable\" style=\"display:none\"> \n");
		
		while(cRowSet.next()){
			arrActivityData.add(tempCol, cRowSet.getString("activity"));
			//System.out.println(tempCol);
			tempCol++;
		}
		
		cRowSet = ProjectDAO.getInstance().projectWordList(projectSeq);

		
		//기타를 리스트를 가져온다.
		sbufTable.append("<tr> \n");
		sbufTable.append("<td>시간</td> \n");

		sbufEtcTable.append("<div style='font-weight:bold;padding-top:10px;padding-bottom:5px;'>시간정보</div>");
		sbufEtcTable.append("<table cellspacing=\"0\" cellpadding=\"0\" id=\"resultTable\" class=\"propertiesTable\"> \n");
		sbufEtcTable.append("<tr> \n");
		sbufEtcTable.append("<th>참가자</th> \n");
		sbufEtcTable.append("<th>Activity</th> \n");
		sbufEtcTable.append("<th>어휘</th> \n");
		sbufEtcTable.append("<th colspan=2>최종 선택 점수/시간</th> \n");
		sbufEtcTable.append("<th colspan=2>수정 점수/시간 정보</th> \n");
		sbufEtcTable.append("<th colspan=2>수정 점수/시간 정보</th> \n");
		sbufEtcTable.append("<th colspan=2>수정 점수/시간 정보</th> \n");
		sbufEtcTable.append("</tr> \n");
		
		

		for(int i=1;i<=tempCol;i++){
			point = 0;
			//System.out.println(projectSeq+"//"+ (String)arrActivityData.get((i-1))+"//"+cRowSet.size()+cRowSet.getString("activity"));
			cRowSet = MemberDAO.getInstance().getMemberCheckedEtcStatPoint1(projectSeq, (String)arrActivityData.get((i-1)));
			
				while(cRowSet.next()){
					
					if(arrUserList.contains(cRowSet.getString("memberid"))&&arrActivityList.contains(cRowSet.getString("activity"))&&arrWordList.contains(cRowSet.getString("word"))){
						//sbufEtcTable.append(cRowSet.getString("memberid")+" - "+(String)arrActivityData.get((i-1))+" - "+cRowSet.getString("word")+ "-"+cRowSet.getString("check_value")+"</br>");
						iRowSet=MemberDAO.getInstance().getMemberCheckedInfo(cRowSet.getString("check_seq"));
						iRowSet.last();
						 int nRecord = iRowSet.getRow();
						 iRowSet.beforeFirst();
						 
						sbufEtcTable.append("<tr> \n");
						sbufEtcTable.append("<td>"+cRowSet.getString("memberid")+"</td> \n");
						sbufEtcTable.append("<td>"+cRowSet.getString("activity")+"</td> \n");
						sbufEtcTable.append("<td>"+cRowSet.getString("word")+"</td> \n");
						if(nRecord==4){
							while(iRowSet.next()){
								sbufEtcTable.append("<td>"+iRowSet.getString("check_value")+"</td> \n");
								sbufEtcTable.append("<td>"+iRowSet.getString("regdate")+"</td> \n");
							}
						}else if(nRecord==3){
							while(iRowSet.next()){
								sbufEtcTable.append("<td>"+iRowSet.getString("check_value")+"</td> \n");
								sbufEtcTable.append("<td>"+iRowSet.getString("regdate")+"</td> \n");
							}
							sbufEtcTable.append("<td colspan=2> </td> \n");
						}else if(nRecord==2){
							while(iRowSet.next()){
								sbufEtcTable.append("<td>"+iRowSet.getString("check_value")+"</td> \n");
								sbufEtcTable.append("<td>"+iRowSet.getString("regdate")+"</td> \n");
							}
							sbufEtcTable.append("<td colspan=2> </td> \n");
							sbufEtcTable.append("<td colspan=2> </td> \n");
						}
						else if(nRecord==1){
							while(iRowSet.next()){
								sbufEtcTable.append("<td>"+iRowSet.getString("check_value")+"</td> \n");
								sbufEtcTable.append("<td>"+iRowSet.getString("regdate")+"</td> \n");
							}
							sbufEtcTable.append("<td colspan=2> </td> \n");
							sbufEtcTable.append("<td colspan=2> </td> \n");
							sbufEtcTable.append("<td colspan=2> </td> \n");
						}else if(nRecord==0){
							while(iRowSet.next()){
								sbufEtcTable.append("<td>"+iRowSet.getString("check_value")+"</td> \n");
								sbufEtcTable.append("<td>"+iRowSet.getString("regdate")+"</td> \n");
							}
							sbufEtcTable.append("<td colspan=2> </td> \n");
							sbufEtcTable.append("<td colspan=2> </td> \n");
							sbufEtcTable.append("<td colspan=2> </td> \n");
							sbufEtcTable.append("<td colspan=2> </td> \n");
						}
						
						
						sbufEtcTable.append("</tr> \n");
						arrEtcWordData.add(etempRow, cRowSet.getString("word"));
						arrEActivityData.add(etempRow, Integer.parseInt(cRowSet.getString("check_value")));
						etempRow++;
						point += cRowSet.getInt("check_value");
						bEtcData = true;
					}
					
				}
			}
		

		

		sbufEtcTable.append("</table> \n");
		sbufEtcTable.append("</div> \n");
		sbufTable.append("</tr> \n");
		sbufTable.append("</table> \n");

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
					items.add(arrPointData.get(arrPointCount));
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

	
	json.put("chartData", chartList);


	//log.debug(json);
	out.println(json);

%>
<%@ include file="/include/footer.jsp" %>
