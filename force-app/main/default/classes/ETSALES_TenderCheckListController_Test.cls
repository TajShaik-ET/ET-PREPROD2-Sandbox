@isTest
public class ETSALES_TenderCheckListController_Test {

    
    public static testMethod void setupdata(){
        Id accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
    	//Id oppRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Leasing').getRecordTypeId();
        
        
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User testUser  = new User(FirstName = 'fName', LastName = 'lName',email = 'test@123.com',
                                  ProfileId =userProfile.Id,ETSALES_Employee_Zone__c = 'Zone A',
                                  ETSALES_Location__c='Dubai',Username = 'fname@test.com',Alias = 'fname',TimeZoneSidKey='GMT',LocaleSidKey='en_IE_EURO',
                                 EmailEncodingKey ='ISO-8859-1',LanguageLocaleKey ='en_US');   
        insert testUser;
        
        Account testAccount = new Account(Name= 'testAccount',RecordTypeId=accRecordType,
                                            ETSALES_Emirates_Passport__c='784-1272-8373838-3',Phone='971581484471',
                                            ETSALES_Customer_Type__c='Person');
        insert testAccount;
        
        ETSALES_Tender__c testTender = new ETSALES_Tender__c(Name = 'Test Tender');
        insert testTender;
        
        ETSALES_Location__c testLocation = new ETSALES_Location__c (Name = 'testLocation', ETSALES_Region__c = 'Central',
                                                                    ETSALES_Emirates__c = 'Dubai', ETSALES_Zone__c = 'Zone A');
        insert testLocation;
        
        Opportunity testOpportunity = new Opportunity (Name = 'test Opportunity', AccountId =testAccount.Id,ETSALES_Tender__c = testTender.Id,
                                                       StageName='Qualification', CloseDate= System.Today());
        insert testOpportunity;
        
        ETSALES_checklist__c testCheckList = new ETSALES_checklist__c(Name = 'test Check',ETSALES_Active__c = TRUE);

        insert testCheckList;
        
        ETSALES_TenderCheckListController.handleCheckList(testTender.Id);
        
        ETSALES_Check_List_Lines__c testCheckListLine  = new ETSALES_Check_List_Lines__c(ETSALES_Checklist__c = testCheckList.Id,
                                                                                        ETSALES_Status__c = 'Requested',
                                                                                        ETSALES_Assign_To__c = testUser.Id,
                                                                                        ETSALES_Tender__c = testTender.Id,
                                                                                        ETSALES_Required__c = TRUE,
                                                                                        ETSALES_AddChecklist__c = TRUE);
        insert testCheckListLine;
        List<ETSALES_Check_List_Lines__c> newListLine = [SELECT Id,ETSALES_Checklist__c,ETSALES_Status__c,ETSALES_Assign_To__c,
                                                         ETSALES_Tender__c,ETSALES_Required__c,ETSALES_AddChecklist__c 
                                                         FROM ETSALES_Check_List_Lines__c WHERE Id =: testCheckListLine.Id];
        String tenderId  = testTender.Id;
        if(!newListLine.isEmpty()){
           ETSALES_TenderCheckListController.saveCheckList(newListLine,tenderId); 
        }   
    }
}