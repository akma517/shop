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
	System.out.println("[debug] updateQnaAction.jsp 로직 진입");
	
	// 로그인 정보가 없을 경우, 또는 작성자가 아닐 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] updateQnaAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
	
	// Q&A 수정 정보 넘겨 받기
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	String qnaTitle = request.getParameter("qnaTitle");
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String qnaCategory = request.getParameter("qnaCategory");
	String qnaSecret = request.getParameter("qnaSecret");
	String qnaContent = request.getParameter("qnaContent");
	
	// 작성자가 아닐 경우, 수정을 허락하지 않고 강제로 index.jsp로 돌려보낸다.
    if(loginMember.getMemberNo() != memberNo) {
        response.sendRedirect(request.getContextPath()+"/index.jsp");
        System.out.println("[debug] updateQnaAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
        return;
     }
	
	// DB에 줄바꿈 문자를 넣어주기 위해 변환
	qnaContent = qnaContent.replaceAll("\r\n|\n", "<br>");
	
	// db 작업 위한 Dao 객체 생성
	QnaDao qnaDao = new QnaDao();
			
	// 공지사항 등록 정보 세팅
	Qna qna = new Qna();
	
	qna.setQnaNo(qnaNo);
	qna.setQnaTitle(qnaTitle);
	qna.setMemberNo(memberNo);
	qna.setQnaCategory(qnaCategory);
	qna.setQnaSecret(qnaSecret);
	qna.setQnaContent(qnaContent);
	
	//수정할 qna 매개변수 디버깅
	System.out.println("[debug] updateQnaAction.jsp => 등록할 수정할 매개변수 : " + qna.toString());
	
	// DB 작업 수행 후 결과 저장
	int confirm = qnaDao.updateQna(qna);
	
	// 결과 확인 및 리턴
	if (confirm==1) {
		
		System.out.println("[debug] updateQnaAction.jsp => qna 등록 성공");
		response.sendRedirect(request.getContextPath() + "/qna/selectQnaOne.jsp?qnaNo=" + qnaNo);
		
		System.out.println("[debug] updateQnaAction.jsp 로직 종료");
		
		return;
		
	} else {
		
		System.out.println("[debug] updateQnaQnaAction.jsp => qna 등록 실패 : 입력 정보를 다시 확인해 주세요.");
		response.sendRedirect(request.getContextPath() + "/qna/selectQnaOne.jsp?qnaNo=" + qnaNo);
		
		System.out.println("[debug] updateQnaQnaAction.jsp 로직 종료");
		
		return;
	}
	
%>