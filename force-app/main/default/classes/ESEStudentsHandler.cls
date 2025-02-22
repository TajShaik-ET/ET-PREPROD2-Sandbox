/*
* Description: Trigger Handler for ESE Students
* Author:Manisha Gouri T
* Created Date: 16/12/2022
*/
public class ESEStudentsHandler {
  
/* 
* Method Description: Give Partner User read only access to records
* Created Date: 16/12/2022
*/
    
    public static void ESEStudentRecords(List<ESE_Students__c> trgNew){

        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<ESE_Students__Share> eseStudentShareList = new List<ESE_Students__Share>();

        for(ESE_Students__c es:trgNew){            
            schoolNameSet.add(es.School__c);
        }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' AND isactive=true]){

            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }

        for(ESE_Students__c es:trgNew){     
            
            if(schoolNameVsUserList.containskey(es.School__c)){

            for(user u : schoolNameVsUserList.get(es.School__c)){

                ESE_Students__Share esShare=new ESE_Students__Share();
                esShare.ParentId=es.Id;
                esShare.UserOrGroupId=u.Id;
                esShare.AccessLevel='Read';
                esShare.RowCause= Schema.ESE_Students__Share.RowCause.Manual;
                eseStudentShareList.add(esShare);
            }
          }
        }
        if(!eseStudentShareList.isEmpty()){
            insert eseStudentShareList;
        }
    }
    
    public static void UpdateESEStudentRecords(List<ESE_Students__c> trgNew, Map<Id,ESE_Students__c> trgOldMap){

        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<ESE_Students__Share> eseStudentShareList = new List<ESE_Students__Share>();

        for(ESE_Students__c es:trgNew)
        { 
            if (es.ReShare__c && es.ReShare__c!=trgOldMap.get(es.id).ReShare__c)
            {
                schoolNameSet.add(es.School__c);
            }
        }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){

            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }

        for(ESE_Students__c es:trgNew){     
            
            if(schoolNameVsUserList.containskey(es.School__c)){

            for(user u : schoolNameVsUserList.get(es.School__c)){

                ESE_Students__Share esShare=new ESE_Students__Share();
                esShare.ParentId=es.Id;
                esShare.UserOrGroupId=u.Id;
                esShare.AccessLevel='Read';
                esShare.RowCause= Schema.ESE_Students__Share.RowCause.Manual;
                eseStudentShareList.add(esShare);
            }
          }
        }
        if(!eseStudentShareList.isEmpty()){
            insert eseStudentShareList;
        }
    }
}