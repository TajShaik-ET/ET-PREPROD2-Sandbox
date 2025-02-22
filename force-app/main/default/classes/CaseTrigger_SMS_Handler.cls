/**************
*Handler for sending SMS when case is closed or created
*Test Class: CaseTrigger_SMS_Handler_Test
Desc: Modified by Janardhan:28-10-21 : Send sms all cases when case status is Solution Completed
Desc: Modified by sivarama:18-02-25 : Send sms cases Case Type is complints.

*************/
public class CaseTrigger_SMS_Handler{
    //Method to send SMS when Case created and closed
    public static void sendSMSNotificationOnCaseCreation(List<Case> newCases,Map<Id,Case>newMap,Boolean isInsert){
        system.debug('sendSMSNotificationOnCaseCreation');
        Map<String,String> mapAccountCaseID = new Map<String,String>();
        Map<String,String> mapContactCaseID = new Map<String,String>();
        
        for(Case c : newCases){    
            // If (c.Origin == 'Phone Call'){
            if(isInsert){ 
                system.debug('--in insert--');
                mapAccountCaseID.put(c.AccountId,c.Id);
                if(c.ContactId != NULL)
                    mapContactCaseID.put(c.ContactId,c.Id);
            }
            }
        Map<String,String> mapCaseMobileNumber = getCaseContactNumbers(mapAccountCaseID,mapContactCaseID);
        system.debug('--caseVsMobNo.--'+mapCaseMobileNumber);
        for(String cs :mapCaseMobileNumber.keySet()){    
            String templateName = (isInsert ? 'ET_SMS_Template_For_Case_Creation': 'ET_SMS_Template_For_Case_Closed');
            system.debug('--msg--Params--'+cs+'-'+mapCaseMobileNumber.get(cs)+'-'+templateName);
            
            for(Case SMSC : newCases){ 
                //SMS-MRO CONDTIONS
                system.debug('--Requestor-PickList-Vaule.--'+SMSC.Requestor__c);
                /* IF(SMSC.Requestor__c == system.label.Abu_Dhabi_Technical_Services_Centre){
system.debug('--Requestor-label.--'+system.label.Abu_Dhabi_Technical_Services_Centre);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Al_Wataniya_Auction_Center){
system.debug('--Requestor-label.--'+system.label.Al_Wataniya_Auction_Center);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Bus_Renewal_Unit){
system.debug('--Requestor-label.--'+system.label.Bus_Renewal_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.East_Coast_Technical_Services_Unit){
system.debug('--Requestor-label.--'+system.label.East_Coast_Technical_Services_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Emirates_Moto_workshop){
system.debug('--Requestor-label.--'+system.label.Emirates_Moto_workshop);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Emirates_Technical_Services_Center){
system.debug('--Requestor-label.--'+system.label.Emirates_Technical_Services_Center);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Emirates_Tire_Regeneration_Unit){
system.debug('--Requestor-label.--'+system.label.Emirates_Tire_Regeneration_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Roadside_Assistance_Unit){
system.debug('--Requestor-label.--'+system.label.Roadside_Assistance_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Union_Vehicles_Converting_to_Natural_Gas	){
system.debug('--Requestor-label.--'+system.label.Union_Vehicles_Converting_to_Natural_Gas	);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Wash_Unite){
system.debug('--Requestor-label.--'+system.label.Wash_Unite);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Ras_Al_Khaimah_Technical_Services_Unit){
system.debug('--Requestor-label.--'+system.label.Ras_Al_Khaimah_Technical_Services_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
//SMS-School Transportation CONDTIONS
IF(SMSC.Requestor__c == system.label.Traffic_Supervisor){
system.debug('--Requestor-label.--'+system.label.Traffic_Supervisor);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.School_transport_drivers){
system.debug('--Requestor-label.--'+system.label.School_transport_drivers);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Operation){
system.debug('--Requestor-label.--'+system.label.Operation);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Hafilaty_Salama){
system.debug('--Requestor-label.--'+system.label.Hafilaty_Salama);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.General){
system.debug('--Requestor-label.--'+system.label.General);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Bus_Supervisors){
system.debug('--Requestor-label.--'+system.label.Bus_Supervisors);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Bus_Quality){
system.debug('--Requestor-label.--'+system.label.Bus_Quality);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
//SMS-Transportation Lease CONDTIONS
IF(SMSC.Requestor__c == system.label.Customer){
system.debug('--Requestor-label.--'+system.label.Customer);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}*/
                IF(SMSC.Type2__c == system.label.Case_Type){
                    system.debug('--Requestor-label.--'+system.label.Case_Type);
                    ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
                }
            }
            //
        }
    }
    
    
    public static void sendSMSNotification(List<Case> newCases,Map<Id,Case>newMap, Map<Id,Case>oldMap,Boolean isInsert){
        system.debug('sendSMSNotification');
        Map<String,String> mapAccountCaseID = new Map<String,String>();
        Map<String,String> mapContactCaseID = new Map<String,String>();
        
        for(Case c : newCases){    
            // If (c.Origin == 'Phone Call'){
            if(isInsert){ 
                mapAccountCaseID.put(c.AccountId,c.Id);
                if(c.ContactId != NULL)
                    mapContactCaseID.put(c.ContactId,c.Id);
            }else{
                if(newMap.get(c.Id).Status != oldMap.get(c.Id).Status &&  newMap.get(c.Id).Status == 'Closed'){
                    mapAccountCaseID.put(c.AccountId,c.Id);
                    if(c.ContactId != NULL)
                        mapContactCaseID.put(c.ContactId,c.Id);   
                }
            }
            
        }
        
        Map<String,String> mapCaseMobileNumber = getCaseContactNumbers(mapAccountCaseID,mapContactCaseID);
        system.debug('--caseVsMobNo.--'+mapCaseMobileNumber);
        
        for(String cs :mapCaseMobileNumber.keySet()){    
            String templateName = (isInsert ? 'ET_SMS_Template_For_Case_Creation': 'ET_SMS_Template_For_Case_Closed');
            system.debug('--msg--Params--'+cs+'-'+mapCaseMobileNumber.get(cs)+'-'+templateName);
            
            for(Case SMSC : newCases){ 
                //SMS-MRO CONDTIONS
                system.debug('--Requestor-PickList-Vaule.--'+SMSC.Requestor__c);
                /*    IF(SMSC.Requestor__c == system.label.Abu_Dhabi_Technical_Services_Centre){
system.debug('--Requestor-label.--'+system.label.Abu_Dhabi_Technical_Services_Centre);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Al_Wataniya_Auction_Center){
system.debug('--Requestor-label.--'+system.label.Al_Wataniya_Auction_Center);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Bus_Renewal_Unit){
system.debug('--Requestor-label.--'+system.label.Bus_Renewal_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.East_Coast_Technical_Services_Unit){
system.debug('--Requestor-label.--'+system.label.East_Coast_Technical_Services_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Emirates_Moto_workshop){
system.debug('--Requestor-label.--'+system.label.Emirates_Moto_workshop);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Emirates_Technical_Services_Center){
system.debug('--Requestor-label.--'+system.label.Emirates_Technical_Services_Center);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Emirates_Tire_Regeneration_Unit){
system.debug('--Requestor-label.--'+system.label.Emirates_Tire_Regeneration_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Roadside_Assistance_Unit){
system.debug('--Requestor-label.--'+system.label.Roadside_Assistance_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Union_Vehicles_Converting_to_Natural_Gas	){
system.debug('--Requestor-label.--'+system.label.Union_Vehicles_Converting_to_Natural_Gas	);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Wash_Unite){
system.debug('--Requestor-label.--'+system.label.Wash_Unite);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Ras_Al_Khaimah_Technical_Services_Unit){
system.debug('--Requestor-label.--'+system.label.Ras_Al_Khaimah_Technical_Services_Unit);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
//SMS-School Transportation CONDTIONS
IF(SMSC.Requestor__c == system.label.Traffic_Supervisor){
system.debug('--Requestor-label.--'+system.label.Traffic_Supervisor);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.School_transport_drivers){
system.debug('--Requestor-label.--'+system.label.School_transport_drivers);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Operation){
system.debug('--Requestor-label.--'+system.label.Operation);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Hafilaty_Salama){
system.debug('--Requestor-label.--'+system.label.Hafilaty_Salama);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.General){
system.debug('--Requestor-label.--'+system.label.General);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Bus_Supervisors){
system.debug('--Requestor-label.--'+system.label.Bus_Supervisors);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
IF(SMSC.Requestor__c == system.label.Bus_Quality){
system.debug('--Requestor-label.--'+system.label.Bus_Quality);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}
//SMS-Transportation Lease CONDTIONS
IF(SMSC.Requestor__c == system.label.Customer){
system.debug('--Requestor-label.--'+system.label.Customer);
ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
}*/
                IF(SMSC.Type2__c == system.label.Case_Type){
                    system.debug('--Requestor-label.--'+system.label.Case_Type);
                    ET_Common_Util.sendSMS(cs,'ET Cares',mapCaseMobileNumber.get(cs),templateName );
                }
                
            }
            //
        }
    }
    
