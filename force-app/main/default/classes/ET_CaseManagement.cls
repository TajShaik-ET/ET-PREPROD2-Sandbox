public class ET_CaseManagement {
	@AuraEnabled
    public static caseWrapper getDashboardData(String recordType) {
        caseWrapper dashboardWrap=new caseWrapper();
        try{
              if(recordType!='All' && recordType!=null ){
                dashboardWrap.newCount=[select count() from Case where status  ='New' and Business_Type__c =:recordType];
                dashboardWrap.inprogressCount=[select count() from Case where status  ='In Progress' and Business_Type__c =:recordType];
                dashboardWrap.cancelledCount=[select count() from Case where status  ='Closed'  and Business_Type__c =:recordType];
                dashboardWrap.onHoldCount=[select count() from Case where status  ='On Hold'  and Business_Type__c =:recordType]; 
              }else if(recordType=='All'){
                dashboardWrap.newCount=[select count() from Case where status  ='New'];
                dashboardWrap.inprogressCount=[select count() from Case where status  ='In Progress'];
                dashboardWrap.cancelledCount=[select count() from Case where status  ='Closed'];
                dashboardWrap.onHoldCount=[select count() from Case where status  ='On Hold']; 
            
              }
            
           return   dashboardWrap;   
        }    
        catch (Exception ex) {
            System.debug(ex.getMessage());
            return null;
            
        }
    }
    
    public class caseWrapper{ 
        @AuraEnabled public Integer newCount=0; 
        @AuraEnabled public Integer inprogressCount=0; 
        @AuraEnabled public Integer cancelledCount=0; 
        @AuraEnabled public Integer onHoldCount=0; 
        
    }
    
    
    @AuraEnabled
    public static List<Case> getCaseDetails(string status,String recordType) {
        try{
            String query='select Id,CaseNumber,CreatedDate,ClosedDate,Record_Types__c,ETST_Student__r.Name,Status,Case_Types__c,ET_Issue_Category__c,ET_Issue_Type_New__c,Description,Solution__c from case where status=:status ';
            if(recordType!='All' && recordType!=null ){
                query+=' and Business_Type__c =:recordType';
            }
            return database.query(query);
        }catch (Exception e) {
             System.debug(e.getMessage());
             return null;
            
        }
    }
    /*@AuraEnabled
    public static String getCommentsHistory(String ticketId){
        List<CaseComment> cmnts = new List<CaseComment>();
        cmnts = [select id, CommentBody ,CreatedbyId, CreatedBy.Name,createdDate,ParentId 
                 FROM CaseComment where ParentId = :ticketId order by createdDate desc];
        system.debug('cmnts = '+ cmnts);
        List<commentsHistoryWrapper> comhwrpList = new List<commentsHistoryWrapper>();
        
        if(cmnts != null && cmnts.size() > 0){
            for(CaseComment cmnt : cmnts){
                commentsHistoryWrapper chw = new commentsHistoryWrapper();
                chw.source = cmnt.ParentId;
                chw.createdByName = cmnt.CreatedBy.Name;
                chw.message = cmnt.CommentBody;
                chw.createdDate = String.ValueOf(cmnt.createdDate);
                comhwrpList.add(chw);
            }
        }
        system.debug('response = '+ JSON.serializePretty(comhwrpList));
        return JSON.serializePretty(comhwrpList);
    }
    @AuraEnabled
    public static String manageTicket(String ticketId , String comments , String status){
        String errStr;
        String response;
        
        Case  ticket = new Case();
        if(status == 'Closed'){
            //close Ticket and log a comment in - Related Comment Object
            ticket.id = ticketId;
            ticket.Status = 'Closed';
        }
        else if(status == 'Reopen'){
            //Reopen Ticket and log a comment in - Related Comment Object
            ticket.id = ticketId;
            ticket.Status = 'Reopen';
        }
        
        //create  a related comment for closed ticket
        CaseComment comm = new CaseComment();
        comm.ParentId = ticketId;
        comm.CommentBody = comments;
        try{
            if(status == 'Closed' || status == 'Reopen'){
                 update ticket;
            }
            insert comm;
            response = 'Success';
        }
        
        catch (Exception e) {
             system.debug(e.getMessage());
        }
        
        return response;
    }
    
    
     public class commentsHistoryWrapper{ 
        @AuraEnabled 
        public String source ;
        @AuraEnabled 
        public String createdByName ;
        @AuraEnabled 
        public String message ;
        @AuraEnabled 
        public String createdDate;
    }*/
}