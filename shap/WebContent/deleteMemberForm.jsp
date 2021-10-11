<%@page import="dao.MemberDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] deleteMemberForm.jsp 로직 진입");	
	
	// 만약 로그인하지 않은 멤버가 deleteMemberForm.jsp에 접근할 시, index.jsp 페이지로 강제 이동시킨다.
	Member loginMember = (Member)session.getAttribute("loginMember");
	
	if (loginMember == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] deleteMemberForm.jsp => index.jsp로 강제 이동: 접근 권한이 없는 이용자의 강제 접근을 막았습니다.");
		return; 
	}
				
%>
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
		<div class="container pt-3 center-block" style="width:80%; padding:15px;">

			<div class="center-block text-center" >
				<h1>회원탈퇴</h1>
				<h4>본인 확인을 위해 비밀번호를 입력해 주세요.</h4>
				<form id="deleteMemberForm" class="form-group" method="post" action="<%=request.getContextPath()%>/deleteMemberAction.jsp" >
					<table class="table table-borderless" >
						<tr>
							<td>
								<input class="form-control" type="text" id="memberPw" name="memberPw">
								<input class="form-control" type="hidden" name="memberNo" value="<%= loginMember.getMemberNo()%>">
								<div id="memberPwCheck">&nbsp;</div>
							</td>
						</tr>
					</table>
				</form>
				<div>
					<button id="deleteMemberButton" class="btn btn-outline-danger text-center" type="button">회원탈퇴</button>
				</div>
				<script>
					
					/* 유효성 검사 이벤트 */
					// 입력받아야 할 항목들의 값이 공백인지 아닌지, 아이디 중복 검사는 통과하였는지를 검사하고
					// 부족한 것이 있다면 이를 알려 이용자에게 정상적으로 값을 받을 수 있게 끔 구현
 					$('#deleteMemberButton').click(function() {
						
						// 비밀번호 검사
						if ($('#memberPw').val() == '') {
							
							$('#memberPwCheck').html($('<small style="color:red;">').text("비밀번호를 입력해 주세요."));
						
						// 모든 유효성 검사를 통과하였으니 비밀번호 수정 승인
						} else {
							
							$('#deleteMemberForm').submit();
						}
					})
				</script>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] deleteMemberForm.jsp 로직 종료");
%>