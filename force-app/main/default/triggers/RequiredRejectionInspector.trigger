trigger RequiredRejectionInspector on ETT_Fleet_Analysis_Request__c (before update,after update) {
    
    if(Trigger.isBefore)
    {
        Map<Id, ETT_Fleet_Analysis_Request__c> inspectorDateTimeNotProvidedMap  = new Map<Id, ETT_Fleet_Analysis_Request__c>{};
        Map<Id, ETT_Fleet_Analysis_Request__c> rejectReasonApprovalProcessMap  = new Map<Id, ETT_Fleet_Analysis_Request__c>{};
            
         for(ETT_Fleet_Analysis_Request__c newFleet: trigger.new)   
        {
            System.debug('newFleet = '+newFleet);
              System.debug('newFleet.Status__c ='+newFleet.Status__c+'End');
            ETT_Fleet_Analysis_Request__c oldFleet = System.Trigger.oldMap.get(newFleet.Id);
            
            if (oldFleet.Status__c != 'Approved  By HOO' && newFleet.Status__c == 'Approved  By HOO')    
            {  System.debug('inside pendign inspector');
                if(newFleet.Inspection_DateTime__c==null||newFleet.ETT_Inspector__c==null)
                {
                    System.debug('date or inspector null');
                    inspectorDateTimeNotProvidedMap.put(newFleet.Id, newFleet);  
                    
                }
                
            }
            
            if (newFleet.Approval_Status_Check__c == 'Requested')    
            {   
                rejectReasonApprovalProcessMap.put(newFleet.id,newFleet);
                newFleet.Approval_Status_Check__c = null;
                
            }
        }
          System.debug('befire inspector not provied');
        if (!inspectorDateTimeNotProvidedMap.isEmpty())  
        {
            System.debug('inside inspector not provied');
            List<Id> processInstanceIds = new List<Id>{};
                
                for (ETT_Fleet_Analysis_Request__c fleet : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1)
                                                            FROM ETT_Fleet_Analysis_Request__c WHERE ID IN :inspectorDateTimeNotProvidedMap.keySet()])
            {
                if(fleet.ProcessInstances.Size()>0)
                {
                     processInstanceIds.add(fleet.ProcessInstances[0].Id);
                }
               
            }
            
            for (ProcessInstance pi : [SELECT TargetObjectId,(SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1 ) FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC])   
            {                   

                    inspectorDateTimeNotProvidedMap.get(pi.TargetObjectId).addError(
                        'Operation Cancelled: Please provide Inspector and Inspection Date Time in Fleet Analysis Request!');

            }  
        }
        
        if (!rejectReasonApprovalProcessMap.isEmpty())  
        {
            List<Id> processInstanceIds = new List<Id>{};
             System.debug('before query');   
                for (ETT_Fleet_Analysis_Request__c fleet : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1)
                                                            FROM ETT_Fleet_Analysis_Request__c WHERE ID IN :rejectReasonApprovalProcessMap.keySet()])
            {
                 //System.debug('after  query fller process instance='+fleet.ProcessInstances[0].Id); 
                if(fleet.ProcessInstances.Size()>0)
                {
                     processInstanceIds.add(fleet.ProcessInstances[0].Id);
                }
               
            }
            System.debug('bnegore query 1 ');
            for (ProcessInstance pi : [SELECT TargetObjectId,(SELECT Id, StepStatus, Comments FROM Steps ORDER BY CreatedDate DESC LIMIT 1) FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC])   
            {  
                System.debug('after query 2 3');
                if(pi.steps.size() >0){
                    for(integer i=0;i<pi.steps.size();i++){
                       // if(pi.steps[i].comments !=null){
                          System.debug('pi.steps[i].comments = '+pi.steps[i].comments);
                       // }
                    }   
                }   
                
                System.debug('pi.Steps[0].Comments = '+pi.Steps[0].Comments);
               //  System.debug('pi.Steps[1].Comments = '+pi.Steps[1].Comments);
               // System.debug('pi.Steps[2].Comments = '+pi.Steps[2].Comments);
              //  System.debug('pi.Steps[1].Comments = '+pi.Steps[1].Comments);
                if ((pi.Steps[0].Comments == null || 
                     pi.Steps[0].Comments.trim().length() == 0))
                {
                     System.debug('pi.Steps[0].Comments  inside= '+pi.Steps[0].Comments);
                    rejectReasonApprovalProcessMap.get(pi.TargetObjectId).addError(
                        'Operation Cancelled: Please provide Rejection Reason!');
                    
                }
                

            }  
        }
    }
    if(Trigger.isAfter)
    {
         List<ETT_Fleet_Analysis_Request__c>  FleetInspectorStatusUpdateList  = new List<ETT_Fleet_Analysis_Request__c>();
            
         for(ETT_Fleet_Analysis_Request__c newFleet: trigger.new)   
         {
          ETT_Fleet_Analysis_Request__c oldFleet = System.Trigger.oldMap.get(newFleet.Id);
           
            if (oldFleet.ETT_Inspector__c != newFleet.ETT_Inspector__c  && newFleet.ETT_Inspector__c != Null )    
            { 
                ETT_Fleet_Analysis_Request__c InspectorStatusObj = [Select id,Inspector_Status__c from ETT_Fleet_Analysis_Request__c where id=:newFleet.id];
                InspectorStatusObj.Inspector_Status__c = 'Scheduled';
                FleetInspectorStatusUpdateList.add(InspectorStatusObj);
                
            } 
        
             
         }
        if(FleetInspectorStatusUpdateList.Size()>0){
            update FleetInspectorStatusUpdateList;
        }
    }
    
    
    
}