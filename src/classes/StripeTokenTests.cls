@isTest
public class StripeTokenTests {

	private static testMethod void test_getToken() {
		Test.startTest();
		StripeToken token = StripeToken.getToken('tok_abcdefghijklmn');
		System.assertEquals('tok_0mUVL0s0kaJ4eg', token.id);
		Test.stopTest();
	}

	public static String testData_getToken {
		get {
			return '{"created": 1320357508,"used": false,"card": {"type": "Visa","country": "US","exp_month": 12,"fingerprint": "pmVir47Ti9dNLS50","exp_year": 2012,"last4": "4242","object": "card","id": "cc_WcJetKxhzIWKRT"},"currency": "usd","object": "token","livemode": false,"id": "tok_0mUVL0s0kaJ4eg","amount": 0}';
		}
	}
	
	static testMethod void testParse() {
		StripeToken obj = StripeToken.parse(testData_getToken);
		System.assert(obj != null);
	}

	private static testMethod void testParseError() {
		String json = '{'+
		'  "error": {'+
		'    "message": "No such singleusecard: tok_AM9jAAwclVBlBJ",'+
		'    "param": "token",'+
		'    "type": "invalid_request_error"'+
		'  }'+
		'}';
		StripeToken obj = StripeToken.parse(json);
		System.assert(obj != null);
	}
	
	private static testMethod void test() {
		new StripeToken();
	}

}