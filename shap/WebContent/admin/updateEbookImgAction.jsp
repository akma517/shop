<%@page import="vo.Ebook"%>
<%@page import="dao.EbookDao"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="vo.Member"%>
<%@page import="dao.MemberDao"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	/* 사전작업 */
	request.setCharacterEncoding("utf-8");
	System.out.println("[debug] updateEbookImgAction.jsp 로직 진입");
	
	/* admin 방어 코드 */
	// 로그인 정보가 없거나 등급이 낮을 경우 강제로 index.jsp로 돌려보낸다.
    Member loginMember = (Member)session.getAttribute("loginMember");
    if(loginMember == null || loginMember.getMemberLevel() < 1) {
       response.sendRedirect(request.getContextPath()+"/index.jsp");
       System.out.println("[debug] updateEbookImgAction.jsp => index.jsp로 강제 이동: 접근권한이 없는 이용자의 강제 접근을 막았습니다.");
       return;
    } 
	
	
	// 넘겨받은 파일을 지정 경로에 저장
	// MultipartRequest를 기존 Request를 대체하여 사용
	MultipartRequest mr = new MultipartRequest(request, "F:/git-shap/shap/WebContent/images", 1024*1024*1024, "utf-8", new DefaultFileRenamePolicy());
	
	// 입력값 받기
	// int형은 null로 비교하여 유효성 검사를 할 수 없기에 String으로 유효성 검사 후, int로 변환
	// form에서 가시성을 위해 넣어둔 "넘버: "를 제거
	String testEbookNo = mr.getParameter("ebookNo");
	testEbookNo = testEbookNo.substring(4);
	
	String ebookImg = mr.getFilesystemName("ebookImg");
	
	// 입력값 디버깅
	System.out.println("[debug] updateEbookImgAction.jsp => 사진을 수정할 전자책 넘버 : " +  testEbookNo);
	System.out.println("[debug] updateEbookImgAction.jsp => 수정할 전자책 이름 : " +  ebookImg);
	
	// 유효성 검사
	if ( testEbookNo == null || ebookImg == null) {
		response.sendRedirect(request.getContextPath() + "/admin/selectEbookList.jsp");
		System.out.println("[debug] updateEbookImgAction.jsp => updateEbookImgForm.jsp로 강제 이동: 입력값에 null값이 있어 selectEbookImg.jsp 페이지로 돌려보냈습니다.");
		return; 
	}
	
	// 유효성 검사 끝나고 int 형으로 변환
	int ebookNo = Integer.parseInt(testEbookNo);

	// db 작업 위한 Dao 객체 생성
	EbookDao ebookDao = new EbookDao();
			
	// 멤버 정보 설정
	Ebook ebook = new Ebook();
	
	ebook.setEbookNo(ebookNo);
	ebook.setEbookImg(ebookImg);
	
	
	int confirm = ebookDao.updateEbookImgByAdmin(ebook);
	
	if (confirm==1) {
		
		System.out.println("[debug] updateEbookImgAction.jsp => 전자책 사진 수정 성공");
		response.sendRedirect(request.getContextPath() + "/admin/selectEbookOne.jsp?ebookNo=" + ebook.getEbookNo());
		
		System.out.println("[debug] updateEbookImgAction.jspp 로직 종료");
		
		return;
	} else {
		
		System.out.println("[debug] updateEbookImgAction.jsp => 전자책 사진 수정 실패 : 입력 정보를 다시 확인해 주세요.");
		response.sendRedirect(request.getContextPath() + "/admin/updateEbookImgForm.jsp?ebookNo=" + ebook.getEbookNo());
		
		System.out.println("[debug] updateEbookImgAction.jsp 로직 종료");
		
		return;
	}

%>