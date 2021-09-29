<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자바 송현우</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>	
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
				<h1> 카테고리 추가 </h1><br>
				<form id="insertCategoryForm" class="form-group" method="post" action="<%=request.getContextPath()%>/admin/insertCategoryAction.jsp" >
					<table class="table table-borderless" >
						<tr>
							<td class="align-middle">
								이름
								<div>&nbsp;</div>
							</td>
							<td>
								<input class="form-control" type="text" name="categoryName" id="categoryName">
								<div id="categoryNameCheck">&nbsp;</div>
							</td>
							<td>
								<button id="categoryNameCheckButton" class="btn btn-outline-primary text-center" type="button">중복검사</button>
								<div>&nbsp;</div>
							</td>
						</tr>
						<tr>
							<td class="align-middle">
								사용여부
							</td>
							<td>
								<div class="form-group">
									<select class="form-control" name="categoryState">
								    	<option value="Y">사용</option>
								    	<option value="N">미사용</option>
									</select>
								</div>
							</td>
						</tr>
					</table>
				</form>
				<div>
					<button id="categoryInsertButton" class="btn btn-outline-primary text-center" type="button">카테고리 추가</button>
				</div>
				<script>
					
					// 카테고리 이름 중복 여부를 확인할 변수 (입력한 카테고리 이름이 DB에 존재하지 않아야 통과(값이 0이 되야 통과))
					let existCategoryName = 1;
					
					// ajax와 XML 방식을 통해 페이지 이동 없이 selectCategoryNameCheckAction.jsp의 로직을 수행
					// 중복 검사를 하기 전, 입력받은 아이디 값이 공백이라면, 먼저 아이디 값을 입력해 달라고 알림 
					$('#categoryNameCheckButton').click(function() {
						if ($('#categoryName').val() == '') {
							$('#categoryNameCheck').html($('<small style="color:red;">').text("이름를 입력해 주세요."));
						} else {
								xhr = new XMLHttpRequest();
								
								let categoryNameCheck = $('#categoryName').val();
								
								let address = '<%=request.getContextPath()%>/admin/selectCategoryNameCheckAction.jsp?categoryName=' + categoryNameCheck;
								console.log(address);
								
								xhr.open('GET',address, true);
								xhr.onreadystatechange = function(){
									if (xhr.readyState == 4) {
										if(xhr.status == 200) {
											let data = xhr.responseXML.getElementsByTagName("exist");
											console.log("요청 성공:" + xhr.status);
											
											if (data[0].childNodes[0].nodeValue == 0) {
												existCategoryName = 0;
												$('#categoryNameCheck').html($('<small style="color:green;">').text("사용 가능한 이름입니다."));
											} else {
												$('#categoryNameCheck').html($('<small style="color:red;">').text("이미 사용중인 이름입니다."));
											}
											
										} else {
											console.log("요청 실패:" + xhr.status);
										}
									}
								}
								xhr.send(null);
							}
					})
					
					/* 유효성 검사 이벤트 */
					// 입력받아야 할 항목들의 값이 공백인지 아닌지, 아이디 중복 검사는 통과하였는지를 검사하고
					// 부족한 것이 있다면 이를 알려 이용자에게 정상적으로 값을 받을 수 있게 끔 구현
					// 이 페이지에선 중복 검사만 하면 되기에 중복 검사만 확인한 후, insert 작업 진행
 					$('#categoryInsertButton').click(function() {
						
 						// 중복 검사
						if (existCategoryName !=0 ) {
							
							$('#categoryNameCheck').html($('<small style="color:red;">').text("중복검사를 통과해 주세요."));
						
						// 모든 유효성 검사를 통과하였으니 회원가입 승인
						} else {
							
							$('#insertCategoryForm').submit();
						}
						
					})
					
				</script>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] insertCategoryForm.jsp 로직 종료");
%>