@isTest
public class StripeCustomerTests {

	public static String testData_currentPeriodStart {
		get {
			DateTime d = DateTime.now();
			Integer i = (d.getTime() / 1000).intValue();
			return String.valueOf(i);
		}
	}
	
	public static String testData_currentPeriodEnd {
		get {
			DateTime d = DateTime.now().addYears(1);
			Integer i = (d.getTime() / 1000).intValue();
			return String.valueOf(i);
		}
	}
	
	public static String testData_getCustomer {
		get {
			return '{"object": "customer", "created": 1375155380, "id": "cus_00000000000000", "livemode": false, "description": "Cirruspath (005G00000025O4VIAU)", "email": null, "delinquent": false, "metadata": { }, "subscription": { "id": "su_2I44CLUFxzAgjY", "plan": { "interval": "year", "name": "Cirrus Insight Annual Subscription", "amount": 0, "currency": "usd", "id": "CI_ANNUALLY", "object": "plan", "livemode": false, "interval_count": 1, "trial_period_days": null }, "object": "subscription", "start": 1375155380, "status": "active", "customer": "cus_00000000000000", "cancel_at_period_end": false, "current_period_start": '+testData_currentPeriodStart+', "current_period_end": '+testData_currentPeriodEnd+', "ended_at": null, "trial_start": null, "trial_end": null, "canceled_at": null, "quantity": 1, "application_fee_percent": null }, "discount": null, "account_balance": 0, "cards": { "object": "list", "count": 1, "url": "/v1/customers/cus_00000000000000/cards", "data": [ { "id": "cc_2I43Pdw7gh8Qlo", "object": "card", "last4": "4242", "type": "Visa", "exp_month": 12, "exp_year": 2014, "fingerprint": "pmVir47Ti9dNLS50", "customer": "cus_00000000000000", "country": "US", "name": null, "address_line1": null, "address_line2": null, "address_city": null, "address_state": null, "address_zip": null, "address_country": null, "cvc_check": "pass", "address_line1_check": null, "address_zip_check": null } ] }, "default_card": "cc_2I43Pdw7gh8Qlo"}';
		}
	}
	
	public static String testData_cancelSubscription {
		get {
			return '{"object": "subscription", "status": "active", "current_period_start": '+testData_currentPeriodStart+', "start": '+testData_currentPeriodStart+', "current_period_end": '+testData_currentPeriodEnd+', "plan": { "object": "plan", "interval": "month", "currency": "usd", "amount": 2499, "livemode": false, "name": "My Plan", "id": "my_plan5" }, "customer": "cus_00000000000000"}';
		}
	}
	
	public static String testData_updateSubscription {
		get {
			return '{"status": "active","start": '+testData_currentPeriodStart+',"plan": {"currency": "usd","object": "plan","interval": "month","livemode": false,"name": "My Plan","id": "my_plan5","amount": 2499},"object": "subscription","current_period_start": '+testData_currentPeriodStart+',"current_period_end": '+testData_currentPeriodEnd+',"customer": "cus_00000000000000"}';
		}
	}
	
