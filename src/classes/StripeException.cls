public class StripeException extends Exception {
	public StripeError error;
	
	public StripeException(StripeError err) {
		this.error = err;
	}
	
	public override String getMessage() {
		return this.error.message;
	}
	
	public StripeError getError() {
		return this.error;
	}

	private static testMethod void test() {
		new StripeException();
		StripeError err = new StripeError();
		err.message = 'abc';
		StripeException ex = new StripeException(err);
		System.assertEquals(err.message, ex.getMessage());
		ex.getError();
	} 
}