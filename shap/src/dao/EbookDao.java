package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import common.DBUtil;
import vo.Ebook;

public class EbookDao {
	
	/* [관리자] [고객] 신규 상품 5개의 전자책 목록 출력(select) */
	// input: nothing
	// output(success): ArrayList<Ebook> => ebookNo, ebookTitle, categoryName, ebookState, ebookImg
	// output(false): ArrayList<Ebook> => null
	public ArrayList<Ebook> selectEbookListNew() throws ClassNotFoundException, SQLException {
		
		// DB 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 쿼리문 생성
		String sql = "SELECT e.ebook_no ebookNo, e.ebook_title ebookTitle, e.category_name categoryName, e.ebook_state ebookState, e.ebook_img ebookImg FROM (SELECT ebook_no FROM orders GROUP BY ebook_no ORDER BY create_date DESC LIMIT 5) t JOIN ebook e ON e.ebook_no=t.ebook_no";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리 디버깅
		System.out.println("[debug] EbookDao.selectEbookListNew() => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<Ebook> ebookList = new ArrayList<Ebook>();
		
		int i = 1;
		
		while(rs.next()) {
			
			Ebook ebook = new Ebook();
			
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookState(rs.getString("ebookState"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			
			// 출력값 디버깅
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 신규 전자책 넘버 : " + ebook.getEbookNo());
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 신규 전자책 카테고리 : " + ebook.getCategoryName());
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 신규 전자책 제목 : " + ebook.getEbookTitle());
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 신규 전자책 상태 : " + ebook.getEbookState());
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 신규 전자책 이미지 : " + ebook.getEbookImg());
			
			ebookList.add(ebook);
			
			i += 1;
			
		}
		
		// DB 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
		
		return ebookList;
	}
	
	/* [관리자] [고객] 판매량 상위 5개의 전자책 목록 출력(select) */
	// input: nothing
	// output(success): ArrayList<Ebook> => ebookNo, ebookTitle, categoryName, ebookState, ebookImg
	// output(false): ArrayList<Ebook> => null
	public ArrayList<Ebook> selectEbookListTop() throws ClassNotFoundException, SQLException {
		
		// DB 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 쿼리문 생성
		String sql = "SELECT e.ebook_no ebookNo, e.ebook_title ebookTitle, e.category_name categoryName, e.ebook_state ebookState, e.ebook_img ebookImg FROM (SELECT  ebook_no, COUNT(ebook_no) AS count_ebook_no FROM orders GROUP BY ebook_no ORDER BY count_ebook_no DESC LIMIT 5) t JOIN ebook e ON e.ebook_no=t.ebook_no";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리 디버깅
		System.out.println("[debug] EbookDao.selectEbookListTop() => 쿼리문 : " + stmt);
		
		// 쿼리문 실행
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<Ebook> ebookList = new ArrayList<Ebook>();
		
		int i = 1;
		
		while(rs.next()) {
			
			Ebook ebook = new Ebook();
			
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookState(rs.getString("ebookState"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			
			// 출력값 디버깅
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 인기 전자책 넘버 : " + ebook.getEbookNo());
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 인기 전자책 카테고리 : " + ebook.getCategoryName());
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 인기 전자책 제목 : " + ebook.getEbookTitle());
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 인기 전자책 상태 : " + ebook.getEbookState());
			System.out.println("[debug] EbookDao.selectEbookListTop() => " + i + "번째 인기 전자책 이미지 : " + ebook.getEbookImg());
			
			ebookList.add(ebook);
			
			i += 1;
			
		}
		
		// DB 자원 헤제
		rs.close();
		stmt.close();
		conn.close();
		
		return ebookList;
	}
	
	
	/* [관리자] 전자책 상세보기(select) */
	// input: Ebook -> ebookImg
	// output(success): 1
	// output(false): 0
	public int updateEbookImgByAdmin(Ebook ebook) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] EbookDao.updateEbookImgByAdmin(Ebook ebook) => 사진을 수정할 전자책 넘버 : " + ebook.getEbookNo());
		System.out.println("[debug] EbookDao.updateEbookImgByAdmin(Ebook ebook) => 수정할 전자책 사진 이름 : " + ebook.getEbookImg());
		
		// DB 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 쿼리문 생성
		String sql = "UPDATE ebook SET ebook_img=?, update_date=NOW() WHERE ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setString(1, ebook.getEbookImg());
		stmt.setInt(2, ebook.getEbookNo());
		
		System.out.println("[debug] EbookDao.updateEbookImgByAdmin(Ebook ebook) => 쿼리문 : " + stmt);
		
		int confirm = stmt.executeUpdate();
		
		System.out.println("[debug] EbookDao.updateEbookImgByAdmin(Ebook ebook) => 수정된 전자책의 수 : " + confirm);
		
		// DB 자원 해제
		stmt.close();
		conn.close();
		
		return confirm;
	}
	
	/* [관리자] 전자책 상세보기(select) */
	// input: int -> ebookNo
	// output(success): Ebook => ebookNo, ebookISBN, ebookTitle, ebookAuthor, ebookCompany, ebookPageCount, ebookPrice, ebookImg, ebookSummary, ebookState, createDate updateDate
	// output(false): Ebook => null;
	public Ebook selectEbookOneByAdmin(int ebookNo) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 상세보기할 전자책 넘버 : " + ebookNo);
		
		// DB 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 쿼리문 생성
		String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_isbn ebookISBN, ebook_title ebookTitle, ebook_Author ebookAuthor, ebook_company ebookCompany, ebook_page_count ebookPageCount, ebook_price ebookPrice, ebook_img ebookImg, ebook_summary ebookSummary, ebook_state ebookState, create_date createDate, update_date updateDate FROM ebook WHERE ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setInt(1, ebookNo);
		
		System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 쿼리문 : " + stmt);
		
		ResultSet rs = stmt.executeQuery();
		
		Ebook ebook = new Ebook();
		
		if(rs.next()) {
			
			// VO에 조회된 전자책 상세 정보를 저장
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setEbookISBN(rs.getString("ebookISBN"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookAuthor(rs.getString("ebookAuthor"));
			ebook.setEbookCompany(rs.getString("ebookCompany"));
			ebook.setEbookPageCount(rs.getInt("ebookPageCount"));
			ebook.setEbookPrice(rs.getInt("ebookPrice"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			ebook.setEbookSummary(rs.getString("ebookSummary"));
			ebook.setEbookState(rs.getString("ebookState"));
			ebook.setCreateDate(rs.getString("createDate"));
			ebook.setUpdateDate(rs.getString("updateDate"));
			
			// 전자책 상세 정보 디버깅
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 넘버: " + ebook.getEbookNo());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 ISBN: " + ebook.getEbookISBN());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 카테고리: " + ebook.getCategoryName());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 제목: " + ebook.getEbookTitle());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 저자: " + ebook.getEbookAuthor());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 출판사: " + ebook.getEbookCompany());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 페이지 수: " + ebook.getEbookPageCount());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 가격: " + ebook.getEbookPrice());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 사진: " + ebook.getEbookImg());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 요약: " + ebook.getEbookSummary());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 상태: " + ebook.getEbookState());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 작성날짜: " + ebook.getCreateDate());
			System.out.println("[debug] EbookDao.selectEbookOneByAdmin(int ebookNo) => 전자책 상세정보 갱신날짜: " + ebook.getUpdateDate());
			
		}
		
		// DB 자원 해제
		rs.close();
		stmt.close();
		conn.close();
		
		return ebook;
	}
	
