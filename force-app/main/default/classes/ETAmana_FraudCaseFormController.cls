/**
* @File Name : ETAmana_FraudCaseFormController.cls
* @Description : This Apex controller manages fraud case operations for the ETAmana solution.  
*                It includes creating, submitting, deleting, and retrieving case records,  
*                handling file uploads, and fetching picklist values for form fields. 
* @Test class :  ETAmana_FraudCaseFormController_Test.cls
* @Lightning Web Component : etamana_FraudCaseForm
* @Author :  Shubhangi Patil
* @Last Modified By :
* @Last Modified On : February 13, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | February 13, 2025 | Shubhangi Patil  | Initial Version
**/


public without sharing class ETAmana_FraudCaseFormController {
	@AuraEnabled
    public static ETAmana_Solution__c createAmanaCase(String uniqueNumber) {
        System.debug('createAmanaCase method called with uniqueNumber: ' + uniqueNumber);
        ETAmana_Solution__c amanaCase = new ETAmana_Solution__c(
            ETAmana_Unique_Number__c = uniqueNumber,
           // ETAmana_Status__c = 'New'
           ETAmana_Status__c = 'Draft' // Set status to Draft on creation
        );
        try {
            insert amanaCase;
            System.debug('Amana Solution case created successfully with ID: ' + amanaCase.Id);
            return amanaCase;
        } catch (DmlException e) {
            System.debug('Error inserting Amana Solution case: ' + e.getMessage());
            throw new AuraHandledException('Error creating Amana Solution case: ' + e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static ETAmana_Solution__c submitAmanaCase(Map<String, Object> caseData) {
        ETAmana_Solution__c caseRecord = new ETAmana_Solution__c();
        System.debug('caseData : ' + caseData);
        for (String key : caseData.keySet()) {
            if (caseData.get(key) != null) {
                if (key == 'ETAmana_When_did_the_incident_occur__c' && caseData.get(key) instanceof String) {
                    caseRecord.put(key, Date.valueOf((String) caseData.get(key)));
                } else {
                    caseRecord.put(key, caseData.get(key));
                }
            }
            System.debug('Updating field ' + key + ' to ' + caseData.get(key));
        }
         // Ensure the status is set to 'New' when submitting the case
    		caseRecord.ETAmana_Status__c = 'New';

        try {
            upsert caseRecord;
            System.debug('Amana Solution case submitted successfully with ID: ' + caseRecord.Id);
        } catch (DmlException e) {
            System.debug('Error submitting Amana Solution case: ' + e.getMessage());
            throw new AuraHandledException('Error submitting Amana Solution case: ' + e.getMessage());
        }
        return caseRecord;
    }

    @AuraEnabled
    public static boolean deleteAmanaCase(String caseId) {
       boolean isSucess = false;
        System.debug('deleteAmanaCase method called with caseId: ' + caseId);
        List<ETAmana_Solution__c> caseList = [SELECT Id
                                            FROM ETAmana_Solution__c
                                            WHERE Id = :caseId AND ETAmana_Status__c = 'Draft' ];
        try {
            if (caseList.size() > 0) {
                delete caseList;
                isSucess=true;
                System.debug('Amana Solution case deleted successfully with ID: ' + caseId);
            }
        } catch (DmlException e) {
            isSucess = false;
            System.debug('Error deleting Amana Solution case: ' + e.getMessage());
            throw new AuraHandledException('Error deleting Amana Solution case: ' + e.getMessage());
        }
        return isSucess;
    }

    @AuraEnabled(cacheable = true)
    public static ETAmana_Solution__c getAmanaCaseStatus(String uniqueNumber) {
        try {
            return [SELECT Id, Name, ETAmana_Unique_Number__c, ETAmana_Full_description__c, Status_of_the_Case__c, Solution__c
                    FROM ETAmana_Solution__c
                    WHERE ETAmana_Unique_Number__c = :uniqueNumber
                    LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving Amana Solution case: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId) {
        return ET_FileUploadHelper.uploadFile(base64, filename, recordId);
    }

    @AuraEnabled(cacheable = false)
    public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {
        return ET_FileUploadHelper.getRelatedFilesByRecordId(recordId);
    }

    @AuraEnabled
    public static Boolean deleteFile(String ContentDocId) {
        return ET_FileUploadHelper.deleteFile(ContentDocId);
    }
	/*@AuraEnabled(cacheable=true)
    public static List<String> getPicklistValues() {
        List<String> picklistValues = new List<String>();
        Schema.DescribeFieldResult fieldDescribe = ETAmana_Solution__c.ETAmana_Business_function_incident__c.getDescribe();
        for (Schema.PicklistEntry entry : fieldDescribe.getPicklistValues()) {
            picklistValues.add(entry.getLabel());
        }
        return picklistValues;
    }*/
    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getPicklistValues() {
        Map<String, List<String>> picklistMap = new Map<String, List<String>>();

        // Retrieve picklist values for each field
        Schema.DescribeFieldResult BusinessField = ETAmana_Solution__c.ETAmana_Business_function_incident__c.getDescribe();
        Schema.DescribeFieldResult violationField = ETAmana_Solution__c.ETAmana_Type_of_the_violation__c.getDescribe();
        Schema.DescribeFieldResult relationField = ETAmana_Solution__c.ETAmana_Relation_with_Emirates_Transport__c.getDescribe();
        Schema.DescribeFieldResult locationField = ETAmana_Solution__c.ETAmana_incident_location__c.getDescribe();
		
         // Add picklist values for Business function
        List<String> BusinessValues = new List<String>();
        for (Schema.PicklistEntry entry : BusinessField.getPicklistValues()) {
            BusinessValues.add(entry.getLabel());
        }
        picklistMap.put('businessFunctionOptions', BusinessValues);
        
        // Add picklist values for Violation Type
        List<String> violationValues = new List<String>();
        for (Schema.PicklistEntry entry : violationField.getPicklistValues()) {
            violationValues.add(entry.getLabel());
        }
        picklistMap.put('violationTypeOptions', violationValues);

        // Add picklist values for Relation with Emirates Transport
        List<String> relationValues = new List<String>();
        for (Schema.PicklistEntry entry : relationField.getPicklistValues()) {
            relationValues.add(entry.getLabel());
        }
        picklistMap.put('relationWithETOptions', relationValues);

        // Add picklist values for Incident Location
        List<String> locationValues = new List<String>();
        for (Schema.PicklistEntry entry : locationField.getPicklistValues()) {
            locationValues.add(entry.getLabel());
        }
        picklistMap.put('incidentLocationOptions', locationValues);

        return picklistMap;
    }
    
}