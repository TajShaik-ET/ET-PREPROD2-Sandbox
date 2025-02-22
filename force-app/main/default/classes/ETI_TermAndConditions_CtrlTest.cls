@isTest
public class ETI_TermAndConditions_CtrlTest {
    private static testmethod void testmethodInspection(){
        ETI_TermAndConditions_Ctrl et = new ETI_TermAndConditions_Ctrl();
        et.getETI_Terms_and_Conditions();
        ET_Terms_and_Conditions__c term=new ET_Terms_and_Conditions__c();
        term.ET_Condition__c='test';
        term.ET_Service_Name__c='Vehicle Inspection';
        term.Place_of_Visisbility__c ='Vehicle Registration';
        insert term;
        ETI_TermAndConditions_Ctrl.getTermsandConditions('Vehicle Registration');
    }
}