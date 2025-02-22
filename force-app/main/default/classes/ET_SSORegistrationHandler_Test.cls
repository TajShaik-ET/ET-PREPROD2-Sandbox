@isTest
public class ET_SSORegistrationHandler_Test {

    static testMethod void testCreateAndUpdateUser() {
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        User uu=new User(firstname = 'testFirst', 
                         lastName = 'testLast', 
                         email = 'testuse8888r@example.org', 
                         Username = 'testuse8888r@example.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'teste8r', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        // create user
        insert uu;
        
        
        ET_SSORegistrationHandler handler = new ET_SSORegistrationHandler();
        Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                                     'testFirst testLast', 'testuse888@example.org', null, 'testuse888@example.org', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'sfdc_networkid' => 'en_US'});
        
        try{
            User u = handler.createUser(null, sampleData);
            
            sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
                                           'testNewFirst testNewLast', 'testnewuser@example.org', null, 'testnewuserlong', 'en_US', 'facebook',
                                           null, new Map<String, String>{'sfdc_networkid' => 'en_US'});
            handler.updateUser(null, null, sampleData);
        }
        
        catch(Exception e){
            
        }      
    }
 
}