	public static String testData_getCustomers {
		get {
			return '{ "count": 44, "data": [ { "created": 1332963923, "object": "customer", "description": "Cirrus Consulting Group", "account_balance": 0, "subscription": { "status": "active", "current_period_start": '+testData_currentPeriodStart+', "start": '+testData_currentPeriodStart+', "object": "subscription", "plan": { "currency": "usd", "object": "plan", "amount": 0, "interval": "month", "livemode": false, "name": "Cirrus Insight Monthly", "id": "CI_MONTHLY" }, "current_period_end": '+testData_currentPeriodEnd+', "customer": "cus_00000000000000" }, "livemode": false, "id": "cus_00000000000000", "active_card": { "type": "Visa", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "exp_month": 12, "last4": "4242", "cvc_check": "pass", "exp_year": 2012 } }, { "created": 1332963773, "object": "customer", "description": "Cirrus Consulting Group", "account_balance": 0, "subscription": { "status": "active", "current_period_start": 1346182975, "start": 1332963775, "object": "subscription", "plan": { "currency": "usd", "object": "plan", "amount": 0, "interval": "month", "livemode": false, "name": "Cirrus Insight Monthly", "id": "CI_MONTHLY" }, "current_period_end": 1348861375, "customer": "cus_00000000000000" }, "livemode": false, "id": "cus_00000000000000", "active_card": { "type": "Visa", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "exp_month": 12, "last4": "4242", "cvc_check": "pass", "exp_year": 2012 } }, { "created": 1332963575, "object": "customer", "description": "Cirrus Consulting Group", "account_balance": 0, "subscription": { "status": "active", "current_period_start": 1346182776, "start": 1332963576, "object": "subscription", "plan": { "currency": "usd", "object": "plan", "amount": 0, "interval": "month", "livemode": false, "name": "Cirrus Insight Monthly", "id": "CI_MONTHLY" }, "current_period_end": 1348861176, "customer": "cus_JgLR1KUS0ir5iW" }, "livemode": false, "id": "cus_JgLR1KUS0ir5iW", "active_card": { "type": "Visa", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "exp_month": 12, "last4": "4242", "cvc_check": "pass", "exp_year": 2012 } }, { "created": 1332963282, "object": "customer", "description": "Cirrus Consulting Group", "account_balance": 0, "subscription": { "status": "active", "current_period_start": 1346182483, "start": 1332963283, "object": "subscription", "plan": { "currency": "usd", "object": "plan", "amount": 0, "interval": "month", "livemode": false, "name": "Cirrus Insight Monthly", "id": "CI_MONTHLY" }, "current_period_end": 1348860883, "customer": "cus_00000000000000" }, "livemode": false, "id": "cus_00000000000000", "active_card": { "type": "Visa", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "exp_month": 12, "last4": "4242", "cvc_check": "pass", "exp_year": 2012 } }, { "created": 1325799745, "object": "customer", "account_balance": 0, "livemode": false, "id": "cus_uxec2nBO465s03", "active_card": { "address_line1": "", "type": "Visa", "address_zip_check": "pass", "address_line2": "", "address_line1_check": "pass", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "address_zip": "92653", "address_state": "California", "name": "Cirruspath, LLC", "exp_month": 10, "last4": "4242", "cvc_check": "pass", "address_country": "", "exp_year": 2015 } }, { "created": 1325799712, "object": "customer", "account_balance": 0, "livemode": false, "id": "cus_00000000000000", "active_card": { "address_line1": "", "type": "Visa", "address_zip_check": "pass", "address_line2": "", "address_line1_check": "pass", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "address_zip": "92653", "address_state": "California", "name": "Cirruspath, LLC", "exp_month": 10, "last4": "4242", "cvc_check": "pass", "address_country": "", "exp_year": 2015 } }, { "created": 1324201094, "object": "customer", "account_balance": 0, "livemode": false, "id": "cus_00000000000000", "active_card": { "address_line1": "", "type": "Visa", "address_zip_check": "pass", "address_line2": "", "address_line1_check": "pass", "fingerprint": "pmVir47Ti9dNLS50", "object": "card", "address_city": null, "country": "US", "address_zip": "", "address_state": "", "name": "Acme Co", "exp_month": 10, "last4": "4242", "cvc_check": "pass", "address_country": "", "exp_year": 2015 } } ] }';
		}
	}
	
	public static String testData_updateCustomer {
		get {
			return '{'+
				'  "object": "customer",'+
				'  "created": 1375155380,'+
				'  "id": "cus_00000000000000",'+
				'  "livemode": false,'+
				'  "description": "Cirruspath",'+
				'  "email": null,'+
				'  "delinquent": false,'+
				'  "metadata": {'+
				'  },'+
				'  "discount": null,'+
				'  "account_balance": 0,'+
				'  "cards": {'+
				'    "object": "list",'+
				'    "count": 1,'+
				'    "url": "/v1/customers/cus_00000000000000/cards",'+
				'    "data": ['+
				'      {'+
				'        "id": "cc_2I43Pdw7gh8Qlo",'+
				'        "object": "card",'+
				'        "last4": "4242",'+
				'        "type": "Visa",'+
				'        "exp_month": 12,'+
				'        "exp_year": 2014,'+
				'        "fingerprint": "pmVir47Ti9dNLS50",'+
				'        "customer": "cus_00000000000000",'+
				'        "country": "US",'+
				'        "name": null,'+
				'        "address_line1": null,'+
				'        "address_line2": null,'+
				'        "address_city": null,'+
				'        "address_state": null,'+
				'        "address_zip": null,'+
				'        "address_country": null,'+
				'        "cvc_check": "pass",'+
				'        "address_line1_check": null,'+
				'        "address_zip_check": null'+
				'      }'+
				'    ]'+
				'  },'+
				'  "default_card": "cc_2I43Pdw7gh8Qlo"'+
				'}';
		}
	}
	
