global class StripeError {
	global String stripeType;
	global String param;
	global String message;
	global String code;
	
	private static testMethod void test() {
		new StripeError();
	}
}