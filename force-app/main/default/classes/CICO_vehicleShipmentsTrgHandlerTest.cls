@isTest
public class CICO_vehicleShipmentsTrgHandlerTest {
    
    private static testmethod void testMethod1(){
        CICO_Intimation__c inti = new CICO_Intimation__c();
        inti.Name = '123242';
        inti.Intimation_Date__c = system.today();
        inti.Intimation_No__c='223323';
        inti.PO_Header_ID__c=1234;
        inti.Vendor_ID__c=4233;
        insert inti;
        
        CICO_Intimation_Line__c line = new CICO_Intimation_Line__c();
        line.Name ='1';
        line.Intimation_ID__c = inti.Id;
        line.PO_Line_ID__c = 12332;
        insert line;
        
        CICO_Vehicle_Spec__c veh = new CICO_Vehicle_Spec__c();
        veh.Name ='BNBNBN343DD23';
        veh.Intimation_Line__c= line.Id;
        veh.Sup_Doc_Date__c = system.today();
        veh.Actual_Receive_Date__c= system.today();
        veh.Sup_Doc_No__c ='1234';
        veh.Sup_Doc_Type__c ='Delivery Note';
        veh.Penalty__c = 'Yes';
        veh.Shipped_Date__c = system.today();
        veh.Inspection_Status__c = 'Approved';
        insert veh;
        
        veh.Penalty__c = 'No';
        
        update veh;
       
        
    }

}