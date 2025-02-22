public class tenderHandler {

    @auraEnabled
    public static String handleCheckList(String tenderId){
        List<ETSALES_checklist__c> chekLists = new List<ETSALES_checklist__c>();
        chekLists =  tenderHandler.getCheckListDetails();
        
        // check if existing checkList lines are there in tender and if there - show them to user for updating
        // if no existing CheckList Lines - give user option to add new Details
         List<ETSALES_Check_List_Lines__c> chekListLines = new List<ETSALES_Check_List_Lines__c>();
          chekListLines =  tenderHandler.getCheckListLineDetails(tenderId);
        
        //iterate over CheckLists and Create checkListWrapper
        List<checkListWrapper> chWList = new List<checkListWrapper>();
        if(chekListLines != null && chekListLines.size() > 0){
            for(ETSALES_Check_List_Lines__c ch : chekListLines){
                checkListWrapper chW = new checkListWrapper();
                chW.Name = ch.ETSALES_Checklist__r.name;
                chW.Status = ch.ETSALES_Status__c;
                chW.checkListLineId = ch.Id;
                chWList.add(chW);
            }
        }
        else{
            //iterate over CheckLists and Create checkListWrapper
            if(chekLists != null && chekLists.size() > 0){
                for(ETSALES_checklist__c ch : chekLists){
                    checkListWrapper chW = new checkListWrapper();
                    chW.Name = ch.Name;
                    chWList.add(chW);
                }
            }
            
        }
 
        return JSON.serializePretty(chWList);
        
        
    }
    
    @auraEnabled
    public static String saveCheckList(String checkListItems , String tenderId){
        
        String response;
		List<checkListWrapper> chcklIst = new List<checkListWrapper>();
        chcklIst = (List<checkListWrapper>) JSON.deserializeStrict(checkListItems, List<checkListWrapper>.class);
        
        // attach above checkList Items to Teder
        List<ETSALES_checklist__c> chekLists = new List<ETSALES_checklist__c>();
        chekLists =  tenderHandler.getCheckListDetails();
        
        Map<String, String> checkListMap = new  Map<String, String>(); //  Key = CheckListName && Value = CheckListId
        if(chekLists != null && chekLists.size() > 0){
            for(ETSALES_checklist__c ch : chekLists){
                checkListMap.put(ch.name , ch.Id);
            }
        }
        
        // Create checkList Lines
        List<ETSALES_Check_List_Lines__c> linesList = new List<ETSALES_Check_List_Lines__c>();
        for(checkListWrapper chWr : chcklIst){
            ETSALES_Check_List_Lines__c lines = new ETSALES_Check_List_Lines__c();
            if(checkListMap.containsKey(chWr.name)){
                lines.ETSALES_Checklist__c = checkListMap.get(chWr.name);
            }
            if(chWr.checkListLineId != null && chWr.checkListLineId != ''){
                system.debug('checkListLineId = '+ chWr.checkListLineId);
                lines.Id = chWr.checkListLineId;
            }
            
            lines.ETSALES_Tender__c = tenderId;
            
            lines.ETSALES_Status__c = chWr.Status;
            
            linesList.add(lines);
            
        }
        
        if(linesList.size() > 0){
            upsert linesList;
            response = 'Success';
        }
        
        return response;
        
        
    }
    
    public class checkListWrapper{
        @auraEnabled
        public String Name;
        @auraEnabled
        public String checkListLineId;
        @auraEnabled
        public String Status = 'None';
    }
    
    public static List<ETSALES_checklist__c> getCheckListDetails(){
        List<ETSALES_checklist__c> chekLists = new List<ETSALES_checklist__c>();
        chekLists = [select id,	Name, ETSALES_Active__c FROM ETSALES_checklist__c where ETSALES_Active__c = True];
        
        return chekLists;
    } 
    
    public static List<ETSALES_Check_List_Lines__c> getCheckListLineDetails(String TenderId){
        List<ETSALES_Check_List_Lines__c> chekListLines = new List<ETSALES_Check_List_Lines__c>();
        chekListLines = [select id , Name, ETSALES_Checklist__c , ETSALES_Checklist__r.name , ETSALES_Status__c ,ETSALES_Tender__c   FROM ETSALES_Check_List_Lines__c 
                         where ETSALES_Tender__c =: TenderId ];
        
        return chekListLines;
    } 
    
    
}