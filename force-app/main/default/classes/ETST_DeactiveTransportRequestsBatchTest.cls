/*******************************************************************************************************************
Class       : ETST_DeactiveTransportRequestsBatchTest
Author      : Sreelakshmi SK
Description :  
TestClass  :
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date             Changed By                        Details
1.          V1               Jan 12th, 2022     Sreelakshmi SK                 Initial Version
*******************************************************************************************************************/

@isTest
private class ETST_DeactiveTransportRequestsBatchTest {

    @isTest
    static void testStart() {
        // Create test data
        List<ET_Service_Request__c> requests = new List<ET_Service_Request__c>();
        for (Integer i = 0; i < 200; i++) {
            ET_Service_Request__c req = new ET_Service_Request__c();
            req.ETST_Pick_Up_Start_Date__c = System.today().addDays(i);
            req.ETST_Pick_Up_End_Date__c = System.today().addDays(i + 5);
            req.ETST_Is_Active__c = false;
            req.ETST_Status__c = 'Open';
            requests.add(req);
        }
        insert requests;
        
        Test.startTest();
        ETST_DeactiveTransportRequestsBatch batch = new ETST_DeactiveTransportRequestsBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        }
    }