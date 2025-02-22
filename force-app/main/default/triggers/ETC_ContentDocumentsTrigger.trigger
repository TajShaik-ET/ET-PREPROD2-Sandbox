trigger ETC_ContentDocumentsTrigger on ContentDocumentLink (before insert) {
    if(trigger.isinsert && trigger.isbefore){
        ETC_ContentDocumentsTriggerHandler.giveFileAccesstoExternalUsers(trigger.new);
    }
}