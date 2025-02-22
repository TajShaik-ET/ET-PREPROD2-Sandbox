trigger ET_Service_Request_Trigger on ET_Service_Request__c (after insert, before update, after update) {
    switch on Trigger.operationType{
        when BEFORE_UPDATE{
            ETST_Global_Handler.changeCoordinatorLayout(Trigger.newMap, Trigger.oldMap);
        }when AFTER_INSERT{
            ETST_Global_Handler.createInvoiceforServiceReq( json.serialize(Trigger.new));
            ETST_Global_Handler.createKPIOnServiceRequestStatusChange(Trigger.newMap, Trigger.oldMap);
            ETST_Global_Handler.sendRegistrationEmail(Trigger.new);
        }when AFTER_UPDATE{
            ETST_Global_Handler.createKPIOnServiceRequestStatusChange(Trigger.newMap, Trigger.oldMap);
            ETST_Global_Handler.updateInvoiceAmount(Trigger.newMap, Trigger.oldMap);
            ETI_ServiceRequestHandler.srManualShare(Trigger.newMap, Trigger.oldMap);
            ETI_ServiceRequestHandler.createInvoice(Trigger.newMap, Trigger.oldMap);
            ETI_ServiceRequestHandler.updateInvoice(Trigger.newMap, Trigger.oldMap);
            ETISPEA_ServiceRequestHandler.createWorkOrder(Trigger.newMap, Trigger.oldMap);
           
            Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
            Set<Id> vServiceId = new Set<Id>();
            if(recordtypeId!=null){
                for(ET_Service_Request__c vItem : Trigger.new){
                    if(vItem.recordtypeId == recordTypeId && vItem.Payment_Status__c  == 'Payment Success' && Trigger.oldMap.get(vItem.Id).Payment_Status__c!=vItem.Payment_Status__c)
                        vServiceId.add(vItem.Id);
                }
                if(!vServiceId.isEmpty() && !ETI_On_Premise_Payment_Ctrl.isFirstTime){
                    ETI_ServiceRequestHandler.sendData(vServiceId,null,null,null);
                    //Added by Noor
                    //ETI_ServiceRequestHandler.sendEmailNotification(vServiceId);
                }
            }
            /*  if(!System.isBatch()){
				ETST_Global_Handler.sendInvoicetoParent(Trigger.newMap, Trigger.oldMap);
			} */
        }
    }
    
}