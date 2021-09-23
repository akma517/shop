<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateEbookImgForm.jsp 로직 진입");	
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] updateEbookImgForm.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
    
 	// 전자책 넘버 설정
    int ebookNo = 1;
    if(request.getParameter("ebookNo") != null) {
    	ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
    }
    
    // 입력값 디버깅
    System.out.println("[debug] updateEbookImgForm.jsp => 입력 받은 전자책 넘버: " + request.getParameter("ebookNo"));
    
%>   
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자바 송현우</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="container pt-3 center-block text-center" style="width:400px; padding:15px;">
				<h1>전자책 이미지 수정</h1>
			   <form class="form-group" action="<%=request.getContextPath()%>/admin/updateEbookImgAction.jsp" method="post" enctype="multipart/form-data"> 
			      <!-- multipart/form-data : 액션으로 기계어코드를 넘길때 사용 -->
			      <!-- application/x-www-form-urlencoded : 액션으로 문자열 넘길때 사용 -->
			      <div><input class="form-control text-center" type="text" name="ebookNo" value="넘버: <%=ebookNo%>" readonly="readonly"></div>
			      <div><input class="form-control-file border" type="file" name="ebookImg"></div>
			      <br>
			      <div><input class="btn btn-outline-warning" type="submit" value="사진 수정"></div>
			   </form>
		</div>
   </div>
</body>
</html>
<%
	System.out.println("[debug] updateEbookImgForm.jsp 로직 종료");
%>