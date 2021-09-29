<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전 작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] insertOrderCommentForm.jsp 로직 진입");
		
	// 로그인 정보가 없을 경우, 강제로 index.jsp로 돌려보낸다.
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) {
	   response.sendRedirect(request.getContextPath()+"/index.jsp");
	   System.out.println("[debug] insertOrderCommentForm.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
	   return;
	}
	
	// 디버깅을 위해 string 타입으로 값을 받고 검증 후에 형 변환 
	String orderNoTest = request.getParameter("orderNo");
	String ebookNoTest = request.getParameter("ebookNo");
	 	
	// 디버깅
	System.out.println("[debug] insertOrderCommentAction.jsp => 작성할 리뷰 주문 넘버 : " + orderNoTest);
	System.out.println("[debug] insertOrderCommentAction.jsp => 작성할 리뷰 전자책 넘버 : " + ebookNoTest);
	
	// 입력값 검증
	if(orderNoTest == null || ebookNoTest == null) {
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		System.out.println("[debug] insertOrderCommentForm.jsp => index.jsp로 강제 이동: 유효하지 않은 강제 접근을 막았습니다.");
		return;
	}
	    
	// 검증 후, 쓰임세에 맞게 형 변환
	int orderNo = Integer.parseInt(orderNoTest);
	int ebookNo = Integer.parseInt(ebookNoTest);
	    
%>
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

	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/submenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="container pt-3 center-block"">
			<div class="center-block text-center" >
				<h1> 리뷰 작성 </h1><br>
				<form id="insertOrderCommentForm" class="form" method="post" action="<%=request.getContextPath()%>/insertOrderCommentAction.jsp"  >
					<table class="table table-borderless" >
						<tr>
							<td class="align-middle">
								별점
							</td>
							<td>
								<div class="form-check-inline">
									<label class="form-check-label" for="orderScore"">
										<input class="form-check-input" type="radio" name="orderScore"" value="1">1점
									</label>
								</div>
								<div class="form-check-inline">
									<label class="form-check-label" for="orderScore"">
										<input class="form-check-input" type="radio" name="orderScore" value="2">2점
									</label>
								</div>
								<div class="form-check-inline">
									<label class="form-check-label" for="orderScore"">
										<input class="form-check-input" type="radio" name="orderScore" value="3">3점
									</label>
								</div>
								<div class="form-check-inline">
									<label class="form-check-label" for="orderScore"">
										<input class="form-check-input" type="radio" name="orderScore" value="4">4점
									</label>
								</div>
								<div class="form-check-inline">
									<label class="form-check-label" for="orderScore"">
										<input class="form-check-input" type="radio" name="orderScore" value="5"  checked="checked">5점
									</label>
								</div>
							</td>
							<td>
								<input type="hidden" name="orderNo" value="<%=orderNo %>">
								<input type="hidden" name="ebookNo" value="<%=ebookNo %>">
							</td>
						</tr>
						<tr>
							<td class="align-middle">
								<div>내용</div>
								<div>&nbsp;</div>
							</td>
							<td class="align-middle" colspan="2">
								<div class="form-group"><textarea id="orderCommentContent" name="orderCommentContent" class="form-control" rows="5" cols="50" wrap="hard"></textarea></div>
								<div id="orderCommentContentCheck">&nbsp;</div>
							</td>
						</tr>
					</table><br>
					<div>
						<button type="button" id="insertOrderCommentButton" class="btn btn-outline-primary">등록</button>
					</div>
				</form>
				<script>
					
					// 유효성 검사 후, 등록 승인
 					$('#insertOrderCommentButton').click(function() {
						
						if ($('#orderCommentContent').val() == '') {
							$('#orderCommentContentCheck').html($('<small style="color:red;">').text("내용을 입력해 주세요."));
						} else {
							$('#insertOrderCommentForm').submit();
						}
						
					})
				</script>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] insertOrderCommentForm.jsp 로직 종료");
%>