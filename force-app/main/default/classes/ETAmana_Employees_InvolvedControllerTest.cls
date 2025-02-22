/**
        * @File Name : ETAmana_Employees_InvolvedControllerTest.cls
        * @Description : This test class verifies the functionality of ETAmana_Employees_InvolvedController.  
        *                It includes unit tests to ensure correct behavior of account searches,  
        *                employee record validation, and record creation methods.  
        * @Author : shubhangi patil
        * @Last Modified By :
        * @Last Modified On : February 14, 2025
        * @Modification Log :
        *==============================================================================
        * Ver | Date | Author | Modification
        *==============================================================================
        * 1.0 | February 14, 2025 | Shubhangi Patil  | Initial Version
        **/
         @IsTest
        public class ETAmana_Employees_InvolvedControllerTest {
             @TestSetup
        static void setupTestData() {
            // Create test Accounts
            Account personAcc1 = new Account(Name = 'Test Person 1');
            Account personAcc2 = new Account(Name = 'Test Person 2');
            insert new List<Account>{personAcc1, personAcc2};
    
            // Create test Amana Solution without setting the Name field
            ETAmana_Solution__c solution = new ETAmana_Solution__c();
            insert solution;
    
            // Create existing Employee record
            ETAmana_Employees_involved__c empRecord = new ETAmana_Employees_involved__c(
                Account__c = personAcc1.Id,
                Amana_Solution__c = solution.Id
            );
            insert empRecord;
        }
        
        @IsTest
        static void testCheckEistingEmployeeRecord_True() {
            Id accId = [SELECT Id FROM Account WHERE Name = 'Test Person 1' LIMIT 1].Id;
            Id solId = [SELECT Id FROM ETAmana_Solution__c LIMIT 1].Id;
            Boolean result = ETAmana_Employees_InvolvedController.checkEistingEmployeeRecord(accId, solId);
            System.assertEquals(true, result, 'Should return true for existing record');
        }
    
        @IsTest
        static void testCheckEistingEmployeeRecord_False() {
            Id accId = [SELECT Id FROM Account WHERE Name = 'Test Person 2' LIMIT 1].Id;
            Id solId = [SELECT Id FROM ETAmana_Solution__c LIMIT 1].Id;
            Boolean result = ETAmana_Employees_InvolvedController.checkEistingEmployeeRecord(accId, solId);
            System.assertEquals(false, result, 'Should return false for non-existing record');
        }
    
        @IsTest
        static void testCreateEmployeeForAccount() {
        Id solId = [SELECT Id FROM ETAmana_Solution__c LIMIT 1].Id;
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = 'Test Person 2'];
        
        Test.startTest();
        ETAmana_Employees_InvolvedController.createEmployeeForAccount(accounts, solId);
        Test.stopTest();
    
        // Verify the employee was created for Test Person 2
        List<ETAmana_Employees_involved__c> employees = [
            SELECT Id, Account__r.Name 
            FROM ETAmana_Employees_involved__c 
            WHERE Amana_Solution__c = :solId 
            AND Account__r.Name = 'Test Person 2'
        ];
        
        System.assertEquals(1, employees.size(), 'Should create one new employee record for Test Person 2');
    }
    
        @IsTest
        static void testGetAmanaSolutionId() {
            String solutionId = ETAmana_Employees_InvolvedController.getAmanaSolutionId();
            System.assertNotEquals(null, solutionId, 'Should return a valid Solution Id');
        }
    }