@isTest public class CICO_checkInSendEmailCtrl_Test {
     @isTest
  
    Public Static void CheckOutTest(){
        
        CICO_Intimation__c inti = new CICO_Intimation__c();
        inti.Name = '123242';
        inti.Intimation_Date__c = system.today();
        inti.Intimation_No__c='223323';
        inti.PO_Header_ID__c=1234;
        inti.Vendor_ID__c=4233;
        insert inti;
        
        CICO_Intimation_Line__c line = new CICO_Intimation_Line__c();
        line.Name ='1';
        line.Intimation_ID__c = inti.Id;
        line.PO_Line_ID__c = 12332;
        insert line;
        
        CICO_Vehicle_Spec__c veh = new CICO_Vehicle_Spec__c();
        veh.Name ='BNBNBN343DD23';
        veh.Intimation_Line__c= line.Id;
        veh.Inspection_Status__c = 'Approved';
        insert veh;
        
        ContentVersion testContVer = new ContentVersion();
        testContVer.Title = 'MarkedDiagram';
        testContVer.PathOnClient = 'MarkedDiagram.txt';
        testContVer.VersionData = Blob.valueOf('Test Content');   
        testContVer.IsMajorVersion = true;
        insert testContVer;
        
        ContentDocumentLink testContDocLink = new ContentDocumentLink(); 
        id contentDocID = [select ContentDocumentId from ContentVersion where id=:testContVer.Id].ContentDocumentId;
        testContDocLink.LinkedEntityId = veh.Id;
        testContDocLink.ContentDocumentId = contentDocID;
        insert testContDocLink;
        
        
        PageReference pageRef = Page.CICO_CheckInPdf;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', veh.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(veh);
        CICO_checkInPdfCtrl testpdf = new CICO_checkInPdfCtrl(sc);
    }
    @isTest 
    Public Static void CheckOutTest1(){
        
        CICO_Intimation__c inti = new CICO_Intimation__c();
        inti.Name = '123242';
        inti.Intimation_Date__c = system.today();
        inti.Intimation_No__c='223323';
        inti.PO_Header_ID__c=1234;
        inti.Vendor_ID__c=4233;
        insert inti;
        
        CICO_Intimation_Line__c line = new CICO_Intimation_Line__c();
        line.Name ='1';
        line.Intimation_ID__c = inti.Id;
        line.PO_Line_ID__c = 12332;
        insert line;
        
        CICO_Vehicle_Spec__c veh = new CICO_Vehicle_Spec__c();
        veh.Name ='BNBNBN343DD23';
        veh.Intimation_Line__c= line.Id;
        veh.Inspection_Status__c = 'Approved';
        insert veh;
        
        ContentVersion testContVer = new ContentVersion();
        testContVer.Title = 'Sign';
        testContVer.PathOnClient = 'MarkedDiagram.txt';
        testContVer.VersionData = Blob.valueOf('Test Content');   
        testContVer.IsMajorVersion = true;
        insert testContVer;
        
        ContentDocumentLink testContDocLink = new ContentDocumentLink(); 
        id contentDocID = [select ContentDocumentId from ContentVersion where id=:testContVer.Id].ContentDocumentId;
        testContDocLink.LinkedEntityId = veh.Id;
        testContDocLink.ContentDocumentId = contentDocID;
        insert testContDocLink;
        
        Vehicle_Master__c vehicleMaster = new Vehicle_Master__c();
        vehicleMaster.Asset_Number__c = 'Test';
        vehicleMaster.Internal_No__c = 'D012413';
        vehicleMaster.Plate_Number__c ='1224';
        vehicleMaster.Plate_colour_code__c='AE';
        vehicleMaster.Plate_Source__c = 'Dubai';
        vehicleMaster.Plate_Type__c ='Private';
        insert vehicleMaster;
        
         CICO_Check_In__c checkin = new CICO_Check_In__c();
        checkin.Internal_No__c = vehicleMaster.Id;
        checkin.Check_In_Date__c = System.today().adddays(5);
        checkin.Check_In_for__c = '	Maintenance';
        checkin.Check_in_fuel_reading__c = 10;
        checkin.Check_In_Status__c='Check In';
        checkin.Document_No__c = '1234';
        insert checkin;
        
        PageReference pageRef = Page.CICO_CheckInPdf;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', veh.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(veh);
        CICO_checkInSendEmailCtrl.sendEmailToCustomer('Test@gmail.com',checkin.id);


    }
}