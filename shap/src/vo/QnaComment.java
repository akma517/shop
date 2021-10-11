package vo;

public class QnaComment {
	
	private int qnaCommentNo;
	private int qnaNo;
	private int memberNo;
	private String qnaCommentContent;
	private String createDate;
	private String updateDate;
	
	public int getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(int memberNo) {
		this.memberNo = memberNo;
	}
	public int getQnaCommentNo() {
		return qnaCommentNo;
	}
	public void setQnaCommentNo(int qnaCommentNo) {
		this.qnaCommentNo = qnaCommentNo;
	}
	public int getQnaNo() {
		return qnaNo;
	}
	public void setQnaNo(int qnaNo) {
		this.qnaNo = qnaNo;
	}
	public String getQnaCommentContent() {
		return qnaCommentContent;
	}
	public void setQnaCommentContent(String qnaCommentContent) {
		this.qnaCommentContent = qnaCommentContent;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	@Override
	public String toString() {
		return "QnaComment [qnaCommentNo=" + qnaCommentNo + ", qnaNo=" + qnaNo + ", memberNo=" + memberNo
				+ ", qnaCommentContent=" + qnaCommentContent + ", createDate=" + createDate + ", updateDate="
				+ updateDate + "]";
	}
	
}
