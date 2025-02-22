/********************************************************************************************************
* @author		Smaartt
* @description	Social sign on using facebook and gmail
*********************************************************************************************************/   

global class ET_SSORegistrationHandler implements Auth.RegistrationHandler{
    
    private static final String ORG_SUFFIX = '.oneet.com';
    //private static final String DEFAULT_ACCOUNTNAME = 'Test Account';
    private static final String EXTERNAL_USER_PROFILE = 'ETS Community Login';
    private static final String INTERNAL_USER_PROFILE = 'Standard User';    
 /********************************************************************************************************
* @author		Smaartt
* @description	register as long as the required fields are supplied
* @param		Auth.UserData data --> require email, lastName, firstName -->the user's info from the Auth Provider
* @return		boolean
*********************************************************************************************************/   

    global boolean canCreateUser(Auth.UserData data) {
        System.debug( logginglevel.INFO,  'canCreateUser was called for ' + (data != null ? data.email : 'null'));
        Boolean retVal = (data != null 
                          && data.email != null
                          && data.lastName != null
                          && data.firstName != null);
        
        System.debug('data.username='+data.username);
        System.debug('data.email='+data.email);
        System.debug('data.lastName='+data.lastName);
        System.debug('data.firstName='+data.firstName);
        
        return retVal;
    }
    
/********************************************************************************************************
* @author		Smaartt
* @description	Create the User - A required method to implement the Handler Interface
* @param		Id of the Community, Auth Provider user data describing the User to create
* @return		User that has been initialized
*********************************************************************************************************/   

    global User createUser(Id portalId, Auth.UserData data){
        
        User u;
           if(!canCreateUser(data)) {
                // Returning null signals the auth framework we can't create the user
                return null;
            }
            
            // Is this a Community Context?
            if(data.attributeMap.containsKey('sfdc_networkid')) {
                System.debug('Registering Community user: ' + data.email);
                Id accountId;
                User retUser;
                List<User> existingUsers = [select Id,Email FROM User WHERE Email =: data.email and profile.name='ETS Community Login' and isActive = true];
                if (existingUsers.size() > 0){
                return existingUsers[0];
                }else{
                    accountId = createAccount(data);
                    System.debug('Created Account: '+ accountId);
                    // You'd likely use other logic to assign the Profile
                    Profile p = [SELECT Id FROM profile WHERE name=:EXTERNAL_USER_PROFILE];
                    System.debug('Found profile: '+ p);
                    
                    // Keeping it modular, we initialize the user in another method
                     u = createUser(data,p);
                    Account acc=[Select Id, PersonContactId from Account where Id=: accountId];
                    u.contactId = acc.PersonContactId;
                   // return u;
                }
                
                
            } 
        return u;
    }
   
/********************************************************************************************************
* @author		Smaartt
* @description	Update the user
* @param		Id of the Community, Auth Provider user data describing the User to create
* @return		void
*********************************************************************************************************/   
   
    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        System.debug('Update User called for: ' + data.email);
        
        User u = new User(id=userId);
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        update(u);
    }
   
   
/********************************************************************************************************
* @author		Smaartt
* @description  Create a Account
* @param		Facebook provided context for the User
* @return		userId
*********************************************************************************************************/   
   private Id createAccount(Auth.UserData data){
        Id personAccountRecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
       
        Id adminId = [SELECT Id FROM User WHERE name =: System.Label.ETI_Admin].Id;
        
        Account account = new Account();
        account.LastName = data.lastName;
        account.FirstName = data.firstName;
        account.PersonEmail = data.email;
        account.RecordTypeId =personAccountRecordTypeId;
        
        account.ownerId= adminId;
        insert account;
        
        System.debug('account created for ' + data.email + ' id=' + account.id);
        
        return account.id; 
    }
    
   
/********************************************************************************************************
* @author		Smaartt
* @description  Create and initialize the User but don't save it yet
* @param		the provided User context from FaceBook and the Profile we are going to assign to this user
* @return		User record
*********************************************************************************************************/      
 
    private User createUser(Auth.UserData data, Profile p) {
        
        User u = new User();
        u.username = data.email.substring(0, data.email.indexOf('@')) +System.Label.ET_Customer_User_Name_Postifx;//data.email + ORG_SUFFIX;
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = data.firstName + data.lastName;
        string languagelocal = UserInfo.getLocale();
        
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        if(languagelocal.containsIgnoreCase('en_IE')){
            languagelocal ='en_US';
        }
        u.alias = alias;
        u.languagelocalekey = languagelocal;
        u.localesidkey = UserInfo.getLocale();
        system.debug('changed Local '+ u.localesidkey);
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'Asia/Dubai';
        u.profileId = p.Id;
        return u;
    }        
}