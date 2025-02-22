/**
 * Author: Janardhan Muddana
 * Date: 10/08/22
 * Desc:
 * */
public class ET_TrafficFineTrgHandler {
    
    public static void updateAssignedVehicle(list<Traffic_Fine__c> trgNew){
        
        set<Id> vehIds = new set<id>();
        map<Id,List<SALine_Assigned_Vehicle__c>> accIdVsAssingedVeh = new map<Id,List<SALine_Assigned_Vehicle__c>>();
        
        for(Traffic_Fine__c tf : trgNew){
            vehIds.add(tf.Vehicle_Master__c);                      
        }
        for(SALine_Assigned_Vehicle__c sav : [select id,Name,Assign_Start_Date__c,Assign_End_Date__c,ET_Vehicle__c,Account__c from SALine_Assigned_Vehicle__c where ET_Vehicle__c=:vehIds]){
            
            if(!accIdVsAssingedVeh.containsKey(sav.Account__c)) {
                accIdVsAssingedVeh.put(sav.Account__c, new List<SALine_Assigned_Vehicle__c>());
            }
            accIdVsAssingedVeh.get(sav.Account__c).add(sav);
            
        }
        for(Traffic_Fine__c tf : trgNew){
            
            if(accIdVsAssingedVeh.containsKey(tf.Account__c)){
                
                for(SALine_Assigned_Vehicle__c av : accIdVsAssingedVeh.get(tf.Account__c)){
                    if(av.Assign_End_Date__c != null && av.Assign_Start_Date__c !=null){
                        if(tf.Vehicle_Master__c == av.ET_Vehicle__c && tf.Ticket_Date__c <= av.Assign_End_Date__c.date() && tf.Ticket_Date__c>=av.Assign_Start_Date__c.date()){
                            tf.Assigned_Vehicle__c= av.Id;
                        }
                    }                    
                }
            }
            
        }
        
               
    }

}