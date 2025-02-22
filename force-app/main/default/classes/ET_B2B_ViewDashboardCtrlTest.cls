@isTest
public class ET_B2B_ViewDashboardCtrlTest {
    
    private static testmethod void viewDashboard(){
        
         Account acc = new Account();
         acc.Name ='Test';
        insert acc;
        Account acc1 = new Account();
        acc1.Name ='Testjana';
        acc1.ParentId=acc.id;
        insert acc1;
        
        
        ET_Sales_Agreement__c sa = new ET_Sales_Agreement__c();
        sa.name ='SA1';
        sa.Customer_PO_No__c='SA1';
        sa.Salesforce_Customer__c=acc.Id;
        insert sa;
        
        SALine_Assigned_Resource__c sla = new SALine_Assigned_Resource__c();
        sla.Sales_Agreement__c=sa.id;
        insert sla;
        SALine_Assigned_Vehicle__c slv = new SALine_Assigned_Vehicle__c();
        slv.Sales_Agreement__c=sa.id;
        slv.Name='B001234';
        insert slv;
        
      ET_B2B_ViewDashboardCtrl.getAssignedResources(acc.Id,true);    
      ET_B2B_ViewDashboardCtrl.getAssignedVehicles(acc.Id,true);
        
    }

}