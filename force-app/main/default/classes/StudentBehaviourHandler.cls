/*
* Description: Trigger Handler for StudentBehaviourIncidentTypes
* Author:Manisha Gouri T
* Created Date: 15/12/2022
*/
public class StudentBehaviourHandler {
    
/* 
* Method Description: Give Partner User read only access to records
* Created Date: 15/12/2022
*/
      
    public static void StudentBehaviourRecords(List<Student_Behavior_Incidents_Types__c> trgNew){

        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Student_Behavior_Incidents_Types__Share> sbitShareList = new List<Student_Behavior_Incidents_Types__Share>();

        for(Student_Behavior_Incidents_Types__c sb:trgNew){            
            schoolNameSet.add(sb.School__c);
        }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){

            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }

        for(Student_Behavior_Incidents_Types__c sb:trgNew){  
            
          if(schoolNameVsUserList.containskey(sb.School__c)){

            for(user u : schoolNameVsUserList.get(sb.School__c)){

                Student_Behavior_Incidents_Types__Share sbShare=new Student_Behavior_Incidents_Types__Share();
                sbShare.ParentId=sb.Id;
                sbShare.UserOrGroupId=u.Id;
                sbShare.AccessLevel='Read';
                sbShare.RowCause= Schema.Student_Behavior_Incidents_Types__Share.RowCause.Manual;
                sbitShareList.add(sbShare);
            }
           }
      }
        if(!sbitShareList.isEmpty()){
            insert sbitShareList;
        }
    }


public static void UpdateStudentBehaviourRecords(List<Student_Behavior_Incidents_Types__c> trgNew,Map<Id,Student_Behavior_Incidents_Types__c> trgOldMap ){   
    
    
        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Student_Behavior_Incidents_Types__Share> sbitShareList = new List<Student_Behavior_Incidents_Types__Share>();

        for(Student_Behavior_Incidents_Types__c sb:trgNew){   
            
            if (sb.ReShare__c && sb.ReShare__c!=trgOldMap.get(sb.id).ReShare__c)
            {
                schoolNameSet.add(sb.School__c);
            }
        }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){

            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }

        for(Student_Behavior_Incidents_Types__c sb:trgNew){  
            
          if(schoolNameVsUserList.containskey(sb.School__c)){

            for(user u : schoolNameVsUserList.get(sb.School__c)){

                Student_Behavior_Incidents_Types__Share sbShare=new Student_Behavior_Incidents_Types__Share();
                sbShare.ParentId=sb.Id;
                sbShare.UserOrGroupId=u.Id;
                sbShare.AccessLevel='Read';
                sbShare.RowCause= Schema.Student_Behavior_Incidents_Types__Share.RowCause.Manual;
                sbitShareList.add(sbShare);
            }
           }
      }
        
        if(!sbitShareList.isEmpty()){
            insert sbitShareList;
        }
    }

    
}