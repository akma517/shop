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
	System.out.println("[debug] updateNoticeForm.jsp 로직 진입");	
   
	// 방어코드
	// 로그인 여부와 회원등급을 같이 확인하면 로그인 정보가 없을 시(loginMember == null일 시) getMemberLebel() 메소드가 nullPointError를 일으키므로 두 조건을 따로 검사
	 Member loginMember = (Member)session.getAttribute("loginMember");
	
	if ( loginMember == null ) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] updateNoticeForm.jsp => index.jsp로 강제 이동: 접근 권한이 없는 회원의 강제 접근을 막았습니다.");
		return; 
	}
	
	if ( loginMember.getMemberLevel() < 1 ) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] updateNoticeForm.jsp => index.jsp로 강제 이동: 접근 권한이 없는 회원의 강제 접근을 막았습니다.");
		return; 
	}
	
 	// 공지사항 수정 설정
    int noticeNo = 1;
    if(request.getParameter("noticeNo") != null) {
    	noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
    }
    
    // 넘겨받은 공지사항 넘버 디버깅
    System.out.println("[debug] updateNoticeOne.jsp => 입력받은 수정할 공지사항 넘버 : " + noticeNo);
    
    /* 수정할 공지사항 세부정보 가져오기 */
    NoticeDao noticeDao = new NoticeDao();
    
    // 공지사항 상세정보 불러오기
    Notice notice = new Notice();
    notice.setNoticeNo(noticeNo);
    
    NoticeMember noticeMember = noticeDao.selectNoticeOne(notice);
    
    System.out.println("[debug] updateNoticeOne.jsp => 로그인 회원 넘버 : " + loginMember.getMemberNo());
    
    // 공지사항 수정자와 작성자의 회원 넘버가 다르면 강제 이동
	if ( noticeMember.getMember().getMemberNo() != loginMember.getMemberNo() ) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] updateNoticeForm.jsp => index.jsp로 강제 이동: 접근 권한이 없는 회원의 강제 접근을 막았습니다.");
		return; 
	}
    
	// 공지사항 내용의 웹에 맞춰진 개행문자를 textarea 형식에 맞게 변환
	noticeMember.getNotice().setNoticeContent(noticeMember.getNotice().getNoticeContent().replaceAll("<br>", "\r\n"));
    
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
		<div class="text-center" style="padding-top:50px;"><h1>공지사항 등록</h1></div>
		<div class="container center-block" style="padding-top:50px;">
			<form id="updateNoticeForm" class="form-group" method="post" action="<%=request.getContextPath()%>/notice/updateNoticeAction.jsp" >
				<table class="table table-borderless" >
					<tr>
						<td class="align-middle">
							제목
							<div>&nbsp;</div>
							<input type="hidden" name="memberNo" value="<%=noticeMember.getMember().getMemberNo() %>">
							<input type="hidden" name="noticeNo" value="<%=noticeMember.getNotice().getNoticeNo() %>">
						</td>
						<td>
							<input class="form-control" type="text" name="noticeTitle" id="noticeTitle" value="<%=noticeMember.getNotice().getNoticeTitle() %>">
							<div id="noticeTitleCheck" >&nbsp;</div>
						</td>
					</tr>
					<tr>
						<td class="align-middle">
							내용
							<div>&nbsp;</div>
						</td>
						<td class="align-middle" colspan="2">
							<div class="form-group"><textarea id="noticeContent" name="noticeContent" class="form-control" rows="10" cols="50" wrap="hard"><%=noticeMember.getNotice().getNoticeContent()%></textarea></div>
							<div id="noticeContentCheck">&nbsp;</div>
						</td>
					</tr>
				</table><br>
				<div class="text-center">
					<button type="button" id="updateNoticeButton" class="btn btn-outline-primary">수정</button>
					<a href="<%=request.getContextPath() %>/notice/selectNoticeOne.jsp?noticeNo=<%=noticeNo %>" class="btn btn-outline-danger">취소</a>
				</div>
			</form>
			<script>
			
				/* 유효성 검사 이벤트 */
				// 입력받아야 할 항목들의 값이 공백인지 아닌지, 아이디 중복 검사는 통과하였는지를 검사하고
				// 부족한 것이 있다면 이를 알려 이용자에게 정상적으로 값을 받을 수 있게 끔 구현
				$('#updateNoticeButton').click(function() {

					// 제목 검사
					if ($('#noticeTitle').val() == '') {
						
						$('#noticeTitleCheck').html($('<small style="color:red;">').text("제목을 입력해 주세요."));
					
					// 내용 검사
					} else if ($('#noticeContent').val() == '') {
						
						// 기존 유효성 검사 불통과 안내 코멘트 삭제
						$('#noticeTitleCheck').html("&nbsp;");
						
						$('#noticeContentCheck').html($('<small style="color:red;">').text("내용을 입력해 주세요."));
					
					// 모든 유효성 검사를 통과하였으니 회원가입 승인
					} else {
						
						// 유효성 검사를 전부 통과하면 회원가입
						$('#updateNoticeForm').submit();
					}
					
				})
			</script>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] updateNoticeForm.jsp 로직 종료");	
%>