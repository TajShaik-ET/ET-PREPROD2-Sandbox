/*
* Description: Trigger Handler for StudentAttendenceTrigger
* Author:Sreelakshmi SK
* Created Date: 14/12/2022
*/

public class StudentAttendenceHandler {    
    /* 
* Method Descriotion: Give account portal user read only access to corresponding student attendence
* Author:Sreelakshmi SK
* Created Date: 14/12/2022
*/
    public static void NewStudentAttendence(List<Students_Attendence__c> trgNew){
        
        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Students_Attendence__Share> stuAttShareList = new List<Students_Attendence__Share>();
        
        for(Students_Attendence__c att:trgNew){            
            schoolNameSet.add(att.School_Name__c);
        }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){
            
            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            //System.debug('User: '+ u);
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }
      
        for(Students_Attendence__c att:trgNew){      
            
            if(schoolNameVsUserList.containskey(att.School_Name__c)){
                for(user u : schoolNameVsUserList.get(att.School_Name__c)){
                    //System.debug('User: '+ u);
                    Students_Attendence__Share attShare=new Students_Attendence__Share();
                    attShare.ParentId=att.Id;
                    attShare.UserOrGroupId=u.Id;
                    attShare.AccessLevel='Read';
                    attShare.RowCause= Schema.Students_Attendence__Share.RowCause.Manual;
                    stuAttShareList.add(attShare);
                }
            }
          
            
        }
        if(!stuAttShareList.isEmpty()){
            insert stuAttShareList;
        }
    }
    
     public static void UpdateStudentAttendence(List<Students_Attendence__c> trgNew,Map<Id,Students_Attendence__c> trgOldMap){
        
        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Students_Attendence__Share> stuAttShareList = new List<Students_Attendence__Share>();
        
        for(Students_Attendence__c att:trgNew)
        {   
            if(att.ReShare__c && att.ReShare__c!=trgOldMap.get(att.id).ReShare__c)
            {
                schoolNameSet.add(att.School_Name__c);
            }
            
        }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){
            
            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            //System.debug('User: '+ u);
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }
      
        for(Students_Attendence__c att:trgNew){      
            
            if(schoolNameVsUserList.containskey(att.School_Name__c)){
                for(user u : schoolNameVsUserList.get(att.School_Name__c)){
                    //System.debug('User: '+ u);
                    Students_Attendence__Share attShare=new Students_Attendence__Share();
                    attShare.ParentId=att.Id;
                    attShare.UserOrGroupId=u.Id;
                    attShare.AccessLevel='Read';
                    attShare.RowCause= Schema.Students_Attendence__Share.RowCause.Manual;
                    stuAttShareList.add(attShare);
                }
            }
          
            
        }
        if(!stuAttShareList.isEmpty()){
            insert stuAttShareList;
        }
    }
}