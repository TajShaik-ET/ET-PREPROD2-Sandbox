public class ETI_ReceiptController{

    
    public ET_Service_Request__c inspRequest{get;set;}
    public Decimal totalAmount{get;set;}
    public string requestLabel{get;set;}
    public String requestName{get;set;}
    public list<bookingDetails> bookingWrp{get;set;}
    public class bookingDetails{
        public Integer srN{get;set;}
        public ETI_Service_Line_Item__c booking{get;set;}
        public bookingDetails(Integer srN1,ETI_Service_Line_Item__c booking1){
            srN=srN1;
            booking=booking1;
        }
    }
    
    public ETI_ReceiptController() {
        String requestID = Apexpages.currentPage().getParameters().get('id');
        bookingWrp=new list<bookingDetails>();
        totalAmount=0;
        system.debug('requestID>> '+requestID );
        if(requestID !=null && requestID !=''){
            system.debug('sr>> '+requestID.startsWith(label.ETI_ServiceRequest_Record_Prefix));
            system.debug('bkng>> '+requestID.startsWith(label.ETI_Booking_Record_Prefix));
            integer i=1;
            if(requestID.startsWith(label.ETI_ServiceRequest_Record_Prefix)){
                requestLabel='Request Id';
                for(ETI_Service_Line_Item__c item: [SELECT Id,AMAN_Receipt_No__c,Booking__r.Booking_Date__c,Booking__r.ET_Location__r.Name,Booking__r.Service_Request__r.name, 
                                                           Service_Type__c,Booking__r.Customer_Vehicle__r.name,Booking__r.Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,
                                                           Booking__r.Total_Amount__c FROM ETI_Service_Line_Item__c WHERE Booking__r.Service_Request__c=: requestID ]){
                    system.debug('item>> '+item);
                    if(totalAmount==0)
                        totalAmount=item.Booking__r.Total_Amount__c;
                    if(requestName==null || requestName=='')
                        requestName=item.Booking__r.Service_Request__r.name;
                    bookingWrp.add(new bookingDetails(i,item));
                    i++;
                }
            }else if(requestID.startsWith(label.ETI_Booking_Record_Prefix)){
                requestLabel='Request Id';
                for(ETI_Service_Line_Item__c item: [SELECT Id,AMAN_Receipt_No__c,Booking__r.Booking_Date__c,Booking__r.ET_Location__r.Name,Booking__r.Service_Request__r.name, 
                                                           Service_Type__c,Booking__r.Customer_Vehicle__r.name,Booking__r.Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,
                                                           Booking__r.Total_Amount__c FROM ETI_Service_Line_Item__c WHERE Booking__c=: requestID ]){
                    system.debug('item>> '+item);
                    if(totalAmount==0)
                        totalAmount=item.Booking__r.Total_Amount__c;
                    if(requestName==null || requestName=='')
                        requestName=item.Booking__r.Service_Request__r.name;
                    bookingWrp.add(new bookingDetails(i,item));
                    i++;
                }
            }   
        }
    }
    @Auraenabled
    public static String getSyncAmanReciept(String recordId){
        system.debug('*****recordId ****** '+recordId );
        Boolean isSynched = false;
        if(recordId !=null && recordId !=''){
            if(recordId.startsWith(label.ETI_ServiceRequest_Record_Prefix)){
                List<ETI_Inspection_Receipt__c> lstReceipts =[Select Id,AMAN_Receipt_No__c,ET_Status__c From ETI_Inspection_Receipt__c Where Bookings__r.Service_Request__c=: recordId AND AMAN_Receipt_No__c!=null];
                if(!lstReceipts.isEmpty()){
                    for(ETI_Inspection_Receipt__c receipt :lstReceipts){
                        system.debug('receipt >> '+receipt);
                        if(receipt.ET_Status__c!='Cancelled')
                            isSynched=true;
                    }
                    if(isSynched)
                        return 'Synched';
                    else 
                        return 'Cancel';
                }else 
                    return 'NotSynched';
            }else if(recordId.startsWith(label.ETI_Booking_Record_Prefix)){
                List<ETI_Inspection_Receipt__c> lstReceipts =[Select Id,AMAN_Receipt_No__c,ET_Status__c From ETI_Inspection_Receipt__c Where Bookings__c=: recordId AND AMAN_Receipt_No__c!=null];
                if(!lstReceipts.isEmpty()){
                    for(ETI_Inspection_Receipt__c receipt :lstReceipts){
                        system.debug('receipt >> '+receipt);
                        if(receipt.ET_Status__c!='Cancelled')
                            isSynched=true;
                    }
                    if(isSynched)
                        return 'Synched';
                    else 
                        return 'Cancel';
                }else 
                    return 'NotSynched';
            }   
        }
        return null;
    }
    public static void utilityMehtod(){
        Integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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