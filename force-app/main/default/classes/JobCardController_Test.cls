@isTest
public class JobCardController_Test {
    @isTest
    static void CreateJobCard(){
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User recp = new User(Alias = 'standt', Email='stanRecp@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = p.Id, 
                             TimeZoneSidKey='America/Los_Angeles', UserName='standaRecpser@testorg.com');
        
        List<Account> accountsList = ETT_TestFactory.createAccounts('Test92J35464', 'Organization');
        insert accountsList;
        
        ETT_Collection_Card__c objCC2 = new ETT_Collection_Card__c();
        objCC2.ETT_Accounts__c = accountsList[0].Id;
        objCC2.HasTyresWithoutPrice__c = false;
        insert objCC2;
        
        ETT_Tyre_Size_Master__c tsm = new ETT_Tyre_Size_Master__c();
        tsm.Name ='Size167';
        insert tsm;
        
        ETT_Pattern_Master__c pat = new ETT_Pattern_Master__c();
        pat.Name ='Pat21';
        insert pat;
        
        ETT_Country_Master__c coun = new ETT_Country_Master__c();
        coun.Name ='Coun1';
        insert coun;
        
        ETT_Brand_Master__c bra = new ETT_Brand_Master__c();
        bra.Name ='Bran1';
        insert bra;
        
        ETT_Price_Master__c pm = new ETT_Price_Master__c();
        pm.ETT_Party_Name__c = accountsList[0].Id;
        insert pm;
        
        List<ETT_Pricing_Information__c> epiList = new List<ETT_Pricing_Information__c>();
        ETT_Pricing_Information__c epi = new ETT_Pricing_Information__c();
        epi.ETT_Price__c=pm.Id;
        epi.ETT_Approval_Status__c ='Approved';
        epi.ETT_Brand__c=bra.id;
        epi.ETT_Pattern__c=pat.id;
        epi.ETT_Tyre_Size__c=tsm.id;
        epi.ETT_Country_of_Origin__c=coun.id;
        epi.ETT_Purchase_Price__c = 0;
        epi.Collection_Card__c=objCC2.Id;
        epi.ETT_Buying_Price_Comments__c ='Updated by HOO';
        
        
        insert epi;
        
        ETT_Tyre_Size_Master__c tsm2 = new ETT_Tyre_Size_Master__c();
        tsm2.Name ='Size1456';
        insert tsm2;
        
        ETT_Pattern_Master__c pat2 = new ETT_Pattern_Master__c();
        pat2.Name ='Pat2178';
        insert pat2;
        
        epi.ETT_Brand__c = bra.id;
        epi.ETT_Pattern__c = pat2.id;
        epi.ETT_Tyre_Size__c = tsm2.id;
        epi.ETT_Country_of_Origin__c=coun.id;
        epi.ETT_Purchase_Price__c = 0;
        epi.Collection_Card__c=objCC2.Id;
        epi.ETT_Buying_Price_Comments__c ='Updated by HOO';
        //epi.ETT_Price__c = pm.Id;
        epiList.add(epi);
        update epiList[0];
        
        ETT_StagingNewTyreCollection__c stg2 = new ETT_StagingNewTyreCollection__c();
        stg2.Brand__c = bra.id;
        stg2.Collection_Card__c = objCC2.Id;
        stg2.Country__c = coun.id;
        stg2.Pattern__c = pat2.id;
        stg2.Tyre_Size__c = tsm2.id;
        stg2.Job_Type__c = 'Retread';
        stg2.Process_Type__c = 'Precure';
        stg2.Tyre_Life__c = '1';
        stg2.Tyre_Serial_No__c = '123456';
        insert stg2;
        
        ETT_Tyre_Inventory__c tin2 = new ETT_Tyre_Inventory__c();
        tin2.ETT_Account__c = accountsList[0].Id;
        tin2.ETT_Collection_Card__c = stg2.Collection_Card__c;
        tin2.Serial_Number__c = '24325445445';
        tin2.ETT_Inventory_Status__c ='Approved by Receptionist';
        tin2.ETT_Brand__c = stg2.Brand__c;
        tin2.ETT_Country__c = stg2.Country__c;
        tin2.ETT_Pattern__c = stg2.Pattern__c;
        tin2.ETT_Tyre_Size_Master__c = stg2.Tyre_Size__c;
        tin2.Process_Type__c = stg2.Process_Type__c;
        tin2.ETT_Tyre_Life__c = stg2.Tyre_Life__c;
        tin2.Serial_Number__c = stg2.Tyre_Serial_No__c;
        tin2.Job_Type__c = stg2.Job_Type__c;
        tin2.Stockable__c = true;
        tin2.Tyre_Type__c = 'Used';
        
        insert tin2;
        
        ETT_Job_Card__c jobcard = new ETT_Job_Card__c();
        //jobcard.Customer__c=acc.Id;
        jobcard.Tyre_Inventory__c=tin2.Id;
        insert jobcard;
        
        PageReference pageRef = Page.job_card;
        pageRef.getParameters().put('Id', jobcard.Id);
        System.Test.setCurrentPage(pageRef);
      	ApexPages.StandardController sc = new ApexPages.StandardController(jobcard);
		JobCardController  obj = new JobCardController(sc);
        
        
    }

}