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
/*
	private static testMethod void testParse_InvoiceCreated() {
		String json = StripeListenerTests.testData_InvoiceCreated;
		StripeEvent event = parse(json);
		System.assert(event != null);
		System.assert(event.stripeData.StripeInvoice != null);
		System.debug(System.LoggingLevel.INFO, '\n**** Invoice: '+event.stripeData.StripeInvoice); 
	}

	private static testMethod void testParse_ChargeSucceeded() {
		String json = StripeListenerTests.testData_ChargeSucceeded;
		StripeEvent event = parse(json);
		System.assert(event != null);
		System.assert(event.stripeData.StripeCharge != null);
		System.debug(System.LoggingLevel.INFO, '\n**** Charge: '+event.stripeData.StripeCharge); 
	}
	
	private static testMethod void testParse_ChargeRefunded() {
		String json = StripeListenerTests.testData_ChargeRefunded;
		StripeEvent event = parse(json);
		System.assert(event != null);
		System.assert(event.stripeData.StripeCharge != null);
		System.debug(System.LoggingLevel.INFO, '\n**** Charge: '+event.stripeData.StripeCharge); 
	}

	private static testMethod void testParse_CustomerUpdated() {
		String json = StripeListenerTests.testData_CustomerUpdated;
		StripeEvent event = parse(json);
		System.assert(event != null);
		System.debug(System.LoggingLevel.INFO, '\n**** EVENT: '+event); 
		System.assert(event.stripeData.StripeCustomer != null);
		System.assert(event.stripeData.previous_attributes != null);
		System.assert(event.stripeData.previous_attributes.active_card != null);
		
		System.debug(System.LoggingLevel.INFO, '\n**** Charge: '+event.stripeData.StripeCustomer); 
	}

	private static testMethod void testParse_CustomerSubscriptionDeleted() {
		String json = StripeListenerTests.testData_CustomerSubscriptionDeleted;
		StripeEvent event = parse(json);
		System.assert(event != null);
		System.assert(event.stripeData.StripeSubscription != null);
		System.debug(System.LoggingLevel.INFO, '\n**** Subscription: '+event.stripeData.StripeSubscription); 
	}
*/

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
				'						"customer": "cus_9mEg8W2FCx82C1",'+
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
				'			"customer_id": "cus_9mEg8W2FCx82C1",'+
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


	private static testMethod void test_general() {
		new StripeEvent();
		new StripeEvent.EventData();
		new StripeEvent.PreviousAttributes();
		new StripeEvent.UnknownWebhookException();
	}

}