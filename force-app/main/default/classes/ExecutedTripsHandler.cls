/*
* Description: Trigger Handler for ExecutedTripsTrigger
* Author:Sreelakshmi SK
* Created Date: 16/12/2022
*/

public class ExecutedTripsHandler {
    /* 
* Method Description: Give school portal user read only access to corresponding executed trips.
* Author:Sreelakshmi SK
* Created Date: 16/12/2022
*/ 
    
    public static void NewExecutedTrips(List<Executed_Trips__c> trgNew){
        
        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Executed_Trips__Share> exTripShareList = new List<Executed_Trips__Share>();
        
        for(Executed_Trips__c exTrips:trgNew){            
            schoolNameSet.add(exTrips.School__c);
        }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' AND isactive=true]){
            
            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            //System.debug('User: '+ u);
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }
        
        for(Executed_Trips__c exTrips:trgNew){      
            if(schoolNameVsUserList.containskey(exTrips.School__c)){
                for(user u : schoolNameVsUserList.get(exTrips.School__c)){
                    //System.debug('User: '+ u);
                    Executed_Trips__Share exTripShare=new Executed_Trips__Share();
                    exTripShare.ParentId=exTrips.Id;
                    exTripShare.UserOrGroupId=u.Id;
                    exTripShare.AccessLevel='Read';
                    exTripShare.RowCause= Schema.Executed_Trips__Share.RowCause.Manual;
                    exTripShareList.add(exTripShare);
                }
            }
        }
        if(!exTripShareList.isEmpty()){
            insert exTripShareList;
        }
    }
    
     public static void UpdateExecutedTrips(List<Executed_Trips__c> trgNew,Map<Id,Executed_Trips__c> trgOldMap){
        
        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Executed_Trips__Share> exTripShareList = new List<Executed_Trips__Share>();
        
         for(Executed_Trips__c exTrips:trgNew)
         {   
             if(exTrips.ReShare__c && exTrips.ReShare__c!=trgOldMap.get(exTrips.id).ReShare__c)
             {
                 schoolNameSet.add(exTrips.School__c);
             }
             
         }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){
            
            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            //System.debug('User: '+ u);
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }
        
        for(Executed_Trips__c exTrips:trgNew){      
            if(schoolNameVsUserList.containskey(exTrips.School__c)){
                for(user u : schoolNameVsUserList.get(exTrips.School__c)){
                    //System.debug('User: '+ u);
                    Executed_Trips__Share exTripShare=new Executed_Trips__Share();
                    exTripShare.ParentId=exTrips.Id;
                    exTripShare.UserOrGroupId=u.Id;
                    exTripShare.AccessLevel='Read';
                    exTripShare.RowCause= Schema.Executed_Trips__Share.RowCause.Manual;
                    exTripShareList.add(exTripShare);
                }
            }
        }
        if(!exTripShareList.isEmpty()){
            insert exTripShareList;
        }
    }
}