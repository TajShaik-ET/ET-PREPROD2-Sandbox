/***********************************************************************************************************************
* Name               : SendQuoteEmailJob                                                                               *
* Test Class         : QuoteTriggerTest                                                                                *
* Description        : Apex Queueable Class to Send Emails on Quote Creation.                                          *
* Created Date       : 29/May/2025                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   29/May/2025         Initial Draft.                                                             *
***********************************************************************************************************************/

public class SendQuoteEmailJob implements Queueable {
    private Set<Id> quoteIds;
    
    public SendQuoteEmailJob(Set<Id> quoteIds) {
        this.quoteIds = quoteIds;
    }
    
    public void execute(QueueableContext context) {
        QuoteEmailHandler.sendQuoteEmail(new List<Id>(quoteIds));
    }
}