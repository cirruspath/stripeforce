@isTest
public class StripeEventTests {

	private static testMethod void testParse_InvoicePaymentSucceeded() {
		StripeEvent event = StripeEvent.parse(testData_InvoicePaymentSucceeded);
		System.assert(event != null);
		System.assert(event.stripeData.StripeInvoice != null);
		
		StripeInvoice invoice = event.stripeData.StripeInvoice;
		System.assertEquals(1, invoice.lines.invoiceitems.size());
		System.assertEquals(1, invoice.lines.subscriptions.size());
		
		System.debug(System.LoggingLevel.INFO, '\n**** Invoice: '+event.stripeData.StripeInvoice); 
	}

	private static testMethod void testParse_InvoiceCreated() {
		String json = testData_InvoiceCreated;
		StripeEvent event = StripeEvent.parse(json);
		System.assert(event != null);
		System.assert(event.stripeData.StripeInvoice != null);
		System.debug(System.LoggingLevel.INFO, '\n**** Invoice: '+event.stripeData.StripeInvoice); 
	}

	private static testMethod void testParse_ChargeSucceeded() {
		String json = testData_ChargeSucceeded;
		StripeEvent event = StripeEvent.parse(json);
		System.assert(event != null);
		System.assert(event.stripeData.StripeCharge != null);
		System.debug(System.LoggingLevel.INFO, '\n**** Charge: '+event.stripeData.StripeCharge); 
	}
	
	private static testMethod void testParse_ChargeRefunded() {
		String json = testData_ChargeRefunded;
		StripeEvent event = StripeEvent.parse(json);
		System.assert(event != null);
		System.assert(event.stripeData.StripeCharge != null);
		System.debug(System.LoggingLevel.INFO, '\n**** Charge: '+event.stripeData.StripeCharge); 
	}

	private static testMethod void testParse_CustomerUpdated() {
		String json = testData_CustomerUpdated;
		StripeEvent event = StripeEvent.parse(json);
		System.assert(event != null);
		System.debug(System.LoggingLevel.INFO, '\n**** EVENT: '+event); 
		System.assert(event.stripeData.StripeCustomer != null);
		System.assert(event.stripeData.previous_attributes != null);
		
		System.debug(System.LoggingLevel.INFO, '\n**** Charge: '+event.stripeData.StripeCustomer); 
	}

	private static testMethod void testParse_CustomerSubscriptionDeleted() {
		String json = testData_CustomerSubscriptionDeleted;
		StripeEvent event = StripeEvent.parse(json);
		System.assert(event != null);
		System.assert(event.stripeData.StripeSubscription != null);
		System.debug(System.LoggingLevel.INFO, '\n**** Subscription: '+event.stripeData.StripeSubscription); 
	}

	public static String testData_ChargeSucceeded {
		get {
			return '{'+
				'  "object": "event",'+
				'  "type": "charge.succeeded",'+
				'  "created": 1342422128,'+
				'  "pending_webhooks": 1,'+
				'  "data": {'+
				'    "object": {'+
				'      "id": "ch_sHBUQHlTQzx5S8",'+
				'      "amount": 2000,'+
				'      "object": "charge",'+
				'      "fee_details": ['+
				'        {'+
				'          "type": "stripe_fee",'+
				'          "currency": "usd",'+
				'          "description": "Stripe processing fees",'+
				'          "amount": 88,'+
				'          "application": null'+
				'        }'+
				'      ],'+
				'      "created": 1342422128,'+
				'      "fee": 88,'+
				'      "livemode": false,'+
				'      "paid": true,'+
				'      "currency": "usd",'+
				'      "card": {'+
				'        "fingerprint": "pmVir47Ti9dNLS50",'+
				'        "cvc_check": "pass",'+
				'        "type": "Visa",'+
				'        "object": "card",'+
				'        "last4": "4242",'+
				'        "country": "US",'+
				'        "exp_month": 12,'+
				'        "exp_year": 2012'+
				'      },'+
				'      "disputed": false,'+
				'      "customer": "cus_00000000000000",'+
				'      "description": "sample description",'+
				'      "refunded": false'+
				'    }'+
				'  },'+
				'  "livemode": false,'+
				'  "id": "evt_7RJPM7Dh5rFA2R"'+
				'}';
		}
	}
	
