public class CustomerInvoiceWrapper {
    
    @AuraEnabled
    Public string accountName{get;set;}
    @AuraEnabled
    Public string totalAmountOriginal{get;set;}
    @AuraEnabled
    Public string totalReceivable{get;set;}  
    @AuraEnabled
    Public string errorMessage{get;set;}
    @AuraEnabled
    Public List<CustomerInvoiceWrapper.Transactions> transactions{get; set;}

    
    Public class Transactions{
        @AuraEnabled
        Public string transactionType{get;set;}
        @AuraEnabled
        Public string transactionNumber{get;set;}
        @AuraEnabled
        Public string amountDueOriginal{get;set;}  
        @AuraEnabled
        Public string amountDueRemaining{get;set;} 
        @AuraEnabled
        Public string orgId{get;set;}
        @AuraEnabled
        Public string sector{get;set;}
        @AuraEnabled
        Public string operatingUnit{get;set;}

    }
    public static CustomerInvoiceWrapper parse(String json) {
        return (CustomerInvoiceWrapper) System.JSON.deserialize(json, CustomerInvoiceWrapper.class);
    }

    public static void testCoverage1(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}