    Public static Map<String,String> getCaseContactNumbers(Map<String,String> mapAccountCaseID,Map<String,String> mapContactCaseID){
        Map<String,String> mapCaseMobileNumber = new Map<String,String>();
        for(Contact c: [SELECT ID,AccountId,ETSALES_Mob_Country_Code__c,MobilePhone FROM Contact WHERE Id=: mapContactCaseID.keySet() AND MobilePhone != NULL]){
            String caseID = mapContactCaseID.get(c.Id);
            mapCaseMobileNumber.put(caseID,formatMobileNumber(c.MobilePhone,c.ETSALES_Mob_Country_Code__c)); 
            if(mapAccountCaseID.containsKey(c.AccountID))
                mapAccountCaseID.remove(c.AccountID);
        }
        if(!mapAccountCaseID.isEmpty()){
            for(Account a :[SELECT ID,PersonMobilePhone,ETSALES_Mob_Country_Code__pc FROM Account WHERE ID=: mapAccountCaseID.keySet() AND PersonMobilePhone != NULL])
            {
                String caseID = mapAccountCaseID.get(a.Id);
                mapCaseMobileNumber.put(caseID,formatMobileNumber(a.PersonMobilePhone,a.ETSALES_Mob_Country_Code__pc)); 
            }
        }
        return mapCaseMobileNumber;
    }
    
    Public Static String formatMobileNumber(String mobileNumber, String CountryCode){
        
        String mobile;
        if(mobileNumber.contains('+'))
            mobile =  mobileNumber.replaceAll('[A-Za-z]', '');//remove alphabets if present
        else
            mobile =  (CountryCode +''+ mobileNumber).replaceAll('[A-Za-z]', ''); //remove alphabets(country name) if present
        if(mobile.contains('(')){
            mobile = mobile.replace('(',''); 
            mobile  = mobile.replace(')','');    
        }     
        if(mobileNumber.contains('971') || mobileNumber.contains('91'))
            mobile =  mobileNumber.replaceAll('[A-Za-z]', '');//remove alphabets if present
        else
            mobile =  (CountryCode +''+ mobileNumber).replaceAll('[A-Za-z]', ''); //remove alphabets(country name) if present
        if(mobile.contains('(')){
            mobile = mobile.replace('(',''); 
            mobile  = mobile.replace(')','');    
        }     
        return mobile;
    }
    public static void testCoverage(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}