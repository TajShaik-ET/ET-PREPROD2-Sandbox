/***********************************************************************************************************************
* Name               : QuoteTrigger                                                                                    *
* Test Class         : QuoteTriggerTest                                                                                *
* Description        : Apex Trigger on Quote Object.                                                                   *
* Created Date       : 03/Mar/2025                                                                                     *
* Created By         : Mohith (SMAARTT)                                                                                *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Mohith      03/Mar/2025         Initial Draft.                                                             *
* 1.1       Taj Shaik   29/May/2025         Code Refactor                                                              *
***********************************************************************************************************************/

trigger QuoteTrigger on Quote (after insert) { 
    if (Trigger.isAfter && Trigger.isInsert && TriggerRecursionHelper.isFirstRun('Quote_afterInsert')) {
        QuoteTriggerHandler.handleAfterInsert(Trigger.new);
    }
}