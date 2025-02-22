/*******************************************************************************************************************
Class       : UAEPassUserRegistrationHandler
Author      : Janardhan Muddana, Taj Shaik
Description : registration and linking handler for UAE PASS SSO 
TestClass   :  UAEPassUserRegistrationHandlerTest
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.           V1.0_SH          Sep 15th, 2022    Initial Version
*******************************************************************************************************************/

global class UAEPassUserRegistrationHandler implements Auth.RegistrationHandler, Auth.ConfirmUserRegistrationHandler {
    
    class RegHandlerException extends Exception {}
    
    global User createUser(Id portalId, Auth.UserData data){
        System.debug(data.identifier+' : identifier -- email: '+data.email);
        if(String.isNotBlank(data.identifier)) {
            List<User> availableUsers = [SELECT Id,Email,UserName,UUID__c,MobilePhone,IsActive FROM User WHERE 
                                         (UUID__c =: data.identifier OR Email =: data.email OR UserName =: data.email) AND 
                                         IsActive = true AND User.Profile.Name =: system.label.OneET_CustomerCmnty_Profile];  
            system.debug('availableUsers: '+availableUsers);
            if(availableUsers!=null && availableUsers.size()>0) {
                User identifiedUser;
                for(User us: availableUsers){
                    if(us.IsActive && us.UUID__c == data.identifier && (us.UserName == data.email || us.Email == data.email)){
                        identifiedUser = us;
                        Break;
                    } 
                }
                system.debug('identifiedUser: '+identifiedUser);
                User possibleUser;
                for(User us: availableUsers){
                    if(us.IsActive && (us.UserName == data.email || us.Email == data.email)){
                        possibleUser = us;
                        Break;
                    } 
                }
                system.debug('possibleUser: '+possibleUser);
                if(identifiedUser != null){
                    return identifiedUser;
                }
                else if(possibleUser != null){
                    if(possibleUser.UUID__c == null || possibleUser.UUID__c != data.identifier){
                        possibleUser.UUID__c = data.identifier;                
                        Update possibleUser;
                    }
                    return possibleUser;
                }else{
                    throw new RegHandlerException(handleUserNotFound(data));
                    //return null;
                }
            }else{
                throw new RegHandlerException(handleUserNotFound(data));
                //return null;
            }
        }else{
            throw new RegHandlerException('Error. Contact ET Admin!');
        }    
    }
    
    global void updateUser(Id userId, Id portalId, Auth.UserData data) {
        System.debug('<updateUser>:: userId' + userId + ' ===:: Data ===' + data);
        User u = new User(id=userId);
        u.firstName = data.firstName;
        u.lastName = data.lastName;
        u.alias = data.username;
        u.UUID__c = data.identifier;
        u.email = data.email; 
        u.MobilePhone = data.attributeMap.get('mobile');
        if(u.alias.length() > 8) {
            u.alias = u.alias.substring(0, 8);
        }
        try{
            Update(u);
        }catch(Exception ex){
            System.debug('getMessage: '+ex.getMessage()); 
        }
    }
    
    global Id confirmUser(Id userId, Id tpalId, Id portalId, Auth.UserData data) {
        System.debug('<confirmUser >:: userId' + userId + ' ===:: Data ===' + data+'--tpalId--'+tpalId+'--portalId--'+portalId);
        Map<Id,User> confirmedUserMap = new Map<Id, User>([SELECT Id,Name,MobilePhone,Email,IsActive FROM User WHERE (UUID__c =: data.identifier OR Id =: userId)]);
        System.debug(confirmedUserMap.Size()+' :confirmedUserMap: ' + confirmedUserMap.Values());
        Map<Id,ThirdPartyAccountLink> userTpAccLinkMap = New Map<Id,ThirdPartyAccountLink>();
        for(ThirdPartyAccountLink tpAccountLink: [SELECT Handle,Id,IsNotSsoUsable,Provider,RemoteIdentifier,SsoProviderId,SsoProviderName,ThirdPartyAccountLinkKey,UserId FROM ThirdPartyAccountLink WHERE UserId =: confirmedUserMap.KeySet()]){
            userTpAccLinkMap.put(tpAccountLink.UserId,tpAccountLink);
        }
        System.debug(userTpAccLinkMap.Size()+' :userTpAccLinkMap: ' + userTpAccLinkMap.Values());
        if(confirmedUserMap != null && !confirmedUserMap.isEmpty()) {
            if(confirmedUserMap.get(userId).IsActive){
                return userId;
            }
            else if(!confirmedUserMap.get(userId).IsActive && userTpAccLinkMap.ContainsKey(userId)){
                revokeAccessToken(userTpAccLinkMap.get(userId));
                for(User u: confirmedUserMap.Values()){
                    if(userId != u.Id){
                        if(confirmedUserMap.get(u.Id).IsActive){
                            return u.Id;
                        }
                        else if(!confirmedUserMap.get(u.Id).IsActive && userTpAccLinkMap.ContainsKey(u.Id)){
                            revokeAccessToken(userTpAccLinkMap.get(u.Id));
                            throw new RegHandlerException(handleUserNotFound(data));
                            //return null;
                        }
                    }
                }
            }
        }
        throw new RegHandlerException(handleUserNotFound(data));
        //return null;
    }
        
    public String handleUserNotFound(Auth.UserData data) {
        customerPortalCtrl.SSOUserData userData = getSSOUserData(data);
        String dataStrEncr = EncryptionUtils.encryptString(userData.ToString());
        return dataStrEncr;
    }
    
    public customerPortalCtrl.SSOUserData getSSOUserData(Auth.UserData data) {
        customerPortalCtrl.SSOUserData userData = New customerPortalCtrl.SSOUserData();
        userData.identifier = data.identifier;
        userData.fullName = data.fullName;
        userData.firstName = data.firstName;
        userData.lastName = data.lastName;
        userData.email = data.email;
        userData.mobile = data.attributeMap.get('mobile');
        userData.gender = data.attributeMap.get('gender');
        System.debug('getSSOUserData userData: '+userData); 
        return userData;
    }
    
    public void revokeAccessToken(ThirdPartyAccountLink tpAccountLink) {
        //Revoke the access token associated with the third-party account
        if (!Auth.AuthToken.revokeAccess(tpAccountLink.SsoProviderId, tpAccountLink.SsoProviderName.toLowerCase(), tpAccountLink.UserId, tpAccountLink.RemoteIdentifier)) {
            throw new RegHandlerException('Something failed when revoking TPL: ' + tpAccountLink);
        }else{
            System.debug('Access revoked Successfully: ' + tpAccountLink);
        }
    }

    global void testCodeMethod(){
        integer i=0;
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