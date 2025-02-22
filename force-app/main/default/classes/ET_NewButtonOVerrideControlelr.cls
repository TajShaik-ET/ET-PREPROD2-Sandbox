public class ET_NewButtonOVerrideControlelr {
 @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){       
        String str = recordTypeLabel;
        system.debug('str'+str);
        Id recid = [Select Id from recordtype where name = :str  LIMIT 1].Id;
        System.debug('RecordType '+ recid);//Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }  
     @AuraEnabled
    public static sObject getrecordDetails(String objDetails,Id recId){       
          DescribeSObjectResult describeResult = recId.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
        String query =' SELECT ' +String.join( fieldNames, ',' ) +' FROM ' +describeResult.getName() +' WHERE ' +' id = :recId ' +' LIMIT 1 ';
        List<sObject> records = Database.query( query );
        system.debug('$$$$$$$Controller$$'+records);
       return records[0];
    }  
@AuraEnabled 
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        system.debug('$$$$$$$$$$$$$$$'+objFieldMap);
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
       
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
          system.debug('$$$$$$$$$$$$$$$'+theField);
      
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        system.debug('$$$$$$$$$$$$$$$'+depEntries);
      
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
       system.debug('$$$$$$$$$$$$$$$'+controllingValues);
        Map<String, Case_Dependent_Types__c> mapOfdependent = Case_Dependent_Types__c.getAll();
        system.debug('$$$$$$$$$$$$$$$'+mapOfdependent);
       system.debug('$$$$$$$$$$$$$$$--->'+objResults);
    /*    for (PicklistEntryWrapper plew : depEntries) {
                system.debug('$$$$$$$$$$'+plew);
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                 if (bit == '1') {
                    system.debug('---------$$$'+controllingValues.get(i));
                    system.debug('---------$$$'+objResults.get(controllingValues));
                    
                     system.debug('---------$$$'+objResults.get(controllingValues.get(i)));
                     objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
         */
          
               for(Case_Dependent_Types__c cdtypes:mapOfdependent.values()){
                     objResults.get(cdtypes.Record_Type_Name__c).add(cdtypes.Type_Name__c);
                   
               }
        
        system.debug('$$$$$$$$$$$$$$$'+objResults);
     
        return objResults;
    }
    
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
}