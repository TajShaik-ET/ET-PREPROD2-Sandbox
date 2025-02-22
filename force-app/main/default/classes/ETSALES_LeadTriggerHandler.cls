/******************************************************************************************************************************

Trigger : LeadAssignmentTrigger
Hanlder : LeadAssignmentTriggerHandler
Description : 

Version 1  : When Creating Lead , if Leads Company Name already Exist as an Account in salesforce , Account owner should be 
the Lead Owner.
company Name is matched with Case Insensitive.


********************************************************************************************************************************/

public class ETSALES_LeadTriggerHandler {
    
    public static void glDetailsUpdation(list<Lead> newLeadList){
        Set<Id> userSet = new Set<Id>();
        
        for(Lead ld : newLeadList){
            userSet.add(ld.OwnerId);
        }
        system.debug('@@###'+userSet);
        List<User_GL_Mapping__c> mappingRecList = [SELECT Id,Name,User__c,GL_Activity__c,GL_Zone_Lookup__c,GL_Department__c,ETSALES_GL_Location__c,GL_Project__c,Sector__c,
                                                   GL_Activity__r.Name,GL_Department__r.Name,ETSALES_GL_Location__r.Name,ETSALES_GL_Location__r.GL_Zone__c,
                                                   ETSALES_GL_Location__r.GL_Region__c,GL_Project__r.Name 
                                                   FROM User_GL_Mapping__c WHERE User__c IN: userSet];
         system.debug('@@###'+mappingRecList);
         for(Lead ld : newLeadList){
            for(User_GL_Mapping__c glmap : mappingRecList){
                if(ld.OwnerId == glmap.User__c){
                 system.debug('@@###'+glmap.GL_Zone_Lookup__c);
                 system.debug('@@###'+glmap.ETSALES_GL_Location__c);
                 system.debug('@@###'+glmap.GL_Project__c);
                 
                    ld.GL_Activity_Lookup__c =glmap.GL_Activity__c;
                    ld.GL_Department_Lookup__c = glmap.GL_Department__c;
                    ld.GL_Location_Lookup__c = glmap.ETSALES_GL_Location__c;
                    ld.GL_Project_Code_Lookup__c = glmap.GL_Project__c;
                    ld.GL_Zone_Lookup__c = glmap.GL_Zone_Lookup__c;
                    ld.GL_ETSALESRegion__c = glmap.ETSALES_GL_Location__r.GL_Region__c;
                    ld.Sector__c = glmap.Sector__c;
                }
            }
            
        }
    }

   /*public static void updateWebToLeadRecordType(list<Lead> newLeadList){
        for(Lead ld : newLeadList){
            if(ld.Service_Required__c == 'Service center' || ld.Service_Required__c == 'Body shop service'){
                ld.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ETSALES_Luxury_Vehicles_Maintenance_unit').getRecordTypeId();
            }else if(ld.Service_Required__c == 'Showroom service'){
                ld.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ETSALES_Automotive_Dealership').getRecordTypeId();
            }
        }
    }*/
    
     @InvocableMethod
    public static void webtoLeadUpdationFinal(list<Id> weblist2){
     system.debug('#########'+weblist2);
        WebtoLeadMatrix__mdt [] threatMappings = [SELECT DeveloperName, Lead_Owner_User__c, Lead_Record_Type__c, Location__c ,Request_Category__c 
        FROM WebtoLeadMatrix__mdt];
            Map<String,WebtoLeadMatrix__mdt> mapwebtoLead= new Map<String,WebtoLeadMatrix__mdt>();
     
         for (WebtoLeadMatrix__mdt threatMapping : threatMappings) {
             mapwebtoLead.put(threatMapping.DeveloperName,threatMapping);
        }
        list<Lead> LeadListfinal=new List<Lead>();
        WebtoLeadMatrix__mdt wmetadata= new WebtoLeadMatrix__mdt(); 
        for(Lead lds: [Select id,Request_Category__c,Preferred_Location__c,ownerId from Lead where id in:weblist2]){
        if(lds.Request_Category__c!=null && lds.Preferred_Location__c!=null){
        String preferredStr=lds.Preferred_Location__c.replaceAll( '\\s+', '');
        String requestcatg=lds.Request_Category__c.replaceAll( '\\s+', '');
          if(requestcatg=='MaintenanceandTechnicalservices' && preferredStr.length()>9){
          preferredStr=preferredStr.substring(0, 9);
          }
         system.debug('@@@@3--->'+(requestcatg+preferredStr));
       
        if(mapwebtoLead.containskey(requestcatg+preferredStr)){
         system.debug('@@@@--->'+lds);
         wmetadata=mapwebtoLead.get(requestcatg+preferredStr);
         lds.RecordTypeId= Schema.SObjectType.Lead.getRecordTypeInfosByName().get(wmetadata.Lead_Record_Type__c).getRecordTypeId();
         lds.OwnerId=wmetadata.Lead_Owner_User__c;
         }
         LeadListfinal.add(lds);
         }
         if(LeadListfinal.size()>0)upsert LeadListfinal;
        }
    }
    