	public static String testData_InvoicePaymentSucceeded {
		get {
			return '{'+
				'	"type": "invoice.payment_succeeded",'+
				'	"object": "event",'+
				'	"created": 1355353000,'+
				'	"livemode": true,'+
				'	"id": "evt_0uCqh93bha4Y4s",'+
				'	"pending_webhooks": 1,'+
				'	"data": {'+
				'		"object": {'+
				'			"period_start": 1323725795,'+
				'			"next_payment_attempt": null,'+
				'			"closed": true,'+
				'			"period_end": 1355348195,'+
				'			"paid": true,'+
				'			"total": 6000,'+
				'			"attempted": true,'+
				'			"lines": {'+
				'				"invoiceitems": ['+
				'					{'+
				'						"proration": false,'+
				'						"object": "invoiceitem",'+
				'						"date": 1355348659,'+
				'						"amount": 6000,'+
				'						"currency": "usd",'+
				'						"customer": "cus_00000000000000",'+
				'						"id": "ii_0uBf5LGi6Bm1md",'+
				'						"invoice": "in_0uBfMrUAiK1mvd",'+
				'						"livemode": true'+
				'					}'+
				'				],'+
				'				"subscriptions": ['+
				'					{'+
				'						"type": "subscription",'+
				'						"proration": false,'+
				'						"object": "line_item",'+
				'						"amount": 0,'+
				'						"currency": "usd",'+
				'						"plan": {'+
				'							"interval": "year",'+
				'							"object": "plan",'+
				'							"amount": 0,'+
				'							"currency": "usd",'+
				'							"name": "Cirrus Insight Annually",'+
				'							"id": "CI_ANNUALLY",'+
				'							"livemode": true,'+
				'							"interval_count": 1'+
				'						},'+
				'						"id": "su_YntabbCbQ96DtN",'+
				'						"period": {'+
				'							"end": 1386884195,'+
				'							"start": 1355348195'+
				'						},'+
				'						"quantity": 1,'+
				'						"livemode": true,'+
				'						"description": null'+
				'					}'+
				'				]'+
				'			},'+
				'			"amount_due": 6000,'+
				'			"attempt_count": 1,'+
				'			"object": "invoice",'+
				'			"starting_balance": 0,'+
				'			"customer": "cus_00000000000000",'+
				'			"date": 1355348653,'+
				'			"ending_balance": 0,'+
				'			"charge": "ch_0uCqVdEyrMbwyE",'+
				'			"livemode": true,'+
				'			"id": "in_0uBfMrUAiK1mvd",'+
				'			"currency": "usd",'+
				'			"subtotal": 6000'+
				'		}'+
				'	}'+
				'}';
		}
	}

	public static String testData_InvoiceCreated {
		get {
			return '{'+
		'  "type": "invoice.created",'+
		'  "livemode": false,'+
		'  "object": "event",'+
		'  "created": 1326853478,'+
		'  "id": "evt_00000000000000",'+
		'  "data": {'+
		'    "object": {'+
		'      "attempt_count": 0,'+
		'      "next_payment_attempt": null,'+
		'      "total": 1000,'+
		'      "livemode": false,'+
		'      "lines": {'+
		'        "count": 1,'+
		'        "object": "list",'+
		'        "url": "/v1/invoices/in_0kxRN5CdHHjhsR/lines",'+
		'        "data": ['+
		'          {'+
		'            "period": {'+
		'              "end": 1358490343,'+
		'              "start": 1355811943'+
		'            },'+
		'            "type": "subscription",'+
		'            "plan": {'+
		'              "livemode": false,'+
		'              "interval_count": 1,'+
		'              "interval": "month",'+
		'              "object": "plan",'+
		'              "name": "Cirrus Insight Monthly",'+
		'              "amount": 0,'+
		'              "currency": "usd",'+
		'              "trial_period_days": null,'+
		'              "id": "CI_MONTHLY"'+
		'            },'+
		'            "proration": false,'+
		'            "livemode": true,'+
		'            "quantity": 1,'+
		'            "object": "line_item",'+
		'            "currency": "usd",'+
		'            "amount": 0,'+
		'            "id": "su_0kxRX2vwSsjdf4",'+
		'            "description": null'+
		'          }'+
		'        ]'+
		'      },'+
		'      "amount_due": 0,'+
		'      "period_start": 1353219943,'+
		'      "subtotal": 0,'+
		'      "attempted": false,'+
		'      "object": "invoice",'+
		'      "starting_balance": 0,'+
		'      "period_end": 1353219943,'+
		'      "charge": null,'+
		'      "date": 1353219943,'+
		'      "ending_balance": null,'+
		'      "discount": null,'+
		'      "customer": "cus_00000000000000",'+
		'      "closed": true,'+
		'      "currency": "usd",'+
		'      "id": "in_00000000000000",'+
		'      "paid": true'+
		'    }'+
		'  }'+
		'}';
		}
	}

