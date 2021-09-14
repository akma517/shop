package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBUtil;
import vo.Member;

// 규칙 => 매개변수값은 첫줄에 디버깅
public class MemberDao {
	
	/* 로그인 */
	// input: Member => memberId, memberPw
	// output(success): Member => , memberNo, memberId, memberName, memberLevel
	// output(false): null
	public Member login(Member member) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] MemberDao.login(Member member) => 입력받은 멤버 아이디 : " + member.getMemberId());
		System.out.println("[debug] MemberDao.login(Member member) => 입력받은 멤버 비밀번호 : " + member.getMemberPw());
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 별칭(alias)를 설정할 때, AS를 안붙여줘도 되고, 별칭이 영어일 경우, ""를 사용해주지 않아도 된다.
		String sql = 
				"SELECT "
				+ "member_no memberNo, "
				+ "member_id memberId, "
				+ "member_name memberName, "
				+ "member_level memberLevel "
				+ "FROM "
				+ "member "
				+ "WHERE "
				+ "member_id=? and member_pw=PASSWORD(?)";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		stmt.setString(1,member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		
		// 쿼리 디버깅
		System.out.println("[debug] MemberDao.login(Member member) => 쿼리문 : " + stmt);
		
		ResultSet rs = stmt.executeQuery();
		
		
		// 객체에 null을 넣으면 그 객체의 기본 구조도 없이 그냥 null 값이 된다. 객체에 null을 넣고 그 객체의 메소드를 호출하면 nullPointError가 발생한다.
		
		if(rs.next()) {
			
			Member returnedMember = new Member();
			
			returnedMember.setMemberNo(rs.getInt("memberNo"));
			returnedMember.setMemberId(rs.getString("memberId"));
			returnedMember.setMemberName(rs.getString("memberName"));
			returnedMember.setMemberLevel(rs.getInt("memberLevel"));
			
			// 출력값 디버깅
			System.out.println("[debug] MemberDao.login(Member member) => 멤버 아이디 : " + returnedMember.getMemberNo());
			System.out.println("[debug] MemberDao.login(Member member) => 멤버 아이디 : " + returnedMember.getMemberId());
			System.out.println("[debug] MemberDao.login(Member member) => 멤버 이름 : " + returnedMember.getMemberName());
			System.out.println("[debug] MemberDao.login(Member member) => 멤버 레벨 : " + returnedMember.getMemberLevel());
			
			rs.close();
			stmt.close();
			conn.close();
			
			return returnedMember;
			
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return null;
	}
	
	/* 회원 가입(insert) */
	// input:  Member => memberId, memberPw, MemberName, MemberAge, MemberGender
	// output(success): 1
	// output(false): 0
	public int insertMember(Member member) throws ClassNotFoundException, SQLException {
		
		// 입력값 디버깅
		System.out.println("[debug] MemberDao.insertMember(Member member) => 가입자 아이디 : " + member.getMemberId());
		System.out.println("[debug] MemberDao.insertMember(Member member) => 가입자 비밀번호 : " + member.getMemberPw());
		System.out.println("[debug] MemberDao.insertMember(Member member) => 가입자 이름 : " + member.getMemberName());
		System.out.println("[debug] MemberDao.insertMember(Member member) => 가입자 나이 : " + member.getMemberAge());
		System.out.println("[debug] MemberDao.insertMember(Member member) => 가입자 성별 : " + member.getMemberGender());
		
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		
		// 별칭(alias)를 설정할 때, AS를 안붙여줘도 되고, 별칭이 영어일 경우, ""를 사용해주지 않아도 된다.
		String sql = 
				"INSERT INTO member("
				+ "member_id, "
				+ "member_pw, "
				+ "member_level, "
				+ "member_name, "
				+ "member_age, "
				+ "member_gender,"
				+ "update_date, "
				+ "create_date"
				+ ") VALUES("
				+ "?, PASSWORD(?), 0, ?, ?, ?, NOW(), NOW()"
				+ ")";
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		stmt.setString(3, member.getMemberName());
		stmt.setInt(4, member.getMemberAge());
		stmt.setString(5, member.getMemberGender());
		
		// 쿼리 디버깅
		System.out.println("[debug] MemberDao.insertMember(Member member) => 쿼리문 : " + stmt);
		
		// db 작업 결과 성공 여부 저장
		int confirm = stmt.executeUpdate();
		
		stmt.close();
		conn.close();
		
		return confirm;
	}
	
}
