<%@page import="dao.MemberDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateMemberPwForm.jsp 로직 진입");	
	
	// 만약 로그인하지 않은 멤버가 updateMemberForm.jsp에 접근할 시, index.jsp 페이지로 강제 이동시킨다.
	Member loginMember = (Member)session.getAttribute("loginMember");
	
	if (loginMember == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] updateMemberPwForm.jsp => index.jsp로 강제 이동: 접근 권한이 없는 이용자의 강제 접근을 막았습니다.");
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
				<h1>비밀번호 수정</h1>
				<form id="updateMemberPwForm" class="form-group" method="post" action="<%=request.getContextPath()%>/updateMemberPwAction.jsp" >
					<table class="table table-borderless" >
						<tr>
							<td class="align-middle">
								현재 비밀번호
								<div>&nbsp;</div>
							</td>
							<td>
								<input class="form-control" type="text" id="memberPw" name="memberPw">
								<input class="form-control" type="hidden" name="memberNo" value="<%= loginMember.getMemberNo()%>">
								<div id="memberPwCheck">&nbsp;</div>
							</td>
						</tr>
						<tr>
							<td class="align-middle">
								새로운 비밀번호
								<div>&nbsp;</div>
							</td>
							<td>
								<input class="form-control" type="text" id="memberPwNew" name="memberPwNew">
								<div id="memberPwNewCheck">&nbsp;</div>
							</td>
						</tr>
					</table>
				</form>
				<div>
					<button id="updateMemberPwButton" class="btn btn-outline-primary text-center" type="button">수정</button>
				</div>
				<script>
					
					/* 유효성 검사 이벤트 */
					// 입력받아야 할 항목들의 값이 공백인지 아닌지, 아이디 중복 검사는 통과하였는지를 검사하고
					// 부족한 것이 있다면 이를 알려 이용자에게 정상적으로 값을 받을 수 있게 끔 구현
 					$('#updateMemberPwButton').click(function() {
						
						// 현재 비밀번호 검사
						if ($('#memberPw').val() == '') {
							
							$('#memberPwCheck').html($('<small style="color:red;">').text("현재 사용중인 비밀번호를 입력해 주세요."));
						
						// 새로운 비밀번호 검사
						} else if ($('#memberPwNew').val() == '') {
							
							// 기존 유효성 검사 불통과 안내 코멘트 삭제(id 중복 검사 통과 안내 코멘트는 유지)
							$('#memberPwCheck').html("&nbsp;");
							
							$('#memberPwNewCheck').html($('<small style="color:red;">').text("새로 사용할 비밀번호를 입력해 주세요."));
							
						// 모든 유효성 검사를 통과하였으니 비밀번호 수정 승인
						} else {
							
							$('#updateMemberPwForm').submit();
						}
						
					})
				</script>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] updateMemberPwForm.jsp 로직 종료");
%>