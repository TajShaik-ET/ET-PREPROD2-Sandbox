/***********************************************************************************************************************
* Name               : ETI_ADPInspectionHandlerTest                                                                    *
* Trigger/Class      : ETI_ADP_Inspection,ETI_ADPInspectionHandler                                                     *
* Description        : Test Class to cover code coverage                                                               *
* Created Date       : 24/Apr/2025                                                                                     *
* Created By         : Akash (SMAARTT)                                                                                 *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Akash       24/Apr/2025         Initial Draft.                                                             *
***********************************************************************************************************************/
@isTest
public class ETI_ADPInspectionHandlerTest {
    
    @isTest
    static void testHandleBeforeInsert_withMatchingName() {
        // Create ETI Observation with AMAN_Receipt_No__c matching ADP.Name
        ETI_Inspection_Observation__c obs = new ETI_Inspection_Observation__c(
            AMAN_Receipt_No__c = 'AM/25/3'
        );
        Insert obs;
        
        Test.startTest();
        // Create ADP_Inspection__c that should match
        ADP_Inspection__c adp = new ADP_Inspection__c(
            Name = 'AM/25/3',
            Receipt_Number__c = 'AM/25/3'
        );
        Insert adp;
        
        ADP_Inspection__c adpAfterInsert = [SELECT Id, Inspection_Observation__c FROM ADP_Inspection__c WHERE Id = :adp.Id];
        // Verify that the Inspection_Observation__c field is set correctly
        System.assertEquals(obs.Id, adpAfterInsert.Inspection_Observation__c, 'Should match by Name');
        
        obs.AMAN_Receipt_No__c = 'AM/25/4';
        Update obs;
        
        // Create ADP_Inspection__c that should match
        adp.Name = 'AM/25/4';
        adp.Receipt_Number__c = 'AM/25/4';
        Update adp;
        Test.stopTest();
        
        ADP_Inspection__c adpAfterUpdate = [SELECT Id, Inspection_Observation__c FROM ADP_Inspection__c WHERE Id = :adp.Id];
        // Verify that the Inspection_Observation__c field is set correctly
        System.assertEquals(obs.Id, adpAfterInsert.Inspection_Observation__c, 'Should match by Name');
    }
    
    @isTest
    static void testHandleBeforeInsert_withNotMatchingName() {
        // Create ETI Observation with AMAN_Receipt_No__c matching ADP.Name
        ETI_Inspection_Observation__c obs = new ETI_Inspection_Observation__c(
            AMAN_Receipt_No__c = 'AM/25/3'
        );
        Insert obs;
        
        Test.startTest();
        // Create ADP_Inspection__c that should match
        ADP_Inspection__c adp = new ADP_Inspection__c(
            Name = 'AM/25/1',
            Receipt_Number__c = 'AM/25/1'
        );
        Insert adp;
        
        ADP_Inspection__c adpAfterInsert = [SELECT Id, Inspection_Observation__c FROM ADP_Inspection__c WHERE Id = :adp.Id];
        // Verify that the Inspection_Observation__c field is set correctly
        System.assertEquals(null, adpAfterInsert.Inspection_Observation__c, 'Should not match by Name');
        
        obs.AMAN_Receipt_No__c = 'AM/25/4';
        Update obs;
        
        // Create ADP_Inspection__c that should match
        adp.Name = 'AM/25/2';
        adp.Receipt_Number__c = 'AM/25/2';
        Update adp;
        Test.stopTest();
        
        ADP_Inspection__c adpAfterUpdate = [SELECT Id, Inspection_Observation__c FROM ADP_Inspection__c WHERE Id = :adp.Id];
        // Verify that the Inspection_Observation__c field is set correctly
        System.assertEquals(null, adpAfterInsert.Inspection_Observation__c, 'Should not match by Name');
    }
}