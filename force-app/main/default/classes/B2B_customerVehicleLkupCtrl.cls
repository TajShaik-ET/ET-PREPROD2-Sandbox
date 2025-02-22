/*******************************************************************************************************************
Class       : B2B_customerVehicleLkupCtrl
Author      : Janardhan
Description : 
TestClass  :  B2B_customerVehicleLkupCtrlTest
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date        Author            Details
1.           V1.0              30/03/23    janardhan          Initial Version

*******************************************************************************************************************/

public without sharing class B2B_customerVehicleLkupCtrl {
    
    @AuraEnabled
    public static list<ET_Customer_Vehicle__c> getFilterList(string searchWord,string accId){        
        String queryStr;
        queryStr = 'SELECT Id,Internal_No__c from ET_Customer_Vehicle__c  where Account__c=:accId AND Internal_No__c like \'%'+ searchWord +'%\' limit 5';
       
        return Database.Query(queryStr);
    }

}