public class ETST_ReceiptPageController {
    public ET_Service_Request__c serviceRequest {get;set;}
    public List<ET_Receipt__c> receiptList {get;set;}
    public string recordId;
    public ETST_ReceiptPageController(){
        recordId = Apexpages.currentPage().getParameters().get('id');
        system.debug('recordId-->'+recordId);
        receiptList = new List<ET_Receipt__c>();
        loadInvoices();
        if(receiptList.size()==0){
        } 
    }
    public void loadInvoices(){
       system.debug('recordId-->'+recordId);  
        // Changed where condition to Id=:recordId --- Sreelakshmi SK 15/5/23
        if(recordId.startsWith('a3')){
            receiptList = [Select Id,Name,CreatedDate,ET_Amount__c,Payment_Mode__c,ET_Service_Request__r.ETST_Student_Name__c,ET_Service_Request__r.ETST_Student__r.ETST_School__r.Name,ET_Service_Request__r.ETST_Service_Type__c,ET_Service_Request__r.ETST_Transport_Type__c,
                       ET_Service_Request__r.ETST_Pick_Up_From__c,ET_Service_Request__r.ETST_Drop_Off_To__c,ET_Service_Request__r.ETST_Pick_Up_Start_Date__c,ET_Service_Request__r.ETST_Pick_Up_End_Date__c,
                       ET_Service_Request__r.ETST_Paid_By__c,ET_Service_Request__r.ETST_Student__r.ETST_Account_Name__c FROM ET_Receipt__c WHERE Id=:recordId limit 1];
        }else if (recordId.startsWith('a1')){
        receiptList = [Select Id,Name,CreatedDate,ET_Amount__c,Payment_Mode__c,ET_Service_Request__r.ETST_Student_Name__c,ET_Service_Request__r.ETST_Student__r.ETST_School__r.Name,ET_Service_Request__r.ETST_Service_Type__c,ET_Service_Request__r.ETST_Transport_Type__c,
                       ET_Service_Request__r.ETST_Pick_Up_From__c,ET_Service_Request__r.ETST_Drop_Off_To__c,ET_Service_Request__r.ETST_Pick_Up_Start_Date__c,ET_Service_Request__r.ETST_Pick_Up_End_Date__c,
                       ET_Service_Request__r.ETST_Paid_By__c,ET_Service_Request__r.ETST_Student__r.ETST_Account_Name__c FROM ET_Receipt__c WHERE ET_Service_Request__c=:recordId limit 1];
        }
    }
    
}