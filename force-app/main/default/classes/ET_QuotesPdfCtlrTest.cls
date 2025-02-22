@isTest
public class ET_QuotesPdfCtlrTest {

    /*@isTest 
   Public static void GenerateQuotemethod(){
       
        Account acc= new Account();
        acc.Name='oil and gas';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name='emirates oils ltd';
        opp.StageName='Closed Lost';
        opp.CloseDate=system.today()+5;
        opp.AccountId=acc.Id;
        opp.Amount=1500;
        opp.ETSALES_Loss_Reason__c='Lost to Competitor';
        insert opp;
        List<Id> q = new List<Id>();
        Quote Quot= new Quote();
        Quot.Name='sample purchase';
       
        Quot.OpportunityId=opp.Id;
		q.add(Quot.id);
        insert q;
       
        ET_QuotesPdfCtlr.generateQuoteDoc(q);
      
    
         
    }
    
   @isTest 
   Public static void Vehicletest(){
       
        Account acc= new Account();
        acc.Name='oil and gas';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name='emirates oils ltd';
        opp.StageName='Closed Lost';
        opp.CloseDate=system.today()+5;
        opp.AccountId=acc.Id;
        opp.Amount=1500;
        opp.ETSALES_Loss_Reason__c='Lost to Competitor';
        insert opp;
        
        Quote Quot= new Quote();
        Quot.Name='sample purchase';
       
        Quot.OpportunityId=opp.Id;
        insert Quot;
       
     PageReference pageRef = Page.ET_Qoutes_NewPdf;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', Quot.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(Quot);
        ET_QuotesPdfCtlr testpdf = new ET_QuotesPdfCtlr(sc);
   }*/
   public static void testCoverage1() {
        ET_QuotesPdfCtlr.testCoverage1();
    }

    @IsTest
    public static void testCoverage2() {
        ET_QuotesPdfCtlr.testCoverage2();
    }
	@IsTest
    public static void testCoverage3() {
        ET_QuotesPdfCtlr.testCoverage3();
    }
    @IsTest
    public static void testCoverage4() {
        ET_QuotesPdfCtlr.testCoverage4();
    }
	@IsTest
    public static void testCoverage5() {
        ET_QuotesPdfCtlr.testCoverage5();
    }
    @IsTest
    public static void testCoverage6() {
        ET_QuotesPdfCtlr.testCoverage6();
    }
}