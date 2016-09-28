<%/*============================================================================
			 * @ Description : 관리자 등록시 ID 체크
			 *
			 * 작성일 : 2011.04.18
			 * 작성자 : 이정순
			 ============================================================================*/%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/header.jsp" %>
<%
  		String activityIndex = StringUtils.defaultString(request.getParameter("activityIndex"));
	String message = "success";
		boolean result = false;
		int resultCount = 0;

		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		String memberid2 = null;
		int[] sums = new int[5];
		int activityNumber = -1;

		try {
			String jdbcDriver = "jdbc:mysql://wine.smartworks.net:3306/newcesa?useUnicode=true&characterEncoding=utf8";
			String dbUser = "root";
			String dbPwd = "smartworks";
			conn = DriverManager.getConnection(jdbcDriver, dbUser,
					dbPwd);
			pstmt = conn
					.prepareStatement("SELECT * FROM member_check Order by regdate DESC LIMIT 1");
			rs = pstmt.executeQuery();

			while (rs.next()) {
				memberid2 = rs.getString("memberid");

			}
			pstmt2 = conn
					.prepareStatement("select * from (SELECT SUM(check_value) as A FROM member_check where memberid="
							+ memberid2
							+ " && activity='A') a,(SELECT SUM(check_value) as B FROM member_check where memberid="
							+ memberid2
							+ " && activity='B') b,	(SELECT SUM(check_value) as C FROM member_check where memberid="
							+ memberid2
							+ " && activity='C') c,(SELECT SUM(check_value) as D FROM member_check where memberid="
							+ memberid2
							+ " && activity='D') d,(SELECT SUM(check_value) as E FROM member_check where memberid="
							+ memberid2 + " && activity='E') e;");
			rs2 = pstmt2.executeQuery();
			while (rs2.next()) {
				sums[0] = rs2.getInt("A");
				sums[1] = rs2.getInt("B");
				sums[2] = rs2.getInt("C");
				sums[3] = rs2.getInt("D");
				sums[4] = rs2.getInt("E");
			}

			int maxValue = -1;
			for (int i = 0; i < 5; i++) {
				if (maxValue < sums[i]) {
					maxValue = sums[i];
					activityNumber = i;
					//System.out.println("aa:"+activityIndex);
				}
			}
			if (maxValue == 0) {
				activityNumber=Integer.parseInt(activityIndex);
			}
		} catch (SQLException se) {
			se.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
		
%>
<%=activityNumber + 2%>
<%@ include file="/include/footer.jsp" %>
