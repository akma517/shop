<%@page import="vo.Notice"%>
<%@page import="dao.NoticeDao"%>
<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateNoticeAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if( loginMember == null || loginMember.getMemberLevel() < 1 ) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] updateNoticeAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
	
	// 공지사항 수정 정보 넘겨 받기
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String noticeContent = request.getParameter("noticeContent");
	
	// 공지사항 수정 정보 디버깅
	System.out.println("[debug] insertNoticeAction.jsp => 수정할 공지사항 넘버 : " + memberNo);
	System.out.println("[debug] insertNoticeAction.jsp => 수정할 공지사항 제목 : " + noticeTitle);
	System.out.println("[debug] insertNoticeAction.jsp => 수정할 공지사항 작성자 넘버 : " + memberNo);
	System.out.println("[debug] insertNoticeAction.jsp => 수정할 공지사항 내용 : " + noticeContent);
	
	// 수정하려는 회원이 공지사항 작성자가 아닐 경우, index.jsp로 돌려보낸다.
    if( loginMember.getMemberNo() != memberNo ) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] updateNoticeAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
	
	// DB에 줄바꿈 문자를 넣어주기 위해 변환
	noticeContent = noticeContent.replaceAll("\r\n|\n", "<br>");
	
	// db 작업 위한 Dao 객체 생성
	NoticeDao noticeDao = new NoticeDao();
			
	// 공지사항 수정 정보 세팅
	Notice notice = new Notice();
	
	notice.setNoticeNo(noticeNo);
	notice.setNoticeTitle(noticeTitle);
	notice.setMemberNo(memberNo);
	notice.setNoticeContent(noticeContent);
	
	// DB 작업 수행 후 결과 저장
	int confirm = noticeDao.updateNotice(notice);
	
	// 결과 확인 및 리턴
	if (confirm==1) {
		
		System.out.println("[debug] updateNoticeAction.jsp => 공지사항 수정 성공");
		response.sendRedirect(request.getContextPath() + "/notice/selectNoticeOne.jsp?noticeNo=" + noticeNo);
		
		System.out.println("[debug] updateNoticeAction.jsp 로직 종료");
		
		return;
		
	} else {
		
		System.out.println("[debug] updateNoticeAction.jsp => 공지사항 수정 실패 : 입력 정보를 다시 확인해 주세요.");
		response.sendRedirect(request.getContextPath() + "/notice/selectNoticeList.jsp?noticeNo=" + noticeNo);
		
		System.out.println("[debug] updateNoticeAction.jsp 로직 종료");
		
		return;
	}
	
%>