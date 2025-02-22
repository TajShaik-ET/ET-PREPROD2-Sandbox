public class ETI_B2B_FeedBackPageController {
    
    @Auraenabled
    public static string getVehIdFrmChassisNo(string chassis){
        list<ET_Customer_Vehicle__c> cv = [select id from ET_Customer_Vehicle__c where Chassis_No__c=:chassis];
        return cv[0].Id;
    }
    
    @Auraenabled
    public static List<Map<string,string>> getUserVehicles(id userId){
        List<Map<string,string>> plateCombinations=new List<Map<string,string>>();
        for(ET_Customer_Vehicle__c vehicle:[select Id,Name,Chassis_No__c ,Plate_Color__c,Plate_No__c from ET_Customer_Vehicle__c where OwnerId=:userId AND status__c = 'Active' order by createdDate desc]){
            if(vehicle.Plate_Color__c!=NULL && vehicle.Plate_Color__c!='' && vehicle.Plate_No__c !=NULL && vehicle.Plate_No__c !=''){
                plateCombinations.add(new Map<String,String>{'Id' => vehicle.Id, 'Name' =>vehicle.Plate_Color__c+'-'+vehicle.Plate_No__c});
            }else if(vehicle.Chassis_No__c !=NULL && vehicle.Chassis_No__c !=''){
                plateCombinations.add(new Map<String,String>{'Id' => vehicle.Id, 'Name' =>vehicle.Chassis_No__c});
            }
        }
        system.debug('plateCombinations>> '+plateCombinations);
        return plateCombinations;
    }
    
    @AuraEnabled   
    public static Id getRecordTypeId(string objName,string devName){
        
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(objName) ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByDeveloperName();
        Id rtId = RecordTypeInfo.get(devName).getRecordTypeId();
        
        return rtId;
    }
    
    @AuraEnabled 
    public static List<string> getCaseTypes(string caseRecordType) { //caseRecordType="Vehicle Inspection Services"
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        Map<String, Case_Dependent_Types__c> mapOfdependent = Case_Dependent_Types__c.getAll();
        List<string> typeValues = new List<String>();
        for(Case_Dependent_Types__c cdtypes:mapOfdependent.values()){
            System.debug('@@@@   ' +  cdtypes.Type_Name__c);
            if(cdtypes.Record_Type_Name__c == caseRecordType){
                typeValues.add(cdtypes.Type_Name__c);   
            }
        } 
        return typeValues;
    }
    
}