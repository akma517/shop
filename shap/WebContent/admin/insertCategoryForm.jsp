<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	<%
		/* 꿀팁: ctr + shift + r 버튼을 누르면 파일명을 기준으로 열려있는 이클립스 프로젝트 안에서 파일을 검색하여 찾아낼 수 있다.*/
		/* 사전 작업 */
		request.setCharacterEncoding("utf-8");
		System.out.println("[debug] insertCategoryForm.jsp 로직 진입");
	%>
	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="container pt-3 center-block" style="width:80%; padding:15px;">
			<%
				
				/* admin 방어 코드 */
				// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
			    Member loginMember = (Member)session.getAttribute("loginMember");
			    if(loginMember == null || loginMember.getMemberLevel() < 1) {
			       response.sendRedirect(request.getContextPath()+"/index.jsp");
			       System.out.println("[debug] insertCategoryForm.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
			       return;
			    }
				
				// 멤버 아이디 중복 방지를 위한 멤버 아이디 체크 값 초기화
				String categoryNameCheck = "";
				if (request.getParameter("categoryNameCheck") != null) {
					categoryNameCheck = request.getParameter("categoryNameCheck");
				}
				
				// 멤버 아이디 중복 검증을 통과하면 사용할 멤버 아이디 값 초기화
				String checkedCategoryName = "";
				if (request.getParameter("checkedCategoryName") != null) {
					checkedCategoryName = request.getParameter("checkedCategoryName");
				}
			%>
			<div class="center-block text-center" >
				<h1> 카테고리 추가 </h1>
				<table class="table" >
					<form class="form" method="post" action="<%=request.getContextPath()%>/admin/selectCategoryNameCheckAction.jsp" >
						<tr>
							<td class="align-middle">
								이름 중복 검사
							</td>
							<td>
								<input class="form-control" type="text" name="categoryName">
							</td>
							<td>
								<input class="btn btn-outline-primary" type="submit" value="중복검사">
							</td>
						</tr>
					</form>
					<form class="form-group" method="post" action="<%=request.getContextPath()%>/admin/insertCategoryAction.jsp" >
					<tr>
						<td class="align-middle">
							이름
						</td>
						<td>
							<input class="form-control" type="text" name="categoryName" readonly="readonly" value="<%=checkedCategoryName %>">
							<%=categoryNameCheck%>
						</td>
						<td>
							
						</td>
					</tr>
					<tr>
						<td class="align-middle">
							사용여부
						</td>
						<td>
							<div class="form-group">
								<label for="memberLevel">등급</label>
								<select class="form-control" name="categoryState">
							    	<option value="Y">사용</option>
							    	<option value="N">미사용</option>
								</select>
							</div>
						</td>
						<td>
						</td>
					<tr>
						<td colspan="3">
							<input class="btn btn-outline-primary text-center" type="submit" value="카테고리 추가">
						</td>
					</tr>
				</form>
			</table>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] insertCategoryForm.jsp 로직 종료");
%>