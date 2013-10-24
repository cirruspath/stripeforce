global class StripeInvoiceItemResponse {

	global Boolean livemode;
	global String invoice_id;
	global Boolean proration;
	global Integer stripeDate;
	global String id;
	global String stripeCurrency; 
	global Integer amount;
	global String customer;
	global String description;
	global StripeError error;
	
	global static StripeInvoiceItemResponse parse(String json) {
		json = StripeUtil.cleanJson(json);
		return (StripeInvoiceItemResponse) System.JSON.deserialize(json, StripeInvoiceItemResponse.class);
	}
	
}