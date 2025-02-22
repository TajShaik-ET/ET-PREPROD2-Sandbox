@isTest(seeAllData=true)
public class ETVIN_VehicleTheftCtrlTest {

    private static testmethod void getTheftCtrlDetails(){
        VehicleInsEmailNotification__c ve = new VehicleInsEmailNotification__c();
        ve.Name = 'test';
        ve.Label__c = 'test';
        ve.Email__c = 'test@gmail.com';
        insert ve;
        ETVIN_VehicleTheftCtrl.sendEmailtoTheList(new list<string>{'test'});
        ETVIN_VehicleTheftCtrl.getVehicleEmailRecipients();
        
        Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.Name = 'test';
        vm.Internal_No__c ='123';
        insert vm;
        Account acc = new Account();
        //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Partner').getRecordTypeId();
        acc.Name = 'XYZW2332';

        insert acc;
        
        ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
        etv.Vehicle__c = vm.Id;
        etv.ETVIN_Insurance_Status__c = 'Active';
        etv.ETVIN_Request_Status__c  = 'Insurance Approved';
        etv.ETVIN_Insurance_Company__c = acc.id;
        etv.ETVIN_Effective_Date__c = system.today();
        etv.ETVIN_Expiry_Date__c =system.today()+365;
        insert etv;
        
        Correction_Cancel_Request__c cr = new Correction_Cancel_Request__c();
        cr.Prove_Theft_certificate__c = true;
        cr.Cancel_Theft_Report__c = true;
        cr.Transfer_Profession_Certificate__c = true;
        cr.Police_Report__c = true;
        cr.NOC_Receive_Vehicle__c = true;
        cr.Vehicle_Master__c = vm.Id;
        cr.Correction_for__c ='Chassis Number';
        cr.Insurance_Company__c = acc.id;
        cr.Vehicle_Insurance_Policy__c = etv.Id;
        insert cr;
        
        VehicleTheftPrcsDocs__c vt = new VehicleTheftPrcsDocs__c();
        vt.name ='Prove_Theft_certificate__c';
        vt.Doc_API_Name__c = 'Prove_Theft_certificate__c';
        vt.Doc_label__c = 'Prove Theft';
        insert vt;
       
        
        ETVIN_VehicleTheftCtrl.getRelatedDocList(cr.Id);
       //ETVIN_VehicleTheftCtrl.getTheftReportData(cr.Id);
       // ETVIN_VehicleTheftCtrl.getNOCReportData(cr.Id);
        //ETVIN_VehicleTheftCtrl.getProfCertData(cr.Id);
        //ETVIN_VehicleTheftCtrl.getCanceLetterData(cr.Id);
       
        ETVIN_VehicleTheftCtrl.getFiles(cr.Id);
        ETVIN_VehicleTheftCtrl.updateRecord(cr.Id,'Prove Theft',true);
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ETVIN_VehicleTheftCtrl.UpdateFiles(cdList[0].Id,'test',cr.Id);
         ETVIN_VehicleTheftCtrl.deleteRecord(cr.Id);
    }
}