	public static String testData_CustomerSubscriptionDeleted {
		get {
			return '{'+
				'  "type": "customer.subscription.deleted",'+
				'  "livemode": false,'+
				'  "object": "event",'+
				'  "created": 1326853478,'+
				'  "id": "evt_00000000000000",'+
				'  "data": {'+
				'    "object": {'+
				'      "status": "canceled",'+
				'      "plan": {'+
				'        "livemode": false,'+
				'        "interval_count": 1,'+
				'        "interval": "year",'+
				'        "object": "plan",'+
				'        "trial_period_days": null,'+
				'        "currency": "usd",'+
				'        "amount": 0,'+
				'        "name": "Cirrus Insight Annually",'+
				'        "id": "CI_00000000000000"'+
				'      },'+
				'      "cancel_at_period_end": false,'+
				'      "start": 1353301842,'+
				'      "current_period_start": 1353301842,'+
				'      "canceled_at": null,'+
				'      "quantity": 1,'+
				'      "object": "subscription",'+
				'      "current_period_end": 1384837842,'+
				'      "trial_start": null,'+
				'      "trial_end": null,'+
				'      "customer": "cus_00000000000000",'+
				'      "ended_at": 1353108230'+
				'    }'+
				'  }'+
				'}';
		}
	}
	
	public static String testData_InvoicePaymentFailed {
		get {
			return '{'+
				'  "type": "invoice.payment_failed",'+
				'  "livemode": false,'+
				'  "object": "event",'+
				'  "created": 1326853478,'+
				'  "id": "evt_00000000000000",'+
				'  "data": {'+
				'    "object": {'+
				'      "attempt_count": 0,'+
				'      "next_payment_attempt": null,'+
				'      "total": 1000,'+
				'      "livemode": false,'+
				'      "lines": {'+
				'        "count": 1,'+
				'        "object": "list",'+
				'        "url": "/v1/invoices/in_0kxRN5CdHHjhsR/lines",'+
				'        "data": ['+
				'          {'+
				'            "period": {'+
				'              "end": 1358490343,'+
				'              "start": 1355811943'+
				'            },'+
				'            "type": "subscription",'+
				'            "plan": {'+
				'              "livemode": false,'+
				'              "interval_count": 1,'+
				'              "interval": "month",'+
				'              "object": "plan",'+
				'              "name": "Cirrus Insight Monthly",'+
				'              "amount": 0,'+
				'              "currency": "usd",'+
				'              "trial_period_days": null,'+
				'              "id": "CI_MONTHLY"'+
				'            },'+
				'            "proration": false,'+
				'            "livemode": true,'+
				'            "quantity": 1,'+
				'            "object": "line_item",'+
				'            "currency": "usd",'+
				'            "amount": 0,'+
				'            "id": "su_0kxRX2vwSsjdf4",'+
				'            "description": null'+
				'          }'+
				'        ]'+
				'      },'+
				'      "amount_due": 0,'+
				'      "period_start": 1353219943,'+
				'      "subtotal": 0,'+
				'      "attempted": true,'+
				'      "object": "invoice",'+
				'      "starting_balance": 0,'+
				'      "period_end": 1353219943,'+
				'      "charge": null,'+
				'      "date": 1353219943,'+
				'      "ending_balance": null,'+
				'      "discount": null,'+
				'      "customer": "cus_00000000000000",'+
				'      "closed": false,'+
				'      "currency": "usd",'+
				'      "id": "in_00000000000000",'+
				'      "paid": false'+
				'    }'+
				'  }'+
				'}';
		}
	}
	
