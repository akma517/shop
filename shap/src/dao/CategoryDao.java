package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import common.DBUtil;
import vo.Category;

public class CategoryDao {
	
	/* [관리자] 카테고리 이름 중복 여부 검증(select) */
	// input: Category => categoryName
	// output(success): 0
	// output(false): 1 or more than 1
	public int selectCategoryNameByAdmin(Category category) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] CategoryDao.selectCategoryNamedByAdmin(Category category) => 중복 여부를 검사할 카테고리 이름 : " + category.getCategoryName());
		
		// db 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 별칭(alias)를 설정할 때, AS를 안붙여줘도 되고, 별칭이 영어일 경우, ""를 사용해주지 않아도 된다.
		String sql = "SELECT COUNT(*) FROM category WHERE category_name=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		stmt.setString(1, category.getCategoryName());
		
		// 쿼리 디버깅
		System.out.println("[debug] CategoryDao.selectCategoryNamedByAdmin(Category category) => 쿼리문 : " + stmt);
	
		ResultSet rs = stmt.executeQuery();
		
		int countMember = 0;
		if (rs.next()) {
			countMember = rs.getInt(1);	
		}
					
		System.out.println("[debug] CategoryDao.selectCategoryNamedByAdmin(Category category) => 입력받은 카테고리 이름과 일치하는 기존 카테고리 수 : " + countMember);
		
		// db 해제
		rs.close();
		stmt.close();
		conn.close();
		
		return countMember;
		
	}

	/* [관리자] 카테고리 사용 유무 수정(update) */
	// input: Category => categoryName, categoryState
	// output(success): 1
	// output(false): 0
	public int updateCategoryStateByAdmin(Category category) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] CategoryDao.updateCategoryStateByAdmin(Category category) => 사용 유무를 수정할 카테고리 이름 : " + category.getCategoryName());
		System.out.println("[debug] CategoryDao.updateCategoryStateByAdmin(Category category) => 변경할 카테고리 상태 : " + category.getCategoryState());
		
		// db 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 별칭(alias)를 설정할 때, AS를 안붙여줘도 되고, 별칭이 영어일 경우, ""를 사용해주지 않아도 된다.
		String sql = "UPDATE category SET category_state=?, update_date=NOW() WHERE category_name=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리문 세팅
		stmt.setString(1, category.getCategoryState());
		stmt.setString(2, category.getCategoryName());
		
		// 쿼리 디버깅
		System.out.println("[debug]CategoryDao.updateCategoryStateByAdmin(Category category) => 쿼리문 : " + stmt);
		
		// db 작업 결과 성공 여부 저장
		int confirm = stmt.executeUpdate();
		
		// db 해제
		stmt.close();
		conn.close();
		
		return confirm;

	}
	
	/* [관리자] 카테고리 목록 출력(select) */
	// input: none
	// output(success): ArrayList<Category> => categoryName, createDate, updateDate, categoryState
	// output(false): null
	public ArrayList<Category> selectCategoryListByAdmin() throws ClassNotFoundException, SQLException {
		
		// db 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 별칭(alias)를 설정할 때, AS를 안붙여줘도 되고, 별칭이 영어일 경우, ""를 사용해주지 않아도 된다.
		String sql = "SELECT category_name categoryName, create_date createDate, update_date updateDate, category_state categoryState FROM category";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 쿼리 디버깅
		System.out.println("[debug] CategoryDao.selectCategoryListByAdmin() => 쿼리문 : " + stmt);
		
		ResultSet rs = stmt.executeQuery();
		
		ArrayList<Category> categoryList = new ArrayList<Category>();
		
		int i = 1;
		
		while(rs.next()) {
			
			Category category = new Category();
			
			category.setCategoryName(rs.getString("categoryName"));
			category.setCreateDate(rs.getString("createDate"));
			category.setUpdateDate(rs.getString("updateDate"));
			category.setCategoryState(rs.getString("categoryState"));
			
			// 출력값 디버깅
			System.out.println("[debug] CategoryDao.selectCategoryListByAdmin() => " + i + "번째 카테고리 이름 : " + category.getCategoryName());
			System.out.println("[debug] CategoryDao.selectCategoryListByAdmin() => " + i + "번째 카테고리 추가날짜 : " + category.getCreateDate());
			System.out.println("[debug] CategoryDao.selectCategoryListByAdmin() => " + i + "번째 카테고리 수정날짜 : " + category.getUpdateDate());
			System.out.println("[debug] CategoryDao.selectCategoryListByAdmin() => " + i + "번째 카테고리 상태 : " + category.getCategoryState());
			
			categoryList.add(category);
			
			i += 1;
			
		}
		
		// db 해제
		rs.close();
		stmt.close();
		conn.close();
		
		// 조회결과 아무런 값도 안 나오면 null을 반환
		if(categoryList.isEmpty()) {
			return null;
		}
		
		return categoryList;
	}
	
	/* [비회원] 카테고리 추가(insert) */
	// input:  Category => categoryName, categoryState
	// output(success): 1
	// output(false): 0
	public int insertCategory(Category category) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug]CateogryDao.insertCategory(Category category) => 추가할 카테고리 이름 : " + category.getCategoryName());
		System.out.println("[debug]CateogryDao.insertCategory(Category category) => 추가할 카테고리 상태 : " + category.getCategoryState());
		
		// db 연결
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 별칭(alias)를 설정할 때, AS를 안붙여줘도 되고, 별칭이 영어일 경우, ""를 사용해주지 않아도 된다.
		String sql = "INSERT INTO category(category_name, create_date, update_date, category_state) VALUES(?,NOW(),NOW(),?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		stmt.setString(1, category.getCategoryName());
		stmt.setString(2, category.getCategoryState());
		
		// 쿼리 디버깅
		System.out.println("[debug]CateogryDao.insertCategory(Category category) => 쿼리문 : " + stmt);
		
		// db 작업 결과 성공 여부 저장
		int confirm = stmt.executeUpdate();
		
		// db 해제
		stmt.close();
		conn.close();
		
		return confirm;
	}
}
