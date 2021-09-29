package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import common.DBUtil;
import vo.Member;
import vo.Notice;
import vo.NoticeMember;

public class NoticeDao {
	
	/* [비회원, 회원, 관리자] 검색 조건에 맞는 공지사항 개수 구하기(select) */
	// input: String => searchNoticeTitle
	// output(success): int => CountOrderList
	// output(false): 0
	public int selectCountNoticeList(String searchNoticeTitle) throws ClassNotFoundException, SQLException  {
		
		// 입력값 디버깅
		System.out.println("[debug] NoticeDao.selectCountOrderList(String searchNoticeTitle) => 검색 키워드 : " + searchNoticeTitle);
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 검색어가 있고 없고에 따라 다른 sql 쿼리문을 생성 후, 세팅
		String sql = null;
		PreparedStatement stmt = null;
		
		if (searchNoticeTitle.equals("ALL") || searchNoticeTitle.equals("") ) {
			
			// 검색어가 없을 경우
			// 쿼리문 생성
			sql = "SELECT COUNT(*) FROM notice";
			stmt = conn.prepareStatement(sql);
			
		} else {
			
			// 검색어가 있을 경우
			// 쿼리문 생성
			sql = "SELECT COUNT(*) FROM notice WHERE notice_title LIKE ?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, "%" + searchNoticeTitle + "%");
		}
		
		// 쿼리문 디버깅
		System.out.println("[debug] NoticeDao.selectCountOrderList(String searchNoticeTitle) => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		ResultSet rs = stmt.executeQuery();
		
		// 주문 목록을 담을 리스트 생성
		int countNoticeList = 0;
		
		while(rs.next()) {
			
			countNoticeList = rs.getInt(1);
			
		}
		
		// 출력값 디버깅
		System.out.println("[debug] NoticeDao.selectCountOrderList(String searchNoticeTitle) => 총 공지사항의 수 : " + countNoticeList);
		
		// db 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
		
		
		return countNoticeList;
	}
	
	
	/*[회원, 비회원, 관리자] 공지사항 목록 출력(검색, 페이징 포함)*/
	// input: int => beginRow, rowPerPage, 
	//		  String => searchNoticeTitle
	// output(success): ArrayList<Notice> => noticeNo, noticeTitle, createDate
	// output(false): ArrayList<Notice> => null;
	public ArrayList<Notice> selectNoticeList(int beginRow, int rowPerPage, String searchNoticeTitle) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] NoticeDao.selectNoticeList(int beginRow, int rowPerPage, String searchNoticeTitle) => 페이지 시작 행 :" + beginRow);
		System.out.println("[debug] NoticeDao.selectNoticeList(int beginRow, int rowPerPage, String searchNoticeTitle) => 페이지당 행 개수 :" + rowPerPage);
		System.out.println("[debug] NoticeDao.selectNoticeList(int beginRow, int rowPerPage, String searchNoticeTitle) => 검색된 공지사항 제목 :" + searchNoticeTitle);
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 검색 키워드의 유무에 따라 다르게 쿼리문을 구성
		String sql = null;
		PreparedStatement stmt = null;
		
		// 검색어가 있을 경우
		if (searchNoticeTitle.equals("ALL") || searchNoticeTitle.equals("")) {
			
			// 쿼리문 생성
			sql = "SELECT notice_no noticeNo, notice_Title noticeTitle, create_date createDate FROM notice ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
			
		// 검색어가 없을 경우	
		} else {
			
			// 쿼리문 생성
			sql = "SELECT notice_no noticeNo, notice_title noticeTitle, create_date createDate FROM notice WHERE notice_title LIKE ? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1,"%" + searchNoticeTitle + "%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			
		}
		
		// 쿼리 실행
		ResultSet rs = stmt.executeQuery();
		
		// 반환할 리스트 생성
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		
		// 객체에 입력된 값을 순서대로 보기 위해 사용하는 변수(없어도 됨, 단지 확인을 위해서 선언한 것)
		int i = 1;
		
