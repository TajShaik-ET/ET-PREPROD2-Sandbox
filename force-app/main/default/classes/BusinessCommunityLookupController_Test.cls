@isTest
public class BusinessCommunityLookupController_Test{

@isTest public static void  insertnewdata(){

Account accoun = new Account();
    accoun.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
    accoun.Name = 'test corp';
    accoun.phone= '01123123';
    accoun.billingcity='London';
    accoun.billingpostalcode='SW1635HJ';
    accoun.billingcountry='United Kingdom';
    accoun.billingstreet='address 1';
    insert accoun;
    

  /*  Contact c = new Contact();
    c.AccountId = accoun.ID;
    c.FirstName = 'test';
    c.LastName = 'test';
    c.email = 'test@test.com';
    c.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
    c.birthdate = Date.newInstance(1992, 04, 12);
    insert c;

    Profile prof = [select id from profile where name ='Partner Community login User'];
    User user = new User();
    user.firstName = 'test1';
    user.lastName = 'test2';
    user.contactid=c.id;
    user.profileId = prof.id;
    user.username = 'test1@uichangeset.com';
    user.email = 'test@test.com';
    user.Alias='test';
    user.TimeZoneSidKey='Asia/Dubai';
    user.LocaleSidKey='en_IE_EURO';
    user.EmailEncodingKey='ISO-8859-1';
    user.LanguageLocaleKey='en_US';
    insert user;
    ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
    etSales.Salesforce_Customer__c = accoun.id;
    //etSales.Contract_No__c='123223';
    insert etSales;
    SALine_Assigned_Vehicle__c etVehic = new SALine_Assigned_Vehicle__c();
    etVehic.Vehicle_Number__c='123223';
    etVehic.Vehicle_Description__c='Test Vehicle';
    etVehic.Sales_Agreement__c=etSales.id;
    etVehic.Name='Test';
    insert etVehic;
    SALine_Assigned_Resource__c etReso = new SALine_Assigned_Resource__c();
    etReso.Employee_ID__c='123223';
    etReso.Name='Test resource';
    etReso.Sales_Agreement__c=etSales.id;
    etReso.ETST_Assigned_Vehicle__c=etVehic.id;
    insert etReso;
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
    Account acc2 = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test');
    insert acc2;
    ETST_School__c schl = new ETST_School__c(Name='Test', Customer__c = accoun.Id);
    insert schl;
    ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_Account_Name__c=acc2.Id);
    insert stdnt;      
    ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Paid_By__c = 'Self');
    insert etreq;  
    Invoice__c inv = new Invoice__c(ETST_Active__c=true,ETST_Type__c='Online',Service_Request__c=etreq.Id,Sales_Agreement__c=etSales.id);
    insert inv;
    
    List<case> cslist= new List<Case>();
    for(Integer i=0;i<10;i++){
    Case cs= new Case();
    cs.Accountid=accoun.id;
    cs.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('B2B_Business_Portal_Cases').getRecordTypeId();
    cs.contactid=c.id;
    if(i<3){
    cs.status='New';
    cs.Assigned_Resource__c=etReso.id;
    cs.Case_Types__c='Request for Awareness Session';
    cs.ET_B2B_Complaint_Against__c='Assigned Resource';
    }
    else if(i>2 && i<5){
    cs.status='Submitted for ADEC';
    cs.Assigned_Vehicle__c=etVehic.id;
    cs.ET_B2B_Complaint_Against__c='Assigned Vehicle';
    
    }
    else if(i>4 && i<8){
    cs.status='New';
    cs.Invoice__c=inv.id;
    cs.Case_Types__c='Evaluation of Schools/Services';
    cs.ET_B2B_Complaint_Against__c='Invoices';
    
    }
    else{
    cs.status='Submitted for ADEC';
    cs.Sales_Agreement__c=etSales.id;
    cs.Case_Types__c='Evaluation of Schools/Services';
    cs.ET_B2B_Complaint_Against__c='Sales Agreement';
   
    }
    cslist.add(cs);
    }
    insert cslist;
    */
    List<Account> accrespList= new List<Account>();
   
     Test.startTest();
     accrespList=  BusinessCommunityLookupController.fetchLookUpValues('test corp','Account');
     System.assertnotequals(accrespList.size(),null);
     Test.stopTest();
     
     }
}