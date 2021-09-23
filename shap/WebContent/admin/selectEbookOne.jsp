<%@page import="vo.Ebook"%>
<%@page import="dao.EbookDao"%>
<%@page import="vo.Member"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] selectEbookList.jsp 로직 진입");	
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] selectEbookOne.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
    
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
			<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
		</div>
		<!-- 서브메뉴 종료 -->
		<div class="text-center" style="padding-top:50px;"><h1>전자책 상세보기</h1></div>
		<div class="container center-block" style="padding-top:50px;">
			<table class="table table-bordered">
				<tbody>
					<tr>
						<td class="text-center" rowspan="4" colspan="2"><img src="<%=request.getContextPath()%>/images/<%=ebook.getEbookImg()%>"></td>
						<td class="text-center align-middle">넘버</td>
						<td class="text-center align-middle"><%=ebook.getEbookNo()%></td>
						<td class="text-center align-middle">제목</td>
						<td class="text-center align-middle"><%=ebook.getEbookTitle()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle">종류</td>
						<td class="text-center align-middle"><%=ebook.getCategoryName()%></td>
						<td class="text-center align-middle">저자</td>
						<td class="text-center align-middle"><%=ebook.getEbookAuthor()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle">ISBN</td>
						<td class="text-center align-middle"><%=ebook.getEbookISBN()%></td>
						<td class="text-center align-middle">출판사</td>
						<td class="text-center align-middle"><%=ebook.getEbookCompany()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle">페이지 수</td>
						<td class="text-center align-middle"><%=ebook.getEbookPageCount()%></td>
						<td class="text-center align-middle">상태</td>
						<td class="text-center align-middle"><%=ebook.getEbookState()%></td>
					</tr>
					<tr>
						<td class="text-center align-middle">작성날짜</td>
						<td class="text-center align-middle" colspan=""><%=ebook.getCreateDate()%></td>
						<td class="text-center align-middle">수정날짜</td>
						<td class="text-center align-middle" colspan=><%=ebook.getUpdateDate()%></td>
						<td class="text-center align-middle">가격</td>
						<td class="text-center align-middle"><%=ebook.getEbookPrice()%>원</td>
					</tr>
					<tr>
						<td class="text-center align-middle">요약</td>
						<td class="text-center align-middle" colspan="6"><%=ebook.getEbookSummary()%></td>
					</tr>
					<tr>
						<td colspan="6">
							<div class="text-right">
								<a href="<%=request.getContextPath() %>/admin/adminIndex.jsp" class="btn btn-outline-danger btn-sm">삭제</a>
								<a href="<%=request.getContextPath() %>/admin/adminIndex.jsp" class="btn btn-outline-warning btn-sm">가격수정</a>
								<a href="<%=request.getContextPath() %>/admin/updateEbookImgForm.jsp?ebookNo=<%=ebook.getEbookNo() %>" class="btn btn-outline-warning btn-sm">이미지수정</a>
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
	System.out.println("[debug] selectEbookOne.jsp 로직 종료");	
%>