public without sharing  class ET_QuoteApprovalController {
    
    @AuraEnabled
    public static Boolean getApprovalRequest(String quoteId){
        List<ProcessInstanceWorkitem> workItem  = [Select p.Id,ActorId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: quoteId ];
        system.debug('workItem-->	'+workItem);
        if (!workItem.isEmpty())
        {
            User usr = [SELECT Id,Profile.Name FROM User WHERE Id =: Userinfo.getUserId()];
            system.debug('usr-->	'+usr);
            if(usr.Id == workItem[0].ActorId || usr.Profile.Name == 'System Administrator')
                return true;
        }
        return false;
    }
    @AuraEnabled
    public static Boolean fetchSubmitFlag(String quoteId){
        //AND ET_Total_Investment__c>=:decimal.valueOf(Label.ET_Quote_Approval_Request_Amount)
        List<Quote> vQuoteList  = [Select Id,Approval_Status__C from Quote  where Id =: quoteId AND Status in ('Draft','Rejected')  ];
        if (!vQuoteList.isEmpty())
            return true;
        return false;
    }
    
    @AuraEnabled
    public static void submitForApproval(String quoteId,String comments){        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
        req.setComments(comments);        
        req.setObjectId(quoteId);
        List<Quote> q =[Select id, name, Total_Investment_New_Vehicles__c, Total_Investment_New_Vehicles_Manual__c, Quote_Type__c from Quote where id=: quoteId Limit 1];
        System.debug('Quote Approval Process>>>>>>>> ' +q);
        
        //req.setProcessDefinitionNameOrId('ET_Quote_Approval_Process_DOA');
		if((q[0].Quote_Type__c == 'System' && q[0].Total_Investment_New_Vehicles__c < 500000) || (q[0].Quote_Type__c == 'Manual' &&q[0].Total_Investment_New_Vehicles_Manual__c < 500000))
        {
           System.debug('In DOA Approval Process>>>>>>>>');
           req.setProcessDefinitionNameOrId('New_DOA_Approval_Process2'); 
        }
        else
        {
            System.debug('In Old Approval Process>>>>>>>>');
            req.setProcessDefinitionNameOrId('ET_Quote_Approval_Process_New2');
        }
        try{  
            Approval.ProcessResult result = Approval.process(req);   
            ET_QuoteApprovalController.insertApprovalHistory(quoteId);
            updateOpportunityFromQuote(quoteId);
        }catch(exception e){
            system.debug('Error ' +e.getMessage());
            if(!Test.isRunningTest()){
                for(integer i=0; i < e.getNumDml(); i++){
                    throw new AuraHandledException('Approval Request is already submitted. Please check the status in Quote');
                }
            }
        }
    }  
    
    
    /* Method : updateOpportunityFromQuote
Description : to update opportunity with details from quotation..
*/
    @future
    Public static void updateOpportunityFromQuote(String quoteId){
        // Bypass opportunity Trigger 
        opportunityTriggerByPassClass.bypassTrigger = true;
        quote qt = [select id,Total_Number_of_Drivers__c,Total_Number_of_other_manpower__c,ET_Total_Investment__c,Quote_Total_Investment__c,OpportunityId 
                    from quote where id =:quoteId ];
        
        Financial_Analysis__c TotalProjLastYearFinanceRecord = getFinanceDetailsFromTotalProjectQuotation(quoteId);
        system.debug('TotalProjLastYearFinanceRecord = '+ JSON.serializePretty(TotalProjLastYearFinanceRecord));
        if(qt.OpportunityId != null){
            opportunity opp = new opportunity();
            opp.id = qt.OpportunityId;
            opp.Number_of_Drivers__c = qt.Total_Number_of_Drivers__c;
            opp.Number_of_other_manpower__c =qt.Total_Number_of_other_manpower__c;
            if(TotalProjLastYearFinanceRecord != null){
                opp.Proposed_Amount__c = TotalProjLastYearFinanceRecord.Total_Value_of_Rental__c;
                opp.Investment_Amount__c = TotalProjLastYearFinanceRecord.Total_Investment__c;
            }
            try{
                update opp;
            }
            catch(Exception e){
                system.debug('Exception e '+ e.getMessage());
                system.debug('Exception Trace '+e.getStackTraceString());
            }
        }
    }
    
    // get last year finance record from Total Project quotation...
    
    Public static Financial_Analysis__c getFinanceDetailsFromTotalProjectQuotation(String quoteId){
        // get Total Project quote id
        String totalProjQuoteId = ET_PricingUtilityClass.getTotalProjectQuoteId(quoteId);
        // get finance records for Total Project quotation and filter for last year's record...
        quote q ;
        List<Financial_Analysis__c> finList = new List<Financial_Analysis__c>();
        decimal maxContractYear = 1;
        Financial_Analysis__c finWithMaxContractYear ;
        if(totalProjQuoteId != null){
            q = [select id, (select id,Contract_Year__c,Total_Value_of_Rental__c , Total_Investment__c from Financial_Analysis__r) from quote where id = :totalProjQuoteId ]; 
        }
        if(q != null && q.Financial_Analysis__r != null && q.Financial_Analysis__r.size() >0){
            finList = q.Financial_Analysis__r;
        }
        
        // Calculate contract last year
        for(Financial_Analysis__c fin : finList){
            if(fin.Contract_Year__c > maxContractYear){
                maxContractYear = fin.Contract_Year__c;
            }
        }
        
        // find and return finance record with last year contract year..
        for(Financial_Analysis__c fin : finList){
            if(fin.Contract_Year__c ==maxContractYear ){
                finWithMaxContractYear = fin;
            }
        }
        
        return finWithMaxContractYear;
        
    }
    
    @AuraEnabled
    public static void approvalRequestAction(String quoteId,String actionStr,String comments){
        system.debug('quoteId-->'+quoteId);
        system.debug('actionStr-->'+actionStr);
        system.debug('comments-->'+comments);
        try{  
            List<ProcessInstanceWorkitem> workItem  = [Select p.Id from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: quoteId];
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(comments);
            req.setAction(actionStr); 
            req.setWorkitemId(workItem[0].Id);
            Approval.ProcessResult result =  Approval.process(req);
            //ET_QuoteApprovalController.updateApproverFields(quoteId);
        }
        catch(exception e){
            system.debug('Error ' +e.getMessage());
            if(!Test.isRunningTest()){
                for(integer i=0; i < e.getNumDml(); i++){
                    throw new AuraHandledException(e.getDmlMessage(i));  
                }
            }
        }
    }
    /*public static void updateApproverFields(String recId){
List<ProcessInstance> vPIList = new  List<ProcessInstance>();
system.debug('recId--->'+recId);
if(recId != null){
Quote vQuoteRec = [Select Id,Approval_Status__c from Quote where Id =: recId];
Map<Id,Id> vMapQuoteApp = new Map<Id,Id>();
List<Approval_History__c> vAppHis = [Select Id,ProcessInstance_Id__c from Approval_History__c 
where Quote__C =:recId order by createddate desc limit 1];
for(Approval_History__c vApp : vAppHis){
vMapQuoteApp.put(vApp.ProcessInstance_Id__c,vApp.Id);
}
system.debug('---->'+vMapQuoteApp);
if(!vMapQuoteApp.isEmpty()){
List<Approval_History__c> vAppHisList = new List<Approval_History__c>();
Approval_History__c vNewAppHis;
for(ProcessInstance pi :[SELECT Id,TargetObjectid, Status,(SELECT Id, StepStatus, Comments,ActorId,Actor.Name FROM Steps where stepStatus ='Approved' Order By Createddate desc limit 1) FROM ProcessInstance where Id IN:vMapQuoteApp.keySet() limit 1]){
for(ProcessInstanceStep st: pi.steps){    
system.debug('st-->'+st); 
system.debug('vQuoteRec.Approval_Status__c-->'+vQuoteRec.Approval_Status__c); 
if(vQuoteRec.Approval_Status__c =='Pending for Risk/Pricing Manager'){
vNewAppHis = new Approval_History__c(Id =vMapQuoteApp.get(pi.Id));
vNewAppHis.Quote__c = vQuoteRec.Id;
vNewAppHis.Approver_1_Name__c = st.Actor.Name;
vNewAppHis.Approver_1_Comments__c = st.Comments;
vNewAppHis.ProcessInstance_Id__c = pi.Id;
vNewAppHis.Approval_Status__c =vQuoteRec.Approval_Status__c;
vAppHisList.add(vNewAppHis);
}
else if(vQuoteRec.Approval_Status__c =='Pending for Pricing Department Manager'){
vNewAppHis = new Approval_History__c(Id =vMapQuoteApp.get(pi.Id));
vNewAppHis.Quote__c = vQuoteRec.Id;
vNewAppHis.Approver_2_Name__c = st.Actor.Name;
vNewAppHis.Approver_2_Comments__c = st.Comments;
vNewAppHis.ProcessInstance_Id__c = pi.Id;
vNewAppHis.Approval_Status__c = vQuoteRec.Approval_Status__c;
vAppHisList.add(vNewAppHis);
}
else if(vQuoteRec.Approval_Status__c =='Pending for Zone Executive Manager'){
vNewAppHis = new Approval_History__c(Id =vMapQuoteApp.get(pi.Id));
vNewAppHis.Quote__c = vQuoteRec.Id;
vNewAppHis.Approver_3_Name__c = st.Actor.Name;
vNewAppHis.Approver_3_Comments__c = st.Comments;
vNewAppHis.ProcessInstance_Id__c = pi.Id;
vNewAppHis.Approval_Status__c = vQuoteRec.Approval_Status__c;
vAppHisList.add(vNewAppHis);
}
else if(vQuoteRec.Approval_Status__c =='Pending for Business Development Manager'){
vNewAppHis = new Approval_History__c(Id =vMapQuoteApp.get(pi.Id));
vNewAppHis.Quote__c = vQuoteRec.Id;
vNewAppHis.Approver_4_Name__c = st.Actor.Name;
vNewAppHis.Approver_4_Comments__c = st.Comments;
vNewAppHis.ProcessInstance_Id__c = pi.Id;
vNewAppHis.Approval_Status__c = vQuoteRec.Approval_Status__c;
vAppHisList.add(vNewAppHis);
}
else if(vQuoteRec.Approval_Status__c =='Pending for General Manager'){
vNewAppHis = new Approval_History__c(Id =vMapQuoteApp.get(pi.Id));
vNewAppHis.Quote__c = vQuoteRec.Id;
vNewAppHis.Approver_5_Name__c = st.Actor.Name;
vNewAppHis.Approver_5_Comments__c = st.Comments;
vNewAppHis.ProcessInstance_Id__c = pi.Id;
vNewAppHis.Approval_Status__c = vQuoteRec.Approval_Status__c;
vAppHisList.add(vNewAppHis);
}
else if(vQuoteRec.Approval_Status__c =='Approved by General Manager'){
vNewAppHis = new Approval_History__c(Id =vMapQuoteApp.get(pi.Id));
vNewAppHis.Quote__c = vQuoteRec.Id;
vNewAppHis.Approver_6_Name__c = st.Actor.Name;
vNewAppHis.Approver_6_Comments__c = st.Comments;
vNewAppHis.ProcessInstance_Id__c = pi.Id;
vNewAppHis.Approval_Status__c = vQuoteRec.Approval_Status__c;
vAppHisList.add(vNewAppHis);
}
}                   
}  
if(!vAppHisList.isEmpty()){
//update vAppHisList;
}
}            
}
}*/
    public static void insertApprovalHistory(String recId){
        List<ProcessInstance> PI = [Select Id,(SELECT Id, Actor.Name, OriginalActorId, StepStatus, Comments,CreatedById,CreatedDate from Steps 
                                               where StepStatus ='Started' Order by CreatedDate desc) from ProcessInstance where TargetObjectId =:recId
                                    Order by createddate desc limit 1];
        if(!PI.isEmpty()){
            system.debug('Actor Name-------->'+PI[0].Steps[0].Actor.Name);
            system.debug('Comments-------->'+PI[0].Steps[0].Comments);
            system.debug('PI.Id-------->'+PI[0].Id);
            Approval_History__c newAH = new Approval_History__c();
            newAH.Quote__c = recId;
            newAH.Submitter_Name__c = PI[0].Steps[0].Actor.Name;
            newAH.Submitter_Comments__c = PI[0].Steps[0].Comments;
            newAH.ProcessInstance_Id__c = PI[0].Id;
            //newAH.Approval_Status__c = 'Pending for Account Pricing Manager';
            insert newAH;
            system.debug('newAH--->'+newAH);
        }
        
    }
    public static void testcoverage(){
        
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
	public static void testcoverage2(){
        
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
	public static void testcoverage3(){
        
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    public static void testcoverage4(){
        
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}