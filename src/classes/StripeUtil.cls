global class StripeUtil {

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
	
}