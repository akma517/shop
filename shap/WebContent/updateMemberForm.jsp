<%@page import="dao.MemberDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateMemberForm.jsp 로직 진입");	
	
	// 만약 로그인하지 않은 멤버가 updateMemberForm.jsp에 접근할 시, index.jsp 페이지로 강제 이동시킨다.
	Member loginMember = (Member)session.getAttribute("loginMember");
	
	if (loginMember == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] updateMemberForm.jsp => index.jsp로 강제 이동: 접근 권한이 없는 이용자의 강제 접근을 막았습니다.");
		return; 
	}
	
    int memberNo = loginMember.getMemberNo();
    
    MemberDao memberDao = new MemberDao();
    
    // 회원정보 불러오기
    Member member = memberDao.selectMemberOne(memberNo);
				
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
				<h1>회원정보 수정</h1>
				<form id="updateMemberForm" class="form-group" method="post" action="<%=request.getContextPath()%>/updateMemberAction.jsp" >
					<table class="table table-borderless" >
						<tr>
							<td class="align-middle">
								닉네임
								<div>&nbsp;</div>
							</td>
							<td>
								<input class="form-control" type="text" id="memberName" name="memberName" value="<%= member.getMemberName()%>">
								<input class="form-control" type="hidden" name="memberNo" value="<%= member.getMemberNo()%>">
								<div id="memberNameCheck">&nbsp;</div>
							</td>
						</tr>
						<tr>
							<td class="align-middle">
								나이
								<div>&nbsp;</div>
							</td>
							<td>
								<input class="form-control" type="text" id="memberAge" name="memberAge" value="<%= member.getMemberAge()%>">
								<div id="memberAgeCheck">&nbsp;</div>
							</td>
						</tr>
						<tr>
							<td class="align-middle">
								성별
								<div>&nbsp;</div>
							</td>
							<td>
								<% 
									if (member.getMemberGender().equals("남")) {
								%>
										<div class="form-check-inline">
											<label class="form-check-label" for="memberGender">
												<input class="form-check-input memberGender" type="radio" name="memberGender" value="남" checked="checked">남
											</label>
										</div>
										<div class="form-check-inline">
											<label class="form-check-label" for="memberGender">
												<input class="form-check-input memberGender" type="radio" name="memberGender" value="여">여
											</label>
										</div>
										<div id="memberGenderCheck">&nbsp;</div>
								<%
									} else {
								%>
										<div class="form-check-inline">
											<label class="form-check-label" for="memberGender">
												<input class="form-check-input memberGender" type="radio" name="memberGender" value="남">남
											</label>
										</div>
										<div class="form-check-inline">
											<label class="form-check-label" for="memberGender">
												<input class="form-check-input memberGender" type="radio" name="memberGender" value="여"  checked="checked">여
											</label>
										</div>
										<div id="memberGenderCheck">&nbsp;</div>
								<%		
									}
								%>
							</td>
						</tr>
					</table>
				</form>
				<div>
					<button id="updateMemberButton" class="btn btn-outline-primary text-center" type="button">수정</button>
				</div>
				<script>
					
					/* 유효성 검사 이벤트 */
					// 입력받아야 할 항목들의 값이 공백인지 아닌지, 아이디 중복 검사는 통과하였는지를 검사하고
					// 부족한 것이 있다면 이를 알려 이용자에게 정상적으로 값을 받을 수 있게 끔 구현
 					$('#updateMemberButton').click(function() {
						
						// 이름 검사
						if ($('#memberName').val() == '') {
							
							
							$('#memberNameCheck').html($('<small style="color:red;">').text("이름을 입력해 주세요."));
						
						// 나이 검사
						} else if ($('#memberAge').val() == '') {
							
							// 기존 유효성 검사 불통과 안내 코멘트 삭제(id 중복 검사 통과 안내 코멘트는 유지)
							$('#memberNameCheck').html("&nbsp;");
							
							$('#memberAgeCheck').html($('<small style="color:red;">').text("나이를 입력해 주세요."));
							
						// 성별 검사
						} else if ($('.memberGender').length == 0) {
							
							// 기존 유효성 검사 불통과 안내 코멘트 삭제(id 중복 검사 통과 안내 코멘트는 유지)
							$('#memberNameCheck').html("&nbsp;");
							$('#memberAgeCheck').html("&nbsp;");
							
							$('#memberGenderCheck').html($('<small style="color:red;">').text("성별을 선택해 주세요."));
						
						// 모든 유효성 검사를 통과하였으니 회원정보 수정 승인
						} else {
							
							$('#updateMemberForm').submit();
						}
						
					})
				</script>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] updateMemberForm.jsp 로직 종료");
%>