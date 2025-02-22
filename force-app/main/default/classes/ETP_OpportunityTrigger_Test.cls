@isTest(seeAllData = false)
public class ETP_OpportunityTrigger_Test {
    
    @TestSetup static void testDataSetup(){
        Account acc = new Account();
        acc.Name = 'Test5678990';
        insert acc;
        
        contact con = new contact();
        con.lastname = 'Mani';
        con.Email = 'manikanta.sinisetti@gmail.com';
        insert con;
        
        // zone
        GL_Zone__c zone = new GL_Zone__c();
        zone.name = 'Zone A';
        insert zone;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test5678bbj';
        opp1.StageName = 'Qualification';
        opp1.CloseDate = System.today()+8;
        opp1.ETSALES_GNG_Approval_Status_Date__c = System.today()+8;
        opp1.ETSALES_Approval_Status__c = 'Rejected';
        opp1.ETSALES_GL_Services__c = 'Vehicle';
        opp1.GL_Zone_Lookup__c = zone.Id;
        opp1.isPricingCreated__c = true;
        insert opp1;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test5678yhnbb';
        opp2.StageName = 'Qualification';
        opp2.CloseDate = System.today()+8;
        opp2.ETSALES_GNG_Approval_Status_Date__c = System.today()+8;
        opp2.ETSALES_Approval_Status__c = 'Rejected';
        opp2.ETSALES_GL_Services__c = 'Vehicle';
        insert opp2;
    }
    
    @isTest static void testNotifyEmailToPricingTeam() {
		opportunity opp = [select id from opportunity where name = 'Test5678bbj'];
        opp.ETSALES_Approval_Status__c = 'Approved';
        update opp;
      //  ETP_OpportunityTrigger_Handler.updateHeadOfSales(oppList);
    }
    
    @isTest
    public static void testCoverageMethod(){
        ETP_OpportunityTrigger_Handler.testCoverage();
    }
    
    
}