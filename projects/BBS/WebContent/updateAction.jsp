<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %> <!--자바 문장을 쓰기위해 작성 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 모든 데이터를 UTF-8로 받을 수 있도록 작성 -->

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%	
	//로그인 완료된 회원은 로그인,회원가입 버튼을 안보이게 하기 위함
		String userID = null;
		if(session.getAttribute("userID") != null) { //userID로 세션이 존재 한다면
			userID = (String) session.getAttribute("userID"); //userID라는 변수가 자신에게 할당된 세션ID를 담을 수 있도록 만듦
		}
		if(userID == null) { //이미 로그인이 된사람은 또다시 로그인, 회원가입을 할 수 없도록
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} 
		int bbsID = 0;
		if (request.getParameter("bbsID") != null) { //매개변수가 넘어온 bbsID가 존재 한다면
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0) { //반드시 존재 해야지 특정한 글을 볼 수 있도록 정해준다.
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		
		//현재 작성한 글이 작성한 사람 본인인지 확인할 필요가 있는데 세션관리가 필요함
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		if(!userID.equals(bbs.getUserID())) { //세션에 있는 값과 작성한 사람의 값이 다르다면
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		} else {
			if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null ||
					request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")) {
				//bbsTitle과 bbsContent가 null값 이거나 빈값("")이면
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다.')");
				script.println("history.back()"); //이전페이지로 돌려보낸다.
				script.println("</script>");
			} else {
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));
				if(result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글수정이 실패했습니다.')");
					script.println("history.back()"); //이전페이지로 돌려보낸다.
					script.println("</script>");
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'");
					script.println("</script>");
				}
			}
		}	
	%>
</body>
</html>