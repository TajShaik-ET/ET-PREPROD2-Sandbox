/********************************************************************************************************
* @author		Smaartt
* @description	Trigger Handler to send Inspection Test Result and Inspection Certificate in mail when the inspection Completed and Report is generated.

*********************************************************************************************************/

trigger ETI_ServiceReportTrigger on ServiceReport (after insert , before insert) {
    
    // before inserting service Report
    if(trigger.isInsert && trigger.isBefore){
    }
    
    // after inserting service Report
    if(trigger.isInsert && trigger.isAfter){
        ETI_ServiceReportHandler.send_Report_InMail(trigger.new);
    }
	
}