@isTest
public class ET_PricingUtilityClassTest {
    
    Public static testmethod void codeCoverage(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.IsConvertedFromLead__c = true;
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Account';
        opp.StageName = 'Qualification';
        opp.CloseDate = System.today()+8;
        opp.ETSALES_GNG_Approval_Status_Date__c = System.today()+8;
        opp.ETSALES_Approval_Status__c = 'Approved';
        opp.ETSALES_GL_Services__c = 'Private School';
        insert opp;
        ET_Service_Request_Common_Data__c et_service_request_common_data = new ET_Service_Request_Common_Data__c(
            CurrencyIsoCode = 'AED',
            ET_Common_Data_Type__c = 'All Tab',
            ET_Contract_Period__c = '1 Yr,2 Yrs,3 Yrs,4 Yrs,5 Yrs,6 Yrs,7 Yrs,8 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Dubai',
            ET_Working_Days_Per_Week__c = '7',
            ET_Working_Months_Per_Year__c = '12');
        insert et_service_request_common_data;
        ET_Pricing_Service_Request__c sr = new ET_Pricing_Service_Request__c(Opportunity__c = opp.Id, ET_PSR_IsActive__c = true, 
                                                                             ET_Service_Request_Common_Data__c = ET_Service_Request_Common_Data.id);
        insert sr;
        Vehicle__c vehical = new Vehicle__c();
        vehical.ET_Pricing_Service_Request__c = sr.Id;
        insert vehical;
        Quote q = new Quote();
        q.name = 'Quote1' + opp.name;
        q.opportunityId = opp.id;
        q.Is_Target_Price_Required__c=true;
        insert q;
        // insert Total project quote summary..
        Quote q2 = new Quote();
        q2.name = 'Quote1' + opp.name;
        q2.opportunityId = opp.id;
        q2.Is_Target_Price_Required__c=true;
        q2.ET_Type__c ='Total Project Summary';
        insert q2;
        Test.startTest();
        ET_PricingUtilityClass.getVehicleRequestMap(sr.Id);
        ET_PricingUtilityClass.getWorkforceRequestMap(sr.Id);
        ET_PricingUtilityClass.getVehicleQuoteItemLst(q.Id);
        ET_PricingUtilityClass.getWorkforceQuoteItemLst(q.Id,'Test');
        ET_PricingUtilityClass.getWorkforceQuoteItemLstWithQutId(q.Id);
        ET_PricingUtilityClass.getVehicleMasterData();
        ET_PricingUtilityClass.getFinanceCalculationsRecords(q.Id);
        ET_PricingUtilityClass.getTotalProjectQuoteId(q.Id);
        Test.stopTest();
    }
    
}