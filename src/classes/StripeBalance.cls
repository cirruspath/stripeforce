global class StripeBalance {
    
    global String	SripeObject;
    global StripeTransaction[]	available;
    global StripeTransaction[]	pending;
    global Boolean	livemode;
    
    global class StripeBalanceTransaction {
        global string	id;
		global string 	stripeObject;
        global integer	amount;
        global string	timestamp;
        global string 	StripeCurrency;
        global string	description;
        global integer	fee;
        global String[]	fee_details;
        global integer	net;
        global string	source;
        global String[]	sourced_transfers; // child attributes
        global String	status;
        global String	type;
     }
    
    global class stripeTransaction {
        global integer	amount;
        global string	stripeCurrency;
    }
    
    global class StripeFeeDetails {
        global integer	amount;
        global string 	StripeCurrency;
        global string 	description;
        global string 	type;
 		global integer	net;
		global string	source;
        global Map<String, String>	sourced_transfers; // TODO: Sourced Transfers object
    }

}