	public static String testData_ChargeRefunded {
		get {
			return '{'+
				'  "pending_webhooks": 1,'+
				'  "type": "charge.refunded",'+
				'  "livemode": false,'+
				'  "object": "event",'+
				'  "created": 1353304503,'+
				'  "id": "evt_0lKAu5rQvWZlGJ",'+
				'  "data": {'+
				'    "object": {'+
				'      "paid": true,'+
				'      "amount": 9900,'+
				'      "amount_refunded": 6000,'+
				'      "fee": 317,'+
				'      "livemode": false,'+
				'      "invoice": null,'+
				'      "card": {'+
				'        "type": "Visa",'+
				'        "address_zip": null,'+
				'        "address_state": null,'+
				'        "cvc_check": "pass",'+
				'        "object": "card",'+
				'        "address_country": null,'+
				'        "address_line1": null,'+
				'        "address_zip_check": null,'+
				'        "exp_month": 12,'+
				'        "fingerprint": "pmVir47Ti9dNLS50",'+
				'        "country": "US",'+
				'        "name": null,'+
				'        "address_line2": null,'+
				'        "address_line1_check": null,'+
				'        "last4": "4242",'+
				'        "exp_year": 2012,'+
				'        "address_city": null'+
				'      },'+
				'      "created": 1353301554,'+
				'      "object": "charge",'+
				'      "customer": "cus_00000000000000",'+
				'      "failure_message": null,'+
				'      "fee_details": ['+
				'        {'+
				'          "type": "stripe_fee",'+
				'          "amount": 317,'+
				'          "currency": "usd",'+
				'          "application": null,'+
				'          "description": "Stripe processing fees"'+
				'        }'+
				'      ],'+
				'      "id": "ch_0lJN69c0Q4D1lL",'+
				'      "dispute": null,'+
				'      "currency": "usd",'+
				'      "description": "Charge for test@example.com",'+
				'      "refunded": false'+
				'    }'+
				'  }'+
				'}';
		}
	}

	public static String testData_ChargeFailed {
		get {
			return '{'+
				'  "type": "charge.failed",'+
				'  "livemode": false,'+
				'  "object": "event",'+
				'  "created": 1326853478,'+
				'  "id": "evt_00000000000000",'+
				'  "data": {'+
				'    "object": {'+
				'      "fee_details": ['+
				'        {'+
				'          "type": "stripe_fee",'+
				'          "application": null,'+
				'          "currency": "usd",'+
				'          "amount": 0,'+
				'          "description": "Stripe processing fees"'+
				'        }'+
				'      ],'+
				'      "invoice": null,'+
				'      "dispute": null,'+
				'      "livemode": false,'+
				'      "failure_message": null,'+
				'      "card": {'+
				'        "address_country": null,'+
				'        "country": "US",'+
				'        "type": "Visa",'+
				'        "last4": "4242",'+
				'        "address_line1": null,'+
				'        "exp_year": 2012,'+
				'        "fingerprint": "pmVir47Ti9dNLS50",'+
				'        "address_line2": null,'+
				'        "cvc_check": "pass",'+
				'        "address_city": null,'+
				'        "object": "card",'+
				'        "address_zip_check": null,'+
				'        "address_zip": null,'+
				'        "address_line1_check": null,'+
				'        "name": null,'+
				'        "address_state": null,'+
				'        "exp_month": 12'+
				'      },'+
				'      "object": "charge",'+
				'      "created": 1353301843,'+
				'      "fee": 0,'+
				'      "amount": 1000,'+
				'      "currency": "usd",'+
				'      "refunded": false,'+
				'      "customer": "cus_00000000000000",'+
				'      "id": "ch_00000000000000",'+
				'      "paid": false,'+
				'      "amount_refunded": 0,'+
				'      "description": null'+
				'    }'+
				'  }'+
				'}';
		}
	}

