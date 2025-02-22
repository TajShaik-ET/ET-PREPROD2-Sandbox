trigger TaxNumberTrigger on Account (before insert, before update) {
    TaxNumberHandler.handleAccounts(Trigger.new, Trigger.oldMap);
}