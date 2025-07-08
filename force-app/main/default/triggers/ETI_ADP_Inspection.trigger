/***********************************************************************************************************************
* Name               : ETI_ADP_Inspection                                                                              *
* Test Class         : ETI_ADPInspectionHandlerTest                                                                    *
* Description        : Trigger for ADP_Inspection__c                                                                   *
* Created Date       : 24/Apr/2025                                                                                     *
* Created By         : Akash (SMAARTT)                                                                                 *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Akash       24/Apr/2025         Initial Draft.                                                             *
***********************************************************************************************************************/
trigger ETI_ADP_Inspection on ADP_Inspection__c (before insert, before update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        ETI_ADPInspectionHandler.handleBeforeInsert(Trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        ETI_ADPInspectionHandler.handleBeforeUpdate(Trigger.newMap, Trigger.oldMap);
    }
}