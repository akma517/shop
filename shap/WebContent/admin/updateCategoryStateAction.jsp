<%@page import="vo.Category"%>
<%@page import="dao.CategoryDao"%>
<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateCategoryStateAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] updateCategoryStateAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
    
	// 카테고리 추가 정보 넘겨 받기
	String categoryName = request.getParameter("categoryName");
	String categoryState = request.getParameter("categoryState");

	
	// 가입 정보값 디버깅
	System.out.println("[debug] updateCategoryStateAction.jsp => 상태를 변경할 카테고리 이름: " + categoryName);
	System.out.println("[debug] updateCategoryStateAction.jsp => 상태를 변경할 카테고리 현재 상태: " + categoryState);

	
	// 가입 정보 유효성 검사
	if (categoryName == null || categoryState == null) {
		response.sendRedirect(request.getContextPath() + "/admin/selectCategoryList.jsp");
		System.out.println("[debug] updateCategoryStateAction.jsp => selectCategoryList.jsp로 강제 이동: 입력받은 값에 null값이 있어 이전 페이지로 돌려보냈습니다.");
		return; 
	}
	
	if (categoryName.equals("") || categoryState.equals("")) {
		response.sendRedirect(request.getContextPath() + "/admin/selectCategoryList.jsp");
		System.out.println("[debug] updateCategoryStateAction.jsp => selectCategoryList.jsp로 강제 이동: 입력받은 값에 공백 값이 있어 이전 페이지로 돌려보냈습니다.");
		return; 
	}
	
	// 기존 카테고리 값을 변경할 카테고리 값으로 변환해 주기
	if (categoryState.equals("Y")) {
		categoryState = "N";
	} else if (categoryState.equals("N")) {
		categoryState = "Y";
	}
	
	
	// db 작업 위한 Dao 객체 생성
	CategoryDao categoryDao = new CategoryDao();
			
	// 카테고리 변경 정보 세팅
	Category category = new Category();
	
	category.setCategoryName(categoryName);
	category.setCategoryState(categoryState);
	
	int confirm = categoryDao.updateCategoryStateByAdmin(category);
	
	if (confirm==1) {
		
		System.out.println("[debug] updateCategoryStateAction.jsp => 카테고리 상태 변경 성공");
		response.sendRedirect(request.getContextPath() + "/admin/selectCategoryList.jsp");
		
		System.out.println("[debug] updateCategoryStateAction.jsp 로직 종료");
		
		return;
		
	} else {
		
		System.out.println("[debug] updateCategoryStateAction.jsp => 카테고리 상태 변경 실패 : 입력받은 카테고리 이름에 문제가 있습니다. 확인해주세요.");
		response.sendRedirect(request.getContextPath() + "/admin/selectCategoryList.jsp");
		
		System.out.println("[debug] updateCategoryStateAction.jsp 로직 종료");
		
		return;
	}
	
%>