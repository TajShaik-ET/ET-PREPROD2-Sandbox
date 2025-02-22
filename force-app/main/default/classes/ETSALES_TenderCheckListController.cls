public class ETSALES_TenderCheckListController {
    @auraEnabled
    public List<User> userList {get;set;}
    @auraEnabled
    public List<String> statusList {get;set;}
    @auraEnabled
    public List<ETSALES_checklist__c> checklist{get;set;}
    
    @auraEnabled
    public static ETSALES_TenderCheckListController handleCheckList(String tenderId){
        ETSALES_TenderCheckListController lexObj = new ETSALES_TenderCheckListController();
        List<ETSALES_Tender__c> currentTender = [SELECT Id, Name, 
                                                 (SELECT Id,ETSALES_Tender__c,ETSALES_Checklist__c  FROM Check_List_Lines__r WHERE ETSALES_Tender__c =:tenderId)
                                                 FROM ETSALES_Tender__c WHERE Id =:tenderId];
        Set<Id> addedCheckListSet = new Set<Id>();
        for(ETSALES_Tender__c tenderItem : currentTender){
            for(ETSALES_Check_List_Lines__c lineItem : tenderItem.Check_List_Lines__r){
                addedCheckListSet.add(lineItem.ETSALES_Checklist__c);
            }
        }if(!addedCheckListSet.isEmpty()){
            lexObj.checklist =  [SELECT Id, Name,ETSALES_Active__c FROM ETSALES_checklist__c where ETSALES_Active__c = True AND Id Not IN: addedCheckListSet];
        }else{
            lexObj.checklist =  [SELECT Id, Name,ETSALES_Active__c FROM ETSALES_checklist__c where ETSALES_Active__c = True];
        }
        
        // check if existing checkList lines are there in tender and if there - show them to user for updating
        // if no existing CheckList Lines - give user option to add new Details
        List<User> userList = [SELECT Id,Name from User WHERE isActive = TRUE];
        lexObj.userList = userList;
        
        Schema.DescribeFieldResult statusVal = ETSALES_Check_List_Lines__c.ETSALES_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = statusVal.getPicklistValues();
        List<String> tempList = new List<String>();
        for( Schema.PicklistEntry pickListVal : ple){
            
            tempList.add(pickListVal.getLabel());
            
        }
        lexObj.statusList = tempList;
        
        system.debug(JSON.serializePretty(lexObj));
        return lexObj;
        
        
    }
    
    @auraEnabled
    public static String saveCheckList(List<ETSALES_Check_List_Lines__c> checkListItems , String tenderId){
        String response;
        List<ETSALES_Check_List_Lines__c> lstCheckList = new List<ETSALES_Check_List_Lines__c> ();
        
        system.debug('=====checkListItems========='+checkListItems);
        if(!checkListItems.isEmpty()){
            for(ETSALES_Check_List_Lines__c newItem: checkListItems ){
                ETSALES_Check_List_Lines__c instanceItem = new ETSALES_Check_List_Lines__c();
                system.debug('---------------------for loop---------------------------------');
                instanceItem.ETSALES_Checklist__c= newItem.Id;
                instanceItem.ETSALES_Tender__c = tenderId;
                instanceItem.ETSALES_Assign_To__c = newItem.ETSALES_Assign_To__c;
                instanceItem.ETSALES_AddChecklist__c = newItem.ETSALES_AddChecklist__c;
                instanceItem.ETSALES_Required__c = newItem.ETSALES_Required__c;
                instanceItem.ETSALES_Status__c = newItem.ETSALES_Status__c;
                
                lstCheckList.add(instanceItem);
            }
        }
        
        try{
            system.debug('-------list to insert-------'+lstCheckList);
            insert lstCheckList;
            //throw new AuraHandledException('Error in Creating Check list for Tender: Duplicate Detected');
        }
        catch(exception e){
            system.debug('Error Message=>'+e.getMessage());
            String error = e.getMessage();
            if(error.contains('DUPLICATES_DETECTED')){
                system.debug('Duplicate Detected');
                throw new AuraHandledException('Error in Creating Check list for Tender: Duplicate Detected');
                
            }
            
        }
        return response = 'Success' ;
    } 
}