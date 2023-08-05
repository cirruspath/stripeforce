@isTest
private class StripeUtilTests {

	private static testMethod void test_cleanJson() {
		StripeUtil.cleanJson('test');
	}

	private static testMethod void testUtil() {
		System.assertEquals('abc', StripeUtil.blankValue('abc', 'def'));
		System.assertEquals('def', StripeUtil.blankValue(s, 'def'));
		System.assertEquals('def', StripeUtil.blankValue('', 'def'));
		
		System.assertEquals(Date.newInstance(2012, 1, 17), StripeUtil.getDate(1326853478));
		
		String urlified = StripeUtil.urlify(new Map<String, String>{'a'=>'1','b'=>'2'});
		System.assert(urlified=='&a=1&b=2&'||urlified=='&b=2&a=1&', urlified);
	}

}
