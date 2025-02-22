public class CICO_vehicleShipmentsTrgHandler {
    
    public static void updateShipmentDetails(list<CICO_Vehicle_Spec__c> trgNew,map<id,CICO_Vehicle_Spec__c> trgOld){
        
        map<Id,Date> intiLineIdVsShipDate = new  map<Id,Date>();
        map<Id,Date> intiLineIdVsActRecvDate = new  map<Id,Date>();
        map<Id,string> intiLineIdVsSupDocType = new  map<Id,string>();
        map<Id,string> intiLineIdVsSupDocNo = new  map<Id,string>();
        map<Id,Date> intiLineIdVsSupDocDate = new  map<Id,Date>();
        map<Id,string> intiLineIdVsPenality = new  map<Id,string>();
        set<Id> intimationLineIDs = new set<Id>();
        
        list<CICO_Vehicle_Spec__c> shipmentDetailsUpdate = new list<CICO_Vehicle_Spec__c>();
        
        for(CICO_Vehicle_Spec__c cv : trgNew){
            if(cv.Intimation_Line__c != null)
            intimationLineIDs.add(cv.Intimation_Line__c);
            
            if(cv.Shipped_Date__c != null)
            intiLineIdVsShipDate.put(cv.Intimation_Line__c,cv.Shipped_Date__c);
            
            if(cv.Actual_Receive_Date__c != null)
            intiLineIdVsActRecvDate.put(cv.Intimation_Line__c,cv.Actual_Receive_Date__c);
            
             if(cv.Sup_Doc_Type__c != null)
            intiLineIdVsSupDocType.put(cv.Intimation_Line__c,cv.Sup_Doc_Type__c);
            
            if(cv.Sup_Doc_No__c != null)
            intiLineIdVsSupDocNo.put(cv.Intimation_Line__c,cv.Sup_Doc_No__c);
            
            if(cv.Sup_Doc_Date__c != null)
            intiLineIdVsSupDocDate.put(cv.Intimation_Line__c,cv.Sup_Doc_Date__c);
            
            if(cv.Penalty__c != null)
            intiLineIdVsPenality.put(cv.Intimation_Line__c,cv.Penalty__c);
            
        }
        
        for(CICO_Intimation_Line__c lines : [select id, (select id,Intimation_Line__c,Shipped_Date__c,Actual_Receive_Date__c,Sup_Doc_Type__c,Sup_Doc_No__c,Sup_Doc_Date__c,Penalty__c from Vehicle_Spec__r where Inspected__c =false) from CICO_Intimation_Line__c where id=:intimationLineIDs]){
             
            for(CICO_Vehicle_Spec__c cvs : lines.Vehicle_Spec__r){
                
                if(intiLineIdVsShipDate.containsKey(cvs.Intimation_Line__c))
                cvs.Shipped_Date__c = intiLineIdVsShipDate.get(cvs.Intimation_Line__c);
                
                if(intiLineIdVsActRecvDate.containsKey(cvs.Intimation_Line__c))
                cvs.Actual_Receive_Date__c = intiLineIdVsActRecvDate.get(cvs.Intimation_Line__c);
                
                if(intiLineIdVsSupDocType.containsKey(cvs.Intimation_Line__c))
                cvs.Sup_Doc_Type__c = intiLineIdVsSupDocType.get(cvs.Intimation_Line__c);
                
                 if(intiLineIdVsSupDocNo.containsKey(cvs.Intimation_Line__c))
                cvs.Sup_Doc_No__c = intiLineIdVsSupDocNo.get(cvs.Intimation_Line__c);
                
                 if(intiLineIdVsSupDocDate.containsKey(cvs.Intimation_Line__c))
                cvs.Sup_Doc_Date__c = intiLineIdVsSupDocDate.get(cvs.Intimation_Line__c);
                
                 if(intiLineIdVsPenality.containsKey(cvs.Intimation_Line__c))
                cvs.Penalty__c = intiLineIdVsPenality.get(cvs.Intimation_Line__c);
                
                shipmentDetailsUpdate.add(cvs);
            }
            
        }
        
        try{
            update shipmentDetailsUpdate;
            
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        
            
            
    }

}