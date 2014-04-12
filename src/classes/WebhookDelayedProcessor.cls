global class WebhookDelayedProcessor implements Database.Batchable<sObject> {
	
	private Boolean reschedule = false;
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([
			Select Id, Webhook_Type__c, Webhook_Data__c, Attempts__c, Status__c From Stripe_Webhook__c Where Status__c = 'Pending'
		]);
	}

 	global void execute(Database.BatchableContext BC, List<Stripe_Webhook__c> webhooks) {
		for (Stripe_Webhook__c webhook : webhooks) {
			webhook.Attempts__c += 1;
			System.debug(System.LoggingLevel.INFO, '\n**** Webhook:\n'+webhook.Webhook_Data__c+'\n'); 

			StripeEvent event = StripeEvent.parse(webhook.Webhook_Data__c);
			if (webhook.Webhook_Type__c == 'charge.succeeded') {
				StripeCharge charge = event.stripeData.StripeCharge;
				WebhookListener listener = new WebhookListener(); // this should be the name of your LOCAL listener; not StripeWebhookListener
				
				try {
					listener.handle_ChargeSucceeded(charge, false);
					webhook.Status__c = 'Succeeded';
				} catch (WebhookDelayedProcessor.WebhookDelayedProcessorException e) {
					if (webhook.Attempts__c >= 3) {
						webhook.Status__c = 'Failed';
					}
					reschedule = true;
				} catch (System.Exception e) {
					webhook.Status__c = 'Failed';
					webhook.Error_Message__c = e.getMessage();
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