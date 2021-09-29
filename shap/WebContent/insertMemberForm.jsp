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
	<%
		/* 꿀팁: ctr + shift + r 버튼을 누르면 파일명을 기준으로 열려있는 이클립스 프로젝트 안에서 파일을 검색하여 찾아낼 수 있다.*/
		/* 사전 작업 */
		request.setCharacterEncoding("utf-8");
		System.out.println("[debug] insertMemberForm.jsp 로직 진입");
	%>
	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/submenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="container pt-3 center-block" style="width:80%; padding:15px;">
			<%
				/* 인증 방어 코드 : 로그인 전에만 페이지 열람 가능 */
				// 만약 로그인한 멤버가 insertMemberForm.jsp에 접근할 시, index.jsp 페이지로 강제 이동시킨다.
				Member member = (Member)session.getAttribute("loginMember");
				
				if (member != null) {
					response.sendRedirect(request.getContextPath() + "/index.jsp");
					System.out.println("[debug] insertMemberForm.jsp => index.jsp로 강제 이동: 이미 로그인한 멤버의 강제 접근을 막았습니다.");
					return; 
				}
				
				// 멤버 아이디 중복 방지를 위한 멤버 아이디 체크 값 초기화
				String memberIdCheck = "";
				if (request.getParameter("memberIdCheck") != null) {
					memberIdCheck = request.getParameter("memberIdCheck");
				}
				
				// 멤버 아이디 중복 검증을 통과하면 사용할 멤버 아이디 값 초기화
				String checkedMemberId = "";
				if (request.getParameter("checkedMemberId") != null) {
					checkedMemberId = request.getParameter("checkedMemberId");
				}
			%>
			<div class="center-block text-center" >
				<h1> 회원가입 </h1>
				<form id="signUpForm" class="form-group" method="post" action="<%=request.getContextPath()%>/insertMemberAction.jsp" >
					<table class="table table-borderless" >
						<tr>
							<td class="align-middle">
								아이디
								<div>&nbsp;</div>
							</td>
							<td>
								<input class="form-control" type="text" name="memberId" id="memberId">
								<div id="memberIdCheck" >&nbsp;</div>
							</td>
							<td>
								<button id="memberIdCheckButton" class="btn btn-outline-primary text-center" type="button">중복검사</button>
								<div>&nbsp;</div>
							</td>
						</tr>
						<tr>
							<td class="align-middle">
								비밀번호
								<div>&nbsp;</div>
							</td>
							<td>
								<input class="form-control" type="password" id="memberPw" name="memberPw">
								<div id="memberPwCheck">&nbsp;</div>
							</td>
						</tr>
						<tr>
							<td class="align-middle">
								이름
								<div>&nbsp;</div>
							</td>
							<td>
								<input class="form-control" type="text" id="memberName" name="memberName">
								<div id="memberNameCheck">&nbsp;</div>
							</td>
						</tr>
						<tr>
							<td class="align-middle">
								나이
								<div>&nbsp;</div>
							</td>
							<td>
								<input class="form-control" type="text" id="memberAge" name="memberAge">
								<div id="memberAgeCheck">&nbsp;</div>
							</td>
						</tr>
						<tr>
							<td class="align-middle">
								성별
								<div>&nbsp;</div>
							</td>
							<td>
								<div class="form-check-inline">
									<label class="form-check-label" for="memberGender">
										<input class="form-check-input memberGender" type="radio" name="memberGender" value="남">남
									</label>
								</div>
								<div class="form-check-inline">
									<label class="form-check-label" for="memberGender">
										<input class="form-check-input memberGender" type="radio" name="memberGender" value="여">여
									</label>
								</div>
								<div id="memberGenderCheck">&nbsp;</div>
							</td>
						</tr>
					</table>
				</form>
				<div>
					<button id="signUpButton" class="btn btn-outline-primary text-center" type="button">회원가입</button>
				</div>
				<script>
					
					// 아이디 중복 여부를 확인할 변수 (입력한 아이디가 DB에 존재하지 않아야 통과(값이 0이 되야 통과))
					let existMemberId = 1;
					
					// ajax와 XML 방식을 통해 페이지 이동 없이 selectMemberIdCheckAction.jsp의 로직을 수행
					// 중복 검사를 하기 전, 입력받은 아이디 값이 공백이라면, 먼저 아이디 값을 입력해 달라고 알림
					// 참고 사이트: https://m.blog.naver.com/pyh3887/221850305991
					$('#memberIdCheckButton').click(function() {
						if ($('#memberId').val() == '') {
							$('#memberIdCheck').html($('<small style="color:red;">').text("아이디를 입력해 주세요."));
						} else {
								xhr = new XMLHttpRequest();
								
								let memberIdCheck = $('#memberId').val();
								
								let address = '<%=request.getContextPath()%>/selectMemberIdCheckAction.jsp?memberId=' + memberIdCheck;
								console.log(address);
								
								xhr.open('GET',address, true);
								console.log("요청중:");
								xhr.onreadystatechange = function(){
									console.log("요청중:");
									if (xhr.readyState == 4) {
										if(xhr.status == 200) {
											let data = xhr.responseXML.getElementsByTagName("exist");
											console.log("요청 성공:" + xhr.status);
											
											if (data[0].childNodes[0].nodeValue == 0) {
												existMemberId = 0;
												$('#memberIdCheck').html($('<small style="color:green;">').text("사용 가능한 아이디입니다."));
											} else {
												$('#memberIdCheck').html($('<small style="color:red;">').text("이미 사용중인 아이디입니다."));
											}
											
										} else {
											console.log("요청 실패:" + xhr.status);
										}
									}
								}
								xhr.send(null);
							}
					})
					
					/* 유효성 검사 이벤트 */
					// 입력받아야 할 항목들의 값이 공백인지 아닌지, 아이디 중복 검사는 통과하였는지를 검사하고
					// 부족한 것이 있다면 이를 알려 이용자에게 정상적으로 값을 받을 수 있게 끔 구현
 					$('#signUpButton').click(function() {
						
 						// 중복 검사
						if (existMemberId !=0 ) {
							
							$('#memberIdCheck').html($('<small style="color:red;">').text("중복검사를 통과해 주세요."));
						
						// 비밀번호 검사
						} else if ($('#memberPw').val() == '') {
							
							$('#memberPwCheck').html($('<small style="color:red;">').text("비밀번호를 입력해 주세요."));
						
						// 이름 검사
						} else if ($('#memberName').val() == '') {
							
							// 기존 유효성 검사 불통과 안내 코멘트 삭제(id 중복 검사 통과 안내 코멘트는 유지)
							$('#memberPwCheck').html("&nbsp;");
							
							$('#memberNameCheck').html($('<small style="color:red;">').text("이름을 입력해 주세요."));
						
						// 나이 검사
						} else if ($('#memberAge').val() == '') {
							
							// 기존 유효성 검사 불통과 안내 코멘트 삭제(id 중복 검사 통과 안내 코멘트는 유지)
							$('#memberPwCheck').html("&nbsp;");
							$('#memberNameCheck').html("&nbsp;");
							
							$('#memberAgeCheck').html($('<small style="color:red;">').text("나이를 입력해 주세요."));
							
						// 성별 검사
						} else if ($('.memberGender').length == 0) {
							
							// 기존 유효성 검사 불통과 안내 코멘트 삭제(id 중복 검사 통과 안내 코멘트는 유지)
							$('#memberPwCheck').html("&nbsp;");
							$('#memberNameCheck').html("&nbsp;");
							
							$('#memberGenderCheck').html($('<small style="color:red;">').text("성별을를 선택해 주세요."));
						
						// 모든 유효성 검사를 통과하였으니 회원가입 승인
						} else {
							
							// 유효성 검사를 전부 통과하면 회원가입
							$('#signUpForm').submit();
						}
						
					})
				</script>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] insertMemberForm.jsp 로직 종료");
%>