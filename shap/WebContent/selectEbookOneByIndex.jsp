<%@page import="vo.OrderCommentMember"%>
<%@page import="dao.OrderCommentDao"%>
<%@page import="dao.OrderDao"%>
<%@page import="vo.OrderComment"%>
<%@page import="java.util.ArrayList"%>
<%@page import="vo.Ebook"%>
<%@page import="dao.EbookDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] selectEbookOneByIndex.jsp 로직 진입");	

	// 로그인 정보가 없어도 열람은 가능하도록 강제 이동시키지 않음
    Member loginMember = (Member)session.getAttribute("loginMember");
    
 	// 전자책 상세보기 설정
    int ebookNo = 1;
    if(request.getParameter("ebookNo") != null) {
    	ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
    }
    
 	// 페이지 설정
    int currentPage = 1;
    if(request.getParameter("currentPage") != null) {
    	currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    
    // 자바에서 상수는 final을 붙이고 변수명을 upper case와 snake 표기식으로 한다.
    final int ROW_PER_PAGE = 10;
    int beginRow = (currentPage-1) * ROW_PER_PAGE;
   
    EbookDao ebookDao = new EbookDao();
    OrderCommentDao orderCommentDao = new OrderCommentDao();
    
    // 전자책 정보 불러오기
    Ebook ebook = ebookDao.selectEbookOneByAdmin(ebookNo);
    
    // 전자책 리뷰 점수 평균 구하기
    double avgOrderScore = orderCommentDao.selectAvgOrderScore(ebookNo);
    
    // 리뷰 불러오기(페이징 포함)
    int countOrderCommentList = orderCommentDao.selectCountOrderComment(ebookNo);
    ArrayList<OrderCommentMember> orderCommentMemberList = orderCommentDao.selectOrderCommentList(beginRow, ROW_PER_PAGE, ebookNo);
    
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
		<div class="text-center" style="padding-top:50px;"><h1>상품 상세보기</h1></div>
		<div class="container center-block" style="padding-top:50px;">
			<table class="table table-bordered">
				<tbody>
					<tr>
						<td class="text-center" rowspan="4" colspan="2"><img src="<%=request.getContextPath()%>/images/<%=ebook.getEbookImg()%>"></td>
						<td class="text-center align-middle table-active">제목</td>
						<td class="text-center align-middle"><%=ebook.getEbookTitle()%></td>
						<td class="text-center align-middle table-active">출판사</td>
						<td class="text-center align-middle"><%=ebook.getEbookCompany()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle table-active">저자</td>
						<td class="text-center align-middle"><%=ebook.getEbookAuthor()%></td>
						<td class="text-center align-middle table-active">종류</td>
						<td class="text-center align-middle"><%=ebook.getCategoryName()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle table-active">페이지 수</td>
						<td class="text-center align-middle"><%=ebook.getEbookPageCount()%></td>
						<td class="text-center align-middle table-active">상태</td>
						<td class="text-center align-middle"><%=ebook.getEbookState()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle table-active">ISBN</td>
						<td class="text-center align-middle"><%=ebook.getEbookISBN()%></td>
						<td class="text-center align-middle table-active">넘버</td>
						<td class="text-center align-middle"><%=ebook.getEbookNo()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle table-active">등록날짜</td>
						<td class="text-center align-middle"><%=ebook.getCreateDate()%></td>
						<td class="text-center align-middle table-active">리뷰 평점</td>
						<td class="text-center align-middle" colspan=><%=avgOrderScore%></td>
						<td class="text-center align-middle table-active">가격</td>
						<td class="text-center align-middle"><%=ebook.getEbookPrice()%>원</td>
					</tr>
					<tr>
						<td class="text-center align-middle table-active">설명</td>
						<td class="text-center align-middle" colspan="6"><%=ebook.getEbookSummary()%></td>
					</tr>
				</tbody>
			</table>
			<div class="text-right">
				<%
					if (loginMember != null) {
				%>
						<a href="<%=request.getContextPath() %>/insertOrderAction.jsp?ebookNo=<%=ebook.getEbookNo() %>&orderPrice=<%=ebook.getEbookPrice() %>" class="btn btn-outline-info btn-sm">주문하기</a>
				<%
					} else {
				%>
						<a href="<%=request.getContextPath() %>/loginForm.jsp" class="btn btn-outline-info btn-sm">로그인 후 주문하기</a>					
				<%
					}
				%>
				<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-primary btn-sm">홈페이지</a>
			</div>
			<table class="table table-borderless" style="border-collapse: collapse">
				<thead>
					<tr  style="border-bottom: 2px solid black">
						<th class="text-left" colspan="3"><h2>댓글목록</h2></th>
						<th class="text-right"><%=countOrderCommentList %>개</th>
					</tr>
				</thead>
				<tbody>
				<%
					for(OrderCommentMember ocm :orderCommentMemberList){
				%>
						<tr style="border-bottom: 1px solid grey">
							<td class="text-left align-middle" width="20%"><%=ocm.getMember().getMemberName()%>[<%=ocm.getMember().getMemberId()%>]</td>
							<td class="text-center align-middle" width="60%"><%=ocm.getOrderComment().getOrderCommentContent()%></td>
							<td class="text-right align-middle" width="5%"><%=ocm.getOrderComment().getOrderScore() %>점</td>
							<td class="text-right" width="15%"><%=ocm.getOrderComment().getCreateDate() %></td>
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
						int lastPage = countOrderCommentList / ROW_PER_PAGE;			
					
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
						if (countOrderCommentList % DISPLAY_RANGE_PAGE != 0 ) {							
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
						System.out.println("[debug] selectOrderListByMember.jsp => 총 리뷰 개수 : " + countOrderCommentList);	
									    
						 // 현재 페이지 범위가 네비게이션 페이징 범위 단위값 이상일 경우에만 이전 버튼을 노출(이전 버튼이 노출되어야 할 상황에만 노출시키기 위해)
						if( rangeStartPage > (DISPLAY_RANGE_PAGE - 1) ) {	
					%>
						<!-- &nbsp;는 HTML에서 띄어쓰기 특수문자 -->
						<!-- 쿼리스트링을 넘길 때에는 초기값은 "?", 그 뒤의 다른 값들이 있다면 "&"로 붙이며 사용한다. -->
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookOneByIndex.jsp?currentPage=<%=1%>&ebookNo=<%=ebookNo %>">처음으로</a></li>
						<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookOneByIndex.jsp?currentPage=<%=rangeStartPage-9%>&ebookNo=<%=ebookNo %>">이전</a></li>
					<%
						}
									    
						// 현 페이지의 페이징 범위에 맞는 네비게이션 버튼을 노출
						for (int i = rangeStartPage+1; i < rangeEndPage+1; i++) {				
					%>	
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookOneByIndex.jsp?currentPage=<%=i%>&ebookNo=<%=ebookNo %>"><%=i%></a></li>
					<%		
						}
										
						// 현재 페이지 범위가 총 페이지 개수의 마지막 개수보다 작을 경우에만 다음 버튼을 노출(다음 버튼이 노출되어야 할 상황에만 노출시키기 위해)
						if((rangeEndPage) < lastPage) {
					%>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookOneByIndex.jsp?currentPage=<%=rangeStartPage+11%>&ebookNo=<%=ebookNo %>">다음</a></li>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookOneByIndex.jsp?currentPage=<%=lastPage%>&ebookNo=<%=ebookNo %>">끝으로</a></li>
					<%
						}
					%>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] selectEbookOneByIndex.jsp 로직 종료");	
%>