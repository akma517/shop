package vo;

public class OrderCommentMember {
	private OrderComment orderComment;
	private Member member;
	
	public OrderComment getOrderComment() {
		return orderComment;
	}
	public void setOrderComment(OrderComment orderComment) {
		this.orderComment = orderComment;
	}
	public Member getMember() {
		return member;
	}
	public void setMember(Member member) {
		this.member = member;
	}
}
