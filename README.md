Stripe API Client Library for Force.com
========================================

[Stripe](http://stripe.com) is a fantastic developer-friendly payment processing platform. This client library was originally developed by Cirruspath in 2012. Please send comments, pull requests, and questions here on github.

Stripe API Documentation
------------------------
Read up: https://stripe.com/docs/api

Listening for Webhooks
----------------------
To implement a listener for Stripe webhooks, start with the template class below. This class isn't included in the repo to help avoid contributors' own webhook implementations from unintentionally gettting committed to this public repo or from being overwritten when they pull in the latest code.

Note that not ALL Stripe webhooks are currently supported. However, support for additional webhooks can easily be added to the StripeWebhookListener class. If you make changes to it, please also include the corresponding updates to this webhook implementation class.

```
@RestResource(urlMapping='/stripe/webhooks/v1/*')
global class WebhookListener extends StripeWebhookListener {

	@HttpPost
	global static void doPost() {
		WebhookListener listener = new WebhookListener();
		listener.handlePost();
	}

	//
	// SUPPORTED WEBHOOKS
	//

	// Handle the customer.updated webhook
	// Create a new Payment Method when a card changes, and update the license
	public override void handle_CustomerUpdated(StripeCustomer customer) {
		throw new StripeEvent.UnknownWebhookException('Not implemented');
	}
	
	// Handle the charge.succeeded webhook
	// Create the payment record, if it's not already present
	public override void handle_ChargeSucceeded(StripeCharge charge) {
		handle_ChargeSucceeded(charge, true);
	}

	public void handle_ChargeSucceeded(StripeCharge charge, Boolean allowDelayedProcessing) {
		throw new StripeEvent.UnknownWebhookException('Not implemented');
	}

	// Handle the charge.failed webhook
	// Create the 'failed' payment record, if it's not already present
	public override void handle_ChargeFailed(StripeCharge charge) {
		throw new StripeEvent.UnknownWebhookException('Not implemented');
	}

	// Handle the charge.refunded webhook
	// Update the payment record
	public override void handle_ChargeRefunded(StripeCharge charge) {
		throw new StripeEvent.UnknownWebhookException('Not implemented');
	}

	// Handle the invoice.created webhook
	public override void handle_InvoiceCreated(StripeInvoice invoice) {
		throw new StripeEvent.UnknownWebhookException('Not implemented');
	}
	
	// Handle the invoice.payment_succeeded webhook
	public override void handle_InvoicePaymentSucceeded(StripeInvoice invoice) {
		throw new StripeEvent.UnknownWebhookException('Not implemented');
	}
	
	// Handle the invoice.payment_failed webhook
	public override void handle_InvoicePaymentFailed(StripeInvoice invoice) {
		throw new StripeEvent.UnknownWebhookException('Not implemented');
	}

	// Handle the customer.subscription.deleted webhook
	public override void handle_CustomerSubscriptionDeleted(StripeSubscription subscription) {
		throw new StripeEvent.UnknownWebhookException('Not implemented');
	}
	
}
```

WebhookDelayedProcessor
-----------------------
There is often an "indexing delay" after inserting (or updating) records in Salesforce. If your Webhook implementation relies on finding existing records to complete its task (i.e. searching for the account that corresponds to a new Stripe customer), you may find the WebhookDelayedProcessor job useful. 

In the example below, after searching for a 'license', we're unable to find one. We check to ensure that delayed processing is allowed (an implementation choice), and we create a `Stripe_Webhook__c` record with the webhook details. A scheduled job will then re-run the appropriate webhook handler up to 3 times, waiting 5 minutes beteween attempts -- adequate time for Salesforce indexing to catch up.

```
public void handle_ChargeSucceeded(StripeCharge charge, Boolean allowDelayedProcessing) {
...
		if (license == null) {
			if (allowDelayedProcessing) {
				System.debug(System.LoggingLevel.INFO, '\n**** License Not Found; Delay Webhook Processing'); 
				Stripe_Webhook__c webhook = new Stripe_Webhook__c(
					Webhook_Type__c = 'charge.succeeded',
					Webhook_Data__c = JSON.serializePretty(charge)
				);
				insert webhook;
				return;
			} 
				
			throw new WebhookDelayedProcessor.WebhookDelayedProcessorException();
		}
...
}

```

Note that delayed processing is currently only implemented for the `charge.succeeded` webhook, but extending the concept to other webhooks (or making it generic) is not difficult.
