trigger ETDI_BookingRequest on ETDI_Booking_Request__c (before insert,before update,after insert,after update,before delete) {    
    
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        Set<String> uniqueTrainer = new Set<String>();
        String Trainer;
        Date RequestedDate; 
        String Depot;
        String Shift;
        String startTime;
        Integer i = 0;
        List<ETDI_Booking_Request__c>  duplicateRecords; 
        // If it's an update, check the old records as well
        
        for (ETDI_Booking_Request__c newRecord : Trigger.new) {
            Trainer = newRecord.Trainer__c;
            RequestedDate = newRecord.Requested_Date__c;
            Depot = newRecord.Depot__c;
            shift = newRecord.Shift__c;
            
            if (Trainer != null) {
                //Prevent if user trying to book a trainer for another location for same day/shift
                duplicateRecords = [SELECT Id, Name,Depot__c 
                                    FROM ETDI_Booking_Request__c 
                                    WHERE Trainer__c = :Trainer AND Requested_Date__c =: RequestedDate AND shift__c = :Shift];
                
                for(ETDI_Booking_Request__c ETDI_BR : Trigger.new){
                    ETDI_Booking_Request__c old_ETDI_BR = trigger.oldMap.get(ETDI_BR.Id);
                    if(duplicateRecords.size()!=0){
                        if(ETDI_BR.Trainer__c !=old_ETDI_BR.Trainer__c || ETDI_BR.Requested_Date__c !=old_ETDI_BR.Requested_Date__c || ETDI_BR.shift__c !=old_ETDI_BR.shift__c){
                            if(ETDI_BR.Shift__c == 'Morning' || ETDI_BR.Shift__c == 'Afternoon'){
                                ETDI_BR.Shift__c.addError('Please Select available Shift .Current Shift is Unavailable to Not allowing the same trainer to be scheduled for same day same Shift');
                            }else{
                                ETDI_BR.Trainer__c.addError('Not allowing the same trainer in another location to be scheduled for another training program on same day');
                            }
                            
                        }
                    }
                    duplicateRecords = [SELECT Id, Name,Depot__c 
                                        FROM ETDI_Booking_Request__c 
                                        WHERE Trainer__c = :Trainer AND Depot__c = :Depot AND Requested_Date__c =: RequestedDate];
                    if(duplicateRecords.size()!=0){
                        if(ETDI_BR.Trainer__c !=old_ETDI_BR.Trainer__c || ETDI_BR.Requested_Date__c !=old_ETDI_BR.Requested_Date__c || ETDI_BR.Depot__c !=old_ETDI_BR.Depot__c){
                            if(ETDI_BR.Depot__c == duplicateRecords[0].Depot__c){
                                ETDI_BR.Depot__c.addError('Please Select available Depot .Not allowing the same trainer to be scheduled for same day same Depot');
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    
    
    //Schedule Records insert
    if (Trigger.isafter && Trigger.isUpdate) {
        
        for (ETDI_Booking_Request__c newRecord : Trigger.new) {
            ETDI_Booking_Request__c oldRecord = trigger.oldMap.get(newRecord.Id);
           
            system.debug('submitted outside if');
            if(newRecord.Trainer__c != null && newRecord.Submitted__c != true && (newRecord.Status__c !='Approved' || newRecord.Status__c !='Rejected')){
                system.debug('submitted inside');
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Automatically submitted for approval.');
                req1.setObjectId(newRecord.Id);
                req1.setSubmitterId(UserInfo.getUserId()); 
                req1.setProcessDefinitionNameOrId('ETDI_Booking_Request_Approval_Process');
                req1.setSkipEntryCriteria(true);
                Approval.ProcessResult result = Approval.process(req1);
              
               // newRecord.Submitted__c = true;
                //ETDI_Booking_Request__c BKR = new ETDI_Booking_Request__c();
               // BKR.Id =newRecord.Id;
               // BKR.Submitted__c=true;
               // update BKR;
            }
            
            if((newRecord.Status__c =='Approved' || newRecord.Status__c =='Rejected') && newRecord.Trainer__c != null && newRecord.Status__c !=oldRecord.Status__c){
                System.debug('newRecordTrainer'+newRecord.Trainer__c);
                List<ETDI_Trainer_Schedules__c> bkngSchedules = new List<ETDI_Trainer_Schedules__c>();
                ETDI_Programs__c program = [SELECT No_of_Days__c FROM ETDI_Programs__c WHERE Id = :newRecord.Program_Name__c];
                Date startDate = newRecord.Requested_Date__c;
                Integer recordCount = 0;
                while (recordCount < program.No_of_Days__c) {
                    // Assuming you have queried the related Program record
                    Date dt = startDate;  
                    DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
                    String dayOfWeek = currDate.format('EEEE');  
                    
                    if (!dayOfWeek.equalsIgnoreCase('Saturday') && !dayOfWeek.equalsIgnoreCase('Sunday')) {
                        ETDI_Trainer_Schedules__c BKS = new ETDI_Trainer_Schedules__c();
                        ETDI_Programs__c programDays = [SELECT No_of_Days__c FROM ETDI_Programs__c WHERE Id = :newRecord.Program_Name__c];
                        BKS.Schedule_Date_Time__c = startDate;
                        BKS.Status__c = 'Booked';
                        BKS.Trainer__c = newRecord.Trainer__c;
                        BKS.Booking_Request__c = newRecord.Id;
                        bkngSchedules.add(BKS);
                        // Increment the record count
                        recordCount++;
                        if(recordCount == program.No_of_Days__c){
                            ETDI_Booking_Request__c BKR = new ETDI_Booking_Request__c();
                            BKR.Id = newRecord.Id;
                            BKR.End_Date_OfProgram__c = startDate;
                            update BKR;
                            system.debug('End_Date_OfProgram__c  '+startDate);
                        }
                    }
                    startDate = startDate.addDays(1);
                }
                insert bkngSchedules;
            }
        }
    }
    
    
    
    
    
    
    
    
}