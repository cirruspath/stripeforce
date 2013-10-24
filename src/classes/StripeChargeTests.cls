@isTest
public class StripeChargeTests {

	public static String testData_getCharge {
		get {
			return '{"amount": 400, "invoice_id":"in_abcdefghijk", "created": 1341900078, "currency": "usd", "description": "Charge for rhuff@cirruspath.com", "disputed": false, "fee": 42, "id": "ch_GFAX3OIYUwQYU7", "livemode": false, "object": "charge", "paid": true, "refunded": false, "card": { "country": "US", "cvc_check": "pass", "exp_month": 12, "exp_year": 2012, "fingerprint": "pmVir47Ti9dNLS50", "last4": "4242", "object": "card", "type": "Visa" }, "fee_details": [ { "type": "stripe_fee", "description": "Stripe processing fees", "application": null, "amount": 42, "currency": "usd"}]}';
		}
	}
	
	public static string testData_createCharge {
		get {
			return '{"amount": 400, "created": 1341900078, "currency": "usd", "description": "Charge for rhuff@cirruspath.com", "disputed": false, "fee": 42, "id": "ch_GFAX3OIYUwQYU7", "livemode": false, "object": "charge", "paid": true, "refunded": false, "card": { "country": "US", "cvc_check": "pass", "exp_month": 12, "exp_year": 2012, "fingerprint": "pmVir47Ti9dNLS50", "last4": "4242", "object": "card", "type": "Visa" }, "fee_details": [ { "type": "stripe_fee", "description": "Stripe processing fees", "application": null, "amount": 42, "currency": "usd"}]}';
		}
	}
	
	public static string testData_error {
		get {
			return '{'+
				'  \"error\": {'+
				'    \"code\": \"incorrect_number\",'+
				'    \"message\": \"Your card number is incorrect\",'+
				'    \"param\": \"number\",'+
				'    \"type\": \"card_error\"'+
				'  }'+
				'}';
		}
	}
	
	private static testMethod void test_createCharge() {
		Test.startTest();
		StripeCharge ch = StripeCharge.create('ch_abcdefghijklmn', 400);
		System.assertEquals('ch_GFAX3OIYUwQYU7', ch.id);
		Test.stopTest();
	}

	private static testMethod void test_getCharge() {
		Test.startTest();
		StripeCharge ch = StripeCharge.getCharge('ch_abcdefghijklmn');
		System.assertEquals('ch_GFAX3OIYUwQYU7', ch.id);
		Test.stopTest();
	}

	static testMethod void testParse() {
		StripeCharge obj = StripeCharge.parse(testData_createCharge);
		System.assert(obj != null);
	}

	static testMethod void testParseError() {
		StripeCharge obj = StripeCharge.parse(testData_error);
		System.assert(obj != null);
		System.assert(obj.error != null);
		System.assertEquals('Your card number is incorrect', obj.error.message);
	}
	
	private static testMethod void test() {
		new StripeCharge();
		new StripeCharge.Fee_details();
	}

}