global class StripeCustomer {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/customers';
	global Integer created;
	global Integer account_balance;
	global Next_recurring_charge next_recurring_charge;
	global String description;
	global StripeError error;
	global Boolean livemode;
	global StripeSubscription subscription;
	global String token;
	global String id;

	// This has changed in the 2013-07-05 API
	// https://stripe.com/docs/upgrades#2013-07-05
	global StripeCard active_card;
	
	global class Next_recurring_charge {  // deprecated
		global String stripeDate;
		global Integer amount;
	}

	// static cache to eliminate multiple lookups in same transaction
	private static Map<String, StripeCustomer> mCustomers = new Map<String, StripeCustomer>();
	private static Integer test_StatusCode = 200;

	global static StripeCustomer getCustomer(String customerId) {
		//if (Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new MockHttpResponse(testData_getCustomer, test_StatusCode));

		if (mCustomers.containsKey(customerId)) {
			return mCustomers.get(customerId);
		}
		
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId);
		http.setMethod('GET');
		Blob headerValue = Blob.valueOf(API.ApiKey + ':');
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
			hs.setBody(testData);
			hs.setStatusCode(test_statusCode);
		}
		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		try {
			StripeCustomer o = StripeCustomer.parse(response);
//			if (o.error != null) throw new StripeException(o.error);
			mCustomers.put(customerId, o);
			return o;
		} catch (System.JSONException e) {
			return null;
		}
	}
	
	global static StripeCustomer create(String token, String description) {
		return updateCustomer(null, token, description);
	}
	
	global static StripeCustomer create(String token, String plan, String description) {
		return updateCustomer(null, token, plan, description);
	}
	
	// Updates OR Creates customer
	global static StripeCustomer updateCustomer(String customerId, String token, String description) {
		return updateCustomer(customerId, token, null, description);
	}
	
	global static StripeCustomer updateCustomer(String customerId, String token, String plan, String description) {
		HttpRequest http = new HttpRequest();
		
		if (customerId == null) 
			http.setEndpoint(StripeCustomer.SERVICE_URL);
		else 
			http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId);

		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(API.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Map<String, String> payload = new Map<String, String>{
			'card' => token,
			'description' => description
		};
		if (plan != null)	payload.put('plan', plan);

		http.setBody(Util.urlify(payload));
		System.debug(System.LoggingLevel.INFO, '\n**** REQUEST BODY:\n'+http.getBody()); 	
		
		String response;
		Integer statusCode;
		Http con = new Http();
		HttpResponse hs = new HttpResponse();
		
		if (!Test.isRunningTest()) {
			try {
				hs = con.send(http);
				system.debug('#### [1]'+ hs.getBody());
				
			} catch (CalloutException e) {
				return null;
			}
		} else {
			hs.setBody(testData);
			hs.setStatusCode(test_statusCode);
		}
		
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		try {
			StripeCustomer new_customer = StripeCustomer.parse(hs.getBody());
			if (new_customer.error != null) throw new StripeException(new_customer.error);

			System.debug(System.LoggingLevel.INFO, '\n**** Customer: '+new_customer); 
			mCustomers.put(new_customer.id, new_customer);
			return new_customer;
		} catch (System.JSONException e) {
			return null;
		}
	}

	global static StripeCustomer grantCoupon(String customerId, StripeCoupon coupon) {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId);

		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(API.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Map<String, String> payload = new Map<String, String>{
			'coupon' => coupon.id
		};

		http.setBody(Util.urlify(payload));
		System.debug(System.LoggingLevel.INFO, '\n**** REQUEST BODY:\n'+http.getBody()); 	
		
		String response;
		Integer statusCode;
		Http con = new Http();
		HttpResponse hs = new HttpResponse();
		
		if (!Test.isRunningTest()) {
			try {
				hs = con.send(http);
				system.debug('#### [1]'+ hs.getBody());
				
			} catch (CalloutException e) {
				return null;
			}
		} else {
			hs.setBody(testData);
			hs.setStatusCode(test_statusCode);
		}
		
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		try {
			StripeCustomer new_customer = StripeCustomer.parse(hs.getBody());
			return new_customer;
		} catch (System.JSONException e) {
			return null;
		}		
	}

	global static StripeSubscription cancelSubscription(String customerId) {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId+'/subscription');
		http.setMethod('DELETE');
		Blob headerValue = Blob.valueOf(API.ApiKey + ':');
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
			hs.setBody(testData_cancelSubscription);
			hs.setStatusCode(test_statusCode);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		
		try {
			StripeSubscription sub = StripeSubscription.parse(response);
			return sub;
		} catch (System.JSONException e) {
			return null;
		}
	}

	@future (callout=true)
	global static void cancelSubscription_future(String customerId) {
		cancelSubscription(customerId);
	}

	global static StripeSubscription updateSubscription(String customerId, String plan) {
		return updateSubscription(customerId, plan, null);
	}

	global static StripeSubscription updateSubscription(String customerId, String plan, Date trial_end) {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId+'/subscription');
		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(API.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Map<String, String> payload = new Map<String, String>{
			'plan' => plan
		};

		if (trial_end != null) {
			DateTime dt = DateTime.newInstanceGmt(trial_end, Time.newInstance(0, 0, 0, 0));
			Integer utc = (dt.getTime() / 1000).intValue();
			payload.put('trial_end', String.valueOf(utc));
		}
		
		http.setBody(Util.urlify(payload));	
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
			hs.setBody(testData_updateSubscription);
			hs.setStatusCode(test_statusCode);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		
		try {
			StripeSubscription o = StripeSubscription.parse(response);
			return o;
		} catch (System.JSONException e) {
			return null;
		}
	}
	
	global static List<StripeCustomer> getCustomers(Integer pageSize, Integer offset) {
		//if (Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new MockHttpResponse(testData_getCustomers, test_StatusCode));

		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeCustomer.SERVICE_URL+'?count='+pageSize+'&offset='+offset);
		http.setMethod('GET');
		Blob headerValue = Blob.valueOf(API.ApiKey + ':');
		String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		String t_json;
		Integer statusCode;
		
		List<StripeCustomer> customers = new List<StripeCustomer>();
		Http con = new Http();
		HttpResponse hs = new HttpResponse();
		
		if (!Test.isRunningTest()) {
			try {
				hs = con.send(http);
			} catch (CalloutException e) {
				return null;
			}
		} else {
			hs.setBody(testData_getCustomers);
			hs.setStatusCode(test_statusCode);
		}

		t_json = hs.getBody();
		statusCode = hs.getStatusCode();
		
		try {
			t_json = StripeUtil.cleanJson(t_json);
			t_json = t_json.substring(t_json.indexOf('['), t_json.lastIndexOf(']')+1);
			customers = (List<StripeCustomer>) JSON.deserialize(t_json, List<StripeCustomer>.class);
			return customers;
			
		} catch (System.JSONException e) {
			return null;
		}
	}

	public static StripeCustomer parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);
		return (StripeCustomer) System.JSON.deserialize(json, StripeCustomer.class);
	}

	private static String testData_next_recurring_charge {
		get {
			DateTime d = DateTime.now().addYears(1);
			return d.format('yyyy-MM-dd');
		}
	}

	private static String testData_currentPeriodStart {
		get {
			DateTime d = DateTime.now();
			Integer i = (d.getTime() / 1000).intValue();
			return String.valueOf(i);
		}
	}
	
	private static String testData_currentPeriodEnd {
		get {
			DateTime d = DateTime.now().addYears(1);
			Integer i = (d.getTime() / 1000).intValue();
			return String.valueOf(i);
		}
	}
	
	private static String testData_getCustomer {
		get {
			// customer id cus_0mKFBsDi6XS2LB
			return '{"created": 1332963923,"account_balance": 0,"next_recurring_charge": {"date": "'+testData_next_recurring_charge+'","amount": 0},"description": "Cirrus Consulting Group","object": "customer","livemode": false,"subscription": {"status": "active","start": '+testData_currentPeriodStart+',"current_period_start": '+testData_currentPeriodStart+',"object": "subscription","plan": {"currency": "usd","object": "plan","interval": "month","livemode": false,"name": "Cirrus Insight Monthly","id": "CI_MONTHLY","amount": 0},"current_period_end": '+testData_currentPeriodEnd+',"customer": "cus_0mKFBsDi6XS2LB"},"id": "cus_0mKFBsDi6XS2LB","active_card": {"type": "Visa","country": "US","exp_month": 12,"fingerprint": "pmVir47Ti9dNLS50","exp_year": 2012,"last4": "4242","object": "card","id": "cc_huV3226cXd1OHf","cvc_check": "pass"}}';
		}
	}
	
	private static String testData_cancelSubscription {
		get {
			return '{"object": "subscription", "status": "active", "current_period_start": '+testData_currentPeriodStart+', "start": '+testData_currentPeriodStart+', "current_period_end": '+testData_currentPeriodEnd+', "plan": { "object": "plan", "interval": "month", "currency": "usd", "amount": 2499, "livemode": false, "name": "My Plan", "id": "my_plan5" }, "customer": "cus_MLJBxWoSParcrX"}';
		}
	}
	
	private static String testData_updateSubscription {
		get {
			return '{"status": "active","start": '+testData_currentPeriodStart+',"plan": {"currency": "usd","object": "plan","interval": "month","livemode": false,"name": "My Plan","id": "my_plan5","amount": 2499},"object": "subscription","current_period_start": '+testData_currentPeriodStart+',"current_period_end": '+testData_currentPeriodEnd+',"customer": "cus_MLJBxWoSParcrX"}';
		}
	}
	
	private static String testData_getCustomers {
		get {
			return '{ "count": 44, "data": [ { "next_recurring_charge": { "date": "'+testData_next_recurring_charge+'", "amount": 0 }, "created": 1332963923, "object": "customer", "description": "Cirrus Consulting Group", "account_balance": 0, "subscription": { "status": "active", "current_period_start": '+testData_currentPeriodStart+', "start": '+testData_currentPeriodStart+', "object": "subscription", "plan": { "currency": "usd", "object": "plan", "amount": 0, "interval": "month", "livemode": false, "name": "Cirrus Insight Monthly", "id": "CI_MONTHLY" }, "current_period_end": '+testData_currentPeriodEnd+', "customer": "cus_0mKFBsDi6XS2LB" }, "livemode": false, "id": "cus_0mKFBsDi6XS2LB", "active_card": { "type": "Visa", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "exp_month": 12, "last4": "4242", "cvc_check": "pass", "exp_year": 2012 } }, { "next_recurring_charge": { "date": "2012-09-28", "amount": 0 }, "created": 1332963773, "object": "customer", "description": "Cirrus Consulting Group", "account_balance": 0, "subscription": { "status": "active", "current_period_start": 1346182975, "start": 1332963775, "object": "subscription", "plan": { "currency": "usd", "object": "plan", "amount": 0, "interval": "month", "livemode": false, "name": "Cirrus Insight Monthly", "id": "CI_MONTHLY" }, "current_period_end": 1348861375, "customer": "cus_WoEUsq5xrvkTMC" }, "livemode": false, "id": "cus_WoEUsq5xrvkTMC", "active_card": { "type": "Visa", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "exp_month": 12, "last4": "4242", "cvc_check": "pass", "exp_year": 2012 } }, { "next_recurring_charge": { "date": "2012-09-28", "amount": 0 }, "created": 1332963575, "object": "customer", "description": "Cirrus Consulting Group", "account_balance": 0, "subscription": { "status": "active", "current_period_start": 1346182776, "start": 1332963576, "object": "subscription", "plan": { "currency": "usd", "object": "plan", "amount": 0, "interval": "month", "livemode": false, "name": "Cirrus Insight Monthly", "id": "CI_MONTHLY" }, "current_period_end": 1348861176, "customer": "cus_JgLR1KUS0ir5iW" }, "livemode": false, "id": "cus_JgLR1KUS0ir5iW", "active_card": { "type": "Visa", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "exp_month": 12, "last4": "4242", "cvc_check": "pass", "exp_year": 2012 } }, { "next_recurring_charge": { "date": "'+testData_next_recurring_charge+'", "amount": 0 }, "created": 1332963282, "object": "customer", "description": "Cirrus Consulting Group", "account_balance": 0, "subscription": { "status": "active", "current_period_start": 1346182483, "start": 1332963283, "object": "subscription", "plan": { "currency": "usd", "object": "plan", "amount": 0, "interval": "month", "livemode": false, "name": "Cirrus Insight Monthly", "id": "CI_MONTHLY" }, "current_period_end": 1348860883, "customer": "cus_2MEr9Lraf1mnZH" }, "livemode": false, "id": "cus_2MEr9Lraf1mnZH", "active_card": { "type": "Visa", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "exp_month": 12, "last4": "4242", "cvc_check": "pass", "exp_year": 2012 } }, { "created": 1325799745, "object": "customer", "account_balance": 0, "livemode": false, "id": "cus_uxec2nBO465s03", "active_card": { "address_line1": "", "type": "Visa", "address_zip_check": "pass", "address_line2": "", "address_line1_check": "pass", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "address_zip": "92653", "address_state": "California", "name": "Cirruspath, LLC", "exp_month": 10, "last4": "4242", "cvc_check": "pass", "address_country": "", "exp_year": 2015 } }, { "created": 1325799712, "object": "customer", "account_balance": 0, "livemode": false, "id": "cus_dkcWtHbvBN96rd", "active_card": { "address_line1": "", "type": "Visa", "address_zip_check": "pass", "address_line2": "", "address_line1_check": "pass", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "address_zip": "92653", "address_state": "California", "name": "Cirruspath, LLC", "exp_month": 10, "last4": "4242", "cvc_check": "pass", "address_country": "", "exp_year": 2015 } }, { "created": 1324201094, "object": "customer", "account_balance": 0, "livemode": false, "id": "cus_VlXUjgykF1KYx6", "active_card": { "address_line1": "", "type": "Visa", "address_zip_check": "pass", "address_line2": "", "address_line1_check": "pass", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "address_zip": "", "address_state": "", "name": "Acme Co", "exp_month": 10, "last4": "4242", "cvc_check": "pass", "address_country": "", "exp_year": 2015 } } ] }';
		}
	}
	
	private static String testData_updateCustomer {
		get {
			// customer id cus_0mKFBsDi6XS2LB
			return '{'+
				'  \"account_balance\": 0,'+
				'  \"created\": 1353535454,'+
				'  \"description\": \"TEST 123\",'+
				'  \"id\": \"cus_'+Util.generateRandomString(14)+'\",'+
				'  \"livemode\": false,'+
				'  \"object\": \"customer\",'+
				'  \"active_card\": {'+
				'    \"address_city\": null,'+
				'    \"country\": \"US\",'+
				'    \"cvc_check\": \"pass\",'+
				'    \"exp_month\": 12,'+
				'    \"exp_year\": 2012,'+
				'    \"fingerprint\": \"pmVir47Ti9dNLS50\",'+
				'    \"last4\": \"1881\",'+
				'    \"object\": \"card\",'+
				'    \"type\": \"Visa\"'+
				'  },'+
				'  \"next_recurring_charge\": {'+
				'    \"amount\": 0,'+
				'    \"date\": \"'+testData_next_recurring_charge+'\"'+
				'  },'+
				'  \"subscription\": {'+
				'    \"current_period_end\": '+testData_currentPeriodEnd+','+
				'    \"current_period_start\": '+testData_currentPeriodStart+','+
				'    \"customer\": \"cus_0mKFBsDi6XS2LB\",'+
				'    \"object\": \"subscription\",'+
				'    \"quantity\": 1,'+
				'    \"start\": '+testData_currentPeriodStart+','+
				'    \"status\": \"active\",'+
				'    \"plan\": {'+
				'      \"amount\": 0,'+
				'      \"currency\": \"usd\",'+
				'      \"id\": \"CI_ANNUALLY\",'+
				'      \"interval\": \"year\",'+
				'      \"interval_count\": 1,'+
				'      \"livemode\": false,'+
				'      \"name\": \"Cirrus Insight Annually\",'+
				'      \"object\": \"plan\"'+
				'    }'+
				'  }'+
				'}';
		}
	}
	
	public static String testData_error {
		get {
			return '{'+
		'  \"error\": {'+
		'    \"type\": \"invalid_request_error\",'+
		'    \"message\": \"No such customer: cus_0mKFBsDi6XS2LB\"'+
		'  }'+
		'}';
		}
	}

	private static testMethod void testParse() {
		String json = testData_updateCustomer;
		StripeCustomer obj = parse(json);
		System.assert(obj != null);
		System.assertEquals(Date.newInstance(2012,12,31), obj.active_card.expirationDate);
	}

	private static testMethod void testParseError() {
		StripeCustomer obj = parse(testData_error);
		System.assert(obj != null);
	}
	
	private static testMethod void test_getCustomers_200() {
		Test.startTest();
		List<StripeCustomer> customers = getCustomers(0, 0);
		System.assertEquals(7, customers.size());
		Test.stopTest();
	}
	
	private static testMethod void test_updateSubscription_200() {
		Test.startTest();
		StripeSubscription sub = updateSubscription('cus_abcdefghijklmn', 'asdf');
		System.assertEquals('active', sub.status);
		Test.stopTest();
	}

	private static testMethod void test_cancelSubscription_200() {
		Test.startTest();
		StripeSubscription sub = cancelSubscription('cus_abcdefghijklmn');
		cancelSubscription_future('cus_abcdefghijklmn');
		System.debug(System.LoggingLevel.INFO, '\n**** sub2: '+sub); 
		System.assertEquals('active', sub.status);
		Test.stopTest();
	}

	private static testMethod void test_getCustomer_200() {
		Test.startTest();
		testData = testData_getCustomer;
		StripeCustomer customer1 = getCustomer('cus_abcdefghijklmn');
		System.assertNotEquals(null, customer1.id);
		Test.stopTest();
	}

	private static testMethod void test_getCustomer_error() {
		Test.startTest();
		StripeCustomer.testData = StripeCustomer.testData_error;
		StripeCustomer customer1 = StripeCustomer.getCustomer('cus_abcdefghijklmn');
		System.assertNotEquals(null, customer1.error.message);
		System.assertEquals('invalid_request_error', customer1.error.stripeType);
		Test.stopTest();
	}

	private static testMethod void test_create_200() {
		Test.startTest();
		testData = testData_getCustomer;
		StripeCustomer customer1 = create('tok_abcdefghijklmn', 'description');
		System.assertNotEquals(null, customer1.id);
		StripeCustomer customer2 = create('tok_abcdefghijklmn', 'plan', 'description');
		System.assertNotEquals(null, customer2.id);
		StripeCustomer customer3 = updateCustomer('cus_abcdefghijklmn', 'tok_abcdefghijklmn', 'description');
		System.assertNotEquals(null, customer3.id);
		StripeCustomer customer4 = updateCustomer('cus_abcdefghijklmn', 'tok_abcdefghijklmn', 'plan', 'description');
		System.assertNotEquals(null, customer4.id);
		Test.stopTest();
	}
	
	public static String testData {
		get {
			return testData == null ? testData_getCustomer : testData;
		}
		set;
	}
	
	private static testMethod void test() {
		new StripeCustomer();
		new Next_recurring_charge();
		
		System.assertNotEquals(null, testData_getCustomer);
		System.assertNotEquals(null, testData_getCustomers);
		System.assertNotEquals(null, testData_cancelSubscription);
		System.assertNotEquals(null, testData_updateSubscription);
		System.assertNotEquals(null, testData_updateCustomer);
	}
}