@isTest(seeAlldata=false)
public class ET_FieldDescribeUtilTest {
    public static testMethod void getPicklistvaluesTestMethod(){
        Test.startTest();
         ET_FieldDescribeUtil.getDependentOptionsImpl(ET_Service_Request_Common_Data__c.ET_Pricing_Type__c.getDescribe().getSObjectField(),ET_Service_Request_Common_Data__c.ET_Pricing_Method__c.getDescribe().getSObjectField());
    	Test.stopTest();
    }
}