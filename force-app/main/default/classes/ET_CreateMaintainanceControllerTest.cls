@isTest
public class ET_CreateMaintainanceControllerTest {
    /*static testMethod void createMaintenanceRequest(){
        Maintenance_Questionnaire__c mQ = new Maintenance_Questionnaire__c();
        mQ.Equipments__c = 'test';
        //Insert mQ;
        Id accountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        Account acc= new Account();
        acc.name='Test Account';
        Insert acc;

        Id oppRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Maintainance').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = oppRecordType;
        opp.Name = 'Test Opportunity';
        opp.AccountId = acc.Id;
        opp.Type = 'New Business';
        opp.CloseDate = Date.today()+2;
        opp.StageName = 'Decision';
        opp.ETSALES_GL_Services__c = 'Maintenance Services - Contracted';
        Insert opp;
        List<Maintenance_Request__c> maintenanceRequestList = new List<Maintenance_Request__c>();
        for(Integer i=0;i<=3;i++){
            Maintenance_Request__c newMR = new Maintenance_Request__c();
            newMR.Opportunity__c = opp.Id;
            //newMR.Maintenance_Questionnaire__c = mQ.Id;
            maintenanceRequestList.add(newMR);
        }
        //Insert maintenanceRequestList;
        Boolean reqCreated = ET_CreateMaintainanceController.createMaintenanceRequestRecord(maintenanceRequestList,opp.Id, mQ );
    }
        */
}