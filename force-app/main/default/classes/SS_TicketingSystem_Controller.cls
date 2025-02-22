public class SS_TicketingSystem_Controller {
    
    @AuraEnabled
    public static String getTicketDetails(String status){
        //return all Tickets of logged in user
        String userDet = SS_TicketingSystem_Controller.fetchUser();
        User userinfo = (User)JSON.deserialize(userDet, User.Class);
        String contactId = userinfo.contactId;
        //String contactId ='0033H000002uaOe';
        system.debug('$$$$$$$'+status);
      String listoftypes=System.Label.Case_Record_Type_MOE;
      List<String>  casetypeList= new List<String>();
      casetypeList=listoftypes.split(',');
       List<Case> tckts = new List<Case>();
      system.debug('##casetype##'+casetypeList);
        String query= 'select Id,CaseNumber,AccountId,Status,Contactid,Description,Case_Types__c ,createdDate FROM  Case where  RecordType.Name IN :casetypeList';
        if(status=='In Progress'){
            system.debug('status = '+ status);
            List<String> statusList = new list<String> { 'New' , 'Closed' , 'On Hold' , 'Reopen'};
                query+=' and Status NOT IN :statusList';
        }
        else if(status=='Approval Pending'){
         system.debug('$$$$$$$$$Inside approval$$');
            system.debug('status = '+ status);
              List<String> newstatusList = new list<String> {'Submitted for ADEC','Submitted for ET Manager'};
            
            query+=' and Status IN :newstatusList';
            system.debug('$$$$$$$$$$$$$$$$$'+query);          
        
        }
        
        else if(status=='New'){
            List<String> statusList = new list<String> { 'New','Reopen'};
                query+=' and Status  IN :statusList';
        }
        
        else{
            query+=' and Status=:status';
        }
        
        query+=' order by lastModifiedDate desc'; 
            system.debug('$$$$$$$$$$$$$$$$$'+query);
            system.debug('------->'+query);
            tckts = Database.query(query);
            system.debug('------->'+tckts);
        List<TicketHistoryWrapper> thwList = new List<TicketHistoryWrapper>();
        
        if(tckts != null && tckts.size() > 0){
            for(Case iss : tckts ){
                TicketHistoryWrapper thw = new TicketHistoryWrapper();
                thw.name = iss.CaseNumber ;
                thw.Description = iss.Description;
                thw.CaseType = iss.Case_Types__c;
                thw.status = iss.Status;
                thw.createdDate = String.valueOf(iss.createdDate);
                thw.ticketId = iss.Id;
                
                thwList.add(thw);
            }
        }
        
        system.debug('Ticket History response = '+ JSON.serializePretty(thwList) );
        return JSON.serializePretty(thwList);
        
    }
    
     @AuraEnabled
    public static String getDashboardData(){
        DashboardWrapper dashboardWrap=new DashboardWrapper();
        String response;
        String errStr;
        List<String> notInprogList = new List<String>{'New' ,'Closed','On Hold','Reopen'};
        List<String> newlist = new List<String>{'New'};
        String listoftypes=System.Label.Case_Record_Type_MOE;
       List<String>  casetypeList= new List<String>();
      casetypeList=listoftypes.split(',');
        system.debug('%%%%%%%%%%'+casetypeList);
        try{
            String userDet = SS_TicketingSystem_Controller.fetchUser();
            User userinfo = (User)JSON.deserialize(userDet, User.Class);
             String contactId = userinfo.contactId;
            dashboardWrap.newCount = [select count() FROM Case where RecordType.Name IN :casetypeList AND Status IN :newlist];
            dashboardWrap.closedCount = [select count() FROM Case where RecordType.Name  IN :casetypeList  AND Status = 'Closed' ];
         //   dashboardWrap.inProgressCount = [select count() FROM Case where Contactid ='ETST_Ministry_of_Education' AND Status NOT in : notInprogList AND  Case_Types__c IN :casetypeList];
            dashboardWrap.onHoldCount = [select count() FROM Case where  RecordType.Name IN :casetypeList AND Status = 'On Hold'];
            dashboardWrap.ApprovalCount = [select count() FROM Case where  RecordType.Name IN :casetypeList AND (Status = 'Submitted for ADEC'
            OR Status='Submitted for ET Manager')];
            response = JSON.serializePretty(dashboardWrap);
            system.debug('---->'+response);
        }
        catch (Exception e) {
            errStr = JSON.serialize(SS_TicketingSystem_Controller.buildErrorResponse('getDashboardData', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
        
        system.debug('response = '+ response);
        return response;
    }
    @AuraEnabled
    public static String getCommentsHistory(String ticketId){
        List<CaseComment> cmnts = new List<CaseComment>();
        cmnts = [select id, CommentBody ,CreatedbyId, CreatedBy.Name,createdDate,ParentId 
                 FROM CaseComment where ParentId = :ticketId order by createdDate desc];
        
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
            errStr = JSON.serialize(SS_TicketingSystem_Controller.buildErrorResponse('manageTicket', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
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
    }
   
    
    public class DashboardWrapper{ 
        @AuraEnabled public Integer newCount=0; 
        @AuraEnabled public Integer closedCount=0; 
        @AuraEnabled public Integer inProgressCount=0; 
        @AuraEnabled public Integer onHoldCount=0;
        @AuraEnabled public Integer ApprovalCount=0;
        
    }
    
    public class TicketHistoryWrapper{ 
        @AuraEnabled 
        public String name ;
        @AuraEnabled 
        public String Description ;
        @AuraEnabled 
        public String CaseType ;
        @AuraEnabled 
        public String status ;
        @AuraEnabled 
        public String createdDate ; 
        @AuraEnabled 
        public String ticketId ; 
    }
    
    
    
    
    // Logged in user Details
    @AuraEnabled 
    public static String fetchUser(){
        User oUser = [select id,Name,Profile.Name,AccountId,ContactId, Username,Country,Email,FirstName,LastName,IsActive
                      FROM User Where id =: userInfo.getUserId()];
        return JSON.serializePretty(oUser) ;
    }
       @AuraEnabled 
    public static String getApprovalDetails(String recId){
     ProcessInstanceWorkitem   pWorkItem  = [select id,ActorId,ElapsedTimeInDays,ProcessInstanceId,ProcessInstance.TargetObjectId from ProcessInstanceWorkitem where 
                      ProcessInstance.TargetObjectId=:recId];
        return JSON.serializePretty(pWorkItem.id) ;
    }
     @TestVisible
    private static Map<String, String> buildErrorResponse(String source, String errorMessage, String stackTrace) {
        Map<String, String> errorResponse = new Map<String, String>();
        
        errorResponse.put('SOURCE', source);
        errorResponse.put('MESSAGE', errorMessage);
        errorResponse.put('STACKTRACE', stackTrace);
        
        return errorResponse;
    }  
    

}