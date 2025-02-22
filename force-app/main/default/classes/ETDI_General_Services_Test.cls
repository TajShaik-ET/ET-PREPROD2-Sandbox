@isTest
public class ETDI_General_Services_Test {
    
    @isTest
    public static void codecoverage1()
    {
        //ETDI_General_Services.testUtility();
    
        Test.setMock(HttpCalloutMock.class, new ETDI_Services_Mock()); 
        Account acc = new Account(LastName = 'Test', PersonMobilePhone='+971504111111');
        
        insert acc;
        
        Case c = new Case(AccountId=acc.id,Status='New',Subject='Test');
        insert c;       
     
        Test.startTest();      
           ETDI_General_Services.validateMobileNumber1(c.id); 
        ETDI_General_Services.getOldLicenseType(c.id);
       // ETDI_General_Services.getClassScheduleOfInstructor(c.id);
        Test.stopTest();
	}
    
    @isTest
     public static void codecoverage2()
    {
        Test.setMock(HttpCalloutMock.class, new ETDI_Services_Mock()); 
        Account acc = new Account(LastName = 'Test', PersonMobilePhone='+971504111111');
        
        insert acc;
        
        Case c = new Case(AccountId=acc.id,Status='New',Subject='Test');
        insert c;       
     
        Test.startTest();      
       
        ETDI_General_Services.changeInstructor(c.id,'Test');
        ETDI_General_Services.changecourse(c.id,'LAV' ,'LMV');
        ETDI_General_Services.bookClass(c.id,'06-06-2021','12:30','1218');
   //   ETDI_General_Services.bookExam(c.id,1,'06-06-2021','Test');
        //ETDI_General_Services.changeInstructor(c.id,'Test');
        Test.stopTest();
	}
    
        @isTest
     public static void codecoverage3()
    {
        Test.setMock(HttpCalloutMock.class, new ETDI_Services_Mock()); 
        Account acc = new Account(LastName = 'Test', PersonMobilePhone='+971504111111');
        
        insert acc;
        
        Case c = new Case(AccountId=acc.id,Status='New',Subject='Test');
        insert c;       
     
        Test.startTest();      

        ETDI_General_Services.bookExam(c.id,1,'06-06-2021','Test');
      //  ETDI_General_Services.getPendingClasses(c.id);
        //ETDI_General_Services.changeInstructor(c.id,'Test');
        Test.stopTest();
	}
    
     @isTest
     public static void codecoverage4()
    {
        Test.setMock(HttpCalloutMock.class, new ETDI_Services_Mock()); 
        Account acc = new Account(LastName = 'Test', PersonMobilePhone='+971504111111');
        
        insert acc;
        
        Case c = new Case(AccountId=acc.id,Status='New',Subject='Test');
        insert c;       
     
        Test.startTest();      

      //  ETDI_General_Services.bookExam(c.id,1,'06-06-2021','Test');
        String pendignClassStr = ETDI_General_Services.getPendingClasses(c.id);
        System.debug('General Service cehck ='+pendignClassStr);
        //ETDI_General_Services.changeInstructor(c.id,'Test');   
        List<String> strlst = new List<String>{'1111'};
        ETDI_General_Services.getSelectedCancelClass(c.id,strlst,pendignClassStr,'Test');
        ETDI_General_Services.getExamType(c.id);
        ETDI_General_Services.getInstructorID(c.id);
        //ETDI_General_Services.getClassScheduleOfInstructor(c.id);
        Test.stopTest();
	}
    
         @isTest
     public static void codecoverage5()
    {
        Test.setMock(HttpCalloutMock.class, new ETDI_Services_Mock()); 
        Account acc = new Account(LastName = 'Test', PersonMobilePhone='+971504111111');
        
        insert acc;
        
        Case c = new Case(AccountId=acc.id,Status='New',Subject='Test');
        insert c;       
     
        Test.startTest();      
     
        ETDI_General_Services.cancelClass(c.id,'Test','29/09/2020','06:00',1111);
        String str = ETDI_General_Services.getPendingExams(c.id);
        List<String> strlsit = new List<String>{'1111'};
        ETDI_General_Services.getSelectedCancelExam(c.id,strlsit,str,'Test');
        ETDI_General_Services.changeToOnlineLecture(c.id,'Test');
        Test.stopTest();
	}
    
     @isTest
     public static void codecoverage6()
    {
        Test.setMock(HttpCalloutMock.class, new ETDI_Services_Mock()); 
        Account acc = new Account(LastName = 'Test', TFN_Number__c='11111');
        
        insert acc;
        
        Case c = new Case(AccountId=acc.id,Status='New',Subject='Test');
        insert c;       
     
        Test.startTest(); 
        try{
        ETDI_General_Services.changeInstructor(c.id,'Test');    
        }
        catch(Exception e){}
        try{
            ETDI_General_Services.changecourse(c.id,'LAV' ,'LMV');
        }
        catch(Exception e){}
        try{
              ETDI_General_Services.bookClass(c.id,'06-06-2021','12:30','1218');
        }
        catch(Exception e){}
        try{
              ETDI_General_Services.validateMobileNumber1(c.id); 
        }
        catch(Exception e){}
        try{
              ETDI_General_Services.bookClass(c.id,'06-06-2021','12:30','1218');
        }
        catch(Exception e){}
        try{
             ETDI_General_Services.bookExam(c.id,1,'06-06-2021','Test');
        }
        catch(Exception e){}
          String pendignClassStr='';
        try{
              pendignClassStr = ETDI_General_Services.getPendingClasses(c.id);
        }
        catch(Exception e){}
          try{
            
        List<String> strlst = new List<String>{'1111'};
        ETDI_General_Services.getSelectedCancelClass(c.id,strlst,pendignClassStr,'Test');
        }
        catch(Exception e){}
                try{
                    ETDI_General_Services.getExamType(c.id);
        }
        catch(Exception e){}
                try{
            //   ETDI_General_Services.cancelClass(c.id,'Test','29/09/2020','06:00',1111);
        }
        catch(Exception e){}
        String str='';
          try{
                str = ETDI_General_Services.getPendingExams(c.id);
        }
        catch(Exception e){}
          try{
               List<String> strlsit = new List<String>{'1111'};
        //ETDI_General_Services.getSelectedCancelExam(c.id,strlsit,str,'Test');
        }
        catch(Exception e){}
          try{
                ETDI_General_Services.changeToOnlineLecture(c.id,'Test');
        }
        catch(Exception e){}

        Test.stopTest();
	}
    

}