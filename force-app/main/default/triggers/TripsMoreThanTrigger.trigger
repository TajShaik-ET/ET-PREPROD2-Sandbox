/*
 * Description: Trigger on TripsMoreThan
 * Author:Manisha Gouri T
 * Created Date: 16/12/2022
*/

trigger TripsMoreThanTrigger on Trips_More_Than__c (after insert,after update) {

    if(Trigger.isInsert && Trigger.isAfter)
    {
     	TripsMoreThanHandler.NewTripRecords(Trigger.new);
    }
     if(Trigger.isUpdate && Trigger.isAfter)
    { 
        TripsMoreThanHandler.UpdateTripRecords(Trigger.new,Trigger.OldMap);
    }
}