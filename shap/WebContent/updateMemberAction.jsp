<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateMemberAction.jsp 로직 진입");
	
	// 만약 로그인하지 않은 멤버가 updateMemberAction.jsp에 접근할 시, index.jsp 페이지로 강제 이동시킨다.
	Member member = (Member)session.getAttribute("loginMember");
	
	if (member == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] updateMemberAction.jsp => index.jsp로 강제 이동: 이미 로그인한 멤버의 강제 접근을 막았습니다.");
		return; 
	}
	
	// 수정 정보 넘겨 받기
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String memberName = request.getParameter("memberName");
	int memberAge = Integer.parseInt(request.getParameter("memberAge"));
	String memberGender = request.getParameter("memberGender");
	
	// 입력값 디버깅
	System.out.println("[debug] updateMemberAction.jsp => 수정할 회원 넘버 : " + memberNo);
	System.out.println("[debug] updateMemberAction.jsp => 수정할 회원 이름 : " +  memberName);
	System.out.println("[debug] updateMemberAction.jsp => 수정할 회원 나이 : " + memberAge);
	System.out.println("[debug] updateMemberAction.jsp => 수정할 회원 성별 : " + memberGender);
	
	// db 작업 위한 Dao 객체 생성
	MemberDao memberDao = new MemberDao();
			
	// 수정정보 세팅
	member = new Member();
	
	member.setMemberNo(memberNo);
	member.setMemberName(memberName);
	member.setMemberAge(memberAge);
	member.setMemberGender(memberGender);
	
	// 회원정보 수정 진행
	int confirm = memberDao.updateMember(member);
	
	if (confirm==1) {
		
		// 갱신된 정보를 서브메뉴에서도 바로 적용할 수 있도록 세션속 멤버 객체도 갱신
		member = memberDao.selectMemberOne(memberNo);
		session.setAttribute("loginMember", member);
		
		System.out.println("[debug] updateMemberAction.jsp => 회원정보 수정 성공");
		response.sendRedirect(request.getContextPath() + "/selectMemberOne.jsp");
		
		System.out.println("[debug] updateMemberAction.jsp 로직 종료");
		
		return;
		
	} else {
		
		System.out.println("[debug] updateMemberAction.jsp => 회원정보 수정 실패 : 입력 정보를 다시 확인해 주세요.");
		response.sendRedirect(request.getContextPath() + "/updateMemberForm.jsp");
		
		System.out.println("[debug] updateMemberAction.jsp 로직 종료");
		
		return;
	}
	
%>