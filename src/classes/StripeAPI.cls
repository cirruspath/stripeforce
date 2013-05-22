global class StripeAPI {

	global static String ApiKey {
		get {
			Stripe_Settings__c s = Stripe_Settings__c.getInstance();
			if (s != null) {
				if (StripeAPI.isTest) {
					return s.Stripe_Test_Key__c;
				} else {
					return s.Stripe_Live_Key__c;
				}
			}
			return null;
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