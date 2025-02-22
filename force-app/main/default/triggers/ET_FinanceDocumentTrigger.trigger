/********************************************************************************************************
* @author		Smaartt
* @description	Trigger on Finance document on update event.
*********************************************************************************************************/
trigger ET_FinanceDocumentTrigger on ET_Finance_Document__c (after update) {
    
     switch on Trigger.operationType{
         when BEFORE_UPDATE{
           //call on before update.
         }when AFTER_INSERT{
            //call on After insert.
         }when AFTER_UPDATE{
             List<ET_Finance_Document__c> finDocList = new List<ET_Finance_Document__c>();
             for(ET_Finance_Document__c finDoc:Trigger.New){
                 if( (finDoc.ET_Status__c!=null && finDoc.ET_Status__c=='Confirmed' && finDoc.ET_Status__c!=trigger.OldMap.get(finDoc.Id).ET_Status__c)
                   || (finDoc.Integration_Message__c==null && finDoc.Integration_Message__c!=trigger.OldMap.get(finDoc.Id).Integration_Message__c) ){
                     finDocList.add(finDoc);
                 }
             }
             
             if(!finDocList.isEmpty()){
                 ET_FinanceController.syncwithEBS(finDocList);
             }
           
         }
     }
  
}