public class getPickListValues {
    
    
    public class getDetailsOnLoadWrapper {
        @AuraEnabled
        public List<String> getBadReasonValues;
       
    }
    
    @AuraEnabled(cacheable=true)
    
    public static getDetailsOnLoadWrapper getDetailsOnLoad(){
        
       getDetailsOnLoadWrapper onLoadWrapper = new getDetailsOnLoadWrapper();
        
        List<String> options = new List<String>();
        
        Schema.DescribeFieldResult fieldResult =
            Fleet_Inspection_Line_Item__c.ETT_Bad_Reason_Complaint__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getLabel());
        }  
        
      onLoadWrapper.getBadReasonValues = options;
        
        return onLoadWrapper;
         
    }   
}