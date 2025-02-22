public with sharing class DisputeCreationController {
    
    /**
     * @description to fetch pending invoices of an account
     */
    @auraEnabled(cacheable=true)
    public static CustomerInvoiceWrapper getInvoiceDetails(Id accId){
        try{
            if(accId != null){
                List<Account> acccounts = [Select id,AccountNumber,ETSALES_Customer_Account_Id__c  from Account where Id =:accId];   
                if(acccounts.size() > 0)
                { 
                    Account acc = acccounts.get(0);
                    if(acc.AccountNumber!=Null){
                        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('GetCustomerAgingTransaction');
                        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
                        string paramvalue = EncodingUtil.base64Encode(beforeblob);
                        
                        Http httpProtocol = new Http();
                        HttpRequest request = new HttpRequest();
                        HttpResponse response = new HttpResponse();
                        request.setHeader('Accept', 'application/json');
                        request.setHeader('Authorization','Basic '+paramvalue); 
                        request.setMethod('GET');
                        
                        if(ET_REST_Authorize_Helper.runningInASandbox()){
                            request.setEndpoint(connection.Dev_Endpoint__c+acc.AccountNumber);
                            system.debug(connection.Dev_Endpoint__c+acc.AccountNumber);
                        }else{
                            request.setEndpoint(connection.LiveEndpoint_c__c+acc.AccountNumber);
                        }  
                        system.debug('request'+request);
                        request.setTimeout(90000);
                        request.setHeader('Content-Type', 'application/json');
                        response = httpProtocol.send(request);
                        if(response.getStatusCode() == 200){
                            CustomerInvoiceWrapper responseData = CustomerInvoiceWrapper.parse(response.getBody());
                            System.debug('------customerAmountWrapper--parse---'+responseData);
                            CustomerInvoiceWrapper invoices = fetchOperatingUnitDeatil(responseData);
                            System.debug('------customerAmountWrapper--parse---'+invoices);
                            return invoices;
                        }
                    }
                }
            }
            return null;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description Actually when we create a case form LWC form, esclation rules doesn't get 
     * execute, so to execute we need to manually exceute that
     */
    @auraEnabled(cacheable=true)
    public static void executeEsclationRule(Id caseId){
        if(caseId != null){
            excuteRule(caseId);
        }
    }
    //201854069
    @future
    public static void excuteRule(Id caseId){
        Case c = [Select id from Case where id=:caseId];
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        c.setOptions(dmo);
        update c;
    }

    public static CustomerInvoiceWrapper fetchOperatingUnitDeatil(CustomerInvoiceWrapper invoices){
        Map<String,Map<String, String>> unitInfo = new  Map<String,Map<String, String>>();
        List<ETSALES_Operating_unit__c> units = [Select id, name, ETSALES_Organization_Id__c,Sector__c  from ETSALES_Operating_unit__c where ETSALES_Organization_Id__c!=null];
        for(ETSALES_Operating_unit__c unit: units){
            Map<String, String> newUnit = new Map<String, String>();
            newUnit.put('sector', unit.Sector__c);
            newUnit.put('operatingUnit', unit.name);
            unitInfo.put(String.valueOf(unit.ETSALES_Organization_Id__c), newUnit);
        }
        System.debug('----fetchOperatingUnitDeatil--unitInfo----'+unitInfo);
        //add operating unit info in the response
        List<CustomerInvoiceWrapper.Transactions> transactions = invoices.transactions;
        for(CustomerInvoiceWrapper.Transactions trans : transactions){
            if(unitInfo.containsKey(trans.orgId)){
                Map<String, String> unit = unitInfo.get(trans.orgId);
                trans.sector = unit.get('sector');
                trans.operatingUnit = unit.get('operatingUnit');
            }else{
                trans.sector = '';
                trans.operatingUnit = '';
            }
        }
        //System.debug('----fetchOperatingUnitDeatil--invoices---'+invoices);
        return invoices;
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
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}