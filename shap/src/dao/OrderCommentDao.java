package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import common.DBUtil;
import vo.Ebook;
import vo.Member;
import vo.Order;
import vo.OrderComment;
import vo.OrderCommentMember;
import vo.OrderEbookMember;

public class OrderCommentDao {
	
	/* [관리자] 전자책에 등록된 리뷰 페이징하여 불러오기(select) */
	// input: int => beginRow, rowPerPage, ebookNo
	// output(success): ArrayList<OrderCommentMember> => OrderComment, Member
	// output(false): ArrayList<OrderCommentMember> => null
	public ArrayList<OrderCommentMember> selectOrderCommentList(int beginRow, int rowPerPage, int ebookNo) throws ClassNotFoundException, SQLException  {
		
		// 입력값 디버깅
		System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => 시작 행 : " + beginRow);
		System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => 페이지당 행 개수 : " + rowPerPage);
		System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => 등록된 리뷰를 불러올 전자책 넘버: " + ebookNo);
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 쿼리문 생성
		String sql = "SELECT oc.order_comment_no orderCommentNo, oc.order_score orderScore, oc.order_comment_content orderCommentContent, oc.create_date createDate, oc.update_date updateDate, m.member_no memberNo, m.member_id memberId, m.member_name memberName FROM order_comment oc INNER JOIN member m ON oc.member_no = m.member_no WHERE oc.ebook_no=? ORDER BY oc.create_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
			
		// 쿼리문 세팅
		stmt.setInt(1, ebookNo);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);

		
		// 쿼리문 디버깅
		System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		ResultSet rs = stmt.executeQuery();
		
		// 리뷰 목록을 담을 리스트 생성
		ArrayList<OrderCommentMember> ocmList = new ArrayList<OrderCommentMember>();
		
		int i = 1;
		
		while(rs.next()) {
			
			// 조인 쿼리문의 결과를 받을 Order, Ebook, Member 클래스의 집합체를 생성
			OrderCommentMember ocm = new OrderCommentMember();
			
			// 조회결과의 OrderComment와 관련된 결과를 OrderComment 클래스에 저장
			OrderComment oc = new OrderComment();
			oc.setOrderCommentNo(rs.getInt("orderCommentNo"));
			oc.setOrderScore(rs.getInt("orderScore"));
			oc.setCreateDate(rs.getString("createDate"));
			oc.setUpdateDate(rs.getString("updateDate"));
			oc.setOrderCommentContent(rs.getString("orderCommentContent"));
			ocm.setOrderComment(oc);
			
			// 출력값 디버깅
			System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => " + i + "번째 리뷰 넘버 : " + oc.getOrderCommentNo());
			System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => " + i + "번째 리뷰 점수 : " + oc.getOrderScore());
			System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => " + i + "번째 리뷰 등록 날짜: " + oc.getCreateDate());
			System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => " + i + "번째 리뷰 수정 날짜: " + oc.getUpdateDate());
			System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => " + i + "번째 리뷰 내용: " + oc.getOrderCommentContent());
			
			// 조회결과의 Member와 관련된 결과를 Member 클래스에 저장
			Member m = new Member();
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberId(rs.getString("memberId"));
			m.setMemberName(rs.getString("memberName"));
			ocm.setMember(m);
			
			// 출력값 디버깅
			System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => " + i + "번째 리뷰 작성자 회원 넘버 : " + m.getMemberNo());
			System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => " + i + "번째 리뷰 작성자 회원 아이디 : " + m.getMemberId());
			System.out.println("[debug] OrderCommentDao.selectOrderList(int beginRow, int rowPerPage, int ebookNo) => " + i + "번째 리뷰 작성자 회원 이름(닉네임) : " + m.getMemberName());
			
			// 리스트에 ocm(리뷰)을 저장
			ocmList.add(ocm);
			
			i += 1;
			
		}
		
		// db 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
		
