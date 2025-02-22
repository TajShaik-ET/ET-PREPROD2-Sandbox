trigger CICO_IntimationTrg on CICO_Intimation__c (after insert) {
    
    CICO_IntimationTrgHandler.processIntimation(trigger.new);
}