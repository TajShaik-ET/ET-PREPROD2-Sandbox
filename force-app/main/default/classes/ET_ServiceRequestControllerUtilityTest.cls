@isTest(SeeAllData=false)
public class ET_ServiceRequestControllerUtilityTest {
	@isTest 
    static void testMethodForUtility() {
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
		Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        Test.Starttest();
            List<Account> accList = ET_ServiceRequestControllerUtility.createAccounts(10,accRecordTypeId);
            insert accList;
            List<Opportunity> oppList = ET_ServiceRequestControllerUtility.createOpportunities(10,oppRecordTypeId,accList[0].Id) ;
            insert oppList;
        	ET_ServiceRequestControllerUtility.createWorkspaceMaster();
            ET_ServiceRequestControllerUtility.createMultiplerecords();
        Test.stopTest();
    }
}