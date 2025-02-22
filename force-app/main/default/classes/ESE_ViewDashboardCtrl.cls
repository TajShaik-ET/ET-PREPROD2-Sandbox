/**
 * Author:Janardhan Muddana
 * CreatedDate: 28/12/2022
 * 
 * */
public without sharing class ESE_ViewDashboardCtrl {
    
    
    @AuraEnabled
    public static List<AggregateResult> getExecTripDetails(list<string> schoolList,date fromDate,date toDate){
        
        string queryStr = 'select count(id) countVal,Morning__c morning from Executed_Trips__c Where Id!= null';
        if(schoolList.size()>0 && !schoolList.contains('All'))
            queryStr +=' AND School__c =:schoolList';  
        if(fromDate != null && toDate != null){
            Datetime fromDateVal = fromDate;
            Datetime toDateVal = toDate;                
            queryStr +=' AND Started_at__c >=:fromDate AND Started_at__c <=:toDate';
        }   
        queryStr +=' group by Morning__c';
        return database.query(queryStr);        
    }
    
    @AuraEnabled
    public static List<Account> getSchoolList(){
        
        return [select id,name,Station_Code__c from Account where Station_Code__c != null];
    }
    
    @AuraEnabled
    public static AggregateResult getSeatOccupiedDetails(){
        return [select avg(Seats_Occupied__c) avgVal from Seats_Occupied__c];
    }
    
    @AuraEnabled
    public static AggregateResult getTripsMoreThanBefore(list<string> schoolList,date fromDate,date toDate){
        
            string queryStr = 'select count(id) countVal from Trips_More_Than__c where Start_Time_data__c <= 06:00:00.000Z and (NOT Grade__c like \'%KG%\')';
            
            if(schoolList.size()>0 && !schoolList.contains('All'))
            queryStr +=' AND School__c =:schoolList';            
            
            if(fromDate != null && toDate != null){
                Datetime fromDateVal = fromDate;
                Datetime toDateVal = toDate;                
                queryStr +=' AND Start_time__c >=:fromDate AND Start_time__c <=:toDate';
            }    
            system.debug(queryStr);
            return database.query(queryStr);

    }
    @AuraEnabled
    public static AggregateResult getKGTripsMoreThan45(list<string> schoolList,date fromDate,date toDate){
        
        string queryStr = 'select  count(id) countVal from Trips_More_Than__c where (Grade__c like \'%KG%\')';
        if(schoolList.size()>0 && !schoolList.contains('All'))
            queryStr +=' AND School__c =:schoolList';  
        if(fromDate != null && toDate != null){
            Datetime fromDateVal = fromDate;
            Datetime toDateVal = toDate;                
            queryStr +=' AND Start_time__c >=:fromDate AND Start_time__c <=:toDate';
        }   
        return database.query(queryStr);
  
    }
     @AuraEnabled
    public static AggregateResult getTripsDuration60_75(list<string> schoolList,date fromDate,date toDate){
       
        string queryStr ='select  count(id) countVal from Trips_More_Than__c where (NOT Grade__c like \'%KG%\') AND Trip_Duration__c >= 60 AND Trip_Duration__c <=75';
        if(schoolList.size()>0 && !schoolList.contains('All'))
            queryStr +=' AND School__c =:schoolList';            
        
        if(fromDate != null && toDate != null){
            Datetime fromDateVal = fromDate;
            Datetime toDateVal = toDate;                
            queryStr +=' AND Start_time__c >=:fromDate AND Start_time__c <=:toDate';
        }
        return database.query(queryStr);
            
    }
     @AuraEnabled
    public static AggregateResult getTripsDurationMore75(list<string> schoolList,date fromDate,date toDate){
       
        string queryStr = 'select  count(id) countVal from Trips_More_Than__c where (NOT Grade__c like \'%KG%\') AND Trip_Duration__c >= 75';
        if(schoolList.size()>0 && !schoolList.contains('All'))
            queryStr +=' AND School__c =:schoolList';            
        
        if(fromDate != null && toDate != null){
            Datetime fromDateVal = fromDate;
            Datetime toDateVal = toDate;                
            queryStr +=' AND Start_time__c >=:fromDate AND Start_time__c <=:toDate';
        } 
        return database.query(queryStr);
    }
     @AuraEnabled
    public static AggregateResult getTotalStudentRegistrations(list<string> schoolList){
        
        string queryStr = 'select count(id) countVal from ESE_Students__c';
        if(schoolList.size()>0 && !schoolList.contains('All'))
            queryStr +=' where School__c =:schoolList';
        
        return database.query(queryStr);   
    }
     @AuraEnabled
    public static AggregateResult getTotalStuWhatsappReq(date fromDate,date toDate){
       string queryStr = 'select sum(Number_of_Students__c) stuSum from Whatsapp_Request__c';
        system.debug(fromDate+'=='+toDate);
        if(fromDate != null && toDate != null){
                Datetime fromDateVal = fromDate;
                Datetime toDateVal = toDate;                
                queryStr +=' where createdDate >=:fromDate AND CreatedDate <=:toDate';
            } 
        system.debug(queryStr);
         return database.query(queryStr);
    }
    
     @AuraEnabled
    public static AggregateResult getBusCountFromTrips(list<string> schoolList,date fromDate,date toDate){
         
        string queryStr = 'select COUNT_DISTINCT(Bus__c) countVal from Executed_Trips__c where id!= null';
        if(schoolList.size()>0 && !schoolList.contains('All'))
            queryStr +=' AND School__c =:schoolList';      
     
        if(fromDate != null && toDate != null){
            Datetime fromDateVal = fromDate;
            Datetime toDateVal = toDate;                
            queryStr +=' AND Started_at__c >=:fromDate AND Started_at__c <=:toDate';
        }         
        return database.query(queryStr);
        
    } 
    
}