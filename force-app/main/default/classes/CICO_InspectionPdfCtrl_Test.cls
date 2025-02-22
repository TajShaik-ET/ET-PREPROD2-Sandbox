@isTest 
public class CICO_InspectionPdfCtrl_Test {
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
        CICO_InspectionPdfCtrl testpdf = new CICO_InspectionPdfCtrl(sc);
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
        
        ContentVersion testContVer1 = new ContentVersion();
        testContVer1.Title = 'Sign2';
        testContVer1.PathOnClient = 'MarkedDiagram.txt';
        testContVer1.VersionData = Blob.valueOf('Test Content');   
        testContVer1.IsMajorVersion = true;
        insert testContVer1;
        
        ContentVersion testContVer2 = new ContentVersion();
        testContVer2.Title = 'Sign3';
        testContVer2.PathOnClient = 'MarkedDiagram.txt';
        testContVer2.VersionData = Blob.valueOf('Test Content');   
        testContVer2.IsMajorVersion = true;
        insert testContVer2;
        
        ContentVersion testContVer3 = new ContentVersion();
        testContVer3.Title = 'Sign4';
        testContVer3.PathOnClient = 'MarkedDiagram.txt';
        testContVer3.VersionData = Blob.valueOf('Test Content');   
        testContVer3.IsMajorVersion = true;
        insert testContVer3;
        
        ContentDocumentLink testContDocLink = new ContentDocumentLink(); 
        id contentDocID = [select ContentDocumentId from ContentVersion where id=:testContVer.Id].ContentDocumentId;
        testContDocLink.LinkedEntityId = veh.Id;
        testContDocLink.ContentDocumentId = contentDocID;
        insert testContDocLink;
        
         ContentDocumentLink testContDocLink1 = new ContentDocumentLink(); 
        id contentDocID1 = [select ContentDocumentId from ContentVersion where id=:testContVer1.Id].ContentDocumentId;
        testContDocLink1.LinkedEntityId = veh.Id;
        testContDocLink1.ContentDocumentId = contentDocID1;
        insert testContDocLink1;
        
         ContentDocumentLink testContDocLink2 = new ContentDocumentLink(); 
        id contentDocID2 = [select ContentDocumentId from ContentVersion where id=:testContVer2.Id].ContentDocumentId;
        testContDocLink2.LinkedEntityId = veh.Id;
        testContDocLink2.ContentDocumentId = contentDocID2;
        insert testContDocLink2;
        
         ContentDocumentLink testContDocLink3 = new ContentDocumentLink(); 
        id contentDocID3 = [select ContentDocumentId from ContentVersion where id=:testContVer3.Id].ContentDocumentId;
        testContDocLink3.LinkedEntityId = veh.Id;
        testContDocLink3.ContentDocumentId = contentDocID3;
        insert testContDocLink3;
        
        
        PageReference pageRef = Page.CICO_CheckInPdf;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', veh.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(veh);
        CICO_InspectionPdfCtrl testpdf = new CICO_InspectionPdfCtrl(sc);
    }

}