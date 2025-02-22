trigger ETSALES_SocialPostTrigger on SocialPost (after insert) {
    
    switch on Trigger.operationType{
        when AFTER_INSERT{
           ETSALES_SocialPostTriggerHandler.updateLeadRecordType(Trigger.newMap);
        }
    }
    
}