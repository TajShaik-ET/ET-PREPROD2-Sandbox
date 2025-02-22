trigger ETSALES_UserTrigger on User (after insert, after update) {
    
    if(trigger.isAfter){
        
        if(trigger.isInsert){
            List<User> userList=[SELECT Id, FirstName, LastName,GL_Activity_Code__c,GL_Department_Code__c,GL_Location_Code__c,GL_Project_Code__c,
                          Profile.UserLicense.Name FROM User where Id In: trigger.NewMap.keySet()];
            Set<Id> userIdSet = new Set<Id>();
            for(User uItem : userList){
                if(uItem.Profile.UserLicense.Name == 'Salesforce'){
                    userIdSet.add(uItem.Id);
                }
            }
            if(!userIdSet.isEmpty()){
                ETSALES_User_Trigger_Handler.userMappingInsert(userIdSet);
            }
            
        }if(trigger.isUpdate){
            List<User> newGLUpdateList = new List<User>();

            
            for(User uItem : trigger.New){
                if(uItem.GL_Activity_Code__c != trigger.OldMap.get(uItem.Id).GL_Activity_Code__c || uItem.GL_Department_Code__c != trigger.OldMap.get(uItem.Id).GL_Department_Code__c || uItem.GL_Location_Code__c != trigger.OldMap.get(uItem.Id).GL_Location_Code__c || uItem.GL_Project_Code__c != trigger.OldMap.get(uItem.Id).GL_Project_Code__c){
                    newGLUpdateList.add(uItem);
                }
            }
            if(!newGLUpdateList.isEmpty()){
                system.debug('-------->Activity Update');
                ETSALES_User_Trigger_Handler.userActivityCodeUpdate(newGLUpdateList,trigger.OldMap);
                ETSALES_User_Trigger_Handler.userDeptCodeUpdate(newGLUpdateList,trigger.OldMap);
                ETSALES_User_Trigger_Handler.userLocactionCodeUpdate(newGLUpdateList,trigger.OldMap);
                ETSALES_User_Trigger_Handler.userProjectCodeUpdate(newGLUpdateList,trigger.OldMap);
            }
        }
        
    }
}