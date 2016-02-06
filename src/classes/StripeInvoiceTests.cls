@isTest
public class StripeInvoiceTests {

	public static String testData_getInvoice {
		get {
			return '{'+
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
				'        "customer": "cus_00000000000000",'+
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
				'    "id": "cus_00000000000000",'+
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
				'      "customer": "cus_00000000000000",'+
				'      "current_period_start": 1378491876,'+
				'      "current_period_end": 1381083876,'+
				'      "quantity": 1'+
				'    },'+
				'    "account_balance": 0,'+
				'    "cards": {'+
				'      "object": "list",'+
				'      "count": 1,'+
				'      "url": "/v1/customers/cus_00000000000000/cards",'+
				'      "data": ['+
				'        {'+
				'          "id": "card_2WWynYtWC1y0NL",'+
				'          "object": "card",'+
				'          "last4": "1036",'+
				'          "type": "American Express",'+
				'          "exp_month": 6,'+
				'          "exp_year": 2014,'+
				'          "fingerprint": "w8vpQTA1QzR5EY4u",'+
				'          "customer": "cus_00000000000000",'+
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
				'    "active_card": {'+
				'      "id": "card_2WWynYtWC1y0NL",'+
				'      "object": "card",'+
				'      "last4": "1036",'+
				'      "type": "American Express",'+
				'      "exp_month": 6,'+
				'      "exp_year": 2014,'+
				'      "fingerprint": "w8vpQTA1QzR5EY4u",'+
				'      "customer": "cus_00000000000000",'+
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
		}
	}
    
	private static testMethod void testParse() {
		String json = testData_getInvoice;
		StripeInvoice obj = StripeInvoice.parse(json);
		
		System.assertEquals(1, obj.Lines.invoiceitems.size());
		System.assertEquals(1, obj.Lines.subscriptions.size());
		
		System.assert(obj != null);
	}
	
	private static testMethod void test_getInvoice() {
		Test.startTest();
		StripeInvoice invoice = StripeInvoice.getInvoice('in_0uBfMrUAiK1mvd');
		System.assertEquals('in_2WWyDTZpb3IvXD', invoice.id);
		Test.stopTest();
	}
	
	private static testMethod void test_addlineItem() {
		StripeInvoice invoice = StripeInvoice.getInvoice('in_2WWyDTZpb3IvXD');

		Test.startTest();
		StripeInvoiceItemResponse li = invoice.addLineItem(3);
		System.assertEquals('in_u19lZAWIe9AIl1', li.invoice_id);
		Test.stopTest();
	}
	
	private static testMethod void test() {
		StripeInvoice invoice = new StripeInvoice();
		new StripeInvoice.Lines();
		new StripeInvoice.InvoiceItem();
	}
}