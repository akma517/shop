<%@page import="vo.Notice"%>
<%@page import="dao.NoticeDao"%>
<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] deleteNoticeAction.jsp 로직 진입");
	
	/* 인증 방어 코드 : 로그인 후에만 페이지 열람 가능 */
	// 만약 로그인하지 않은 멤버가 deleteMemberAction.jsp에 접근하려고 할 시, index.jsp 페이지로 강제 이동시킨다.
	Member member = (Member)session.getAttribute("loginMember");
	
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] deleteNoticeAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
    
    // 유효성 검사를 위해 String으로 값을 받음
    int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	
	// 입력값 디버깅
	System.out.println("[debug] deleteNoticeAction.jsp => 입력받은 삭제할 공지사항 넘버 : " +  noticeNo);
	System.out.println("[debug] deleteNoticeAction.jsp => 입력받은 삭제할 공지사항 작성자 넘버 : " +  memberNo);
	
	// 삭제하려는 회원이 공지사항 작성자가 아닐 경우, index.jsp로 돌려보낸다.
    if( loginMember.getMemberNo() != memberNo ) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] deleteNoticeAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
	
 	// db 작업 위한 Dao 객체 생성
 	NoticeDao noticeDao = new NoticeDao();
 			
 	// 삭제할 공지사항 정보 세팅
 	Notice notice = new Notice();
 	
 	notice.setNoticeNo(noticeNo);
 	notice.setMemberNo(memberNo);
 	
 	// DB 작업 수행 후 결과 저장
 	int confirm = noticeDao.deleteNotice(notice);
 	
 	// 결과 확인 및 리턴
 	if (confirm==1) {
 		
 		System.out.println("[debug] deleteNoticeAction.jsp => 공지사항 삭제 성공");
 		response.sendRedirect(request.getContextPath() + "/notice/selectNoticeList.jsp");
 		
 		System.out.println("[debug] deleteNoticeAction.jsp 로직 종료");
 		
 		return;
 		
 	} else {
 		
 		System.out.println("[debug] deleteNoticeAction.jsp => 공지사항 삭제 실패 : 입력 정보를 다시 확인해 주세요.");
 		response.sendRedirect(request.getContextPath() + "/notice/selectNoticeList.jsp");
 		
 		System.out.println("[debug] deleteNoticeAction.jsp 로직 종료");
 		
 		return;
 	}
	
%>