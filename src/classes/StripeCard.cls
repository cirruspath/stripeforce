global class StripeCard {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/customers/';

	global String stripeType;
	global String country;
	global Integer exp_month;
	global String fingerprint;
	global Integer exp_year;
	global String last4;
	global String stripeObject;
	global String id;
	global String name;
	global StripeError error;
	global String customer_id;
	
	global Date expirationDate {
		get {
			Date d = Date.newInstance(this.exp_year, this.exp_month, Date.daysInMonth(this.exp_year, this.exp_month));
			return d;
		}
	}

	global static StripeCard create(String customerId, String token) {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(SERVICE_URL + customerId + '/cards');
		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Map<String, String> payload = new Map<String, String>{
			'card' => token
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
			} catch (CalloutException e) {
				return null;
			}
		} else {
			hs.setBody(StripeCardTests.testData_getCard);
			hs.setStatusCode(200);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		
		try {
			StripeCard o = StripeCard.parse(response);
			System.debug(System.LoggingLevel.INFO, '\n**** StripeCard object: '+o); 
			return o;
		} catch (System.JSONException e) {
			System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
			return null;
		}
	}

	public static StripeCard parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);

		return (StripeCard) System.JSON.deserialize(json, StripeCard.class);
	}
	
}