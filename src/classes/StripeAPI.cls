global class StripeAPI {

	global static String ApiKey {
		get {
			Stripe_Settings__c s = Stripe_Settings__c.getInstance();
			if (s != null) {
				if (StripeAPI.isTest) {
					return s.Stripe_Secret_Test_Key__c;
				} else {
					return s.Stripe_Secret_Live_Key__c;
				}
			}
			return null;
		}
	}
	
	global static String PublishableKey {
		get {
			Stripe_Settings__c s = Stripe_Settings__c.getInstance();
			if (s != null) {
				if (StripeAPI.isTest) {
					return s.Stripe_Publishable_Test_Key__c;
				} else {
					return s.Stripe_Publishable_Live_Key__c;
				}
			}
			return null;
		}
	}
	
	global static Boolean isWebhookProcessorRunning() {
		Stripe_Settings__c s = Stripe_Settings__c.getOrgDefaults();
		if (s != null) {
			if (s.Delayed_Webhook_Processor_ID__c == null) {
				return false;
			} else {
				System.debug(System.LoggingLevel.INFO, '\n**** stripe settings: '+s);
				try { 
					CronTrigger sched = [Select State, NextFireTime From CronTrigger Where Id =: s.Delayed_Webhook_Processor_ID__c];
					if (sched.NextFireTime != null) return true;
				} catch (System.QueryException e) {}
			}
		}

		return false;
	}
	
	global static void startWebhookProcessor() {
		if (isWebhookProcessorRunning() == false) {
			WebhookDelayedProcessor proc = new WebhookDelayedProcessor();
			Id jobId = System.scheduleBatch(proc, 'delayed webhook processor', 5);
			
			Stripe_Settings__c s = Stripe_Settings__c.getOrgDefaults();
			s.Delayed_Webhook_Processor_ID__c = jobId;
			update s;
		}
	}
	
	global static Boolean isTest {
		get {
			Stripe_Settings__c s = Stripe_Settings__c.getInstance();
			if (s != null) {
				return !s.Is_Live_Environment__c;
			}
			return true;
		}
	}
	
}