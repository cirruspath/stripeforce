global class StripeCard {
	global String stripeType;
	global String country;
	global Integer exp_month;
	global String fingerprint;
	global Integer exp_year;
	global String last4;
	global String stripeObject;
	global String id;
	global String name;
	global StripeError error;
	
	global Date expirationDate {
		get {
			Date d = Date.newInstance(this.exp_year, this.exp_month, Date.daysInMonth(this.exp_year, this.exp_month));
			return d;
		}
	}
	
	private static testMethod void test() { new StripeCard(); }
}