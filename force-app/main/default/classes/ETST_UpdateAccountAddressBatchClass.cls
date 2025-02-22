global class ETST_UpdateAccountAddressBatchClass implements Database.Batchable<sObject> {
    global string queryString;
    public set<Id> accountIds = new set<Id>();
    String profileId = [SELECT Id FROM Profile WHERE name =:System.Label.ETST_ETS_Community_Login  LIMIT 1].id;
    List<Account> lstAccount = new List<Account>();
    global ETST_UpdateAccountAddressBatchClass(){
        queryString = 'Select id,Name,Phone,city,street,country,accountId,ETST_Emirates_Id__c ';
        queryString += 'FROM User WHERE IsActive=true AND ProfileId=:profileId AND account.ETSALES_Emirates_Passport__c=null';
    }
    public ETST_UpdateAccountAddressBatchClass(set<Id> accIds){
        accountIds.addAll(accIds);
        queryString = 'Select id,Name,Phone,city,street,country,accountId,ETST_Emirates_Id__c ';
        queryString += 'FROM User WHERE IsActive=true AND ProfileId=:profileId AND account.ETSALES_Emirates_Passport__c=null AND accountId IN:accountIds';
    }
    global Database.QueryLocator start(Database.BatchableContext bc){        
        return Database.getQueryLocator(queryString);
    }
    global void execute(Database.BatchableContext bc, List<User> scope){
        for(User usr : scope){
            Account acc = new Account(Id=usr.accountId);
            acc.Phone = usr.Phone;
            acc.BillingStreet = usr.street;
            acc.BillingCity = usr.city;
            acc.BillingCountry = usr.country;
            acc.ETSALES_Emirates_Passport__c = usr.ETST_Emirates_Id__c;
            lstAccount.add(acc);
        }
        if(!lstAccount.isEmpty() && lstAccount.size()>0){
            update lstAccount;
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
    }