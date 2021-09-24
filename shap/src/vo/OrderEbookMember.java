package vo;

// 조인 쿼리문의 결과를 담기 위한 클래스
// 클래스 안에 클래스를 담는 것은 객체 지향이기에 틀린 것이 아니지만 정답 또한 아니다.
// 정답은 상황에 따라 항상 변한다.
// 고착되지 말 것!
public class OrderEbookMember {
	
	private Order order;
	private Ebook ebook;
	private Member member;
	
	public Order getOrder() {
		return order;
	}
	public void setOrder(Order order) {
		this.order = order;
	}
	public Ebook getEbook() {
		return ebook;
	}
	public void setEbook(Ebook ebook) {
		this.ebook = ebook;
	}
	public Member getMember() {
		return member;
	}
	public void setMember(Member member) {
		this.member = member;
	}
	
}