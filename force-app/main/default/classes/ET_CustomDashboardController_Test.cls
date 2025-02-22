@isTest
public class ET_CustomDashboardController_Test {
    @isTest Public static void customDashboardTest(){
        Account acc = new Account();
        acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc.Name = 'MINISTRY OF EDUCATION1';
        acc.phone= '01123353';
        acc.billingcity='London';
        acc.billingpostalcode='SW1635HJ';
        acc.billingcountry='United Kingdom';
        acc.billingstreet='address 1';
        insert acc;
        
        Contact c = new Contact(LastName = 'Contact Last Name', AccountId = acc.id);
        insert c; 
        
        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='Partner Community login User'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test12@uniquedomain.com';
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.IsActive = true;
        user.ContactId = c.Id;
        insert user; 
        
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Customer_PO_No__c = 'Test';
        etSales.Salesforce_Customer__c = acc.id;
        etSales.Category__c = 'Transportation';
        insert etSales;
        
        ETST_Student__c estud = new ETST_Student__c(ETST_Email__c='abc@xyz.com',ETST_Emirate__c='Dubai',Name='test Student',
                                                    ETST_Nationality__c='India',ETST_Emirates_Id__c='784-2131-3212131-2',
                                                    ETST_ESIS_No__c='2302',ETST_Division__c='5',ETST_Gender__c='Male',ETST_School__c = acc.Id,
                                                    ETST_Student_Id__c='1223',ETST_Date_of_Birth__c=system.today()-1200);
        insert estud;
        
        SALine_Assigned_Vehicle__c vehicle=new SALine_Assigned_Vehicle__c();
        vehicle.Name='vehcle 1';
        vehicle.Account__c = acc.Id;
        vehicle.Sales_Agreement__c = etSales.Id;
        vehicle.Assign_End_Date__c =system.today();
        insert vehicle;
        
        Case cas = new Case(contactId = c.Id);
        insert cas;
        
        ET_User_Files__c newFile = new ET_User_Files__c();
        newFile.File_Name__c ='test file';
        newFile.Doc_Id__c ='123';
        insert newFile;
        
        system.runAs(user){
            Test.startTest();
            ET_CustomDashboardController.getDashboardData();
            ET_CustomDashboardController.getSpecialRequestDashboardData();
            Test.stopTest();
        }
    }
}