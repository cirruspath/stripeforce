global class StripeInvoice {
	private static final String SERVICE_URL = 'https://api.stripe.com/v1/invoices';
	private static final String ITEMS_SERVICE_URL = 'https://api.stripe.com/v1/invoiceitems';

	global Integer 	attempt_count;
	global Integer 	next_payment_attempt;
	global Integer 	total;
	global Boolean 	livemode;
	global Lines 		lines;
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
	
	private static Integer test_StatusCode = 200;
	
	global static StripeInvoice getInvoice(String invoiceId) {
		//if (Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new MockHttpResponse(testData_getInvoice, test_StatusCode));
		HttpRequest http = new HttpRequest();
		
		String end_point = SERVICE_URL+'/'+invoiceId;
			end_point += '?expand[]=customer';
		http.setEndpoint(end_point);

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
			hs.setBody(testData_getInvoice);
			hs.setStatusCode(test_statusCode);
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

	global StripeInvoiceItemResponse addLineItem(Decimal amount) {
		//if (Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new MockHttpResponse(StripeInvoiceItemResponse.testData_InvoiceItem, test_StatusCode));
		HttpRequest http = new HttpRequest();
		http.setEndpoint(StripeInvoice.ITEMS_SERVICE_URL);

		http.setMethod('POST');
		Blob headerValue = Blob.valueOf(API.ApiKey + ':');
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
			hs.setBody(StripeInvoiceItemResponse.testData_InvoiceItem);
			hs.setStatusCode(test_statusCode);
		}

		system.debug('#### '+ hs.getBody());
		
		response = hs.getBody();
		statusCode = hs.getStatusCode();
		system.debug('$$statusCode = '+hs.getStatusCode());
		
		if (statusCode == 200) {
			try {
				StripeInvoiceItemResponse inv_item_response = StripeInvoiceItemResponse.parse(response);
				return inv_item_response;
			} catch (System.JSONException e) {
				return null;
			}
		} else {
			return null;
		}
	}
	
	public static StripeInvoice parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);		
		System.debug(System.LoggingLevel.INFO, '\n**** '+json); 

		return (StripeInvoice) System.JSON.deserialize(json, StripeInvoice.class);
	}
	
	private static String testData_getInvoice {
		get {
			String json = '{'+
				'  "date": 1378491876,'+
				'  "id": "in_2WWyDTZpb3IvXD",'+
				'  "period_start": 1378491876,'+
				'  "period_end": 1378491876,'+
				'  "lines": {'+
				'    "invoiceitems": ['+
				'      {'+
				'        "proration": false,'+
				'        "object": "invoiceitem",'+
				'        "date": 1355348659,'+
				'        "amount": 6000,'+
				'        "currency": "usd",'+
				'        "customer": "cus_9mEg8W2FCx82C1",'+
				'        "id": "ii_0uBf5LGi6Bm1md",'+
				'        "invoice": "in_0uBfMrUAiK1mvd",'+
				'        "livemode": true'+
				'      }'+
				'    ],'+
				'    "subscriptions": ['+
				'      {'+
				'        "id": "su_2WWyeBoUevuyNd",'+
				'        "object": "line_item",'+
				'        "type": "subscription",'+
				'        "livemode": true,'+
				'        "amount": 0,'+
				'        "currency": "usd",'+
				'        "proration": false,'+
				'        "period": {'+
				'          "start": 1378491876,'+
				'          "end": 1381083876'+
				'        },'+
				'        "quantity": 1,'+
				'        "plan": {'+
				'          "interval": "month",'+
				'          "name": "Cirrus Insight Monthly",'+
				'          "amount": 0,'+
				'          "currency": "usd",'+
				'          "id": "CI_MONTHLY",'+
				'          "object": "plan",'+
				'          "livemode": true,'+
				'          "interval_count": 1'+
				'        },'+
				'        "description": null'+
				'      }'+
				'    ]'+
				'  },'+
				'  "subtotal": 0,'+
				'  "total": 0,'+
				'  "customer": {'+
				'    "object": "customer",'+
				'    "created": 1378491876,'+
				'    "id": "cus_2WWykkByyJuFB9",'+
				'    "livemode": true,'+
				'    "description": "Carbon War Room (005F00000018nWAIAY)",'+
				'    "subscription": {'+
				'      "id": "su_2WWyeBoUevuyNd",'+
				'      "plan": {'+
				'        "interval": "month",'+
				'        "name": "Cirrus Insight Monthly",'+
				'        "amount": 0,'+
				'        "currency": "usd",'+
				'        "id": "CI_MONTHLY",'+
				'        "object": "plan",'+
				'        "livemode": true,'+
				'        "interval_count": 1'+
				'      },'+
				'      "object": "subscription",'+
				'      "start": 1378491876,'+
				'      "status": "active",'+
				'      "customer": "cus_2WWykkByyJuFB9",'+
				'      "current_period_start": 1378491876,'+
				'      "current_period_end": 1381083876,'+
				'      "quantity": 1'+
				'    },'+
				'    "account_balance": 0,'+
				'    "cards": {'+
				'      "object": "list",'+
				'      "count": 1,'+
				'      "url": "/v1/customers/cus_2WWykkByyJuFB9/cards",'+
				'      "data": ['+
				'        {'+
				'          "id": "card_2WWynYtWC1y0NL",'+
				'          "object": "card",'+
				'          "last4": "1036",'+
				'          "type": "American Express",'+
				'          "exp_month": 6,'+
				'          "exp_year": 2014,'+
				'          "fingerprint": "w8vpQTA1QzR5EY4u",'+
				'          "customer": "cus_2WWykkByyJuFB9",'+
				'          "country": "US",'+
				'          "name": "Virginia Newton",'+
				'          "address_line1": "1020 19th St NW, Suite 130",'+
				'          "address_city": "Washington",'+
				'          "address_state": "DC",'+
				'          "address_zip": "20036",'+
				'          "address_country": "US",'+
				'          "cvc_check": "pass",'+
				'          "address_line1_check": "pass",'+
				'          "address_zip_check": "pass"'+
				'        }'+
				'      ]'+
				'    },'+
				'    "default_card": "card_2WWynYtWC1y0NL",'+
				'    "next_recurring_charge": {'+
				'      "date": "2013-10-06",'+
				'      "amount": 0'+
				'    },'+
				'    "active_card": {'+
				'      "id": "card_2WWynYtWC1y0NL",'+
				'      "object": "card",'+
				'      "last4": "1036",'+
				'      "type": "American Express",'+
				'      "exp_month": 6,'+
				'      "exp_year": 2014,'+
				'      "fingerprint": "w8vpQTA1QzR5EY4u",'+
				'      "customer": "cus_2WWykkByyJuFB9",'+
				'      "country": "US",'+
				'      "name": "Virginia Newton",'+
				'      "address_line1": "1020 19th St NW, Suite 130",'+
				'      "address_city": "Washington",'+
				'      "address_state": "DC",'+
				'      "address_zip": "20036",'+
				'      "address_country": "US",'+
				'      "cvc_check": "pass",'+
				'      "address_line1_check": "pass",'+
				'      "address_zip_check": "pass"'+
				'    }'+
				'  },'+
				'  "object": "invoice",'+
				'  "attempted": true,'+
				'  "closed": true,'+
				'  "paid": true,'+
				'  "livemode": true,'+
				'  "attempt_count": 0,'+
				'  "amount_due": 0,'+
				'  "currency": "usd",'+
				'  "starting_balance": 0,'+
				'  "ending_balance": null,'+
				'  "next_payment_attempt": null'+
				'}';
			return json;
		}
	}

	private static testMethod void testParse() {
		String json = testData_getInvoice;
		StripeInvoice obj = parse(json);
		
		System.assertEquals(1, obj.Lines.invoiceitems.size());
		System.assertEquals(1, obj.Lines.subscriptions.size());
		
		System.assert(obj != null);
	}
	
	private static testMethod void test_getInvoice_200() {
		Test.startTest();
		StripeInvoice invoice = getInvoice('in_0uBfMrUAiK1mvd');
		System.assertEquals('in_2WWyDTZpb3IvXD', invoice.id);
		Test.stopTest();
	}
	
	private static testMethod void test_getInvoice_500() {
		test_StatusCode = 500;

		Test.startTest();
		StripeInvoice invoice = getInvoice('in_2WWyDTZpb3IvXD');
		System.assertEquals(null, invoice);
		Test.stopTest();
	}
	
	private static testMethod void test_addlineItem_200() {
		StripeInvoice invoice = getInvoice('in_2WWyDTZpb3IvXD');

		Test.startTest();
		StripeInvoiceItemResponse li = invoice.addLineItem(3);
		System.assertEquals('in_u19lZAWIe9AIl1', li.invoice);
		Test.stopTest();
	}
	
	private static testMethod void test_addlineItem_500() {
		StripeInvoice invoice = getInvoice('in_0uBfMrUAiK1mvd');

		Test.startTest();
		test_StatusCode = 500;
		StripeInvoiceItemResponse li = invoice.addLineItem(3);
		System.assertEquals(null, li);
		Test.stopTest();
	}
	
	private static testMethod void test() {
		StripeInvoice invoice = new StripeInvoice();
		new Lines();
		new InvoiceItem();
	}
}