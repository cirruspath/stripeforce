global class StripeInvoice {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/invoices';
	private static final String ITEMS_SERVICE_URL = 'https://api.stripe.com/v1/invoiceitems';

	global Integer 	attempt_count;
	global Integer 	next_payment_attempt;
	global Integer 	total;
	global Boolean 	livemode;
	global Lines 	lines;
	global Integer 	amount_due;
	global Integer 	period_start;
	global Integer 	subtotal;
	global Boolean 	attempted;
	global Integer 	starting_balance;
	global Integer 	period_end;
	global String 	charge;
	global Integer 	stripeDate;
	global Integer 	ending_balance;
	global Object 	discount;
	global StripeCustomer 	customer;
	global String 	customer_id; // this will be set ONLY in the situation of the invoice-related webhooks, and the 'customer' will NOT be set
	global Boolean 	closed;
	global String 	stripeCurrency;
	global String 	id;
	global Boolean 	paid;
	global StripeError error;
	global Map<String, String> metadata;
	
	// This has changed in the 2012-10-26 API
	// https://stripe.com/docs/upgrades#2012-10-26
	global class Lines {
		global List<InvoiceItem> invoiceitems = new List<InvoiceItem>();
		global List<StripeSubscription> subscriptions = new List<StripeSubscription>();
	}

	global class InvoiceItem {
		global Boolean proration;
		global Integer stripeDate;
		global Integer amount;
		global String customer;
		global String id;
		global String invoice_id;
		global Boolean livemode;
	}
	
	global static StripeInvoice getInvoice(String invoiceId) {
		HttpRequest http = new HttpRequest();
		
		String end_point = SERVICE_URL+'/'+invoiceId;
			end_point += '?expand[]=customer';
		http.setEndpoint(end_point);

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
			hs.setBody(StripeInvoiceTests.testData_getInvoice);
			hs.setStatusCode(200);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		if (statusCode == 200) {
			try {
				StripeInvoice o = parse(response);
				return o;
			} catch (System.JSONException e) {
				return null;
			}
		} else {
			return null;
		}
	}

	global static StripeInvoice updateInvoice(String invoiceId, Map<String, String> properties, Map<String, String> metadata) {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(SERVICE_URL+'/'+invoiceId);
		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		Map<String, String> payload = new Map<String, String>();
		if (properties != null) {
			for (String key : properties.keySet()) {
				if (properties.get(key) != null) {
					payload.put(key, properties.get(key));
				}
			}
		}

		if (metadata != null) {
			for (String key : metadata.keySet()) {
				if (metadata.get('key') != null) {
					payload.put('metadata['+key+']', metadata.get(key));
				}
			}
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
			hs.setBody(StripeInvoiceTests.testData_getInvoice);
			hs.setStatusCode(200);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		try {
			StripeInvoice o = StripeInvoice.parse(response);
			System.debug(System.LoggingLevel.INFO, '\n**** StripeInvoice object: '+o); 
			return o;
		} catch (System.JSONException e) {
			System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
			return null;
		}
	}

	global StripeInvoiceItemResponse addLineItem(Decimal amount) {
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeInvoice.ITEMS_SERVICE_URL);

		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
		String authorizationHeader = 'BASIC ' +
		EncodingUtil.base64Encode(headerValue);
		http.setHeader('Authorization', authorizationHeader);
		
		String charge_amount = String.valueOf((amount*100).intValue());
		Map<String, String> payload = new Map<String, String>{
			'invoice' => this.id,
			'customer' => this.customer_id,
			'currency' => 'usd',
			'amount' =>	charge_amount
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
			hs.setBody(StripeInvoiceItemResponseTests.testData_InvoiceItem);
			hs.setStatusCode(200);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		
		try {
			StripeInvoiceItemResponse inv_item_response = StripeInvoiceItemResponse.parse(response);
			System.debug(System.LoggingLevel.INFO, '\n**** '+inv_item_response); 
			return inv_item_response;

		} catch (System.JSONException e) {
			return null;
		}
	}
	
	public static StripeInvoice parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);		
		System.debug(System.LoggingLevel.INFO, '\n**** '+json); 

		return (StripeInvoice) System.JSON.deserialize(json, StripeInvoice.class);
	}
	
}