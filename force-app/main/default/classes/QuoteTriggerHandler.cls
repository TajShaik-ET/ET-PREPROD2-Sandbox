/***********************************************************************************************************************
* Name               : QuoteTriggerHandler                                                                             *
* Test Class         : QuoteTriggerTest                                                                                *
* Description        : Apex Class handler on Quote Object.                                                             *
* Created Date       : 29/May/2025                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   29/May/2025         Initial Draft.                                                             *
***********************************************************************************************************************/

public class QuoteTriggerHandler {
    
    public static void handleAfterInsert(List<Quote> quotes) {
        Set<Id> quoteIdsToProcess = new Set<Id>();
        for (Quote q : quotes) {
            if (q.ET_Type__c == 'Quote for Approval' && q.OpportunityId != null) {
                quoteIdsToProcess.add(q.Id);
            }
        }
        if (!quoteIdsToProcess.isEmpty()) {
            System.enqueueJob(new SendQuoteEmailJob(quoteIdsToProcess));
        }
    }
}