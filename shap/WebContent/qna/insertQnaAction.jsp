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
	System.out.println("[debug] insertQnaAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] insertQnaAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
	
	// 공지사항 등록 정보 넘겨 받기
	String qnaTitle = request.getParameter("qnaTitle");
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String qnaCategory = request.getParameter("qnaCategory");
	String qnaSecret = request.getParameter("qnaSecret");
	String qnaContent = request.getParameter("qnaContent");
	
	// 가입 정보값 디버깅
	System.out.println("[debug] insertQnaAction.jsp => 등록할 qna 제목 : " + qnaTitle);
	System.out.println("[debug] insertQnaAction.jsp => 등록할 qna 작성자 넘버 : " + memberNo);
	System.out.println("[debug] insertQnaAction.jsp => 등록할 qna 종류 : " + qnaCategory);
	System.out.println("[debug] insertQnaAction.jsp => 등록할 qna 비밀 여부 : " + qnaSecret);
	System.out.println("[debug] insertQnaAction.jsp => 등록할 qna 내용 : " + qnaContent);
	
	// DB에 줄바꿈 문자를 넣어주기 위해 변환
	qnaContent = qnaContent.replaceAll("\r\n|\n", "<br>");
	
	// db 작업 위한 Dao 객체 생성
	QnaDao qnaDao = new QnaDao();
			
	// 공지사항 등록 정보 세팅
	Qna qna = new Qna();
	
	qna.setQnaTitle(qnaTitle);
	qna.setMemberNo(memberNo);
	qna.setQnaCategory(qnaCategory);
	qna.setQnaSecret(qnaSecret);
	qna.setQnaContent(qnaContent);
	
	// DB 작업 수행 후 결과 저장
	int confirm = qnaDao.insertQna(qna);
	
	// 결과 확인 및 리턴
	if (confirm==1) {
		
		System.out.println("[debug] insertQnaAction.jsp => qna 등록 성공");
		response.sendRedirect(request.getContextPath() + "/qna/selectQnaList.jsp");
		
		System.out.println("[debug] insertQnaAction.jsp 로직 종료");
		
		return;
		
	} else {
		
		System.out.println("[debug] insertQnaAction.jsp => qna 등록 실패 : 입력 정보를 다시 확인해 주세요.");
		response.sendRedirect(request.getContextPath() + "/qna/selectQnaList.jsp");
		
		System.out.println("[debug] insertQnaAction.jsp 로직 종료");
		
		return;
	}
	
%>