		// 조회 결과 값 담기
		while (rs.next()) {
			
			// 객체 생성
			Notice notice = new Notice();
			
			// 조회 결과 값 입력
			notice.setNoticeNo(rs.getInt("noticeNo"));
			notice.setNoticeTitle(rs.getString("noticeTitle"));
			notice.setCreateDate(rs.getString("createDate"));
			
			// 출력값 디버깅
			System.out.println("[debug] NoticeDao.selectNoticeList(int beginRow, int rowPerPage, String searchNoticeTitle) => " + i + "번째 공지사항 넘버 : " + notice.getNoticeNo());
			System.out.println("[debug] NoticeDao.selectNoticeList(int beginRow, int rowPerPage, String searchNoticeTitle) => " + i + "번째 공지사항 제목 : " + notice.getNoticeTitle());
			System.out.println("[debug] NoticeDao.selectNoticeList(int beginRow, int rowPerPage, String searchNoticeTitle) => " + i + "번째 공지사항 등록날짜 : " + notice.getCreateDate());
			
			// 리스트에 객체 추가
			noticeList.add(notice);
			
			// 순번 확인을 위한 덧셈 처리
			i += 1;
		}
		
		// DB 자원 해제
		rs.close();
		stmt.close();
		conn.close();
		
		return noticeList;
	}
	
	
	/*[회원, 비회원, 관리자] 공지사항 상세보기*/
	// input: Notice => noticeNo
	// output(success): NoticeMember => Notice => noticeNo, noticeTiitle, noticeContent, createDate updateDate,
	//								 => Member => memberNo, memberName, memberId
	// output(false): NoticeMember => null;
	public NoticeMember selectNoticeOne(Notice notice) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] NoticeDao.selectNoticeOne(Notice noticie) => 입력받은 세부보기할 공지사항 넘버 :" + notice.getNoticeNo());
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 쿼리문 생성
		String sql = "SELECT n.notice_no noticeNo, n.notice_title noticeTitle, n.notice_content noticeContent, n.create_date createDate, n.update_date updateDate, m.member_no memberNo, m.member_name memberName, m.member_id memberId FROM notice n JOIN member m ON n.member_no=m.member_no WHERE n.notice_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setInt(1, notice.getNoticeNo());
		
		// 쿼리문 실행
		ResultSet rs = stmt.executeQuery();
		
		// 객체 생성
		NoticeMember nm = new NoticeMember();
		
		// 조회 결과 값 담기
		if (rs.next()) {
			
			// 공지사항 객체 생성
			Notice n = new Notice();
			
			// 공지사항 관련 조회 결과 값 입력
			n.setNoticeNo(rs.getInt("noticeNo"));
			n.setNoticeTitle(rs.getString("noticeTitle"));
			n.setNoticeContent(rs.getString("noticeContent"));
			n.setCreateDate(rs.getString("createDate"));
			n.setUpdateDate(rs.getString("updateDate"));
			
			// 출력값 디버깅
			System.out.println("[debug] NoticeDao.selectNoticeOne(Notice noticie) => 세부보기할 공지사항 넘버 :" + n.getNoticeNo());
			System.out.println("[debug] NoticeDao.selectNoticeOne(Notice noticie) => 세부보기할 공지사항 제목 :" + n.getNoticeTitle());
			System.out.println("[debug] NoticeDao.selectNoticeOne(Notice noticie) => 세부보기할 공지사항 내용 :" + n.getNoticeContent());
			System.out.println("[debug] NoticeDao.selectNoticeOne(Notice noticie) => 세부보기할 공지사항 등록날짜 :" + n.getCreateDate());
			System.out.println("[debug] NoticeDao.selectNoticeOne(Notice noticie) => 세부보기할 공지사항 수정날짜 :" + n.getUpdateDate());
			
			// 반환할 최종 객체에 공지사항 객체 입력
			nm.setNotice(n);
			
			// 회원 객체 생성
			Member m = new Member();
			
			// 회원 관련 조회 결과 값 입력
			m.setMemberNo(rs.getInt("memberNo"));
			m.setMemberName(rs.getString("memberName"));
			m.setMemberId(rs.getString("memberId"));
			
			// 출력값 디버깅
			System.out.println("[debug] NoticeDao.selectNoticeOne(Notice noticie) => 세부보기할 공지사항 작성자 넘버 :" + m.getMemberNo());
			System.out.println("[debug] NoticeDao.selectNoticeOne(Notice noticie) => 세부보기할 공지사항 작성자 이름 :" + m.getMemberName());
			System.out.println("[debug] NoticeDao.selectNoticeOne(Notice noticie) => 세부보기할 공지사항 작성자 아이디 :" + m.getMemberId());
			
			// 반환할 최종 객체에 회원 객체 입력
			nm.setMember(m);
		}
		
		// db 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
				
		return nm;
	}
	
	/*[관리자] 공지사항 등록*/
	// input: Notice => noticeTiitle, noticeContent, memberNo
	// output(success): int => confirm
	// output(false): int => 0
	public int insertNotice(Notice notice) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] NoticeDao.insertNotice(Notice notice) => 입력받은 등록할 공지사항 제목 : " + notice.getNoticeTitle());
		System.out.println("[debug] NoticeDao.insertNotice(Notice notice) => 입력받은 등록할 공지사항 내용 : " + notice.getNoticeContent());
		System.out.println("[debug] NoticeDao.insertNotice(Notice notice) => 입력받은 등록할 공지사항 작성자 넘버 : " + notice.getMemberNo());
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
				
		// 쿼리문 생성
		String sql = "INSERT INTO notice VALUES(notice_title=?, notice_content=?, member_no=?, create_date=NOW(), update_date=Now())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setString(1, notice.getNoticeTitle());
		stmt.setString(2, notice.getNoticeContent());
		stmt.setInt(3, notice.getMemberNo());
		
		// 쿼리문 실행 결과 저장
		int confirm = stmt.executeUpdate();
		
		// DB 작업 결과 디버깅
		System.out.println("[debug] NoticeDao.insertNotice(Notice notice) => 등록된 공지사항 개수 : " + confirm);

		// db 자원 헤제
		stmt.close();
		conn.close();
				
		return confirm;
	}
	
	/*[관리자] 공지사항 변경*/
	// input: Notice => noticeNo, noticeTiitle, noticeContent, memberNo
	// output(success): int => confirm
	// output(false): int => 0
	public int updateNotice(Notice notice) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] NoticeDao.updateNotice(Notice notice) => 입력받은 수정할 공지사항 넘버 : " + notice.getNoticeNo());
		System.out.println("[debug] NoticeDao.updateNotice(Notice notice) => 입력받은 수정할 공지사항 제목 : " + notice.getNoticeTitle());
		System.out.println("[debug] NoticeDao.updateNotice(Notice notice) => 입력받은 수정할 공지사항 내용 : " + notice.getNoticeContent());
		System.out.println("[debug] NoticeDao.updateNotice(Notice notice) => 입력받은 수정할 공지사항 작성자 넘버 : " + notice.getMemberNo());
		
		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
				
		// 쿼리문 생성
		String sql = "UPDATE notice SET notice_title=?, notice_content=?, update_date=NOW() WHERE notice_no=? AND member_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setString(1, notice.getNoticeTitle());
		stmt.setString(2, notice.getNoticeContent());
		stmt.setInt(3, notice.getNoticeNo());
		stmt.setInt(4, notice.getMemberNo());
		
		
		// 쿼리문 실행 결과 저장
		int confirm = stmt.executeUpdate();
		
		// DB 작업 결과 디버깅
		System.out.println("[debug] NoticeDao.insertNotice(Notice notice) => 수정된 공지사항 개수 : " + confirm);

		// db 자원 헤제
		stmt.close();
		conn.close();
				
		return confirm;
		
	}
	
	/* [관리자] 공지사항 삭제 */
	// input: Notice => noticeNo, memberNo
	// output(success): int => confirm
	// output(false): int => 0
	public int deleteNotice(Notice notice) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] NoticeDao.deleteNotice(Notice notice) => 입력받은 삭제할 공지사항 넘버 : " + notice.getNoticeNo());

		// db 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
				
		// 쿼리문 생성
		String sql = "DLETE FORM notice WHERE notice_no=? AND member_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setInt(1, notice.getNoticeNo());
		stmt.setInt(2, notice.getMemberNo());
		
		// 쿼리문 실행 결과 저장
		int confirm = stmt.executeUpdate();
		
		// DB 작업 결과 디버깅
		System.out.println("[debug] NoticeDao.deleteNotice(Notice notice) => 삭제된 공지사항 개수 : " + confirm);

		// db 자원 헤제
		stmt.close();
		conn.close();
				
		return confirm;
	}
}
