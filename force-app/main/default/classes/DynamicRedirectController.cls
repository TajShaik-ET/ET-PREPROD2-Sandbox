public with sharing class DynamicRedirectController {
    public String redirectURL { get; set; }
    
    public DynamicRedirectController() {
        // Get the Record ID from the URL parameter (sent in the email)
        Id recordId = ApexPages.currentPage().getParameters().get('recordId');
        
        // Check if the user is logged into Salesforce Lightning or the Community Portal
        if (URL.getOrgDomainURL().toExternalForm().contains('lightning.force.com')) {
            // Redirect to Salesforce Lightning record URL
            redirectURL = 'https://icrm--preprod2.sandbox.lightning.force.com/' + recordId;
        } else {
            // Redirect to Community Portal record URL
            redirectURL = 'https://icrm--preprod2.sandbox.my.site.com/Business/s/detail/' + recordId;
        }
    }
}