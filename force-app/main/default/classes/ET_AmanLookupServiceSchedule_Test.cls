@isTest
public class ET_AmanLookupServiceSchedule_Test {
    
    @isTest
    public static void testCase1(){
       System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        String CRON_EXP = '0 0 0 15 12 ? 2021';
        System.Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
                                       CRON_EXP, 
                                       new ET_AmanLookupServiceSchedule()); 
        System.Test.stopTest();
          System.assert(jobId != null);
    }
    @isTest
    public static void testCase2(){
        
        ET_Lookup.Output result = new ET_Lookup.Output();
        result.Status = 's';
        result.data = new ET_Lookup.AmanLookupValuesCollection();
        result.data.AmanLookupValues =  new List<ET_Lookup.AmanLookupValues>{new ET_Lookup.AmanLookupValues()};
            System.Test.startTest(); 
      // List<ETI_Aman_Lookup__c> resultStatus =  ET_AmanLookupServiceSchedule.doMappingLookupMaster(result);
        System.Test.stopTest();
        //System.assert(resultStatus != null);
    }
}