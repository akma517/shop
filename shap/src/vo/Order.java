package vo;

public class Order {
	
	private int orderNo;
	private int orderPrice;
	private int ebookNo;
	private int memberNo;
	private String orderCommentState;
	private String createDate;
	private String updateDate;
	
	public String getOrderCommentState() {
		return orderCommentState;
	}

	public void setOrderCommentState(String orderCommentState) {
		this.orderCommentState = orderCommentState;
	}


	public int getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}

	public int getOrderPrice() {
		return orderPrice;
	}

	public void setOrderPrice(int orderPrice) {
		this.orderPrice = orderPrice;
	}

	public int getEbookNo() {
		return ebookNo;
	}

	public void setEbookNo(int ebookNo) {
		this.ebookNo = ebookNo;
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

	@Override
	public String toString() {
		return "Order [orderNo=" + orderNo + ", orderPrice=" + orderPrice + ", ebookNo=" + ebookNo + ", memberNo="
				+ memberNo + ", orderCommentState=" + orderCommentState + ", createDate=" + createDate + ", updateDate="
				+ updateDate + "]";
	}
	
	
}
