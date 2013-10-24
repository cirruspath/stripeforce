global class Util {

	global static Boolean isNullOrEmpty(String s) {
		if (s == null || s == '') return true;
		return false;
	}
	
	global static Boolean isNullOrZero(Decimal d) {
		if (d == null || d == 0) return true;
		return false;
	}
	
	global static Boolean isNullOrZero(Integer d) {
		if (d == null || d == 0) return true;
		return false;
	}
	
	global static String coalesce(String s1, String s2) {
		if (isNullOrEmpty(s1)) return s2;
		return s1;
	}
	
	global static Decimal coalesce(Decimal d1, Decimal d2) {
		if (isNullOrZero(d1)) return d2;
		return d1;
	}
	
	global static Integer coalesce(Integer d1, Integer d2) {
		if (isNullOrZero(d1)) return d2;
		return d1;
	}
	
	global static Date getDate(Integer dt) {
		String s = String.valueOf(dt)+'000';
		Long l = Long.valueOf(s);
		return DateTime.newInstance(l).date();
	}

	global static String urlify(Map<String, String> params) {
		String url = '&';
		for (String key : params.keySet()) {
			url += EncodingUtil.urlEncode(key, 'UTF-8') + '=' + EncodingUtil.urlEncode(coalesce(params.get(key), ''), 'UTF-8') + '&';
		}
		return url;
	}

	global static String generateRandomString(Integer length) {
		String allowed = '0123456789abcdefghjkmnpqrstuvwxyz';
		
		String code = '';
		for (Integer i=0; i<length; i++) {
			Integer rand = Math.abs(Math.mod(Crypto.getRandomInteger(), allowed.length()));
			String s = allowed.substring(rand,rand+1);
			if (Math.mod(rand,2) == 0) s = s.toUpperCase();
			code += s;
		}
		
		return code;
	}

	global static String cleanJson(String json) {
		json = json.replaceAll('"object":', '"stripeObject":');
		json = json.replaceAll('"date":', '"stripeDate":');
		json = json.replaceAll('"end":', '"endDate":');
		json = json.replaceAll('"data":', '"stripeData":');
		json = json.replaceAll('"currency":', '"stripeCurrency":');
		json = json.replaceAll('"type":', '"stripeType":');
		
		return json;
	}
	
	private static testMethod void test_cleanJson() {
		Util.cleanJson('test');
	}

	private static testMethod void testUtil() {
		System.assertEquals(true, isNullOrEmpty(''));
		System.assertEquals(true, isNullOrEmpty(null));
		System.assertEquals(false, isNullOrEmpty('a'));
		
		Decimal d = 0, d2 = null;
		System.assertEquals(true, isNullOrZero(d));
		System.assertEquals(true, isNullOrZero(d2));
		System.assertEquals(false, isNullOrZero(d+1));

		Integer i = 0, i2 = null;
		System.assertEquals(true, isNullOrZero(i));
		System.assertEquals(true, isNullOrZero(i2));
		System.assertEquals(false, isNullOrZero(i+1));

		String s = null;
		System.assertEquals('abc', coalesce('abc', 'def'));
		System.assertEquals('def', coalesce(s, 'def'));
		System.assertEquals('def', coalesce('', 'def'));
		
		System.assertEquals(1, coalesce(d, 1));
		System.assertEquals(2, coalesce(d+2, 1));

		System.assertEquals(1, coalesce(i, 1));
		System.assertEquals(2, coalesce(i+2, 1));

		System.assertEquals(Date.newInstance(2012, 1, 17), getDate(1326853478));
		
		String urlified = urlify(new Map<String, String>{'a'=>'1','b'=>'2'});
		System.assert(urlified=='&a=1&b=2&'||urlified=='&b=2&a=1&', urlified);
		
		System.assert(generateRandomString(10).length() == 10);
	}
}