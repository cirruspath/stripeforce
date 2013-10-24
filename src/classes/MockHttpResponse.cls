public class MockHttpResponse implements HttpCalloutMock {
	private String responseBody;
	private Integer statusCode = 200;
	private String contentType = 'application/json';
	
	public MockHttpResponse(String responseBody) {
		this.responseBody = responseBody;
	}
	
	public MockHttpResponse(String responseBody, Integer statusCode) {
		this.responseBody = responseBody;
		this.statusCode = statusCode;
	}
	
	public MockHttpResponse(String responseBody, Integer statusCode, String contentType) {
		this.responseBody = responseBody;
		this.statusCode = statusCode;
		this.contentType = contentType;
	}
	
	public HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', this.contentType);
		res.setBody(this.responseBody);
		res.setStatusCode(this.statusCode);
		return res;
	}
	
//	private static testMethod void test() {
//		new MockHttpResponse('asdf');
//		new MockHttpResponse('asdf', 200);
//		new MockHttpResponse('asdf', 200, 'application/json');
//	}
}