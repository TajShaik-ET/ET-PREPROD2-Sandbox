/*
* Description: Trigger Handler for ESE Students
* Author:Manisha Gouri T
* Created Date: 16/12/2022
*/
public class TripsMoreThanHandler {
  
/* 
* Method Description: Give Partner User read only access to records
* Created Date: 16/12/2022
*/
    
    public static void NewTripRecords(List<Trips_More_Than__c> trgNew){

        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Trips_More_Than__Share> tripsShareList = new List<Trips_More_Than__Share>();

        for(Trips_More_Than__c tm:trgNew){            
            schoolNameSet.add(tm.School__c);
        }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){

            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }

        for(Trips_More_Than__c tm:trgNew){      
            
            if(schoolNameVsUserList.containskey(tm.School__c)){

            for(user u : schoolNameVsUserList.get(tm.School__c)){

                Trips_More_Than__Share tmShare=new Trips_More_Than__Share();
                tmShare.ParentId=tm.Id;
                tmShare.UserOrGroupId=u.Id;
                tmShare.AccessLevel='Read';
                tmShare.RowCause= Schema.Student_Behavior_Incidents_Types__Share.RowCause.Manual;
                tripsShareList.add(tmShare);
            }
          }
        }
        if(!tripsShareList.isEmpty()){
           insert tripsShareList;
        }
    }
    
     public static void UpdateTripRecords(List<Trips_More_Than__c> trgNew, Map<Id,Trips_More_Than__c> trgOldMap ){

        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Trips_More_Than__Share> tripsShareList = new List<Trips_More_Than__Share>();

         for(Trips_More_Than__c tm:trgNew)
         {  
             if (tm.ReShare__c && tm.ReShare__c!=trgOldMap.get(tm.id).ReShare__c)
             {
                 schoolNameSet.add(tm.School__c);
             }
         }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){

            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }

        for(Trips_More_Than__c tm:trgNew){      
            
            if(schoolNameVsUserList.containskey(tm.School__c)){

            for(user u : schoolNameVsUserList.get(tm.School__c)){

                Trips_More_Than__Share tmShare=new Trips_More_Than__Share();
                tmShare.ParentId=tm.Id;
                tmShare.UserOrGroupId=u.Id;
                tmShare.AccessLevel='Read';
                tmShare.RowCause= Schema.Student_Behavior_Incidents_Types__Share.RowCause.Manual;
                tripsShareList.add(tmShare);
            }
          }
        }
        if(!tripsShareList.isEmpty()){
           insert tripsShareList;
        }
    }
}