<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] insertMemberAction.jsp 로직 진입");
	
	/* 인증 방어 코드 : 로그인 전에만 페이지 열람 가능 */
	// 만약 로그인한 멤버가 insertMemberAction.jsp에 접근할 시, index.jsp 페이지로 강제 이동시킨다.
	Member member = (Member)session.getAttribute("loginMember");
	
	if (member != null) {
		response.sendRedirect("./index.jsp");
		System.out.println("[debug] insertMemberAction.jsp => index.jsp로 강제 이동: 이미 로그인한 멤버의 강제 접근을 막았습니다.");
		return; 
	}
	
	// 가입 정보 넘겨 받기
	String memberId = request.getParameter("memberId");
	String memberName = request.getParameter("memberName");
	String memberAgeString = request.getParameter("memberAge");
	String memberGender = request.getParameter("memberGender");
	String memberPw = request.getParameter("memberPw");
	
	// 가입 정보값 디버깅
	System.out.println("[debug] insertMemberAction.jsp => 가입 정보 아이디 : " + memberId);
	System.out.println("[debug] insertMemberAction.jsp => 가입 정보 이름 : " +  memberName);
	System.out.println("[debug] insertMemberAction.jsp => 가입 정보 나이 : " + memberAgeString);
	System.out.println("[debug] insertMemberAction.jsp => 가입 정보 성별 : " + memberGender);
	System.out.println("[debug] insertMemberAction.jsp => 가입 정보 비밀번호 : " + memberPw);
	
	// 가입 정보 유효성 검사
	if (memberId == null || memberName == null || memberAgeString == null || memberGender == null || memberPw == null) {
		response.sendRedirect("./insertMemberForm.jsp");
		System.out.println("[debug] insertMemberAction.jsp => insertMemberForm.jsp로 강제 이동: 가입 정보에 null값이 있어 이전 페이지로 돌려보냈습니다.");
		return; 
	}
	
	// 유효성 검사 후, memeberAge의 타입에 맞게 형 변환
	int memberAge = Integer.parseInt(memberAgeString);
	
	// db 작업 위한 Dao 객체 생성
	MemberDao memberDao = new MemberDao();
			
	// 가입 정보 세팅
	member = new Member();
	
	member.setMemberId(memberId);
	member.setMemberName(memberName);
	member.setMemberAge(memberAge);
	member.setMemberGender(memberGender);
	member.setMemberPw(memberPw);
	
	int confirm = memberDao.insertMember(member);
	
	if (confirm==1) {
		
		System.out.println("[debug] insertMemberAction.jsp => 회원가입 성공");
		response.sendRedirect("./index.jsp");
		
		
		System.out.println("[debug] insertMemberAction.jsp 로직 종료");
		
		return;
	} else {
		System.out.println("[debug] insertMemberAction.jsp => 회원가입 실패 : 입력 정보를 다시 확인해 주세요.");
		response.sendRedirect("./index.jsp");
		
		
		System.out.println("[debug] insertMemberAction.jsp 로직 종료");
		
		return;
	}
	
%>