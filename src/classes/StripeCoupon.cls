global class StripeCoupon {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/coupons';

	global String id;
	global Integer percent_off;
	global Integer amount_off;
	global String stripeCurrency;
	global String stripeObject;
	global Boolean livemode;
	global String duration;
	global Integer redeem_by;
	global Integer max_redemptions;
	global Integer times_redeemed;
	global Integer duration_in_months;
	
	private static Integer test_StatusCode;

	global static StripeCoupon getCoupon(String couponId) {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeCoupon.SERVICE_URL+'/'+couponId);
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
//			hs.setBody(StripeCouponTests.testData);
			hs.setStatusCode(test_statusCode);
		}
		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		try {
			StripeCoupon o = StripeCoupon.parse(response);
			return o;
		} catch (System.JSONException e) {
			return null;
		}
	}
	
	/*
	 * duration must be: 'forever', 'once', or 'repeating'
	 */
	global static StripeCoupon create(String couponId, String duration, Integer amount_off, Integer max_redemptions) {
		HttpRequest http = new HttpRequest();
		
		if (couponId == null) 
			http.setEndpoint(StripeCoupon.SERVICE_URL);
		else 
			http.setEndpoint(StripeCoupon.SERVICE_URL+'/'+couponId);

		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Map<String, String> payload = new Map<String, String>{
			'id' => couponId,
			'duration' => duration,
			'amount_off' => String.valueOf(amount_off),
			'max_redemptions' => String.valueOf(max_redemptions)
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
//			hs.setBody(StripeCouponTests.testData);
			hs.setStatusCode(test_statusCode);
		}
		
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		try {
			StripeCoupon new_coupon = StripeCoupon.parse(hs.getBody());
			return new_coupon;
		} catch (System.JSONException e) {
			return null;
		}		
	}

	global static StripeCoupon parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);
		return (StripeCoupon) System.JSON.deserialize(json, StripeCoupon.class);
	}
	
}