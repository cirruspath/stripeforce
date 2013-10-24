@isTest
private class TestStripe {

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
		
    
}