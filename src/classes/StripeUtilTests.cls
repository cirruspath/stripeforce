@isTest
private class StripeUtilTests {

	private static testMethod void test_cleanJson() {
		StripeUtil.cleanJson('test');
	}

	private static testMethod void testUtil() {
		
		List<Profile> prof = [Select id From Profile where Name='Standard User'];

        	User u = new User(
            	FirstName = 'John', 
            	LastName = 'Doe',
            	Username = 'john.doe.test@testcase.com',
            	Email = 'john.doe.test@testcase.com', 
            	IsActive = true,
            	Alias = 'jdoe', 
            	TimeZoneSidKey = 'GMT', 
            	LocaleSidKey = 'en_US', 
            	EmailEncodingKey = 'ISO-8859-1', 
            	LanguageLocaleKey = 'en_US', 
            	ProfileId = prof[0].id);

        	insert U;
		
		system.runAs(U){ 
			String s = null; 
			System.assertEquals('abc', StripeUtil.blankValue('abc', 'def'));
			System.assertEquals('def', StripeUtil.blankValue(s, 'def'));
			System.assertEquals('def', StripeUtil.blankValue('', 'def'));
		
        		// 1326853478 converts to Wed, 18 Jan 2012 02:24:38 GMT
			System.assertEquals(Date.newInstance(2012, 1, 18), StripeUtil.getDate(1326853478));
		
			String urlified = StripeUtil.urlify(new Map<String, String>{'a'=>'1','b'=>'2'});
        	
        		// assertion wasn't properly written
			System.assert(urlified=='?a=1&b=2&'||urlified=='?b=2&a=1&');			
		}

	}

}
