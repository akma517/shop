<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	System.out.println("[debug] adminMenu.jsp 로직 진입");
%>
<!-- 관리자메뉴 모듈 -->    
<div>
	<ul class="nav justify-content-end">
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">일반 사용자 페이지</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/selectCategoryList.jsp">전자책 카테고리 관리</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/selectEbookList.jsp">전자책 관리</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp">주문 관리</a></li>
		<li class="nav-item"><a class="nav-link"  href="<%=request.getContextPath()%>/admin/selectMemberList.jsp">회원 목록 보기</a></li>
<%-- 	<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/qna/selectQnaList.jsp">[상품평 관리]</a></li> --%>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/notice/selectNoticeList.jsp">공지사항 관리</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/qna/selectQnaList.jsp">Q&A 관리</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/logOut.jsp">로그아웃</a></li>
	</ul>
</div>
<%
	Member loginMember = (Member)session.getAttribute("loginMember");
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
	System.out.println("[debug] adminMenu.jsp 로직 종료");
%>