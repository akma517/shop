<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] deleteMemberAction.jsp 로직 진입");
	
	// 만약 로그인하지 않은 멤버가 deleteMemberAction.jsp에 접근할 시, index.jsp 페이지로 강제 이동시킨다.
	Member member = (Member)session.getAttribute("loginMember");
	
	if (member == null) {
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		System.out.println("[debug] deleteMemberAction.jsp => index.jsp로 강제 이동: 이미 로그인한 멤버의 강제 접근을 막았습니다.");
		return; 
	}
	
	// 수정 정보 넘겨 받기
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String memberPw = request.getParameter("memberPw");
	
	// 입력값 디버깅
	System.out.println("[debug] deleteMemberAction.jsp => 탈퇴할 회원 넘버 : " + memberNo);
	System.out.println("[debug] deleteMemberAction.jsp => 탈퇴할 회원이 입력한 비밀번호 : " +  memberPw);
	
	// db 작업 위한 Dao 객체 생성
	MemberDao memberDao = new MemberDao();
	
	// 수정정보 세팅
	member = new Member();
	
	member.setMemberNo(memberNo);
	member.setMemberPw(memberPw);

	// 입력한 비밀번호가 등록된 회원정보와 일치하는지 검사
	int confirm = memberDao.selectMemberPwCompare(member);
	
	// 일치하지 않다면 탈퇴 취소
	if (confirm==0) {
		
		System.out.println("[debug] deleteMemberAction.jsp => 비밀번호 수정 실패: 입력하신 비밀번호가 등록된 회원정보와 일치하지 않습니다.");
		response.sendRedirect(request.getContextPath() + "/deleteMemberForm.jsp");
		
		System.out.println("[debug] deleteMemberAction.jsp 로직 종료");
		
		return;
		
	// 일치하다면 회원탈퇴 진행
	} else {
		
		member.setMemberNo(memberNo);
		
		confirm = memberDao.deleteMember(member);
		
		if (confirm==1) {
			
			System.out.println("[debug] deleteMemberAction.jsp => 회원탈퇴 성공");
			response.sendRedirect(request.getContextPath() + "/logOut.jsp");
			
			System.out.println("[debug] deleteMemberAction.jsp 로직 종료");
			
			return;
			
		} else {
			
			System.out.println("[debug] udeleteMemberAction.jsp => 비밀번호 수정 실패 : 입력 정보를 다시 확인해 주세요.");
			response.sendRedirect(request.getContextPath() + "/deleteMemberForm.jsp");
			
			System.out.println("[debug] udeleteMemberAction.jsp 로직 종료");
			
			return;
		}
		
	}
%>