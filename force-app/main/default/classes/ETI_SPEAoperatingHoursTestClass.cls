@isTest
public class ETI_SPEAoperatingHoursTestClass {
    
    // Setup Test Data
    @testSetup static void setup() {
        //Create work Type
        WorkType wType = new WorkType();
        wType.Name = 'Inspection';
        wType.DurationType = 'Minutes';
        wType.EstimatedDuration = 40;
        insert wType;
        
        //create operating Hours 
        OperatingHours oHours = new OperatingHours();
        oHours.Name = 'Sharjah operating Hours';
        oHours.ETI_operating_hours_unique_identifier__c = 'Sharjah_operating_Hours';
        insert oHours;
        
        // Create Time slots for operating hours
        TimeSlot slot = new TimeSlot();
        slot.StartTime = Time.newInstance(8, 0, 0, 0);
        slot.EndTime =  Time.newInstance(11, 30, 0, 0);
        slot.OperatingHoursId = oHours.id;
        insert slot;
    }
    
    @isTest static void testMethod1(){
        ETI_SPEAoperatingHours.getOperatingHours();
    }
}