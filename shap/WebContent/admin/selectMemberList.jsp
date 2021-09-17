<%@page import="dao.MemberDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] selectMemberList.jsp 로직 진입");	
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] slectMemberList.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
    
    // 페이지 설정
    int currentPage = 1;
    if(request.getParameter("currentPage") != null) {
    	currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    
    // 검색어 설정
    String searchMemberId = "";
    if(request.getParameter("searchMemberId") != null) {
    	searchMemberId = request.getParameter("searchMemberId");
    }
    
    // 자바에서 상수는 final을 붙이고 변수명을 upper case와 snake 표기식으로 한다.
    final int ROW_PER_PAGE = 10;
    int beginRow = (currentPage-1) * ROW_PER_PAGE;
    
    MemberDao memberDao = new MemberDao();
    ArrayList<Member> memberList = null;
    
    
    
    // 검색어가 있을 떄와 없을 때를 구분하여 페이징을 구현
    int countMember =0;
    
    if (searchMemberId.equals("") == true) {
    	
    	// 검색어가 없을 경우
       	memberList = memberDao.selectMemberListByPage(beginRow, ROW_PER_PAGE);
        countMember = memberDao.selectCountMember(ROW_PER_PAGE);
        
    } else {
    	
    	// 검색어가 있을 경우
       	memberList = memberDao.selectMemberListBySearchMemberId(searchMemberId, beginRow, ROW_PER_PAGE);
        countMember = memberDao.selectCountSearchedMember(searchMemberId, ROW_PER_PAGE);
    	
    }
    
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>자바 송현우</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<style type="text/css">
		
		.centerSearchBar{
			position: absolute;
			left: 50%;
			transform: translate(-50%, -50%);
			z-index: 1;
		}
	</style>
</head>
<body>
	<div class="container-fluid pt-3">
		<!-- 서브메뉴 시작 -->
		<div>
			<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="text-center" style="padding-top:50px;"><h1>회원 목록</h1></div>
		<div class="container-fluid center-block" style="padding-top:50px;">
			<table class="table">
				<thead class="thead-light">	
					<tr class="align-content-center">
						<th class="text-center" style="width: 5%">넘버</th>
						<th class="text-center" style="width: 7%">등급</th>
						<th class="text-center" style="width: 10%">이름</th>
						<th class="text-center" style="width: 10%" >나이</th>
						<th class="text-center" style="width: 10%" >성별</th>
						<th class="text-center" style="width: 20%" >수정날짜</th>
						<th class="text-center" style="width: 20%" >가입날짜</th>
						<th class="text-center" style="width: 5%" ></th>
						<th class="text-center" style="width: 8%" ></th>
						<th class="text-center" style="width: 5%" ></th>
					</tr>
				</thead>
				<tbody>
					<% 
						for (Member member : memberList) {
					%>
							<tr>
								<td class="text-center" style="width: 5%"><%=member.getMemberNo()%></td>
								<td class="text-center" style="width: 7%">
				                     <%
				                        if(member.getMemberLevel() == 0) {
				                     %>
				                           <span>일반회원</span>
				                     <%      
				                        } else if(member.getMemberLevel() == 1) {
				                     %>
				                           <span>관리자</span>
				                     <%      
				                        }
				                     %>
								</td>
								<td class="text-center" style="width: 10%"><%=member.getMemberName()%></td>
								<td class="text-center" style="width: 10%" ><%=member.getMemberAge()%>세</td>
								<td class="text-center" style="width: 10%" ><%=member.getMemberGender()%></td>
								<td class="text-center" style="width: 20%" ><%=member.getUpdateDate()%></td>
								<td class="text-center" style="width: 20%" ><%=member.getCreateDate()%></td>
								<td class="text-center" style="width: 5%" >
									<a href="<%=request.getContextPath() %>/admin/updateMemberLevelForm.jsp?memberNo=<%=member.getMemberNo() %>" class="btn btn-outline-primary btn-sm">등급수정</a>
								</td>
								<td class="text-center" style="width: 8%" >
									<a href="<%=request.getContextPath() %>/admin/updateMemberPwForm.jsp?memberNo=<%=member.getMemberNo() %>" class="btn btn-outline-primary btn-sm">비밀번호수정</a>
								</td>
								<td class="text-center" style="width: 5%" >
									<a href="<%=request.getContextPath() %>/admin/deleteMember.jsp?memberNo=<%=member.getMemberNo() %>" class="btn btn-outline-danger btn-sm">강제탈퇴</a>
								</td>
							</tr>
					<% 
						}
					%>
					<tr>
						<td colspan="10">
							<div class="text-center">
								<!-- 네비게이션 페이징 스타일 적용  -->	
								<ul class="pagination justify-content-center" style="margin:20px 0">
									<%		
										/* 네비게이션 페이징 */
										// 한 페이지당 10개(ROW_PER_PAG)씩 담았을 때 생성될 마지막 페이지 계산
										int lastPage = countMember /ROW_PER_PAGE;			
									
										// 화면 밑단에 보일 네비게이션 페이징 범위 단위값
										int DISPLAY_RANGE_PAGE = 10;								
										
										// 현 페이징 범위 시작 숫자를 계산
										int rangeStartPage = ((currentPage / DISPLAY_RANGE_PAGE) * DISPLAY_RANGE_PAGE);			
										
										// 현 페이징 범위 끝 숫자를 계산
										int rangeEndPage = ((currentPage / DISPLAY_RANGE_PAGE) * DISPLAY_RANGE_PAGE) + DISPLAY_RANGE_PAGE;		
										
										
										// 네비게이션 페이징 범위 속 끝 페이지가 클릭되어도 네비게이션 페이징이 다음 범위로 이동하지 않기 위한 조건문 
										if ((currentPage % DISPLAY_RANGE_PAGE) == 0) {
											rangeStartPage -= DISPLAY_RANGE_PAGE;
											rangeEndPage -= DISPLAY_RANGE_PAGE;
										}
										
										// 마지막 페이지 정확히 계산
										if (countMember % DISPLAY_RANGE_PAGE != 0 ) {							
											lastPage += 1;
										}
										
										// 페이징 범위 끝 숫자가 마지막 페이지 보다 더 크면 페이징 범위 끝 숫자를 마지막 페이지로 바꿈 (다음 버튼 노출 안 시키기 위해)
									    if(rangeEndPage >= lastPage ) {
									        rangeEndPage = lastPage; 
									     }
										
									    // 디버깅용
									    System.out.println("[debug] 현재 페이지 : " + currentPage);
									    System.out.println("[debug] 마지막 페이지 : " + lastPage);
									    System.out.println("[debug] 페이징 범위 단위값 : " + DISPLAY_RANGE_PAGE);
									    System.out.println("[debug] 페이징 시작 범위 숫자 : " + (rangeStartPage+1));
									    System.out.println("[debug] 페이징 끝 범위 숫자 : " + rangeEndPage);
									    System.out.println("[debug] 총 멤버 수 : " + countMember);	
									    
									    // 현재 페이지 범위가 네비게이션 페이징 범위 단위값 이상일 경우에만 이전 버튼을 노출(이전 버튼이 노출되어야 할 상황에만 노출시키기 위해)
										if( rangeStartPage > (DISPLAY_RANGE_PAGE - 1) ) {	
									%>
											<!-- &nbsp;는 HTML에서 띄어쓰기 특수문자 -->
											<!-- 쿼리스트링을 넘길 때에는 초기값은 "?", 그 뒤의 다른 값들이 있다면 "&"로 붙이며 사용한다. -->
											<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=1%>&searchMemberId=<%=searchMemberId%>">처음으로</a></li>
											<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=rangeStartPage-9%>&searchMemberId=<%=searchMemberId%>">이전</a></li>
									<%
										}
									    
										// 현 페이지의 페이징 범위에 맞는 네비게이션 버튼을 노출
										for (int i = rangeStartPage+1; i < rangeEndPage+1; i++) {				
									%>	
											<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=i%>&searchMemberId=<%=searchMemberId%>"><%=i%></a></li>
									<%		
										}
										
										// 현재 페이지 범위가 총 페이지 개수의 마지막 개수보다 작을 경우에만 다음 버튼을 노출(다음 버튼이 노출되어야 할 상황에만 노출시키기 위해)
										if((rangeEndPage) < lastPage) {
									%>
											<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=rangeStartPage+11%>&searchMemberId=<%=searchMemberId%>">다음</a></li>
											<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=lastPage%>&searchMemberId=<%=searchMemberId%>">끝으로</a></li>
									<%
										}
									%>
								</ul>

								<form class="form-group" method="get" action="<%=request.getContextPath() %>/admin/selectMemberList.jsp">
									<div class="container-fluid row justify-content-center align-items-center" style="margin:20px 0">
										<input class="form-control text-center" type="text" name="searchMemberId" style="width:250px">
										<input class="btn btn-outline-info" type="submit"  value="검색">
									</div>		
								</form>
							</div>
							<div class="text-right">
								<a href="<%=request.getContextPath() %>/admin/adminIndex.jsp" class="btn btn-outline-primary btn-sm">관리자페이지로</a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] selectMemberList.jsp 로직 종료");	
%>