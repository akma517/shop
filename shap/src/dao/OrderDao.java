package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import common.DBUtil;
import vo.Category;
import vo.Ebook;
import vo.Member;
import vo.Order;
import vo.OrderComment;
import vo.OrderEbookMember;

public class OrderDao {
	
	/* [회원] 검색 조건에 맞는 주문 목록 출력(select) */
	// input: int => beginRow, rowPerPage, memberNo, String => searchOrderNo
	// output(success): ArrayList<OrderEbookMember> => Order, Ebook, Member
	// output(false): ArrayList<OrderEbookMember> => null
	public ArrayList<OrderEbookMember> selectOrderListByMember(int beginRow, int rowPerPage, String searchOrderNo, int memberNo) throws ClassNotFoundException, SQLException  {
		
		// 입력값 디버깅
		System.out.println("[debug] OrderDao.selectOrderListByMember(int beginRow, int rowPerPage, String searchOrderNo, int memberNo) => 시작 행 : " + beginRow);
		System.out.println("[debug] OrderDao.selectOrderListByMember(int beginRow, int rowPerPage, String searchOrderNo, int memberNo) => 페이지당 행 개수 : " + rowPerPage);
		System.out.println("[debug] OrderDao.selectOrderListByMember(int beginRow, int rowPerPage, String searchOrderNo, int memberNo) => 검색 키워드 : " + searchOrderNo);
		System.out.println("[debug] OrderDao.selectOrderListByMember(int beginRow, int rowPerPage, String searchOrderNo, int memberNo) => 회원 넘버 : " + memberNo);
		
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 검색어가 있고 없고에 따라 다른 sql 쿼리문을 생성 후, 세팅
		String sql = null;
		PreparedStatement stmt = null;
		
		if (searchOrderNo.equals("ALL") || searchOrderNo.equals("") ) {
			
			// 검색어가 없을 경우
			// 쿼리문 생성
			sql = "SELECT o.order_no orderNo, o.order_price orderPrice, o.create_date createDate, o.update_date updateDate, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id memberId, o.order_comment_state orderCommentState FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no WHERE m.member_no=? ORDER BY o.create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setInt(1, memberNo);
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			
		} else {
			
			// 검색어가 있을 경우
			// 쿼리문 생성
			sql = "SELECT o.order_no orderNo, o.order_price orderPrice, o.create_date createDate, o.update_date updateDate, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id memberId, o.order_comment_state orderCommentState FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no WHERE o.order_no LIKE ? AND m.member_no=? ORDER BY o.create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, "%" + searchOrderNo + "%");
			stmt.setInt(2, memberNo);
			stmt.setInt(3, beginRow);
			stmt.setInt(4, rowPerPage);
		}
		
		// 쿼리문 디버깅
		System.out.println("[debug] OrderDao.selectOrderList(int beginRow, int rowPerPage) => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		ResultSet rs = stmt.executeQuery();
		
		// 주문 목록을 담을 리스트 생성
		ArrayList<OrderEbookMember> oemList = new ArrayList<OrderEbookMember>();
		
		while(rs.next()) {
			
			// 조인 쿼리문의 결과를 받을 Order, Ebook, Member 클래스의 집합체를 생성
			OrderEbookMember oem = new OrderEbookMember();
			
			// 조회결과의 Order와 관련된 결과를 Order 클래스에 저장
			Order o = new Order();
			o.setOrderNo(rs.getInt("orderNo"));
			o.setOrderPrice(rs.getInt("orderPrice"));
			o.setCreateDate(rs.getString("createDate"));
			o.setUpdateDate(rs.getString("updateDate"));
			o.setOrderCommentState(rs.getString("orderCommentState"));
			oem.setOrder(o);
			
			// 조회결과의 Ebook과 관련된 결과를 Ebook 클래스에 저장
			Ebook e = new Ebook();
			e.setEbookNo(rs.getInt("ebookNo"));
			e.setEbookTitle(rs.getString("ebookTitle"));
			oem.setEbook(e);
			
			// 조회결과의 Member와 관련된 결과를 Member 클래스에 저장
			Member m = new Member();
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberId(rs.getString("memberId"));
			oem.setMember(m);
			
			// 리스트에 oem(주문)을 저장
			oemList.add(oem);
			
		}
		
		// db 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
		
		return oemList;
	}
	
	/* [관리자] 검색 조건에 맞는 주문 목록 출력(select) */
	// input: int => beginRow, rowPerPage, String => searchOrderNo
	// output(success): ArrayList<OrderEbookMember> => Order, Ebook, Member
	// output(false): ArrayList<OrderEbookMember> => null
	public ArrayList<OrderEbookMember> selectOrderList(int beginRow, int rowPerPage, String searchOrderNo) throws ClassNotFoundException, SQLException  {
		
		// 입력값 디버깅
		System.out.println("[debug] OrderDao.selectOrderList(int beginRow, int rowPerPage) => 시작 행 : " + beginRow);
		System.out.println("[debug] OrderDao.selectOrderList(int beginRow, int rowPerPage) => 페이지당 행 개수 : " + rowPerPage);
		System.out.println("[debug] OrderDao.selectOrderList(int beginRow, int rowPerPage) => 검색 키워드 : " + searchOrderNo);
		
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		

		
		// 검색어가 있고 없고에 따라 다른 sql 쿼리문을 생성 후, 세팅
		String sql = null;
		PreparedStatement stmt = null;
		
		if (searchOrderNo.equals("ALL") || searchOrderNo.equals("") ) {
			
			// 검색어가 없을 경우
			// 쿼리문 생성
			sql = "SELECT o.order_no orderNo, o.order_price orderPrice, o.create_date createDate, o.update_date updateDate, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id memberId, o.order_comment_state orderCommentState  FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no ORDER BY o.create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
			
		} else {
			
			// 검색어가 있을 경우
			// 쿼리문 생성
			sql = "SELECT o.order_no orderNo, o.order_price orderPrice, o.create_date createDate, o.update_date updateDate, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id memberId, o.order_comment_state orderCommentState  FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no WHERE o.order_no LIKE ? ORDER BY o.create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, "%" + searchOrderNo + "%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
		}
		
		// 쿼리문 디버깅
		System.out.println("[debug] OrderDao.selectOrderList(int beginRow, int rowPerPage) => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		ResultSet rs = stmt.executeQuery();
		
		// 주문 목록을 담을 리스트 생성
		ArrayList<OrderEbookMember> oemList = new ArrayList<OrderEbookMember>();
		
		while(rs.next()) {
			
			// 조인 쿼리문의 결과를 받을 Order, Ebook, Member 클래스의 집합체를 생성
			OrderEbookMember oem = new OrderEbookMember();
			
			// 조회결과의 Order와 관련된 결과를 Order 클래스에 저장
			Order o = new Order();
			o.setOrderNo(rs.getInt("orderNo"));
			o.setOrderPrice(rs.getInt("orderPrice"));
			o.setCreateDate(rs.getString("createDate"));
			o.setUpdateDate(rs.getString("updateDate"));
			o.setOrderCommentState(rs.getString("orderCommentState"));
			oem.setOrder(o);
			
			// 조회결과의 Ebook과 관련된 결과를 Ebook 클래스에 저장
			Ebook e = new Ebook();
			e.setEbookNo(rs.getInt("ebookNo"));
			e.setEbookTitle(rs.getString("ebookTitle"));
			oem.setEbook(e);
			
			// 조회결과의 Member와 관련된 결과를 Member 클래스에 저장
			Member m = new Member();
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberId(rs.getString("memberId"));
			oem.setMember(m);
			
			// 리스트에 oem(주문)을 저장
			oemList.add(oem);
			
		}
		
		// db 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
		
		return oemList;
	}
	
	/* [관리자] 검색 조건에 맞는 주문 목록 개수 구하기(select) */
	// input: String => searchOrderNo
	// output(success): CountOrderList
	// output(false): 0
	public int selectCountOrderList(String searchOrderNo) throws ClassNotFoundException, SQLException  {
		
		// 입력값 디버깅
		System.out.println("[debug] OrderDao.selectCountOrderList(String searchOrderNo) => 검색 키워드 : " + searchOrderNo);
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 검색어가 있고 없고에 따라 다른 sql 쿼리문을 생성 후, 세팅
		String sql = null;
		PreparedStatement stmt = null;
		
		if (searchOrderNo.equals("ALL") || searchOrderNo.equals("") ) {
			
			// 검색어가 없을 경우
			// 쿼리문 생성
			sql = "SELECT COUNT(*) FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no ";
			stmt = conn.prepareStatement(sql);
			
		} else {
			
			// 검색어가 있을 경우
			// 쿼리문 생성
			sql = "SELECT COUNT(*) FROM orders o INNER JOIN ebook e INNER JOIN member m ON o.ebook_no = e.ebook_no AND o.member_no = m.member_no WHERE o.order_no LIKE ?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, "%" + searchOrderNo + "%");
		}
		
		// 쿼리문 디버깅
		System.out.println("[debug] OrderDao.selectCountOrderList(String searchOrderNo) => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		ResultSet rs = stmt.executeQuery();
		
		// 주문 목록을 담을 리스트 생성
		int countOrderList = 0;
		
		while(rs.next()) {
			
			countOrderList = rs.getInt(1);
			
		}
		
		// 출력값 디버깅
		System.out.println("[debug] OrderDao.selectOrderList(int beginRow, int rowPerPage) => 총 주문의 수 : " + countOrderList);
		
		// db 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
		
		
		return countOrderList;
	}
	
}
