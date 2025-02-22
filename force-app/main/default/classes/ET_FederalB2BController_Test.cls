@isTest(seeAllData=true)
private class ET_FederalB2BController_Test {
     
    @isTest Public static void wrapperClassesTest(){
        
        Account acc = new Account();
        Account acc1 = new Account();
        Account acc2 = new Account();
        //system.runas(adminUser){
        
        acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc.Name = 'MINISTRY OF EDUCATION 1';
        acc.phone= '01123123';
        acc.billingcity='London';
        acc.billingpostalcode='SW1635HJ';
        acc.billingcountry='United Kingdom';
        acc.billingstreet='address 1';
        insert acc;
        
        Contact c = new Contact();
        c.AccountId = acc.ID;
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
        
        acc1.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc1.Name = 'test corp1';
        acc1.phone= '01123123';
        acc1.ETST_Account_Type__c='Government School';
        acc1.billingcity='London';
        acc1.billingpostalcode='SW1635HJ';
        acc1.billingcountry='United Kingdom';
        acc1.billingstreet='address 1';
        acc.parentId=acc.Id;
        insert acc1;        
        
        Contact c1 = new Contact();
        c1.AccountId = acc1.ID;
        c1.FirstName = 'testxx';
        c1.LastName = 'testyy';
        c1.email = 'testyy@test.com';
        c1.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
        c1.birthdate = Date.newInstance(1992, 04, 12);
        insert c1;
        
        User user1 = new User();
        user1.firstName = 'test3';
        user1.lastName = 'test4';
        user1.contactid=c1.id;
        user1.profileId = prof.id;
        user1.username = 'test2@uichangeset.com';
        user1.email = 'test@test.com';
        user1.Alias='test';
        user1.TimeZoneSidKey='Asia/Dubai';
        user1.LocaleSidKey='en_IE_EURO';
        user1.EmailEncodingKey='ISO-8859-1';
        user1.LanguageLocaleKey='en_US';
        insert user1;
        
              
        
        ET_Sales_Agreement__c agr = new ET_Sales_Agreement__c(Salesforce_Customer__c=acc1.Id);
        insert agr;
        
       
        
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
            ETST_Cancellation_Mode__c = 'Month',
            ETST_Amount__c=500
        );
        insert price;
        
       
        
        system.runAs(user1) {
            
        ET_FederalB2BController.MyBusinessWrapper busWrap = new ET_FederalB2BController.MyBusinessWrapper();
        ET_FederalB2BController.getDashboardData();
        ET_FederalB2BController.getSAList();
        ET_FederalB2BController.getInvoiceListHelper();
        ET_FederalB2BController.getEstimationsList();
        }
    }
}