@isTest
public class CICO_InspectionCtrlTest {
    
    private static testmethod void inspectionTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];        
       
        User user1 = new User();
        user1.Username = 'stand3423@jana9334.com';
        user1.Email = 'us1@test.com';
        user1.LastName = 'LastName1';
        user1.FirstName = 'FirstName1';
        user1.Alias ='u1';
        user1.CommunityNickname ='use1';
        user1.ProfileId =p.id;
        user1.ETI_Inspection_Center__c='DXB-RL-M';
        
        user1.EmailEncodingKey='UTF-8';
        user1.LanguageLocaleKey='en_US';
        user1.LocaleSidKey='en_US';
        user1.TimeZoneSidKey='America/Los_Angeles';
        user1.Country = 'US';
        user1.Title = 'Territory Manager';
        user1.EmployeeNumber ='123456';
        user1.Grade__c='OPER-CICO';
        insert user1;
       
        Account acc = new Account();
        acc.firstName ='Jana';
        acc.lastName ='Jana';
        acc.ETIN_Employee_Id__c = '123456';
        acc.Type='Employee';
        insert acc;
           
        
        system.runAs(user1){
        
            CICO_InspectionCtrl.getUserDetails();
            CICO_InspectionCtrl.getUserLoginInfo();
             CICO_InspectionCtrl.getUserLocationInfo();
        }
        
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
        Vehicle_Master__c vehicleMaster = new Vehicle_Master__c();
        vehicleMaster.Asset_Number__c = 'Test';
        vehicleMaster.Internal_No__c = 'D012413';
        vehicleMaster.Plate_Number__c ='1224';
        vehicleMaster.Plate_colour_code__c='AE';
        vehicleMaster.Plate_Source__c = 'Dubai';
        vehicleMaster.Plate_Type__c ='Private';
        insert vehicleMaster;
        
        String fileData = 'testfilename';
        string jsonstr='[{"strFileName":"Passport.pdf","strFileType":"application/pdf","strBase64Data":"'+fileData+'"}]';
        CICO_InspectionCtrl.getIntimationWithRelatedDetails();
       
        CICO_InspectionCtrl.addImagesToRecId(veh.Id,jsonstr);
        
        ContentDocument testContDoc = new ContentDocument();
        ContentVersion testContVer = new ContentVersion();
        ContentDocumentLink testContDocLink = new ContentDocumentLink(); 
        
        //Populate and create ContentVersion
        testContVer.Title = 'MarkedDiagram';
        testContVer.PathOnClient = 'MarkedDiagram.txt';
        testContVer.VersionData = Blob.valueOf('Test Content');   
        testContVer.IsMajorVersion = true;
        insert testContVer;
        
        id contentDocID = [select ContentDocumentId from ContentVersion where id=:testContVer.Id].ContentDocumentId;
        //Populate and create ContentDocumentLink
        testContDocLink.LinkedEntityId = veh.Id;
        testContDocLink.ContentDocumentId = contentDocID;
        
        insert testContDocLink;
        
        CICO_Workshop_Location__c  glLocation = new CICO_Workshop_Location__c();
        insert glLocation;
        
        CICO_Check_In__c checkin = new CICO_Check_In__c();
        checkin.Internal_No__c = vehicleMaster.Id;
        checkin.Check_In_Date__c = System.today().adddays(5);
        checkin.Check_In_for__c = '	Maintenance';
        checkin.Check_in_fuel_reading__c = 10;
        checkin.Check_In_Status__c='Check In';
        //checkin.Check_in_Location__c = glLocation.id;
        insert checkin;
        
        CICO_Check_Out__c Checkout = new CICO_Check_Out__c();
        Checkout.Cassette__c = true;
        Checkout.Check_Out_fuel_reading__c = 45;
        Checkout.Check_Out_Reading__c = 4999;
        Checkout.Check_Out_Location__c = glLocation.id;
        Checkout.Internal_No__c = vehicleMaster.Id;
        Checkout.Check_Out_For__c = 'Maintenance';
        Checkout.Check_Out_Status__c='Check Out';
        insert Checkout;
        
        CICO_Child_Asset__c Childasset = new CICO_Child_Asset__c();
        Childasset.Check_Out__c = Checkout.id;
        //Childasset.Check_In__c = Checkin.id;
        insert Childasset;
        
         CICO_Child_Asset__c Childasset1 = new CICO_Child_Asset__c();
        //Childasset1.Check_Out__c = Checkout.id;
        Childasset1.Check_In__c = Checkin.id;
        insert Childasset1;
        
        //test logic for vf page ctrl - CICO_InspectionPdfCtrl
        PageReference pageRef = Page.CICO_InspectionPdfPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', veh.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(veh);
        CICO_InspectionPdfCtrl testpdf = new CICO_InspectionPdfCtrl(sc);
        CICO_InspectionCtrl inspCtrl = new CICO_InspectionCtrl();
        CICO_InspectionCtrl.getRecordFileDetails(veh.Id);
        CICO_InspectionCtrl.getCheckOutInfo();
        CICO_InspectionCtrl.getCheckOutDetails(vehicleMaster.Id,'Maintenance');
        CICO_InspectionCtrl.getCheckInDetails(vehicleMaster.Id,'Maintenance');
        
       CICO_InspectionCtrl.getVehicleInfo(vehicleMaster.Id);
       CICO_InspectionCtrl.getselectOptions('Case','Status');
        CICO_InspectionCtrl.getWorkshopCoord();
        CICO_InspectionCtrl.updateVehicleMaster(vehicleMaster.Id,'Car');
        CICO_InspectionCtrl.getVehicleMasterList('1224','AE','Dubai','Private');
        CICO_InspectionCtrl.deleteCheckOutChildAssets(Checkout.id);
        CICO_InspectionCtrl.deleteCheckInChildAssets(checkin.Id);
         CICO_InspectionCtrl.sendCheckOutToOracle(Checkout.id);
        CICO_InspectionCtrl.getVehicleChildAssetCustomerInfo('B002131','Vehicle Rental');
        CICO_InspectionCtrl.getVehicleChildAssetCheckIn('B002131','Vehicle Rental');
        
       CICO_InspectionCtrl.deleteFilewithVersionId(testContVer.Id);
       CICO_InspectionCtrl.getCheckInDetailsByCheckInID(checkin.Id);
       CICO_InspectionCtrl.getChildAssetDetails(Checkout.id);
       CICO_InspectionCtrl.getCheckOutDetailsByCheckOutRecId(Checkout.id);
       CICO_InspectionCtrl.deleteRecordInSF(Checkout.id);
       CICO_InspectionCtrl.getCheckInInfo();
       CICO_InspectionCtrl.getChildAssetDetailsCI(checkin.Id);
      // CICO_InspectionCtrl.getVehicleAssetType(vehicleMaster.Id);
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CICO_Services_Mock()); 
        CICO_InspectionCheckInCreationService.createInspectionInOracle(inti.Id);
        
        CICO_InspectionCtrl.submitIntimationReq(inti.Id);
        
        //Test.setMock(HttpCalloutMock.class, new CICO_Services_Mock2());
        CICO_InspectionCtrl.sendCheckInToOracle(checkin.Id);    
      
        
        Test.stopTest(); 
        
       
    
    }
  
}