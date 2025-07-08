trigger CaseTrigger on Case (before update,after update,after insert,before insert,before delete) {
    List<Case> csList= new List<Case>();
    List<Case> csEntitlment= new List<Case>();
    List<Case> updateCases= new List<Case>();
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            for (Case c : Trigger.new) {
                Boolean isWeekday = true;
                Integer numberDaysDue=0;
                Date startDate;
                Date endDate;
                if(c.Preferred_Date__c != null && c.Preferred_End_Date__c !=null){
                    startDate  = date.newinstance(c.Preferred_Date__c.year(), c.Preferred_Date__c.month(), c.Preferred_Date__c.day());
                    endDate = date.newinstance(c.Preferred_End_Date__c.year(), c.Preferred_End_Date__c.month(), c.Preferred_End_Date__c.day());
                    numberDaysDue = startDate.daysBetween(endDate)+1;
                }
                if(numberDaysDue != 0){
                    for(Integer i=0; i<numberDaysDue;i++){
                        Date newDate = startDate.addDays(i);
                        Datetime Dt=(DateTime)newDate;
                        String dayOFWeek = Dt.format('EEEE');
                        System.debug('Which day Collect'+dayOFWeek);
                        if(dayOFWeek=='Saturday'|| dayOFWeek=='Sunday'){
                            isWeekday = false;
                            break;
                        }
                    }
                }
                if (isWeekday && (c.RecordType.developername == 'Requests_for_trips_activities_events' || c.Status_Category__c=='Pending with Department Of School Activities')) {
                    c.Status_Category__c = 'Pending with Operation Supervisors';
                    c.Sub_Status__c = 'Approved by Department of School Activities';
                }
            }
            if (system.label.Case_Trigger_Blocker !='TRUE'){
                for(Case cs : Trigger.New){
                    if(cs.origin == 'Web'){
                        cs.Priority = 'Emergency - close within 24 hours' ;
                    }
                    if(cs.Priority=='Emergency - close within 24 hours' || cs.Priority=='Normal - close within 2 working days' 
                       || cs.Priority=='Complicated - close within 11 working days' ){
                           system.debug('Inside before priorty###'+csEntitlment);
                           csEntitlment.add(cs);
                       }
                    system.debug('$$$$$$$$$$'+cs.Origin); 
                }
                // CaseTriggerHandler.validateDuplicateCase(Trigger.New);
                system.debug('Inside before update###'+csList);
            }
            //if(csList.size()>0)CaseTriggerHandler.validatePendingActivies(csList);
            //if(updateCases.size()>0)CaseTriggerHandler.updateMilestones(updateCases);
            if(csEntitlment.size()>0)CaseTriggerHandler.validateEntitlement(csEntitlment);
        }
        if(Trigger.isUpdate){
            if(system.label.Case_Trigger_Blocker !='TRUE'){
                system.debug('Inside before update###');
                for(Case cs : Trigger.New){
                    
                    if(cs.Status=='Closed' && cs.Status != Trigger.oldMap.get(cs.Id).Status){
                        system.debug('Inside before Closed###');
                        
                        if ((cs.SlaStartDate <= system.now())&&(cs.SlaExitDate == null)){
                            system.debug('Inside before Closed2###'+updateCases);
                            
                            updateCases.add(cs);
                        }
                        else{
                            csList.add(cs);
                        }
                    }
                    else if(cs.Priority!=  Trigger.oldMap.get(cs.Id).Priority && cs.Priority=='Emergency - close within 24 hours' || cs.Priority=='Normal - close within 2 working days' 
                            || cs.Priority=='Complicated - close within 11 working days'){
                                system.debug('Inside before priorty###'+csEntitlment);
                                csEntitlment.add(cs);
                            }
                }
                system.debug('Inside before update###'+csList);
                if(csList.size()>0)CaseTriggerHandler.validatePendingActivies(csList);
                if(updateCases.size()>0)CaseTriggerHandler.updateMilestones(updateCases);
                if(csEntitlment.size()>0)CaseTriggerHandler.validateEntitlement(csEntitlment);
            }
        }
        if(Trigger.isDelete){
            CaseTriggerHandler.caseDeleteValidation(trigger.old);
        }
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            /*Added by Sreelakshmi SK - Send email to Account email once the case is created */
            CaseTriggerHandler.SendCaseCreationEmail(Trigger.New);
            
            /*This Tigger Function Work For Send Email As Notification to Ese for User and Manual Case Sharing each deprtment by associate user this  code developed by Akash */
            caseSharingHandler.eseCaseSharing(Trigger.NewMap); 
            sendEmailsToUsers.sendEmailsToESEUsersAfterInsert(trigger.newMap);
            if(system.label.Case_Trigger_Blocker != 'TRUE'){
                CaseTrigger_SMS_Handler.sendSMSNotificationOnCaseCreation(trigger.new,trigger.newMap,true);
                system.debug('after insert--sendSMSNotificationOnCaseCreation');
                system.debug('inside after insert');
            }
        }
        if(Trigger.isUpdate){
            /*Added by Sreelakshmi SK - Send email to Account email once the case is closed */
            CaseTriggerHandler.SendClosedCaseEmail(Trigger.New,Trigger.OldMap);
            CaseTriggerHandler.SendFeedbackEmail(Trigger.New,Trigger.OldMap); 
            
            /*Added by Janardhan - Send sms on case status -Solution Completed */
            CaseTrigger_SMS_Handler.sendSMSNotification(trigger.new,trigger.newMap,trigger.oldMap,false);
            system.debug('CaseTrigger_SMS_Handler in trigger');  
            
            /*This Tigger Function Work For Manual Case Sharing each deprtment by associate user this code developed by Akash */
            caseSharingHandler.eseCaseSharingAfterUpdateCase(trigger.oldMap,trigger.newMap);    
            
            /*This Tigger Function Work For Send Email As Notification to Ese for User and Manual Case Sharing each deprtment by associate user this  code developed by Akash */
            sendEmailsToUsers.sendEmailsToESEUsersAfterUpdate(trigger.oldMap,trigger.newMap);
            sendEmailsToUsers.handleAfterUpdate(Trigger.new, Trigger.oldMap);
            if(system.label.Case_Trigger_Blocker !='TRUE'){
                if(CaseTriggerHandler.isFirstTime){
                    CaseTriggerHandler.isFirstTime = false;
                    CaseTriggerHandler.updateCaseManagerEmailfromQueue(trigger.newMap);
                    // CaseTriggerHandler.caliculateNoOfDays(trigger.new);
                    List<Case> updateArkaniCloseCaseList = new List<Case>();
                    for(Case cs:Trigger.New)
                    {
                        Case oldcase = System.Trigger.oldMap.get(cs.id);
                        String newcaseStatus = cs.Status;
                        if(cs.Arkani_Incident_ID__c!=null || cs.Arkani_Incident_ID__c!='')
                        {
                            if((oldcase.Status!= cs.Status) || (oldcase.SiteVisitTimestamp__c!=cs.SiteVisitTimestamp__c) || (oldcase.Solution_Completed_Date__c!=cs.Solution_Completed_Date__c))
                            {
                                //CloseCaseInArkani.updateArkaniIdUponCaseClosure(cs.id);
                                CloseCaseInArkani.updateArkaniIdUponCase(cs.id);
                            }
                        }
                    }
                    if(updateArkaniCloseCaseList.size()>0)
                    {
                        update updateArkaniCloseCaseList;
                    }
                }
            }
        }
        if(Trigger.isDelete){
        }
    }
}