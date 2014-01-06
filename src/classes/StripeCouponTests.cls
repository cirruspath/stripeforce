@isTest
public class StripeCouponTests {

	public static String testData {
		get {
			String json = '{'+
			'  \"id\": \"25OFF\",'+
			'  \"percent_off\": 25,'+
			'  \"amount_off\": 5,'+
			'  \"currency\": \"usd\",'+
			'  \"object\": \"coupon\",'+
			'  \"livemode\": false,'+
			'  \"duration\": \"repeating\",'+
			'  \"redeem_by\": null,'+
			'  \"max_redemptions\": 3,'+
			'  \"times_redeemed\": 0,'+
			'  \"duration_in_months\": 3'+
			'}';
			return json;
		}
	}
	
	private static testMethod void testParse() {
		StripeCoupon obj = StripeCoupon.parse(testData);
		System.assert(obj != null);
		new StripeCoupon();
	}
	
	private static testMethod void testGetCoupon() {
		StripeCoupon coupon = StripeCoupon.getCoupon('25OFF');
		System.assertEquals('25OFF', coupon.id);
		System.assertEquals(25, coupon.percent_off);
	}
	
	private static testMethod void testCreateCoupon() {
		StripeCoupon coupon = StripeCoupon.create('25OFF', 'once', 25, 3);
		System.assertEquals('25OFF', coupon.id);
		System.assertEquals(25, coupon.percent_off);		
	}
}