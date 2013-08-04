public class StripeCoupon {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/coupons';

	public String id;
	public Integer percent_off;
	public Integer amount_off;
	public String stripeCurrency;
	public String stripeObject;
	public Boolean livemode;
	public String duration;
	public Integer redeem_by;
	public Integer max_redemptions;
	public Integer times_redeemed;
	public Integer duration_in_months;
	
	private static Integer test_StatusCode;

	public static StripeCoupon getCoupon(String couponId) {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeCoupon.SERVICE_URL+'/'+couponId);
		http.setMethod('GET');
		Blob headerValue = Blob.valueOf(Stripe.ApiKey + ':');
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
			StripeCoupon o = StripeCoupon.parse(response);
			return o;
		} catch (System.JSONException e) {
			return null;
		}
	}
	
	/*
	 * duration must be: 'forever', 'once', or 'repeating'
	 */
	public static StripeCoupon create(String couponId, String duration, Integer amount_off, Integer max_redemptions) {
		HttpRequest http = new HttpRequest();
		
		if (couponId == null) 
			http.setEndpoint(StripeCoupon.SERVICE_URL);
		else 
			http.setEndpoint(StripeCoupon.SERVICE_URL+'/'+couponId);

		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(Stripe.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Map<String, String> payload = new Map<String, String>{
			'id' => couponId,
			'duration' => duration,
			'amount_off' => String.valueOf(amount_off),
			'max_redemptions' => String.valueOf(max_redemptions)
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
			StripeCoupon new_coupon = StripeCoupon.parse(hs.getBody());
			return new_coupon;
		} catch (System.JSONException e) {
			return null;
		}		
	}

	public static StripeCoupon parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);
		return (StripeCoupon) System.JSON.deserialize(json, StripeCoupon.class);
	}
	
	private static String testData {
		get {
			String json = '{'+
			'  \"id\": \"25OFF\",'+
			'  \"percent_off\": 25,'+
			'  \"amount_off\": 5,'+
			'  \"currency\": \"usd\",'+
			'  \"object\": \"coupon\",'+
			'  \"livemode\": false,'+
			'  \"duration\": \"repeating\",'+
			'  \"redeem_by\": null,'+
			'  \"max_redemptions\": 3,'+
			'  \"times_redeemed\": 0,'+
			'  \"duration_in_months\": 3'+
			'}';
			return json;
		}
	}
	
	static testMethod void testParse() {
		StripeCoupon obj = parse(testData);
		System.assert(obj != null);
	}
}