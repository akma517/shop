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
   
    EbookDao ebookDao = new EbookDao();
    
    // 전자책 리스트 불러오기
    Ebook ebook = ebookDao.selectEbookOneByAdmin(ebookNo);
    
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
		<div class="text-center" style="padding-top:50px;"><h1>전자책 상세보기</h1></div>
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
						<td class="text-center align-middle table-active">수정날짜</td>
						<td class="text-center align-middle" colspan=><%=ebook.getUpdateDate()%></td>
						<td class="text-center align-middle table-active">가격</td>
						<td class="text-center align-middle"><%=ebook.getEbookPrice()%>원</td>
					</tr>
					<tr>
						<td class="text-center align-middle table-active">요약</td>
						<td class="text-center align-middle" colspan="6"><%=ebook.getEbookSummary()%></td>
					</tr>
				</tbody>
			</table>
			<div class="text-right">
				<a href="<%=request.getContextPath() %>/insertOrderAction.jsp?ebookNo=<%=ebook.getEbookNo() %>" class="btn btn-outline-info btn-sm">주문하기</a>
				<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-primary btn-sm">홈페이지</a>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] selectEbookOneByIndex.jsp 로직 종료");	
%>