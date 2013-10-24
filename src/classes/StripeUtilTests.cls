@isTest
private class StripeUtilTests {

	private static testMethod void test_cleanJson() {
		StripeUtil.cleanJson('test');
	}

	private static testMethod void testUtil() {
		System.assertEquals(true, StripeUtil.isNullOrEmpty(''));
		System.assertEquals(true, StripeUtil.isNullOrEmpty(null));
		System.assertEquals(false, StripeUtil.isNullOrEmpty('a'));
		
		Decimal d = 0, d2 = null;
		System.assertEquals(true, StripeUtil.isNullOrZero(d));
		System.assertEquals(true, StripeUtil.isNullOrZero(d2));
		System.assertEquals(false, StripeUtil.isNullOrZero(d+1));

		Integer i = 0, i2 = null;
		System.assertEquals(true, StripeUtil.isNullOrZero(i));
		System.assertEquals(true, StripeUtil.isNullOrZero(i2));
		System.assertEquals(false, StripeUtil.isNullOrZero(i+1));

		String s = null;
		System.assertEquals('abc', StripeUtil.coalesce('abc', 'def'));
		System.assertEquals('def', StripeUtil.coalesce(s, 'def'));
		System.assertEquals('def', StripeUtil.coalesce('', 'def'));
		
		System.assertEquals(1, StripeUtil.coalesce(d, 1));
		System.assertEquals(2, StripeUtil.coalesce(d+2, 1));

		System.assertEquals(1, StripeUtil.coalesce(i, 1));
		System.assertEquals(2, StripeUtil.coalesce(i+2, 1));

		System.assertEquals(Date.newInstance(2012, 1, 17), StripeUtil.getDate(1326853478));
		
		String urlified = StripeUtil.urlify(new Map<String, String>{'a'=>'1','b'=>'2'});
		System.assert(urlified=='&a=1&b=2&'||urlified=='&b=2&a=1&', urlified);
		
		System.assert(StripeUtil.generateRandomString(10).length() == 10);
	}

}