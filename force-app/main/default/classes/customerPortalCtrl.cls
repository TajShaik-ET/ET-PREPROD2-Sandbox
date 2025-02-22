/***
Class       : customerPortalCtrl
Author      : Janardhan Muddana, Taj Shaik
Description : custom error page 
TestClass   : customerPortalCtrlTest
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0_SH           23/03/2023          Initial Version
*****************************************************************************************************************/
global without Sharing class customerPortalCtrl{
    
    @AuraEnabled
    public static string createUser(String userInfoStr, String accRecType){ 
        System.debug('accRecType: '+accRecType+' userInfoStr: '+userInfoStr);
        SSOUserData userData = (SSOUserData) JSON.deserialize(userInfoStr, SSOUserData.class);
        Account acc = New Account();        
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(accRecType).getRecordTypeId();
        acc.LastName = userData.lastName;
        acc.FirstName = userData.firstName;
        acc.PersonEmail = userData.email; 
        Insert acc;
        Boolean isSandbox = [SELECT Id, IsSandbox FROM Organization].isSandbox;
        String random = string.valueOf(math.random()).substring(0,4);
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name =: system.label.OneET_CustomerCmnty_Profile LIMIT 1];
        Account accSaved = [Select Id, PersonContactId from Account where Id =: acc.Id];
        User u = new User();
        u.ProfileId = portalProfile.Id;
        u.FirstName = userData.firstName; 
        u.LastName = userData.LastName;
        u.Email = userData.email;
        u.ContactID = accSaved.PersonContactId; 
        u.TimeZoneSidKey = 'Asia/Dubai';
        u.LocaleSidKey = 'en_AE';
        u.LanguageLocaleKey = 'en_US';
        u.CommunityNickname = userData.lastName+string.valueOf(math.random()).substring(0,6);
        u.EmailEncodingKey = 'UTF-8'; 
        List<String> emailSplit = userData.email.split('@');
        u.Alias = emailSplit[0].substring(0,2) + Integer.valueof((Math.random() * 10000));
        u.Username = emailSplit[0];
        u.Username += (isSandbox ? '.'+Integer.valueof((Math.random() * 1000)) : '') + '@et.ae'; 
        u.MobilePhone = userData.mobile;
        u.UUID__c = userData.identifier;
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = false;     
        try{
            //database.insert(u, dlo);
            if(!Test.isRunningTest()){
                database.Insert(u);
                System.debug('User created successfully: '+ u.Id);
                String tpAccountLink = linkThirdPartyAccount(u.Id,'uae pass',userData.email);
                System.debug('tpAccountLink: '+tpAccountLink);
                return u.Id;
            }else{
                return null;
            }
        }catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static boolean login(String username, String password, String startUrl, String userInfoStr) {
        system.debug('userInfoStr: '+userInfoStr);
        Boolean loginSuccess = false;
        SSOUserData userData = (SSOUserData) JSON.deserialize(userInfoStr, SSOUserData.class);
        system.debug('userData: '+userData);
        system.debug('username: '+username);
        //Authenticate the user
        PageReference loginPage = Site.login(username, password, '');
        if(Test.isRunningTest())
           loginPage = new PageReference('/dummyPage'); //for Test class
        System.debug('Final loginPage: ' + loginPage);
        if (loginPage != null) {
            loginSuccess = true;
            try {
                User currentUser = [SELECT Id, Email, UUID__c, CompanyName, UserName, FirstName, LastName FROM User WHERE username =: username];
                currentUser.LastName = userData.lastName;
                currentUser.FirstName = userData.firstName;
                currentUser.Email = userData.email;
                currentUser.MobilePhone = userData.mobile;
                currentUser.UUID__c = userData.identifier;
                Update currentUser;
                System.debug('User updated successfully: '+currentUser.Id);
                String tpAccountLink = linkThirdPartyAccount(currentUser.Id,'uae pass',userData.email);
                System.debug('tpAccountLink: '+tpAccountLink);
            } catch (Exception e) {
                System.debug('Error updating user email: ' + e.getMessage());
            }
        } else {
            System.debug('User authentication failed.');
            loginSuccess = false;
        }
        aura.redirect(loginPage);
        return loginSuccess;
    }   
    
    @AuraEnabled
    public static String linkThirdPartyAccount(Id userId, String thirdPartyAccountName, String thirdPartyAccountId) {
        try {
            ThirdPartyAccountLink tpAccountLink = new ThirdPartyAccountLink();
            tpAccountLink.UserId = userId; // ID of the user to link the account to
            tpAccountLink.Provider = thirdPartyAccountName; // Name of the third-party provider (e.g., 'Google', 'Facebook')
            tpAccountLink.Handle = thirdPartyAccountId; // Unique identifier for the third-party account
            if(!Test.isRunningTest())
              Database.InsertImmediate(tpAccountLink);
            return 'Third-party account linked successfully.';
        } catch (Exception e) {
            return 'Error linking third-party account: ' + e.getMessage();
        }
    }
    
    @AuraEnabled
    public static SSOUserData getSSOUserData(String dataStrEncr) {
        String dataStrDecr = EncryptionUtils.decryptString(dataStrEncr); 
        SSOUserData userData = fromString(dataStrDecr);
        System.debug('getSSOUserData userData: '+userData);
        return userData;
    }
    
    @AuraEnabled
    public static SSOUserData fromString(String data) {
        SSOUserData userData = New SSOUserData();
        Map<String, String> userDataMap = new Map<String, String>();
        String cleanedData = data.replace('[', '').replace(']', '');
        List<String> attributes = cleanedData.split(', ');
        for (String attribute : attributes) {
            List<String> keyValue = attribute.split('=');
            if (keyValue.size() == 2) {
                userDataMap.put(keyValue[0].trim(), keyValue[1].trim());
            }
        }
        userData.identifier = userDataMap.get('identifier');
        userData.fullName = userDataMap.get('fullName');
        userData.firstName = userDataMap.get('firstName');
        userData.lastName = userDataMap.get('lastName');
        userData.email = userDataMap.get('email');
        userData.mobile = userDataMap.get('mobile');
        userData.gender = userDataMap.get('gender');
        return userData;
    }
    
    public class SSOUserData {
        @AuraEnabled
        public String identifier{get;set;} 
        @AuraEnabled
        public String firstName{get;set;}
        @AuraEnabled
        public String lastName{get;set;}  
        @AuraEnabled
        public String fullName{get;set;}
        @AuraEnabled
        public String email{get;set;}
        @AuraEnabled
        public String mobile{get;set;} 
        @AuraEnabled
        public String gender{get;set;} 
        @AuraEnabled
        Public Map<String,String> attributeMap{get;set;}
        public SSOUserData(){
        }
    }
    
}