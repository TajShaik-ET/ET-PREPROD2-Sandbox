public class ETC_ReceiptPageController {
    
    public List<ET_Receipt__c> receiptList {get;set;}
    public string recordId;
    
    public ETC_ReceiptPageController(){
        
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=PaymentReceipt.pdf'); 
        recordId = Apexpages.currentPage().getParameters().get('id');
        system.debug('recordId-->'+recordId);
        receiptList = new List<ET_Receipt__c>();
        loadReceipts();
    
    }
    
    public void loadReceipts(){
        
        receiptList = [SELECT CreatedDate,ET_Amount__c,ETC_Vehicle_Bookings_Total__c,ET_Service_Request__r.Name,Id,Name,OwnerId,Payment_Mode__c,RecordTypeId FROM 
                       ET_Receipt__c WHERE 
                       ET_Service_Request__c=:recordId order by createddate desc limit 1];
        
    }
}