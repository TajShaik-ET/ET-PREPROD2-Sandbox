public class ETI_BookingInvoiceController{

public ETI_Booking__c booking{get;set;}
public List<ETI_Booking__c> bookingList {get;set;}

public ETI_BookingInvoiceController(){
    Id bkngId=ETI_VehicleController.getDecryptedData(ApexPages.currentPage().getParameters().get('Id').replace(' ','+'));
    if(bkngId!=NULL){
        list<ETI_Booking__c> bkngList=[SELECT Id,Service_Request__c,Service_Request__r.Name, Service_Type__c,Test_Result__c,Customer_Vehicle__r.name,Customer_Vehicle__r.Chassis_No__c,
                                       Customer_Vehicle__r.Plate_No__c,Booking_Date__c,Total_Amount__c,Payment_Status__c,User__r.Name FROM ETI_Booking__c WHERE Id=: bkngId limit 1];
        if(bkngList!=NULL && bkngList.size()>0)
            booking=bkngList[0];
    }
    
    
}
  
}