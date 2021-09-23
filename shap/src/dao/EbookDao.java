package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import common.DBUtil;
import vo.Ebook;

public class EbookDao {
	
	/* [관리자] 검색된 전자책 목록 출력(select) */
	// input: int => beginRow, rowPerPage, String => searchEbookTitle, searchCategoryName
	// output(success): ArrayList<Ebook> => ebookNo, ebookTitle, categoryName, ebookState
	// output(false): null
	public ArrayList<Ebook> selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 검색한 전자책 제목 : " + searchEbookTitle);
		System.out.println("[debug] selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 검색한 전자책 종류 : " + searchCategoryName);
		System.out.println("[debug] selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 시작 행 : " + beginRow);
		System.out.println("[debug] selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 입력받은 페이지 당 행 : " + rowPerPage);
		
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
		System.out.println("[debug] selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => 쿼리문 : " + stmt);
		
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
			System.out.println("[debug] selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 넘버 : " + ebook.getEbookNo());
			System.out.println("[debug] selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 카테고리 : " + ebook.getCategoryName());
			System.out.println("[debug] selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 제목 : " + ebook.getEbookTitle());
			System.out.println("[debug] selectEbookListBySearchEbookTitleAndCategoryName(String searchEbookTitle, String searchCategoryName ,int beginRow, int rowPerPage) => " + i + "번째 전자책 상태 : " + ebook.getEbookState());
			
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
		System.out.println("[debug] selectCountSearchedEbook(String searchEbookTitle, String searchCategoryName) => 입력받은 검색한 전자책 제목 : " + searchEbookTitle);
		System.out.println("[debug] selectCountSearchedEbook(String searchEbookTitle, String searchCategoryName) => 입력받은 검색한 전자책 카테고리 이름 : " + searchCategoryName);
		
		
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
					
		System.out.println("[debug] selectCountSearchedEbook(String searchEbookTitle, String searchCategoryName) => 쿼리문 : " + stmt);
		
		int countSearchedEbook = 0;
		
		if (rs.next()) {
			countSearchedEbook = rs.getInt(1);	
		}
					
		System.out.println("[debug] selectCountSearchedEbook(String searchEbookTitle, String searchCategoryName) => 검색된 전자책의 수 : " + countSearchedEbook);

		rs.close();
		stmt.close();
		conn.close();
		
		return countSearchedEbook;
	}
	
}
