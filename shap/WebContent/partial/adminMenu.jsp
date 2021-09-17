<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	System.out.println("[debug] adminMenu.jsp 로직 진입");
%>
<!-- 관리자메뉴 모듈 -->    
<div>
	<ul class="nav justify-content-end">
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/selectCategoryList.jsp">[전자책 카테고리 관리]</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/">[전자책 관리]</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/">[주문 관리]</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/">[상품평 관리]</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/">[공지게시판 관리]</a></li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/admin/">[게시판 관리]</a></li>
	</ul>
</div>
<%
	System.out.println("[debug] adminMenu.jsp 로직 진입");
%>