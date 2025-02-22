public class ET_CustomDashboardController {
    
    @AuraEnabled
    public static DashboardWrapper getDashboardData(){
        User u=[select id,AccountId,Account.Name,contactID from user where id=:userinfo.getUserId()];
        system.debug('DashboardWrapper == '+u);
        DashboardWrapper wrapper = new DashboardWrapper();
        
        //Cases By School
        List<Account> accountList =[Select Id,Name from Account where ParentId=:u.AccountId];
        List<Id> childAccList = New List<Id>();
        for(Account acc:accountList){
            childAccList.add(acc.Id);
        }
        system.debug('childAccList == '+childAccList);
        List<AggregateResult> caseBySchoolCount =  [Select Count(CaseNumber) cnt, Account.Name accName from Case where AccountId IN :childAccList group by Account.Name ];
        List<DataSet> casesPerSchool = new List<DataSet>();
        for(AggregateResult ar:caseBySchoolCount){
            String status =  (String)ar.get('accName') ;
            Integer total =(Integer)ar.get('cnt'); 
            casesPerSchool.add(new DataSet(status ,total));
        }
        System.debug('casesPerSchool'+casesPerSchool);
        wrapper.casesPerSchool = casesPerSchool;
        
        //Cases By status
        List<AggregateResult> caseByStatusCount =  [Select Count(CaseNumber) cnt, Status from Case where AccountId=:u.accountID group by Status ];
        List<DataSet> casesByStatus = new List<DataSet>();
        for(AggregateResult ar:caseByStatusCount){
            String status =  (String)ar.get('Status') ;
            Integer total =(Integer)ar.get('cnt'); 
            casesByStatus.add(new DataSet(status ,total));
            
        }
        System.debug('casesByStatus'+casesByStatus);
        wrapper.casesByStatus = casesByStatus;
        
        //Cases By type
        List<AggregateResult> caseTypeCount =  [Select Count(CaseNumber) cnt, ETST_Complaint_Type__c from Case where AccountId=:u.accountID group by ETST_Complaint_Type__c ];
        List<DataSet> casesByType = new List<DataSet>();
        for(AggregateResult ar:caseTypeCount){
            String type =  (String)ar.get('ETST_Complaint_Type__c') ;
            Integer total =(Integer)ar.get('cnt'); 
            casesByType.add(new DataSet(type ,total));
            
        }
        System.debug('casesByType'+casesByType);
        wrapper.casesByType = casesByType;
        
        return wrapper;
    }
    
    @AuraEnabled
    public static DashboardWrapper getSpecialRequestDashboardData(){
        String listoftypes=System.Label.ET_Special_Requests_Record_Types;
        List<String>  casetypeList= new List<String>();
        casetypeList=listoftypes.split(',');
        
        User u=[select id,AccountId,Account.Name,contactID from user where id=:userinfo.getUserId()];
        system.debug('DashboardWrapper == '+u);
        DashboardWrapper wrapper = new DashboardWrapper();
        
        //Cases By School
        List<Account> accountList =[Select Id,Name from Account where ParentId=:u.AccountId];
        List<Id> childAccList = New List<Id>();
        childAccList.add(u.AccountId);
        for(Account acc:accountList){
            childAccList.add(acc.Id);
        }
        system.debug('childAccList == '+childAccList);
        List<AggregateResult> caseBySchoolCount =  [Select Count(CaseNumber) cnt, Account.Name accName from Case where AccountId IN :childAccList AND RecordType.Name IN :casetypeList group by Account.Name ];
        List<DataSet> casesPerSchool = new List<DataSet>();
        for(AggregateResult ar:caseBySchoolCount){
            String status =  (String)ar.get('accName') ;
            Integer total =(Integer)ar.get('cnt'); 
            casesPerSchool.add(new DataSet(status ,total));
        }
        System.debug('casesPerSchool'+casesPerSchool);
        wrapper.casesPerSchool = casesPerSchool;
        
        //Cases By status
        List<AggregateResult> caseByStatusCount =  [Select Count(CaseNumber) cnt, Status from Case where AccountId=:u.accountID AND  RecordType.Name IN :casetypeList group by Status ];
			system.debug('dash caseByStatusCount '+caseByStatusCount);
        List<DataSet> casesByStatus = new List<DataSet>();
        for(AggregateResult ar:caseByStatusCount){
            String status =  (String)ar.get('Status') ;
            Integer total =(Integer)ar.get('cnt'); 
            casesByStatus.add(new DataSet(status ,total));
             system.debug('dash123 status '+status);
             system.debug('dash123 total '+total);
            system.debug('dash casesByStatus '+casesByStatus);
        }
        System.debug('checkcasesByStatus'+casesByStatus);
        wrapper.casesByStatus = casesByStatus;
          System.debug('wrappercasesByStatus'+wrapper.casesByStatus);
        //Cases By type
        List<AggregateResult> caseTypeCount =  [Select Count(CaseNumber) cnt, ETST_Complaint_Type__c from Case where AccountId=:u.accountID AND RecordType.Name IN :casetypeList group by ETST_Complaint_Type__c ];
      system.debug('dash caseTypeCount '+caseTypeCount);
        List<DataSet> casesByType = new List<DataSet>();
        for(AggregateResult ar:caseTypeCount){
            String type =  (String)ar.get('ETST_Complaint_Type__c') ;
            Integer total =(Integer)ar.get('cnt'); 
            casesByType.add(new DataSet(type ,total));
            system.debug('dash456 type '+type);
             system.debug('dash456 total '+total);
             system.debug('dash casesByType '+casesByType);
        }
        System.debug('dshboardcasesByType'+casesByType);
        wrapper.casesByType = casesByType;
        System.debug(' wrappercasesByTyp'+ wrapper.casesByType);
        return wrapper;
    }
    
    public class DataSet{
        public DataSet(String label ,Integer count){
            this.label  = label ; 
            this.count = count ;
        }
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public Integer  count {get;set;}
        
        
    }
    
    public class DashboardWrapper{
        
        @AuraEnabled public List<DataSet> casesPerSchool {get;set;}
        @AuraEnabled public List<DataSet> casesByType {get;set;}
        @AuraEnabled public List<DataSet> casesByStatus {get;set;}
        public DashboardWrapper(){
            casesPerSchool = new List<DataSet> ();
            casesByType  = new List<DataSet> ();
            casesByStatus = new List<DataSet> ();
        }
        
    }
    
    
    // Example 2
    //  @auraEnabled
  /*  public List<LineChartVar> myLineChartVarList;
    
    public class LineChartVar {
        string label;
        integer firstValue;
        integer secondValue;       
        
        public LineChartVar(string a, integer b, integer c){
            label = a;
            firstValue = b;
            secondValue = c;
        } 
    }
    
    @auraEnabled
    public static Map<string, integer> getChartMap(){
        Map<string, integer> mp = new Map<string, integer>();        
        mp.put('Jan', 45);
        mp.put('Feb', 50);
        mp.put('Mar', 30);
        mp.put('Apr', 36);
        mp.put('May', 42);
        mp.put('Jun', 39);
        mp.put('Jul', 41);
        mp.put('Aug', 36);
        mp.put('Sep', 43);
        mp.put('Oct', 45);
        mp.put('Nov', 33);
        mp.put('Dec', 53);
        
        return mp;
    }
    
    @auraEnabled
    public static string getLineChartMap(){
        List<LineChartVar> myLineChartVarList = new List<LineChartVar>();
        
        myLineChartVarList.add(new LineChartVar('2010', 10, 12));
        myLineChartVarList.add(new LineChartVar('2011', 12, 15));
        myLineChartVarList.add(new LineChartVar('2012', 17, 19));
        myLineChartVarList.add(new LineChartVar('2013', 19, 17));
        myLineChartVarList.add(new LineChartVar('2014', 21, 15));
        myLineChartVarList.add(new LineChartVar('2015', 17, 20));
        myLineChartVarList.add(new LineChartVar('2016', 18, 16));        
        return JSON.Serialize(myLineChartVarList);
    } */
}