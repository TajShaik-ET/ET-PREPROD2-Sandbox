public class ETSALES_User_Trigger_Handler {
    

    @future
    public static void userMappingInsert(Set<Id> updateList){
        
        Map< String, GL_Activity__c> activityMap = new Map< String, GL_Activity__c>();
        Map< String, GL_Project__c> projectMap = new Map< String, GL_Project__c>();
        Map< String, ETSALES_Department__c> departmentMap = new Map< String, ETSALES_Department__c>();
        Map< String, ETSALES_Location__c> locationMap = new Map< String, ETSALES_Location__c>();
        
        // GL Activity
        for(GL_Activity__c activityItem : [SELECT Id,GL_Activity_Code__c,Name FROM GL_Activity__c]){
            activityMap.put(activityItem.GL_Activity_Code__c,activityItem);
        }
        // GL Project
        for(GL_Project__c projectItem : [SELECT Id,Project_Code__c,Name FROM GL_Project__c ]){
            projectMap.put(projectItem.Project_Code__c,projectItem);
        }
        // GL Department
        for(ETSALES_Department__c depItem : [SELECT Id,Department_Code__c,Name FROM ETSALES_Department__c]){
            departmentMap.put(depItem.Department_Code__c, depItem);
        }
        // GL Location
        for(ETSALES_Location__c locItem : [SELECT Id,Location_Code__c,Name FROM ETSALES_Location__c]){
            locationMap.put(locItem.Location_Code__c,locItem);
        }
        
        ETSALES_User_Trigger_Handler instance = new ETSALES_User_Trigger_Handler();
        
        List<User_GL_Mapping__c> glCodeList = new List<User_GL_Mapping__c>();
        
        for(User uItem : [SELECT Id, FirstName, LastName,GL_Activity_Code__c,GL_Department_Code__c,GL_Location_Code__c,GL_Project_Code__c,
                          Profile.UserLicense.Name FROM User where Id In:updateList]){
            if(uItem.Profile.UserLicense.Name == 'Salesforce'){
                
            User_GL_Mapping__c glMapping = new User_GL_Mapping__c();
            glMapping.User__c = uItem.Id;
            glMapping.Name = uItem.FirstName+ ' '+uItem.LastName;
            if(activityMap.containsKey(uItem.GL_Activity_Code__c)){
                
                glMapping.GL_Activity__c = activityMap.get(uItem.GL_Activity_Code__c).Id;
                system.debug('Activity Name----->'+activityMap.get(uItem.GL_Activity_Code__c).Name);
            }
            if(departmentMap.containsKey(uItem.GL_Department_Code__c)){
                
                glMapping.GL_Department__c = departmentMap.get(uItem.GL_Department_Code__c).Id;
                system.debug('Department Name----->'+departmentMap.get(uItem.GL_Department_Code__c).Name);
            }
            if(locationMap.containsKey(uItem.GL_Location_Code__c)){
                
                glMapping.ETSALES_GL_Location__c = locationMap.get(uItem.GL_Location_Code__c).Id;
                system.debug('Location Name----->'+locationMap.get(uItem.GL_Location_Code__c).Name);
            }
            if(projectMap.containsKey(uItem.GL_Project_Code__c)){
                
                glMapping.GL_Project__c = projectMap.get(uItem.GL_Project_Code__c).Id;
                system.debug('Project Name----->'+projectMap.get(uItem.GL_Project_Code__c).Name);
            }
            glCodeList.add(glMapping);
                          }
        }
        if(!glCodeList.isEmpty()){
            system.debug('Insertion Of GL Mapping------->'+glCodeList);
            insert glCodeList;
        }
    }
    public static void userActivityCodeUpdate(list<User> updateList, Map<Id,User> oldMap){
        system.debug('Activity Update---->'+updateList);
        List<User_GL_Mapping__c> mappingUpdate = new List<User_GL_Mapping__c>();
        Map< String, GL_Activity__c> activityMap = new Map< String, GL_Activity__c>();
        List<User_GL_Mapping__c> mappingRecList = [SELECT Id,Name,User__c,GL_Activity__c FROM User_GL_Mapping__c WHERE User__c IN: updateList ];
        // GL Activity
        for(GL_Activity__c activityItem : [SELECT Id,GL_Activity_Code__c FROM GL_Activity__c]){
            activityMap.put(activityItem.GL_Activity_Code__c,activityItem);
            
        }
        for(User uItem : updateList){
            if(uItem.GL_Activity_Code__c != OldMap.get(uItem.Id).GL_Activity_Code__c){
                for(User_GL_Mapping__c glMap : mappingRecList){
                    if(uItem.Id == glMap.User__c){
                        glMap.GL_Activity__c = activityMap.get(uItem.GL_Activity_Code__c).Id;
                        system.debug('glMap.GL_Activity__c'+uItem.GL_Activity_Code__c);
                        mappingUpdate.add(glMap);
                    }
                }
            }
            
            system.debug('Update List--------->'+mappingRecList);
            
        }
        if(!mappingUpdate.isEmpty()){
            update mappingUpdate;
        }
    }
    // Department update
    public static void userDeptCodeUpdate(list<User> updateList, Map<Id,User> oldMap){
        List<User_GL_Mapping__c> mappingUpdate = new List<User_GL_Mapping__c>();
        
        Map< String, ETSALES_Department__c> departmentMap = new Map< String, ETSALES_Department__c>();
        for(ETSALES_Department__c depItem : [SELECT Id,Department_Code__c FROM ETSALES_Department__c]){
            departmentMap.put(depItem.Department_Code__c, depItem);
            
        }
        List<User_GL_Mapping__c> mappingRecList = [SELECT Id,Name,User__c,GL_Department__c FROM User_GL_Mapping__c WHERE User__c IN: updateList ];
        
        for(User uItem : updateList){
            if(uItem.GL_Department_Code__c != oldMap.get(uItem.Id).GL_Department_Code__c){
                for(User_GL_Mapping__c glMap : mappingRecList){
                    if(uItem.Id == glMap.User__c){
                        glMap.GL_Department__c = departmentMap.get(uItem.GL_Department_Code__c).Id;
                        system.debug('glMap.GL_Department__c'+uItem.GL_Department_Code__c);
                        mappingUpdate.add(glMap);
                    }
                }
                
            }
            
        }
        if(!mappingUpdate.isEmpty()){
            update mappingUpdate;
        }
    }
    // Location update
    public static void userLocactionCodeUpdate(list<User> updateList,Map<Id,User> oldMap){
        List<User_GL_Mapping__c> mappingUpdate = new List<User_GL_Mapping__c>();
        Map< String, ETSALES_Location__c> locationMap = new Map< String, ETSALES_Location__c>();
        for(ETSALES_Location__c locItem : [SELECT Id,Location_Code__c FROM ETSALES_Location__c]){
            locationMap.put(locItem.Location_Code__c,locItem);
            
        }
        
        List<User_GL_Mapping__c> mappingRecList = [SELECT Id,Name,User__c,ETSALES_GL_Location__c FROM User_GL_Mapping__c WHERE User__c IN: updateList ];
        // GL Department
        for(User uItem : updateList){
            if(uItem.GL_Location_Code__c != OldMap.get(uItem.Id).GL_Location_Code__c){
                for(User_GL_Mapping__c glMap : mappingRecList){
                    if(uItem.Id == glMap.User__c){
                        glMap.ETSALES_GL_Location__c = locationMap.get(uItem.GL_Location_Code__c).Id;
                        system.debug('glMap.ETSALES_GL_Location__cc'+uItem.GL_Location_Code__c);
                        mappingUpdate.add(glMap);
                        
                    }
                }
            }
            
            
        }
        if(!mappingUpdate.isEmpty()){
            update mappingUpdate;
        }
    }
    // Project update
    public static void userProjectCodeUpdate(list<User> updateList, Map<Id,User> oldMap){
        List<User_GL_Mapping__c> mappingUpdate = new List<User_GL_Mapping__c>();
        Map< String, GL_Project__c> projectMap = new Map< String, GL_Project__c>();
        for(GL_Project__c projectItem : [SELECT Id,Project_Code__c,Name FROM GL_Project__c ]){
            projectMap.put(projectItem.Project_Code__c,projectItem);
            
        }
        List<User_GL_Mapping__c> mappingRecList = [SELECT Id,Name,User__c,GL_Project__c FROM User_GL_Mapping__c WHERE User__c IN: updateList ];
        // GL Department
        for(User uItem : updateList){
            if(uItem.GL_Project_Code__c != OldMap.get(uItem.Id).GL_Project_Code__c){
                for(User_GL_Mapping__c glMap : mappingRecList){
                    if(uItem.Id == glMap.User__c){
                        if(projectMap.containsKey(uItem.GL_Project_Code__c)){
                            glMap.GL_Project__c = projectMap.get(uItem.GL_Project_Code__c).Id;
                            system.debug('glMap.GL_Project__c'+uItem.GL_Project_Code__c);
                            mappingUpdate.add(glMap);
                        }
                    }
                }
            }    
        }
        if(!mappingUpdate.isEmpty()){
            update mappingUpdate;
        }
    }
}