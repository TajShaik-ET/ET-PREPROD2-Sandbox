@isTest 
public class CICO_checkOutSendEmailCtrl_Test {
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
        
        
        PageReference pageRef = Page.CICO_CheckOutPdf;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', veh.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(veh);
        CICO_checkOutPdfCtrl testpdf = new CICO_checkOutPdfCtrl(sc);
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
        
        CICO_Check_Out__c Checkout = new CICO_Check_Out__c();
        Checkout.Cassette__c = true;
        Checkout.Check_Out_fuel_reading__c = 45;
        Checkout.Check_Out_Reading__c = 4999;
        Checkout.Document_No__c = '23234';
        Checkout.Internal_No__c = vehicleMaster.Id;
        Checkout.Check_Out_For__c = 'Maintenance';
        Checkout.Check_Out_Status__c='Check Out';
        insert Checkout;
        
        PageReference pageRef = Page.CICO_CheckOutPdf;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', veh.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(veh);
        CICO_checkOutSendEmailCtrl.sendEmailToCustomer('Test@gmail.com',Checkout.id);
    }
    

}