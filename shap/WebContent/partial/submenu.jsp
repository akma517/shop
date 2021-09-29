<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	System.out.println("[debug] submenu.jsp 로직 진입");
%>
<!-- 서브메뉴 모듈 -->    
<div>
	<ul class="nav justify-content-end">
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/index.jsp">홈페이지</a></li>
		<li class="nav-item"><a class="nav-link" href="">menu1</a></li>
		<li class="nav-item"><a class="nav-link" href="#">menu2</a></li>
		<li class="nav-item"><a class="nav-link" href="#">menu3</a></li>
		<li class="nav-item"><a class="nav-link" href="#">menu4</a></li>
		<li class="nav-item"><a class="nav-link" href="#">menu5</a></li>
	</ul>
</div>
<%
	System.out.println("[debug] submenu.jsp 로직 종료");
%>