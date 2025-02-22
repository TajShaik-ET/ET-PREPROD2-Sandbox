@isTest
public class ETSALES_LeadTriggerHandler_Test {
    
    public class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            res.setBody('mock response');
            return res;
        }
    }
    
    public  static testMethod void setupdata(){
        System.Test.startTest();
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        GL_Activity__c  test_Activity = new GL_Activity__c(Name= 'test_Activity', GL_Activity_Code__c = '0001');
        GL_Project__c   test_Project = new GL_Project__c (Name = 'test_Project', Project_Code__c = '0002');
        ETSALES_Department__c   test_Dept = new ETSALES_Department__c (Name = 'test_Dept' , Department_Code__c = '0003');
        ETSALES_Location__c test_location  = new ETSALES_Location__c(Name = 'test_Location',Location_Code__c='0004');
        
        insert test_Activity;
        insert test_Project;
        insert test_Dept;
        insert test_location;
        
        User testUser  = new User(FirstName = 'fName', LastName = 'lName',email = 'test@123.com',GL_Activity_Code__c=test_Activity.GL_Activity_Code__c,
                                  GL_Project_Code__c=test_Project.Project_Code__c,GL_Location_Code__c=test_location.Location_Code__c,
                                  GL_Department_Code__c=test_Dept.Department_Code__c,ProfileId =userProfile.Id,ETSALES_Employee_Zone__c = 'Zone A',
                                  ETSALES_Location__c='Dubai',Username = 'fnamew46642895@test.com',Alias = 'fname',TimeZoneSidKey='GMT',LocaleSidKey='en_IE_EURO',
                                  EmailEncodingKey ='ISO-8859-1',LanguageLocaleKey ='en_US');
        insert testUser;
        
        Vehicle_Brand_Master__c vbm = new Vehicle_Brand_Master__c();
        vbm.Name = 'Audi';
        insert vbm;
        
        Vehicle_Model_Master__c vmm = new Vehicle_Model_Master__c();
        vmm.Name ='A1';
        vmm.Vehicle_Brand__c = vbm.Id;
        insert vmm;
        
        Campaign cam = new Campaign();
        cam.Name ='test Campaign';
        cam.Campaign_Code__c  ='1234';
        cam.IsActive = true;
        insert cam;
        
        Lead testLead = new Lead();
        testLead.LastName = 'LastName';
        testLead.Company = 'testCompany';
        testLead.Phone = '12345678';
        testLead.MobilePhone = '987654321';
        testLead.Email = 'testEmail@123.com';
        testLead.ETSALES_Budget__c   = 123456798;
        testLead.ETSALES_Lead_Rating__c  = 'Hot';
        testLead.Service_Required__c = 'Service center';
        testLead.OwnerId=testUser.Id;
        testLead.Request_Category__c='Maintenance and Technical services';
        testLead.Preferred_Location__c = 'Dubai';
        testLead.Vehicle_Brand_Pick__c = 'Audi'; //For Moto
        testLead.Vehicle_Model_Pick__c='A1'; //for Moto
        testLead.Emirates_Moto_Campaign__c ='test Campaign';//for Moto
        testLead.Contract_Years__c='2';
        //testLead.No_of_Used_Vehicles__c=20;
        insert testlead;
        
        User testUser1  = new User(FirstName = 'fName1', LastName = 'lName1',email = 'test1@123.com',GL_Activity_Code__c=test_Activity.GL_Activity_Code__c,
                                   GL_Project_Code__c=test_Project.Project_Code__c,GL_Location_Code__c=test_location.Location_Code__c,
                                   GL_Department_Code__c=test_Dept.Department_Code__c,ProfileId =userProfile.Id,ETSALES_Employee_Zone__c = 'Zone A',
                                   ETSALES_Location__c='Dubai',Username = 'fname1@test.com',Alias = 'fname1',TimeZoneSidKey='GMT',LocaleSidKey='en_IE_EURO',
                                   EmailEncodingKey ='ISO-8859-1',LanguageLocaleKey ='en_US');   
        insert testUser1;
        
        User_GL_Mapping__c mappingRecList = new User_GL_Mapping__c (Name = 'Test Mapping',User__c = testUser1.Id,GL_Activity__c =test_Activity.Id ,
                                                                    GL_Department__c =test_Dept.Id ,ETSALES_GL_Location__c = test_location.Id,
                                                                    GL_Project__c= test_Project.Id,Sector__c='School');
        insert mappingRecList;
        Lead leadTest = [SELECT Id,OwnerId FROM Lead where Id =:testlead.Id];
        
        leadtest.OwnerId = testUser1.Id;
        update leadTest;
        List<Id> webList = new List<Id>();
        webList.add(leadTest.Id);
        //ETSALES_LeadTriggerHandler.webtoLeadUpdationFinal(webList);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        ETSALES_LeadTriggerHandler.webtoLeadUpdationFinal(webList);

        
        System.Test.stopTest();
    }
    
}