/***
Class       : ETST_ReceiptPageontrollerTest
Author      : Sreelakshmi SK
CreatedDate : 19.05.2023
Description : 
***/
@IsTest
public class ETST_ReceiptPageControllerTest {
    @IsTest
    static void testLoadInvoices() {
        ET_Service_Request__c serviceRequest = new ET_Service_Request__c(ETST_Payee__c = 'Test');
        insert serviceRequest;
        
        PageReference pageRef = Page.ETST_ReceiptPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', serviceRequest.Id);
        
        ETST_ReceiptPageController controller = new ETST_ReceiptPageController();
        controller.serviceRequest = serviceRequest;
    }
    
    @IsTest
    static void testConstructorWithNoReceipts() {
        ET_Receipt__c receipt = new ET_Receipt__c(
        //   Payment_Mode__c = 'Bank Transfer'
        );
        insert receipt;
        
        PageReference pageRef = Page.ETST_ReceiptPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', receipt.Id);
        
        ETST_ReceiptPageController controller = new ETST_ReceiptPageController();
        
    }
}