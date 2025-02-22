global class ET_ResetIntegrationController {
    
/********************************************************************************************************
* @author		Smaartt
* @description	Quick action ligthning component helper invokes this method.
* @param		objToIDString (String) : ObjectName and recordId value is seperated with ':'
* @return		Boolean
*********************************************************************************************************/
    @AuraEnabled
    global static Boolean resetIntegrationMessageFields(String objToIDString){
        System.debug('---objToIDString--'+objToIDString);
        // Variable to indicate error
        Boolean hasError=True;
        String objName;
        String recordId;
        List<sObject> sObjrecords = new List<sObject>();
        //List of String deducted from  objToIDString string split based on ':' 
        list<String> oNameAndRecordId=objToIDString.split(':');
        //sObject Name e.g. WorkOrder
        objName=oNameAndRecordId[0];
        //sObject Record Id
        recordId=oNameAndRecordId[1];
        System.debug('---objName--'+objName+'---recordId---'+recordId);

        String queryString='SELECT '+
            ' Id,Integration_Message__c,Integration_Status__c from '+ objName +
            ' WHERE ID = :recordId';
        System.debug('--queryString--'+queryString);
        //sObject records return via query String
        sObjrecords.addAll(System.Database.query(queryString));
        System.debug('---records--'+sObjrecords);
        
        
        //Iterate the sObject Records
        
        for(sObject sobjInst:sObjrecords){
            if(sobjInst.get('Integration_Message__c') != null){
                sobjInst.put('Integration_Message__c',null);
                sobjInst.put('Integration_Status__c','In Progress');
                //sobjInst.put('Synchronize__c',false);
            }
            System.debug('--Integration_Message__c--'+sobjInst);
        }
        try{
            update sObjrecords;
            system.debug('-->1'+objToIDString);
            if(recordId.startsWith('a21')){
               system.debug('-->2'+objToIDString);
         	  
            }
            if(recordId.startsWith('0WO')){
               system.debug('-->2'+objToIDString);
         	  //ET_SOA_Services.syncTestResultsToAMAN(String locationCode,String receiptNumber,String testResult);
            }
            hasError=False;
        }catch(Exception e){
            system.debug('Error >>' +e.getMessage());
        }
        return hasError;
    }
    
}