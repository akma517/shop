<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
	/* 로그인 처리 */
	// input: request => memberId, memberPw
	// output(success): session => Member loginMember
	// output(false): 
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] loginAction.jsp 로직 진입");	
	
	/* 인증 방어 코드 : 로그인 전에만 페이지 열람 가능 */
	// 만약 로그인한 멤버가 loginActionm.jsp에 접근하려고 할 시, index.jsp 페이지로 강제 이동시킨다.
	Member member = (Member)session.getAttribute("loginMember");
	
	if (member != null) {
		response.sendRedirect("./index.jsp");
		System.out.println("[debug] lgoinAction.jsp => index.jsp로 강제 이동: 이미 로그인한 멤버의 강제 접근을 막았습니다.");
		return; 
	}
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// 로그인 정보값 디버깅
	System.out.println("[debug] loginAction.jsp => 로그인 정보 아이디 : " + memberId);
	System.out.println("[debug] loginAction.jsp => 로그인 정보 비밀번호 : " + memberPw);
	
	// 로그인 정보 유효성 검사
	if (memberId == null || memberPw == null) {
		response.sendRedirect("./loginForm.jsp");
		System.out.println("[debug] loginAction.jsp => loginForm.jsp로 강제 이동: 로그인 정보에 null값이 있어 이전 페이지로 돌려보냈습니다.");
		return; 
	}
	
	MemberDao memberDao = new MemberDao();
	
	member = new Member();
	member.setMemberId(memberId);
	member.setMemberPw(memberPw);
	
	Member returnedMember = memberDao.login(member);
	
	// 로그인 여부 디버깅
	if(returnedMember == null) {
		
		System.out.println("[debug] loginAction.jsp => 로그인 실패 : 일치하는 멤버 정보가 없음");
		response.sendRedirect("./loginForm.jsp");
		
		System.out.println("[debug] loginAction.jsp 로직 종료");	
		
		return;
		
	} else {
		
		System.out.println("[debug] loginAction.jsp => 로그인 성공");
		System.out.println("[debug] loginAction.jsp => 로그인 멤버 넘버 : " + returnedMember.getMemberNo());
		System.out.println("[debug] loginAction.jsp => 로그인 멤버 아이디 : " + returnedMember.getMemberId());
		System.out.println("[debug] loginAction.jsp => 로그인 멤버 이름 : " + returnedMember.getMemberName());
		System.out.println("[debug] loginAction.jsp => 로그인 멤버 레벨 : " + returnedMember.getMemberLevel());
		
		// session, request(생성하지 않아도 이미 생성되어 있는 jsp 내장 객체)
		// returnedMember 객체를 사용자의 session에 저장
		session.setAttribute("loginMember", returnedMember);
		
		response.sendRedirect("./index.jsp");
		
		System.out.println("[debug] loginAction.jsp 로직 종료");	
		
		return;
		
	}

%>