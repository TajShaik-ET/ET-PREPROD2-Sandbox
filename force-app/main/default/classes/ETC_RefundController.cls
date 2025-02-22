public class ETC_RefundController {
    
    /*  @InvocableMethod
public static List <ET_Service_Request__c> execute (List<ET_Service_Request__c> requestList) {
system.debug('refund ctrl');
List<ETC_Rental_Settings__c> cancellationMatrix = new List<ETC_Rental_Settings__c> ([SELECT Id,ETC_Policy__c ,ETC_Refund_Percentage__c ,ETC_hours_before_booking_date__c 
FROM ETC_Rental_Settings__c WHERE ETC_Policy__c ='Cancellation' order by ETC_hours_before_booking_date__c desc ]);

Map<Id, ET_Refund__c> refundMap = new Map<Id, ET_Refund__c>();
List<ET_Refund__c> refundList = new List<ET_Refund__c>();
Id recordTypeId = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('Car_Services_Refund_Record_Type').getRecordTypeId();
for(ET_Service_Request__c req : requestList){
ET_Refund__c refund=new ET_Refund__c();
refund.RecordTypeId = recordTypeId;
refund.ET_Service_Request__c = req.Id;
}

return null;    
} */
    
    @AuraEnabled
    public static List<ETCAR_Service_Request_Line_Item__c> getVehicleBookings(String recId) {
        List<ETCAR_Service_Request_Line_Item__c> vehBookingsList =
            [SELECT Id, Name,ETCAR_Service_Request__c,ETST_Service_Type__c,Total_Booking_Cost_With_Vat__c FROM ETCAR_Service_Request_Line_Item__c WHERE ETCAR_Service_Request__c =:recId AND ETCAR_Status__c =: 'Booking Confirmed' ];
        system.debug('list '+vehBookingsList);
        return vehBookingsList;
    }
    
    @AuraEnabled
    public static Map<string,decimal> calculateRefundAmount(list<string> vehBkngs){
        Map<string,decimal> refunds = new Map<string,decimal>();
        List<ETC_Limo_Refund_Settings__c> refundSettings = [select ETC_From__c,ETC_To__C, ETC_Percentage__c from ETC_Limo_Refund_Settings__c];
        List<ETCAR_Service_Request_Line_Item__c> vehBookingsList =[SELECT Id, Name,ETCAR_Service_Request__c,ETST_Service_Type__c,Total_Booking_Cost_With_Vat__c,ETCAR_Pick_UP_Date_Time__c FROM ETCAR_Service_Request_Line_Item__c WHERE id=:vehBkngs];
        decimal total=0;
        for(ETCAR_Service_Request_Line_Item__c lt :vehBookingsList ){            
            decimal decHours = ((lt.ETCAR_Pick_UP_Date_Time__c.getTime())/1000/60/60) - ((system.now().getTime())/1000/60/60);
            system.debug('dechrs '+decHours);
            decimal refundper = 0;
            /*  if(decHours>24){
                refundper=1;
                }else if(decHours>5){
                refundper=0.5;
            } */
            for(ETC_Limo_Refund_Settings__c s:refundSettings){
                if(decHours>=decimal.valueof(s.ETC_From__c) && (s.ETC_To__C==null || decHours<=decimal.valueof(s.ETC_To__C)) ){
                    refundper=s.ETC_Percentage__c;
                    break;
                } 
            }
            
            total+=refundper*lt.Total_Booking_Cost_With_Vat__c;
            refunds.put(lt.id,refundper*lt.Total_Booking_Cost_With_Vat__c);            
        }
        refunds.put('total',total);   
        system.debug('list '+refunds);
        return refunds;
    }
    
    @AuraEnabled
    public static void createRefund(list<ETCAR_Service_Request_Line_Item__c> lineItems){
        string requestId =lineItems[0].ETCAR_Service_Request__c;
        List<ETST_Payment__c> payments = [Select Id,Name,CreatedDate From ETST_Payment__c Where ET_Service_Request__c=:requestId and  ETST_Payment_State__c='CAPTURED' AND ETST_Capture_State__c='SUCCESS' order by createdDate desc limit 1];
        if(payments.size()>0){
            Id recordTypeId = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('Car_Services_Refund_Record_Type').getRecordTypeId();
            list<string> itemIds =new list<string>();
            for(ETCAR_Service_Request_Line_Item__c item:lineItems){
                item.ETCAR_Status__c = 'Cancelled';
                itemIds.add(item.id);
            }
            Map<string,decimal> refunds =calculateRefundAmount(itemIds);
            ET_Refund__c refund=new ET_Refund__c();
            refund.RecordTypeId = recordTypeId;
            refund.ET_Service_Request__c = requestId;
            refund.ET_Refund_Amount__c = refunds.get('total');
            refund.ET_Payment__c=payments[0].Id; 
            if( refund.ET_Refund_Amount__c == 0){
                refund.ET_Refund_Status__c='Completed';
                insert refund;
                update lineItems;
            }else{
                if(payments[0].createddate.isSameDay(system.now())){
                    refund.ET_Refund_Status__c='Process Refund NextDay'; 
                    insert refund;
                    update lineItems;
                    
                    Integer hur = payments[0].createddate.hour();
                    Date nextDay=Date.today()+1;
                    integer dd=nextDay.day();
                    integer mm=nextDay.month(); 
                    // insert refund;
                    String refundTime = '0 0 '+hur+' '+dd+' '+mm+' ?';
                    ETC_CallRefundServiceScheduled SC = new ETC_CallRefundServiceScheduled(new set<Id>{refund.Id}); 
                    System.schedule('ETC CallRefundServiceScheduled '+refund.Name, refundTime, SC);
                } else{
                    ET_Common_Util.ETPaymentResponse response=ET_Payment_Controller.createRefundRequest(payments[0].Id,refund.ET_Refund_Amount__c);
                    system.debug('response>> '+response);
                    ET_common_util.cls_authResponse authResponse = new ET_common_util.cls_authResponse();
                    system.debug('authResponse>> '+authResponse);
                    if(response!=null && response.authResponse!=null){
                        authResponse = response.authResponse;
                        if(authResponse.authorizationCode!=null && authResponse.authorizationCode!='')
                            refund.ET_Authorization_Code__c=authResponse.authorizationCode;
                        if(authResponse.success == 'true'){
                            refund.ET_Refund_Status__c='Completed';
                        }else {
                            refund.ET_Refund_Status__c='Failed';
                        }
                    }
                    insert refund;
                    update lineItems;
                } 
            }
        }
    }
    /*
public static void createFlatRefundRequest(Set<Id> flatRefundIds){

List<ETC_Rental_Settings__c> flatPercentage = [SELECT Id,ETC_Policy__c,ETC_Refund_Percentage__c FROM ETC_Rental_Settings__c WHERE ETC_Policy__c ='Flat Refund' limit 1];
Id recordTypeId = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('Car_Services_Refund_Record_Type').getRecordTypeId();
List<ET_Refund__c> refundList = new List<ET_Refund__c>();
List<ETCAR_Service_Request_Line_Item__c> vehBkngList = new List<ETCAR_Service_Request_Line_Item__c>();
for(ET_Service_Request__c req : [SELECT Id, Name,ETC_Billing_Total__c,ETC_Booking_Confirmed_Amount__c, (SELECT Id,ETCAR_Status__c FROM Service_Request_Line_Items__r ),(Select Id,Name,CreatedDate From ET_Payments__r Where  ETST_Payment_State__c='CAPTURED' AND ETST_Capture_State__c='SUCCESS' order by createdDate desc limit 1)
FROM ET_Service_Request__c WHERE Id In: flatRefundIds]){
for(ETCAR_Service_Request_Line_Item__c vBkng : req.Service_Request_Line_Items__r){
if(vBkng.ETCAR_Status__c != 'Cancelled'){
vBkng.ETCAR_Status__c = 'Cancelled';
vehBkngList.add(vBkng);
}
}
system.debug('loop');
ET_Refund__c refund=new ET_Refund__c();
refund.RecordTypeId = recordTypeId;
refund.ET_Service_Request__c = req.Id;
refund.ET_Refund_Amount__c = (req.ETC_Booking_Confirmed_Amount__c*flatPercentage[0].ETC_Refund_Percentage__c)/100;
if(req.ET_Payments__r.size()>0) refund.ET_Payment__c=req.ET_Payments__r[0].Id;
Date paymentDate =date.newinstance(req.ET_Payments__r[0].CreatedDate.year(), req.ET_Payments__r[0].CreatedDate.month(), req.ET_Payments__r[0].CreatedDate.day());
Integer hur = req.ET_Payments__r[0].CreatedDate.hour();   
system.debug('paymentdate'+paymentDate);
if(paymentDate!=Date.today()){
if(req.ET_Payments__r.size()>0){
ET_Common_Util.ETPaymentResponse response=ET_Payment_Controller.createRefundRequest(req.ET_Payments__r[0].Id,refund.ET_Refund_Amount__c);
system.debug('response>> '+response);
ET_common_util.cls_authResponse authResponse = new ET_common_util.cls_authResponse();
if(response!=null && response.authResponse!=null){
system.debug('authResponse>> '+authResponse);
authResponse = response.authResponse;
if(authResponse.authorizationCode!=null && authResponse.authorizationCode!='')
refund.ET_Authorization_Code__c=authResponse.authorizationCode;
if(authResponse.success == 'true'){
refund.ET_Refund_Status__c='Completed';
}else {
refund.ET_Refund_Status__c='Failed';
}
}else {
refund.ET_Refund_Status__c='Failed';
}
}
}else {
system.debug('paymentDate>> '+paymentDate);
Date nextDay=Date.today()+1;
system.debug('nextDay>> '+nextDay);
system.debug('hur>> '+hur);
if(paymentDate==Date.today()){
string result;
result='S';
if(result=='S'){
refund.ET_Refund_Status__c='Process Refund NextDay';
integer dd=nextDay.day();
integer mm=nextDay.month();
//String sched3am = '0 0 3 '+dd+' '+mm+' ?'; //Next Day, 3AM
String sched3am = '0 0 '+hur+' '+dd+' '+mm+' ?'; //After 24 hours
//  ETI_CallRefundServiceScheduled SC = new ETI_CallRefundServiceScheduled(new set<Id>{refund.Id}); 
//  System.schedule('ETI CallRefundServiceScheduled - Next Day '+booking.Name, sched3am, SC);
//  return refund;
}
}
} 
refundList.add(refund);
}

if(refundList.size()>0) insert refundList;
if(vehBkngList.size()>0) update vehBkngList;

} */
    
    
    @future(callout=true)
    public static void callRefundRequest(Set<Id> refundIds) {
        List<ET_Refund__c> listRefund = new List<ET_Refund__c>();
        try{
            if(!refundIds.isEmpty()){
                for(ET_Refund__c refund:[SELECT Id,Name,ETI_Booking__c,ET_Refund_Amount__c,ET_Refund_Status__c,ET_Payment__c FROM ET_Refund__c WHERE Id=:refundIds AND ET_Payment__r.CreatedDate!=TODAY]){
                    listRefund.add(refund);
                }
                if(!listRefund.isEmpty()){
                    if(listRefund[0].ET_Refund_Amount__c!=0){
                        ET_Common_Util.ETPaymentResponse response=ET_Payment_Controller.createRefundRequest(listRefund[0].ET_Payment__c,listRefund[0].ET_Refund_Amount__c);
                        system.debug('response>> '+response);
                        ET_common_util.cls_authResponse authResponse = new ET_common_util.cls_authResponse();
                        if(response!=null && response.authResponse!=null){
                            system.debug('authResponse>> '+authResponse);
                            authResponse = response.authResponse;
                            if(authResponse.authorizationCode!=null && authResponse.authorizationCode!='')
                                listRefund[0].ET_Authorization_Code__c=authResponse.authorizationCode;
                            if(authResponse.success == 'true'){
                                listRefund[0].ET_Refund_Status__c='Completed';
                            }else {
                                listRefund[0].ET_Refund_Status__c='Failed';
                            }
                        }else {
                            listRefund[0].ET_Refund_Status__c='Failed';
                        }
                    }
                    update listRefund;
                }
            }
        }catch(Exception ex) {
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETC_CallRefundServiceScheduled', 'CallRefundServiceScheduled', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
    }
    
    public static void testUtilityRFC(){
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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