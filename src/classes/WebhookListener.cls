@RestResource(urlMapping='/stripe/webhooks/v1/*')
global class WebhookListener extends StripeWebhookListener {
	/**
	 * DO NOT PACKAGE THIS CLASS
	 * This class is an example implementation of the listener clients would have to create
	 *
	 */

	@HttpPost
	global static void doPost() {
		WebhookListener listener = new WebhookListener();
		listener.handlePost();
	}
	
	// Handle the invoice.created webhook
	public override void handle_InvoiceCreated(StripeInvoice invoice) {
		throw new StripeException('Not implemented');
	}
	
	// Handle the invoice.payment_succeeded webhook
	public override void handle_InvoicePaymentSucceeded(StripeInvoice invoice) {
		throw new StripeException('Not implemented');
	}
	
	// Handle the invoice.payment_failed webhook
	public override void handle_InvoicePaymentFailed(StripeInvoice invoice) {
		throw new StripeException('Not implemented');
	}

	// Handle the customer.subscription.deleted webhook
	public override void handle_CustomerSubscriptionDeleted(StripeSubscription subscription) {
		throw new StripeException('Not implemented');
	}
	
	// Handle the customer.updated webhook
	public override void handle_CustomerUpdated(StripeCustomer customer) {
		throw new StripeException('Not implemented');
	}
	
	// Handle the charge.succeeded webhook
	public override void handle_ChargeSucceeded(StripeCharge charge) {
		return;
	}

	// Handle the charge.failed webhook
	public override void handle_ChargeFailed(StripeCharge charge) {
		throw new StripeException('Not implemented');
	}

	// Handle the charge.refunded webhook
	public override void handle_ChargeRefunded(StripeCharge charge) {
		throw new StripeException('Not implemented');
	}

}