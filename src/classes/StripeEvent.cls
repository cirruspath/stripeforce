global class StripeEvent {
	
	global String 	stripeType;
	global Integer 	created;
	global EventData stripeData;
	global Boolean 	livemode;
	global String 	id;
	global StripeError error;
	global String 	stripeObject;
	global String 	apiVersion;
	global Integer 	pendingWebhooks;
	global String 	request;
	
	// map the event to the stripeData object that will be filled
	private static Map<String, String> supported_events = new Map<String, String>{
		'invoice.created' => 'StripeInvoice', 
		'invoice.payment_succeeded' => 'StripeInvoice',
		'invoice.payment_failed' => 'StripeInvoice',
		'customer.subscription.deleted' => 'StripeSubscription',
		'customer.created' => 'StripeCustomer',
		'customer.updated' => 'StripeCustomer',
		'customer.card.created' => 'StripeCard',
		'customer.card.updated' => 'StripeCard',
		'charge.succeeded' => 'StripeCharge',
		'charge.failed' => 'StripeCharge',
		'charge.refunded' => 'StripeCharge',
		'ping' => 'object' // leave it alone
	};

	// Fix to serialize values that formerly broke the webservice
	// SOBCRM-38
	// https://interaktiv.jira.com/projects/SOBCRM/issues/SOBCRM-38
	// DSt 2016-02-05

	global class PreviousRefunds {
		StripeCharge.Refunds [] stripeData;
		Integer total_count;

	}

	global class PreviousAttributes {
		Integer amount_refunded;
		Boolean refunded;
        PreviousRefunds refunds;
        String default_card;
	}

	global class EventData {
		// One of the following members will be populated, depending on the event type
		global StripeCharge StripeCharge;
		global StripeInvoice StripeInvoice;
		global StripeSubscription StripeSubscription;
		global StripeCustomer StripeCustomer;
		global StripeCard StripeCard;

		//global Map<String, String> previous_attributes; 
		global PreviousRefunds previous_attributes; 
	}
	
	// SOBCRM 38 --> 
	public static StripeEvent parse(String json) {
		json = rationalize(json);
        json = StripeUtil.cleanJson(json);
        
		System.debug(System.LoggingLevel.INFO, '\n**** StripeEvent Parsed JSON:\n'+json);
        StripeEvent oStripeEvent = (StripeEvent) System.JSON.deserialize(json, StripeEvent.class);
        
        return oStripeEvent;
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