	public static String testData_CustomerCardCreated {
		get {
			return '{'+
				'  "id": "evt_103ctg2BONonlYaULT2VQcT9",'+
				'  "created": 1394259867,'+
				'  "livemode": false,'+
				'  "type": "customer.card.created",'+
				'  "data": {'+
				'    "object": {'+
				'      "id": "card_103ctg2BONonlYaUl4Njcd7V",'+
				'      "object": "card",'+
				'      "last4": "1881",'+
				'      "type": "Visa",'+
				'      "exp_month": 3,'+
				'      "exp_year": 2015,'+
				'      "fingerprint": "oVSfQJDcxFfCBlGB",'+
				'      "customer": "cus_00000000000000",'+
				'      "country": "US",'+
				'      "name": null,'+
				'      "address_line1": null,'+
				'      "address_line2": null,'+
				'      "address_city": null,'+
				'      "address_state": null,'+
				'      "address_zip": null,'+
				'      "address_country": null,'+
				'      "cvc_check": "pass",'+
				'      "address_line1_check": null,'+
				'      "address_zip_check": null'+
				'    }'+
				'  },'+
				'  "object": "event",'+
				'  "pending_webhooks": 1,'+
				'  "request": "iar_3ctgOuziIWxG3q"'+
				'}';
		}
	}
	
	public static String testData_CustomerUpdated {
		get {
			return '{'+
				'  "id": "evt_103ctn2BONonlYaUjvgdxaMj",'+
				'  "created": 1394260283,'+
				'  "livemode": false,'+
				'  "type": "customer.updated",'+
				'  "data": {'+
				'    "object": {'+
				'      "object": "customer",'+
				'      "created": 1383951929,'+
				'      "id": "cus_00000000000000",'+
				'      "livemode": false,'+
				'      "description": "Life in the Clouds",'+
				'      "email": null,'+
				'      "delinquent": false,'+
				'      "metadata": {},'+
				'      "subscriptions": {'+
				'        "object": "list",'+
				'        "count": 0,'+
				'        "url": "/v1/customers/cus_00000000000000/subscriptions",'+
				'        "data": []'+
				'      },'+
				'      "discount": null,'+
				'      "account_balance": 0,'+
				'      "currency": null,'+
				'      "cards": {'+
				'        "object": "list",'+
				'        "count": 2,'+
				'        "url": "/v1/customers/cus_00000000000000/cards",'+
				'        "data": ['+
				'          {'+
				'            "id": "card_103ctg2BONonlYaUl4Njcd7V",'+
				'            "object": "card",'+
				'            "last4": "1881",'+
				'            "type": "Visa",'+
				'            "exp_month": 3,'+
				'            "exp_year": 2016,'+
				'            "fingerprint": "oVSfQJDcxFfCBlGB",'+
				'            "customer": "cus_00000000000000",'+
				'            "country": "US",'+
				'            "name": null,'+
				'            "address_line1": null,'+
				'            "address_line2": null,'+
				'            "address_city": null,'+
				'            "address_state": null,'+
				'            "address_zip": null,'+
				'            "address_country": null,'+
				'            "cvc_check": "pass",'+
				'            "address_line1_check": null,'+
				'            "address_zip_check": null'+
				'          },'+
				'          {'+
				'            "id": "card_102uCj2BONonlYaULwspZstB",'+
				'            "object": "card",'+
				'            "last4": "4242",'+
				'            "type": "Visa",'+
				'            "exp_month": 11,'+
				'            "exp_year": 2014,'+
				'            "fingerprint": "jTU2IfFVCVRg8CCh",'+
				'            "customer": "cus_00000000000000",'+
				'            "country": "US",'+
				'            "name": null,'+
				'            "address_line1": null,'+
				'            "address_line2": null,'+
				'            "address_city": null,'+
				'            "address_state": null,'+
				'            "address_zip": null,'+
				'            "address_country": null,'+
				'            "cvc_check": "pass",'+
				'            "address_line1_check": null,'+
				'            "address_zip_check": null'+
				'          }'+
				'        ]'+
				'      },'+
				'      "default_card": "card_103ctg2BONonlYaUl4Njcd7V",'+
				'      "subscription": null'+
				'    },'+
				'    "previous_attributes": {'+
				'      "default_card": "card_102uCj2BONonlYaULwspZstB"'+
				'    }'+
				'  },'+
				'  "object": "event",'+
				'  "request": "iar_3ctnxZZ4RjfXuK"'+
				'}';
		}
	}

