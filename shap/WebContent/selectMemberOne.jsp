<%@page import="dao.MemberDao"%>
<%@page import="vo.Ebook"%>
<%@page import="dao.EbookDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] selectMemberOne.jsp 로직 진입");	
	
	// 로그인 정보가 없을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] selectMemberOne.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
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
	<style type="text/css">
		
		.centerSearchBar{
			position: absolute;
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
			<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="text-center" style="padding-top:50px;"><h1>회원정보</h1></div>
		<div class="container center-block" style="padding-top:50px;">
			<table class="table table-bordered">
				<tbody>
					<tr>
						<td class="text-center align-middle table-active" width="15%;">아이디</td>
						<td class="text-center align-middle" width="35%;"><%=member.getMemberId()%></td>
						<td class="text-center align-middle table-active" width="15%;">닉네임</td>
						<td class="text-center align-middle" width="35%;"><%=member.getMemberName()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle table-active" width="15%;">나이</td>
						<td class="text-center align-middle" width="35%;"><%=member.getMemberAge()%></td>
						<td class="text-center align-middle table-active" width="15%;">성별</td>
						<td class="text-center align-middle" width="35%;"><%=member.getMemberGender()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle table-active" width="15%;">회원 등급</td>
						<% 
							if (member.getMemberLevel() == 0) {
						%>
								<td class="text-center align-middle" width="35%;">일반회원</td>
						<%
							} else if (member.getMemberLevel() == 1)  { 
						%>
								<td class="text-center align-middle" width="35%;">관리자</td>
						<%
							}
						%>
						<td class="text-center align-middle table-active" width="15%;">가입날짜</td>
						<td class="text-center align-middle" width="35%;"><%=member.getCreateDate()%></td>
					</tr>
				</tbody>
			</table>
			<div class="text-right">
				<a href="<%=request.getContextPath() %>/deleteMemberForm.jsp" class="btn btn-outline-danger btn-sm">회원탈퇴</a>
				<a href="<%=request.getContextPath() %>/updateMemberForm.jsp" class="btn btn-outline-warning btn-sm">회원정보 수정</a>
				<a href="<%=request.getContextPath() %>/updateMemberPwForm.jsp" class="btn btn-outline-warning btn-sm">비밀번호 수정</a>
				<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-primary btn-sm">홈페이지</a>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] selectMemberOne.jsp 로직 종료");	
%>