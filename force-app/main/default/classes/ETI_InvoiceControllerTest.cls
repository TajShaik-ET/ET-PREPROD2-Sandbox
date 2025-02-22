@isTest
public class ETI_InvoiceControllerTest {
    
    private static testmethod void testmethodInspection(){
        
        /*
integer i=1;
for(ETI_Booking__c bkng: [SELECT Id,Booking_Date_Time__c,ET_Location__r.Name,Service_Request__c, Service_Type__c,Customer_Vehicle__r.name,Customer_Vehicle__r.Chassis_No__c,Booking_Date__c,Total_Amount__c
FROM ETI_Booking__c WHERE Service_Request__c=:  inspRequest.Id ]){

*/
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.Email =Label.ETI_TargetObject_Email;
        con.LastName = 'Noor';
        insert con;
        
        ET_Customer_Vehicle__c customerVehicle = new ET_Customer_Vehicle__c();
        customerVehicle.Account__c = acc.Id;
        customerVehicle.Chassis_No__c = '43235';
        insert customerVehicle;
        
        ET_Location__c locationObj = new ET_Location__c();
        locationObj.Name = 'Abu Dhabi';
        insert locationObj;
        
        ET_Service_Request__c serviceRequest = new ET_Service_Request__c();
        serviceRequest.ET_Account__c = acc.Id;
        insert serviceRequest;
        
        ETI_Booking__c objBooking = new ETI_Booking__c();
        objBooking.ET_Location__c = locationObj.Id;
        objBooking.Service_Request__c = serviceRequest.Id;
        objBooking.Booking_Date__c = Date.valueOf('2020-07-21');
        objBooking.Service_Type__c = 'Police Inspection';
        objBooking.Customer_Vehicle__c = customerVehicle.Id;
        objBooking.Booking_Status__c = 'Booked';
        insert objBooking;
 
        PageReference pageRef = Page.ETI_BookingInvoice;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(serviceRequest);
        ApexPages.currentPage().getParameters().put('Id',objBooking.id);
       
    }
}