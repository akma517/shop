package vo;

public class Qna {
	
	private int qnaNo;
	private String qnaTitle;
	private String qnaCategory;
	private String qnaSecret;
	private String qnaContent;
	private int memberNo;
	private String createDate;
	private String updateDate;
	
	public int getQnaNo() {
		return qnaNo;
	}
	public void setQnaNo(int qnaNo) {
		this.qnaNo = qnaNo;
	}
	public String getQnaTitle() {
		return qnaTitle;
	}
	public void setQnaTitle(String qnaTitle) {
		this.qnaTitle = qnaTitle;
	}
	public String getQnaCategory() {
		return qnaCategory;
	}
	public void setQnaCategory(String qnaCategory) {
		this.qnaCategory = qnaCategory;
	}
	public String getQnaSecret() {
		return qnaSecret;
	}
	public void setQnaSecret(String qnaSecret) {
		this.qnaSecret = qnaSecret;
	}
	public int getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(int memberNo) {
		this.memberNo = memberNo;
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
	public String getQnaContent() {
		return qnaContent;
	}
	public void setQnaContent(String qnaContent) {
		this.qnaContent = qnaContent;
	}
	@Override
	public String toString() {
		return "Qna [qnaNo=" + qnaNo + ", qnaTitle=" + qnaTitle + ", qnaCategory=" + qnaCategory + ", qnaSecret="
				+ qnaSecret + ", qnaContent=" + qnaContent + ", memberNo=" + memberNo + ", createDate=" + createDate
				+ ", updateDate=" + updateDate + "]";
	}
	
}
