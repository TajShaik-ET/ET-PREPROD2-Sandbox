@isTest(SeeAllData = false)
public class ET_WorkforceCalcDetailsControllerTest {
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
        q.Is_Target_Price_Required__c=true;
        q.ET_Type__c = 'Total Project Summary';
        insert q;
        ET_Vehicle_Quote_Item__c vqi = new ET_Vehicle_Quote_Item__c();
        vqi.ET_Quote_Item_Type__c = 'Vehicle';
        vqi.ET_Vehicle_Unique_key__c = '1231';
        vqi.ET_Line_Number__c = 123;
        vqi.Quote__c = q.Id;
        insert vqi;
        ET_Quote_Item_SpecReq__c qItemSpecReq=new ET_Quote_Item_SpecReq__c();
        qItemSpecReq.Name='test';
        qItemSpecReq.ET_Api_Name__c='';
        qItemSpecReq.ET_Cost__c=100;
        qItemSpecReq.Quote__c=q.id;
        qItemSpecReq.Line_Item_Number__c=1;
        qItemSpecReq.Quote_Contract_Year__c=1;
        insert qItemSpecReq;
        ET_Workforce_Quote_Item__c et_workforce_quote_item = new ET_Workforce_Quote_Item__c(
        Quote__c = q.id,
            
        ET_Workforce_Quote_Item_Type__c = 'Other Employee',
        CurrencyIsoCode = 'AED',
        Approval_Details__c='test,test,test,test;');
        insert et_workforce_quote_item;
        ET_Quote_Item_SpecReq__c quoteItemSpecReq=new ET_Quote_Item_SpecReq__c();
        quoteItemSpecReq.Name='Washing';
        quoteItemSpecReq.Workforce_Quote_Item__c=et_workforce_quote_item.Id;
        quoteItemSpecReq.ET_Cost__c=100;
        insert quoteItemSpecReq;
        ET_Pricing_Service_Request__c sr = new ET_Pricing_Service_Request__c(Opportunity__c = oppList[0].Id, ET_PSR_IsActive__c = true,ET_Accountant_Pricing_Choice__c='test',
                                                                             ET_Coordinator_Pricing_Choice__c='test',ET_Supervisor_Pricing_Choice__c='test');
        insert sr;
        ET_Request_Mapping__c reqMapping=new ET_Request_Mapping__c();
        reqMapping.ET_Vehicle_Unique_key__c='test';
        reqMapping.ET_Number_of_Vehicles__c = 2;
        reqMapping.ET_Number_of_Accountants__c=2;
        reqMapping.ET_Number_of_Coordinators__c=2;
        reqMapping.ET_Number_of_Drivers__c=2;
        reqMapping.ET_Number_of_Nannies__c=2;
        reqMapping.ET_Number_of_Other_Employees__c=2;
        reqMapping.ET_Number_of_Supervisors__c=2;
        reqMapping.ET_Pricing_Service_Request__c=sr.id;
        insert reqMapping;
        
        q.ET_Pricing_Service_Request__c=sr.id;
        update q;
        Test.startTest();
        ET_WorkforceCalDetailsController.ET_getWorkforceCalcDetails(q.Id,'Other Employee');
        ET_WorkforceCalDetailsController.ET_getAllWorkforceCalcDetails(q.Id);
        et_workforce_quote_item .ET_Workforce_Quote_Item_Type__c = 'Driver';
        update et_workforce_quote_item ;
        ET_WorkforceCalDetailsController.ET_getAllWorkforceCalcDetails(q.Id);
        et_workforce_quote_item .ET_Workforce_Quote_Item_Type__c = 'Nanny';
        update et_workforce_quote_item ;
        ET_WorkforceCalDetailsController.ET_getAllWorkforceCalcDetails(q.Id);
        et_workforce_quote_item .ET_Workforce_Quote_Item_Type__c = 'Supervisor';
        update et_workforce_quote_item ;
        ET_WorkforceCalDetailsController.ET_getAllWorkforceCalcDetails(q.Id);
        et_workforce_quote_item .ET_Workforce_Quote_Item_Type__c = 'Coordinator';
        update et_workforce_quote_item ;
        ET_WorkforceCalDetailsController.ET_getAllWorkforceCalcDetails(q.Id);
        et_workforce_quote_item .ET_Workforce_Quote_Item_Type__c = 'Accountant/Cashier';
        update et_workforce_quote_item ;
        ET_WorkforceCalDetailsController.ET_getAllWorkforceCalcDetails(q.Id);
        et_workforce_quote_item .ET_Workforce_Quote_Item_Type__c = 'Other Cost';
        update et_workforce_quote_item ;
        ET_WorkforceCalDetailsController.ET_getAllWorkforceCalcDetails(q.Id);
        Test.stopTest();
   }
}