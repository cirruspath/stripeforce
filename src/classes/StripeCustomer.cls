global class StripeCustomer {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/customers';
	global Integer created;
	global Integer account_balance;
	global String description;
	global StripeError error;
	global Boolean livemode;
	global StripeSubscription subscription;
	global String token;
	global String id;
	
	global CardList cards;
	global String default_card;
	
	global class CardList {
		global Integer count;
		global String url;
		global List<StripeCard> stripeData;
	}

	// static cache to eliminate multiple lookups in same transaction
	private static Map<String, StripeCustomer> mCustomers = new Map<String, StripeCustomer>();

	global static StripeCustomer getCustomer(String customerId) {
		if (mCustomers.containsKey(customerId)) {
			return mCustomers.get(customerId);
		}
		
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId);
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
			hs.setBody(StripeCustomerTests.testData);
			hs.setStatusCode(StripeCustomerTests.test_statusCode);
		}
		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		try {
			StripeCustomer o = StripeCustomer.parse(response);
			System.debug(System.LoggingLevel.INFO, '\n**** Stripe Customer: '+o); 
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
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Map<String, String> payload = new Map<String, String>{
			'card' => token,
			'description' => description
		};
		if (plan != null)	payload.put('plan', plan);

		http.setBody(StripeUtil.urlify(payload));
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
			hs.setBody(StripeCustomerTests.testData);
			hs.setStatusCode(StripeCustomerTests.test_statusCode);
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
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Map<String, String> payload = new Map<String, String>{
			'coupon' => coupon.id
		};

		http.setBody(StripeUtil.urlify(payload));
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
			hs.setBody(StripeCustomerTests.testData);
			hs.setStatusCode(StripeCustomerTests.test_statusCode);
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
			hs.setBody(StripeCustomerTests.testData_cancelSubscription);
			hs.setStatusCode(StripeCustomerTests.test_statusCode);
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
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
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
			hs.setBody(StripeCustomerTests.testData_updateSubscription);
			hs.setStatusCode(StripeCustomerTests.test_statusCode);
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
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeCustomer.SERVICE_URL+'?count='+pageSize+'&offset='+offset);
		http.setMethod('GET');
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
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
			hs.setBody(StripeCustomerTests.testData_getCustomers);
			hs.setStatusCode(StripeCustomerTests.test_statusCode);
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
	
	public StripeCard getDefaultCard() {
		for (StripeCard card : this.cards.stripeData) {
			if (card.id == this.default_card) {
				return card;
			}
		}

		return null;
	}

	public static StripeCustomer parse(String json) {
		json = StripeUtil.cleanJson(json);
		return (StripeCustomer) System.JSON.deserialize(json, StripeCustomer.class);
	}

}