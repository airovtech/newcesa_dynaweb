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
<%
	// Param
	String mode		= StringUtils.defaultString(request.getParameter("mode"));
	String seq		= StringUtils.defaultString(request.getParameter("seq"));

	String spn		= StringUtils.defaultString(request.getParameter("sbp_project_name"));
	String spp		= StringUtils.defaultString(request.getParameter("sbp_project_puid"));
	
	String activity		= StringUtils.defaultString(request.getParameter("activity"));
	String Info = "";
	boolean resultSBP = false;
	
	/* SBP프로젝트와 연결시켜준다 */
	if(!(spn.equals("") || spp.equals("") || seq.equals(""))) {
		resultSBP = ProjectDAO.getInstance().regProject_SBPProject(spn, spp, seq);
	}
%>
	<script>
		if(<%=resultSBP%>) {
			alert("It has been registered.");
			location.href="projectFormStep02_en.jsp?seq=" + <%=seq%>;
		}
	</script>

	
<% 	
	/* SBP와 연결을 끊는다. */
	String project_seq	= StringUtils.defaultString(request.getParameter("project_seq"));
	String sbp_name	= StringUtils.defaultString(request.getParameter("sbp_name"));
	if(!(project_seq.equals("") || sbp_name.equals(""))) {
		resultSBP = ProjectDAO.getInstance().delProject_Activity(project_seq, sbp_name);
	}
%>
	<script>
		if(<%=resultSBP%>) {
			alert("The SBP connection has been disconnected.");
			location.href="projectFormStep02_en.jsp?seq=" + <%=project_seq%>;
		}
	</script>

<%
	/* SBP Project와 연결을 끊는다. */
	String project_seq2	= StringUtils.defaultString(request.getParameter("project_seq2"));
	if(!(project_seq2.equals(""))) {
		resultSBP = ProjectDAO.getInstance().delProject_SBPProject(project_seq2);	
	}
%>
	<script>
		if(<%=resultSBP%>) {
			alert("The SBP Project connection has been disconnected.");
			location.href="projectFormStep02_en.jsp?seq=" + <%=project_seq2%>;
		}
	</script>




<%
	// proc variable
	String message = "Success";
	List params = new ArrayList();
	boolean result = false;
	
	String[] activityNames = request.getParameterValues("activityName");
	String[] wordNames = request.getParameterValues("wordName");
	String[] checkVals = request.getParameterValues("checkVal");
	String[] activityImages = request.getParameterValues("tempActImage");

	String[] sbp_names			= request.getParameterValues("sbp_name");
	String[] sbp_ids			= request.getParameterValues("sbp_id");
	String[] sbp_activityIds	= request.getParameterValues("sbp_activityId");
	
	int activityIndex = 0;
	int wordIndex = 0;
/*
	try {
		log.debug("-----------------------------------------------");
		if(activityNames!=null){
			//삭제 후 재등록
			ProjectDAO.getInstance().delProjectActivity(seq);

			for(int i=0;i<activityNames.length;i++){
				log.debug(activityNames[i]);
				ProjectDAO.getInstance().regProjectActivity(activityNames[i], seq, "/images/blank.gif".equals(activityImages[i])?"":activityImages[i], sbp_names[i], sbp_ids[i], sbp_activityIds[i]);   // activity를 등록한다.
			}
		}
		log.debug("-----------------------------------------------");
		if(wordNames!=null){
			//삭제 후 재등록
			ProjectDAO.getInstance().delProjectWord(seq);
			for(int i=0;i<wordNames.length;i++){
				log.debug(wordNames[i]);
				ProjectDAO.getInstance().regProjectWord(wordNames[i], seq);
			}
		}
		
		log.debug("-----------------------------------------------");
		if(checkVals!=null){
			
			//삭제 후 재등록
			ProjectDAO.getInstance().delProjectActivityWord(seq);

			for(int i=0;i<checkVals.length;i++){
				log.debug(checkVals[i]);
				
				if(checkVals[i].split("-").length>1){
					activityIndex = Integer.parseInt(checkVals[i].split("-")[0])-1;
					wordIndex = Integer.parseInt(checkVals[i].split("-")[1])-1;

					ProjectDAO.getInstance().regProjectActivityWord(checkVals[i].split("-")[0], checkVals[i].split("-")[1], activityNames[activityIndex], wordNames[wordIndex], seq);
				}
			}
		}
		log.debug("-----------------------------------------------");
*/














	try {
		log.debug("-----------------------------------------------");
		if(activityNames!=null){
			//삭제 후 재등록
			ProjectDAO.getInstance().delProjectActivity(seq);
	
			for(int i=0;i<activityNames.length;i++){
				log.debug(activityNames[i]);
				ProjectDAO.getInstance().regProjectActivity(activityNames[i], seq, "/images/blank.gif".equals(activityImages[i])?"":activityImages[i], sbp_names[i], sbp_ids[i], sbp_activityIds[i]);   // activity를 등록한다.
			}
		}
		log.debug("-----------------------------------------------");
		if(wordNames!=null){
			//삭제 후 재등록
			ProjectDAO.getInstance().delProjectWord(seq);
			for(int i=0;i<wordNames.length;i++){
				log.debug(wordNames[i]);
				ProjectDAO.getInstance().regProjectWord(wordNames[i], seq);
			}
			
			/* activity word를 변경하였을 경우 member_check에 있는 word의 info를 변경해준다.  */
			RowSetMapper word_RowSet = ProjectDAO.getInstance().getProjectActivityWord(seq);
			int wordEqualsCount = 0;
			int whileCount = 0;
			while(word_RowSet.next()) {
				whileCount++;
				String word = word_RowSet.getString("word");
				for(int i=0; i<wordNames.length; i++) {
					if(word.equals(wordNames[i])) {
						wordEqualsCount++;
					}
				}
			}
			if(whileCount != wordEqualsCount) {
				MemberDAO.getInstance().updateMemberCheck(seq);
			}
		}
		
		log.debug("-----------------------------------------------");
		if(checkVals!=null){
			
			//삭제 후 재등록
			ProjectDAO.getInstance().delProjectActivityWord(seq);
	
			for(int i=0;i<checkVals.length;i++){
				log.debug(checkVals[i]);
				
				if(checkVals[i].split("-").length>1){
					activityIndex = Integer.parseInt(checkVals[i].split("-")[0])-1;
					wordIndex = Integer.parseInt(checkVals[i].split("-")[1])-1;
	
					ProjectDAO.getInstance().regProjectActivityWord(checkVals[i].split("-")[0], checkVals[i].split("-")[1], activityNames[activityIndex], wordNames[wordIndex], seq);
				}
			}
			
//			ProjectDAO.getInstance().updateMemberCheck(seq);
/*
			RowSetMapper word_RowSet = ProjectDAO.getInstance().getProjectActivityWord(seq);
			List<String> wordList = new ArrayList<String>();
			while(word_RowSet.next()) {
				wordList.add(word_RowSet.getString("word"));
			}
			ProjectDAO.getInstance().updateMemberCheck(wordList, seq);
			ProjectDAO.getInstance().updateMemberCheck2(wordList, seq);
*/
		}
		log.debug("-----------------------------------------------");












		out.println("<script language='javascript'>");
		out.println("alert('It has been registered.');");
		out.println("self.location.replace('projectList_en.jsp');");
		out.println("</script>");

		
		
	}           
	catch(Exception e){
		log.debug("Exception:"+e);
	} 
%>
<%@ include file="/include/footer.jsp" %>
