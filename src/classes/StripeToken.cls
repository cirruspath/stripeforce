global class StripeToken {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/tokens';

	global Integer created;
	global Boolean used;
	global StripeCard card;
	global String stripeCurrency; // deprecated
	global String stripeObject;
	global Boolean livemode;
	global String id;
	global Integer amount; // deprecated
	global StripeError error;

	global static StripeToken getToken(String token) {
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
			hs.setBody(StripeTokenTests.testData_getToken);
			hs.setStatusCode(StripeTokenTests.test_statusCode);
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
	

	public static StripeToken parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);
		System.debug(System.LoggingLevel.INFO, '\n**** '+json); 

		return (StripeToken) System.JSON.deserialize(json, StripeToken.class);
	}
	
}