public class ETST_GetRelatedrResources {

@AuraEnabled
public static List<SALine_Assigned_Resource__c>  getRelatedList(Id recordId)
{
        
ETST_Student__c etStudent = [Select id,ETST_Primary_Assigned_Vehicle__c from ETST_Student__c where id =: recordId ];
List<SALine_Assigned_Resource__c> resourcelist=[Select id,Name,Employee_ID__c,Employee_Type__c from SALine_Assigned_Resource__c where 
                                               ETST_Assigned_Vehicle__c=:etStudent.ETST_Primary_Assigned_Vehicle__c];
    
    return resourcelist;
}
    
       
}