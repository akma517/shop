<%@page import="java.net.URLEncoder"%>
<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] selectMemberIdCheckAction.jsp 로직 진입");
	
	/* 인증 방어 코드 : 로그인 전에만 페이지 열람 가능 */
	// 만약 로그인한 멤버가 insertMemberAction.jsp에 접근할 시, index.jsp 페이지로 강제 이동시킨다.
	Member member = (Member)session.getAttribute("loginMember");
	
	if (member != null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] selectMemberIdCheckAction.jsp => index.jsp로 강제 이동: 이미 로그인한 멤버의 강제 접근을 막았습니다.");
		return; 
	}
	
	// 아이디 중복 여부를 검증할 값 받기
	String memberId = request.getParameter("memberId");
	
	// 입력값 디버깅
	System.out.println("[debug] selectMemberIdCheckAction.jsp => 중복 여부를 검사할 아이디 : " + memberId);
	
	// 입력값 유효성 검사
	if (memberId == null || memberId.equals("")) {
		response.sendRedirect(request.getContextPath() + "/insertMemberForm.jsp");
		System.out.println("[debug]  selectMemberIdCheckAction.jsp => insertMemberForm.jsp로 강제 이동: 중복 여부를 검사할 아이디 값에 null값 혹은 공백값이 있어 이전 페이지로 돌려보냈습니다.");
		return; 
	}
	
	
	// db 작업 위한 Dao 객체 생성
	MemberDao memberDao = new MemberDao();
	
	member = new Member();
	
	member.setMemberId(memberId);
	
	int confirm = memberDao.selectMemberIdByAdmin(member);
	
	if (confirm==0) {
		
		System.out.println("[debug] selectMemberIdCheckAction.jsp => 아이디 중복 여부 검증 : 통과");
		
		// 자바에서 한글을 get 메소드로 보낼 때 한글이 안 깨지도록 하는 메소드 URLEncoder.encode(값, 인코딩)을 사용(https://dream-space.tistory.com/10)
		response.sendRedirect(request.getContextPath() + "/insertMemberForm.jsp?memberIdCheck="+ URLEncoder.encode("사용 가능한 아이디입니다.","utf-8") +"&checkedMemberId="+member.getMemberId());
		
		System.out.println("[debug] insertMemberAction.jsp 로직 종료");
		
		return;
		
	} else {
		
		System.out.println("[debug] selectMemberIdCheckAction.jsp => 아이디 중복 여부 검증 : 실패(이미 사용 중인 아이디)");
		response.sendRedirect(request.getContextPath() + "/insertMemberForm.jsp?memberIdCheck="+ URLEncoder.encode("이미 사용 중인 아이디입니다.","utf-8"));
		
		System.out.println("[debug] insertMemberAction.jsp 로직 종료");
		
		return;
	}
	
%>