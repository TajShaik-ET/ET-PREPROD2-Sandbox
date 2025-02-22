public class ETST_InvoiceController {
    public ET_Service_Request__c transportRequest {get;set;}
    public List<Invoice__c> invoiceList {get;set;}
    public string recordId;
    public string employerAddress {get;set;}
    public datetime dueDate {get;set;}
    public string selfAddress {get;set;}
    public string schoolName {get;set;}
    public string address {get;set;}
    public static ETST_Invoice_Address__mdt invoiceAddress {get;set;}
    
    public ETST_InvoiceController(){
        recordId = Apexpages.currentPage().getParameters().get('id');
        system.debug('recordId-->'+recordId);
        invoiceList = new List<Invoice__c>();
        invoiceAddress = new ETST_Invoice_Address__mdt();
        loadInvoices();
        if(invoiceList.size()==0){
            
        } 
    }
    public void loadInvoices(){
        invoiceAddress = [SELECT Id,DeveloperName,Line_1__c,Line_2__c,Line_3__c,Line_4__c,Line_5__c,Line_6__c
                                                   FROM ETST_Invoice_Address__mdt WHERE DeveloperName='Invoice_Address' LIMIT 1];
        invoiceList = [Select Id,Name,CreatedDate,Total_Inv_Amount__c,Service_Request__r.ETST_Service_Type__c,Service_Request__r.ETST_Transport_Type__c,Service_Request__r.Name,Service_Request__r.ETST_Status__c,
                       Service_Request__r.ETST_Pick_Up_From__c,Service_Request__r.ETST_Student_Name__c ,Service_Request__r.ETST_Drop_Off_To__c,Service_Request__r.ETST_Pick_Up_Start_Date__c,Service_Request__r.ETST_Pick_Up_End_Date__c,Service_Request__r.ETST_Paid_By__c,Service_Request__r.ETST_Student__r.ETST_Account_Name__c,Service_Request__r.ETST_Student__r.ETST_School_Name__r.Name from Invoice__c WHERE Service_Request__c=:recordId and ETST_Active__c=true limit 1];
        if(invoiceList.size()>0){ 
            dueDate = invoiceList[0].CreatedDate.addDays(5);
            schoolName = invoiceList[0].Service_Request__r.ETST_Student__r.ETST_School_Name__r.Name;
            List<Account> lstAccounts = [Select Id,name,BillingStreet,BillingCity,BillingState,BillingCountry,(Select Id,Name,ET_Line_1__c,ET_Line_2__c,ET_City__c,ET_Country__c from Addresses__r WHERE ET_Is_Primary__c=true) from Account WHERE Id=:invoiceList[0].Service_Request__r.ETST_Student__r.ETST_School_Name__c limit 1];
            if(lstAccounts.size()>0){
                address = lstAccounts[0].BillingStreet+ '\n' + lstAccounts[0].BillingCity +'\n' +lstAccounts[0].BillingCountry; 
                if(invoiceList[0].Service_Request__r.ETST_Paid_By__c == 'Self'){
                    selfAddress = lstAccounts[0].BillingStreet+ '\n' + lstAccounts[0].BillingCity +'\n' +lstAccounts[0].BillingCountry; 
                }
                else if(invoiceList[0].Service_Request__r.ETST_Paid_By__c == 'Employer' && lstAccounts[0].Addresses__r.size()>0){
                    employerAddress = lstAccounts[0].Addresses__r[0].ET_Line_1__c+ '\n' + lstAccounts[0].Addresses__r[0].ET_Line_2__c + '\n' +lstAccounts[0].Addresses__r[0].ET_City__c+ '\n' +lstAccounts[0].Addresses__r[0].ET_Country__c; 
                }
            }
        }
    } 
    
}