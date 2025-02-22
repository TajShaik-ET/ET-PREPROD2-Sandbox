@isTest
public class ETI_InvoiceCtrlTest {
 
    private static testMethod void testmethodInspection(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        System.debug('acc detials'+acc);
        
        ET_Service_Request__c serviceRequest = new ET_Service_Request__c();
        serviceRequest.ET_Account__c = acc.Id;
        insert serviceRequest;
        System.debug('serviceRequest detials'+serviceRequest);

        ET_Location__c locationObj = new ET_Location__c();
        locationObj.Name = 'Abu Dhabi';
        insert locationObj;
        System.debug('locationObj detials'+locationObj);
        
        ET_Customer_Vehicle__c customerVehicle = new ET_Customer_Vehicle__c();
        customerVehicle.Account__c = acc.Id;
        customerVehicle.Chassis_No__c = '43235';
        customerVehicle.Plate_Color__c='red';
        customerVehicle.Plate_No__c='4512';
        insert customerVehicle;
        System.debug('customerVehicle detials'+customerVehicle);
        
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        Invoice__c objectinvoice = new Invoice__c();
        objectinvoice.Total_Inv_Amount__c= 400;
        objectinvoice.Trx_Date__c=Date.valueOf('2020-07-21');
        objectinvoice.Service_Request__c=serviceRequest.Id;
        objectinvoice.ETST_Active__c=true;
        insert objectinvoice;
        invoiceList.add(objectinvoice);
         System.debug('objectinvoice detials size '+invoiceList.size());
        System.debug('objectinvoice detials'+objectinvoice);
        
        List<ETI_Booking__c> bookinglist= new List<ETI_Booking__c>();
        ETI_Booking__c objBooking = new ETI_Booking__c();
        objBooking.ET_Location__c = locationObj.Id;
        objBooking.Service_Request__c = serviceRequest.Id;
        objBooking.Booking_Date__c = Date.valueOf('2020-07-21');
        objBooking.Service_Type__c = 'Police Inspection';
        objBooking.ET_Location__c=locationObj.ETSALES_Emirates__c;
        objBooking.Customer_Vehicle__c = customerVehicle.Id;
        objBooking.Booking_Status__c = 'Booked';
        objBooking.Plate_No__c=customerVehicle.Plate_No__c;
        objBooking.Plate_Color__c=customerVehicle.Plate_Color__c;
        objBooking.Chassis_No__c=customerVehicle.Chassis_No__c;
        insert objBooking;
        bookinglist.add(objBooking);
        System.debug('bookinglist  size '+bookinglist.size());
        
        ETI_Service_Line_Item__c serviceline = new ETI_Service_Line_Item__c();
        serviceline.Booking__c=objBooking.Id;
        insert serviceline;
        
         ETI_InvoiceCtrl invoicectrl= new ETI_InvoiceCtrl();
         PageReference pageRef = Page.ETI_Invoice;
         Test.setCurrentPage(pageRef);
         ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(serviceRequest);
         ApexPages.currentPage().getParameters().put('recordId',objBooking.id);
        
         test.startTest();
         invoicectrl.initValueForETServiceRequest(serviceRequest.Id);
    	 invoicectrl.initValueForETBooking(objBooking.Id);
         test.stopTest();
      
       
        
    }
    
}