<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateMemberLevelAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] updateMemberLevelAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
	
    // 유효성 검사를 위해 String으로 값을 받음
    String testMemberNo = request.getParameter("memberNo");
    String testMemberLevel = request.getParameter("memberLevel");
	
	// 디버깅
	System.out.println("[debug] updateMemberLevelAction.jsp => 등급을 변경할 멤버 넘버 : " +  testMemberNo);
	System.out.println("[debug] updateMemberLevelAction.jsp => 변경할 멤버 등급 : " +  testMemberLevel);
	
	// 유효성 검사
	if ( testMemberNo == null || testMemberLevel == null) {
		response.sendRedirect(request.getContextPath() + "/admin/updateMemberForm.jsp");
		System.out.println("[debug] updateMemberLevelAction.jsp => updatetMemberLevelForm.jsp로 강제 이동: 회원 정보 수정값에 null값이 있어 이전 페이지로 돌려보냈습니다.");
		return; 
	}
	
	// 유효성 검사 끝나고 int 형으로 변환
    int memberNo = Integer.parseInt(testMemberNo);
    int memberLevel = Integer.parseInt(testMemberLevel);

	// db 작업 위한 Dao 객체 생성
	MemberDao memberDao = new MemberDao();
			
	// 멤버 정보 설정
	Member member = new Member();
	
	member.setMemberNo(memberNo);
	member.setMemberLevel(memberLevel);
	
	
	int confirm = memberDao.updateMemberLevelByAdmin(member);
	
	if (confirm==1) {
		
		System.out.println("[debug] updateMemberLevelAction.jsp => 회원 등급 수정 성공");
		response.sendRedirect(request.getContextPath() + "/admin/selectMemberList.jsp");
		
		System.out.println("[debug] updateMemberLevelAction.jspp 로직 종료");
		
		return;
	} else {
		
		System.out.println("[debug] updateMemberLevelAction.jsp => 회원 등급 수정 실패 : 입력 정보를 다시 확인해 주세요.");
		response.sendRedirect(request.getContextPath() + "/admin/updateMemberLevelForm.jsp");
		
		System.out.println("[debug] updateMemberLevelAction.jsp 로직 종료");
		
		return;
	}

%>