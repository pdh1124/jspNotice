<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- 자바 라이브러리 생성 -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 화면 최적화 -->
<meta name="viewport" content="width=device-width", initial-scale="1">
<!-- 루트 폴더에 부트스트랩을 참조하는 링크 -->
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%	
		//로그인이 된 사람은 로그인된 정보를 담을 수 있게 한다.
		String userID = null;
		if(session.getAttribute("userID") != null) { //현재 세션이 존재하는 사람이라면 아이디 값을 받아서 그래도 관리할 수 있도록 만들어 줌
			userID = (String)session.getAttribute("userID");
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
				<li class="active"><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
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
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top:20px;">
				<form method="post" action="loginAction.jsp">
					<h3 style="text-align:center;">로그인 화면</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
					</div>
					<input type="submit" class="btn btn-primary form-control" value="로그인">
				</form>
			</div>
		</div>
		<div class="col-lg-4"></div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>

</body>
</html>