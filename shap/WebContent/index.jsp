<%@page import="dao.NoticeDao"%>
<%@page import="vo.Notice"%>
<%@page import="vo.Category"%>
<%@page import="vo.Ebook"%>
<%@page import="dao.EbookDao"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.CategoryDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] index.jsp 로직 진입");	
	
    
 	// 페이지 설정
    int currentPage = 1;
    if(request.getParameter("currentPage") != null) {
    	currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    
    // 검색어 설정
    String searchEbookTitle = "ALL";
    if(request.getParameter("searchEbookTitle") != null) {
    	searchEbookTitle = request.getParameter("searchEbookTitle");
    }
    
	 // 카테고리 설정
 	String searchCategoryName = "ALL";
    if(request.getParameter("searchCategoryName") != null) {
    	searchCategoryName = request.getParameter("searchCategoryName");
    }
    
    // 자바에서 상수는 final을 붙이고 변수명을 upper case와 snake 표기식으로 한다.
    final int ROW_PER_PAGE = 20;
    int beginRow = (currentPage-1) * ROW_PER_PAGE;
   
   /* 카테고리 리스트 불러오기 */
    CategoryDao categoryDao = new CategoryDao();
    ArrayList<Category> categoryList = categoryDao.selectCategoryListByAdmin();
    
    
    /* 전자책 리스트 불러오기 */
    EbookDao ebookDao = new EbookDao();
    
    // 검색 조건에 맞는 전자책 개수 구하기
    int countEbookList = ebookDao.selectCountSearchedEbook(searchEbookTitle, searchCategoryName);
    
    // 전자책 리스트 불러오기
    ArrayList<Ebook> ebookList = ebookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(searchEbookTitle, searchCategoryName, beginRow, ROW_PER_PAGE);
    
    // 판매순(desc)으로 상위 전자책 5개를 노출
     ArrayList<Ebook> ebookListTop = ebookDao.selectEbookListTop();
    
     // 등록순(desc)으로 상위 전자책 5개를 노출
     ArrayList<Ebook> ebookListNew = ebookDao.selectEbookListNew();
     
     /* 공지사항 리스트 불러오기 */
     NoticeDao noticeDao = new NoticeDao();
     
     // 가장 최신의 공지사항 5개만 가져오기
     ArrayList<Notice> noticeList = noticeDao.selectNoticeList(0, 5, "ALL");

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
		<div class="container-fluid center-block" style="padding-top:50px;">
			<div class="text-center" style="padding-top:50px;">
				<h1>홈페이지</h1>
			</div>
			<div class="container-fluid center-block" style="padding-top:50px;">
				<h2>신규 상품</h2>
				<table class="table table-border">
					<tbody>
						<tr>
						<% 
							for (Ebook ebook : ebookListNew) {
						%>
								<td class="text-center" style="width: 20%" >
									<div>
										<a href="<%=request.getContextPath()%>/selectEbookOneByIndex.jsp?ebookNo=<%=ebook.getEbookNo() %>">
											<img src="<%=request.getContextPath()%>/images/<%=ebook.getEbookImg()%>" width="200px" height="200px">
										</a>
									</div>
									<a href="<%=request.getContextPath()%>/selectEbookOneByIndex.jsp?ebookNo=<%=ebook.getEbookNo() %>" style="color: black;">
										제목: <%=ebook.getEbookTitle()%>
									</a>
									<div>종류: <%=ebook.getCategoryName()%></div>
									<div>상태: <%=ebook.getEbookState()%></div>
								</td>
						<%
							}
						%>
						</tr>
					</tbody>
				</table>
				<br>
				<h2>인기 상품 TOP 5</h2>
				<table class="table table-border">
					<tbody>
						<tr>
						<% 
							for (Ebook ebook : ebookListTop) {
						%>
								<td class="text-center" style="width: 20%" >
									<div>
										<a href="<%=request.getContextPath()%>/selectEbookOneByIndex.jsp?ebookNo=<%=ebook.getEbookNo() %>">
											<img src="<%=request.getContextPath()%>/images/<%=ebook.getEbookImg()%>" width="200px" height="200px">
										</a>
									</div>
									<a href="<%=request.getContextPath()%>/selectEbookOneByIndex.jsp?ebookNo=<%=ebook.getEbookNo() %>" style="color: black;">
										제목: <%=ebook.getEbookTitle()%>
									</a>
									<div>종류: <%=ebook.getCategoryName()%></div>
									<div>상태: <%=ebook.getEbookState()%></div>
								</td>
						<%
							}
						%>
						</tr>
					</tbody>
				</table>
				<br>
				<div class="d-flex justify-content-between">
					<h2>최신 소식</h2>
					<a class="align-self-end" href="<%=request.getContextPath()%>/notice/selectNoticeList.jsp" ><span style="color: grey;">전체 보기</span></a>
				</div>
				<table class="table table-border">
					<tbody>
						
						<% 
							for (Notice notice : noticeList) {
						%>
							<tr>
								<td class="text-left" style="width: 80%">
									<div>
										<a href="<%=request.getContextPath()%>/notice/selectNoticeOne.jsp?noticeNo=<%=notice.getNoticeNo() %>" style="color: black;">
											<%=notice.getNoticeTitle() %>
										</a>
									</div>
								</td>
								<td class="text-right" style="width: 20%">
									<div><%=notice.getCreateDate()%></div>
								</td>
							</tr>
						<%
							}
						%>		
					</tbody>
				</table>
				<br>
				<h2>전체 상품</h2>
				<table class="table table-border">
					<tbody>
						<tr>
						<% 
							// <tr>의 개수
							int trIndex = 0;
						
							// <td>의 개수
							int tdIndex = 0; 
							
							// 전자책 개수를 이용하여 5개씩 한 줄로 전자책을 노출킬 수 있도록 필요한 <td>와 <tr>의 개수를 계산
							int ebookListTrLength = ebookList.size() / 5;
							int ebookListTdLength = ebookList.size() % 5;
						
							for (Ebook ebook : ebookList) {
								
								// 5개의 <td> 마다 <tr>을 추가
								if (tdIndex % 5 == 0) { 
									trIndex += 1;
						%>
									<tr>
						<%
								}
						%>
								
								<td class="text-center" style="width: 20%" >
									<div>
										<a href="<%=request.getContextPath()%>/selectEbookOneByIndex.jsp?ebookNo=<%=ebook.getEbookNo() %>">
											<img src="<%=request.getContextPath()%>/images/<%=ebook.getEbookImg()%>" width="200px" height="200px">
										</a>
									</div>
									<a href="<%=request.getContextPath()%>/selectEbookOneByIndex.jsp?ebookNo=<%=ebook.getEbookNo() %>" style="color: black;">
										제목: <%=ebook.getEbookTitle()%>
									</a>
									<div>종류: <%=ebook.getCategoryName()%></div>
									<div>상태: <%=ebook.getEbookState()%></div>
								</td>
								
						<% 
								tdIndex += 1;
								
								// 만약 모든 전차책을 출력한 뒤에, <tr>의 <td> 개수가 부족할 경우 부족한 수만큼 공백의 <td>를 채워줌
								if (trIndex == ebookListTrLength && ebookListTdLength != 4 && tdIndex == ebookListTdLength) {
									
									int requiredTdLength = 4 - tdIndex;
									
									for (int j = 0; j < requiredTdLength; j++){
						%>
										<td class="text-center" style="width: 20%" ></td>
						<%
									}
								}
								
								// 5개의 <td>마다 </tr>을 추가
								if (tdIndex % 5 == 0) { 
						%>
									</tr>
						<%
								}	
							}
						%>
						</tr>
						<tr>
							<td colspan="5">
								<div class="text-center">
									<!-- 네비게이션 페이징 스타일 적용  -->	
									<ul class="pagination justify-content-center" style="margin:20px 0">
										<%		
											/* 네비게이션 페이징 */
											// 한 페이지당 10개(ROW_PER_PAG)씩 담았을 때 생성될 마지막 페이지 계산
											int lastPage = countEbookList /ROW_PER_PAGE;			
										
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
											if (countEbookList % DISPLAY_RANGE_PAGE != 0 ) {							
												lastPage += 1;
											}
											
											// 페이징 범위 끝 숫자가 마지막 페이지 보다 더 크면 페이징 범위 끝 숫자를 마지막 페이지로 바꿈 (다음 버튼 노출 안 시키기 위해)
										    if(rangeEndPage >= lastPage ) {
										        rangeEndPage = lastPage; 
										     }
											
										    // 디버깅용
										    System.out.println("[debug] index.jsp => 현재 페이지 : " + currentPage);
										    System.out.println("[debug] index.jsp => 마지막 페이지 : " + lastPage);
										    System.out.println("[debug] index.jsp => 페이징 범위 단위값 : " + DISPLAY_RANGE_PAGE);
										    System.out.println("[debug] index.jsp => 페이징 시작 범위 숫자 : " + (rangeStartPage+1));
										    System.out.println("[debug] index.jsp => 페이징 끝 범위 숫자 : " + rangeEndPage);
										    System.out.println("[debug] index.jsp => 총 전자책 수 : " + countEbookList);	
										    
										    // 현재 페이지 범위가 네비게이션 페이징 범위 단위값 이상일 경우에만 이전 버튼을 노출(이전 버튼이 노출되어야 할 상황에만 노출시키기 위해)
											if( rangeStartPage > (DISPLAY_RANGE_PAGE - 1) ) {	
										%>
												<!-- &nbsp;는 HTML에서 띄어쓰기 특수문자 -->
												<!-- 쿼리스트링을 넘길 때에는 초기값은 "?", 그 뒤의 다른 값들이 있다면 "&"로 붙이며 사용한다. -->
												<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=1%>&searchEbookTitle=<%=searchEbookTitle%>&searchCategoryName=<%=searchCategoryName%>">처음으로</a></li>
												<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=rangeStartPage-9%>&searchEbookTitle=<%=searchEbookTitle%>&searchCategoryName=<%=searchCategoryName%>">이전</a></li>
										<%
											}
										    
											// 현 페이지의 페이징 범위에 맞는 네비게이션 버튼을 노출
											for (int i = rangeStartPage+1; i < rangeEndPage+1; i++) {				
										%>	
												<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=i%>&searchEbookTitle=<%=searchEbookTitle%>&searchCategoryName=<%=searchCategoryName%>"><%=i%></a></li>
										<%		
											}
											
											// 현재 페이지 범위가 총 페이지 개수의 마지막 개수보다 작을 경우에만 다음 버튼을 노출(다음 버튼이 노출되어야 할 상황에만 노출시키기 위해)
											if((rangeEndPage) < lastPage) {
										%>
												<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=rangeStartPage+11%>&searchEbookTitle=<%=searchEbookTitle%>&searchCategoryName=<%=searchCategoryName%>">다음</a></li>
												<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=lastPage%>&searchEbookTitle=<%=searchEbookTitle%>&searchCategoryName=<%=searchCategoryName%>">끝으로</a></li>
										<%
											}
										%>
									</ul>
									<form class="form-group" method="get" action="<%=request.getContextPath() %>/index.jsp">
										<div class="container-fluid row justify-content-center align-items-center" style="margin:20px 0">
											<select class="form-control" name="searchCategoryName" style="width:100px">
												<option value="ALL">전체</option>
												<%
													for (Category category : categoryList) {
												%>
														<option value="<%=category.getCategoryName() %>"><%=category.getCategoryName() %></option>
												<% 
													}
												%>
											</select>
											<input class="form-control text-center" type="text" name="searchEbookTitle" style="width:250px">
											<input class="btn btn-outline-info" type="submit"  value="검색">
										</div>		
									</form>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
<% 
	System.out.println("[debug] index.jsp 로직 종료");	
%>