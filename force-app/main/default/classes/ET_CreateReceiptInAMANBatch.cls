/********************************************************************************************************
* @author           Smaartt
* @description      Batch to create receipt record in AMAN system.
* @Name             ET_CreateReceiptInAMANBatch
*********************************************************************************************************/
global class ET_CreateReceiptInAMANBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.stateful{ 
    
    //global variable declaration.
    List<ETI_Inspection_Receipt__c> receipts = new List<ETI_Inspection_Receipt__c>();
    Public String sQuery;
    public Date todayDate;
    
    public void Execute(SchedulableContext sc){
        ET_CreateReceiptInAMANBatch batchCreateReceipt = new ET_CreateReceiptInAMANBatch(null);
        Database.executeBatch(batchCreateReceipt,1);
    }
    
    public ET_CreateReceiptInAMANBatch(Date runDate) {
        this.todayDate = runDate!=null ? runDate:Date.Today();
        sQuery = 'SELECT Id, Name,Booking__c FROM ETI_Service_Line_Item__c WHERE Booking__r.Booking_Date__c=:todayDate'+ 
            ' AND AMAN_Receipt_No__c=Null AND Booking__r.Booking_Status__c <> \'Cancelled\'' ;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<ETI_Service_Line_Item__c> scope) {
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}