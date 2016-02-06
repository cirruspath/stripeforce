@isTest
public class TestStripe {

	// StripeCard
	private static testMethod void testStripeCard() { 
		new StripeCard(); 
	}

	private static testMethod void testStripeError() {
		new StripeError();
	}
		
	private static testMethod void testStripeException() {
		new StripeException();
		StripeError err = new StripeError();
		err.message = 'abc';
		StripeException ex = new StripeException(err);
		System.assertEquals(err.message, ex.getMessage());
		ex.getError();
	}
	
	private static testmethod void testStripeAPI() {
		Test.startTest();
		System.assertEquals(null, StripeAPI.ApiKey);
		System.assertEquals(null, StripeAPI.PublishableKey);
		System.assertEquals(true, StripeAPI.isTest);
		System.assertEquals(false, StripeAPI.isWebhookProcessorRunning());
		
		TestStripe.StripeDataSetup();
		System.assertEquals(false, StripeAPI.isTest);
		System.assertEquals('xyz', StripeAPI.ApiKey);
		System.assertEquals('456', StripeAPI.PublishableKey);
		System.assertEquals(false, StripeAPI.isWebhookProcessorRunning());
		
		Stripe_Settings__c s = Stripe_Settings__c.getOrgDefaults();
		s.Is_Live_Environment__c = false;
		update s;
		
		System.assertEquals(true, StripeAPI.isTest);
		System.assertEquals('123', StripeAPI.ApiKey);
		System.assertEquals('def', StripeAPI.PublishableKey);
		Test.stopTest();
	}
		
	public static void StripeDataSetup() {
		Stripe_Settings__c s = new Stripe_Settings__c();
		s.Is_Live_Environment__c = true;
		s.Stripe_Secret_Live_Key__c = 'xyz';
		s.Stripe_Secret_Test_Key__c = '123';
		s.Stripe_Publishable_Test_Key__c = 'def';
		s.Stripe_Publishable_Live_Key__c = '456';
		insert s;		
	}
	
  
}