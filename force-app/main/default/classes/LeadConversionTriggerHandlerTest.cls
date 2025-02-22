@isTest
public class LeadConversionTriggerHandlerTest {

    @isTest
    public static void testCase1(){
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        myLead.leadsource = 'Instagram';
        insert myLead;
        ETM_Vehicle_Test_Drive__c testDrive = new ETM_Vehicle_Test_Drive__c();
        testDrive.ETM_Lead__c = myLead.Id;
        insert testDrive;
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(myLead.id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Test.startTest();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        Test.stopTest();
        
        Lead objLead = new Lead( FirstName = 'Test', LastName = 'Sample', Company = 'Testing Sample Co',leadsource = 'Instagram' );  
        objLead.Appointment_Date__c  = System.now();
        insert objLead;  
        objLead.Appointment_Date__c  = System.now().adddays(1);
        update objLead;
        Database.LeadConvert lc1 = new database.LeadConvert();
        
        lc1.setLeadId( objLead.Id );  
        lc1.setDoNotCreateOpportunity( false );  
        lc1.setConvertedStatus('Qualified');  
          
        Database.LeadConvertResult lcr1 = Database.convertLead(lc1, false);  
          
        system.debug( 'Errors are ' + lcr1.getErrors() );  
          
        system.assert( lcr1.isSuccess() );  
        //System.assert(lcr.isSuccess());
        //LeadConversionTriggerHandler 
    }
}