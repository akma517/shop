<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateMemberPwAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] updateMemberPwAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
	
	
	// 유효성 검사를 위해 String으로 값을 받음
    String testMemberNo = request.getParameter("memberNo");
    String testMemberPw = request.getParameter("memberPwNew");
	
	// 디버깅
	System.out.println("[debug] updateMemberPwAction.jsp => 등급을 변경할 멤버 넘버 : " +  testMemberNo);
	System.out.println("[debug] updateMemberAction.jsp => 변경할 멤버 등급 : " +  testMemberPw);
	
	// 유효성 검사
	if ( testMemberNo == null || testMemberPw == null) {
		response.sendRedirect(request.getContextPath() + "/admin/updateMemberPwForm.jsp");
		System.out.println("[debug] updateMemberPwAction.jsp => selectMeberPwForm.jsp로 강제 이동: 비밀번호 수정값에 null값이 있어 이전 페이지로 돌려보냈습니다.");
		return; 
	}
	
	// 유효성 검사 끝나고 int 형으로 변환
    int memberNo = Integer.parseInt(testMemberNo);
    String memberPw = testMemberPw;
    
	// db 작업 위한 Dao 객체 생성
	MemberDao memberDao = new MemberDao();
	
	Member member = new Member();
	
	member.setMemberNo(memberNo);
	member.setMemberPw(memberPw);
	
	int confirm = memberDao.updateMemberPwByAdmin(member);
	
	if (confirm==1) {
		
		System.out.println("[debug] updateMemberPwAction.jsp => 비밀번호 수정 성공");
		response.sendRedirect(request.getContextPath() + "/admin/selectMemberList.jsp");
		
		System.out.println("updateMemberPwAction.jsp 로직 종료");
		
		return;
	} else {
		System.out.println("[debug] updateMemberPwAction.jsp => 비밀번호 수정 실패 : 입력 정보를 다시 확인해 주세요.");
		response.sendRedirect(request.getContextPath() + "/admin/updateMemberPwForm.jsp");
		
		System.out.println("[debug] updateMemberPwAction.jsp 로직 종료");		
		
		return;
	}
	
%>