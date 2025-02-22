global class ETI_DraftBookingDeletionBatch implements Database.Batchable<sObject>, Schedulable{  
    
    global String queryString;
    public Set<Id> recordIds = new Set<Id>();
    public Set<Id> serviceRequesIds = new Set<Id>();
    public Map<Id, Id> serReqIds = new Map<Id, Id>();   
    public Set<Id> sevReqIds = new Set<Id>();
    public List<ET_Service_Request__c> serviceReqDelete = new List<ET_Service_Request__c>();
    public List<ETI_Booking__c> lstBookingstoDelete = new List<ETI_Booking__c>();
    public string recordTypeDevelopeName = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId(); 
    public DateTime dt;
    public Integer offset;
    public Datetime local;
    
    global ETI_DraftBookingDeletionBatch(){
		dt=Datetime.now().addMinutes(+44);
        offset = UserInfo.getTimezone().getOffset(dt);
        local = dt.addSeconds(offset/1000);
        system.debug('dt>> '+dt+' offset>> '+offset);
        system.debug('local>> '+local);
        /*queryString='SELECT Id,Name,Booking_Status__c,Service_Request__c FROM ETI_Booking__c WHERE Booking_Status__c =\'Draft\'';
queryString+=' AND CreatedDate <=:local'; */
        // queryString='SELECT Id,Name,Booking_Status__c,Service_Request__c,ETI_Draft_Status_Date__c,ETI_Draft_Status_in_Mins__c FROM ETI_Booking__c WHERE Booking_Status__c =\'Draft\'';
        // queryString+=' AND ETI_Draft_Status_Date__c = null AND ETI_Draft_Status_in_Mins__c >15 AND Service_Request__r.Payment_Status__c =\'Not Initiated\' AND Service_Request__r.RecordTypeId=:recordTypeDevelopeName';
        
        queryString='SELECT Id,Name,(SELECT Id,Name,Booking_Status__c,CreatedDate,Service_Request__c FROM Bookings__r WHERE CreatedDate <=:local) FROM ET_Service_Request__c WHERE Payment_Status__c =\'Not Initiated\' AND RecordTypeId =:recordTypeDevelopeName AND CreatedDate <=:local';
        system.debug('queryString>> '+queryString);
    }
    
    public ETI_DraftBookingDeletionBatch(set<Id> recordIds){
        recordIds.addAll(recordIds);
        dt=Datetime.now().addMinutes(+44);
        offset = UserInfo.getTimezone().getOffset(dt);
        local = dt.addSeconds(offset/1000);
        system.debug('dt>> '+dt+' offset>> '+offset);
        system.debug('local>> '+local);
        /*queryString='SELECT Id,Name,Booking_Status__c,Service_Request__c FROM ETI_Booking__c WHERE Booking_Status__c =\'Draft\'';
queryString+=' AND CreatedDate <=:local AND Id IN:recordIds'; */
        //  queryString='SELECT Id,Name,Booking_Status__c,Service_Request__c,ETI_Draft_Status_Date__c,ETI_Draft_Status_in_Mins__c FROM ETI_Booking__c WHERE Booking_Status__c =\'Draft\'';
        //   queryString+=' AND ETI_Draft_Status_Date__c = null AND ETI_Draft_Status_in_Mins__c >15 AND Service_Request__r.Payment_Status__c =\'Not Initiated\' AND Service_Request__r.RecordTypeId=:recordTypeDevelopeName AND Service_Request__c:recordIds';
        
        queryString='SELECT Id,Name,(SELECT Id,Name,Booking_Status__c,CreatedDate,Service_Request__c FROM Bookings__r WHERE CreatedDate <=:local) FROM ET_Service_Request__c WHERE Payment_Status__c =\'Not Initiated\' AND RecordTypeId =:recordTypeDevelopeName AND CreatedDate <=:local AND Id IN:recordIds';
        system.debug('queryString>> '+queryString); 
    }   
    
    global Database.QueryLocator start(Database.BatchableContext bc){        
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext BC, List<Sobject> scope){
        Map<Id,List<ETI_Booking__c>> serviceReqBookingMap = new Map<Id,List<ETI_Booking__c>>();
        /*  for(ETI_Booking__c booking : (List<ETI_Booking__c>) scope){
if(booking.Service_Request__c !=null)
serviceRequesIds.add(booking.Service_Request__c);
}
if(!serviceRequesIds.isEmpty()){
List<ETI_Booking__c> lstBookings = [SELECT Id,Name,Booking_Status__c,Service_Request__c,ETI_Draft_Status_Date__c,ETI_Draft_Status_in_Mins__c FROM ETI_Booking__c WHERE Service_Request__c IN:serviceRequesIds];
for(ETI_Booking__c booking : lstBookings){
List<ETI_Booking__c> bookinglst = serrviceReqBookingMap.get(booking.Service_Request__c);
if(bookinglst == null)
bookinglst = new List<ETI_Booking__c>();
bookinglst.add(booking);
serrviceReqBookingMap.put(booking.Service_Request__c, bookinglst);
}
} */
        for(ET_Service_Request__c srvReq : (List<ET_Service_Request__c>) scope){
            if(srvReq.Bookings__r.size()>0){
                serviceReqBookingMap.put(srvReq.Id, srvReq.Bookings__r);
            }
        }
        List<Id> totalServiceReq = new List<Id>();
        system.debug('serviceReqBookingMap***'+serviceReqBookingMap);
        for(Id serReqId : serviceReqBookingMap.keySet()){
            for(ETI_Booking__c booking : serviceReqBookingMap.get(serReqId)){
               // if(booking.Booking_Status__c == 'Draft' && booking.ETI_Draft_Status_in_Mins__c > 15 && booking.ETI_Draft_Status_Date__c == null){
                 if(booking.Booking_Status__c == 'Draft' && booking.CreatedDate <=local){
                   // system.debug('inside if Name***'+booking.name+'**Status***'+booking.Booking_Status__c);
                    if(!lstBookingstoDelete.contains(booking)){
                        lstBookingstoDelete.add(booking);
                        serReqIds.put(serReqId, serReqId);
                    }
                } else {
                  //  system.debug('inside else Name***'+booking.name+'**Status***'+booking.Booking_Status__c);
                    if(!sevReqIds.contains(serReqId)){
                        sevReqIds.add(serReqId);
                    }
                }
            }
        }

        for(id reqId : sevReqIds){
            if(serReqIds.keyset().contains(reqId)){
                serReqIds.remove(reqId);
            }
        }
        for(id reqId : serReqIds.keySet()){
            serviceReqDelete.add(new ET_Service_Request__c(id = reqId));
        }
        system.debug('lstBookingstoDelete***'+lstBookingstoDelete.size());
        system.debug('serviceReqDelete***'+serviceReqDelete.size());     
         delete lstBookingstoDelete;
         delete serviceReqDelete;
    }
    global void finish(Database.BatchableContext BC){
        
    }  
    global void execute(SchedulableContext scon) {
        Database.executeBatch(new ETI_DraftBookingDeletionBatch());
    }
}