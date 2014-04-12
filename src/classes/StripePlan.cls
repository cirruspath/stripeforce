global class StripePlan {
	global String id;
	global String name;
	global String statement_description;
	global String interval; // 'week', 'month' or 'year'
	global Integer created;
	global Integer amount;
	global String stripeCurrency;
	global Integer interval_count;
	global Integer trial_period_days;
	global Map<String, String> metadata;

	private static final String SERVICE_URL = 'https://api.stripe.com/v1/plans';

	public static StripePlan getPlan(String planId) {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripePlan.SERVICE_URL+'/'+planId);
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
			hs.setBody(StripePlanTests.testData_getPlan);
			hs.setStatusCode(200);
		}
		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		
		try {
			StripePlan o = StripePlan.parse(response);
			System.debug(System.LoggingLevel.INFO, '\n**** Stripe Plan: '+o); 
			return o;
		} catch (System.JSONException e) {
			return null;
		}
	}

	public static List<StripePlan> getPlans() {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripePlan.SERVICE_URL + '?limit=100');
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
			hs.setBody(StripePlanTests.testData_getPlanList);
			hs.setStatusCode(200);
		}
		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		
		try {
			StripePlanList o = StripePlan.parseList(response);
			System.debug(System.LoggingLevel.INFO, '\n**** Stripe Plans: '+o); 
			return o.stripeData;
		} catch (System.JSONException e) {
			return null;
		}
	}

	public static StripePlan parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);
		return (StripePlan) System.JSON.deserialize(json, StripePlan.class);
	}

	public static StripePlanList parseList(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);
		return (StripePlanList) System.JSON.deserialize(json, StripePlanList.class);
	}
	
}