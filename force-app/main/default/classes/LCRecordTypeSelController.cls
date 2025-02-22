public with sharing class LCRecordTypeSelController {
   
    @AuraEnabled
    public static string findRecordTypes(string recId){
        
        List<Opportunity> vListOpps = [SELECT Id FROM Opportunity WHERE Id =: recId AND StageName ='Negotiation'];
        system.debug('vListOpps--->'+vListOpps);
        if(vListOpps.isEmpty())
            return 'false';
        string returnString='';
        string queryString='Select id, name from RecordType where sobjectType = \'Legal_Contract__c\' and IsActive=true';
        List<sobject> recordList= Database.query(queryString);
        List<RecordTypeWrapper> wrapperList=new List<RecordTypeWrapper>();
        for(sobject sb : recordList)  {
            RecordTypeWrapper rw=new RecordTypeWrapper();
            rw.recordTypeLabel=string.valueof(sb.get('name'));
            rw.recordTypeId=string.valueof(sb.get('id'));
            wrapperList.add(rw);
        } 
        returnString= JSON.serialize(wrapperList);
        system.debug('*****'+returnString);
        return returnString;
    }
    public class RecordTypeWrapper{
        public string recordTypeLabel{get;set;}
        public string recordTypeId{get;set;}
    }
}