global class ETI_BookingsCancellationBatch implements Database.Batchable<sObject>, Schedulable{  
    
    global String queryString;
    public Set<Id> recordIds = new Set<Id>();
    public List<ETI_Booking__c> lstBookingstoDelete = new List<ETI_Booking__c>();
    public string recordTypeDevelopeName = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId(); 
    public DateTime dt;
    public Integer offset;
    public Datetime local;
    global ETI_BookingsCancellationBatch(set<Id> recIds){
        if(recIds!=null && recIds.size()>0){
            recordIds.addAll(recIds);
        }else {
            dt=Datetime.now().addMinutes(-30);
            offset = UserInfo.getTimezone().getOffset(dt);
            local = dt.addSeconds(offset/1000);
            system.debug('dt>> '+dt+' offset>> '+offset);
            system.debug('local>> '+local);       
            for(ETI_Booking__c bkng:[SELECT Id,Name,Booking_Status__c,Service_Request__c FROM ETI_Booking__c WHERE (Booking_Status__c ='Draft' AND CreatedDate <=:local) OR (Service_Request__r.Payment_Status__c IN ('Not Initiated','Payment Pending') AND Booking_Date__c=YESTERDAY AND Booking_Status__c !='Cancelled')]){
                recordIds.add(bkng.Id);
            }
        }
    }
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        system.debug('recordIds>> '+recordIds);  
        queryString='SELECT Id,Name,Booking_Status__c,Service_Request__c,Cancellation_Reason__c,Is_Auto_Cancelled__c FROM ETI_Booking__c WHERE Id=:recordIds';
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext BC, List<ETI_Booking__c> scope){
        for(ETI_Booking__c booking : scope){
            booking.Booking_Status__c='Cancelled';
            booking.Cancellation_Reason__c=label.ETI_Cancellation_Reason;
            booking.Is_Auto_Cancelled__c=true;
            lstBookingstoDelete.add(booking);
        }
        system.debug('lstBookingstoDelete***'+lstBookingstoDelete.size());
        update lstBookingstoDelete;
    }
    global void finish(Database.BatchableContext BC){
        
    }  
    global void execute(SchedulableContext scon) {
        Database.executeBatch(new ETI_BookingsCancellationBatch(null));
    }
}