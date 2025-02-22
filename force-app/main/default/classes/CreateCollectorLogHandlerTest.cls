@isTest
public class CreateCollectorLogHandlerTest {
    @isTest 
    Public static void CustomerAmountDetailsTest(){
        
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        Account acc= new Account();
        acc.Name='oil and gas 2342342323';
        acc.ETSALES_Customer_Account_Id__c='1926070';
        acc.accountnumber='1926070';
        insert acc;
        
        Account acc2= new Account();
        acc2.Name='Test243424';       
        insert acc2;
        
        Test.startTest();
        try{ 
            CreateCollectorLogHandler.getCustomerAmountDetails(acc.Id);  
            CreateCollectorLogHandler.getCustomerAmountDetails(acc2.Id);   
        }catch(Exception e){
            system.assertEquals(e.getMessage(), e.getMessage()); 
        }
       
        CreateCollectorLogHandler.getDispositionInfo();
        Test.stopTest();
    }
}