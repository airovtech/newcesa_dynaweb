<%
	/*============================================================================
	 * @ Description : 관리자 등록시 ID 체크
	 *
	 * 작성일 : 2011.04.18
	 * 작성자 : 이정순
	 ============================================================================*/
%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/header.jsp" %>
<%
	RowSetMapper cRowSet = null;
	String message = "success";
	boolean result = false;
	int resultCount = 0;

	int valueCount = Integer.parseInt(StringUtils.defaultString(request.getParameter("valueCount"),"0"));
	String rowId		= StringUtils.defaultString(request.getParameter("rowId"));
	String activity = StringUtils.defaultString(request.getParameter("activity"), "");
	String add_word = StringUtils.defaultString(request.getParameter("add_word"), "");
	
	String[] word = request.getParameterValues("word");

	String checkValue = "";
	List params = null;
	//log.debug("valueCount : "+valueCount);
	//log.debug("activity : "+activity);

	//MemberDAO.getInstance().delMemberCheckValue(sMemberId, activity, sProjectSeq);
	cRowSet=MemberDAO.getInstance().getMemberCheckValueDetail(sMemberId,activity,sProjectSeq);
	
	
	for(int i=1;i<=valueCount;i++){

		log.debug("word : "+word[(i-1)]);
		params = new ArrayList();

		params.add(0, sProjectSeq);
		params.add(1, activity);
		params.add(2, word[i-1]);
		params.add(3, sMemberId);
		checkValue = StringUtils.defaultString(request.getParameter("checked_"+i));
		
		if(StringUtils.isEmpty(checkValue)){
			
			checkValue = "0";
			
		}
		params.add(4, checkValue);

		params.add(5, "N");
		params.add(6, ""+i);

		//log.debug("value : "+StringUtils.defaultString(request.getParameter("checked_"+i),"0"));
		if(cRowSet.next()){
			System.out.println("----------look at me if------------------------" + params.get(6));
			/* activity word가 변경되었을 경우 새로운 word를 insert */
			RowSetMapper info_RowSet = MemberDAO.getInstance().checkMemberCheckInfo(params);
			if(info_RowSet.size() == 0) {
				MemberDAO.getInstance().regMemberCheckValue2(params);
				resultCount++;
			} else {
				if(MemberDAO.getInstance().updateMemberCheckValue(params)){
					resultCount++;
				}
			}
		}else{
			System.out.println("----------look at me else------------------------" + params.get(6));
			MemberDAO.getInstance().regMemberCheckValue2(params);
			/*
			if(MemberDAO.getInstance().regMemberCheckValue(params)){
				resultCount++;
			}*/
		}
		
	}

	if(!StringUtils.isEmpty(add_word)){
		//log.debug("word : "+add_word);
		//log.debug("value : "+StringUtils.defaultString(request.getParameter("checked_"+(valueCount+1))));

		params = new ArrayList();
		params.add(0, sProjectSeq);
		params.add(1, activity);
		params.add(2, add_word);
		params.add(3, sMemberId);

		checkValue = StringUtils.defaultString(request.getParameter("checked_"+(valueCount+1)));
		if(StringUtils.isEmpty(checkValue)){
			checkValue = "0";
		
		}
		params.add(4, checkValue);
		params.add(5, "Y");
		params.add(6, ""+(valueCount+1));
		
		if(cRowSet.next()){
			System.out.println("값이 있습니다.");
		}else{
			if(MemberDAO.getInstance().regMemberCheckValue(params)){
				resultCount++;
			}
		}
		
	}

	if(StringUtils.isEmpty(add_word)){
		if(resultCount == valueCount){
			message = "success";
		}
		else{
			message = "fail";
		}
	}
	else{
		if(resultCount == (valueCount+1)){
			message = "success";
		}
		else{
			message = "fail";
		}
	}
	out.println("{\"result\":\""+message+"\"}");
%>
<%@ include file="/include/footer.jsp" %>
