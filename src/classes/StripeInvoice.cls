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
	global String 	customer;
	global Boolean 	closed;
	global String 	stripeCurrency;
	global String 	id;
	global Boolean 	paid;
	global StripeError error;
	
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
		global String invoice;
		global Boolean livemode;
	}
	
	private static Integer test_StatusCode = 200;
	
	global static StripeInvoice getInvoice(String invoiceId) {
		//if (Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new MockHttpResponse(testData_getInvoice, test_StatusCode));
		HttpRequest http = new HttpRequest();
		http.setEndpoint(SERVICE_URL+'/'+invoiceId);
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
			'customer' => this.customer,
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
		json = json.replaceAll('"object":', '"stripeObject":');
		json = json.replaceAll('"date":', '"stripeDate":');
		json = json.replaceAll('"end":', '"endDate":');
		json = json.replaceAll('"start":', '"startDate":');
		json = json.replaceAll('"data":', '"stripeData":');
		json = json.replaceAll('"type":', '"stripeType":');
		json = json.replaceAll('"currency":', '"stripeCurrency":');
		System.debug(System.LoggingLevel.INFO, '\n**** '+json); 

		return (StripeInvoice) System.JSON.deserialize(json, StripeInvoice.class);
	}
	
	private static String testData_getInvoice {
		get {
			String json = '{'+
				'	"period_start": 1323725795,'+
				'	"next_payment_attempt": null,'+
				'	"closed": true,'+
				'	"period_end": 1355348195,'+
				'	"paid": true,'+
				'	"total": 6000,'+
				'	"attempted": true,'+
				'	"lines": {'+
				'		"invoiceitems": ['+
				'			{'+
				'				"proration": false,'+
				'				"object": "invoiceitem",'+
				'				"date": 1355348659,'+
				'				"amount": 6000,'+
				'				"currency": "usd",'+
				'				"customer": "cus_9mEg8W2FCx82C1",'+
				'				"id": "ii_0uBf5LGi6Bm1md",'+
				'				"invoice": "in_0uBfMrUAiK1mvd",'+
				'				"livemode": true'+
				'			}'+
				'		],'+
				'		"subscriptions": ['+
				'			{'+
				'				"type": "subscription",'+
				'				"proration": false,'+
				'				"object": "line_item",'+
				'				"amount": 0,'+
				'				"currency": "usd",'+
				'				"plan": {'+
				'					"interval": "year",'+
				'					"object": "plan",'+
				'					"amount": 0,'+
				'					"currency": "usd",'+
				'					"name": "Cirrus Insight Annually",'+
				'					"id": "CI_ANNUALLY",'+
				'					"livemode": true,'+
				'					"interval_count": 1'+
				'				},'+
				'				"id": "su_YntabbCbQ96DtN",'+
				'				"period": {'+
				'					"end": 1386884195,'+
				'					"start": 1355348195'+
				'				},'+
				'				"quantity": 1,'+
				'				"livemode": true,'+
				'				"description": null'+
				'			}'+
				'		]'+
				'	},'+
				'	"amount_due": 6000,'+
				'	"attempt_count": 1,'+
				'	"object": "invoice",'+
				'	"starting_balance": 0,'+
				'	"customer": "cus_9mEg8W2FCx82C1",'+
				'	"date": 1355348653,'+
				'	"ending_balance": 0,'+
				'	"charge": "ch_0uCqVdEyrMbwyE",'+
				'	"livemode": true,'+
				'	"id": "in_0uBfMrUAiK1mvd",'+
				'	"currency": "usd",'+
				'	"subtotal": 6000'+
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
		System.assertEquals('in_0uBfMrUAiK1mvd', invoice.id);
		Test.stopTest();
	}
	
	private static testMethod void test_getInvoice_500() {
		test_StatusCode = 500;

		Test.startTest();
		StripeInvoice invoice = getInvoice('in_0uBfMrUAiK1mvd');
		System.assertEquals(null, invoice);
		Test.stopTest();
	}
	
	private static testMethod void test_addlineItem_200() {
		StripeInvoice invoice = getInvoice('in_0uBfMrUAiK1mvd');

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