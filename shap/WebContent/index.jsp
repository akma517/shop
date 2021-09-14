<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자바 송현우</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<style type="text/css">
		.center-block{
			position: absolute;
			top: 50%;
			left: 50%;
			transform: translate(-50%, -50%);
			z-index: 1;
		}
	</style>
</head>
<body>
	<div class="container pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/submenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="center-block text-center" style="width:300px; padding:15px;">
			<h1>메인페이지</h1>
			<%
				request.setCharacterEncoding("utf-8");
				System.out.println("[debug] index.jsp 로직 진입");	
			%>
				<!-- 로그인 전 -->
			<div><a href="./loginForm.jsp">로그인</a></div>
			<div><a href="./insertMemberForm.jsp">회원가입</a></div>
		</div>
	</div>
<%
	System.out.println("[debug] index.jsp 로직 종료");	
			
%>
</body>
</html>