/*
* File Name:ETI_Batch_Employee_Service
* Author : Sagar Kambli
* CreatedDate :  01 June 2020
* Modification Purpose
* * 1. Sagar: Batch to load all employee Details
* * 2.srihari: commented code because employe service is not using 18-01-2023
*/ 
global class ETI_Batch_Employee_Service {
    public static void codecheck(){
        
    }
  /* implements Database.Batchable<ETEmployee.EmployeeData_element>, Database.AllowsCallouts,Database.stateful 
   * public static List<ETEmployee.EmployeeData_element> employeeList{get;set;}
    public  String employeeNumber {get;set;}
    public  Date  lastModifiedDate {get;set;}
    global Map<String, String> errorMap;
    global Map<String, String> successMap;
    global String baseURL;

    public ETI_Batch_Employee_Service(String employeeNumber, Date lastModifiedDate) {
        this.employeeNumber = employeeNumber;
        this.lastModifiedDate = lastModifiedDate;
        errorMap = new Map<String, String>();
        successMap = new Map<String, String>();
        baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        employeeList = new List<ETEmployee.EmployeeData_element>();
    }
    
    global Iterable<ETEmployee.EmployeeData_element> start(Database.BatchableContext BC) {
        ETEmployeeService.execute_pt service = new ETEmployeeService.execute_pt();
        ETEmployee.OutputType employeeResult = service.execute(employeeNumber,lastModifiedDate);
        if(employeeResult!=null)
        {
            employeeList = employeeResult.EmployeeData;
        	return new ET_Employee_Iterable(employeeList);
        }
        return null;
    } 
     
    global void execute(Database.BatchableContext BC, List<ETEmployee.EmployeeData_element> employeeData) {
        List<Account> employeeToInsert = ET_EmployeeServiceSchedule.doEmployeeMapping(employeeData);
        if(employeeToInsert!=null && employeeToInsert.size()>0){
            Database.UpsertResult[] results = Database.upsert(employeeToInsert, Account.ETT_ERP_Number__c);
            for(Integer index = 0, size = results.size(); index < size; index++) {
                if(results[index].isSuccess()) {
                    String sucMsg = baseURL + '/' + employeeToInsert[index].Id;
                    if(results[index].isCreated()) {
                        sucMsg += ':' + employeeToInsert[index].ETT_ERP_Number__c + ':created';
                        System.debug(employeeToInsert[index].ETT_ERP_Number__c +' was created');
                    } else {
                        sucMsg += ':' + employeeToInsert[index].ETT_ERP_Number__c + ':updated';
                        System.debug(employeeToInsert[index].ETT_ERP_Number__c +' was updated');
                    }

                    successMap.put(employeeToInsert[index].Id, sucMsg);
                }
                else{
                    String errMsg = results[index].getErrors()[0].getMessage();
                    errorMap.put(employeeToInsert[index].ETT_ERP_Number__c, errMsg);
                }
            }
        }
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
        ET_Common_Util.sendEmail('ERP Employee Daily Job - Result for ETI_Batch_Employee_Service', new string[]{'sagar.kambli@smaartt.com'}, null, null,'Data Results' ,successMap,errorMap);
        system.debug('Completed processing ERP Employee Service successfully......');
    }

   */
}