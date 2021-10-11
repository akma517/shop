package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import common.DBUtil;
import vo.Member;
import vo.OrderComment;
import vo.OrderCommentMember;
import vo.Qna;
import vo.QnaComment;
import vo.QnaCommentMember;

public class QnaCommentDao {
	
	/* [비회원, 회원, 관리자] qna 댓글 불러오기(select) */
	// input: int =>  qnaNo
	// output(success): ArrayList<QnaCommentMember> => QnaComment, Member
	// output(false): ArrayList<QnaCommentMember> => null
	public ArrayList<QnaCommentMember> selectQnaCommentList(int qnaNo) throws ClassNotFoundException, SQLException  {
		
		// 입력값 디버깅
		System.out.println("[debug] QnaCommentDao.selectQnaCommentList(int qnaNo) => 등록된 qna 댓글을 불러올 qna 넘버: " + qnaNo);
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 쿼리문 생성
		String sql = "SELECT qc.qna_comment_no qnaCommentNo, qc.qna_no qnaNo, qc.qna_comment_content qnaCommentContent, qc.create_date createDate, m.member_no memberNo, m.member_id memberId, m.member_name memberName FROM qna_comment qc JOIN member m ON qc.member_no = m.member_no WHERE qc.qna_no=? ORDER BY qc.create_date ASC ";
		PreparedStatement stmt = conn.prepareStatement(sql);
			
		// 쿼리문 세팅
		stmt.setInt(1, qnaNo);
		
		// 쿼리문 디버깅
		System.out.println("[debug] QnaCommentDao.selectQnaCommentList(int qnaNo) => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		ResultSet rs = stmt.executeQuery();
		
		// 리뷰 목록을 담을 리스트 생성
		ArrayList<QnaCommentMember> qcmList = new ArrayList<QnaCommentMember>();
		
		int i = 1;
		
		while(rs.next()) {
			
			// 조인 쿼리문의 결과를 받을 QnaComment, Member 클래스의 집합체를 생성
			QnaCommentMember qcm = new QnaCommentMember();
			
			// 조회결과의 QnaComment와 관련된 결과를 QnaComment 클래스에 저장
			QnaComment qc = new QnaComment();
			qc.setQnaCommentNo(rs.getInt("qnaCommentNo"));
			qc.setQnaNo(rs.getInt("QnaNo"));
			qc.setCreateDate(rs.getString("createDate"));
			qc.setQnaCommentContent(rs.getString("qnaCommentContent"));
			qcm.setQnaComment(qc);
			
			// 출력값 디버깅
			System.out.println("[debug] QnaCommentDao.selectQnaCommentList(int qnaNo) => " + i + "번째 qna 댓글 매개변수 : " + qc.toString());
			
			// 조회결과의 Member와 관련된 결과를 Member 클래스에 저장
			Member m = new Member();
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberId(rs.getString("memberId"));
			m.setMemberName(rs.getString("memberName"));
			qcm.setMember(m);
			
			// 출력값 디버깅
			System.out.println("[debug] QnaCommentDao.selectQnaCommentList(int qnaNo) => " + i + "번째 qna 댓글 작성자 회원 매개변수: " + m.toString());
		
			// 리스트에 qcm(qna 댓글)을 저장
			qcmList.add(qcm);
			
			i += 1;
			
		}
		
		// db 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
		
		return qcmList;
	}
	
	/*[회원] qna 댓글 등록*/
	// input: QnaComment => qnaNo, qnaCommentContent, memberNo
	// output(success): int => confirm
	// output(false): 0;
	public int insertQnaComment(QnaComment qnaComment) throws SQLException, ClassNotFoundException {
		
		// 입력값 디버깅
		System.out.println("[debug] QnaCommentDao.insertQnaComment(QnaComment qnaComment) => 입력받은 등록할 qna 댓글 매개 변수 값 :" + qnaComment.toString());
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 쿼리문 생성
		String sql = "INSERT INTO qna_comment(qna_no, qna_comment_content, member_no, create_date, update_date ) VALUES(?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setInt(1, qnaComment.getQnaNo());
		stmt.setString(2, qnaComment.getQnaCommentContent());
		stmt.setInt(3, qnaComment.getMemberNo());
		
		// 쿼리 디버깅
		System.out.println("[debug] QnaCommentDao.insertQnaComment(QnaComment qnaComment) => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		int confirm = stmt.executeUpdate();
		
		// 작업 결과 디버깅
		System.out.println("[debug] QnaCommentDao.insertQnaComment(QnaComment qnaComment) => 등록된 qna 댓글 개수 : " + confirm);
		
		// db 자원 헤제
		stmt.close();
		conn.close();
		
		return confirm;
	}
	
	/* [회원] qna 댓글 삭제 */
	// input: QnaComment => qnaCommentNo, member_no
	// output(success): int => confirm
	// output(false): 0;
	public int deleteQnaComment(QnaComment qnaComment) throws ClassNotFoundException, SQLException {

		// 입력값 디버깅
		System.out.println("[debug] QnaCommentDao.deleteQnaComment(QnaComment qnaComment)) => 입력받은 삭제할 qna 매개 변수 값 :" + qnaComment.toString());
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 쿼리문 생성
		String sql = "DELETE FROM qna_comment WHERE qna_comment_no=? AND member_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setInt(1, qnaComment.getQnaCommentNo());
		stmt.setInt(2, qnaComment.getMemberNo());
		
		// 쿼리 디버깅
		System.out.println("[debug] QnaCommentDao.deleteQnaComment(QnaComment qnaComment) => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		int confirm = stmt.executeUpdate();
		
		// 작업 결과 디버깅
		System.out.println("[debug] QnaCommentDao.deleteQnaComment(QnaComment qnaComment) => 삭제된 qna 댓글 개수 : " + confirm);
		
		// db 자원 헤제
		stmt.close();
		conn.close();
		
		return confirm;
	}
	
}
