/*
 * Description: Test Class for ExecutedTripsHandler
 * Author:Sreelakshmi SK
 * Created Date: 16/12/2022
*/

@isTest
public class ExecutedTripsHandlerTest {
	@isTest
    static void testNewStudentAttendence(){
        Account school1 = new Account(Name = 'Test School 1');
        insert school1;
        
        Contact portalUser1= new Contact(LastName='Test School 1 User1',AccountId=school1.id);
        insert portalUser1;
       
        List<Profile> ProfileDataList=new List<Profile>();
        ProfileDataList=[SELECT Id, Name, UserLicense.Name FROM Profile where Name='Govt School Partner User Login'];
        User user1 = new User(UserName = 'rftgyhuytdtffygygt@test.com',
                              LastName='rftgyhuytdtffygygt@test.com',
                             Alias='user1',
                              TimeZoneSidKey='Asia/Dubai',
                              LocaleSidKey='en_IE_EURO',
                              EmailEncodingKey='ISO-8859-1',
                              LanguageLocaleKey='en_US',
                              Email = 'user1@test.com',
                              //AccountId = school1.Id,
                              ContactId=portalUser1.Id,
                              ProfileId = ProfileDataList[0].Id
                              );
        insert user1;
        
        Executed_Trips__c trgNew= new Executed_Trips__c(School__c = school1.Name);
        insert trgNew;
        trgNew.ReShare__c=true;
        update trgNew;
    }   
}