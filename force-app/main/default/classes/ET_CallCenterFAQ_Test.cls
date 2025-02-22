@isTest
public class ET_CallCenterFAQ_Test {
    @isTest
    static void testfetchRecords() {
        String strQuery ='SELECT Id,Sequence__c,Number__c,Department_En__c,Department_Ar__c,Service_En__c,Service_Ar__c,Activities_En__c,Activities_Ar__c FROM Call_Center_FAQ__mdt ORDER BY Sequence__c ASC';
        String strQuery2 ='SELECT Id,Sequence__c,Number__c,Department_En__c,Department_Ar__c,Service_En__c,Service_Ar__c,Activities_En__c,Activities_Ar__c FROM  ORDER BY Sequence__c ASC';
        try {
            ET_CallCenterFAQ.fetchRecords(strQuery);
            ET_CallCenterFAQ.fetchRecords(strQuery2);
        } catch (Exception err) {
            
            
        }
    }
}