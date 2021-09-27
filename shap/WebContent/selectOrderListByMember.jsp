<%@page import="vo.OrderEbookMember"%>
<%@page import="dao.OrderDao"%>
<%@page import="vo.Category"%>
<%@page import="dao.CategoryDao"%>
<%@page import="dao.MemberDao"%>
<%@page import="vo.Ebook"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.EbookDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] selectOrderListByMember.jsp 로직 진입");	
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] selectOrderListByMember.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
    
 	// 페이지 설정
    int currentPage = 1;
    if(request.getParameter("currentPage") != null) {
    	currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    
    // 검색어 설정
    String searchOrderNo = "ALL";
    if(request.getParameter("searchOrderNo") != null) {
    	searchOrderNo = request.getParameter("searchOrderNo");
    }
    
    
    // 자바에서 상수는 final을 붙이고 변수명을 upper case와 snake 표기식으로 한다.
    final int ROW_PER_PAGE = 10;
    int beginRow = (currentPage-1) * ROW_PER_PAGE;
   
    // 주문 리스트 불러오기
    OrderDao orderDao = new OrderDao();
    
    // 검색 조건에 맞는 주문 개수 구하기
 	int countOrderList = orderDao.selectCountOrderList(searchOrderNo);
    
    // 검색 조건에 맞는 주문 목록 가져오기
    ArrayList<OrderEbookMember> oemList = orderDao.selectOrderListByMember(beginRow, ROW_PER_PAGE, searchOrderNo,  loginMember.getMemberNo());
    
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
			<jsp:include page="/partial/submenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="text-center" style="padding-top:50px;"><h1>주문 내역</h1></div>
		<div class="container-fluid center-block" style="padding-top:50px;">
			<table class="table table-hover">
				<thead class="thead-light">	
					<tr class="align-content-center">
						<th class="text-center" style="width: 20%">주문넘버</th>
						<th class="text-center" style="width: 20%">전자책 제목</th>
						<th class="text-center" style="width: 20%">주문 가격</th>
						<th class="text-center" style="width: 20%" >주문 날짜</th>
						<th class="text-center" style="width: 10%" ></th>
						<th class="text-center" style="width: 10%" ></th>
					</tr>
				</thead>
				<tbody>
					<% 
						for (OrderEbookMember oem : oemList) {
					%>
							<tr>
								<td class="text-center" style="width: 20%"><%=oem.getOrder().getOrderNo()%></td>
								<td class="text-center" style="width: 20%">
									<a href="<%=request.getContextPath() %>/selectEbookOneByIndex.jsp?ebookNo=<%=oem.getEbook().getEbookNo()%>"><%=oem.getEbook().getEbookTitle()%></a>
								</td>
								<td class="text-center" style="width: 20%"><%=oem.getOrder().getOrderPrice()%></td>
								<td class="text-center" style="width: 20%" ><%=oem.getOrder().getCreateDate()%></td>
								<td class="text-center" style="width: 10%" >
									<a href="<%=request.getContextPath() %>/admin/selectOrderOne.jsp?orderNo=<%=oem.getOrder().getOrderNo()%>">상세내역</a>
								</td>
								<td class="text-center" style="width: 10%" >
									<a href="<%=request.getContextPath() %>/insertOrderCommentForm.jsp?orderNo=<%=oem.getOrder().getOrderNo()%>&ebookNo=<%=oem.getEbook().getEbookNo()%>">후기작성</a>
								</td>
							</tr>
					<% 
						}
					%>
				</tbody>
			</table>
			<div class="text-center">
				<!-- 네비게이션 페이징 스타일 적용  -->	
				<ul class="pagination justify-content-center" style="margin:20px 0">
					<%		
						/* 네비게이션 페이징 */
						// 한 페이지당 10개(ROW_PER_PAG)씩 담았을 때 생성될 마지막 페이지 계산
						int lastPage = countOrderList /ROW_PER_PAGE;			
					
						// 화면 밑단에 보일 네비게이션 페이징 범위 단위값
						final int DISPLAY_RANGE_PAGE = 10;								
						
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
						if (countOrderList % DISPLAY_RANGE_PAGE != 0 ) {							
							lastPage += 1;
						}
										
						// 페이징 범위 끝 숫자가 마지막 페이지 보다 더 크면 페이징 범위 끝 숫자를 마지막 페이지로 바꿈 (다음 버튼 노출 안 시키기 위해)
						if(rangeEndPage >= lastPage ) {
							 rangeEndPage = lastPage; 
						}
										
						 // 디버깅용
						System.out.println("[debug] selectOrderListByMember.jsp => 현재 페이지 : " + currentPage);
						 System.out.println("[debug] selectOrderListByMember.jsp => 마지막 페이지 : " + lastPage);
						System.out.println("[debug] selectOrderListByMember.jsp => 페이징 범위 단위값 : " + DISPLAY_RANGE_PAGE);
						System.out.println("[debug] selectOrderListByMember.jsp => 페이징 시작 범위 숫자 : " + (rangeStartPage+1));
						 System.out.println("[debug] selectOrderListByMember.jsp => 페이징 끝 범위 숫자 : " + rangeEndPage);
						System.out.println("[debug] selectOrderListByMember.jsp => 총 주문 수 : " + countOrderList);	
									    
						 // 현재 페이지 범위가 네비게이션 페이징 범위 단위값 이상일 경우에만 이전 버튼을 노출(이전 버튼이 노출되어야 할 상황에만 노출시키기 위해)
						if( rangeStartPage > (DISPLAY_RANGE_PAGE - 1) ) {	
					%>
						<!-- &nbsp;는 HTML에서 띄어쓰기 특수문자 -->
						<!-- 쿼리스트링을 넘길 때에는 초기값은 "?", 그 뒤의 다른 값들이 있다면 "&"로 붙이며 사용한다. -->
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=1%>&searchOrderNo=<%=searchOrderNo%>">처음으로</a></li>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=rangeStartPage-9%>&searchOrderNo=<%=searchOrderNo%>">이전</a></li>
					<%
						}
									    
						// 현 페이지의 페이징 범위에 맞는 네비게이션 버튼을 노출
						for (int i = rangeStartPage+1; i < rangeEndPage+1; i++) {				
					%>	
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=i%>&searchOrderNo=<%=searchOrderNo%>"><%=i%></a></li>
					<%		
						}
										
						// 현재 페이지 범위가 총 페이지 개수의 마지막 개수보다 작을 경우에만 다음 버튼을 노출(다음 버튼이 노출되어야 할 상황에만 노출시키기 위해)
						if((rangeEndPage) < lastPage) {
					%>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=rangeStartPage+11%>&searchOrderNo=<%=searchOrderNo%>">다음</a></li>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=lastPage%>&searchOrderNo=<%=searchOrderNo%>">끝으로</a></li>
					<%
						}
					%>
				</ul>
				<form class="form-group" method="get" action="<%=request.getContextPath() %>/selectOrderListByMember.jsp">
					<div class="container-fluid row justify-content-center align-items-center" style="margin:20px 0">
						<input class="form-control text-center" type="text" name="searchOrderNo" style="width:250px">
						<input class="btn btn-outline-info" type="submit"  value="검색">
					</div>		
				</form>
			</div>
			<div class="text-right">
				<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-primary btn-sm">홈페이지로</a>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] selectOrderListByMember.jsp 로직 종료");	
%>