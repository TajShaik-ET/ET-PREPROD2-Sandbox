public class ETI_ReceiptCtrl {
    public ET_Service_Request__c serviceRequest {get;set;}
     public String  serviceRequestName {get;set;}
    public List<Invoice__c> invoiceList {get;set;}
    public List<WrapperBooking> wrapBookings {get;set;}
    public double amount {get;set;} 
    public double vat {get;set;}
    public double totalAmount {get;set;}
    public Boolean isBooking {get; set;}

    public ETI_ReceiptCtrl(){
        amount = 0.00;
        vat = 0.00;
        totalAmount = 0.00;
        id recordId = Apexpages.currentPage().getParameters().get('id');
        invoiceList = new List<Invoice__c>();
        wrapBookings = new List<WrapperBooking>();
        //loadInvoices();
        if(invoiceList.size()==0){
            
        } 
        if(recordId == null){
            return;
            
        }
        String sobjectName = recordId.getSObjectType().getDescribe().getName();
        system.debug('sobjectName>> '+sobjectName);
        if(sobjectName == 'ET_Service_Request__c'){
        system.debug('recordId11>> '+recordId);
            isBooking = false;
            initValueForETServiceRequest(recordId);
        }else{
        system.debug('recordId22>> '+recordId);
            isBooking = true;
            initValueForETBooking(recordId);
        }
    }
    
    public void initValueForETServiceRequest(id recordId){
      system.debug('recordId33>> '+recordId);
      List<ETI_Booking__c> lstBookings = [Select Id,Service_Request__r.Name,Name,Service_Type__c,ET_Location__c,ET_Location__r.ETSALES_Emirates__c,ET_Location__r.Name,Customer_Vehicle__c,Customer_Vehicle__r.Registration_Expiry_Date__c,Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__r.Plate_Color__c,Customer_Vehicle__r.Plate_Source__c,Customer_Vehicle__r.Plate_Type__c,Customer_Vehicle__r.Chassis_No__c,
                                                   Purpose_Type__r.Name,User__r.Name,Customer_Vehicle__r.Customer_Name__c,Allocated_Lane__r.Lane_Type_AMAN__c,(Select Id,Name,CreatedDate,AMAN_Receipt_No__c,Service_Line_Item__r.Service__r.Name,Service_Line_Item__r.Fee_Amount__c,Service_Line_Item__r.Tax_Amount__c,Service_Line_Item__r.Total_Fee__c from Receipts__r WHERE AMAN_Receipt_No__c !=null AND ET_Status__c ='Active' order by createddate) FROM ETI_Booking__c WHERE Service_Request__c=:recordId];
        if(!lstBookings.isEmpty() && lstBookings.size()>0){
            for(ETI_Booking__c bk : lstBookings){
                System.debug('bk.Service_Request__r.Name ' + bk.Service_Request__r.Name);
                serviceRequestName = bk.Service_Request__r.Name;
                List<ETI_Inspection_Receipt__c> ReceiptsList = new List<ETI_Inspection_Receipt__c>();
                WrapperBooking wrap = new WrapperBooking();
                wrap.booking = bk;
                System.debug('receipt size'+bk.Receipts__r.size());
                if(bk.Receipts__r.size()>0){
                    for(ETI_Inspection_Receipt__c receipt : bk.Receipts__r){
                        amount+= receipt.Service_Line_Item__r.Fee_Amount__c;
                        vat+= receipt.Service_Line_Item__r.Tax_Amount__c;
                        totalAmount+= receipt.Service_Line_Item__r.Total_Fee__c;
                        wrap.receiptDate = String.valueOf(receipt.CreatedDate.format('dd/MM/yyyy'));
                        wrap.receiptTime = String.valueOf(receipt.CreatedDate.format('HH:mm'));
                        ReceiptsList.add(receipt);
                    }
                    wrap.ReceiptsList = ReceiptsList;
                    if(bk.ET_Location__c !=null){
                        wrap.location = bk.ET_Location__r.Name;
                        wrap.emirate = bk.ET_Location__r.ETSALES_Emirates__c;
                    }
                }
                wrap.customerName= bk.User__r.Name!=null && bk.User__r.Name!=''? bk.User__r.Name:bk.Customer_Vehicle__r.Customer_Name__c;
                wrapBookings.add(wrap);
                system.debug('wrapBookings>> '+wrapBookings);
            }
        }
    } 
    public void initValueForETBooking(id recordId){
        system.debug('recordId44>> '+recordId);
        List<ETI_Booking__c> lstBookings1 = [Select Id,Service_Request__c from ETI_Booking__c Where id=:recordId];
        if(lstBookings1!=null && lstBookings1.size()>0){
            List<ETI_Booking__c> lstBookings = [Select Id,Service_Request__r.Name,Name,Service_Type__c,ET_Location__c,ET_Location__r.ETSALES_Emirates__c,ET_Location__r.Name,Customer_Vehicle__c,Customer_Vehicle__r.Registration_Expiry_Date__c,Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__r.Plate_Color__c,Customer_Vehicle__r.Plate_Source__c,Customer_Vehicle__r.Plate_Type__c,Customer_Vehicle__r.Chassis_No__c,
                                                       Purpose_Type__r.Name,User__r.Name,Customer_Vehicle__r.Customer_Name__c,Allocated_Lane__r.Lane_Type_AMAN__c,(Select Id,Name,CreatedDate,AMAN_Receipt_No__c,Service_Line_Item__r.Service__r.Name,Service_Line_Item__r.Fee_Amount__c,Service_Line_Item__r.Tax_Amount__c,Service_Line_Item__r.Total_Fee__c from Receipts__r WHERE AMAN_Receipt_No__c !=null AND ET_Status__c ='Active' order by createddate) from ETI_Booking__c WHERE Id=:recordId];
            if(!lstBookings.isEmpty() && lstBookings.size()>0){
                for(ETI_Booking__c bk : lstBookings){
                    serviceRequestName = bk.Service_Request__r.Name;
                    List<ETI_Inspection_Receipt__c> ReceiptsList = new List<ETI_Inspection_Receipt__c>();
                    WrapperBooking wrap = new WrapperBooking();
                    wrap.booking = bk;
                    if(bk.Receipts__r.size()>0){
                        for(ETI_Inspection_Receipt__c receipt : bk.Receipts__r){
                            amount+= receipt.Service_Line_Item__r.Fee_Amount__c;
                            vat+= receipt.Service_Line_Item__r.Tax_Amount__c;
                            totalAmount+= receipt.Service_Line_Item__r.Total_Fee__c;
                            wrap.receiptDate = String.valueOf(receipt.CreatedDate.format('dd/MM/yyyy'));
                            wrap.receiptTime = String.valueOf(receipt.CreatedDate.format('HH:mm'));
                            ReceiptsList.add(receipt);
                        }
                        wrap.ReceiptsList = ReceiptsList;
                        if(bk.ET_Location__c !=null){
                            wrap.location = bk.ET_Location__r.Name;
                            wrap.emirate = bk.ET_Location__r.ETSALES_Emirates__c;
                        }
                    }
                    wrap.customerName= bk.User__r.Name!=null && bk.User__r.Name!=''? bk.User__r.Name:bk.Customer_Vehicle__r.Customer_Name__c;
                    wrapBookings.add(wrap);
                    system.debug('wrapBookings>> '+wrapBookings);
                }
            }
        }
    } 
    
    class WrapperBooking{
        public ETI_booking__c booking {get;set;}
        public List<ETI_Inspection_Receipt__c> ReceiptsList {get;set;}  
        public string customerName{get; set;}
        public string location {get;set;}
        public string receiptDate {get;set;}
        public string receiptTime {get;set;}
        public string emirate {get;set;}
        WrapperBooking(){}
    }
     
}