		return ocmList;
	}
	
	/* [회원] 전자책에 등록된 리뷰 개수 구하기(select) */
	// input: int => ebookNo
	// output(success): CountOrderCommentList
	// output(false): 0
	public int selectCountOrderComment(int ebookNo) throws ClassNotFoundException, SQLException  {
		
		// 입력값 디버깅
		System.out.println("[debug] OrderCommentDao.selectCountOrderComment(int ebookNo) => 리뷰 개수를 구할 전자책 넘버 : " + ebookNo);
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();

		// 쿼리문 생성
		String sql = "SELECT COUNT(t.orderCommentNo) FROM (SELECT order_comment_no orderCommentNo FROM order_comment WHERE ebook_no=?) t";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setInt(1, ebookNo);
		
		// 쿼리문 디버깅
		System.out.println("[debug] OrderCommentDao.selectCountOrderComment(int ebookNo) => 쿼리문 : " + stmt);
		
		ResultSet rs = stmt.executeQuery();
		
		// 주문 목록을 담을 리스트 생성
		int countOrderCommentList = 0;
		
		while(rs.next()) {
			
			countOrderCommentList = rs.getInt(1);
			
		}
		
		// 출력값 디버깅
		System.out.println("[debug]  OrderCommentDao.selectCountOrderComment(int ebookNo) => 총 리뷰 개수 : " +  countOrderCommentList);
		
		// db 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
		
		
		return countOrderCommentList;
	}
	
	/* [회원] 평균 리뷰 점수 구하기(select) */
	// input:  double => ebookNo 
	// output(success): int => avgOrderScore
	// output(false): 0
	public double selectAvgOrderScore(int ebookNo) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] OrderCommentDao.selectAvgOrderScore(int ebookNo) => 평균 리뷰 점수를 구할 전자책 넘버 : " + ebookNo);
		
		// db 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 별칭(alias)를 설정할 때, AS를 안붙여줘도 되고, 별칭이 영어일 경우, ""를 사용해주지 않아도 된다.
		String sql = "SELECT AVG(t.orderScore) FROM (SELECT order_score orderScore FROM order_comment WHERE ebook_no=?) t";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setInt(1, ebookNo);

		// 쿼리 디버깅
		System.out.println("[debug] OrderCommentDao.selectAvgOrderScore(int ebookNo) => 쿼리문 : " + stmt);
		
		// db 작업 결과 성공 여부 저장
		ResultSet rs = stmt.executeQuery();
		
		// 기본값은 0.0으로 설정
		double avgOrderScore = 0;
		
		// 평균 점수를 구해온다.
		if (rs.next()) {
			avgOrderScore = rs.getDouble(1);
		}
		
		// 결과 디버깅
		System.out.println("[debug] OrderCommentDao.selectAvgOrderScore(int ebookNo) => 전자책의 평균 리뷰 점수 : " + avgOrderScore);
		
		// db 해제
		rs.close();
		stmt.close();
		conn.close();
		
		return avgOrderScore;
	}
	
	/* [회원] 리뷰 등록(insert) */
	// input:  OrderComment => orderNo, ebookNo, memberNo, orderScore, orderCommentContent
	// output(success): 1
	// output(false): 0
	public int insertOrderComment(OrderComment orderComment) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] OrderCommentDao.insertOrderComment(OrderComment orderComment) => 작성할 리뷰 주문 넘버 : " + orderComment.getOrderNo());
		System.out.println("[debug] OrderCommentDao.insertOrderComment(OrderComment orderComment) => 작성할 리뷰 전자책 넘버 : " + orderComment.getEbookNo());
		System.out.println("[debug] OrderCommentDao.insertOrderComment(OrderComment orderComment) => 작성할 리뷰 점수 : " + orderComment.getOrderScore());
		System.out.println("[debug] OrderCommentDao.insertOrderComment(OrderComment orderComment) => 작성할 리뷰 내용 : " + orderComment.getOrderCommentContent());
		System.out.println("[debug] OrderCommentDao.insertOrderComment(OrderComment orderComment) => 작성할 리뷰 작성자 회원 넘버 : " + orderComment.getMemberNo());
		
		// db 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 별칭(alias)를 설정할 때, AS를 안붙여줘도 되고, 별칭이 영어일 경우, ""를 사용해주지 않아도 된다.
		String sql = "INSERT INTO order_comment(order_no, ebook_no, order_score, order_comment_content, member_no, create_date, update_date) VALUES(?,?,?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setInt(1,  orderComment.getOrderNo());
		stmt.setInt(2,  orderComment.getEbookNo());
		stmt.setInt(3,  orderComment.getOrderScore());
		stmt.setString(4, orderComment.getOrderCommentContent());
		stmt.setInt(5,  orderComment.getMemberNo());
		
		// 쿼리 디버깅 
		System.out.println("[debug] OrderCommentDao.insertOrderComment(OrderComment orderComment) => 쿼리문 : " + stmt);
		
		// db 작업 결과 성공 여부 저장
		int confirm = stmt.executeUpdate();
		stmt.close();
		
		// 결과 디버깅
		System.out.println("[debug] OrderCommentDao.insertOrderComment(OrderComment orderComment) => 등록한 리뷰 개수 : " + confirm);
		
		// 해당 주문에 리뷰를 작성했음을 갱신하는 쿼리문 생성
		sql = "UPDATE orders SET order_comment_state='Y' WHERE order_no=?";
		stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setInt(1,  orderComment.getOrderNo());
		
		// 쿼리 디버깅
		System.out.println("[debug] OrderCommentDao.insertOrderComment(OrderComment orderComment) => 리뷰를 작성한 주문의 리뷰 작성 상태 갱신 쿼리문 : " + stmt);
		
		// db 작업 결과 성공 여부 저장
		int confirmOrderCommentState = stmt.executeUpdate();
		
		// 결과 디버깅
		System.out.println("[debug] OrderCommentDao.insertOrderComment(OrderComment orderComment) => 갱신된 주문 개수 : " + confirmOrderCommentState);
		
		
		// db 해제
		stmt.close();
		conn.close();
		
		return confirm;
	}
}
