@isTest
public class StripeCouponTests {

	private static String testData {
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
	
	static testMethod void testParse() {
		StripeCoupon obj = StripeCoupon.parse(testData);
		System.assert(obj != null);
	}


}