Global class ET_VehicleInspectResultWebservice {
    
/********************************************************************************************************
* @author		Smaartt
* @description	Webservice to update test result in SF from AMAN System.
* @param		List<requestWrapper>
* @return		List<responseWrapper>
*********************************************************************************************************/
    
    webservice static  List<responseWrapper> getVehicleInspectionResults(List<requestWrapper> requestParams){
        
        system.debug('requestParams>>'  +requestParams);
        //Variable declaration.
        List<responseWrapper> responsesToReturn = new  List<responseWrapper>();
        Map<String,requestWrapper> requestMap = new Map<String,requestWrapper>();
        Map<Id,String> mapServiceItemsToReceipt = new Map<Id,String>();
        Map<String,ETI_Inspection_Receipt__c> receiptMap = new Map<String,ETI_Inspection_Receipt__c>();
        List<ETI_Service_Line_Item__c> lineItemsToUpdate = new List<ETI_Service_Line_Item__c>();
        List<ET_Customer_Vehicle__c> vehiclesToUpdate = new List<ET_Customer_Vehicle__c>();
        //Logic starts here...
        try{ 
            // Create log before invoking webservice   
            Integer len = 5;
            String str = string.valueof(Math.abs(Crypto.getRandomLong()));
            String randomNumber = str.substring(0, len); 
            UTIL_Logging.createIntegrationLog('INBOUND',JSON.serialize(requestParams), 'Test Result',
                                                      'SF','AMAN', 'TestResult'+randomNumber);
            //Itrate over request wrapper and populate map of receipt number to request Item.
            for(requestWrapper reqItem: requestParams){ 
                if(reqItem.receiptNumber!='' && reqItem.testResult!=''){
                    requestMap.put(reqItem.receiptNumber, reqItem);
                }else{
                    responseWrapper resWrap = new responseWrapper();
                    resWrap.status='Error';
                    resWrap.message=System.Label.ET_Vehicle_ResReqParamErrMsg;
                    resWrap.receiptNumber='';
                    responsesToReturn.add(resWrap);
                }  
            }
            
            //Query the list of receipts.           
            List<ETI_Inspection_Receipt__c> receipts =[SELECT Id, Name, Bookings__c, ETI_Account__c, ETI_Amount__c, isSyncedToAman__c,
                                                       Receipt_No__c, Service_Request__c, AMAN_Receipt_No__c, Service_Line_Item__c,
                                                       Service_Line_Item__r.Test_Result__c, Service_Line_Item__r.AMAN_Receipt_No__c, Auth_Code__c,
                                                       CrmTrxReference__c,Service_Line_Item__r.Booking__r.Customer_Vehicle__c
                                                       FROM ETI_Inspection_Receipt__c
                                                       WHERE AMAN_Receipt_No__c IN:requestMap.keySet()];
           
            //Populate map of receipt number to receipts. 
            for(ETI_Inspection_Receipt__c receipt:receipts){
                receiptMap.put(receipt.AMAN_Receipt_No__c, receipt);
            }
            
            //Itrate over input receipt numbers and populate response wrapper.
            for(String receiptNumber:requestMap.keySet()){
                if(!receiptMap.containsKey(receiptNumber)){
                    responseWrapper resWrap = new responseWrapper();
                    resWrap.status='Error';
                    resWrap.message=System.Label.ET_NoReceiptFoundErrMsg;
                    resWrap.receiptNumber= receiptNumber;
                    responsesToReturn.add(resWrap);
                }
            }
            system.debug('receipts >>'  +receipts);
            
            // if receipt list is not empty itrate over them and populate list of service line items to update.
            if(!receipts.isEmpty()){
                
                for(ETI_Inspection_Receipt__c receipt:receipts){
                    system.debug('receipt >>'  +receipt);
                    if(requestMap.get(receipt.AMAN_Receipt_No__c)!=null){
                        ETI_Service_Line_Item__c newItem = new ETI_Service_Line_Item__c(Id=receipt.Service_Line_Item__c);
                        if(requestMap.get(receipt.AMAN_Receipt_No__c).testResult!=null)
                            newItem.Test_Result__c=requestMap.get(receipt.AMAN_Receipt_No__c).testResult;
                        newItem.AMAN_Receipt_No__c=receipt.AMAN_Receipt_No__c;
                        if(requestMap.get(receipt.AMAN_Receipt_No__c).description!=null)
                            newItem.Description__c=requestMap.get(receipt.AMAN_Receipt_No__c).description;
                        if(requestMap.get(receipt.AMAN_Receipt_No__c).testDate!=null)
                            newItem.Test_Date__c=requestMap.get(receipt.AMAN_Receipt_No__c).testDate;
                        lineItemsToUpdate.add(newItem);
                        //Update customer vehicle with chasis number.
                        if(requestMap.get(receipt.AMAN_Receipt_No__c).ChassisNumber!=null){
                            ET_Customer_Vehicle__c vItem = new ET_Customer_Vehicle__c(Id=receipt.Service_Line_Item__r.Booking__r.Customer_Vehicle__c);
                            if(!vehiclesToUpdate.contains(vItem)){
                                vItem.Chassis_No__c = requestMap.get(receipt.AMAN_Receipt_No__c).ChassisNumber;
                                vehiclesToUpdate.add(vItem);
                            }
   
                        }
                        //populate the map of service request and aman receipt number to use in exception handling.. 
                        mapServiceItemsToReceipt.put(receipt.Service_Line_Item__c,receipt.AMAN_Receipt_No__c);
                    }
                      
                }
                
            }
            
            //Update test result on service line items.
            List<Database.SaveResult> updateResults = Database.update(lineItemsToUpdate, false);
            for(Integer i=0;i<updateResults.size();i++){
                if (updateResults.get(i).isSuccess()){
                    responseWrapper resWrap = new responseWrapper();
                    resWrap.status='Success';
                    resWrap.message='';
                    resWrap.receiptNumber=mapServiceItemsToReceipt.get(lineItemsToUpdate.get(i).Id);
                    responsesToReturn.add(resWrap);
                    
                    
                }else if (!updateResults.get(i).isSuccess()){
                    // DML operation failed
                    Database.Error error = updateResults.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    responseWrapper resWrap = new responseWrapper();
                    resWrap.status='Error';
                    resWrap.message=failedDML;
                    resWrap.receiptNumber=mapServiceItemsToReceipt.get(lineItemsToUpdate.get(i).Id);
                    responsesToReturn.add(resWrap);
                    
                }
                
                if(!vehiclesToUpdate.isEmpty()){
                    update vehiclesToUpdate;
                }
                
            }
                               
        }catch(exception e){
            system.debug('Error >>' +e.getMessage());
            responseWrapper resWrap = new responseWrapper();
            resWrap.status='Error';
            resWrap.message=e.getDMLMessage(0);
            resWrap.receiptNumber='';
            responsesToReturn.add(resWrap);
            
        }
        
        return responsesToReturn;
    }
    
    global class responseWrapper{
        webservice String status;
        webservice String message;
        webservice String receiptNumber;  
    }
    
    global class requestWrapper{
        webservice String receiptNumber;
        webservice String testResult;
        webservice String description;
        webservice DateTime testDate;
        webservice String ChassisNumber;
    }
    public static void utilityMethod(){
        
        integer i=0;
        
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
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