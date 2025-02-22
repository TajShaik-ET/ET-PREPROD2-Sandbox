/* Class : ETI_SPEAoperatingHours
   Description : To get operating Time slots for SPEA Inspection with Respect to Day
   Test Class  : 
*/



public class ETI_SPEAoperatingHours {
    
    /* Description : To get operating hours from 'OperatingHours' object which are defined for SPEA Inspection
     				 Get Appointment Duration from 'WorkType'
					 slotsMap => Key = DayOfWeek && Values = Slots
	*/
    public static Map<String, List<String>> getOperatingHours(){
        
        // Initilizations
        Map<String, List<String>> slotsMap = new Map<String, List<String>>();
        list<String> slots = new list<String>();
        
        // query FSL operating hours   
        List<TimeSlot> TimeSlots = new List<TimeSlot>();
        TimeSlots = [select id, StartTime, EndTime, DayOfWeek, Type FROM TimeSlot WHERE OperatingHoursId in 
                     (select id from OperatingHours where ETI_operating_hours_unique_identifier__c =: system.Label.ETI_operating_hours_unique_identifier)];
        
        system.debug('TimeSlots  = '+ TimeSlots);
        
        // query duration from work Type
        List<WorkType> wType = new List<WorkType>([select id ,Name, EstimatedDuration from WorkType where Name	=: system.Label.ETI_Inspection_work_Type ]);
        integer duration = 40;
        if(wType != null && wType.size() > 0){
            duration = integer.valueof(wType[0].EstimatedDuration);
        }
        
        // create the slotsMap with Key = DayOfWeek && Values = Slots
        if(TimeSlots != null && TimeSlots.size() > 0){
            system.debug('size = '+ TimeSlots.size() );
            for(TimeSlot slot : TimeSlots ){
                if(slot.StartTime != null && slot.EndTime != null && duration != null ){
                    slots= getSlots(String.Valueof(slot.StartTime), String.Valueof(slot.EndTime ),duration );
                    slotsMap.put(slot.DayOfWeek , slots);
                }
            }
            system.debug('slotsMap = '+ JSON.serializePretty(slotsMap));
        }
        
        return slotsMap;
        
    }
    
    /* 
      Method 	  : getSlots
      Description : To get slots based on Start Time, End Time of Day and Duration of appointment
					Convert Duration from minutes to decimal -- (finalDuration) as in below example -
					 1) 40 mins --> 0.4
					 2) 60 mins --> 1
					 3) 80 mins --> 1.2

  				    * Calculate 'n' for number of iterations in for loop to get slots 
  				    * n = (end Time - start Time)/(duration/60)
	*/
    public static list<String> getSlots(String startTime, String endTime, decimal duration){
        system.debug('duration = '+ duration);
        decimal finalDuration;
        decimal dur = duration/60;
        system.debug('dur  = '+ dur);
        if(dur < 1){
            finalDuration =  duration/100;
        }
        else if(dur ==1){
            finalDuration = 1;
        }
        else if(dur >1){
            integer durInt = integer.ValueOf(duration/60);
            decimal durDecm =(duration - durInt*60) /100;
            finalDuration = durInt + durDecm;
        }
        
        system.debug('finalDuration = '+ finalDuration);
        
        String startPref = (startTime.left(5)).substringBefore(':');
        String startSuffix = (startTime.left(5)).substringAfter(':');
        String start = startPref +'.'+startSuffix;
        system.debug('start = '+ start);
        String endPref = (endTime.left(5)).substringBefore(':');
        String endSuffix = (endTime.left(5)).substringAfter(':');
        String endT = endPref +'.'+endSuffix;
        system.debug('endT = '+ endT);
        integer n = integer.Valueof(((decimal.ValueOf(endT)- decimal.ValueOf(start))/duration)*60);
        system.debug('test = '+ n);
        
        list<String> slots = new list<String>{String.ValueOf(start.replace('.',':'))};
        decimal temp = decimal.ValueOf(start);
        for(integer i=0 ; i<n ; i++){
            temp += finalDuration;
            decimal temp2 = adjustTime(temp).setScale(2);
            temp = temp2;
            String finalSlot1 = String.ValueOf(temp2); 
            String finalSlot2 =(finalSlot1.substring(0,1) != '0' && finalSlot1.substringBefore('.').length() == 1   ? '0'+ finalSlot1 : finalSlot1);
            slots.add(finalSlot2.replace('.',':'));
        }
        system.debug('slots  = '+ slots);
        return slots;
    }
    
    /* Method 		: adjustTime
       Description  : To adjust decimal Value in Time Pattern
					  Ex: 8.6 to 9.00
						  8.8 to 9.10
	*/
    
    public static decimal adjustTime(decimal temp){
        decimal decimalPart = temp - temp.round(System.RoundingMode.DOWN);
        decimal x = decimalPart/0.6;
        decimal retValue;
        if(x < 1){
            retValue = temp;
        }
        else if(x == 1){
            integer intVal = integer.valueOf(temp);
            retValue = intVal+1;
        }
        
        else if(x > 1){
            integer intVal = integer.valueOf(temp)+1;
            retValue = intVal + (decimalPart - 0.6);
        }
        system.debug('retValue  = '+ retValue);
        return retValue;
    }
   
}