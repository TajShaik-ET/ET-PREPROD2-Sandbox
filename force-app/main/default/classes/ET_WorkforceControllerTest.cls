@isTest(seeAlldata=false)
public class ET_WorkforceControllerTest {
    public static testMethod void getPicklistvaluesTestMethod1(){
        Workforce_Master__c workforce=new Workforce_Master__c(Workforce_Type__c='Driver');
        insert workforce;
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Driver_Category__c'},'Driver');
        test.stopTest();
    }
    public static testMethod void getPicklistvaluesTestMethod2(){
        Workforce_Master__c workforce=new Workforce_Master__c(Workforce_Type__c='Nanny');
        insert workforce;
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Nanny_Category__c'},'Nanny');
        test.stopTest();
    }
    public static testMethod void getPicklistvaluesTestMethod3(){
        Workforce_Master__c workforce=new Workforce_Master__c(Workforce_Type__c='Coordinator');
        insert workforce;
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Coordinator_Category__c'},'Coordinator');
        test.stopTest();
    }
    public static testMethod void getPicklistvaluesTestMethod4(){
        Workforce_Master__c workforce=new Workforce_Master__c(Workforce_Type__c='Supervisor');
        insert workforce;
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Supervisor_Category__c'},'Supervisor');
        test.stopTest();
    }
    public static testMethod void getPicklistvaluesTestMethod5(){
        Workforce_Master__c workforce=new Workforce_Master__c(Workforce_Type__c='Accountant/Cashier');
        insert workforce;
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Accountant_Category__c'},'Accountant');
        test.stopTest();
    }
 /*   public static testMethod void getPicklistvaluesTestMethod6(){
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Special_Requirements__c'},'Other Employee');
        test.stopTest();
    }*/
    public static testMethod void getPicklistvaluesTestMethod7(){
        Workforce_Master__c workforce=new Workforce_Master__c(Workforce_Type__c='Other Employee');
        insert workforce;
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Other_employee_Category__c'},'Other Employee');
        test.stopTest();
    }
    public static testMethod void getPicklistvaluesTestMethod8(){
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Special_requirements__c'},'Other Employee');
        test.stopTest();
    }
   
    public static testMethod void getPicklistvaluesTestMethod9(){
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Service_Emirate__c'},'Other Employee');
        test.stopTest();
    }
    public static testMethod void getPicklistvaluesTestMethod10(){
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Pricing_Method__c'},'Other Employee');
        test.stopTest();
    }
    
    public static testMethod void getPicklistvaluesTestMethod11(){
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Contract_Type__c'},'Accountant');
        test.stopTest();
    }
    public static testMethod void getPicklistvaluesTestMethod12(){
        test.startTest();
        ET_WorkforceController.getPicklistvalues('ET_Work_force__c',new List<String>{'ET_Service_Emirate__c'},'Accountant');
        test.stopTest();
    }
        
}