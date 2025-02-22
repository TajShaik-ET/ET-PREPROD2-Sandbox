/*
 * Description: Trigger on Routes Preview
 * Author:Sreelakshmi SK
 * Created Date: 16/12/2022
*/

trigger RoutesPreviewTrigger on Routes_Preview__c (after insert,after update) {
      
    if(Trigger.isInsert && Trigger.isAfter)
    {
		RoutesPreviewHandler.NewRoutesPreview(trigger.New);
    }
    
     if(Trigger.isUpdate && Trigger.isAfter)
    {
		RoutesPreviewHandler.UpdateRoutesPreview(trigger.New,Trigger.OldMap);
    }
}