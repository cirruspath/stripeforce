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

}