    public static void glDetailsUpdation1(list<Lead> newLeadList){
        Set<Id> userSet = new Set<Id>();
        
        
        for(Lead ld : newLeadList){
            userSet.add(ld.OwnerId);
        }
        List<User_GL_Mapping__c> mappingRecList = [SELECT Id,Name,User__c,GL_Activity__c,GL_Department__c,ETSALES_GL_Location__c,GL_Project__c,Sector__c,
                                                   GL_Activity__r.Name,GL_Department__r.Name,ETSALES_GL_Location__r.Name,ETSALES_GL_Location__r.GL_Zone__c,
                                                   ETSALES_GL_Location__r.GL_Region__c,GL_Project__r.Name 
                                                   FROM User_GL_Mapping__c WHERE User__c IN: userSet];
        
        for(Lead ld : newLeadList){
            for(User_GL_Mapping__c glmap : mappingRecList){
                if(ld.OwnerId == glmap.User__c){
                    ld.GL_Activity__c =glmap.GL_Activity__r.Name;
                    ld.GL_Department__c = glmap.GL_Department__r.Name;
                    ld.GL_Location__c = glmap.ETSALES_GL_Location__r.Name;
                    ld.GL_Project_Code__c = glmap.GL_Project__r.Name;
                    ld.GL_Zone__c = glmap.ETSALES_GL_Location__r.GL_Zone__c;
                    ld.GL_ETSALESRegion__c = glmap.ETSALES_GL_Location__r.GL_Region__c;
                    ld.Sector__c = glmap.Sector__c;
                }
            }
            
        }
    }
    
  /**
   * Author: Janardhan Muddana
   * CreatedDate:12/07/2022
   * Method Name: updateVehicleInfo
   * Desc: This method is used to update Vehicle Model/Brand lkup from Vehicle Model/brand picklist in Whatsapp,social media..etc
   * */
    public static void updateVehicleInfo(list<lead> trgNew){
        
        Map<String,Id> vehBrandNameVsID = new Map<String,Id>();
        Map<String,Id> campCodeVsId = new Map<String,Id>();
        Map<string,Map<String,Id>>  VehBrandNameVs_VehModelNameVsVehModId = new Map<string,Map<String,Id>>();
        
        for(Vehicle_Brand_Master__c vb  : [Select id,name,(select id,name from Vehicle_Model__r) from Vehicle_Brand_Master__c]){
            
            vehBrandNameVsID.put(vb.Name,vb.Id);
            Map<String,Id> tempMap = new Map<String,Id>();
            for(Vehicle_Model_Master__c vm : vb.Vehicle_Model__r){
                tempMap.put(vm.Name,vm.Id);
            }            
           VehBrandNameVs_VehModelNameVsVehModId.put(vb.Name, tempMap);
        }
        for(Campaign ca : [select Id,Name,Campaign_Code__c from Campaign where isactive = true]){
            campCodeVsId.put(ca.Name,ca.Id);
        }
        

        for(lead le : trgNew){
            
            if(le.Mobile_Number__c != null){
               le.MobilePhone = '0'+le.Mobile_Number__c.right(9); //CTI calling format
            }
            if(le.Vehicle_Brand_Pick__c != null ){ 
                if(vehBrandNameVsID.containskey(le.Vehicle_Brand_Pick__c))
                le.Vehicle_Brand__c = vehBrandNameVsID.get(le.Vehicle_Brand_Pick__c);
                le.Moto_Vehicle_Model__c = VehBrandNameVs_VehModelNameVsVehModId.get(le.Vehicle_Brand_Pick__c).get(le.Vehicle_Model_Pick__c);
            }
            if(le.Emirates_Moto_Campaign__c != null){
                if(campCodeVsId.containskey(le.Emirates_Moto_Campaign__c))
                le.Campaign__c = campCodeVsId.get(le.Emirates_Moto_Campaign__c);
            }
        }
        
    }
    
    
}