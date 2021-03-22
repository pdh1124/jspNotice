<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- 자바 라이브러리 생성 -->
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 화면 최적화 -->
<meta name="viewport" content="width=device-width", initial-scale="1">
<!-- 루트 폴더에 부트스트랩을 참조하는 링크 -->
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
	a {
		color:#000;
		text-decoration:none;
	}
	a:hover {
		color:#888;
		text-decoration:none;
	}
</style>
</head>
<body>
	<%	
		//로그인이 된 사람은 로그인된 정보를 담을 수 있게 한다.
		String userID = null;
		if(session.getAttribute("userID") != null) { //현재 세션이 존재하는 사람이라면 아이디 값을 받아서 그래도 관리할 수 있도록 만들어 줌
			userID = (String)session.getAttribute("userID");
		}
		int pageNumber = 1; //1 은 기본페이지
		if(request.getParameter("pageNumber") != null) { //파라미터로 pageNumber가 넘어왔다면
			pageNumber = Integer.parseInt(request.getParameter("pageNumber")); //pageNumber에는 해당 파라미터의 값을 넣어준다. 대신 정수형으로 변환하는 parseInt으로 변환해 준다.
		}
	%>
	<nav class="navbar navbar-default"> <!-- 네비게이션 -->
		<div class="navbar-header"> 	<!-- 네비게이션 상단 부분 -->
			<!-- 네비게이션 상단 박스 영역 -->
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<!-- 이 삼줄 버튼은 화면이 좁아지면 우측에 나타난다 -->
				<span class="icon-bar"></span> 
				<span class="icon-bar"></span> 
				<span class="icon-bar"></span>
			</button>
			<!-- 상단 바에 제목이 나타나고 클릭하면 main 페이지로 이동한다 -->
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<!-- 게시판 제목 이름 옆에 나타나는 메뉴 영역 -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			
			<%
				//로그인이 되어 있지 않을 경우만 표시
				if(userID == null) {
			%>	
				<!-- 로그인이 안된 사람 헤더 우측에 나타나는 드랍다운 영역 -->
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">접속하기<span class="caret"></span></a>
						<!-- 드랍다운 아이템 영역 -->	
						<ul class="dropdown-menu">
							<li><a href="login.jsp">로그인</a></li>
							<li><a href="join.jsp">회원가입</a></li>
						</ul>				
					</li>
				</ul>
			<%	
				} else {	
			%>
				<!-- 로그인이 된 사람 나타나는 드랍다운 영역 -->
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle"
							data-toggle="dropdown" role="button" aria-haspopup="true"
							aria-expanded="false">회원관리<span class="caret"></span></a>
						<!-- 드랍다운 아이템 영역 -->	
						<ul class="dropdown-menu">
							<li><a href="logoutAction.jsp">로그아웃</a></li>
						</ul>				
					</li>
				</ul>
			<%		
				}
			%>
			
		</div>
	</nav>
	
	
	<div class="container">
		<div class="row"> <!-- 테이블이 들어갈 수 있는 공간 -->
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd;"> <!-- table-striped 목록의 홀수와 짝수의 색상이 변경되게 해서 가독성이 좋게 해줌 -->
				<thead>
					<tr>
						<th style="background-color:#eeeeee; text-align: center;">번호</th>
						<th style="background-color:#eeeeee; text-align: center;">제목</th>
						<th style="background-color:#eeeeee; text-align: center;">작성자</th>
						<th style="background-color:#eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
				<% 
					BbsDAO bbsDAO = new BbsDAO();//하나의 인스턴스 생성
					ArrayList<Bbs> list = bbsDAO.getList(pageNumber); //리스트를 하나 만들어서 그 값은 현재의 페이지에서 가져온 리스트(목록)으로 지정함 
					for(int i = 0; i < list.size(); i++) {
				%>
					<tr>
						<td><%= list.get(i).getBbsID() %></td>
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle() %></a></td>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시 " + list.get(i).getBbsDate().substring(14, 16) + "분 " %></td>
					</tr>
				<%
					}
				%>
				</tbody>
			</table>
			<%
				if(pageNumber != 1) { //1이 아니라면
				
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber - 1%>" class="btn btn-success btn-arraw-left">이전</a>
			<%
				}
				if(bbsDAO.nextPage(pageNumber + 1)) { //다음페이지가 존재 한다면
					
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber + 1%>" class="btn btn-success btn-arraw-left">다음</a>
			<%
				} 
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>

</body>
</html>