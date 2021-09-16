<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] deleteMember.jsp 로직 진입");
	
	/* 인증 방어 코드 : 로그인 후에만 페이지 열람 가능 */
	// 만약 로그인하지 않은 멤버가 deleteMemberAction.jsp에 접근하려고 할 시, index.jsp 페이지로 강제 이동시킨다.
	Member member = (Member)session.getAttribute("loginMember");
	
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] deleteMember.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
    
    // 유효성 검사를 위해 String으로 값을 받음
    String testMemberNo = request.getParameter("memberNo");
	
	// 디버깅
	System.out.println("[debug] deleteMember.jsp => 삭제할 멤버 넘버 : " +  testMemberNo);
	
	// 유효성 검사
	if ( testMemberNo == null) {
		response.sendRedirect(request.getContextPath() + "/admin/selectMemberList.jsp");
		System.out.println("[debug] deleteMember.jsp => selectMemberList.jsp로 강제 이동: 입력값에 null값이 있어 이전 페이지로 돌려보냈습니다.");
		return; 
	}
	
	// 유효성 검사 끝나고 int 형으로 변환
    int memberNo = Integer.parseInt(testMemberNo);

	// db 작업 위한 Dao 객체 생성
	MemberDao memberDao = new MemberDao();
			
	// 회원 삭제 정보 세팅
	Member deleteMember = new Member();
	deleteMember.setMemberNo(memberNo);
	
	
	int confirm = memberDao.deleteMemberByAdmin(deleteMember);
	
	if (confirm==1) {
		
		System.out.println("[debug] deleteMember.jsp => 회원삭제 성공");
		response.sendRedirect(request.getContextPath() + "/admin/selectMemberList.jsp");
		
		System.out.println("[debug] deleteMember.jsp 로직 종료");
		
		return;
		
	} else {
		System.out.println("[debug] deleteMember.jsp => 회원삭제 실패 : 존재하지 않은 회원입니다.");
		response.sendRedirect(request.getContextPath() + "/admin/selectMemberList.jsp");
		
		System.out.println("[debug] deleteMember.jsp 로직 종료");
		
		return;
	}
	
%>