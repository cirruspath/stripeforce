@isTest
public class StripeWebhookListenerTests {
	
	private static testmethod void testListener() {
		TestStripe.StripeDataSetup();
		
		StripeWebhookListener listener = new StripeWebhookListener();

		System.RestRequest req = new System.RestRequest();
		req.requestBody = Blob.valueOf(StripeEventTests.testData_ChargeSucceeded);
		RestContext.request = req;
		RestContext.response = new System.RestResponse();
		
		Test.startTest();
		try {
			listener.handlePost();
		} catch (StripeEvent.UnknownWebhookException e) {}
		Test.stopTest();
	}
	
	private static testmethod void testHandlerCoverage() {
		System.RestRequest req = new System.RestRequest();
		req.requestBody = Blob.valueOf(StripeEventTests.testData_ChargeSucceeded);
		RestContext.request = req;
		RestContext.response = new System.RestResponse();

		StripeWebhookListener listener = new StripeWebhookListener();
		
		try {
			listener.handle_InvoiceCreated(new StripeInvoice());
		} catch (StripeEvent.UnknownWebhookException e) {}	

		try {
			listener.handle_InvoicePaymentSucceeded(new StripeInvoice());
		} catch (StripeEvent.UnknownWebhookException e) {}	

		try {
			listener.handle_InvoicePaymentFailed(new StripeInvoice());
		} catch (StripeEvent.UnknownWebhookException e) {}	

		try {
			listener.handle_CustomerSubscriptionDeleted(new StripeSubscription());
		} catch (StripeEvent.UnknownWebhookException e) {}	

		try {
			listener.handle_CustomerUpdated(new StripeCustomer());
		} catch (StripeEvent.UnknownWebhookException e) {}	

		try {
			listener.handle_CustomerCardCreated(new StripeCard());
		} catch (StripeEvent.UnknownWebhookException e) {}	

		try {
			listener.handle_ChargeSucceeded(new StripeCharge());
		} catch (StripeEvent.UnknownWebhookException e) {}	

		try {
			listener.handle_ChargeFailed(new StripeCharge());
		} catch (StripeEvent.UnknownWebhookException e) {}	

		try {
			listener.handle_ChargeRefunded(new StripeCharge());
		} catch (StripeEvent.UnknownWebhookException e) {}
		
		listener.createWebhookTask('test', null);	
	}
	
}