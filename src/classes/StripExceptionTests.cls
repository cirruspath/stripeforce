@isTest
private class StripExceptionTests {
	
    @isTest
    private static void testStripeException() {
        Test.startTest();
        StripeError err = new StripeError();
        err.code = '123';
        err.message = 'void';
        err.param = 'none';
        err.stripeType = 'Charge';
        
        StripeException ex = new StripeException(err);
        String s = ex.getMessage();
        
        StripeError res = ex.getError();
        
        Test.stopTest();
    }
        
   
}