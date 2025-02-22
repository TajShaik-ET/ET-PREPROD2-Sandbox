/**
* @File Name : ETAmana_Employees_InvolvedController.cls
* @Description : This Apex controller handles operations related to employees involved in Amana solutions.  
*                It includes functionalities such as searching for accounts, checking existing employee records,  
*                creating employee records for selected accounts, and retrieving an Amana solution ID.
* @Test class :  ETAmana_Employees_InvolvedControllerTest.cls
* @Lightning Web Component : etamana_Employees_Involved
* @Author :		shubhangi patil
* @Last Modified By :
* @Last Modified On : February 14, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | February 14, 2025 |Shubhangi Patil   | Initial Version
**/

public without sharing class ETAmana_Employees_InvolvedController {
    
    
    @AuraEnabled(cacheable = true)
    
    public static List<Account> searchAccounts(String searchTerm) {
        if (String.isBlank(searchTerm)) {
            throw new AuraHandledException('Search term cannot be blank.');
        }
        
        String query = '%' + String.escapeSingleQuotes(searchTerm) + '%';
        return [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE :query AND IsPersonAccount = true
            ORDER BY Name
            LIMIT 50
        ];
    }
    
    @AuraEnabled
    public static boolean checkEistingEmployeeRecord(Id accountId, Id recordId){
        List<ETAmana_Employees_involved__c> emp = [SELECT Id, Account__c, Amana_Solution__c 
                                                   FROM ETAmana_Employees_involved__c 
                                                   WHERE Amana_Solution__c =: recordId AND Account__c =: accountId];
        System.debug('emp : '+ emp);
        if(emp.size() > 0){
            return true;
        }else{
            return false;
        }
    }
    
    @AuraEnabled
    public static void createEmployeeForAccount(List<Account> account, Id recordId) {
        List<Account> accList = [SELECT Id, PersonDepartment, ETIN_Location__c, Phone, ETIN_Employee_Id__c FROM Account WHERE ID IN: account];
        Map<Id, Account> accMap = new Map<Id,Account>();
        for(Account a : accList){
            accMap.put(a.Id,a);
        }
        System.debug('account : '+ account);
        System.debug('recordId : '+ recordId);
        List<ETAmana_Employees_involved__c> employees = new List<ETAmana_Employees_involved__c>();
        
        for (Account acc : account) {
            System.debug('acc : '+ acc.Id + ' ' + acc.Name);
            ETAmana_Employees_involved__c emp = new ETAmana_Employees_involved__c(
                Account__c = acc.Id,
                Amana_Solution__c = recordId,
                Name = acc.Name,
                employee_Id__c = accMap.get(acc.Id).ETIN_Employee_Id__c,
                Department__c = accMap.get(acc.Id).PersonDepartment,
                Location__c = accMap.get(acc.Id).ETIN_Location__c,
                Phone__c = accMap.get(acc.Id).Phone
            );
            employees.add(emp);
        }
        
        if (!employees.isEmpty()) {
            insert employees;
        }
    }
    @AuraEnabled(cacheable=true)
    public static String getAmanaSolutionId() {
        // Example query to get the ID of a specific ETAmana_Solution__c record
        ETAmana_Solution__c solution = [SELECT Id FROM ETAmana_Solution__c LIMIT 1];
        return solution.Id;
    }
    
}