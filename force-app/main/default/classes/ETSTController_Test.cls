/*
CreateDate :07/27/2020
Created By:Sree Chandu
Description:This is a Test class for Student controller test Class.
*/
@isTest
public class ETSTController_Test {
    @testsetup
    public static void studentControllerTestDetails(){
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User u=[select id from user where profileId=:profile1.Id and isactive=true LIMIT 1];
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId(); 
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com',etst_coordinator__c=userinfo.getUserId(),ET_IBAN_Code__c='AE070331234567890123456');
        System.runAs(u){
            insert acc; 
        }
        User portalUser=[select id from user where contactId=:acc.PersonContactId and isActive=true LIMIT 1];
        System.debug('person '+acc.PersonContactId); 
        /*User portalUser = new User(
//UserRoleId = portalRole.Id,
ProfileId = profile1.Id,
ContactId=acc.PersonContactId,
Username = System.now().millisecond() + 'test2@test.com',
Alias = 'test2',
Email='test2.test2@wayneenterprises.com',
EmailEncodingKey='UTF-8',
Firstname='test2',
Lastname='test2',
LanguageLocaleKey='en_US',
LocaleSidKey='en_US',
TimeZoneSidKey='America/Chicago'
);
Database.insert(portalUser);*/
        //User portalUser=[select Id from user where profileId=:profile1.Id LIMIT 1];
        Account acc1 = new Account(RecordTypeId=schoolRecordTypeId,Name='Test',etst_coordinator__c=userinfo.getUserId(),ET_IBAN_Code__c='AE070331234567890123456');
        insert acc1;
        
        ET_Sales_Agreement__c agr = new ET_Sales_Agreement__c(Salesforce_Customer__c=acc1.Id);
        insert agr;
        
        ETST_School__c schl = new ETST_School__c(Name='Test', Customer__c = acc1.Id,ETST_Sales_Agreement__c=agr.Id,ETST_Account_Type__c='University');
        insert schl;
        
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_School_Name__c=schl.Id,
                                                    ETST_Account_Name__c=acc.Id,ETST_School__c=acc1.Id);
        insert stdnt;
        
        
        ETSTController.updateProfile('784-1234-1234567-1', '+971 551234567',acc1.Id );
        ETST_Price_List__c price = new ETST_Price_List__c(
            ETST_Monthly_Allowed__c=false,
            ETST_Half_Yearly_Allowed__c=true,
            ETST_Area__c='SHJ',
            ETST_Yearly_Allowed__c=true,
            ETST_Quarterly_Allowed__c=false,
            ETST_Transport_Type__c='Two way',
            ETST_Pro_Rate__c='Month',
            ETST_Is_Active__c=true,
            ETST_On_Demand_Allowed__c=true,
            ETST_Sales_Agreement__c=agr.Id,
            ETST_Cancellation_Fee__c = 0,
            ETST_Ondemand_Rate_per_Day__c=0,
            ETST_Cancellation_Mode__c = System.Label.ETST_Cancel_Month,
            ETST_Amount__c=500
        );
        insert price;
        
        ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Paid_By__c = 'Self',ETST_Pick_Up_Start_Date__c=system.today(),
                                                                 ET_Sales_Agreement__c=agr.Id,ETST_Pick_Up_End_Date__c=system.today()+60,ETST_Cancellation_End_Date__c=system.today()+20,
                                                                 ETST_Cancellation_Effective_Date__c=system.today()+20,ETST_Service_Type__c='Yearly',ETST_Fare_Charges__c=1000,ETST_Price_List__c=price.Id,
                                                                 ET_Account__c=acc.Id,ETST_User__c=portalUser.Id,
                                                                 ETST_Status__c='Under Review',
                                                                 ETST_Pick_Up_From__c='Test - United Arab Emirates',
                                                                 ETST_Prev_Pickup_From__c = 'test',ETST_Drop_Off_To__c ='fcghjkm');
        insert etreq;
        
        ETST_Payment__c newPayment = new ETST_Payment__c(Bank_statement_Ref__c='5678906789',ET_Service_Request__c =etreq.Id);
        insert newPayment;
        
        Invoice__c inv = new Invoice__c(ETST_Active__c=true,Service_Request__c=etreq.Id);
        insert inv;
        
        ETST_Address__c etst1 = new ETST_Address__c();
        etst1.account__c = acc.id;
        etst1.ET_Line_1__c = 'Test-line';
        etst1.ET_Country__c = 'AE';
        etst1.ET_City__c = 'Hyderabad';
        etst1.ET_Line_2__c = '15-45,Hitec city';
        etst1.ET_Address_Type__c = 'BILL_TO';
        etst1.ET_Is_Primary__c = true;
        insert etst1;
        
        ContentVersion contentVersionInsert = new ContentVersion(Title = 'Test',PathOnClient = 'Test.pdf',VersionData = Blob.valueOf('Test Content Data'),
                                                                 IsMajorVersion = true );
        insert contentVersionInsert;    
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :contentVersionInsert.Id];
        
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=stdnt.id;
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
        
        List<Id> serviceRecordIds = new List<Id>();
        serviceRecordIds.add(etreq.Id);
        
        
        ETSTController.ETSTWrapper objETSTWrap = ETSTController.getStudentDetails(true);
        try{
            objETSTWrap = ETSTController.getStudentDetails(null);
        }catch(exception e){
            system.debug('tested');
        }
        
       /* ETSTController.PicklistEntryWrapper objPickListEntryWrap = new ETSTController.PicklistEntryWrapper();
        objPickListEntryWrap.active = 'true';
        objPickListEntryWrap.defaultValue = 'true';
        objPickListEntryWrap.label = 'true';
        objPickListEntryWrap.value = 'true';
        objPickListEntryWrap.validFor = 'true'; */
        
        ETSTController.BankDetails objBankDetails = new ETSTController.BankDetails();
        objBankDetails.BankName = 'ADCB';
        objBankDetails.BankAccountNumber = '112103456789023'; 
        objBankDetails.IBAN = '123456';
        objBankDetails.Address = '15/6 Deira city center';
        objBankDetails.invoice = inv;    
        ETSTController.updateUserLoc('Dubai',acc1.id);
        ETSTController.updateUserChangedLoc('Dubai',acc1.id);
        ETSTController.createInvoice(etreq.Id);
        ETSTController.getStudentInfo(stdnt.Id,'en');
        
        ETSTController.getServiceTypes(stdnt.Id, 'Two way');
        
        ETSTController.deactivateStudent(stdnt.Id, etreq, 500, 'test','test','test','AE070331234567890123456','test','test',testContent.ContentDocumentId);
        try{
          // ETSTController.deactivateStudent(null,null,null,null,null,null,null,null,null,null);
        }catch(exception e){
            system.debug('exception '+e);
            system.debug('tested');
        } 
        
       // ETSTController.createNewStudent(schl.Id, stdnt);
        try{
            ETSTController.createNewStudent(null,null);
        }catch(exception e){
            system.debug('tested');
        }
        
        //ETSTController.getFareDetails(stdnt.Id, 'Two way', 10.0, 10.0);
		//ETSTController.getFareDetailsbyarea(stdnt.Id,'Emirates', 'Two way', 10.0, 10.0);
        try{
          //  ETSTController.getFareDetailsbyarea(stdnt.Id,'Emirates', 'Two way', 10.0, 10.0);   
            
            //ETSTController.getFareDetails(null,null,null,null);
        }catch(exception e){
            system.debug('tested');
        } 
        System.Test.startTest();
        ETSTController.viewStudentService(stdnt.Id);
        try{
            ETSTController.viewStudentService(null);
        }catch(exception e){
            system.debug('tested');
        } 
        
        ETSTController.getLocationDetails('10.0', '10.0');
        ETSTController.getAddressSet('Dubai');
        ETSTController.getAddressDetailsByPlaceId('Dubai');
        ETSTController.getEmployerAddress();
        try{
            ETSTController.getEmployerAddress();
        }catch(exception e){
            system.debug('tested');
        }
        ETSTController.cancelStudentService(etreq);
        try{
            ETSTController.cancelStudentService(null);
        }catch(exception e){
            system.debug('tested');
        }
        
        /*system.runAs(portalUser)  {
ETSTController.getProfileDetails();
}*/
        //system.runAs(portalUser)  {
        //ETSTController.createNewService(etreq, true, system.today()+10, system.today()+60, etst1, 'Name', 'Employer', agr.Id, price.Id);
        //ETSTController.createNewService(etreq, true, system.today()+10, system.today()+60, etst1, null, 'Employer', agr.Id, price.Id);
        //}
        try{
            ETSTController.createNewService(null,null,null,null,null,null,null,null,null,null);
           
        }catch(exception e){
            system.debug('tested');
        }
        ETSTController.getQuaerterlyPickupDates(String.valueOf(system.today()));
        ETSTController.getHalfyrlyPickupDates(String.valueOf(system.today()));
        et_service_Request__c etreq1 = etreq.clone();
        ETSTController.updateService(etreq.id, etreq1, agr.Id);
        try{
            ETSTController.updateService(null,null,null);
        }catch(exception e){
            system.debug('tested');
        } 
        //  System.runAs(portalUser){
       
        //}
        ETSTController.getImageContent(contentlink.ContentDocumentId, stdnt.Id);
        try{
            ETSTController.getImageContent(null,null);
        }catch(exception e){
            system.debug('tested');
        } 
        
        System.Test.stopTest();
        
    }
    @istest
    public static void testMethod3(){
        System.Test.startTest();
         ETSTController.getProfileDetails();
        ET_Service_Request__c etreq = [
            SELECT Id, ET_Account__r.PersonEmail, ETST_Price_List__c, ETST_Cancellation_Effective_Date__c, Payment_Status__c,
            ETST_Student__c, ETST_Paid_By__c, ETST_Pick_Up_Start_Date__c, ET_Sales_Agreement__c, ETST_Prev_Status__c,
            ETST_Drop_Off_To__c, ETST_Prev_Pickup_From__c, ETST_Pick_Up_End_Date__c, ETST_Cancellation_End_Date__c,
            ETST_Pick_Up_From__c, ETST_Service_Type__c, ETST_Fare_Charges__c, ETST_Status__c, 
            ET_Account__r.PersonContactId, ET_Account__c, ETST_User__c, ETST_Prev_Pickup_Loc__Latitude__s,ETST_Prev_Pickup_Loc__Longitude__s,ETST_Prev_Dropoff_Loc__Latitude__s,ETST_Prev_Dropoff_Loc__Longitude__s
            ,ETST_Prev_DropOff_To__c FROM ET_Service_Request__c
            LIMIT 1
        ];
        ETSTController.getServiceRecord(etreq.id);
    
        ContentVersion contentVersionInsert = new ContentVersion(Title = 'Test1',PathOnClient = 'Test1.pdf',VersionData = Blob.valueOf('Test Content Data1'),
                                                                 IsMajorVersion = true );
        insert contentVersionInsert;    
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :contentVersionInsert.Id];
        
        ETST_Student__c stdnt=[select id from ETST_Student__c LIMIT 1];
        List<Id> serviceRecordIds = new List<Id>();
        serviceRecordIds.add(etreq.Id);
        ETSTController.getSchoolList('University');
        ETSTController.getParentBankDetails(stdnt.Id);
        Id schoolId=[select id from ETST_School__c LIMIT 1].Id;
        ETSTController.changeStudentSchool(stdnt.Id,schoolId,'xxx','xxx','xxx',
                                           'xxx','xxx','xxx',etreq,
                                            10000,true,testContent.ContentDocumentId);              
        ETSTController.updateBulkTransportRequestStatus(serviceRecordIds, 'status');
        ETSTController.updateLocation('25.545545','25.545545',etreq.Id,'Pcik');
        ETSTController.updateLocation('25.545545','25.545545',etreq.Id,'Pick');
        ETSTController.rejectService(etreq);
        etreq.ETST_Status__c='Location Update - Under Review';
        update etreq;
        ETSTController.rejectService(etreq);
        try{
            ETSTController.updateBulkTransportRequestStatus(null,null);
        }catch(exception e){
            system.debug('tested');
        } 
        ETSTController.buildErrorResponse('source', 'errorMessage', 'stackTrace');
        
        ETSTController.getParentPaymentHistory(etreq.Id);
        try{
            ETSTController.getParentPaymentHistory(null);
        }catch(exception e){
            system.debug('tested');
        }
        
        ETSTController.getInvoice(etreq.Id);
        try{
            ETSTController.getInvoice(null);
        }catch(exception e){
            system.debug('tested');
        }

        ETSTController.getRefundAmount(etreq,true);
        ETSTController.getSelectedTransportRequests(1, 'University', 'Employer', 'status');
        ETSTController.getTransportRequests(1);
        try{
            ETSTController.getTransportRequests(null);
        }catch(exception e){
            system.debug('tested');
        } 
        ETSTController.attachmentInsert('fileName', 'fileBody', stdnt.Id);
        
        sObject obj = new ET_Service_Request__c();
       // ETSTController.getDependentPicklistValues(obj, 'Payment_Status__c', 'ETST_Paid_By__c');
        System.Test.stopTest();
        
    }
    @istest
    public static void testMethod1(){
        System.Test.startTest();
         
        ET_Service_Request__c etreq=[select id,ET_Account__r.personemail from ET_Service_Request__c LIMIT 1];
        ETST_Payment__c newPayment = new ETST_Payment__c();
        ETSTController.decimalToBinary(10);
       // ETSTController.base64ToBits('Test');
        ETSTController.getParentCaseHistory();
        
        try{
            ETSTController.getParentCaseHistory();
        }catch(exception e){
            system.debug('tested');
        }
        ETSTController.getParentRefundHistory();
        try{
            ETSTController.getParentRefundHistory();
            ETSTController.createPayment(newPayment, etreq, 'Cheque');
            
        }catch(exception e){
            system.debug('tested');
        }
        System.Test.stopTest(); 
    }
    @istest
    public static void testMethod2(){
        System.Test.startTest();
        ET_Service_Request__c etreq=[select id,ET_Account__c,ET_Account__r.personemail,ETST_Status__c from ET_Service_Request__c LIMIT 1];
        ETST_Payment__c newPayment = new ETST_Payment__c(Bank_statement_Ref__c='5678906789',ET_Service_Request__c =etreq.Id);
        insert newPayment;
        string caseSchoolTransportRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('School_Transport').getRecordTypeId(); 
        Map<string,string> mapService= ETSTController.getServiceLocationDetails();
        ETSTController.getServiceDetails(etreq.Id);
	etreq.ETST_Status__c = 'Location Update - Under Review';
	update etreq;
        ETSTController.approveService(etreq.id, 'Test');
        
         Invoice__c inv = [Select Id from Invoice__c LIMIT 1];
         ETSTController.getServiceReqId(inv.Id);
       //  ETSTController.getAccount(etreq.ET_Account__c);
       // ETSTController.getPicklistValues(caseSchoolTransportRecordTypeId, 'Case', 'status');
        try{
            ETSTController.getServiceDetails(null);
        }catch(exception e){
            system.debug('tested');
        }
        ETSTController.updateTransportRequestStatus(etreq.Id, 'status', true);
        try{
            ETSTController.updateTransportRequestStatus(null,null,null);
            //ETSTController.activateOnholdService(etreq);
        }catch(exception e){
            system.debug('tested');
        } 
        ETSTController.createRefundRecord(1000,etreq.Id);
        ETSTController.activateOnholdService(etreq);
        ETSTController.getStudent(etreq.Id);
        ETSTController.getBankDetails(etreq.Id);
        ETSTController.emailUserInvoice(etreq.Id);
        ETSTController.getCaseTypes();
        try{
            ETSTController.createPayment(newPayment, etreq, 'Cash');
        }catch(exception e){
            system.debug('tested');
        }
        try{
            ETSTController.createInvoice(null);
        }catch(exception e){
            system.debug('tested');
        } 
        
        ET_Terms_and_Conditions__c vis = new ET_Terms_and_Conditions__c(Place_of_Visisbility__c='Vehicle Registration',ET_Service_Name__c = 'School',Active__c = true);
        insert vis;
        ETSTController.getTermsandConditions('Vehicle Registration', 'en');
        case cs = new case(Status='new',Origin='email');
        ETSTController.saveCase(cs);
        System.Test.stopTest();
    } 
    @istest
    public static void testMethod4(){
        Test.startTest();
        Id customerRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETT_Customer').getRecordTypeId();
        Account acc = new Account(RecordTypeId = customerRecTypeId,Name = 'Test',
                                  Phone = '976544456777',ETT_VAT_TRN_No__c ='test0009',ET_IBAN_Code__c='AE070331234567890123456');
        //insert acc;
        try{
            //ETSTController.saveUpdatedAccount('bankAccName','bankName','bankAccNumber',0.01,acc.Id);
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        
        ET_Service_Request__c etreq=[select id,ET_Account__c,ET_Account__r.personemail,ETST_Status__c from ET_Service_Request__c LIMIT 1];
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Document',
            VersionData = Blob.valueOf('Test Content'),
            PathOnClient = 'test.txt'
        );
        insert testContentVersion; 
        ContentDocumentLink existingContentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id FROM ContentDocument WHERE Title = 'Test Document' LIMIT 1].Id,
            LinkedEntityId = etreq.Id,
            ShareType = 'I'
        );
        insert existingContentLink;
        
        ETSTController.deleteDocuments(existingContentLink.ContentDocumentId);
        
        ETSTController.RefundDetailsWrapper wrapper = new ETSTController.RefundDetailsWrapper();
        wrapper.refundAmount = 100.0;
        wrapper.refundPercentage = 10.0;
        wrapper.noOfDaysOnhold = 7;
        
        Date date1 = Date.newInstance(2024, 1, 1);
        Date date2 = Date.newInstance(2024, 8, 21);

        ETSTController.getweekbetweentwodates(date1, date2);
        Blob pdfContent = Blob.valueOf('Dummy PDF Content');
        ETSTController.attachFile(etreq.Id, pdfContent);
        Test.stopTest();
    }
     @isTest
    public static void setupData() {

        Id schoolCoordinatorReadOnlyRtId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Coordinator_Read_Only').getRecordTypeId();
        //Id schoolCoordinatorReadOnlyRtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'ETST_School_Coordinator_Read_Only' AND SObjectType = 'ET_Service_Request__c' LIMIT 1].Id;
        Id schoolServiceRequestRtId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Service_Request').getRecordTypeId();
        //Id schoolServiceRequestRtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'ETST_School_Service_Request' AND SObjectType = 'ET_Service_Request__c' LIMIT 1].Id;
        
        Test.startTest();
        
        User u = [select id from user where Profile.Name = 'System Administrator' and isactive=true LIMIT 1];
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId(); 
        Account parent = [Select Id from Account WHERE RecordTypeId =: devRecordTypeId LIMIT 1];
            //new Account(RecordTypeId = devRecordTypeId,LastName = 'Test',PersonEmail='test@test.com');
        
        /*System.runAs(u){
            insert parent; 
        }*/
        
        /*Account acc = new Account(
            Name = 'Test Acc',
            RecordTypeId = schoolRecordTypeId
        );
        insert acc;*/
        
        ETST_School__c school = new ETST_School__c(Name = 'Test School');
        insert school;
 
        ETST_Student__c student = new ETST_Student__c(
            Name = 'Test Student',
            ETST_First_Name__c = 'Tests',
            ETST_School_Name__c = school.Id,
            ETST_Emirates_Id__c = '34356789',
            ETST_Gender__c = 'Male',
            ETST_Student_Id__c = '111',
            ETST_Emirate__c = 'Dubai',
            ETST_Date_of_Birth__c = Date.valueOf('2009-05-13'),
            ETST_Phone__c = '971581671070',
            ETST_Division__c = '4',
            ETST_Grade__c = 'A',
            ETST_Account_Name__c = parent.Id
        );
        insert student;
 
        ET_Service_Request__c serviceRequest1 = new ET_Service_Request__c(
            RecordTypeId = schoolCoordinatorReadOnlyRtId,
            ETST_Status__c = 'Service Confirmed',
            ETST_Student__c = student.Id
        );
        insert serviceRequest1;
 
        ET_Service_Request__c serviceRequest2 = new ET_Service_Request__c(
            RecordTypeId = schoolCoordinatorReadOnlyRtId,
            ETST_Status__c = System.Label.ETST_Location_Update,
            ETST_Student__c = student.Id
        );
        insert serviceRequest2;
 
        ET_Service_Request__c serviceRequest3 = new ET_Service_Request__c(
            RecordTypeId = schoolServiceRequestRtId,
            ETST_Status__c = 'Service Confirmed',
            ETST_Student__c = student.Id
        );
        insert serviceRequest3;
        
        ETSTController.createNewStudent(school.Id,student);
        Test.stopTest();
    }
 
    @IsTest
    public static void testGetTransportRequests() {
        Test.startTest();
        // Call the method with a specific page number
        Integer pageNumber = 1;
        ETSTController.TransportRequests result = ETSTController.getTransportRequests(pageNumber);
        
        Test.stopTest();
    }
    
  /*  @isTest
    static void testAttachmentInsert() {
        Id schoolCoordinatorReadOnlyRtId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Coordinator_Read_Only').getRecordTypeId();
        ET_Service_Request__c serviceRequest1 = new ET_Service_Request__c(
            RecordTypeId = schoolCoordinatorReadOnlyRtId,
            ETST_Status__c = 'Service Confirmed'
        );
        insert serviceRequest1;

        String fileName = 'TestFile.txt';
        String fileContent = 'This is a test file content.';
        String encodedFileBody = EncodingUtil.base64Encode(Blob.valueOf(fileContent));

        Test.startTest();
        ETSTController.attachmentInsert(fileName, encodedFileBody, serviceRequest1.Id);
        Test.stopTest();

    }
}
    /*@IsTest
    public static void testAttachFile() {
        
        ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Paid_By__c = 'Self',ETST_Pick_Up_Start_Date__c=system.today(),
                                                                 ETST_Pick_Up_End_Date__c=system.today()+60,ETST_Cancellation_End_Date__c=system.today()+20,
                                                                 ETST_Cancellation_Effective_Date__c=system.today()+20,ETST_Service_Type__c='Yearly',ETST_Fare_Charges__c=1000,
                                                                 ETST_Status__c='Under Review',
                                                                 ETST_Pick_Up_From__c='Test - United Arab Emirates',
                                                                 ETST_Prev_Pickup_From__c = 'test',ETST_Drop_Off_To__c ='fcghjkm');
        insert etreq;

        Blob pdfContent = Blob.valueOf('Dummy PDF Content');

        Test.startTest();
        ETSTController.attachFile(etreq.Id, pdfContent);
        Test.stopTest();
    }*/
}