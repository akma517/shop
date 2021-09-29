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
	System.out.println("[debug] selectNoticeOne.jsp 로직 진입");	

	// 로그인 정보가 없어도 열람은 가능하도록 강제 이동시키지 않음
    Member loginMember = (Member)session.getAttribute("loginMember");
    
 	// 전자책 상세보기 설정
    int noticeNo = 1;
    if(request.getParameter("noticeNo") != null) {
    	noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
    } 
    
    // 넘겨받은 공지사항 넘버 디버깅
    System.out.println("[debug] selectNoticeOne.jsp => 입력받을 상세보기할 공지사항 넘버 : " + noticeNo);
    
    /* 공지사항 세부정보 가져오기 */
    NoticeDao noticeDao = new NoticeDao();
    
    // 공지사항 상세정보 불러오기
    Notice notice = new Notice();
    notice.setNoticeNo(noticeNo);
    
    NoticeMember noticeMember = noticeDao.selectNoticeOne(notice);
    
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
			<jsp:include page="/partial/submenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="text-center" style="padding-top:50px;"><h1>상품 상세보기</h1></div>
		<div class="container center-block" style="padding-top:50px;">
			<table class="table table-bordered">
				<tbody>
					<tr>
						<td class="text-center align-middle table-active" ">제목</td>
						<td class="text-center align-middle" colspan="7"><%=noticeMember.getNotice().getNoticeTitle()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle table-active">등록날짜</td>
						<td class="text-center align-middle"  colspan="2"><%=noticeMember.getNotice().getCreateDate()%></td>
						<td class="text-center align-middle table-active" >수정날짜</td>
						<td class="text-center align-middle"  colspan="2"><%=noticeMember.getNotice().getUpdateDate()%></td>
						<td class="text-center align-middle table-active" >작성자</td>
						<td class="text-center align-middle" colspan="2" ><%=noticeMember.getMember().getMemberName()%>[<%=noticeMember.getMember().getMemberId()%>]</td>
					</tr>
					<tr>
						<td class="text-center align-middle" colspan="9" ><%=noticeMember.getNotice().getNoticeContent() %></td>
					</tr>
				</tbody>
			</table>
			<div class="text-right">
				<%
					if (loginMember != null && loginMember.getMemberLevel() < 1) {
				%>
						<a href="<%=request.getContextPath() %>/notice/deleteNoticeAction.jsp?noticekNo=<%=noticeMember.getNotice().getNoticeNo()%>" class="btn btn-outline-danger btn-sm">삭제하기</a>
						<a href="<%=request.getContextPath() %>/notice/updateNoticeAction.jsp?noticekNo=<%=noticeMember.getNotice().getNoticeNo()%>" class="btn btn-outline-warning btn-sm">수정하기</a>
				<%
					}
				%>			
				<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-primary btn-sm">홈페이지</a>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] selectNoticeOne.jsp 로직 종료");	
%>