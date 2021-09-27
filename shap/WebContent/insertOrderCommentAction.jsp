<%@page import="vo.OrderComment"%>
<%@page import="vo.OrderEbookMember"%>
<%@page import="dao.OrderDao"%>
<%@page import="vo.Member"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");	/* utf-8로 인코딩을 세팅해 준다. */
	System.out.println("[debug] insertOrderCommentAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없을 경우, 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] insertOrderCommentAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
    
	
	/* 인력값 받기 */
	String orderNoTest = request.getParameter("orderNo");
	String orderScoreTest = request.getParameter("orderScore");
	String ebookNoTest = request.getParameter("ebookNo");
	String orderCommentContent = request.getParameter("orderCommentContent");
	
	
	// DB에 줄바꿈 문자를 넣어주기 위해 변환
	orderCommentContent = orderCommentContent.replaceAll("\r\n|\n", "<br>");
	
	// 디버깅
	System.out.println("[debug] insertOrderCommentAction.jsp => 작성할 리뷰 주문 넘버 : " + orderNoTest);
	System.out.println("[debug] insertOrderCommentAction.jsp => 작성할 리뷰 점수 : " + orderScoreTest);
	System.out.println("[debug] insertOrderCommentAction.jsp => 작성할 리뷰 전자책 넘버 : " + ebookNoTest);
	System.out.println("[debug] insertOrderCommentAction.jsp => 작성할 리뷰 내용 : " + orderCommentContent);
	System.out.println("[debug] insertOrderCommentAction.jsp => 작성할 리뷰 작성자 회원 넘버 : " + loginMember.getMemberNo());
	
	// 인력값 검증
    if(orderNoTest == null || ebookNoTest == null || ebookNoTest == null || orderCommentContent == null) {
	       response.sendRedirect(request.getContextPath()+"/index.jsp");
	       System.out.println("[debug] insertOrderCommentAction.jsp => index.jsp로 강제 이동: 유효하지 않은 강제 접근을 막았습니다.");
	       return;
	}
    
    // 검증이 끝난 후, 사용할 데이터 형으로 변환
    int orderNo = Integer.parseInt(orderNoTest);
    int ebookNo = Integer.parseInt(ebookNoTest);
    int orderScore = Integer.parseInt(orderScoreTest);
    
    // 객체 생성
    OrderComment orderComment = new OrderComment();
    
    // 입력값 세팅
    orderComment.setOrderNo(orderNo);
    orderComment.setEbookNo(ebookNo);
    orderComment.setOrderScore(orderScore);
    orderComment.setOrderCommentContent(orderCommentContent);
    orderComment.setMemberNo(loginMember.getMemberNo());

    
	// DAO에서 삽입 작업 수행
	OrderDao orderDao = new OrderDao();
	int confirm = orderDao.insertOrderComment(orderComment);
	
	if (confirm==1) {
			
			System.out.println("[debug] insertOrderCommentAction.jsp => 리뷰 등록 성공");
			response.sendRedirect(request.getContextPath() + "/selectOrderListByMember.jsp");
			
			System.out.println("[debug] insertOrderCommentAction.jsp 로직 종료");
			
			return;
			
		} else {
			
			System.out.println("[debug] insertOrderCommentAction.jsp => 리뷰 등록 실패 : 입력 정보를 다시 확인해 주세요.");
			response.sendRedirect(request.getContextPath() + "/selectOrderListByMember.jsp");
			
			System.out.println("[debug] insertOrderCommentAction.jsp 로직 종료");
			
			return;
		}

	
%>