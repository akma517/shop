<?xml version="1.0" encoding="UTF-8"?>
<%@page import="vo.Category"%>
<%@page import="dao.CategoryDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/XML; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] selectCategoryNameCheckAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] updateMemberLevelAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
	
	// 아이디 중복 여부를 검증할 값 받기
	String categoryName = request.getParameter("categoryName");
	
	// 입력값 디버깅
	System.out.println("[debug] selectCategoryNameCheckAction.jsp => 중복 여부를 검사할 카테고리 이름 : " + categoryName);
	
	// 입력값 유효성 검사
	if (categoryName == null || categoryName.equals("")) {
		response.sendRedirect(request.getContextPath() + "/admin/insertCategoryForm.jsp");
		System.out.println("[debug]  selectCategoryNameCheckAction.jsp => insertCategoryForm.jsp로 강제 이동: 중복 여부를 검사할 카테고리 이름에 null값 혹은 공백값이 있어 이전 페이지로 돌려보냈습니다.");
		return; 
	}
	
	
	// db 작업 위한 Dao 객체 생성
	CategoryDao categoryDao = new CategoryDao();
	
	Category category = new Category();
	
	category.setCategoryName(categoryName);
	
	int confirm = categoryDao.selectCategoryNameByAdmin(category);
	
	if (confirm==0) {
		
		System.out.println("[debug] selectCategoryNameCheckAction.jsp => 카테고리 이름 중복 여부 검증 : 통과");
		
	} else {
		
		System.out.println("[debug] selectCategoryNameCheckAction.jsp => 카테고리 이름 중복 여부 검증 : 실패(이미 사용 중인 카테고리 이름)");
	
	}
	
	System.out.println("[debug] selectCategoryNameCheckAction.jsp 로직 종료");
%>
<checkCategoryName>
	<exist><%=confirm %></exist>
</checkCategoryName>