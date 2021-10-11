<%@page import="vo.QnaCommentMember"%>
<%@page import="dao.QnaCommentDao"%>
<%@page import="vo.QnaMember"%>
<%@page import="vo.Qna"%>
<%@page import="dao.QnaDao"%>
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
	System.out.println("[debug] selectQnaOne.jsp 로직 진입");	

    
	// 로그인 정보가 없어도 열람은 가능하도록 강제 이동시키지 않음
    Member loginMember = (Member)session.getAttribute("loginMember");
    
 	// qna 상세보기 설정
    int qnaNo = 1;
    if(request.getParameter("qnaNo") != null) {
    	qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
    }
   
    /* qna 불러오기 */
    QnaDao qnaDao = new QnaDao();
    
    Qna qna = new Qna();
    qna.setQnaNo(qnaNo);
    
    // 상세보기 할 qna 가져오기
    QnaMember qnaMember = qnaDao.selectQnaOne(qna);
    
    // qna에 작성된 댓글들 가져오기
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	ArrayList<QnaCommentMember> qnaCommentMemberList = qnaCommentDao.selectQnaCommentList(qnaNo);
    
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
		<div class="text-center" style="padding-top:50px;"><h1>Q&A 상세보기</h1></div>
		<div class="container center-block" style="padding-top:50px;">
			<table class="table table-bordered">
				<tbody>
					<tr>
						<td class="align-middle">
							<div class="text-center align-middle"><h3>[<%=qnaMember.getQna().getQnaCategory()%>] <%=qnaMember.getQna().getQnaTitle()%></h3></div>
							<div class="text-right align-middle"><small><%=qnaMember.getQna().getCreateDate()%><br> <%=qnaMember.getMember().getMemberName()%>[<%=qnaMember.getMember().getMemberId()%>]</small></div>
						</td>
					</tr>
					<tr>
						<td class="align-middle">
							<div class="text-left align-middle" style="min-height: 400px; padding:20px;" ><%=qnaMember.getQna().getQnaContent()%></div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="text-right">
				<%
					if ( loginMember != null  && ( loginMember.getMemberNo() == qnaMember.getMember().getMemberNo() ) ) {
				%>
						<a href="<%=request.getContextPath() %>/qna/deleteQnaAction.jsp?qnaNo=<%=qnaMember.getQna().getQnaNo()%>&memberNo=<%=qnaMember.getMember().getMemberNo() %>" class="btn btn-outline-danger btn-sm">삭제하기</a>
						<a href="<%=request.getContextPath() %>/qna/updateQnaForm.jsp?qnaNo=<%=qnaMember.getQna().getQnaNo()%>" class="btn btn-outline-warning btn-sm">수정하기</a>
				<%
					}
				%>			
				<a href="<%=request.getContextPath() %>/qna/selectQnaList.jsp" class="btn btn-outline-primary btn-sm">Q&A 목록</a>
				<a href="<%=request.getContextPath() %>/index.jsp" class="btn btn-outline-primary btn-sm">홈페이지</a>
			</div>
			<br>
			<!-- 댓글 파트, 작성자와 관리자만 댓글 입력 폼이 보이도록 설정, 작성된 댓글은 모든 회원이 볼 수 있도록 설정 -->
			<%
				if ( loginMember != null  && ( (loginMember.getMemberNo() == qnaMember.getMember().getMemberNo()) || (loginMember.getMemberNo() >= 1))) {
			%>
					<div>
						<form action="<%=request.getContextPath() %>/qna/insertQnaCommentAction.jsp" method="post">
							<input type="hidden" name="qnaNo" value="<%=qnaNo %>">
							<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo() %>">
							<div class="form-group">
								<label for="comment">Comment:</label>
								<textarea id="qnaCommentContent" name="qnaCommentContent" rows="5" class="form-control"></textarea>
							</div>
							<div class="text-right">
								<button class="btn btn-outline-primary">댓글입력</button>
							</div>
						</form>
					</div>
					<br>
			<%
				}
			%>			

			<!-- 댓글목록 출력-->
			<div>
				<%
					
					
				%>
				<!-- tr의 테두리 부분 넣기위한 속성) talbe:style="border-collapse: collapse" -->
				<!-- tr의 테두리 부분 넣기위한 속성) tr:style="border-bottom: 1px solid grey" -->
				<!-- 참고한 사이트(https://roqkfrhdqngkwk.tistory.com/28) -->
				<table class="table table-borderless" style="border-collapse: collapse">
					<thead>
						<tr  style="border-bottom: 2px solid black">
							<th class="text-left" ><h2>댓글목록</h2></th>
						</tr>
					</thead>
					<tbody>
						<%
							for(QnaCommentMember qcm : qnaCommentMemberList){
						%>
							<tr style="border-bottom: 1px solid grey;">
								<td class="text-left align-middle"><%=qcm.getMember().getMemberName()%>[<%=qcm.getMember().getMemberId()%>]</td>
								<td class="text-right">
									<%=qcm.getQnaComment().getCreateDate() %>
									<%
										if ( loginMember != null  && (loginMember.getMemberNo() == qnaMember.getMember().getMemberNo()) ){
									%>
											<a href="<%=request.getContextPath() %>/qna/deleteQnaCmmentAction.jsp?qnaNo=<%=qcm.getQnaComment().getQnaNo()%>&memberNo=<%=qcm.getMember().getMemberNo() %>&qnaCommentNo=<%=qcm.getQnaComment().getQnaCommentNo() %>" class="btn btn-outline-danger btn-sm">삭제</a>
									<%
										}
									%>
								</td>
							</tr>
							<tr style="margin-left: 15px; marin-right: 15px; border-bottom: 2px solid grey;" >
								<td class="text-left align-middle"><%=qcm.getQnaComment().getQnaCommentContent()%></td>
							</tr>
						<%
							}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
<%
	System.out.println("[debug] selectQnaOne.jsp 로직 종료");	
%>