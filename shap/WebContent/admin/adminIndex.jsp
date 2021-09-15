<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] adminIndex.jsp 로직 진입");	
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] adminIndex.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
%>
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
	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="container pt-3 center-block" style="width:330px; padding:15px;">
			<div class="center-block text-center" style="width:300px; padding:15px;">
				<h1>관리자 페이지</h1>
				<div><%=loginMember.getMemberName() %>님 반갑습니다.</div>
				<div><a href="<%=request.getContextPath()%>/logOut.jsp">로그아웃</a></div>
				<div><a href="<%=request.getContextPath()%>/admin/selectMemberList.jsp">멤버 목록 보기</a></div>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] adminIndex.jsp 로직 종료");	
%>