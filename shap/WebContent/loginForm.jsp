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
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/submenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
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
						response.sendRedirect(request.getContextPath() + "./index.jsp");
						System.out.println("[debug] lgoinForm.jsp => index.jsp로 강제 이동: 이미 로그인한 멤버의 강제 접근을 막았습니다.");
						return; 
					}
					
				%>
				<h1>로그인</h1>
				<form id="loginForm" class="form-group" method="post" action="<%=request.getContextPath()%>/loginAction.jsp">
					<div>MemberId : </div>
					<div><input class="form-control" type="text" name="memberId" id="memberId"></div>
					<div>MemberPw : </div>
					<div><input class="form-control" type="password" name="memberPw" id="memberPw"></div>
					<br>
					<div><button id="loginButton" class="btn btn-outline-primary">로그인</button></div>
				</form>
				<script>
					// %(() == jquery()
					$('#loginButton').click(function() {
						if ($('#memberId').val() == '') {
							alert('memberId를 입력해 주세요.');
						} else if ($('#memberPw').val() == '') {
							alert('memberPw를 입력해 주세요.');
						}
						
						$("#loginForm").submit();
					})
					
					/* 라디오, 체크, 셀레트 등의 다중 값 태그들에게 유효성 검사하는 법(클래스로 선택하는 것이 좋음(배열로 받음))
					$('#loginButton').click(function() {
						if ($('.radioButton').length == 0)) {
							alert('버튼을 하나 이상 선택해 주세요.');
						} 
						$("#loginForm").submit();
					})
					 */
				</script>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] loginForm.jsp 로직 종료");
%>