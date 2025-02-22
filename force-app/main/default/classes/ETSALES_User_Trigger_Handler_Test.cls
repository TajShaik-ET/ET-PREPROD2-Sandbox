@isTest
public class ETSALES_User_Trigger_Handler_Test {
    
    public  static testMethod void setupdata(){
        System.Test.startTest();
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        GL_Activity__c	test_Activity = new GL_Activity__c(Name= 'test_Activity', GL_Activity_Code__c = '0001');
        GL_Project__c	test_Project = new GL_Project__c (Name = 'test_Project', Project_Code__c = '0002');
        ETSALES_Department__c	test_Dept = new ETSALES_Department__c (Name = 'test_Dept' , Department_Code__c = '0003');
        ETSALES_Location__c	test_location  = new ETSALES_Location__c(Name = 'test_Location',Location_Code__c='0004');
        
        insert test_Activity;
        insert test_Project;
        insert test_Dept;
        insert test_location;
        
        User testUser  = new User(FirstName = 'fName', LastName = 'lName',email = 'test@123.com',GL_Activity_Code__c=test_Activity.GL_Activity_Code__c,
                                  GL_Project_Code__c=test_Project.Project_Code__c,GL_Location_Code__c=test_location.Location_Code__c,
                                  GL_Department_Code__c=test_Dept.Department_Code__c,ProfileId =userProfile.Id,ETSALES_Employee_Zone__c = 'Zone A',
                                  ETSALES_Location__c='Dubai',Username = 'fname@test.com',Alias = 'fname',TimeZoneSidKey='GMT',LocaleSidKey='en_IE_EURO',
                                 EmailEncodingKey ='ISO-8859-1',LanguageLocaleKey ='en_US');
        
        insert testUser;
        
        //List<User_GL_Mapping__c> testUserMapping = [SELECT Id,Name,User__c,GL_Activity__c FROM User_GL_Mapping__c];
        //system.assertEquals(1, testUserMapping.size());
        
        System.Test.stopTest();
        
        GL_Activity__c	test_Activity1 = new GL_Activity__c(Name= 'test_Activity', GL_Activity_Code__c = '0005');
        GL_Project__c	test_Project1 = new GL_Project__c (Name = 'test_Project', Project_Code__c = '0006');
        ETSALES_Department__c	test_Dept1 = new ETSALES_Department__c (Name = 'test_Dept' , Department_Code__c = '0007');
        ETSALES_Location__c	test_location1  = new ETSALES_Location__c(Name = 'test_Location',Location_Code__c='0008');
        
        insert test_Activity1;
        insert test_Project1;
        insert test_Dept1;
        insert test_location1;
        
        system.assertEquals('0005', test_Activity1.GL_Activity_Code__c);
        system.assertEquals('0006', test_Project1.Project_Code__c);
        system.assertEquals('0007', test_Dept1.Department_Code__c);
        system.assertEquals('0008', test_location1.Location_Code__c);
        
        User uTest = [SELECT Id,GL_Activity_Code__c,GL_Project_Code__c,GL_Department_Code__c,GL_Location_Code__c FROM User WHERE Id =: testUser.Id];
        
        system.assertEquals('0001',uTest.GL_Activity_Code__c);
        system.assertEquals('0002',uTest.GL_Project_Code__c);
        system.assertEquals('0003',uTest.GL_Department_Code__c);
        system.assertEquals('0004',uTest.GL_Location_Code__c);
        
        uTest.GL_Activity_Code__c=test_Activity1.GL_Activity_Code__c;
        //update uTest;
        uTest.GL_Project_Code__c = test_Project1.Project_Code__c;
        //update uTest;
        uTest.GL_Department_Code__c=test_Dept1.Department_Code__c;
        //update uTest;
        uTest.GL_Location_Code__c = test_location1.Location_Code__c;
        update uTest;
    }
}