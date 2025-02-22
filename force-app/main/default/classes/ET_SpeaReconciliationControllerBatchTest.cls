/************************************************************************************************************************
* Name               : ET_SpeaReconciliationControllerBatchTest                                                        *
* Description        : Apex Test Class for ET_SpeaReconciliationControllerBatch,ET_FinanceControllerCalloutBatch       *
* Created Date       : 22/Apr/2024                                                                                     *
* Created By         : Santosh(SMAARTT)                                                                                *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Santosh     22/Apr/2024         Initial Draft.                                                             *
***********************************************************************************************************************/
@isTest
public class ET_SpeaReconciliationControllerBatchTest {
    @isTest
    static void testBatchExecution() {
        ET_Location__c loc = New ET_Location__c();
        loc.Name = 'Sharjah Spea Inspection Centre';
        loc.Arabic_Name__c = 'Sharjah Spea Inspection Centre';
        loc.Region__c = 'Sharjah';
        Insert loc;
        
        ET_Service_Request__c SRREC = new ET_Service_Request__c();
        SRREC.ETST_Service_Type__c = 'Quarterly';
        SRREC.ETST_Payee__c = 'Parent';
        SRREC.Payment_Status__c = 'Payment Success';
        SRREC.ET_Location__c = loc.Id;
        Insert SRREC;
        
        ET_Service_Request__c SRREC1 = new ET_Service_Request__c();
        SRREC1.ETST_Service_Type__c = 'Quarterly';
        SRREC1.ETST_Payee__c = 'Parent';
        SRREC1.Payment_Status__c = 'Payment Success';
        SRREC1.ET_Location__c = loc.Id;
        Insert SRREC1;
        
        ET_Customer_Vehicle__c veh = New ET_Customer_Vehicle__c();
        veh.Plate_Type__c = 'PRIVATE';
        veh.Plate_Color__c = 'SECOND CATEGORY';
        veh.Preferred_Language__c = 'English';
        veh.Chassis_No__c = 'JTGFB7189K1231231';
        Insert veh;
        
        List<ETST_Payment__c> testPayments = new List<ETST_Payment__c>();
        ETST_Payment__c testPayment = new ETST_Payment__c(
            ET_Service_Request__c = SRREC.Id,
            ETST_Payment_Mode__c = 'Online',
            ETST_Amount__c = 2887.50,
            ETST_Currency__c = 'AED',
            ETST_Payment_State__c = 'CAPTURED',
            ETST_Capture_State__c = 'SUCCESS',
            ETST_AuthorizationCode__c = '1234',
            ETST_Cardholder_Name__c = 'emirates transport'
        );
        ETST_Payment__c testPayment1 = new ETST_Payment__c(
            ET_Service_Request__c = SRREC1.Id,
            ETST_Payment_Mode__c = 'Online',
            ETST_Amount__c = 262.50,
            ETST_Currency__c = 'AED',
            ETST_Payment_State__c = 'CAPTURED',
            ETST_Capture_State__c = 'SUCCESS',
            ETST_AuthorizationCode__c = '12345',
            ETST_Cardholder_Name__c = 'emirates transport'
        );
        testPayments.add(testPayment);
        testPayments.add(testPayment1);
        Insert testPayments;
        
        System.debug('testPayment.Id: '+testPayment.Id);
        List<ET_Receipt__c> recList = [SELECT Id FROM ET_Receipt__c WHERE ET_Payment__c =: testPayment.Id OR ET_Payment__c =: testPayment1.Id];
        System.debug('recList Size: '+recList.Size());
        if(recList.Size()>0)
            Delete recList;
        
        List<ETI_Booking__c> bkgList = New List<ETI_Booking__c>();
        ETI_Booking__c bkg = New ETI_Booking__c();
        bkg.Service_Request__c = SRREC.Id; 
        bkg.Booking_Status__c = 'Inspection Completed'; 
        bkg.Customer_Vehicle__c = veh.Id;
        bkg.Service_Type__c = 'SPEA Inspection';
        bkgList.add(bkg);
        ETI_Booking__c bkg1 = New ETI_Booking__c();
        bkg1.Service_Request__c = SRREC1.Id; 
        bkg1.Booking_Status__c = 'Inspection Completed'; 
        bkg1.Customer_Vehicle__c = veh.Id;
        bkg1.Service_Type__c = 'SPEA Inspection';
        bkgList.add(bkg1);
        Insert bkgList;
        
        List<ETI_Service_Line_Item__c> bkglList = New List<ETI_Service_Line_Item__c>();
        ETI_Service_Line_Item__c bkgl = New ETI_Service_Line_Item__c();
        bkgl.Status__c = 'Active';
        bkgl.Booking__c = bkg.Id; 
        bkgl.Fee_Amount__c = 2750;
        bkgl.Total_Fee__c = 2887.5;
        bkgl.Tax_Amount__c = 137.5; 
        bkglList.add(bkgl);
        
        ETI_Service_Line_Item__c bkgl1 = New ETI_Service_Line_Item__c();
        bkgl1.Status__c = 'Active';
        bkgl1.Booking__c = bkg1.Id; 
        bkgl1.Fee_Amount__c = 250;
        bkgl1.Total_Fee__c = 262.5;
        bkgl1.Tax_Amount__c = 12.5; 
        bkglList.add(bkgl1);
        Insert bkglList;
        
        Test.startTest();
        //Running Batch
        ET_SpeaReconciliationControllerBatch speaBatch = New ET_SpeaReconciliationControllerBatch();
        speaBatch.givenDateTime = System.today();
        Id batchJobId = Database.executeBatch(speaBatch,3);
        Test.stopTest();
    }
}