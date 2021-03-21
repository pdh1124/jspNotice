<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %> <!--자바스크립트 문장을 쓰기위해 작성 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 모든 데이터를 UTF-8로 받을 수 있도록 작성 -->

<jsp:useBean id="user" class="user.User" scope="page"/><!-- javaBean(자바빈즈) 사용 -->
<jsp:setProperty name="user" property="userID"/>
<jsp:setProperty name="user" property="userPassword"/>
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
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID"); //userID라는 변수가 자신에게 할당된 세션ID를 담을 수 있도록 만듦
		}
		if(userID != null) { //이미 로그인이 된사람은 또다시 로그인을 할 수 없도록
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
	
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(), user.getUserPassword()); //로그인을 해서 나온 결과값인 -2 ~ 1을 result라는 변수에 담김
		
		if(result == 1) {
			session.setAttribute("userID", user.getUserID());//로그인이 성공되었을때 해당 사용자를 세션을 부여함
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		} else if(result == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')");
			script.println("history.back()"); //이전페이지로 돌려보낸다.
			script.println("</script>");
		} else if(result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디 입니다.')");
			script.println("history.back()"); //이전페이지로 돌려보낸다.
			script.println("</script>");
		} else if(result == -2) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()"); //이전페이지로 돌려보낸다.
			script.println("</script>");
		}
	%>
</body>
</html>