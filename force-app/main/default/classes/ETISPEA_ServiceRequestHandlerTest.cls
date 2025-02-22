@isTest
public class ETISPEA_ServiceRequestHandlerTest {
    // Test Data Setup
    @testsetup static void setup(){
        // account
         Id AccRecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        Account acc = new Account(FirstName = 'Test',LastName = 'Account',PersonEmail = 'test@gmail.com',Preferred_Language__c='English',
                                 RecordTypeId = AccRecordTypeId,ETSALES_Email__c = 'testAcc@gmail.com',PersonMobilePhone='+971555555555');
        insert acc;
        
        // Customer Vehicle
        ET_Customer_Vehicle__c cv = new ET_Customer_Vehicle__c();
        cv.Chassis_No__c = 'JN6BE6CS4G9401628';
        insert cv;
        
        // Service Request
        Id ServRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        ET_Service_Request__c req = new ET_Service_Request__c(Payment_Status__c = 'Not Initiated',RecordTypeId = ServRecordTypeId,ET_Account__c = acc.id);
        
        insert req;
        
        ET_Location__c objLocation = new ET_Location__c(Name = 'Sharjah Spea Inspection Centre',Status__c='Active');
        insert objLocation;
        
        // Booking
        ETI_Booking__c bkng = new ETI_Booking__c();
        
        bkng.Service_Type__c = 'SPEA Inspection';
        bkng.Customer_Vehicle__c = cv.id;
        bkng.Booking_Status__c = 'Booked';
        bkng.Service_Request__c = req.id;
        bkng.ET_Location__c = objLocation.id;
        insert bkng;
        
        // Booking Line Item
        ETI_Service_Line_Item__c item = new ETI_Service_Line_Item__c();
        item.Booking__c = bkng.id;
        item.Test_Result__c = 'Pass';
        insert item;
        
        // Receipt
        ETI_Inspection_Receipt__c recpt = new   ETI_Inspection_Receipt__c();
        
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
        wo.Status = '';
        wo.Booking__c = bkng.id;
        //insert wo;
        
        // create workType 
        WorkType wType = new WorkType();
        wType.Name = 'Inspection';
        wType.EstimatedDuration = 40;
        wType.DurationType ='Minutes';
        insert wType;
        
        
    }
    
    
    @isTest static void testMethod1() {
        ET_Service_Request__c req = [select id, Payment_Status__c from ET_Service_Request__c where Payment_Status__c='Not Initiated'];
        req.Payment_Status__c = 'Payment Success';
        update req;
        try {
            contact con = new contact( email='test@g.com');
            insert con;
        } catch(Exception e) {
            ETISPEA_ServiceRequestHandler.logException(e, 'test');
        }
    
    }
    
}