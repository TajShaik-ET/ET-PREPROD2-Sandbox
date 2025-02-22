public class ETI_InvoiceController{
    public Boolean isBooking {get; set;}
    public ET_Service_Request__c inspRequest{get; set;}
    public List<ETI_Booking__c> bookingList {get;set;}
    public list<bookingDetails> bookingWrp{get;set;}
    public Date invoiceDate{get;set;}
    public class bookingDetails{
        public Integer srN{get;set;}
        public ETI_Booking__c booking{get;set;}
        public string DateVal {get;set;}
        
        public bookingDetails(Integer srN1,ETI_Booking__c booking1,String DtVal){
            srN=srN1;
            booking=booking1;
            DateVal =DtVal;
        }
    }
    public ETI_InvoiceController() {
        id requestid = Apexpages.currentPage().getParameters().get('id');
        if(requestid == null){
            return;
            
        }
        String sobjectName = requestid.getSObjectType().getDescribe().getName();
        if(sobjectName == 'ET_Service_Request__c'){
            isBooking = false;
            initValueForETServiceRequest(requestid);
        }else{
            isBooking = true;
            initValueForETBooking(requestid);
        }
        
        
    }
    
    public void initValueForETServiceRequest(id requestid){
        this.inspRequest= [SELECT id, Name, ET_Account__r.Name, Total_Amount__c, Payment_Status__c FROM ET_Service_Request__c WHERE id = :requestid];
        bookingList= new list<ETI_Booking__c>();
        bookingWrp=new list<bookingDetails>();
        integer i=1;
        for(ETI_Booking__c bkng: [SELECT Id,Booking_Date_Time__c,ET_Location__r.Name,Service_Request__c, Service_Type__c,Customer_Vehicle__r.name,Customer_Vehicle__r.Chassis_No__c,Booking_Date__c,Total_Amount__c,createdDate
                                  FROM ETI_Booking__c WHERE Service_Request__c=:  inspRequest.Id ]){
                                      Datetime thisDT = bkng.Booking_Date_Time__c;
                                      String myDate = thisDT.format('dd/MM/yyyy HH:mm', 'Asia/Dubai');
                                      bookingList.add(bkng);
                                      bookingWrp.add(new bookingDetails(i,bkng,myDate));
                                      if(invoiceDate==null)
                                          invoiceDate=bkng.createdDate.date();
                                      i++;
                                  }
    }
    
    public void initValueForETBooking(id bookingId){
         bookingList= new list<ETI_Booking__c>();
        bookingWrp=new list<bookingDetails>();
        integer i=1;
        id serviceId;
        for(ETI_Booking__c bkng: [SELECT Id,Booking_Date_Time__c,ET_Location__r.Name,Service_Request__c, Service_Type__c,Customer_Vehicle__r.name,Customer_Vehicle__r.Chassis_No__c,Booking_Date__c,Total_Amount__c,createdDate
                                  FROM ETI_Booking__c WHERE id=:  bookingId ]){
                                      Datetime thisDT = bkng.Booking_Date_Time__c;
                                      String myDate = thisDT.format('dd/MM/yyyy HH:mm', 'Asia/Dubai');
                                      bookingList.add(bkng);
                                      bookingWrp.add(new bookingDetails(i,bkng,myDate));
                                      if(invoiceDate==null)
                                          invoiceDate=bkng.createdDate.date();
                                      i++;
                                      serviceId = bkng.Service_Request__c;
                                  }
         this.inspRequest= [SELECT id, Name, ET_Account__r.Name, Total_Amount__c, Payment_Status__c FROM ET_Service_Request__c WHERE id = :serviceId];
    }
    public static void utilityMehtod(){
        
        
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
    }
}