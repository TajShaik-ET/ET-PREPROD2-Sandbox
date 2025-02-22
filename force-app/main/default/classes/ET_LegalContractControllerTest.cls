@isTest
public class ET_LegalContractControllerTest {

    public static testmethod void testupdateOwner(){
        Opportunity opp = new Opportunity();
		opp.Name = 'test';
		opp.stageName = 'Negotiation';
		opp.Closedate =  Date.newInstance(2021, 12, 9);
		insert opp;
        LCRecordTypeSelController.findRecordTypes(opp.Id);
        Legal_Contract__c lcon = new Legal_Contract__c();   
        lcon.Opportunity__c = opp.Id;
        insert lcon;
        lcon.Approval_Status__c='Approved by Head of Legal';
        update lcon;
        List<Legal_Contract__c> vListlc = new List<Legal_Contract__c>();
        vListlc.add(lcon);
        Map<Id,Legal_Contract__c> vMap = new Map<Id,Legal_Contract__c>([Select Id,Approval_Status__c,Status__c,Opportunity__c from Legal_Contract__c where Id =: lcon.Id limit 1]);
        ET_LegalContractController.updateOwner(vListlc,vMap);
        lcon.Status__c ='Closed';
        update lcon;
        ET_LegalContractController.updateOppsLegal(vListlc,vMap,true);
    
        
    }
    	
}