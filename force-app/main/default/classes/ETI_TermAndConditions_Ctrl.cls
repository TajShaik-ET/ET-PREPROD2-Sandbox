public class ETI_TermAndConditions_Ctrl {
    public String variant;
    public List<ET_Terms_and_Conditions__c> termsAndConditionsList {get; set;}
    public ETI_TermAndConditions_Ctrl(){
        variant = ApexPages.currentPage().getParameters().get('variant');
        variant =  setVariant(variant);
        getETI_Terms_and_Conditions();
    }
    public string setVariant(String type){
        switch on type {
            when 'Registered' { 
                return 'Vehicle Registration';
            }   
            when 'Un-Registered' {
                return 'Vehicle Unregistered';
            }
            when 'Payment' {
                return 'Payment Page';
            }
            when else { 
                return '';
            }
        }
    }
    public void getETI_Terms_and_Conditions(){
        System.debug(variant);
        termsAndConditionsList = [SELECT Id,ET_Condition__c,Place_of_Visisbility__c,Header_Line__c,Footer_Text__c  
                                  FROM ET_Terms_and_Conditions__c WHERE Place_of_Visisbility__c = :variant order by Order__c];
    }
    @AuraEnabled
    public static List<ET_Terms_and_Conditions__c> getTermsandConditions(String Visisbility){
        System.debug(Visisbility);
        list<ET_Terms_and_Conditions__c> termsAndConditionsList=new list<ET_Terms_and_Conditions__c>();
        if(Visisbility!=null && Visisbility!=''){
            termsAndConditionsList = [SELECT Id,ET_Condition__c,ET_Service_Name__c,Place_of_Visisbility__c,Header_Line__c,Footer_Text__c  
                                             FROM ET_Terms_and_Conditions__c WHERE Place_of_Visisbility__c = :Visisbility AND ET_Service_Name__c='Vehicle Inspection' order by Order__c];
        }
        return termsAndConditionsList;  
    }
    
}