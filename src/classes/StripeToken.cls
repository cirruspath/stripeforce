global class StripeToken {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/tokens';

	global Integer created;
	global Boolean used;
	global StripeCard card;
	global String stripeCurrency;
	global String stripeObject;
	global Boolean livemode;
	global String id;
	global Integer amount;
	global StripeError error;

	global static StripeToken getToken(String token) {
		//if (Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new MockHttpResponse(testData_getToken, test_StatusCode));
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeToken.SERVICE_URL+'/'+token);
		http.setMethod('GET');
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		String response;
		Integer statusCode;
		Http con = new Http();
		HttpResponse hs = new HttpResponse();
		
		if (!Test.isRunningTest()) {
			try {
				hs = con.send(http);
			} catch (CalloutException e) {
				return null;
			}
		} else {
			hs.setBody(testData_getToken);
			hs.setStatusCode(test_statusCode);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		if (statusCode == 200) {
			try {
				StripeToken o = StripeToken.parse(response);
				return o;
			} catch (System.JSONException e) {
				return null;
			}
		} else {
			return null;
		}
	}
	
	private static Integer test_StatusCode = 200;
	private static testMethod void test_getToken_200() {
		Test.startTest();
		StripeToken token = getToken('tok_abcdefghijklmn');
		System.assertEquals('tok_0mUVL0s0kaJ4eg', token.id);
		Test.stopTest();
	}
	
	private static testMethod void test_getToken_500() {
		test_StatusCode = 500;
		Test.startTest();
		StripeToken token = getToken('tok_0mUVL0s0kaJ4eg');
		System.assertEquals(null, token);
		Test.stopTest();
	}

	private static String testData_getToken {
		get {
			return '{"created": 1320357508,"used": false,"card": {"type": "Visa","country": "US","exp_month": 12,"fingerprint": "pmVir47Ti9dNLS50","exp_year": 2012,"last4": "4242","object": "card","id": "cc_WcJetKxhzIWKRT"},"currency": "usd","object": "token","livemode": false,"id": "tok_0mUVL0s0kaJ4eg","amount": 0}';
		}
	}
	
	public static StripeToken parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);
		System.debug(System.LoggingLevel.INFO, '\n**** '+json); 

		return (StripeToken) System.JSON.deserialize(json, StripeToken.class);
	}
	
	static testMethod void testParse() {
		StripeToken obj = parse(testData_getToken);
		System.assert(obj != null);
	}

	static testMethod void testParseError() {
		String json = '{'+
		'  \"error\": {'+
		'    \"message\": \"No such singleusecard: tok_AM9jAAwclVBlBJ\",'+
		'    \"param\": \"token\",'+
		'    \"type\": \"invalid_request_error\"'+
		'  }'+
		'}';
		StripeToken obj = parse(json);
		System.assert(obj != null);
	}
	
	private static testMethod void test() {
		new StripeToken();
	}
}