	public static String testData_CustomerCreated {
		get {
			return '{'+
				'  "id": "evt_103ctn2BONonlYaUjvgdxaMj",'+
				'  "created": 1394260283,'+
				'  "livemode": false,'+
				'  "type": "customer.created",'+
				'  "data": {'+
				'    "object": {'+
				'      "object": "customer",'+
				'      "created": 1383951929,'+
				'      "id": "cus_00000000000000",'+
				'      "livemode": false,'+
				'      "description": "Life in the Clouds",'+
				'      "email": null,'+
				'      "delinquent": false,'+
				'      "metadata": {},'+
				'      "subscriptions": {'+
				'        "object": "list",'+
				'        "count": 0,'+
				'        "url": "/v1/customers/cus_00000000000000/subscriptions",'+
				'        "data": []'+
				'      },'+
				'      "discount": null,'+
				'      "account_balance": 0,'+
				'      "currency": null,'+
				'      "cards": {'+
				'        "object": "list",'+
				'        "count": 2,'+
				'        "url": "/v1/customers/cus_00000000000000/cards",'+
				'        "data": ['+
				'          {'+
				'            "id": "card_103ctg2BONonlYaUl4Njcd7V",'+
				'            "object": "card",'+
				'            "last4": "1881",'+
				'            "type": "Visa",'+
				'            "exp_month": 3,'+
				'            "exp_year": 2016,'+
				'            "fingerprint": "oVSfQJDcxFfCBlGB",'+
				'            "customer": "cus_00000000000000",'+
				'            "country": "US",'+
				'            "name": null,'+
				'            "address_line1": null,'+
				'            "address_line2": null,'+
				'            "address_city": null,'+
				'            "address_state": null,'+
				'            "address_zip": null,'+
				'            "address_country": null,'+
				'            "cvc_check": "pass",'+
				'            "address_line1_check": null,'+
				'            "address_zip_check": null'+
				'          },'+
				'          {'+
				'            "id": "card_102uCj2BONonlYaULwspZstB",'+
				'            "object": "card",'+
				'            "last4": "4242",'+
				'            "type": "Visa",'+
				'            "exp_month": 11,'+
				'            "exp_year": 2014,'+
				'            "fingerprint": "jTU2IfFVCVRg8CCh",'+
				'            "customer": "cus_00000000000000",'+
				'            "country": "US",'+
				'            "name": null,'+
				'            "address_line1": null,'+
				'            "address_line2": null,'+
				'            "address_city": null,'+
				'            "address_state": null,'+
				'            "address_zip": null,'+
				'            "address_country": null,'+
				'            "cvc_check": "pass",'+
				'            "address_line1_check": null,'+
				'            "address_zip_check": null'+
				'          }'+
				'        ]'+
				'      },'+
				'      "default_card": "card_103ctg2BONonlYaUl4Njcd7V",'+
				'      "subscription": null'+
				'    },'+
				'    "previous_attributes": {'+
				'      "default_card": "card_102uCj2BONonlYaULwspZstB"'+
				'    }'+
				'  },'+
				'  "object": "event",'+
				'  "request": "iar_3ctnxZZ4RjfXuK"'+
				'}';
		}
	}

	private static testMethod void test_general() {
		new StripeEvent();
		new StripeEvent.EventData();
		new StripeEvent.UnknownWebhookException();
	}

}