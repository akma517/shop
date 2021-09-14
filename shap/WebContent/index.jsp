<%@page import="vo.Member"%>
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
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] index.jsp 로직 진입");	
%>
	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/submenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="container pt-3 center-block" style="width:330px; padding:15px;">
			<div class="center-block text-center" style="width:300px; padding:15px;">
				<h1>홈페이지</h1>
				<%
					// session은 참조 타입만 들어간다.
					if(session.getAttribute("loginMember") == null) {
				%>
						<!-- 로그인 전 -->
						<div><a href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a></div>
						<div><a href="<%=request.getContextPath()%>/insertMemberForm.jsp">회원가입</a></div>
				<%
					} else {
						Member loginMember = (Member)session.getAttribute("loginMember");
				%>
						<!-- 로그인 후 -->
						<div><%=loginMember.getMemberName() %>님 반갑습니다.<br><a href="<%=request.getContextPath()%>/logOut.jsp">로그아웃</a></div>
				<%
					}
					
					System.out.println("[debug] index.jsp 로직 종료");	
				%>
			</div>
		</div>
	</div>
</body>
</html>