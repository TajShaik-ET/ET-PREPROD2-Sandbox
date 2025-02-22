@isTest
Public class ETI_UpdatePaymentTest{

    @isTest
    public static void testUpdatePayment(){
        ETI_TestUtilityClass.testUserCreation();
        System.runAs(ETI_TestUtilityClass.objUser){
            ETI_TestUtilityClass.testAccountCreation();
            ETI_TestUtilityClass.testCustomerVehicle();
            ETI_TestUtilityClass.testServiceRequest();
            ETI_TestUtilityClass.tesPaymentData();
            ETI_Inspection_Receipt__c objReceipt = new ETI_Inspection_Receipt__c(ET_Status__c = 'Active',
                                                                                 Service_Request__c= ETI_TestUtilityClass.objServiceReq.Id,
                                                                                 ETI_Amount__c=100);
            insert objReceipt;
            
            //ETI_PaymentTriggerHandler code coverage
            ETI_TestUtilityClass.objPayment.ETST_Payment_State__c ='CAPTURED';
            update ETI_TestUtilityClass.objPayment;
            
        }
        
    }
}