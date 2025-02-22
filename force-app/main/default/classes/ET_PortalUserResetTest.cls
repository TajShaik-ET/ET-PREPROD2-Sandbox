@isTest
public class ET_PortalUserResetTest {
 	 @isTest
    private static void PrtalUserPasswordTest(){
        
        String query='SELECT Id, Name, UserRole.Name, Email, userName, Profile.Name, IsActive, LastLoginDate, Profile.UserLicense.Name FROM User WHERE isActive = true limit 5';
        ET_PortalUserReset.fetchRecords(query);
        ET_PortalUserReset.testCoverage1();
            
      }
}