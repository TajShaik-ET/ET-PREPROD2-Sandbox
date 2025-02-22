public class MOTO_AutoPricingToolCtrl {
    
    @auraEnabled    
    public static map<string,list<string>> getMakeVsModel(){
        
        map<string,list<string>> makeVsModel = new map<string,list<string>>();
        for(AggregateResult ap:  [select Make__c make,Model__c model from Auto_Pricing_Details__c group by Make__c,Model__c limit 30000]){
            
            if(!makeVsModel.containsKey((string)ap.get('make'))){
                makeVsModel.put((string)ap.get('make'),new list<string>());
            }
            makeVsModel.get((string)ap.get('make')).add((string)ap.get('model'));
                
        }
        return makeVsModel;
    }
    @auraEnabled    
    public static list<Auto_Pricing_Details__c> getAutoPricingDetails(string make,string model,integer year,string dealerName,integer minKm,integer maxKm,string posted){
        
        string query ='select Make__c,Model__c,Car_Type__c,Color__c,Dealer_Name__c,Kilometer__c,Price__c,URL__c,Year__c,Posting_Time__c from Auto_Pricing_Details__c ';
        string whereClause ='where Make__c=:make and Model__c=:model';
       
        if(year !=null){
            whereClause += ' and Year__c=:year';          
        }
        if(dealerName != null){
            whereClause += ' and Dealer_Name__c like \'%'+dealerName+'%\'';
        }
        if(minKm != null){
             whereClause += ' and Kilometer__c >='+minKm;
        }
        if(maxKm != null){
             whereClause += ' and Kilometer__c <='+maxKm;
        }       
        if(posted == '1_hour_ago'){
            
              whereClause += ' and Posting_Time__c like \'%minute%\'';
        }
        if(posted == '24_hour_ago'){
            
              whereClause += ' and (Posting_Time__c like \'%minutes%\' OR Posting_Time__c like \'%hour%\')';
        }
        if(posted == '1 day' || posted == '2 day' || posted == '3 day' || posted == '4 day' || posted == '5 day'){
            
             whereClause += ' and Posting_Time__c like \'%'+posted+'%\'';
        }
        if(posted == '5_Plus'){
            
             whereClause += ' and Posting_Time__c like \'%day%\' and Posting_Time__c !=\'Posted 1 day ago\' and Posting_Time__c !=\'Posted 2 days ago\' and Posting_Time__c !=\'Posted 3 days ago\' and Posting_Time__c !=\'Posted 4 days ago\' and Posting_Time__c !=\'Posted 5 days ago\'';
        }
        
        string finalQuery = query + whereClause;
        system.debug(finalQuery);
        return database.query(finalQuery);
       //[select Make__c,Model__c,Car_Type__c,Color__c,Dealer_Name__c,Kilometer__c,Price__c,Year__c from Auto_Pricing_Details__c where Make__c=:make and Model__c=:model and Year__c=:year ];
        
        
    }

}