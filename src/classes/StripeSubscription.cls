global class StripeSubscription {
	global String status;
	global Integer start;
	global Integer current_period_start;
	global Plan plan;
	global Integer current_period_end;
	global String customer;
	global StripeError error;
	global SubscriptionPeriod period;

	global class SubscriptionPeriod {
		global Integer start;
		global Integer endDate;
	}

	global class Plan {
		global String stripeCurrency;
		global String interval;
		global Boolean livemode;
		global String name;
		global String id;
		global Integer amount;
	}

	public static StripeSubscription parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = Util.cleanJson(json);
		return (StripeSubscription) System.JSON.deserialize(json, StripeSubscription.class);
	}
	
	private static testMethod void test() {
		new StripeSubscription();
		new SubscriptionPeriod();
		new Plan();
	}
}