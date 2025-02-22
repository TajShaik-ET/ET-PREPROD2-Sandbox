@isTest
public class ETSALES_GONOGOControllerTest {
    static testMethod void insertNewOpportunity(){
        test.startTest();
        Account acc= new Account();
        acc.name='Test Account';
        Insert acc;

        Id oppRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Leasing').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = oppRecordType;
        opp.Name = 'Test Opportunity';
        opp.AccountId = acc.Id;
        opp.Type = 'New Business';
        opp.CloseDate = Date.today()+2;
        //opp.StageName = 'Negotiation';
        opp.StageName = 'Decision';
        opp.ETSALES_GL_Services__c = 'Motor Cycle';
        Insert opp;
        
        ET_Service_Request_Common_Data__c srcd = New ET_Service_Request_Common_Data__c(ET_Contract_Period__c='12');
        insert srcd;
        
        ET_Pricing_Service_Request__c prReq= new ET_Pricing_Service_Request__c();
        prReq.Opportunity__c = opp.Id;
        prReq.ET_PSR_IsActive__c=true;
        prReq.ET_Service_Request_Common_Data__c = srcd.Id;
        Insert prReq;
        
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.ET_Pricing_Service_Request__c =prReq.Id;
        Insert vehicle;
        
        /*
        User testUser = new User();
        testUser.Lastname = 'testUser';
        testUser.Username ='testUser@123.com';
        testUser.Email='testUser@123.com';
        insert testUser;
        */
        
        ETSALES_GONOGOController.AccountContactListWrapper oppInfo = ETSALES_GONOGOController.getOppAccountVehicleDetails(opp.Id);
        ETSALES_GONOGOController.submitForOppApproval(opp.Id);
        ETSALES_GONOGOController.getOpportunityDetails(opp.Id);
        delete prReq;
        ETSALES_GONOGOController.submitForOppApproval(opp.Id);
        Id oppRecordType1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Driving School- B2B').getRecordTypeId();
        opp.RecordTypeId = oppRecordType1;
        update opp;
        ETSALES_GONOGOController.submitForOppApproval(opp.Id);
        test.stopTest();
    }
}