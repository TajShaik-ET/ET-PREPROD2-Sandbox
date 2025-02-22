/***
Class       : ET_EmployeeHomeCntrl
Author      : Arunsarathy
CreatedDate : 19.01.2023
Description : Get all the emp related information
TestClass  : ET_EmployeeHomeCntrlTest
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date      Author          Details
1.          V1.0              19/01/23          	 Initial Version 
2.          V2.0              25/04/23   Janardhan   Added Employee_Tabs__c,profile.Name in query
3.          V2.1              12/02/24   Srihari     Added ETIN_Insurance__c Insurance Details 
****************************************************************************************************************/
public without sharing class ET_EmployeeHomeCntrl {
    @AuraEnabled
    public static UserInsuranceWrapper getCurrentUser() {
        UserInsuranceWrapper result = new UserInsuranceWrapper();
        User userInfo = [SELECT Id, Username, LastName, FirstName, MiddleName, Name, MediumPhotoUrl, Account.ET_Emirates_Id__c, Account.Employee_Tabs__c, Account.Phone, FullPhotoUrl, Account.ET_Preferred_Location__c, Street, City, State, PostalCode, Country, Address, Email, Phone, MobilePhone, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
        result.userInfo = userInfo;
        if ((userInfo.Account.Id != null || Test.isRunningTest())) {
            list<ETIN_Insurance__c> InsrnceList = new list<ETIN_Insurance__c>();
            InsrnceList  = [SELECT Id, Name, Employee_ID__c, Effective_Date__c, Expiry_Date__c, National_Id_Type__c, EmployeeAcc__c, EmployeeAcc__r.Id, EmployeeAcc__r.Name,Insurance_Company__c,Insurance_Company__r.Id,Insurance_Company__r.Name, Insurance_Policy_Number__c, Card_Number__c,Member_Name__c,Relation__c,Plan__c FROM ETIN_Insurance__c WHERE EmployeeAcc__r.Id = :userInfo.Account.Id AND Insurance_Current_Status__c ='Active' ORDER BY LastModifiedDate DESC LIMIT 1];
            system.debug('InsrnceList Size '+InsrnceList.Size());
            if (InsrnceList.Size() > 0) {
                result.insuranceInfo = InsrnceList;
            }
        }
        return result;
    }
    public class UserInsuranceWrapper {
        @AuraEnabled public User userInfo { get; set; }
        @AuraEnabled public List<ETIN_Insurance__c> insuranceInfo { get; set; }
    }
}