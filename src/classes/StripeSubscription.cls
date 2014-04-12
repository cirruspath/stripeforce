global class StripeSubscription {
	global String status; // 'trialing', 'active', 'past_due', 'canceled', or 'unpaid'
	global Integer start;
	global StripePlan plan;
	global String customer_id;
	global Integer quantity;
	global Boolean cancel_at_period_end;
	global Integer current_period_start;
	global Integer current_period_end;
	global Integer ended_at; 
	global Integer trial_start; 
	global Integer trial_end;
	global Integer canceled_at;
	global StripeError error;

	public static StripeSubscription parse(String json) {
		// rough string replacement to simplify json parsing and avoid Apex reserved words
		json = StripeUtil.cleanJson(json);
		return (StripeSubscription) System.JSON.deserialize(json, StripeSubscription.class);
	}
	
}