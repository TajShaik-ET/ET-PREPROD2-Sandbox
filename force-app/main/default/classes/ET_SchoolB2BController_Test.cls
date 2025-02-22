@istest
public class ET_SchoolB2BController_Test {
    @testSetup static void setup() {
        //UserRole portalRole = [Select Id From UserRole Where Name= 'General Manager' Limit 1]; 
        //User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' and isactive=true 
        //                 and UserRoleId=:portalRole Limit 1];
        //
        //adminUser.UserRoleId = userRole.Id;
        //update adminUser;
        Account acc = new Account();
        Account acc1 = new Account();
        Account acc2 = new Account();
        //system.runas(adminUser){
        
        acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc.Name = 'MINISTRY OF EDUCATION';
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
        // }
        System.Test.startTest();
        ETST_Student__c student=new ETST_Student__c();
        student.Name='student';
        student.ETST_School__c=acc1.Id;
        student.ETST_Emirates_Id__c='784-4444-4422331-1';
        student.ETST_Date_of_Birth__c=date.today();
        student.ETST_First_Name__c='test';
        insert student;
        
        SALine_Assigned_Vehicle__c vehicle=new SALine_Assigned_Vehicle__c();
        vehicle.Name='vehcle 1';
        vehicle.Account__c=acc1.Id;
        insert vehicle;
        
        SALine_Assigned_Resource__c resource=new SALine_Assigned_Resource__c();
        resource.Name='vehcle 1';
        resource.Account__c=acc1.Id;
        insert resource;
        
        ET_Sales_Agreement__c  sa=new ET_Sales_Agreement__c();
        sa.Name='vehcle 1';
        sa.Salesforce_Customer__c=acc1.Id;
        insert sa;
        
        Invoice__c inv=new Invoice__c();
        inv.Sales_Agreement__c=sa.Id;
        
        insert inv;
        
        System.Test.stopTest();
    }
    @isTest static void testMethod1() {
        user u=[select id from user where username = 'test1@uichangeset.com' ];
        System.Test.startTest();
        system.runas(u){
            ET_SchoolB2BController.getBusinessType();
            ET_SchoolB2BController.getDashboardData();
            ET_SchoolB2BController.getStudentList();
            ET_SchoolB2BController.getvehicleList();
            ET_SchoolB2BController.getResourceList();
            ET_SchoolB2BController.getSAList();
            ET_SchoolB2BController.getSchoolList();
            ET_SchoolB2BController.getInvoiceListHelper();
        }
        System.Test.stopTest();
    }
    @isTest static void testMethod2() {
        user u=[select id from user where username = 'test2@uichangeset.com' ];
        System.Test.startTest();
        system.runas(u){
            ET_SchoolB2BController.getDashboardData();
            ET_SchoolB2BController.getStudentList();
            ET_SchoolB2BController.getvehicleList();
            ET_SchoolB2BController.getResourceList();
            ET_SchoolB2BController.getSAList();
            ET_SchoolB2BController.getInvoiceListHelper();
            ET_SchoolB2BController.MyBusinessWrapper bzWrap = new ET_SchoolB2BController.MyBusinessWrapper();
        }
        System.Test.stopTest();
    }
}