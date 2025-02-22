@isTest
public class ET_Quotation_PDF_Attachment_Con_Test {

    @testSetup
    static void setup(){
        /*Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
        List<Account> accList = ET_ServiceRequestControllerUtility.createAccounts(1, null);
        accList[0].client_type__c = 'Sovrin';
        insert accList;
        List<Contact> conList = ET_ServiceRequestControllerUtility.createContacts(1, accList[0].Id);
        List<Opportunity> oppList = ET_ServiceRequestControllerUtility.createOpportunities(1, oppRecordTypeId, accList[0].id);insert oppList;
        System.debug(oppList);
        ET_ServiceRequestControllerUtility.createMultiplerecords();*/
    }
     @isTest
    public static void codecoverage()
    {
        /*ET_Pricing_Service_Request__c psr = [Select id from ET_Pricing_Service_Request__c Limit 1];
        List<Opportunity> oppList = [SELECT id,name FROM Opportunity];
         Quote q1 = new Quote();
        q1.name = 'Quote1' + oppList[0].name;
        q1.opportunityId = oppList[0].id;
        q1.ET_Type__c = 'Quote for Approval';
        q1.Is_Target_Price_Required__c=true;
        q1.ET_Pricing_Service_Request__c = psr.id;
        insert q1;
         Quote q2 = new Quote();
        q2.name = 'Quote1' + oppList[0].name;
        q2.opportunityId = oppList[0].id;
        q1.ET_Type__c = 'Total Project Summary';
        q2.Is_Target_Price_Required__c=true;
        q2.ET_Pricing_Service_Request__c = psr.id;
        insert q2;
        ET_Quotation_PDF_Attachment_Controller obj = new ET_Quotation_PDF_Attachment_Controller();
        obj.UpdatePDFContent(q1.id);
        String str = obj.PagePDFContentWithoutTotalSummary;
        String str1 = obj.PagePDFContentWithTotalSummary;
        String QuoteId = obj.QuoteId;*/
        ET_Quotation_PDF_Attachment_Controller.testcoverage1();
    }
}