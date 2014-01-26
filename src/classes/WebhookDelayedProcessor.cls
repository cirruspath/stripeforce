global class WebhookDelayedProcessor implements Database.Batchable<sObject> {
	
	private Boolean reschedule = false;
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([
			Select Id, Webhook_Type__c, Webhook_Data__c, Attempts__c From Stripe_Webhook__c
				Where Status__c = 'Pending'
		]);
	}

 	global void execute(Database.BatchableContext BC, List<Stripe_Webhook__c> webhooks) {
		for (Stripe_Webhook__c webhook : webhooks) {
			webhook.Attempts__c += 1;
			System.debug(System.LoggingLevel.INFO, '\n**** Webhook: '+webhook); 

			if (webhook.Webhook_Type__c == 'charge.succeeded') {
				StripeCharge charge = (StripeCharge) JSON.deserialize(webhook.Webhook_Data__c, StripeCharge.class);
				StripeWebhookListener listener = new StripeWebhookListener();
				
				try {
					listener.handle_ChargeSucceeded(charge, false);
					webhook.Status__c = 'Succeeded';
				} catch (WebhookDelayedProcessor.WebhookDelayedProcessorException e) {
					if (webhook.Attempts__c >= 3) {
						webhook.Status__c = 'Failed';
					}
					reschedule = true;
				}
			}
		}
		
		update webhooks;		
	}
	
	global void finish(Database.BatchableContext BC) {
		if (reschedule) {
			StripeAPI.startWebhookProcessor();
		}
	}
	
	global class WebhookDelayedProcessorException extends System.Exception {}

}