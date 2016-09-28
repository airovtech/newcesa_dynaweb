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

	String projectName	= StringUtils.defaultString(request.getParameter("projectName"));
	String projectBG	= StringUtils.defaultString(request.getParameter("projectBG"));
	String fontSize	= StringUtils.defaultString(request.getParameter("fontSize"));
	String fontC	= StringUtils.defaultString(request.getParameter("fontC"));
	String projectDesc	= StringUtils.defaultString(request.getParameter("projectDesc"));
	String startDate	= StringUtils.defaultString(request.getParameter("startDate"));
	String endDate	= StringUtils.defaultString(request.getParameter("endDate"));
	String tempImage	= StringUtils.defaultString(request.getParameter("tempImage"));

	String groupSeq = StringUtils.defaultString(request.getParameter("groupSeq"), "0");
	String returnUrl = "projectList.jsp";
	String step = StringUtils.defaultString(request.getParameter("step"));
	
	if(!sGroup.equals("0")){
		groupSeq = sGroup;
	}
	String lastInsertId = null;

	// proc variable
	String message = "Success";
	List params = new ArrayList();
	boolean result = false;

	try {
		if(mode.equals("Create")){

			if( "".equals(projectName) || "".equals(projectDesc) || "".equals(startDate) || "".equals(endDate) ) {
				message = "Invalid Parameters";
				returnUrl = "projectList.jsp";
			} else {
			
				params.add(0, projectName);
				params.add(1, projectBG);
				params.add(2, fontSize);
				params.add(3, fontC);
				params.add(4, projectDesc);
				params.add(5, startDate);
				params.add(6, endDate);
				params.add(7, tempImage);
				params.add(8, groupSeq);
				
				//등록
				lastInsertId = ProjectDAO.getInstance().regProject(params);
			
				if(!StringUtils.isEmpty(lastInsertId)){
					// 완료

					if(step.equals("next")){
						message = "Go to the next step.";
						returnUrl = "projectFormStep02_en.jsp?seq="+lastInsertId;
					}
					else{
						message = "Registration is complete.";
						returnUrl = "projectList_en.jsp";
					}

				}
			}

		} else if(mode.equals("Modify")){

			params.add(0, projectName);
			params.add(1, projectBG);
			params.add(2, fontSize);
			params.add(3, fontC);
			params.add(4, projectDesc);
			params.add(5, startDate);
			params.add(6, endDate);
			params.add(7, tempImage);
			params.add(8, groupSeq);
			params.add(9, seq);

			result = ProjectDAO.getInstance().modProject(params);
		
			if(result){
				if(step.equals("next")){
					message = "Go to the next step.";
					returnUrl = "projectFormStep02_en.jsp?seq="+seq;
				}
				else{
					message = "Modified";
					returnUrl = "projectList_en.jsp";
				}
			}
		} 
		else if(mode.equals("Delete")){
			result = ProjectDAO.getInstance().delProject(seq);
		
			if(result){
				message = "Deleted";
				returnUrl = "projectList.jsp";
			}
		}
		else {
			message = "Error : Need Process Type";
		}

		out.println("<script language='javascript'>");
		out.println("alert('"+message+"');");
		out.println("self.location.replace('"+returnUrl+"');");
		out.println("</script>");

	}           
	catch(Exception e){
		log.debug("admin register Exception:"+e);
	} 
%>
<%@ include file="/include/footer.jsp" %>
