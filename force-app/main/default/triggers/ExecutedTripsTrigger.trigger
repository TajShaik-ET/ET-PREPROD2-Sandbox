/*
* Description: Trigger on Executed Trips
* Author:Sreelakshmi SK
* Created Date: 16/12/2022
*/

trigger ExecutedTripsTrigger on Executed_Trips__c (after insert,after update) {
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        ExecutedTripsHandler.NewExecutedTrips(trigger.New);
    }
    
    
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        ExecutedTripsHandler.UpdateExecutedTrips(trigger.New,trigger.OldMap);
    }
}