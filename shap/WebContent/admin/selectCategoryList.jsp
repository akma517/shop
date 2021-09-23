<%@page import="vo.Category"%>
<%@page import="dao.CategoryDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] selectCategoryList.jsp 로직 진입");	
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] slectMemberList.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
    
    // 카테고리 리스트 불러오기
    CategoryDao categoryDao = new CategoryDao();
    ArrayList<Category> categoryList = categoryDao.selectCategoryListByAdmin();
    
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
		<div class="text-center" style="padding-top:50px;"><h1>카테고리 목록</h1></div>
		<div class="container-fluid center-block" style="padding-top:50px;">
			<table class="table">
				<thead class="thead-light">	
					<tr class="align-content-center">
						<th class="text-center">이름</th>
						<th class="text-center">상태</th>
						<th class="text-center">추가날짜</th>
						<th class="text-center">수정날짜</th>
						<th class="text-center" style="width:8%;"></th>
					</tr>
				</thead>
				<tbody>
					<% 
						for (Category category : categoryList) {
					%>
							<tr>
								<td class="text-center"><%=category.getCategoryName()%></td>
								<td class="text-center">
				                     <%
				                        if(category.getCategoryState().equals("Y")) {
				                     %>
				                           <span>사용중</span>
				                     <%      
				                        } else if(category.getCategoryState().equals("N")) {
				                     %>
				                           <span>미사용</span>
				                     <%      
				                        }
				                     %>
								</td>
								<td class="text-center"><%=category.getCreateDate()%></td>
								<td class="text-center"><%=category.getUpdateDate()%></td>
								<td class="text-center" style="width:8%;">
									<a href="<%=request.getContextPath() %>/admin/updateCategoryStateAction.jsp?categoryName=<%=category.getCategoryName() %>&categoryState=<%=category.getCategoryState() %>" class="btn btn-outline-warning btn-sm">상태 수정</a>
								</td>
							</tr>
					<% 
						}
					%>
					<tr>
						<td colspan="5">
							<div class="text-right">
								<a href="<%=request.getContextPath() %>/admin/insertCategoryForm.jsp" class="btn btn-outline-primary btn-sm">카테고리 추가</a>
								<a href="<%=request.getContextPath() %>/admin/adminIndex.jsp" class="btn btn-outline-primary btn-sm">관리자페이지로</a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] selectCategoryList.jsp 로직 종료");	
%>