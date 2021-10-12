<%@page import="vo.Order"%>
<%@page import="dao.OrderCommentDao"%>
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
	System.out.println("[debug] insertOrderAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없을 경우, 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] insertOrderAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    }
    
	
	/* 인력값 받기 */
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	int memberNo = loginMember.getMemberNo();
	int orderPrice = Integer.parseInt(request.getParameter("orderPrice"));
	
    // 객체 생성
    Order order = new Order();
    
    // 입력값 세팅
    order.setEbookNo(ebookNo);
    order.setMemberNo(memberNo);
    order.setOrderPrice(orderPrice);
    
	// 디버깅
	System.out.println("[debug] insertOrderAction.jsp => 주문정보 매개변수 : " + order.toString());

    
	// DAO에서 삽입 작업 수행
	OrderDao orderDao = new OrderDao();
	int confirm = orderDao.insertOrder(order);
	
	if (confirm==1) {
			
			System.out.println("[debug] insertOrderAction.jsp => 주문 성공");
			response.sendRedirect(request.getContextPath() + "/selectOrderListByMember.jsp");
			
			System.out.println("[debug] insertOrderAction.jsp 로직 종료");
			
			return;
			
		} else {
			
			System.out.println("[debug] insertOrderAction.jsp => 주문 실패 : 입력 정보를 다시 확인해 주세요.");
			response.sendRedirect(request.getContextPath() + "/selectEbookOneByIndex.jsp?ebookNo=" + ebookNo);
			
			System.out.println("[debug] insertOrderAction.jsp 로직 종료");
			
			return;
		}

	
%>