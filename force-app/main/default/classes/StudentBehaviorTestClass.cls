@isTest
    public class StudentBehaviorTestClass {
        
       static testMethod void NewSbitTest() {
          //Create Data for Student Behavior Incidents Types Object
        Account school = new Account(Name = 'Test School');
        insert school;
        
        Contact portalUser= new Contact(LastName='Test School User1',AccountId=school.id);
        insert portalUser;
              
        List<Profile> ProfileDataList=new List<Profile>();
        ProfileDataList=[SELECT Id, Name, UserLicense.Name FROM Profile where Name='Govt School Partner User Login'];
        User u1 = new User(UserName = 'rftgyhuytdtffygygt@test.com',
                              LastName='rftgyhuytdtffygygt@test.com',
                             Alias='user1',
                              TimeZoneSidKey='Asia/Dubai',
                              LocaleSidKey='en_IE_EURO',
                              EmailEncodingKey='ISO-8859-1',
                              LanguageLocaleKey='en_US',
                              Email = 'user1@test.com',
                              ContactId=portalUser.Id,
                              ProfileId = ProfileDataList[0].Id
                              );
        insert u1;
        
      
          Student_Behavior_Incidents_Types__c trgNew = new Student_Behavior_Incidents_Types__c(School__c = school.Name);
            
        insert trgNew;
          trgNew.Reshare__c=true;
           update trgNew;
       }
}