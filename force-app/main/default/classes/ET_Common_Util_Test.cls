@isTest
public class ET_Common_Util_Test {
    @testsetup
    public static void setupdata(){
        ETST_Payment__c epaym = new ETST_Payment__c();
        epaym.ETST_Amount__c = 200;
        epaym.ETST_Payment_URL__c = 'http://example.com/example/test';
        insert epaym;
    }
    /*@isTest
    public static void testFormakeCallout(){
          System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorResponce());
        System.Test.startTest();
        //ET_Common_Util.makeCallout();
        new ET_Payment_Controller().updatePayment();
        System.Test.stopTest();
    }
    @isTest
    public static void testForsendEmail(){
          String key = String.valueOf([SELECT id from ETST_Payment__c limit 1][0].id);
        System.Test.startTest();
        ET_Common_Util.magicMe();
        ET_Common_Util.sendEmail( 'subject', new List<String>{'abc@gmail.com'}, new List<String>{'abc@gmail.com'}, new List<String>{'abc@gmail.com'}, 'body',new Map<String, String>{key=>'1Test'}, new Map<String, String>{key=>'1Test'});
        System.Test.stopTest();
    }
    @isTest
    public static void testForvoidPayment(){
          String key = String.valueOf([SELECT id from ETST_Payment__c limit 1][0].id);
        System.Test.startTest();
        //ET_Common_Util.makeCallout();
        ET_Common_Util.voidPayment(key);
        System.Test.stopTest();
    }
     @isTest
    public static void testForcreateRefundRequest(){
          String key = String.valueOf([SELECT id from ETST_Payment__c limit 1][0].id);
        System.Test.startTest();
        //ET_Common_Util.makeCallout();
        ET_Common_Util.createRefundRequest(key,100);
        //ET_Common_Util.testData();
        System.Test.stopTest();
    }
    @isTest
    public static void testForcancelRefund(){
          String key = String.valueOf([SELECT id from ETST_Payment__c limit 1][0].id);
        System.Test.startTest();
        //ET_Common_Util.makeCallout();
        ET_Common_Util.cancelRefund(key);
        System.Test.stopTest();
    }
    @isTest
    public static void testForgetRefundStatus(){
          String key = String.valueOf([SELECT id from ETST_Payment__c limit 1][0].id);
        System.Test.startTest();
        //ET_Common_Util.makeCallout();
        ET_Common_Util.getRefundStatus(key);
        System.Test.stopTest();
    }
   */
  @isTest
    public static void testForgetRefundStatus(){
       //   String key = String.valueOf([SELECT id from ETST_Payment__c limit 1][0].id);
        System.Test.startTest();
        ET_Common_Util.magicMethod();
        //ET_Common_Util.getRefundStatus(key);
        System.Test.stopTest();
    }  
}