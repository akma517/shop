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
				<table class="table" >
					<form class="form" method="post" action="<%=request.getContextPath()%>/selectMemberIdCheckAction.jsp" >
						<tr>
							<td class="align-middle">
								ID 중복 검사
							</td>
							<td>
								<input class="form-control" type="text" name="memberId">
							</td>
							<td>
								<input class="btn btn-outline-primary" type="submit" value="중복검사">
							</td>
						</tr>
					</form>
					<form class="form-group" method="post" action="<%=request.getContextPath()%>/insertMemberAction.jsp" >
					<tr>
						<td class="align-middle">
							ID
						</td>
						<td>
							<input class="form-control" type="text" name="memberId" readonly="readonly" value="<%=checkedMemberId %>">
						</td>
						<td>
							<%=memberIdCheck %>
						</td>
						<td>
						</td>
					</tr>
					<tr>
						<td class="align-middle">
							비밀번호
						</td>
						<td>
							<input class="form-control" type="password" name="memberPw">
						</td>
						<td>
						</td>
					</tr>
					<tr>
						<td class="align-middle">
							이름
						</td>
						<td>
							<input class="form-control" type="text" name="memberName">
						</td>
						<td>
						</td>
					</tr>
					<tr>
						<td class="align-middle">
							나이
						</td>
						<td>
							<input class="form-control" type="text" name="memberAge">
						</td>
						<td>
						</td>
					</tr>
					<tr>
						<td class="align-middle">
							성별
						</td>
						<td>
							<div class="form-check-inline">
								<label class="form-check-label" for="memberGender">
									<input class="form-check-input" type="radio" name="memberGender" value="남" checked="checked">남
								</label>
							</div>
							<div class="form-check-inline">
								<label class="form-check-label" for="memberGender">
									<input class="form-check-input" type="radio" name="memberGender" value="여">여
								</label>
							</div>
						</td>
						<td>
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<input class="btn btn-outline-primary text-center" type="submit" value="회원가입">
						</td>
					</tr>
				</form>
			</table>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] insertMemberForm.jsp 로직 종료");
%>