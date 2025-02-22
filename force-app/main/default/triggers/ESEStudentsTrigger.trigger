/*
 * Description: Trigger on ESE Students
 * Author:Manisha Gouri T
 * Created Date: 16/12/2022
*/
trigger ESEStudentsTrigger on ESE_Students__c (after insert,after update) {
    
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        ESEStudentsHandler.ESEStudentRecords(Trigger.new);
        
    }
    
     if(Trigger.isUpdate && Trigger.isAfter)
    { 
          ESEStudentsHandler.UpdateESEStudentRecords(Trigger.new,Trigger.OldMap);
    }
}