	/* [관리자, 고객]검색된 전자책 목록 출력(select) */
	// input: int => beginRow, rowPerPage, String => searchEbookTitle, searchCategoryName
	// output(success): ArrayList<Ebook> => ebookNo, ebookTitle, categoryName, ebookState, ebookImg
	// output(false): ArrayList<Ebook> => null
	public ArrayList<Ebook> selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 검색한 전자책 제목 : " + searchEbookTitle);
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 검색한 전자책 종류 : " + searchCategoryName);
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 시작 행 : " + beginRow);
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 페이지 당 행 : " + rowPerPage);
		
		// DB 자원 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = null;
		PreparedStatement stmt = null;
		
		/* 카테고리가 있고 없고에 따라(ALL or 특정 카테고리) 쿼리문을 다르게 구성 */
		// 입력받은 카테고리 이름과 전자책 제목이 없을 경우(전체검색)
		if (searchCategoryName.equals("ALL") && (searchEbookTitle.equals("ALL") || searchEbookTitle.equals(""))) {
			sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState, ebook_img ebookImg FROM ebook ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
						
		// 입력받은 카테고리 이름만 있을 경우
		} else if ( (!searchCategoryName.equals("ALL")) && (searchEbookTitle.equals("ALL") || searchEbookTitle.equals(""))){
			sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState, ebook_img ebookImg FROM ebook WHERE category_name=? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, searchCategoryName);
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			
		// 입력받은 전자책 제목만 있을 경우	
		} else if ( searchCategoryName.equals("ALL") && (!searchEbookTitle.equals("ALL") || !searchEbookTitle.equals(""))){
			sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState, ebook_img ebookImg FROM ebook WHERE ebook_title LIKE ? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, "%" + searchEbookTitle + "%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			
		// 입력받은 카테고리 이름과 전자책 제목이 있을 경우(전체검색)	
		} else if ( (!searchCategoryName.equals("ALL")) && (!searchEbookTitle.equals("ALL") || !searchEbookTitle.equals(""))){
			sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState, ebook_img ebookImg FROM ebook WHERE category_name=? AND ebook_title LIKE ? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, searchCategoryName);
			stmt.setString(2, "%" + searchEbookTitle + "%");
			stmt.setInt(3, beginRow);
			stmt.setInt(4, rowPerPage);
		}
		
		
		// 쿼리 디버깅
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 쿼리문 : " + stmt);
		
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<Ebook> ebookList = new ArrayList<Ebook>();
		
		int i = 1;
		
		while(rs.next()) {
			
			Ebook ebook = new Ebook();
			
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookState(rs.getString("ebookState"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			
			// 출력값 디버깅
			System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 넘버 : " + ebook.getEbookNo());
			System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 카테고리 : " + ebook.getCategoryName());
			System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 제목 : " + ebook.getEbookTitle());
			System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 상태 : " + ebook.getEbookState());
			System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryNameInIndex(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 이미지 : " + ebook.getEbookImg());
			
			ebookList.add(ebook);
			
			i += 1;
			
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return ebookList;
	}
	
	/* [관리자] 검색된 전자책 목록 출력(select) */
	// input: int => beginRow, rowPerPage, String => searchEbookTitle, searchCategoryName
	// output(success): ArrayList<Ebook> => ebookNo, ebookTitle, categoryName, ebookState
	// output(false): ArrayList<Ebook> => null
	public ArrayList<Ebook> selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 검색한 전자책 제목 : " + searchEbookTitle);
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 검색한 전자책 종류 : " + searchCategoryName);
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 시작 행 : " + beginRow);
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 페이지 당 행 : " + rowPerPage);
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		String sql = null;
		PreparedStatement stmt = null;
		
		/* 카테고리가 있고 없고에 따라(ALL or 특정 카테고리) 쿼리문을 다르게 구성 */
		// 입력받은 카테고리 이름과 전자책 제목이 없을 경우(전체검색)
		if (searchCategoryName.equals("ALL") && (searchEbookTitle.equals("ALL") || searchEbookTitle.equals(""))) {
			sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			stmt.setInt(1, beginRow);
			stmt.setInt(2, rowPerPage);
						
		// 입력받은 카테고리 이름만 있을 경우
		} else if ( (!searchCategoryName.equals("ALL")) && (searchEbookTitle.equals("ALL") || searchEbookTitle.equals(""))){
			sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE category_name=? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, searchCategoryName);
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			
		// 입력받은 전자책 제목만 있을 경우	
		} else if ( searchCategoryName.equals("ALL") && (!searchEbookTitle.equals("ALL") || !searchEbookTitle.equals(""))){
			sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE ebook_title LIKE ? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, "%" + searchEbookTitle + "%");
			stmt.setInt(2, beginRow);
			stmt.setInt(3, rowPerPage);
			
		// 입력받은 카테고리 이름과 전자책 제목이 있을 경우(전체검색)	
		} else if ( (!searchCategoryName.equals("ALL")) && (!searchEbookTitle.equals("ALL") || !searchEbookTitle.equals(""))){
			sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState FROM ebook WHERE category_name=? AND ebook_title LIKE ? ORDER BY create_date DESC LIMIT ?,?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, searchCategoryName);
			stmt.setString(2, "%" + searchEbookTitle + "%");
			stmt.setInt(3, beginRow);
			stmt.setInt(4, rowPerPage);
		}
		
		
		// 쿼리 디버깅
		System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 쿼리문 : " + stmt);
		
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<Ebook> ebookList = new ArrayList<Ebook>();
		
		int i = 1;
		
		while(rs.next()) {
			
			Ebook ebook = new Ebook();
			
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookState(rs.getString("ebookState"));
			
			// 출력값 디버깅
			System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 넘버 : " + ebook.getEbookNo());
			System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 카테고리 : " + ebook.getCategoryName());
			System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 제목 : " + ebook.getEbookTitle());
			System.out.println("[debug] EbookDao.selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 상태 : " + ebook.getEbookState());
			
			ebookList.add(ebook);
			
			i += 1;
			
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return ebookList;
	}
	
	
	/* [관리자]  검색된 전자책의 수 계산 (select) */
	// input:  String => searchEbookTitle, searchCategoryName
	// output(success): int => countSearchedEbook
	// output(false): 0
	public int selectCountSearchedEbook(String searchEbookTitle, String searchCategoryName) throws SQLException, ClassNotFoundException {
		
		// 입력값 디버깅
		System.out.println("[debug] EbookDao.selectCountSearchedEbook(String searchEbookTitle, String searchCategoryName) => 입력받은 검색한 전자책 제목 : " + searchEbookTitle);
		System.out.println("[debug] EbookDao.selectCountSearchedEbook(String searchEbookTitle, String searchCategoryName) => 입력받은 검색한 전자책 카테고리 이름 : " + searchCategoryName);
		
		
		// DBUtil 클래스로 connection을 만듬
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 조건에 맞는 검색 결과의 총 전자책의 수 계산하기
		String sql = null;
		PreparedStatement stmt = null;
		
		/* 카테고리가 있고 없고에 따라(ALL or 특정 카테고리) 쿼리문을 다르게 구성 */
		// 입력받은 카테고리 이름과 전자책 제목이 없을 경우(전체검색)
		if (searchCategoryName.equals("ALL") && (searchEbookTitle.equals("ALL") || searchEbookTitle.equals(""))) {
			sql = "SELECT COUNT(*) FROM ebook";
			stmt = conn.prepareStatement(sql);
						
		// 입력받은 카테고리 이름만 있을 경우
		} else if ( (!searchCategoryName.equals("ALL")) && (searchEbookTitle.equals("ALL") || searchEbookTitle.equals(""))){
			sql = "SELECT COUNT(*) FROM ebook WHERE category_name=?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, searchCategoryName);
			
		// 입력받은 전자책 제목만 있을 경우	
		} else if ( searchCategoryName.equals("ALL") && (!searchEbookTitle.equals("ALL") || !searchEbookTitle.equals(""))){
			sql = "SELECT COUNT(*) FROM ebook WHERE ebook_title Like ?";
			stmt = conn.prepareStatement(sql);
			
			// 쿼리문 세팅
			stmt.setString(1, "%" + searchEbookTitle + "%");
			
		// 입력받은 카테고리 이름과 전자책 제목이 있을 경우(전체검색)	
		} else if ( (!searchCategoryName.equals("ALL")) && (!searchEbookTitle.equals("ALL") || !searchEbookTitle.equals(""))){
			sql = "SELECT COUNT(*) FROM ebook WHERE category_name=? AND ebook_title LIKE ?";
			stmt = conn.prepareStatement(sql);
						
			// 쿼리문 세팅
			stmt.setString(1, searchCategoryName);
			stmt.setString(2, "%" + searchEbookTitle + "%");
		}
					
		ResultSet rs = stmt.executeQuery();
					
		System.out.println("[debug] EbookDao.selectCountSearchedEbook(String searchEbookTitle, String searchCategoryName) => 쿼리문 : " + stmt);
		
		int countSearchedEbook = 0;
		
		if (rs.next()) {
			countSearchedEbook = rs.getInt(1);	
		}
					
		System.out.println("[debug] EbookDao.selectCountSearchedEbook(String searchEbookTitle, String searchCategoryName) => 검색된 전자책의 수 : " + countSearchedEbook);

		rs.close();
		stmt.close();
		conn.close();
		
		return countSearchedEbook;
	}
	
}
