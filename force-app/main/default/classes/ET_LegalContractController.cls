public class ET_LegalContractController {
    
    public static void updateOwner(List<Legal_Contract__c> newList,Map<Id,Legal_Contract__c> oldMap){
        for(Legal_Contract__c vItm : newList){
            if(vItm.Approval_Status__c == 'Approved by Head of Legal' && oldMap.get(vItm.Id).Approval_Status__c != vItm.Approval_Status__c){
               	if(vItm.Back_Up_Owner_Id__c != null)
                    vItm.OwnerId = vItm.Back_Up_Owner_Id__c;
            }
        }
    }
    public static void updateOppsStages(List<Legal_Contract__c> newList){
        Set<Id> vSetOppIds = new Set<Id>();
        for(Legal_Contract__c vItm : newList){
        	if(vItm.Opportunity__c != null)
                vSetOppIds.add(vItm.Opportunity__c);
            
        }
        if(!vSetOppIds.isEmpty()){
        	List<Opportunity> vListOpps =[SELECT Id,StageName FROM Opportunity WHERE Id IN :vSetOppIds];
        	List<Opportunity> vListUpdateOpps = new List<Opportunity>();
        	Opportunity upOpps;
        	for(Opportunity vItm : vListOpps){
            	if(vItm.StageName=='Negotiation'){
           			upOpps = new Opportunity(Id = vItm.Id);
                	upOpps.stageName = 'Legal Contract';
                	vListUpdateOpps.add(upOpps);
            	}
        }
        if(!vListUpdateOpps.isEmpty())
            update vListUpdateOpps;
        }
    }
     public static void updateOppsLegal(List<Legal_Contract__c> newList,Map<Id,Legal_Contract__c> oldMap,Boolean trgFlag){
        List<Opportunity> vListUpdateOpps = new List<Opportunity>();
        Opportunity upOpps;
        for(Legal_Contract__c vItm : newList){
            system.debug('vItm.Opportunity__c-->'+vItm.Opportunity__c);
            system.debug('vItm.Status__c-->'+vItm.Status__c);
            if(vItm.Opportunity__c != null){
                if(trgFlag){
               	 if( vItm.Status__c == 'Closed' && vItm.Status__c!= oldMap.get(vItm.Id).Status__c){
           			upOpps = new Opportunity(Id = vItm.Opportunity__c);
                	upOpps.Legal_Contract_Status__c = True;
                	vListUpdateOpps.add(upOpps);
                  }
                }
                else if( vItm.Status__c == 'Closed' && vItm.Status__c!= oldMap.get(vItm.Id).Status__c){
           			upOpps = new Opportunity(Id = vItm.Opportunity__c);
                	upOpps.Legal_Contract_Status__c = True;
                	vListUpdateOpps.add(upOpps);
                  }
            }
        }
        system.debug('vListUpdateOpps--->'+vListUpdateOpps);
        if(!vListUpdateOpps.isEmpty())
            update vListUpdateOpps;
    }
}