trigger StripeWebhookAfter on Stripe_Webhook__c (after insert) {

	if (Trigger.isInsert) {
		StripeAPI.startWebhookProcessor();		
	}

}