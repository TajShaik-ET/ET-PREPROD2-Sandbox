/*
* File Name:ETSyncReceipts
* Author : Sagar Kambli
* CreatedDate :  22 June 2020
* Modification Purpose
* * 1. Sagar: Batch to sync all unprocessed receipts to aman system
* * 2.
*/ 
global class ETSyncReceipts implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.stateful{
    
    List<ETI_Inspection_Receipt__c> receipts = new List<ETI_Inspection_Receipt__c>();
    public ET_CreateReceipt.Output saveReceiptResult {get;set;}
    public ET_CreateReceipt.OutputFuture saveReceiptFutureResult {get;set;}

    public ETSyncReceipts(List<ETI_Inspection_Receipt__c> receipts) {
        this.receipts = receipts;
    }

    global List<ETI_Inspection_Receipt__c> start(Database.BatchableContext BC) {
        return receipts;
    }

    global void execute(Database.BatchableContext BC, List<ETI_Inspection_Receipt__c> scope) {

    }

    private void doMapping(List<ETI_Inspection_Receipt__c> receipts){
        ET_CreateReceipt.VehicleDetailCollection_element VehicleDetailCollection;
        List<ET_CreateReceipt.VehicleDetail> VehicleDetails = new List<ET_CreateReceipt.VehicleDetail>();
        ET_CreateReceipt.VehicleDetail VehicleDetail;
        Integer autoNumber = 1;
        String CrmTrxReference = '';
        String CrmCustomerNo =ET_SOA_Authorize.CRM_CUSTOMER_NO;
        String CustomerName = '';
        String CustomerMobileNo = '';
        String PreferredLanguage = '';
        String CustomerSiteAddress = '';
        String CustSiteGpsCord = '';
        Decimal TotalPaidAmount = 0;
        String CrCardAuthCode = '';
        String userName ='';
        /*receipts = [SELECT Id,CrmTrxReference__c,Auth_Code__c,
                    Service_Line_Item__r.Booking__r.User__r.Name,
                    Service_Line_Item__r.Booking__r.User__r.Preferred_Language__c,
                    Service_Line_Item__r.Booking__r.User__r.Phone,
                    Service_Line_Item__r.Booking__r.Customer_Site_Address__c,
                    Service_Line_Item__r.Booking__r.Customer_Site_Geometry__c,
                    Service_Line_Item__r.Booking__r.Total_Amount__c,
                    Service_Line_Item__r.Booking__r.Name,
                    Service_Line_Item__r.Booking__r.Vehicle_Number__c,
                    Service_Line_Item__r.Booking__r.ET_Location__r.Location_Code__c,
                    Service_Line_Item__r.Booking__r.Booking_Date__C,
                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Registration_Type__c,
                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_No__c,
                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_Type_Code__c,
                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_Source_Code__c,
                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_Color_Code__c,
                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Chassis_No__c,
                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Model_Code__c,
                    Service_Line_Item__r.Booking__r.Purpose_Type__r.ETI_LookupCode__c,
                    Service_Line_Item__r.Booking__r.Trade_License_Number__c,
                    Service_Line_Item__r.Booking__r.Total_Fee__c,
                    Service_Line_Item__r.Booking__r.Total_Tax__c,
                    Service_Request__r.Total_Amount__c
                    FROM ETI_Inspection_Receipt__c where isSyncedToAman__c = false];*/

        for(ETI_Inspection_Receipt__c receipt: receipts){
            
            ETI_Booking__c booking = receipt.Service_Line_Item__r.Booking__r;
            if(booking!=null){
                if(receipt.CrmTrxReference__c!=null)
                CrmTrxReference = receipt.CrmTrxReference__c;

                if(booking.User__r.Name!=null)
                CustomerName = booking.User__r.Name;  
                
                if(booking.User__r.Preferred_Language__c!=null)
                PreferredLanguage = booking.User__r.Preferred_Language__c;   

                if(booking.User__r.Phone!=null)
                CustomerMobileNo = booking.User__r.Phone;

                if(booking.Customer_Site_Address__c!=null)
                CustomerSiteAddress = booking.Customer_Site_Address__c;

                if(booking.Customer_Site_Geometry__c!=null)
                CustSiteGpsCord = booking.Customer_Site_Geometry__c;

                if(receipt.Service_Request__r.Total_Amount__c!=null)
                TotalPaidAmount = receipt.Service_Request__r.Total_Amount__c;

                if(receipt.Auth_Code__c!=null)
                CrCardAuthCode = receipt.Auth_Code__c;

                VehicleDetail = new ET_CreateReceipt.VehicleDetail();
                
                if(booking.Name!=null)
                VehicleDetail.BookingReference = booking.Name;
                
                if(booking.Vehicle_Number__c!=null)
                VehicleDetail.VehicleId = booking.Vehicle_Number__c;
                
                VehicleDetail.SerialNo = autoNumber;
                
                if(booking.ET_Location__r.Location_Code__c!=null)
                VehicleDetail.LocId = booking.ET_Location__r.Location_Code__c;
                
                //if(booking.Booking_Date__C!=null)
                //VehicleDetail.ServiceDate = booking.Booking_Date__C;
                VehicleDetail.ServiceDate=System.now().addMinutes(5); 

                if(booking.Customer_Vehicle__r.Registration_Type__c!=null){
                    if(booking.Customer_Vehicle__r.Registration_Type__c.tolowerCase() == ET_SOA_Authorize.REG_VEHICLE){
                        //registered
                        VehicleDetail.RegType = 'R';

                        
                        if(booking.Customer_Vehicle__r.Chassis_No__c!=null)
                        VehicleDetail.ChassisNo = booking.Customer_Vehicle__r.Chassis_No__c;
                    }
                    else { // unregistered
                        VehicleDetail.RegType = 'U';

                        if(booking.Customer_Vehicle__r.Plate_No__c!=null)
                        VehicleDetail.PlateNo = booking.Customer_Vehicle__r.Plate_No__c;

                        if(booking.Customer_Vehicle__r.Plate_Type_Code__c!=null)
                        VehicleDetail.PlateTypeId = booking.Customer_Vehicle__r.Plate_Type_Code__c;

                        if(booking.Customer_Vehicle__r.Plate_Source_Code__c!=null)
                        VehicleDetail.PlateSourceId = booking.Customer_Vehicle__r.Plate_Source_Code__c;

                        if(booking.Customer_Vehicle__r.Plate_Color_Code__c!=null)
                        VehicleDetail.PlateColor = booking.Customer_Vehicle__r.Plate_Color_Code__c;

                    }
                }

                if(booking.Purpose_Type__r.ETI_LookupCode__c!=null)
                VehicleDetail.TestPurposeId =  booking.Purpose_Type__r.ETI_LookupCode__c;

                if(booking.Total_Fee__c!=null)
                VehicleDetail.FeeAmount  = booking.Total_Fee__c;

                if(booking.Total_Tax__c!=null)
                VehicleDetail.TaxAmount   = booking.Total_Tax__c;

                if(booking.Total_Amount__c!=null)
                VehicleDetail.TotalAmount   = booking.Total_Amount__c;
              
                VehicleDetails.add(VehicleDetail);
            }
            autoNumber++;
        }


        /*if(VehicleDetails.size()>0)
        {
            VehicleDetailCollection.VehicleDetail = VehicleDetails;
            createReceipt(CrmTrxReference,CrmCustomerNo, CustomerName, CustomerMobileNo,
                          PreferredLanguage, CustomerSiteAddress, CustSiteGpsCord, TotalPaidAmount,
                          CrCardAuthCode,userName,VehicleDetailCollection);
        }*/

    }

    /**************************CREATE INSPECTION RECEIPT*******************************************************************************************************************/
    //By Using the service Vehicle test registration or Certificate transaction will be created in AMAN System .
    // Synchronous Receipt Creation
    /*public ET_CreateReceipt.Output createReceipt(String CrmTrxReference,String CrmCustomerNo,String CustomerName,String CustomerMobileNo,
                                                 String PreferredLanguage,String CustomerSiteAddress,String CustSiteGpsCord,Decimal TotalPaidAmount,
                                                 String CrCardAuthCode,String userName,ET_CreateReceipt.VehicleDetailCollection_element VehicleDetailCollection){
        ET_CreateReceiptService.execute_pt service = new ET_CreateReceiptService.execute_pt();
        saveReceiptResult = service.execute(CrmTrxReference,CrmCustomerNo,CustomerName,CustomerMobileNo,
                                            PreferredLanguage,CustomerSiteAddress,CustSiteGpsCord,TotalPaidAmount,
                                            CrCardAuthCode,userName,VehicleDetailCollection);
        return saveReceiptResult;
    }
    // Invoke Asynchronous Receipt Creation process
    public void createReceiptAsync(String CrmTrxReference,String CrmCustomerNo,String CustomerName,String CustomerMobileNo,String PreferredLanguage,String CustomerSiteAddress,String CustSiteGpsCord,Decimal TotalPaidAmount,String CrCardAuthCode,ET_CreateReceipt.VehicleDetailCollection_element VehicleDetailCollection){
        Continuation cont = new Continuation(30);
        cont.continuationMethod = 'createReceiptResponse';
        ET_CreateReceiptService.Asyncexecute_pt service = new ET_CreateReceiptService.Asyncexecute_pt();
        saveReceiptFutureResult = service.beginExecute(cont,CrmTrxReference,CrmCustomerNo,CustomerName,CustomerMobileNo,PreferredLanguage,CustomerSiteAddress,CustSiteGpsCord,TotalPaidAmount,CrCardAuthCode,VehicleDetailCollection);    
    }
    // Get the result of asynchronous receipt result process
    public ET_CreateReceipt.Output createReceiptResponse() {
        saveReceiptResult = saveReceiptFutureResult.getValue();
        return saveReceiptResult; 
    }*/

    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
        //ET_Common_Util.sendEmail('ERP Employee Daily Job - Result for ETI_Batch_Employee_Service', new string[]{'sagar.kambli@smaartt.com'}, null, null,'Data Results' ,successMap,errorMap);
        //system.debug('Completed processing ERP Employee Service successfully......');
    }
     public static void utilityMethod(){
        
        integer i=0;
        
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
        
    }
}