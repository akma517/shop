<%@page import="vo.QnaComment"%>
<%@page import="dao.QnaCommentDao"%>
<%@page import="vo.Qna"%>
<%@page import="dao.QnaDao"%>
<%@page import="vo.Notice"%>
<%@page import="dao.NoticeDao"%>
<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] insertQnaCommentAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] insertQnaCommentAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
	
	// qna 댓글 등록 정보 넘겨 받기
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String qnaCommentContent = request.getParameter("qnaCommentContent");
	
	
	
	// DB에 줄바꿈 문자를 넣어주기 위해 변환
	qnaCommentContent = qnaCommentContent.replaceAll("\r\n|\n", "<br>");
	
	// db 작업 위한 Dao 객체 생성
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
			
	// 공지사항 등록 정보 세팅
	QnaComment qnaComment = new QnaComment();
	
	qnaComment.setQnaNo(qnaNo);
	qnaComment.setQnaCommentContent(qnaCommentContent);
	qnaComment.setMemberNo(memberNo);
	
	// qna 댓글 정보값 디버깅
	System.out.println("[debug] insertQnaCommentAction.jsp => 등록할 qna 댓글 매개변수 : " + qnaComment.toString());
	
	// DB 작업 수행 후 결과 저장
	int confirm = qnaCommentDao.insertQnaComment(qnaComment);
	
	// 결과 확인 및 리턴
	if (confirm==1) {
		
		System.out.println("[debug] insertQnaCommentAction.jsp => qna 등록 성공");
		response.sendRedirect(request.getContextPath() + "/qna/selectQnaOne.jsp?qnaNo=" + qnaNo);
		
		System.out.println("[debug] insertQnaCommentAction.jsp 로직 종료");
		
		return;
		
	} else {
		
		System.out.println("[debug] insertQnaCommentAction.jsp => qna 등록 실패 : 입력 정보를 다시 확인해 주세요.");
		response.sendRedirect(request.getContextPath() + "/qna/selectQnaOne.jsp?qnaNo=" + qnaNo);
		
		System.out.println("[debug] insertQnaCommentAction.jsp 로직 종료");
		
		return;
	}
	
%>