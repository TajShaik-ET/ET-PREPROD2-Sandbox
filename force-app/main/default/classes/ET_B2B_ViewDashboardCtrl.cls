/*
 * Author: Janardhan Muddana
 * CreatedDate: 05/08/22
 * Test Class: ET_B2B_ViewDashboardCtrlTest
 * */
public class ET_B2B_ViewDashboardCtrl {
    
    
    @AuraEnabled
    public static list<SALine_Assigned_Resource__c> getAssignedResources(String AccountId,Boolean showAllAcc){   
        
        set<id> accIdList = new set<id>();  
         accIdList.add(AccountId); 
        if(showAllAcc){           
            for(account acc: [select id,parentId from Account where parentId=:AccountId]){
                accIdList.add(acc.Id);
            }
        } 
       
        return [select id,name,Employee_Type__c,Driver_Category__c,Sales_Agreement__r.Customer_PO_No__c from SALine_Assigned_Resource__c where Assign_End_Date__c>= TODAY AND Sales_Agreement__r.Salesforce_Customer__c=:accIdList];
    }
    
    @AuraEnabled
    public static list<SALine_Assigned_Vehicle__c> getAssignedVehicles(String AccountId,Boolean showAllAcc){   
        
        set<id> accIdList = new set<id>();  
        accIdList.add(AccountId); 
        if(showAllAcc){           
            for(account acc: [select id,parentId from Account where parentId=:AccountId]){
                accIdList.add(acc.Id);
            }
        }         
        return [select id,name,Vehicle_Type__c,Vehicle_Status__c,Sales_Agreement__r.Customer_PO_No__c from SALine_Assigned_Vehicle__c where Assign_End_Date__c>=TODAY AND Sales_Agreement__r.Salesforce_Customer__c=:accIdList];
    }

}