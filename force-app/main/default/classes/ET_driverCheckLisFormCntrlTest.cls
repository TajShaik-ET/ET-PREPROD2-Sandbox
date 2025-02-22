/************************************************************************************************************************
 * Name               : ET_driverCheckLisFormCntrlTest                                                                  *
 * Description        : Apex Test Class for ET_driverCheckLisFormCntrl                                                  *
 * Created Date       : 02/Feb/2024                                                                                     *
 * Created By         : Taj Shaik(SMAARTT)                                                                              *
 * -----------------------------------------------------------------------------------------------                      *
 * VERSION   AUTHOR      DATE                COMMENTS                                                                   *
 * 1.0       Taj Shaik   02/Feb/2024         Initial Draft.                                                             *
 ***********************************************************************************************************************/@isTest
public class ET_driverCheckLisFormCntrlTest {
    @isTest
    static void testGetDriverCheckListDetails() {
        // Create test data
        Account Accnt = new Account();
        Accnt.FirstName='Test FName';
        Accnt.LastName='Test LName';
        Accnt.PersonEmail='test@yahoo.com';
        Accnt.Employee_Task__c='Driver Checklist Form';
        insert Accnt;
        
        Vehicle_Master__c VMRec = new Vehicle_Master__c();
        VMRec.Name ='B0053601';
        VMRec.Internal_No__c='B0053601';
        insert VMRec;
        
        Driver_Daily_Check_List__c DriverCKList = new Driver_Daily_Check_List__c();
        DriverCKList.Driver__c = Accnt.Id;
        DriverCKList.Internal_Number__c = VMRec.Id;
        DriverCKList.Status__c = 'Submitted';
        DriverCKList.Station__c = 'Test Station';
        DriverCKList.Branch__c = 'Test Branch';
        DriverCKList.KM_Reading__c = '100';
        insert DriverCKList;
        
        String fileData = '[{"filename": "Signature.png","filetype": "image/png","base64": "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"}]';
        String queryDriver = 'SELECT Type__c,Category_Ar__c,Category_En__c,Category_Ur__c,Question_Ar__c,Question_En__c,Question_Ur__c,Severity_Ar__c,Number__c,Version__c,Sequence__c,Show_Number__c,Show_Category__c FROM DriverChecklistMaster__mdt ORDER BY Sequence__c ASC NULLS LAST'; //WHERE Number__c = 1 
        String driverChecklistWrpMdt ='[{"category":{"ar":"تفحص زيوت الحافلة","en":"Bus Oil Check","ur":"بس کے سيال مادوں"},"categoryCount":8,"categoryShow":true,"checkPoint":{"ar":"فحص وتفقد زيوت الحافلة","en":"Examination of the bus fluids","ur":"بس کے سيال مادوں"},"iconSelectedAction":"approve","optionType":"Radio","seq":0.001,"severity":{"ar":"High"},"srNo":1,"srNoCount":8,"srNoShow":true,"response":"Selected"}]';         
        
        // Call the method to be tested
        ET_driverCheckLisFormCntrl.getDriverChecklistsMdt(queryDriver);
        ET_driverCheckLisFormCntrl.getDriverCheckListRecord('Draft');
        ET_driverCheckLisFormCntrl.saveDriverCheckListLines(DriverCKList.Id, driverChecklistWrpMdt);
        ET_driverCheckLisFormCntrl.deleteChecklist(DriverCKList.Id);
        ET_driverCheckLisFormCntrl.fetchRecords(queryDriver);
        ET_driverCheckLisFormCntrl.addFilesToRecords(DriverCKList.Id,fileData);
        ET_driverCheckLisFormCntrl.addFilesToRecords(DriverCKList.Id,fileData);
    }
    
    public class DriverChecklistWrapper {
        @AuraEnabled public Decimal seq { get; set; }
        @AuraEnabled public Decimal srNo { get; set; }
        @AuraEnabled public String iconSelectedAction { get; set; }
        @AuraEnabled public String response { get; set; }
        @AuraEnabled public Boolean commentReq { get; set; }
        @AuraEnabled public String optionType { get; set; }
        @AuraEnabled public Decimal srNoCount { get; set; }
        @AuraEnabled public Boolean srNoShow { get; set; }
        @AuraEnabled public LangWrapper category { get; set; }
        @AuraEnabled public Decimal categoryCount { get; set; }
        @AuraEnabled public Boolean categoryShow { get; set; }
        @AuraEnabled public LangWrapper checkPoint { get; set; }
        @AuraEnabled public LangWrapper severity { get; set; }
        public DriverChecklistWrapper() {
            this.category = New LangWrapper();
            this.checkPoint = New LangWrapper();
            this.severity = New LangWrapper();
            this.iconSelectedAction ='';
        }
    }
    
    public class LangWrapper {
        @AuraEnabled public String ar { get; set; }
        @AuraEnabled public String en { get; set; }
        @AuraEnabled public String ur { get; set; }
    }
}