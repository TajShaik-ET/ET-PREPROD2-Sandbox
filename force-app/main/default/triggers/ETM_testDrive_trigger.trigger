trigger ETM_testDrive_trigger on ETM_Vehicle_Test_Drive__c (before insert, after update) {
    // To update lead with selected Test Drive info..
    if(trigger.isafter && trigger.isupdate){
        ETM_testDrive_triggerHanlder.updateLeadWithTestDriveInfo(Trigger.new, Trigger.oldMap);
    }
}