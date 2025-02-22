@isTest
public class ETDI_General_Services_From_Trigger_Test {
 @isTest
    public static void codecoverage1()
    {
        Test.setMock(HttpCalloutMock.class, new ETDI_Services_Mock()); 
        Account acc = new Account(LastName = 'Test', PersonMobilePhone='+971504111111');
        
        insert acc;
        
        Case c = new Case(AccountId=acc.id,Status='New',Subject='Test');
        insert c;       
     
        Map<id,Case> caseMap = new Map<id,Case>();
        caseMap.put(c.id,c);
        Test.startTest();      
           ETDI_General_Services_From_Trigger.validateMobileTFNCallETDI(caseMap); 
       
        Test.stopTest();
    }
}