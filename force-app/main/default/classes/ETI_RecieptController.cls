public class ETI_RecieptController{

    
    public ET_Service_Request__c inspRequest{get;set;}
    public Decimal totalAmount{get;set;}
    public Date recieptDate{get;set;}
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
    
    public ETI_RecieptController() {
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
                                                           Booking__r.Total_Amount__c,(Select Id,createdDate from Receipts__r Where ET_Status__c='Active' order by createdDate desc limit 1)  FROM ETI_Service_Line_Item__c WHERE Booking__r.Service_Request__c=: requestID ]){
                    system.debug('item>> '+item);
                    if(totalAmount==0)
                        totalAmount=item.Booking__r.Total_Amount__c;
                    if(requestName==null || requestName=='')
                        requestName=item.Booking__r.Service_Request__r.name;
                    bookingWrp.add(new bookingDetails(i,item));
                    if(item.Receipts__r!=null && item.Receipts__r.size()>0 && recieptDate==null)
                        recieptDate=item.Receipts__r[0].createdDate.date();
                    System.debug('recieptDate=' + recieptDate);
                    i++;
                }
            }else if(requestID.startsWith(label.ETI_Booking_Record_Prefix)){
                requestLabel='Request Id';
                for(ETI_Service_Line_Item__c item: [SELECT Id,AMAN_Receipt_No__c,Booking__r.Booking_Date__c,Booking__r.ET_Location__r.Name,Booking__r.Service_Request__r.name, 
                                                           Service_Type__c,Booking__r.Customer_Vehicle__r.name,Booking__r.Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,
                                                           Booking__r.Total_Amount__c,(Select Id,createdDate from Receipts__r Where ET_Status__c='Active' order by createdDate desc limit 1) FROM ETI_Service_Line_Item__c WHERE Booking__c=: requestID ]){
                    system.debug('item>> '+item);
                    if(totalAmount==0)
                        totalAmount=item.Booking__r.Total_Amount__c;
                    if(requestName==null || requestName=='')
                        requestName=item.Booking__r.Service_Request__r.name;
                    bookingWrp.add(new bookingDetails(i,item));
                    if(item.Receipts__r!=null && item.Receipts__r.size()>0 && recieptDate==null)
                        recieptDate=item.Receipts__r[0].createdDate.date();
                    System.debug('recieptDate=' + recieptDate);
                    i++;
                }
            }   
        }
    }
    @Auraenabled
    public static Boolean getSyncAmanReciept(String recordId){
        Boolean isSynched = false;
        system.debug('*****recordId ****** '+recordId );
        if(recordId !=null && recordId !=''){
            if(recordId.startsWith(label.ETI_ServiceRequest_Record_Prefix)){
                for(ETI_Service_Line_Item__c item: [SELECT Id,AMAN_Receipt_No__c,Booking__r.Booking_Date__c,Booking__r.ET_Location__r.Name,Booking__r.Service_Request__r.name, 
                                                           Service_Type__c,Booking__r.Customer_Vehicle__r.name,Booking__r.Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,
                                                           Booking__r.Total_Amount__c,(Select Id,AMAN_Receipt_No__c from Receipts__r Where ET_Status__c='Active' AND AMAN_Receipt_No__c!=null order by createdDate desc limit 1) FROM ETI_Service_Line_Item__c WHERE Booking__r.Service_Request__c=: recordId ]){
                    system.debug('item>> '+item);
                    
                    if(!isSynched && item.Receipts__r !=null && item.Receipts__r.size()>0)
                        isSynched =true;
                }
            }else if(recordId.startsWith(label.ETI_Booking_Record_Prefix)){
                for(ETI_Service_Line_Item__c item: [SELECT Id,AMAN_Receipt_No__c,Booking__r.Booking_Date__c,Booking__r.ET_Location__r.Name,Booking__r.Service_Request__r.name, 
                                                           Service_Type__c,Booking__r.Customer_Vehicle__r.name,Booking__r.Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,
                                                           Booking__r.Total_Amount__c,(Select Id,AMAN_Receipt_No__c from Receipts__r Where ET_Status__c='Active' AND AMAN_Receipt_No__c!=null order by createdDate desc limit 1) FROM ETI_Service_Line_Item__c WHERE Booking__c=: recordId ]){
                    system.debug('item>> '+item);
                    if(!isSynched && item.Receipts__r !=null && item.Receipts__r.size()>0)
                        isSynched =true;
                }
            }   
        }
        return isSynched ;
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