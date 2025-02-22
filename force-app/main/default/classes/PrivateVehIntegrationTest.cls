@isTest
public class PrivateVehIntegrationTest {
   @isTest
    public static void MOTO_PrivateVehTest(){
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        string AccNumber='1384772';
        
      
        Account acc = new Account(name='Test Account');
        insert acc;
        //List<Opportunity> lstopp =[select id from opportunity where accountid=: acc.id];
        
        opportunity Opp= new opportunity();
        opp.Name='DemoTest';
        opp.AccountId=acc.id;
        opp.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
        opp.Type='Growth Business';
        opp.CloseDate=Date.newInstance(2022,12,15);
        opp.StageName='Service Booking';
        
        insert opp;
        
        Test.startTest();
        system.enqueueJob(new PrivateVehIntegration(AccNumber,opp.Id));
        Test.stopTest();
    }
}