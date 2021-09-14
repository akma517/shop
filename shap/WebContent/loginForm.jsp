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
	<div class="container pt-3 center-block" style="width:330px; padding:15px;">
		<div class="center-block text-center" style="width:300px; padding:15px;">
		<%
			/* 사전작업 */
			request.setCharacterEncoding("utf-8");
			System.out.println("[debug] loginForm.jsp 로직 진입");	
		
			/* 인증 방어 코드 : 로그인 전에만 페이지 열람 가능 */
			// 만약 로그인한 멤버가 loginForm.jsp에 접근하려고 할 시, index.jsp 페이지로 강제 이동시킨다.
			Member member = (Member)session.getAttribute("loginMember");
			
			if (member != null) {
				response.sendRedirect("./index.jsp");
				System.out.println("[debug] lgoinForm.jsp => index.jsp로 강제 이동: 이미 로그인한 멤버의 강제 접근을 막았습니다.");
				return; 
			}
			
		%>
			<h1>로그인</h1>
			<form class="form-group" method="post" action="./loginAction.jsp">
				<div>MemberId : </div>
				<div><input class="form-control" type="text" name="memberId"></div>
				<div>MemberPw : </div>
				<div><input class="form-control" type="password" name="memberPw"></div>
				<br>
				<div><input class="btn btn-outline-primary" type="submit" value="로그인"></div>
			</form>
		<%
			System.out.println("[debug] loginForm.jsp 로직 종료");
		%>
		</div>
	</div>
</body>
</html>