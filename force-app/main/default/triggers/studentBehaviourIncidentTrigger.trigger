/*
* Description: Trigger on Students Behaviour Incident Types
* Author:Manisha Gouri T
* Created Date: 15/12/2022
*/

trigger studentBehaviourIncidentTrigger on Student_Behavior_Incidents_Types__c (after insert,after update) 
{
    if(Trigger.isInsert && Trigger.isAfter)
    {
        StudentBehaviourHandler.StudentBehaviourRecords(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        StudentBehaviourHandler.UpdateStudentBehaviourRecords(Trigger.new,Trigger.OldMap);
    }
}