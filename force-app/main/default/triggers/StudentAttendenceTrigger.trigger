/*
 * Description: Trigger on Students Attendence
 * Author:Sreelakshmi SK
 * Created Date: 14/12/2022
*/

trigger StudentAttendenceTrigger on Students_Attendence__c (after insert,after update) {
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        StudentAttendenceHandler.NewStudentAttendence(Trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter)
    {
       StudentAttendenceHandler.UpdateStudentAttendence(Trigger.new,Trigger.OldMap);
    }
    
}