	public static String testData_error {
		get {
			return '{'+
		'  \"error\": {'+
		'    \"type\": \"invalid_request_error\",'+
		'    \"message\": \"No such customer: cus_00000000000000\"'+
		'  }'+
		'}';
		}
	}

	private static testMethod void testParse() {
		String json = testData_updateCustomer;
		StripeCustomer obj = StripeCustomer.parse(json);
		System.assert(obj != null);
		System.assertEquals(Date.newInstance(2014,12,31), obj.getDefaultCard().expirationDate);
	}

	private static testMethod void testParseError() {
		StripeCustomer obj = StripeCustomer.parse(testData_error);
		System.assert(obj != null);
	}
	
	private static testMethod void test_getCustomers() {
		Test.startTest();
		List<StripeCustomer> customers = StripeCustomer.getCustomers(0, 0);
		System.assertEquals(7, customers.size());
		Test.stopTest();
	}

	private static testMethod void testGrantCoupon() {
		StripeCoupon coupon = StripeCoupon.getCoupon('25OFF');
		StripeCustomer.grantCoupon('cus_00000000000000', coupon);		
	}
	
	private static testMethod void test_updateSubscription() {
		Test.startTest();
		StripeSubscription sub = StripeCustomer.updateSubscription('cus_00000000000000', 'asdf');
		System.assertEquals('active', sub.status);
		Test.stopTest();
	}

	private static testMethod void test_cancelSubscription() {
		Test.startTest();
		StripeSubscription sub = StripeCustomer.cancelSubscription('cus_00000000000000');
		StripeCustomer.cancelSubscription_future('cus_00000000000000');
		System.debug(System.LoggingLevel.INFO, '\n**** sub2: '+sub); 
		System.assertEquals('active', sub.status);
		Test.stopTest();
	}

	private static testMethod void test_getCustomer() {
		Test.startTest();
		testData = testData_getCustomer;
		StripeCustomer customer1 = StripeCustomer.getCustomer('cus_00000000000000');
		System.assertNotEquals(null, customer1.id);
		Test.stopTest();
	}

	private static testMethod void test_getCustomer_error() {
		Test.startTest();
		testData = testData_error;
		StripeCustomer customer1 = StripeCustomer.getCustomer('cus_00000000000000');
		System.assertNotEquals(null, customer1.error.message);
		System.assertEquals('invalid_request_error', customer1.error.stripeType);
		Test.stopTest();
	}

	private static testMethod void test_create() {
		Test.startTest();
		testData = testData_getCustomer;
		StripeCustomer customer1 = StripeCustomer.create('tok_abcdefghijklmn', 'description');
		System.assertNotEquals(null, customer1.id);
		System.assertEquals(1, customer1.cards.stripeData.size());
		StripeCustomer customer2 = StripeCustomer.create('tok_abcdefghijklmn', 'plan', 'description');
		System.assertNotEquals(null, customer2.id);
		StripeCustomer customer3 = StripeCustomer.updateCustomer('cus_00000000000000', 'tok_abcdefghijklmn', 'description');
		System.assertNotEquals(null, customer3.id);
		StripeCustomer customer4 = StripeCustomer.updateCustomer('cus_00000000000000', 'tok_abcdefghijklmn', 'plan', 'description');
		System.assertNotEquals(null, customer4.id);
		Test.stopTest();
	}
	
	public static String testData {
		get {
			return testData == null ? testData_getCustomer : testData;
		}
		set;
	}
	
	private static testMethod void test() {
		new StripeCustomer();
		
		System.assertNotEquals(null, testData_getCustomer);
		System.assertNotEquals(null, testData_getCustomers);
		System.assertNotEquals(null, testData_cancelSubscription);
		System.assertNotEquals(null, testData_updateSubscription);
		System.assertNotEquals(null, testData_updateCustomer);
	}


}