public class ETI_InvoiceCtrl {
    public ET_Service_Request__c serviceRequest {get;set;}
    public String  serviceRequestName {get;set;}
    public List<Invoice__c> invoiceList {get;set;}
    public List<WrapperBooking> wrapBookings {get;set;}
    public double amount {get;set;}
    public double vat {get;set;}
    public double totalAmount {get;set;}
    public Boolean isBooking {get; set;}

    public ETI_InvoiceCtrl(){
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
        try{
            invoiceList = [Select Id,Name,CreatedDate,Total_Inv_Amount__c,Trx_Date__c,Service_Request__r.ET_Account__c from Invoice__c WHERE Service_Request__c=:recordId and ETST_Active__c=true order by createddate desc limit 1];
            if(invoiceList.size()>0){ 
                List<ETI_Booking__c> lstBookings = [Select Id,Name,Service_Request__r.Name,Service_Type__c,ET_Location__c,ET_Location__r.ETSALES_Emirates__c,ET_Location__r.Name,Customer_Vehicle__c,Customer_Vehicle__r.Registration_Expiry_Date__c,Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__r.Plate_Color__c,Customer_Vehicle__r.Plate_Source__c,
                                                           Customer_Vehicle__r.Plate_Type__c,Customer_Vehicle__r.Chassis_No__c,Customer_Vehicle__r.Vehicle_Make__c,Customer_Vehicle__r.Vehicle_Model__c,Customer_Vehicle__r.Vehicle_Type__c,Customer_Vehicle__r.Vehicle_Year__c,Customer_Vehicle__r.Vehicle_Color1__c,Payment_Status__c,
                                                           Purpose_Type__r.Name,User__r.Name,Customer_Vehicle__r.Customer_Name__c,Allocated_Lane__r.Lane_Type_AMAN__c,(Select Id,Name,Service__r.Name,Fee_Amount__c,Tax_Amount__c,Total_Fee__c,Test_Date__c,Test_Result__c from Services__r order by createddate) from ETI_Booking__c WHERE Service_Request__c=:recordId];
               if(!lstBookings.isEmpty() && lstBookings.size()>0){
                    for(ETI_Booking__c bk : lstBookings){
                        serviceRequestName = bk.Service_Request__r.Name;
                        List<ETI_Service_Line_Item__c> lstServiceLineItems = new List<ETI_Service_Line_Item__c>();
                        WrapperBooking wrap = new WrapperBooking();
                        wrap.booking = bk;
                        if(bk.Services__r.size()>0){
                            for(ETI_Service_Line_Item__c srvLine : bk.Services__r){
                                /*amount+= srvLine.Fee_Amount__c;
                                vat+= srvLine.Tax_Amount__c;
                                totalAmount+= srvLine.Total_Fee__c;*/
                                lstServiceLineItems.add(srvLine);
                            }
                            wrap.serviceLineItemsList = lstServiceLineItems;
                            if(bk.ET_Location__c !=null){
                                wrap.location = bk.ET_Location__r.Name;
                                wrap.emirate = bk.ET_Location__r.ETSALES_Emirates__c;
                            }
                        }
                        wrap.customerName= bk.User__r.Name!=null && bk.User__r.Name!=''? bk.User__r.Name:bk.Customer_Vehicle__r.Customer_Name__c;
                        wrap.invoiceDate = String.valueOf(invoiceList[0].CreatedDate.format('dd/MM/yyyy'));
                        wrap.invoiceTime = String.valueOf(invoiceList[0].CreatedDate.format('HH:mm'));
                        wrapBookings.add(wrap);
                    }
                }
            }
        }catch(exception e){
            System.debug('Exception '+e.getMessage());
            System.debug('Exception line '+e.getLineNumber());
        }
    } 
    public void initValueForETBooking(id recordId){
        try{
            List<ETI_Booking__c> lstBookings1 = [Select Id,Service_Request__c from ETI_Booking__c Where id=:recordId];
            if(lstBookings1!=null && lstBookings1.size()>0)
                invoiceList = [Select Id,Name,CreatedDate,Total_Inv_Amount__c,Trx_Date__c,Service_Request__r.ET_Account__c from Invoice__c WHERE Service_Request__c=:lstBookings1[0].Service_Request__c and ETST_Active__c=true order by createddate desc limit 1];
            if(invoiceList.size()>0){ 
                List<ETI_Booking__c> lstBookings = [Select Id,Name,Service_Request__r.Name,Service_Type__c,ET_Location__c,ET_Location__r.ETSALES_Emirates__c,ET_Location__r.Name,Customer_Vehicle__c,Customer_Vehicle__r.Registration_Expiry_Date__c,Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__r.Plate_Color__c,Customer_Vehicle__r.Plate_Source__c,Customer_Vehicle__r.Plate_Type__c,Customer_Vehicle__r.Chassis_No__c,
                                                           Purpose_Type__r.Name,User__r.Name,Customer_Vehicle__r.Customer_Name__c,Allocated_Lane__r.Lane_Type_AMAN__c,Customer_Vehicle__r.Vehicle_Color1__c,Payment_Status__c,
                                                           Customer_Vehicle__r.Vehicle_Make__c,Customer_Vehicle__r.Vehicle_Model__c,Customer_Vehicle__r.Vehicle_Type__c,Customer_Vehicle__r.Vehicle_Year__c,
                                                           (Select Id,Name,Service__r.Name,Fee_Amount__c,Tax_Amount__c,Total_Fee__c,Test_Date__c,Test_Result__c from Services__r order by createddate) from ETI_Booking__c WHERE Id=:recordId];
                if(!lstBookings.isEmpty() && lstBookings.size()>0){
                    for(ETI_Booking__c bk : lstBookings){
                         serviceRequestName = bk.Service_Request__r.Name;
                        List<ETI_Service_Line_Item__c> lstServiceLineItems = new List<ETI_Service_Line_Item__c>();
                        WrapperBooking wrap = new WrapperBooking();
                        wrap.booking = bk;
                        if(bk.Services__r.size()>0){
                            for(ETI_Service_Line_Item__c srvLine : bk.Services__r){
                                /*if(srvLine.Fee_Amount__c!=null)
                                    amount+= srvLine.Fee_Amount__c;
                                if(srvLine.Tax_Amount__c!=null )
                                    vat+= srvLine.Tax_Amount__c;
                                if(srvLine.Total_Fee__c!=null)
                                    totalAmount+= srvLine.Total_Fee__c;*/
                                lstServiceLineItems.add(srvLine);
                            }
                            wrap.serviceLineItemsList = lstServiceLineItems;
                            if(bk.ET_Location__c !=null){
                                wrap.location = bk.ET_Location__r.Name;
                                wrap.emirate = bk.ET_Location__r.ETSALES_Emirates__c;
                            }
                        }
                        wrap.customerName= bk.User__r.Name!=null && bk.User__r.Name!=''? bk.User__r.Name:bk.Customer_Vehicle__r.Customer_Name__c;
                        wrap.invoiceDate = String.valueOf(invoiceList[0].CreatedDate.format('dd/MM/yyyy'));
                        wrap.invoiceTime = String.valueOf(invoiceList[0].CreatedDate.format('HH:mm'));
                        wrapBookings.add(wrap);
                        system.debug('wrapBookings>> '+wrapBookings);
                    }
                }
            }
        }catch(exception e){
            System.debug('Exception '+e.getMessage());
            System.debug('Exception line '+e.getLineNumber());
        }
    } 
    
    class WrapperBooking{
        public ETI_booking__c booking {get;set;}
        public List<ETI_Service_Line_Item__c> serviceLineItemsList {get;set;}
        public string customerName{get; set;}
        public string location {get;set;}
        public string invoiceDate {get;set;}
        public string invoiceTime {get;set;}
        public string emirate {get;set;}       
        WrapperBooking(){}
    }
    
}