public class ETI_SendReceipttoAmanController {
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Create Receipts
    * @Params           String recId
    * @return           Boolean
    *********************************************************************************************************/
    @AuraEnabled
    public static Boolean createReceiptInAman(String recId){
        List<ETI_Booking__c> lstBooking=new List<ETI_Booking__c>();
        List<ET_Service_Request__c> serviceRequest = [SELECT Id,Name,(Select Id,Booking_Date__c From Bookings__r Where Booking_Date__c<:Date.Today()),
                                                             (Select Id,Name From Receipts__r)
                                                             FROM ET_Service_Request__c WHERE Id =:recId AND Payment_Status__c = 'Payment Success'];
        if(!serviceRequest.isEmpty()){
            if(serviceRequest[0].Receipts__r==null || serviceRequest[0].Receipts__r.size()==0){
                if(!serviceRequest[0].Bookings__r.isEmpty()){
                    for(ETI_Booking__c bkng:serviceRequest[0].Bookings__r){
                       if(bkng.Booking_Date__c!=Date.today()){
                           bkng.Booking_Date__c= Date.today();
                           lstBooking.add(bkng);
                       }
                    }
                }
                if(!lstBooking.isEmpty()){
                    update lstBooking;
                }
                ETI_ServiceRequestHandler.sendData(new set<Id>{recId},null,null,null);
                return true;
            }else {
                set<id> bkngIteIds=new set<id>();
                for(ETI_Service_Line_Item__c bkngItems: [SELECT Id, Name,Booking__c,Booking__r.Payment_Status__c,Booking__r.Booking_Date__c 
                                                                FROM ETI_Service_Line_Item__c 
                                                                Where Booking__r.Service_Request__c =:recId 
                                                                AND Booking__r.Payment_Status__c= 'Payment Success' 
                                                                AND AMAN_Receipt_No__c=Null 
                                                                AND Booking__r.Booking_Status__c !='Cancelled']){
                     if(bkngItems.Booking__r.Booking_Date__c<Date.today()){
                         ETI_Booking__c bkng=new ETI_Booking__c(); 
                         bkng.Id=bkngItems.Booking__c;
                         bkng.Booking_Date__c= Date.today();
                         lstBooking.add(bkng);
                     }                                            
                     bkngIteIds.add(bkngItems.Id);                                             
                }
                if(!lstBooking.isEmpty()){
                    update lstBooking;
                }
                if(!bkngIteIds.isEmpty()){
                    ETI_CreateReceiptInAMANBatch batchCreateReceipt = new ETI_CreateReceiptInAMANBatch(null,bkngIteIds);
                    Database.executeBatch(batchCreateReceipt,1);
                    return true;
                }
            }
        }
        return false; 
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to ReSynch Receipts
    * @Params           String recId
    * @return           Boolean
    *********************************************************************************************************/
    @AuraEnabled
    public static Boolean sendDataToAman(String recId){
        List<ETI_Inspection_Receipt__c> receipt = [SELECT Id,Service_Line_Item__c,Service_Line_Item__r.Booking__c,Integration_Message__c
                                                   FROM ETI_Inspection_Receipt__c 
                                                   WHERE Id =:recId and Integration_Status__C !='Success' ];
        if(!receipt.isEmpty()){
            if(receipt[0].Service_Line_Item__c != null){//&& !String.isBlank(receipt[0].Integration_Message__c)
               ETI_Inspection_Receipt__c upRec = new ETI_Inspection_Receipt__c(Id = receipt[0].Id);
               upRec.Integration_Status__c = 'In Progess';
               upRec.Integration_Message__c = '';
               update upRec;
               ETI_ServiceRequestHandler.sendData(null,receipt[0].Service_Line_Item__c,receipt[0].Service_Line_Item__r.Booking__c,receipt[0].Id);
            }
            return true;
        }
    return false; 
    }
    
}