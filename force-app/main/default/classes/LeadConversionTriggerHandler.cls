public class LeadConversionTriggerHandler {
    public static boolean isTriggerFired = false;
    public static void updateOpportunityCreatedFromLead(List<Lead> leadList, Map<id, lead> oldMap){
        Map<id, Lead> descriptionMap = new Map<id, lead>();
        for(Lead ld : leadList){
            Lead old = oldMap.get(ld.id);
            if (ld.IsConverted == true && old.isConverted == false) {
                descriptionMap.put(ld.ConvertedOpportunityId, ld);
            }
        }
        List<opportunity> oppList = new List<Opportunity>();
        for(Opportunity opp : [SELECT Convertedfromlead__c,Type FROM Opportunity WHERE id IN: descriptionMap.keySet()]){
            opp.Convertedfromlead__c = 'Converted from Lead';
            opp.Type = 'New Business'; //SF Portal work ID: W-00889
            opp.Description = descriptionMap.get(opp.id).Description;
            opp.GL_Activity_Lookup__c = descriptionMap.get(opp.id).GL_Activity_Lookup__c;
            opp.GL_Location_Lookup__c = descriptionMap.get(opp.id).GL_Location_Lookup__c;
            opp.GL_Project_Code_Lookup__c = descriptionMap.get(opp.id).GL_Project_Code_Lookup__c;
            opp.GL_Zone_Lookup__c = descriptionMap.get(opp.id).GL_Zone_Lookup__c;
            opp.GL_Region__c = descriptionMap.get(opp.id).GL_ETSALESRegion__c;
             opp.GL_Department_Lookup__c = descriptionMap.get(opp.id).GL_Department_Lookup__c;
            oppList.add(opp); 
        }
        update oppList;
    }
    
   /* public static void bindTestDriveRecordsToOpp(List<Lead> leadNewList, List<Lead> leadOldList){
       /*Map<Id, Lead> leadMap = new Map<Id,Lead>();
        Lead parent;
        Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Automotive Dealership').getRecordTypeId();
        for (Integer i = 0; i < leadNewList.size(); i++){
            if (Test.isRunningTest() || leadNewList[i].IsConverted == true && leadOldList[i].isConverted == false && leadNewList[i].recordtypeid == devRecordTypeId) {
                leadMap.put( leadNewList[i].Id, leadNewList[i]);
            }
        }
        
        if( leadMap.size() > 0 ) {
            Set<Id> leadIds = leadMap.keySet();
            List<ETM_Vehicle_Test_Drive__c> allChildren =
                [select Id, Opportunity__c, ETM_Lead__c from ETM_Vehicle_Test_Drive__c where ETM_Lead__c in :leadIds];      
            
            System.debug(allChildren);
            
            for ( ETM_Vehicle_Test_Drive__c child : allChildren ) {
                if ( leadMap.containsKey( child.ETM_Lead__c ) ) {
                    parent = leadMap.get( child.ETM_Lead__c );
                    child.opportunity__c = parent.ConvertedOpportunityId;
                }
            }
            
            System.debug(allChildren);
            
            update allChildren;
        }
    }*/
    
    /*public static void createEventonUpdate(List<lead> leadList, Map<id, lead> oldMap){
        List<Event> eventList = new List<Event>();
        for(Lead ld: leadList){
            Lead oldLd = oldMap.get(ld.id);
            if(ld.Appointment_Date__c != null && ld.Appointment_Date__c != oldLd.Appointment_Date__c){
                Datetime endDate = ld.Appointment_Date__c;
                endDate = endDate.addMinutes(90);
                Event evt = new Event(
                    OwnerId = ld.OwnerId,
                    StartDateTime = ld.Appointment_Date__c,
                    EndDateTime = endDate,
                    ActivityDateTime = ld.Appointment_Date__c, //add this line
                    Subject = 'Appoinment'
                    
                ); 
                eventList.add(evt);
            }
        }
        insert eventList;
        
    }
    public static void createEventonInsert(List<lead> leadList){
        List<Event> eventList = new List<Event>();
        for(Lead ld: leadList){
            if(ld.Appointment_Date__c != null ){
                Datetime endDate = ld.Appointment_Date__c;
                endDate = endDate.addMinutes(90);
                Event evt = new Event(
                    OwnerId = ld.OwnerId,
                    StartDateTime = ld.Appointment_Date__c,
                    EndDateTime = endDate,
                    ActivityDateTime = ld.Appointment_Date__c, //add this line
                    Subject = 'Appoinment'
                    
                ); 
                eventList.add(evt);
            }
        }
        insert eventList;
        
    }*/
}