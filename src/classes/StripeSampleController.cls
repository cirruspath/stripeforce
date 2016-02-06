public class StripeSampleController {
    
    public boolean isStep1 {public get; set;}
    public boolean isStep2 {public get; set;}
    public Account acc {get; set;}
    public Contact cont {get; set;}
    public final String StripePublicKey = 'pk_test_mHVVylBD66Fk6kUmPKifGc2G';
    protected final String StripeSecretKey = 'sk_test_Mvypcczfz1ypm8YyMwOX9eWd';
    
    private Map<String, String> parameters;
    
    public StripeSampleController () {
        this.isStep1 = true;
        this.acc = new Account();
        this.cont = new Contact();
    }
    
    public string getStripePk () {
        return this.StripePublicKey;
    }
    
    public void save() {
        
        insert this.Acc;
        this.Cont.AccountId = this.Acc.Id;
        this.Cont.LastName = this.Acc.Name; // and again, name should better be split, looked up etc.
        insert this.Cont;
        
        // drops all post variables into a map of strings
        this.parameters = ApexPages.currentPage().getParameters();
        
        // controls which page blocks to show
        this.isStep2 = true;
        this.isStep1 = false;
        
        Map<String, String> properties = new Map<String, String>();
        Map<String, String> metadata = new Map<String, String>();
        
        StripeSampleController.createCustomerAndCharge(this.acc.Id, this.cont.id, this.parameters.get('stripeToken'));        
    }

    @future (callout=true)
    private static void createCustomerAndCharge(string acc, String cont, String token) {

        Account a = new Account();
        Contact c = new Contact();
        StripeCustomer customer = new StripeCustomer();
        StripeCharge charge = new StripeCharge();

        Map<String, String> properties = new Map<String, String>();
        Map<String, String> metadata = new Map<String, String>();
        
        try {
            a = [SELECT id, StripeCustomerID__c FROM Account WHERE Id = : acc LIMIT 1];
            c = [SELECT id, Email FROM Contact WHERE Id = : cont LIMIT 1];

            properties.put('source', token);
            properties.put('email', c.Email);
            properties.put('description','Sample Payment Form');
        
            metadata.put('SFDCAccount', a.Id);
            metadata.put('SGDCContact', c.Id);

            customer = StripeCustomer.create(properties, metadata);
            a.StripeCustomerID__c = customer.Id;

            Integer amount = 100;
             // clearing properties to set up required and optional fields for charges
            properties = new Map<String, String>();
            properties.put('customer', customer.id);
            properties.put('currency', 'eur');

            charge = StripeCharge.create(customer.Id, amount, properties, metadata);
        }         
        
        catch (DmlException d) {
            System.debug('DML Exception ' + d.getMessage());
        }

        catch (StripeException e) {
            System.debug('Stripe Exception ' + e.getMessage());
        }
        
        catch (Exception e) {
            System.debug('Exception ' + e.getMessage());
        }
        finally {
            if (a != null) {
                update a; 
                }
            if (c != null) {
                update c;
                }
        } 
    }

    public string getToken () {
        return JSON.serialize(this.parameters);
    }

}