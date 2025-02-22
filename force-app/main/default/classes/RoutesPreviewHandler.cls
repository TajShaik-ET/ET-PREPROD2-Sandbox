/*
* Description: Trigger Handler for RoutesPreviewTrigger
* Author:Sreelakshmi SK
* Created Date: 16/12/2022
*/
public class RoutesPreviewHandler {
    /* 
* Method Description: Give school portal user read only access to corresponding routes preview.
* Author:Sreelakshmi SK
* Created Date: 16/12/2022
*/   
    public static void NewRoutesPreview(List<Routes_Preview__c> trgNew){
        
        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Routes_Preview__Share> routePrvwShareList = new List<Routes_Preview__Share>();
        
        for(Routes_Preview__c rp:trgNew){            
            schoolNameSet.add(rp.School__c);
        }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){
            
            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            //System.debug('User: '+ u);
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }
        
        for(Routes_Preview__c rp:trgNew){      
            if(schoolNameVsUserList.containskey(rp.School__c)){
                for(user u : schoolNameVsUserList.get(rp.School__c)){
                    //System.debug('User: '+ u);
                    Routes_Preview__Share rpShare=new Routes_Preview__Share();
                    rpShare.ParentId=rp.Id;
                    rpShare.UserOrGroupId=u.Id;
                    rpShare.AccessLevel='Read';
                    rpShare.RowCause= Schema.Routes_Preview__Share.RowCause.Manual;
                    routePrvwShareList.add(rpShare);
                }
            }
            
        }
        if(!routePrvwShareList.isEmpty()){
            insert routePrvwShareList;
        }
    }
    
     public static void UpdateRoutesPreview(List<Routes_Preview__c> trgNew,Map<Id,Routes_Preview__c> trgOldMap){
        
        set<string> schoolNameSet = new set<string>();
        map<string,list<user>> schoolNameVsUserList = new map<string,list<user>>();
        List<Routes_Preview__Share> routePrvwShareList = new List<Routes_Preview__Share>();
        
         for(Routes_Preview__c rp:trgNew)
         {  
             if(rp.ReShare__c && rp.ReShare__c!=trgOldMap.get(rp.id).ReShare__c)
             {
                 schoolNameSet.add(rp.School__c);
             }
         }
        for(User u : [select id,Account.Name from user where Account.Name=:schoolNameSet and Profile.UserLicense.Name='Partner Community Login' and isactive=true]){
            
            if(!schoolNameVsUserList.containsKey(u.Account.Name)) {
                schoolNameVsUserList.put(u.Account.Name, new List<user>());
            }
            //System.debug('User: '+ u);
            schoolNameVsUserList.get(u.Account.Name).add(u);
        }
        
        for(Routes_Preview__c rp:trgNew){      
            if(schoolNameVsUserList.containskey(rp.School__c)){
                for(user u : schoolNameVsUserList.get(rp.School__c)){
                    //System.debug('User: '+ u);
                    Routes_Preview__Share rpShare=new Routes_Preview__Share();
                    rpShare.ParentId=rp.Id;
                    rpShare.UserOrGroupId=u.Id;
                    rpShare.AccessLevel='Read';
                    rpShare.RowCause= Schema.Routes_Preview__Share.RowCause.Manual;
                    routePrvwShareList.add(rpShare);
                }
            }
            
        }
        if(!routePrvwShareList.isEmpty()){
            insert routePrvwShareList;
        }
    }
}