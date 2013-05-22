global class StripeCharge {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/charges';

	global Integer amount;
	global Integer created;
	global String stripeCurrency;
	global String customer;
	global String description;
	global Boolean disputed;
	global Integer fee;
	global String id;
	global Boolean livemode;
	global String stripeObject;
	global Boolean paid;
	global Boolean refunded;
	global Integer amount_refunded;
	global StripeCard card;
	global List<Fee_details> fee_details;
	global StripeError error;
	global String invoice;
	global String failure_message;

	global class Fee_details {
		global String stripeType;
		global String description;
		global Object application;
		global Integer amount;
		global String stripeCurrency;
	}

	global static StripeCharge getCharge(String chargeId) {
		//if (Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new MockHttpResponse(testData_getCharge, test_StatusCode));
		HttpRequest http = new HttpRequest();
		http.setEndpoint(SERVICE_URL+'/'+chargeId);
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
			hs.setBody(testData_getCharge);
			hs.setStatusCode(test_statusCode);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		
		try {
			StripeCharge o = StripeCharge.parse(response);
			return o;
		} catch (System.JSONException e) {
			System.debug(System.LoggingLevel.INFO, '\n**** '+e); 
			return null;
		}
	}
	
	global static StripeCharge create(String customerId, Decimal amount) {
		return StripeCharge.create(customerId, amount, null);
	}
	
	global static StripeCharge create(String customerId, Decimal amount, String description) {
		//if (Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new MockHttpResponse(testData_createCharge, test_StatusCode));

		HttpRequest http = new HttpRequest();
		http.setEndpoint(SERVICE_URL);
		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Integer amount_int = (amount * 100).intValue();
		Map<String, String> payload = new Map<String, String>{
			'customer' => customerId,
			'amount' => String.valueOf(amount_int),
			'currency' => 'usd'
		};
		if (description != null) {
			payload.put('description', description);
		}
		http.setBody(StripeUtil.urlify(payload));
		System.debug(System.LoggingLevel.INFO, '\n**** REQUEST BODY:\n'+http.getBody()); 	
		
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
			hs.setBody(testData_createCharge);
			hs.setStatusCode(test_statusCode);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		try {
			StripeCharge o = StripeCharge.parse(response);
			System.debug(System.LoggingLevel.INFO, '\n**** StripeCharge object: '+o); 
			return o;
		} catch (System.JSONException e) {
			System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
			return null;
		}
	}

	public static StripeCharge parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = json.replaceAll('"object":', '"stripeObject":');
		json = json.replaceAll('"type":', '"stripeType":');
		json = json.replaceAll('"currency":', '"stripecurrency":');

		return (StripeCharge) System.JSON.deserialize(json, StripeCharge.class);
	}
	
	private static Integer test_StatusCode = 200;

	private static String testData_getCharge {
		get {
			return '{"amount": 400, "invoice":"in_abcdefghijk", "created": 1341900078, "currency": "usd", "description": "Charge for rhuff@cirruspath.com", "disputed": false, "fee": 42, "id": "ch_GFAX3OIYUwQYU7", "livemode": false, "object": "charge", "paid": true, "refunded": false, "card": { "country": "US", "cvc_check": "pass", "exp_month": 12, "exp_year": 2012, "fingerprint": "pmVir47Ti9dNLS50", "last4": "4242", "object": "card", "type": "Visa" }, "fee_details": [ { "type": "stripe_fee", "description": "Stripe processing fees", "application": null, "amount": 42, "currency": "usd"}]}';
		}
	}
	
	private static string testData_createCharge {
		get {
			return '{"amount": 400, "created": 1341900078, "currency": "usd", "description": "Charge for rhuff@cirruspath.com", "disputed": false, "fee": 42, "id": "ch_GFAX3OIYUwQYU7", "livemode": false, "object": "charge", "paid": true, "refunded": false, "card": { "country": "US", "cvc_check": "pass", "exp_month": 12, "exp_year": 2012, "fingerprint": "pmVir47Ti9dNLS50", "last4": "4242", "object": "card", "type": "Visa" }, "fee_details": [ { "type": "stripe_fee", "description": "Stripe processing fees", "application": null, "amount": 42, "currency": "usd"}]}';
		}
	}
	
	private static string testData_error {
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
		StripeCharge ch = create('ch_abcdefghijklmn', 400);
		System.assertEquals('ch_GFAX3OIYUwQYU7', ch.id);
		Test.stopTest();
	}

	private static testMethod void test_getCharge() {
		Test.startTest();
		StripeCharge ch = getCharge('ch_abcdefghijklmn');
		System.assertEquals('ch_GFAX3OIYUwQYU7', ch.id);
		Test.stopTest();
	}

	static testMethod void testParse() {
		StripeCharge obj = parse(testData_createCharge);
		System.assert(obj != null);
	}

	static testMethod void testParseError() {
		StripeCharge obj = parse(testData_error);
		System.assert(obj != null);
		System.assert(obj.error != null);
		System.assertEquals('Your card number is incorrect', obj.error.message);
	}
	
	private static testMethod void test() {
		new StripeCharge();
		new Fee_details();
	}
}