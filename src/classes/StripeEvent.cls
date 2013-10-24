global class StripeEvent {
	
	global String stripeType;
	global Integer created;
	global Integer pending_webhooks;
	global EventData stripeData;
	global Boolean livemode;
	global String id;
	global StripeError error;
	
	private static Map<String, String> supported_events = new Map<String, String>{
		'invoice.created' => 'StripeInvoice', 
		'invoice.payment_succeeded' => 'StripeInvoice', 
		'invoice.payment_failed' => 'StripeInvoice', 
		'customer.subscription.deleted' => 'StripeSubscription',
		'customer.updated' => 'StripeCustomer',
		'charge.succeeded' => 'StripeCharge',
		'charge.failed' => 'StripeCharge',
		'charge.refunded' => 'StripeCharge',
		'ping' => 'object' // leave it alone
	};

	global class EventData {
		// One of the following members will be populated, depending on the event type
		global StripeCharge StripeCharge;
		global StripeInvoice StripeInvoice;
		global StripeSubscription StripeSubscription;
		global StripeCustomer StripeCustomer;

		global PreviousAttributes previous_attributes;
	}
	
	global class PreviousAttributes {
		global StripeCard active_card;
	}

	public static StripeEvent parse(String json) {
		json = rationalize(json);
		json = StripeUtil.cleanJson(json);
		
		System.debug(System.LoggingLevel.INFO, '\n**** StripeEvent Parsed JSON:\n'+json); 
		return (StripeEvent) System.JSON.deserialize(json, StripeEvent.class);
	}
	
	// changes the generic 'object' property to a typed property that Apex can serialize into the appropriate object based on the event type
	// Accepts the raw JSON string from the webhook listener
	private static String rationalize(String json) {
		// identify the type of event
		String event_type = json.substring(
			json.indexOf('"type"')+9,
			json.indexOf('"', json.indexOf('"type"')+9)
		);
		System.debug(System.LoggingLevel.INFO, '\n**** event type: '+event_type);

		String data_member = supported_events.get(event_type);
		if (data_member == null) throw new UnknownWebhookException('Unknown webhook event');
		json = json.replaceFirst('"object":\\s?\\{',  '"'+data_member+'": {');
		
		return json;
	}

	
	global class UnknownWebhookException extends Exception {}
}