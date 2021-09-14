<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	request.setCharacterEncoding("utf-8");
	
	System.out.println("[debug] logOug.jsp 로직 진입");
	
	// 세션을 갱신(초기화)
	session.invalidate();

	response.sendRedirect(request.getContextPath() + "/index.jsp");
	
	System.out.println("[debug] logOug.jsp 로직 종료");
	
%>