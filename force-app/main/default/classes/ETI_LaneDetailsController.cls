public class ETI_LaneDetailsController {
    
    @AuraEnabled
    public static List<ETI_Booking__c> getLaneDetailsBookings(String recordId){
        return [SELECT Id, Booking_Date__c, Booking_Status__c FROM ETI_Booking__c where Allocated_Lane__r.Id = :recordId and (Booking_Status__c = 'Drafte' or Booking_Status__c = 'Booked')];
    }

    @AuraEnabled
    public static ETI_Lane_Details__c getLaneDetails(String recordId){
        return [SELECT Id, Lane_Status__c, From_Date__c, To_Date__c FROM ETI_Lane_Details__c where Id = :recordId];
    }
    
    @AuraEnabled
    public static string updateLaneStatus(map<string,string> mapofStageJsonList){
        ETI_Lane_Details__c laneDetailsObj;
        if(mapofStageJsonList.containskey('laneDetails')){
            laneDetailsObj = (ETI_Lane_Details__c) JSON.deserialize(mapofStageJsonList.get('laneDetails'),Type.forname('ETI_Lane_Details__c'));
        }
        if(laneDetailsObj!=null){
            List<ETI_Booking__c> lstBoolings = [SELECT Id, Allocated_Lane__r.Id FROM ETI_Booking__c where Allocated_Lane__r.Id = :laneDetailsObj.Id];
            try{
                System.debug(laneDetailsObj);
                upsert laneDetailsObj;
            }Catch(Exception ex){
                system.debug('******Exception Cause *****');
                throw new AuraHandledException(ex.getMessage());
            }
            return laneDetailsObj.Id;
        }
        return null;
    }
    
    //This is for Preparing the Dynamic Pick list Values for Combination
    @AuraEnabled
    public static Map<String, String> getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        Map<String, String> options = new Map<String, String>();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
            options.put(a.getValue(), a.getLabel());
        }
        allOpts.sort();
        System.debug(options);
        return options;
    }
    
    
}