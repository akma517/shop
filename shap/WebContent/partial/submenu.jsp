<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	System.out.println("[debug] submenu.jsp 로직 진입");
%>
<!-- 서브메뉴 모듈 -->    
<div>
	<ul class="nav justify-content-end">
		<%
			Member loginMember = (Member)session.getAttribute("loginMember");
		%>
		
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/index.jsp">홈페이지</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/notice/selectNoticeList.jsp">공지사항</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/qna/selectQnaList.jsp">Q&A</a></li>
		
		<%
			// session은 참조 타입만 들어간다.
			if( loginMember == null) {
		%>
				<!-- 로그인 전 -->
				<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a></li>
				<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/insertMemberForm.jsp">회원가입</a></li>
		<%
			} else {
				
		%>
				<!-- 로그인 후 -->
				<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/selectOrderListByMember.jsp?memberNo=<%=loginMember.getMemberNo() %>">주문내역</a></li>
				<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/selectMemberOne.jsp">회원정보</a></li>
				<%
					if (loginMember.getMemberLevel() >= 1) {
				%>
				 		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/adminIndex.jsp">관리자 페이지</a></li>
				<%
					}
				%>
				<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/logOut.jsp">로그아웃</a></li>
		<%
			}
		%>
	</ul>
</div>
<%
	// 로그인 상태일 경우
	if( loginMember != null) {
%>
	<div>
		<ul class="nav justify-content-end">
			<li class="nav-item">
				<span style="color: black; font-size: 25px">
					<a style="color: black;" href="<%=request.getContextPath()%>/selectMemberOne.jsp"><%=loginMember.getMemberName() %></a>
				</span>님 반갑습니다.
			</li>
			
		</ul>
	</div>
<%
	}
%>
<%
	System.out.println("[debug] submenu.jsp 로직 종료");
%>