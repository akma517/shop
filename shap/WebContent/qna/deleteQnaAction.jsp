<%@page import="vo.Qna"%>
<%@page import="dao.QnaDao"%>
<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] deleteQnaAction.jsp 로직 진입");
	
	Member member = (Member)session.getAttribute("loginMember");
	
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] deleteQnaAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
    
    // 유효성 검사를 위해 String으로 값을 받음
    int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	
	// 삭제하려는 qna의 작성자가 아닐 경우, index.jsp로 돌려보낸다.
    if( loginMember.getMemberNo() != memberNo ) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] deleteQnaAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
	
 	// db 작업 위한 Dao 객체 생성
 	QnaDao qnaDao = new QnaDao();
 			
 	// 삭제할 공지사항 정보 세팅
 	Qna qna = new Qna();
 	
 	qna.setQnaNo(qnaNo);
 	qna.setMemberNo(memberNo);
 	
	// 입력값 디버깅
	System.out.println("[debug] deleteQnaAction.jsp => 입력받은 삭제할 qna 매개변수 : " +  qna.toString());
 	
 	// DB 작업 수행 후 결과 저장
 	int confirm = qnaDao.deleteQna(qna);
 	
 	// 결과 확인 및 리턴
 	if (confirm==1) {
 		
 		System.out.println("[debug] deleteQnaAction.jsp => qna 삭제 성공");
 		response.sendRedirect(request.getContextPath() + "/qna/selectQnaOne.jsp?qnaNo=" + qnaNo);
 		
 		System.out.println("[debug] deleteQnaAction.jsp 로직 종료");
 		
 		return;
 		
 	} else {
 		
 		System.out.println("[debug] deleteQnaAction.jsp => qna 삭제 실패 : 입력 정보를 다시 확인해 주세요.");
 		response.sendRedirect(request.getContextPath() + "/qna/selectQnaOne.jsp?qnaNo=" + qnaNo);
 		
 		System.out.println("[debug] deleteQnaAction.jsp 로직 종료");
 		
 		return;
 	}
	
%>