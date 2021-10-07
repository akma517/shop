<%@page import="vo.QnaMember"%>
<%@page import="vo.Qna"%>
<%@page import="dao.QnaDao"%>
<%@page import="dao.NoticeDao"%>
<%@page import="vo.Notice"%>
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
	System.out.println("[debug] selectQnaList.jsp 로직 진입");	
	
	// 로그인 정보가 없어도 열람은 가능하도록 강제 이동시키지 않음
    Member loginMember = (Member)session.getAttribute("loginMember");
    
 	// 페이지 설정
    int currentPage = 1;
    if(request.getParameter("currentPage") != null) {
    	currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }
    
    // 검색어 설정
    String searchQnaTitle = "ALL";
    if( request.getParameter("searchQnaTitle") != null ) {
    	searchQnaTitle  = request.getParameter("searchQnaTitle");
    }
    
    // 카테고리 설정
    String searchQnaCategory = "ALL";
    if( request.getParameter("searchQnaCategory") != null ) {
    	searchQnaCategory  = request.getParameter("searchQnaCategory");
    }
    
    // 자바에서 상수는 final을 붙이고 변수명을 upper case와 snake 표기식으로 한다.
    final int ROW_PER_PAGE = 10;
    int beginRow = (currentPage-1) * ROW_PER_PAGE;
   
    /* qna 불러오기 */
    QnaDao qnaDao = new QnaDao();
    
    // 검색 조건에 맞는 qna 개수 구하기
 	int countQnaList = qnaDao.selectCountQnaList(searchQnaTitle, searchQnaCategory);
    
    // 검색 조건에 맞는 qna 목록 가져오기
    ArrayList<QnaMember> qnaMemberList = qnaDao.selectQnaList(beginRow, ROW_PER_PAGE, searchQnaTitle, searchQnaCategory);
    
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
		<div class="text-center" style="padding-top:50px;"><h1>Q&A 목록</h1></div>
		<div class="container-fluid center-block" style="padding-top:50px;">
			<table class="table table-hover">
				<thead class="thead-light">	
					<tr class="align-content-center">
						<th class="text-left" style="width: 20%">&nbsp;종류</th>
						<th class="text-center" style="width: 40%">제목</th>
						<th class="text-center" style="width: 20%">작성자</th>
						<th class="text-right" style="width: 20%">등록날짜&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<% 
						for ( QnaMember qnaMember : qnaMemberList ) {
							if ( qnaMember.getQna().getQnaSecret().equals("N") || ( qnaMember.getQna().getQnaSecret().equals("Y") && ( qnaMember.getMember().getMemberNo() == loginMember.getMemberNo() ) ) ) {
					%>
								<tr>
									<td class="text-left" style="width: 20%">
										<%=qnaMember.getQna().getQnaCategory()%>
									</td>
									<td class="text-center" style="width: 40%">
										<a href="<%=request.getContextPath()%>/qna/selectQnaOne.jsp?qnaNo=<%=qnaMember.getQna().getQnaNo() %>" style="color: black;">
											<%=qnaMember.getQna().getQnaTitle() %>
										</a>
									</td>
	
									<td class="text-center" style="width: 20%">
										<%=qnaMember.getMember().getMemberName() %>[<%=qnaMember.getMember().getMemberId() %>]
									</td>
									<td class="text-right" style="width: 20%">
										<%=qnaMember.getQna().getCreateDate()%>
									</td>
								</tr>
					<% 
							} else {
					%>
								<tr>
									<td class="text-left" style="width: 20%">
										<%=qnaMember.getQna().getQnaCategory()%>
									</td>
									<td class="text-center" style="width: 40%">비밀글입니다.</td>
									<td class="text-center" style="width: 20%">
										<%=qnaMember.getMember().getMemberName() %>[<%=qnaMember.getMember().getMemberId() %>]
									</td>
									<td class="text-right" style="width: 20%">
										<%=qnaMember.getQna().getCreateDate()%>
									</td>
								</tr>
					<%
							}
						}
					%>
				</tbody>
			</table>
			<div class="text-right">
				<%
					if ( loginMember != null ) {
				%>
						<a href="<%=request.getContextPath() %>/qna/insertQnaForm.jsp" class="btn btn-outline-primary btn-sm">등록</a>
				<%
					}
				%>			
				<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-primary btn-sm">홈페이지</a>
			</div>
			<div class="text-center">
				<!-- 네비게이션 페이징 스타일 적용  -->	
				<ul class="pagination justify-content-center" style="margin:20px 0">
					<%		
						/* 네비게이션 페이징 */
						// 한 페이지당 10개(ROW_PER_PAG)씩 담았을 때 생성될 마지막 페이지 계산
						int lastPage = countQnaList/ROW_PER_PAGE;			
									
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
						if ( countQnaList % DISPLAY_RANGE_PAGE != 0 ) {							
							lastPage += 1;
						}
										
						// 페이징 범위 끝 숫자가 마지막 페이지 보다 더 크면 페이징 범위 끝 숫자를 마지막 페이지로 바꿈 (다음 버튼 노출 안 시키기 위해)
						if(rangeEndPage >= lastPage ) {
							 rangeEndPage = lastPage; 
						}
										
					    // 디버깅용
					    System.out.println("[debug] selectNoticeList.jsp => 현재 페이지 : " + currentPage);
					    System.out.println("[debug] selectNoticeList.jsp => 마지막 페이지 : " + lastPage);
					    System.out.println("[debug] selectNoticeList.jsp => 페이징 범위 단위값 : " + DISPLAY_RANGE_PAGE);
					    System.out.println("[debug] selectNoticeList.jsp => 페이징 시작 범위 숫자 : " + (rangeStartPage+1));
					    System.out.println("[debug] selectNoticeList.jsp => 페이징 끝 범위 숫자 : " + rangeEndPage);
					    System.out.println("[debug] selectNoticeList.jsp => 총 qna 수 : " + countQnaList);	
					    
					    // 현재 페이지 범위가 네비게이션 페이징 범위 단위값 이상일 경우에만 이전 버튼을 노출(이전 버튼이 노출되어야 할 상황에만 노출시키기 위해)
						if( rangeStartPage > (DISPLAY_RANGE_PAGE - 1) ) {	
					%>
							<!-- &nbsp;는 HTML에서 띄어쓰기 특수문자 -->
							<!-- 쿼리스트링을 넘길 때에는 초기값은 "?", 그 뒤의 다른 값들이 있다면 "&"로 붙이며 사용한다. -->
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/qna/selectQnaList.jsp?currentPage=<%=1%>&searchQnaTitle=<%=searchQnaTitle%>&searchQnaCategory=<%=searchQnaCategory %>">처음으로</a></li>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/qna/selectQnaList.jsp?currentPage=<%=rangeStartPage-9%>&searchQnaTitle=<%=searchQnaTitle%>&searchQnaCategory=<%=searchQnaCategory %>">이전</a></li>
					<%
						}
					    
						// 현 페이지의 페이징 범위에 맞는 네비게이션 버튼을 노출
						for (int i = rangeStartPage+1; i < rangeEndPage+1; i++) {				
					%>	
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/qna/selectQnaList.jsp?currentPage=<%=i%>&searchQnaTitle=<%=searchQnaTitle%>&searchQnaCategory=<%=searchQnaCategory %>"><%=i%></a></li>
					<%		
						}
						
						// 현재 페이지 범위가 총 페이지 개수의 마지막 개수보다 작을 경우에만 다음 버튼을 노출(다음 버튼이 노출되어야 할 상황에만 노출시키기 위해)
						if((rangeEndPage) < lastPage) {
					%>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/qna/selectQnaList.jsp?currentPage=<%=rangeStartPage+11%>&searchQnaTitle=<%=searchQnaTitle%>&searchQnaCategory=<%=searchQnaCategory %>">다음</a></li>
							<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/qna/selectQnaList.jsp?currentPage=<%=lastPage%>&searchQnaTitle=<%=searchQnaTitle%>&searchQnaCategory=<%=searchQnaCategory %>">끝으로</a></li>
					<%
						}
					%>
				</ul>
				<form class="form-group" method="get" action="<%=request.getContextPath() %>/qna/selectQnaList.jsp">
					<div class="container-fluid row justify-content-center align-items-center" style="margin:20px 0">
						<select class="form-control" name="searchQnaCategory" style="width:120px">
							<option value="ALL">전체</option>
							<option value="가입정보">가입정보</option>
							<option value="전자책">전자책</option>
							<option value="기타">기타</option>
						</select>
						<input class="form-control text-center" type="text" name="searchQnaTitle" style="width:250px">
						<input class="btn btn-outline-info" type="submit"  value="검색">
					</div>		
				</form>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] selectQnaList.jsp 로직 종료");	
%>