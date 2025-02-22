@isTest
public class ET_OtherCostCalcDetailsControllerTest {
    @testSetup
    static void setup(){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
        List<Account> accList = ET_ServiceRequestControllerUtility.createAccounts(1, null);
        accList[0].client_type__c = 'Sovrin';
        insert accList;
        List<Opportunity> oppList = ET_ServiceRequestControllerUtility.createOpportunities(1, oppRecordTypeId, accList[0].id);insert oppList;
        System.debug(oppList);
    }
    @isTest 
    static void testOtherCostCalcDetails() {
        List<Opportunity> oppList = [SELECT id,name FROM Opportunity ];
        Quote q = new Quote();
        q.name = 'Quote1' + oppList[0].name;
        q.opportunityId = oppList[0].id;
        insert q;
        ET_Quote_Item_SpecReq__c qItemSpecReq=new ET_Quote_Item_SpecReq__c();
        qItemSpecReq.Name='test';
        qItemSpecReq.ET_Api_Name__c='';
        qItemSpecReq.ET_Cost__c=100;
        qItemSpecReq.Quote__c=q.id;
        qItemSpecReq.Line_Item_Number__c=1;
        qItemSpecReq.Quote_Contract_Year__c=1;
        insert qItemSpecReq;
        Test.startTest();
        ET_OtherCostCalcDetailsController.ET_getotherCostCalcDetail(q.Id);
        Test.stopTest();
    }
}