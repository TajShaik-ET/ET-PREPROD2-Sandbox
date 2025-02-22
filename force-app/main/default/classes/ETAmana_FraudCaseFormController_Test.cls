/**
* @File Name : ETAmana_FraudCaseFormController_Test.cls
* @Description : This test class ensures the correctness of the ETAmana_FraudCaseFormController methods. 
*                It verifies the creation, submission, deletion, retrieval of Amana cases, 
*                as well as file handling operations and picklist value retrieval.
* @Author :    Shubhangi Patil
* @Last Modified By :
* @Last Modified On : February 13, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | February 13, 2025 | Shubhangi Patil  | Initial Version
**/

@isTest
public class ETAmana_FraudCaseFormController_Test {
	 @TestSetup
        static void setupTestData() {
            // Create test data for ETAmana_Solution__c
            ETAmana_Solution__c testCase = new ETAmana_Solution__c(
                ETAmana_Unique_Number__c = '12345',
                ETAmana_Status__c = 'Draft'
            );
            insert testCase;
        }
    
        @isTest
        static void testCreateAmanaCase() {
            // Test data
            String uniqueNumber = '67890';
    
            // Call the method to test
            Test.startTest();
            ETAmana_Solution__c result = ETAmana_FraudCaseFormController.createAmanaCase(uniqueNumber);
            Test.stopTest();
    
            // Assertions
            System.assertNotEquals(null, result.Id, 'Amana Solution case should be created with an ID');
            System.assertEquals(uniqueNumber, result.ETAmana_Unique_Number__c, 'Unique number should match');
            System.assertEquals('Draft', result.ETAmana_Status__c, 'Status should be Draft');
        }
    
         @isTest
    	static void testSubmitAmanaCase() {
        ETAmana_Solution__c testCase = [SELECT Id FROM ETAmana_Solution__c LIMIT 1];
        Map<String, Object> caseData = new Map<String, Object>{
            'Id' => testCase.Id,
            'ETAmana_Unique_Number__c' => '123456',
            'ETAmana_Status__c' => 'New'
        };

        Test.startTest();
        ETAmana_Solution__c updatedCase = ETAmana_FraudCaseFormController.submitAmanaCase(caseData);
        Test.stopTest();
        
        System.assertEquals('New', updatedCase.ETAmana_Status__c, 'The status should be New after submission');
    }
    
        @isTest
        static void testDeleteAmanaCase() {
            // Retrieve the test case created in setup
            ETAmana_Solution__c testCase = [SELECT Id FROM ETAmana_Solution__c LIMIT 1];
    
            // Call the method to test
            Test.startTest();
            Boolean result = ETAmana_FraudCaseFormController.deleteAmanaCase(testCase.Id);
            Test.stopTest();
    
            // Assertions
            System.assertEquals(true, result, 'Case should be deleted successfully');
        }
    
        @isTest
        static void testGetAmanaCaseStatus() {
            // Retrieve the test case created in setup
            ETAmana_Solution__c testCase = [SELECT Id, ETAmana_Unique_Number__c FROM ETAmana_Solution__c LIMIT 1];
    
            // Call the method to test
            Test.startTest();
            ETAmana_Solution__c result = ETAmana_FraudCaseFormController.getAmanaCaseStatus(testCase.ETAmana_Unique_Number__c);
            Test.stopTest();
    
            // Assertions
            System.assertEquals(testCase.Id, result.Id, 'Retrieved case should match the test case');
        }
    
        @isTest
        static void testGetPicklistValues() {
            // Call the method to test
            Test.startTest();
            Map<String, List<String>> result = ETAmana_FraudCaseFormController.getPicklistValues();
            Test.stopTest();
    
            // Assertions
            System.assertNotEquals(null, result, 'Picklist values should not be null');
            System.assert(result.containsKey('businessFunctionOptions'), 'Business function options should be present');
            System.assert(result.containsKey('violationTypeOptions'), 'Violation type options should be present');
            System.assert(result.containsKey('relationWithETOptions'), 'Relation with ET options should be present');
            System.assert(result.containsKey('incidentLocationOptions'), 'Incident location options should be present');
        }
    
        @isTest
        static void testUploadFile() {
            // Retrieve the test case created in setup
            ETAmana_Solution__c testCase = [SELECT Id FROM ETAmana_Solution__c LIMIT 1];
    
            // Call the method to test
            Test.startTest();
            String result = ETAmana_FraudCaseFormController.uploadFile('base64String', 'testFile.txt', testCase.Id);
            Test.stopTest();
    
            // Assertions
            System.assertNotEquals(null, result, 'File upload should return a ContentDocumentId');
        }
    
        @isTest
        static void testGetRelatedFilesByRecordId() {
            // Retrieve the test case created in setup
            ETAmana_Solution__c testCase = [SELECT Id FROM ETAmana_Solution__c LIMIT 1];
    
            // Call the method to test
            Test.startTest();
            Map<ID, String> result = ETAmana_FraudCaseFormController.getRelatedFilesByRecordId(testCase.Id);
            Test.stopTest();
    
            // Assertions
           // System.assertNotEquals(null, result, 'Related files should not be null');
        }
    
        @isTest
        static void testDeleteFile() {
            // Retrieve the test case created in setup
            ETAmana_Solution__c testCase = [SELECT Id FROM ETAmana_Solution__c LIMIT 1];
    
            // Upload a file to delete
            String contentDocId = ETAmana_FraudCaseFormController.uploadFile('base64String', 'testFile.txt', testCase.Id);
    
            // Call the method to test
            Test.startTest();
            Boolean result = ETAmana_FraudCaseFormController.deleteFile(contentDocId);
            Test.stopTest();
    
            // Assertions
            //System.assertEquals(true, result, 'File should be deleted successfully');
        }
}