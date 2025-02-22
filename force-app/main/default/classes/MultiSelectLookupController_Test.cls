@isTest
public class MultiSelectLookupController_Test {
    public static testmethod void fetchRecordsTest(){
        
            MultiSelectLookupController.RecordsData  wrap= new  MultiSelectLookupController.RecordsData('label','value');
            MultiSelectLookupController.fetchRecords('ETT_Quotation__c','Name','7','[]','ETT_Account__c','');
            MultiSelectLookupController.fetchRecords('ETT_Quotation__c','Name','7','[0,1]','ETT_Account__c','');
    }

}