@isTest
public class ET_FinanceController_Test{


    public static testmethod void finaceControllerTestData(){
		        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User u=[select id from user where profileId=:profile1.Id and isactive=true LIMIT 1];
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId(); 
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com',etst_coordinator__c=userinfo.getUserId());
        System.runAs(u){
           insert acc; 
        }
        User portalUser=[select id from user where contactId=:acc.PersonContactId  and isactive=true LIMIT 1];
        
        id profileId = [Select Id from Profile where Name='School Coordinator(Platform)' limit 1].Id;
        user coordinator = [Select Id,Name,GL_Location_Code__c,GL_Activity_Code__c from User where Profileid=:profileId  and isactive=true limit 1];
        if(coordinator!=null){
            coordinator.GL_Location_Code__c = '212002';
        	coordinator.GL_Activity_Code__c = '113001';
        	update coordinator;
        }
        
        
        ETSALES_Location__c sales=new ETSALES_Location__c(GL_Zone__c='Zone A',Name='Musafah 1',Location_Code__c='212002');
        
        insert sales;
        
        GL_Activity__c act=new GL_Activity__c(Name='Private School Transportation Center',GL_Activity_Code__c='113001');
        
        insert act;
        
        
        Account acc1 = new Account(RecordTypeId=schoolRecordTypeId,Name='Test',etst_coordinator__c=coordinator.Id);
        insert acc1;
        
        ET_Sales_Agreement__c agr = new ET_Sales_Agreement__c(Salesforce_Customer__c=acc1.Id);
        insert agr;
        
        ETST_School__c schl = new ETST_School__c(Name='Test', Customer__c = acc1.Id,ETST_Sales_Agreement__c=agr.Id,ETST_Account_Type__c='University');
        insert schl;
   
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_School_Name__c=schl.Id,
                                                    ETST_Account_Name__c=acc.Id,ETST_School__c=acc1.Id);
        insert stdnt;

        ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Paid_By__c = 'Self',ETST_Pick_Up_Start_Date__c=system.today(),
                                                                 ET_Sales_Agreement__c=agr.Id,ETST_Pick_Up_End_Date__c=system.today()+60,ETST_Cancellation_End_Date__c=system.today()+20,
                                                                 ETST_Cancellation_Effective_Date__c=system.today()+20,ETST_Service_Type__c='Yearly',ETST_Fare_Charges__c=1000,
                                                                 ET_Account__c=acc.Id,ETST_Status__c = 'Payment Success-Confirmation in progress',
                                                                 ETST_User__c=portalUser.Id);
        insert etreq;
        
        ET_Service_Request__c  etreq1 = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Paid_By__c = 'Self',ETST_Pick_Up_Start_Date__c=system.today(),
                                                                 ET_Sales_Agreement__c=agr.Id,ETST_Pick_Up_End_Date__c=system.today()+60,ETST_Cancellation_End_Date__c=system.today()+20,
                                                                 ETST_Cancellation_Effective_Date__c=system.today()+20,ETST_Service_Type__c='Yearly',ETST_Fare_Charges__c=1000,
                                                                 ET_Account__c=acc.Id,ETST_Status__c = 'Payment success',
                                                                 ETST_User__c=portalUser.Id);
        insert etreq1;
       
      /*  Invoice__c inv = new Invoice__c(ETST_Active__c=true,Service_Request__c=etreq.Id);
        insert inv;
        */
      /*  ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_Account_Name__c=acc.Id);
        insert stdnt;
        
        ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Paid_By__c = 'Self');
        insert etreq; */
        ET_Finance_Document__c doc = new ET_Finance_Document__c(ET_Activity__c='Test Activity',ET_Batch_Source__c='123',ET_Bill_To_Customer__c='1000',ET_From_Period__c=system.today(),
                                                               ET_Location__c='Test',ET_Payment_Mode__c='Cash',ET_Status__c='Prepared',ET_To_Period__c=system.today()+30,ET_Transaction_Type__c='Test',ET_Zone__c='Zone A');
        insert doc;
        doc.ET_Batch_Source__c = '321';
       // doc.Integration_Message__c = 'Success';
        update doc;
        
        ETST_InvoiceController invctrl = new ETST_InvoiceController();
        
        Invoice__c inv = new Invoice__c(ETST_Active__c=true,Service_Request__c=etreq.Id);
        inv.ETST_Coordinator__c = coordinator.id;
        inv.Location__c = 'Hyderabad';
        inv.ETST_Type__c = 'Online';
        inv.Service_Request__c = etreq.Id;
        insert inv;
        
        ET_Receipt__c rec=new ET_Receipt__c();
        rec.ET_Coordinator__c = coordinator.id;
        rec.Payment_Mode__c = 'Online';
        rec.ET_Service_Request__c = etreq.Id;
        insert rec;
        
        ET_Location__c objLocation = new ET_Location__c();
        objLocation.Name  = 'Test Location';
        objLocation.Available_Services__c = 'Police Inspection';
        objLocation.ETSALES_Emirates__c = 'Dubai';
        objLocation.Latitude__c = '123';
        objLocation.Location_Code__c = '123456';
        objLocation.Longitude__c = '134';
        objLocation.ETSALES_Zone__c = 'Dubai';
        insert objLocation;
        
        ET_FinanceController.InvoiceWrapper invWrap=new ET_FinanceController.InvoiceWrapper();
        
        invWrap.coordinator=coordinator.Name;
        invWrap.totalAmount='200';
        invWrap.invCount='2';
        invWrap.coordinator=coordinator.Id;
        invWrap.customerOracleId='111222';
		invWrap.accountNumber='12345';  
        //invWrap.SchoolName='School';
        
        List<ET_FinanceController.InvoiceWrapper> invWrapList=new List<ET_FinanceController.InvoiceWrapper> ();
        invWrapList.add(invWrap);
        List<ET_FinanceController.wrapper> wrapList=new List<ET_FinanceController.wrapper>();
        ET_FinanceController.wrapper wrap = new ET_FinanceController.wrapper();
        wrap.key = '12345';
        wrap.value = invWrapList;
        wrapList.add(wrap);
        datetime startdate=system.today();
        datetime enddate=system.today();
        ET_FinanceController.getZoneList();
        ET_FinanceController.getZoneLocations('Zone A');
        ET_FinanceController.getReceiptDetails(coordinator.name,'','School'); // Removed type parameter-- Sreelakshmi SK- 25/4/23
        ET_FinanceController.getAllInvDetails('112233', '112233','Cheque',startdate,enddate);
        ET_FinanceController.getInvoiceByLoc('Zone A','Musafah 1','Private School Transportation Center','Online',Datetime.now(),Datetime.now());
        ET_FinanceController.submitForApproval(doc);
        
        ET_FinanceController.saveFinanceDocument('Zone A', 'Musafah 1', 'Private School Transportation Center','Private School Transportation Center',JSON.serialize(wrapList),Datetime.now(),Datetime.now());
    }
}