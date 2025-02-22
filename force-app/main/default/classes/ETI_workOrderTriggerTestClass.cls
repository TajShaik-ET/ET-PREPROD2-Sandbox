/********************************************************************************************************
* @author       Smaartt
* @description  Test Class for 'ETI_workOrderTriggerHandler'
*********************************************************************************************************/
@isTest
public class ETI_workOrderTriggerTestClass {
    
    // Test Data Setup
    @testsetup static void setup(){
        
        // Customer Vehicle
        ET_Customer_Vehicle__c cv = new ET_Customer_Vehicle__c();
        cv.Chassis_No__c = 'JN6BE6CS4G9401628';
        insert cv;
        
        // Service Request
        ET_Service_Request__c req = new ET_Service_Request__c();
        insert req;
        
        // Booking
        ETI_Booking__c bkng = new ETI_Booking__c();
        
        bkng.Service_Type__c = 'SPEA Inspection';
        bkng.Customer_Vehicle__c = cv.id;
        bkng.Booking_Status__c = 'Booked';
        bkng.Service_Request__c = req.id;
        insert bkng;
        
        // Booking Line Item
        ETI_Service_Line_Item__c item = new ETI_Service_Line_Item__c();
        item.Booking__c = bkng.id;
        item.Test_Result__c = 'Pass';
        insert item;
        
        // Receipt
        ETI_Inspection_Receipt__c recpt = new 	ETI_Inspection_Receipt__c();
        
        recpt.AMAN_Receipt_No__c = '1234';
        recpt.Service_Request__c  = req.id;
        recpt.Service_Line_Item__c =item.id;
        recpt.Bookings__c = bkng.id;
        recpt.ETI_Amount__c = 123;
        insert recpt;
        
        // Create work Orders
        workOrder wo = new workOrder();
        Id recordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Inspection_Work_Order').getRecordTypeId();
        wo.StartDate = Datetime.Now(); 
        wo.Subject = 'Inspection';
        wo.ETI_Schedule_Appointment__c = true;  
        wo.Street  = 'Alfahidhi';
        wo.City = 'Dubai';
        wo.PostalCode = '531116';
        wo.Country ='United Arab Emirates';
        wo.Inspection_Status__c = 'Pass';
        wo.Booking__c = bkng.id;
        insert wo;
        
    }
    
    
    // update work order from Pass to Fail
    @isTest static void testMethod1() {
        
        workOrder wo = [select id, Inspection_Status__c from workOrder where Subject = 'Inspection' ];
        wo.Inspection_Status__c = 'Fail';
        update wo;
        
    }
    
    @isTest static void testMethod2(){
        ETI_workOrderTriggerHandler.utility();
    }
}