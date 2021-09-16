<%@page import="dao.MemberDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자바 송현우</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<style>
		.center-block{
		position: absolute;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		z-index: 1;
		}
	</style>
</head>
<body>
<%
	/* 사전 작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateMemberLevelForm.jsp 로직 진입");	
%>
	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="container pt-3 center-block" style="width:330px; padding:15px;">
		<%
			
			/* admin 방어 코드 */
			// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
		    Member loginMember = (Member)session.getAttribute("loginMember");
		    if(loginMember == null || loginMember.getMemberLevel() < 1) {
		       response.sendRedirect(request.getContextPath()+"/index.jsp");
		       System.out.println("[debug] updateMemberLevelForm.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
		       return;
		    }
					
			// db 작업 위한 Dao 객체 생성
			MemberDao memberDao = new MemberDao();
			
		    String memberNo = request.getParameter("memberNo");
		    
			// 디버깅
			System.out.println("[debug] updateMemberLevelAction.jsp => 등급을 변경할 멤버 넘버 : " +  memberNo);
			
			// 유효성 검사
			if ( memberNo == null) {
				response.sendRedirect(request.getContextPath() + "/admin/selectMemberList.jsp");
				System.out.println("[debug] updateMemberLevelForm.jsp => selectMemberList.jsp로 강제 이동: 회원 넘버값에 null값이 있어 이전 페이지로 돌려보냈습니다.");
				return; 
			}
					
			// 멤버 정보 가져오기
			Member member = memberDao.selectMemberOneByAdmin(memberNo);
		%>
			<div class="center-block text-center" style="width:300px; padding:15px;">
				<h1>회원정보 수정</h1>
				<form class="form-group" method="post" action="<%=request.getContextPath()%>/admin/updateMemberLevelAction.jsp">
					<div>넘버 : </div>
					<div><input class="form-control" type="text" name="memberNo" value="<%=member.getMemberNo() %>" readonly="readonly"></div>
					<div>아이디 : </div>
					<div><input class="form-control" type="text" name="memberId" value="<%=member.getMemberId() %>" readonly="readonly"></div>
					<div>이름 : </div>
					<div><input class="form-control" type="text" name="memberName" value="<%=member.getMemberName() %>" readonly="readonly"></div>
					<div>나이 : </div>
					<div><input class="form-control" type="text" name="memberAge" value="<%=member.getMemberAge() %>세" readonly="readonly"></div>
					<div>성별 : </div>
					<div><input class="form-control" type="text" name="memberGender" value="<%=member.getMemberGender() %>" readonly="readonly"></div>
					<div class="form-group">
						<label for="memberLevel">등급</label>
						<select class="form-control" name="memberLevel">
					    	<option value="0">일반회원</option>
					    	<option value="1">관리자</option>
						</select>
					</div>
					<div>가입날짜 : </div>
					<div><input class="form-control" type="text" name="createDate" value="<%=member.getCreateDate() %>" readonly="readonly"></div>
					<div>수정날짜 : </div>
					<div><input class="form-control" type="text" name="updateDate" value="<%=member.getUpdateDate() %>" readonly="readonly"></div>
					<br>
					<div><input class="btn btn-outline-primary" type="submit" value="회원정보 수정"></div>
				</form>
			<%
				System.out.println("[debug] updateMemberLevelForm.jsp 로직 종료");
			%>
			</div>
		</div>
	</div>
</body>
</html>