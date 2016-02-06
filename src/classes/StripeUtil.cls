global class StripeUtil {

	global static String blankValue(String s1, String s2) {
		if (s1 == null || s1 == '') return s2;
		return s1;
	}
	
	global static Date getDate(Integer dt) {
		String s = String.valueOf(dt)+'000';
		Long l = Long.valueOf(s);

		return DateTime.newInstance(l).date();
	}

	/*global static String urlify(Map<String, String> params) {
		String url = '&';
		for (String key : params.keySet()) {
			url += EncodingUtil.urlEncode(key, 'UTF-8') + '=' + EncodingUtil.urlEncode(blankValue(params.get(key), ''), 'UTF-8') + '&';
		}
		return url;
	}*/

	global static String urlify(Map<String, String> params) {
		String url = '?';
		for (String key : params.keySet()) {
			url += EncodingUtil.urlEncode(key, 'UTF-8') + '=' + EncodingUtil.urlEncode(blankValue(params.get(key), ''), 'UTF-8') + '&';
		}
		return url;
	}

	global static String cleanJson(String json) {
		json = json.replaceAll('"object":', '"stripeObject":');
		json = json.replaceAll('"date":', '"stripeDate":');
		json = json.replaceAll('"end":', '"endDate":');
		json = json.replaceAll('"data":', '"stripeData":');
		json = json.replaceAll('"currency":', '"stripeCurrency":');
		json = json.replaceAll('"type":', '"stripeType":');

		json = json.replaceAll('"customer":\\s?"cus_', '"customer_id": "cus_');
		json = json.replaceAll('"invoice":\\s?"in_', '"invoice_id": "in_');
		
		return json;
	}
	
}