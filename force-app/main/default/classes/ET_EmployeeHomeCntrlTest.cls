@isTest
public class ET_EmployeeHomeCntrlTest {
    
    @isTest
    static void testGetCurrentUser() {
        Account testAccount = new Account(Name = 'Test Account');
        try{
            insert testAccount;
        }catch(Exception e){
            System.debug('Error ---'+e);
        }
        Contact testContact = new Contact(
            LastName = 'Test',
            FirstName = 'Contact',
            AccountId = testAccount.Id
        );
        insert testContact;
        User testUser = new User(
            Username = 'testuser@example6.com',
            LastName = 'Test',
            FirstName = 'User',
            Email = 'testuser@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = UserInfo.getProfileId(),
            IsActive = true,
            ContactId = testContact.Id
        );
        try{
            insert testUser;
        }catch(Exception e){
            System.debug('Error ---'+e);
        }
        ET_EmployeeHomeCntrl.UserInsuranceWrapper result = ET_EmployeeHomeCntrl.getCurrentUser();
        
    }
}