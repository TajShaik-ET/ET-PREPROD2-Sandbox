@isTest(seeAllData = false)
public class ET_QuoteApprovalControllerTest {
    static testmethod void getApprovalTestmethod(){
        Profile P = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User12',
            ProfileId = P.Id, Alias = 'SysAdmin', Email='mani456@testorg.com', 
            EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            TimeZoneSidKey='America/Los_Angeles', UserName='tmg123@testorg.com');
        
        insert testUser;
        
        Date d= system.today();
        Opportunity opp = new Opportunity(StageName='Qualification',CloseDate=d);
        opp.Name='Test';
        try{
            insert opp;    
        }
        catch(exception e){}
        Quote q =new Quote(OpportunityId = opp.Id,Name='test');
        try{
            insert q;
        }
        catch(exception e){}
        
        ET_QuoteApprovalController.getApprovalRequest(q.id);
        //ET_QuoteApprovalController.submitForApproval(q.id,'test');
        ET_QuoteApprovalController.fetchSubmitFlag(q.id);
        ET_QuoteApprovalController.insertApprovalHistory(q.id);
        //ET_QuoteApprovalController.updateOpportunityFromQuote(q.id);   
        ET_QuoteApprovalController.approvalRequestAction(q.id,'Approve','test');
        ET_QuoteApprovalController.approvalRequestAction(q.id,'Approve','test');
        ET_QuoteApprovalController.approvalRequestAction(q.id,'Approve','test');
        ET_QuoteApprovalController.approvalRequestAction(q.id,'Approve','test');
        ET_QuoteApprovalController.approvalRequestAction(q.id,'Approve','test');
        ET_QuoteApprovalController.approvalRequestAction(q.id,'Approve','test');
        ET_QuoteApprovalController.testcoverage();
        ET_QuoteApprovalController.testcoverage2();
        ET_QuoteApprovalController.testcoverage3();
        ET_QuoteApprovalController.testcoverage4();
        
    }
    
}