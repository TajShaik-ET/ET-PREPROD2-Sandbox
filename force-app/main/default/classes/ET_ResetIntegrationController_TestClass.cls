/********************************************************************************************************
* @author		Smaartt
* @description	Test Class for 'ET_ResetIntegrationController'
*********************************************************************************************************/
@isTest
public class ET_ResetIntegrationController_TestClass {
    @isTest static void testMethod1() {
        workOrder wo = new workOrder();
        Id recordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Inspection_Work_Order').getRecordTypeId();
        wo.StartDate = Datetime.Now(); 
        wo.Subject = 'Inspection';
        wo.ETI_Schedule_Appointment__c = true;  
        wo.Street  = 'Alfahidhi';
        wo.City = 'Dubai';
        wo.PostalCode = '531116';
        wo.Country ='United Arab Emirates';
        wo.Integration_Message__c = 'Pass';
        wo.Integration_Status__c = 'Pass';
        insert wo;
        
        ET_ResetIntegrationController.resetIntegrationMessageFields('workorder'+':'+wo.id);
    }
}