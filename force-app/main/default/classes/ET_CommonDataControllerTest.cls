@isTest(seeAlldata=false)
public class ET_CommonDataControllerTest {
    public static testMethod void getPicklistvaluesTestMethod(){
        ET_Service_Contract_Years__c serviceCon = new ET_Service_Contract_Years__c();
        serviceCon.Name = 'Pricing Contract Years';
        serviceCon.ET_Contract_Years__c = '1 Yr,2 Yrs,3 Yrs,4 Yrs,5 Yrs,6 Yrs,7 Yrs,8 Yrs,Multiple';
        insert serviceCon;
        test.startTest();
        ET_CommonDataController.getPicklistvalues('ET_Service_Request_Common_Data__c',new List<String>{'ET_Contract_Type__c'});
        ET_CommonWorkForceController.getPicklistvalues('ET_Service_Request_Common_Data__c',new List<String>{'ET_Fleet_Type__c'});
        test.stopTest();
    }
}