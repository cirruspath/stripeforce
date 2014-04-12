@isTest
public class StripeInvoiceItemResponseTests {

	private static testMethod void testParse() {
		StripeInvoiceItemResponse obj = StripeInvoiceItemResponse.parse(testData_InvoiceItem);
		System.assert(obj != null);
		System.assert(obj.error == null);
		
		obj = StripeInvoiceItemResponse.parse(testData_InvoiceItemError);
		System.assert(obj != null);
		System.assert(obj.error != null);
		System.assertEquals('No such customer: cus_00000000000000', obj.error.message);
		new StripeInvoiceItemResponse();
	}
	
	public static String testData_InvoiceItem {
		get {
			String json = '{'+
			'  "livemode": false,'+
			'  "invoice_id": "in_u19lZAWIe9AIl1",'+
			'  "proration": false,'+
			'  "object": "invoiceitem",'+
			'  "date": 1325481271,'+
			'  "id": "ii_MNKieKWu5f6QH6",'+
			'  "currency": "usd",'+
			'  "amount": 0,'+
			'  "customer": "cus_0kxRC2ZqGdmDgN",'+
			'  "description": "%7B%22users%22%3A25%2C%22license%22%3A%22a003000000HAR4eAAH%22%2C%22account%22%3A%220013000000ougduAAA%22%2C%22contact%22%3A%220033000000w3xZhAAI%22%7D"'+
			'}';
			return json;
		}
	}
	
	public static String testData_InvoiceItemError {
		get {
			String json = '{'+
  			'"error": {'+
    		'"message": "No such customer: cus_00000000000000",'+
    		'"param": "customer",'+
    		'"type": "invalid_request_error"'+
    	'}}';
			return json;
		}
	}


}