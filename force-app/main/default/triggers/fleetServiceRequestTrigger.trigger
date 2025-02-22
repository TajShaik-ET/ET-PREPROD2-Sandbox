/***
Class       : fleetServiceRequestTrigger
Author      : Janardhan Muddana
Description : common trigger for Fleet_Service_Request__c
TestClass  : 
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              27/03/23           Initial Version 
****************************************************************************************************************/

trigger fleetServiceRequestTrigger on Fleet_Service_Request__c (after insert) {
    
    fleetServiceRequestHandler.processServiceRequest(trigger.new);
 }