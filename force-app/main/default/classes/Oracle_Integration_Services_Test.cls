@isTest
public class Oracle_Integration_Services_Test {

    @isTest
    public static void codecoverage1()
    {
         Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
       // Oracle_Integration_Mock.testcodecoverage();
         Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
  //      Id recordTypeId = 
        Account acc = new Account(Name='Test1');
        acc.RecordTypeId  = RecordTypeId;
       // acc.PersonMobilePhone = '+971504111111';
        insert acc; 
        ETSALES_Address__c addressObj = new ETSALES_Address__c(ETSALES_Address1__c='test1',ETSALES_Account__c=acc.id);
        insert addressObj;
                
        ETSALES_Account_Sites__c siteObj = new ETSALES_Account_Sites__c(ETSALES_Business_Purpose__c='BILL_TO',ETSALES_Address__c=addressObj.id,ETSALES_Account__c=acc.id);
        insert siteObj;                        
        		      
        Oracle_Integration_Services.integrateAccountToOracleButton(acc.id);
        
        Contact con = new Contact(LastName='test1',AccountId=acc.id);
        insert con;
        
        Oracle_Integration_Services.integrateAddressToOracleFromTrigger(new List<ETSALES_Address__c>{addressObj});

   }

      @isTest
    public static void codecoverage3()
    {
         Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
         Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
  //      Id recordTypeId = 
        Account acc = new Account(Name='Test1');
        acc.RecordTypeId  = RecordTypeId;
        acc.ETSALES_Customer_Account_Id__c = '1234';
        insert acc; 
      
        ETSALES_Address__c addressObj = new ETSALES_Address__c(ETSALES_Address1__c='test1',ETSALES_Account__c=acc.id);
        addressObj.ETSALES_Location_ID__c = '3411';
        insert addressObj;
                
        ETSALES_Account_Sites__c siteObj = new ETSALES_Account_Sites__c(ETSALES_Business_Purpose__c='BILL_TO',ETSALES_Address__c=addressObj.id,ETSALES_Account__c=acc.id);
        insert siteObj;                        
        		      
     
        Contact con = new Contact(LastName='test1',AccountId=acc.id);
        insert con;        
        
        Oracle_Integration_Services.getAddressDetails(addressObj.id);
        Oracle_Integration_Services.getAccountSiteDetails(siteObj.id);
        Oracle_Integration_Services.getAccountDetails(acc.id);
        Oracle_Integration_Services.getContactDetails(con.id);
        
        acc.Name = 'Name2';
        update acc;
   }
}