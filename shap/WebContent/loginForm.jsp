<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자바 송현우</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/submenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="container pt-3 center-block">
			<div class="center-block text-center">
				<%
					/* 사전작업 */
					request.setCharacterEncoding("utf-8");
					System.out.println("[debug] loginForm.jsp 로직 진입");	
				
					/* 인증 방어 코드 : 로그인 전에만 페이지 열람 가능 */
					// 만약 로그인한 멤버가 loginForm.jsp에 접근하려고 할 시, index.jsp 페이지로 강제 이동시킨다.
					Member member = (Member)session.getAttribute("loginMember");
					
					if (member != null) {
						response.sendRedirect(request.getContextPath() + "./index.jsp");
						System.out.println("[debug] lgoinForm.jsp => index.jsp로 강제 이동: 이미 로그인한 멤버의 강제 접근을 막았습니다.");
						return; 
					}
					
				%>
				<h1>로그인</h1><br>
				<form id="loginForm" class="form-group" method="post" action="<%=request.getContextPath()%>/loginAction.jsp">
					<table>
						<tr>
							<td class="text-left align-middle" width="30%">아이디</td>
							<td><input class="form-control" type="text" name="memberId" id="memberId"></td>
						</tr>
						<tr>
							<td></td>
							<td id="memberIdCheck">&nbsp;</td>
						</tr>
						<tr>
							<td class="text-left align-middle" width="30%">비밀번호</td>
							<td><input class="form-control" type="password" name="memberPw" id="memberPw"></td>
						</tr>
						<tr>
							<td></td>
							<td id="memberPwCheck">&nbsp;</td>
						</tr>
					</table><br>
					<div>
						<button type="button" id="loginButton" class="btn btn-outline-primary">로그인</button>
					</div>
				</form>
				<script>
					// %(() == jquery()
 					$('#loginButton').click(function() {
						
						if ($('#memberId').val() == '') {
							$('#memberIdCheck').html($('<small style="color:red;">').text("아이디를 입력해 주세요."));
						} else if ($('#memberPw').val() == '') {
							// id를 입력했으므로 입력해 달라는 코멘트를 삭제
							$('#memberIdCheck').html("&nbsp;");
							
							$('#memberPwCheck').html($('<small style="color:red;">').text("비밀번호를 입력해 주세요."));
							
						} else {
							$('#loginForm').submit();
						}
						
					})
				</script>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] loginForm.jsp 로직 종료");
%>