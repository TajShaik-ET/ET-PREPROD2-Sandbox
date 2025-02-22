@isTest
public class ETST_UpdateAccountAddressScheduler_Test{
  
  public static testmethod void testData(){
   
          ETST_UpdateAccountAddressScheduler  sh1 = new ETST_UpdateAccountAddressScheduler();
          String sch = '0 0 23 * * ?'; 
          System.schedule('Test Territory Check', sch, sh1); 
        
  
  }
}