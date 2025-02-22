@isTest
public class GIN_InsurancePolicyTrgHandlerTest {
   
    private static testmethod void createNewPolicy(){
        
        GI_General_Insurance_Policy__c p = new GI_General_Insurance_Policy__c();
        
         p.Insurance_Type__c = 'Property All Risk';
         p.Status__c = 'Active';
         Insert p;
        
        GI_General_Insurance_Policy__c newp = new GI_General_Insurance_Policy__c();
        newp.Insurance_Type__c = 'Property All Risk';
        newp.Status__c = 'New';
        newp.Last_Insurance_Policy__c =p.Id;
        Insert newp;
        newp.Status__c = 'Active';
        update newp;
        
    }
}