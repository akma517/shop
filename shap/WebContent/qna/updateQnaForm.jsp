<%@page import="vo.QnaMember"%>
<%@page import="vo.Qna"%>
<%@page import="dao.QnaDao"%>
<%@page import="vo.NoticeMember"%>
<%@page import="vo.Notice"%>
<%@page import="dao.NoticeDao"%>
<%@page import="vo.OrderCommentMember"%>
<%@page import="dao.OrderCommentDao"%>
<%@page import="dao.OrderDao"%>
<%@page import="vo.OrderComment"%>
<%@page import="java.util.ArrayList"%>
<%@page import="vo.Ebook"%>
<%@page import="dao.EbookDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateQnaForm.jsp 로직 진입");	
   
	// 방어코드
	// 로그인 여부와 회원등급을 같이 확인하면 로그인 정보가 없을 시(loginMember == null일 시) getMemberLebel() 메소드가 nullPointError를 일으키므로 두 조건을 따로 검사
	 Member loginMember = (Member)session.getAttribute("loginMember");
	
	if ( loginMember == null ) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] updateQnaForm.jsp => index.jsp로 강제 이동: 접근 권한이 없는 회원의 강제 접근을 막았습니다.");
		return; 
	}
	
 	// qna 상세보기 설정
    int qnaNo = 1;
    if(request.getParameter("qnaNo") != null) {
    	qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
    }
   
    /* qna 불러오기 */
    QnaDao qnaDao = new QnaDao();
    
    Qna qna = new Qna();
    qna.setQnaNo(qnaNo);
    
    // 수정할 qna 가져오기
    QnaMember qnaMember = qnaDao.selectQnaOne(qna);
	
    // qna 자바에서 인식할 수 있게 html기준으로 db에 기록된 줄바꿈 문자를 변환
	String javaEscText = qnaMember.getQna().getQnaContent();
	qnaMember.getQna().setQnaContent(javaEscText.replaceAll("<br>", "\r\n"));	
    
%>   
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자바 송현우</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
			<jsp:include page="/partial/submenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="text-center" style="padding-top:50px;"><h1>Q&A 수정</h1></div>
		<div class="container center-block" style="padding-top:50px;">
			<form id="updateQnaForm" class="form-group" method="post" action="<%=request.getContextPath()%>/qna/updateQnaAction.jsp" >
				<table class="table table-borderless" >
					<tr>
						<td class="align-middle">
							제목
							<div>&nbsp;</div>
							<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo() %>">
							<input type="hidden" name="qnaNo" value="<%=qnaMember.getQna().getQnaNo() %>">
						</td>
						<td>
							<input class="form-control" type="text" name="qnaTitle" id="qnaTitle" value="<%=qnaMember.getQna().getQnaTitle() %>">
							<div id="qnaTitleCheck" >&nbsp;</div>
						</td>
					</tr>
					<tr>
						<td class="align-middle">
							종류
							<div>&nbsp;</div>
						</td>
						<td class="align-middle">
							<select class="form-control" name="qnaCategory" id="qnaCategory">
								<option value="선택">선택</option>
						    	<option value="전자책">전자책</option>
						    	<option value="가입정보">가입정보</option>
						    	<option value="기타">기타</option>
							</select>
							<div id="qnaCategoryCheck" >&nbsp;</div>
						<td >
					</tr>
					<tr>
						<td class="align-middle">
							공개 설정
							<div>&nbsp;</div>
						</td>
						<td class="align-middle">
							<select class="form-control" name="qnaSecret" id="qnaSecret">
								<option value="선택">선택</option>
						    	<option value="Y">비밀</option>
						    	<option value="N">공개</option>
							</select>
							<div id="qnaSecretCheck" >&nbsp;</div>
						</td>
					</tr>
					<tr>
						<td class="align-middle">
							내용
							<div>&nbsp;</div>
						</td>
						<td class="align-middle">
							<div class="form-group"><textarea id="qnaContent" name="qnaContent" class="form-control" rows="10" cols="50" wrap="hard"><%=qnaMember.getQna().getQnaContent() %></textarea></div>
							<div id="qnaContentCheck">&nbsp;</div>
						</td>
					</tr>
				</table><br>
				<div class="text-center">
					<button type="button" id="updateQnaButton" class="btn btn-outline-primary btn-sm">수정</button>
					<a href="<%=request.getContextPath() %>/qna/selectQnaList.jsp" class="btn btn-outline-primary btn-sm">취소</a>
				</div>
			</form>
			<script>
			
				/* 유효성 검사 이벤트 */
				// 입력받아야 할 항목들의 값이 공백인지 아닌지, 아이디 중복 검사는 통과하였는지를 검사하고
				// 부족한 것이 있다면 이를 알려 이용자에게 정상적으로 값을 받을 수 있게 끔 구현
				$('#updateQnaButton').click(function() {

					// 제목 검사
					if ($('#qnaTitle').val() == '') {
						
						$('#qnaTitleCheck').html($('<small style="color:red;">').text("제목을 입력해 주세요."));
					
					// 종류 검사
					} else if ($('#qnaCategory').val() == '선택') {
						
						// 기존 유효성 검사 불통과 안내 코멘트 삭제
						$('#qnaTitleCheck').html("&nbsp;");
						
						$('#qnaCategoryCheck').html($('<small style="color:red;">').text("종류를 선택해 주세요."));
					
					// 비밀여부 검사
					} else if ($('#qnaSecret').val() == '선택') {
						
						// 기존 유효성 검사 불통과 안내 코멘트 삭제
						$('#qnaTitleCheck').html("&nbsp;");
						$('#qnaCategoryCheck').html("&nbsp;");
						
						$('#qnaSecretCheck').html($('<small style="color:red;">').text("비밀 여부를 선택해 주세요."));
					
					// 내용 검사
					} else if ($('#qnaContent').val() == '') {
						
						// 기존 유효성 검사 불통과 안내 코멘트 삭제
						$('#qnaTitleCheck').html("&nbsp;");
						$('#qnaCategoryCheck').html("&nbsp;");
						$('#qnaSecretCheckk').html("&nbsp;");
						
						$('#qnaContentCheck').html($('<small style="color:red;">').text("내용을 입력해 주세요."));
					
					// 모든 유효성 검사를 통과하였으니 회원가입 승인
					} else {
						
						// 유효성 검사를 전부 통과하면 qna 수정
						$('#updateQnaForm').submit();
					}
					
				})
			</script>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] updateQnaForm.jsp 로직 종료");	
%>