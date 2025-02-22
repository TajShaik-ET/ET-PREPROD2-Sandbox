/*******************************************************************************************************************
Class       : ETSALES_OpportunityTrigger_Handler
Author      : 
Description : 
TestClass   : ETSALES_OpportunityTrigger_Handler_Test
----------------------------------------------------------------------------------------------------------------            
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version     Date      Modified By           Details
1.        V1                                    Initial Version
2.        V2       8/3/2023   Sreelakshmi SK    Added the method additionalGrowthFormula
3.        V3       14/3/2023  Sreelakshmi SK    Modified method additionalGrowthFormula
4.        V4       09/06/2023  Manisha T        Added the method OppTypeValidationForInsert , OppTypeValidationForUpdate
*******************************************************************************************************************/

public class ETSALES_OpportunityTrigger_Handler {
    
    public static void glCodeAddition(List<Opportunity> newOpportunity){
        System.debug('Entered glCodeAddition');
        Set<Id> oppOwnerSet = new Set<Id>();
        for(Opportunity oppItem : newOpportunity){
            oppOwnerSet.add(oppItem.OwnerId);
        }
        
        List<User_GL_Mapping__c> mappingRecList = [SELECT Id,Name,User__c,GL_Activity__c,GL_Department__c,ETSALES_GL_Location__c,GL_Project__c,Sector__c,
                                                   GL_Activity__r.Name,GL_Department__r.Name,GL_Zone_Lookup__c,ETSALES_GL_Location__r.Name,ETSALES_GL_Location__r.GL_Zone__c,
                                                   ETSALES_GL_Location__r.GL_Region__c,GL_Project__r.Name 
                                                   FROM User_GL_Mapping__c WHERE User__c IN: oppOwnerSet];
        
        for(Opportunity oppItem :newOpportunity){
            for(User_GL_Mapping__c glmap : mappingRecList ){
                system.debug('Opportunity Id : '+oppItem.OwnerId );
                system.debug('User Mapping Id: '+glmap.User__c);
                if(oppItem.OwnerId == glmap.User__c){
                    oppItem.GL_Activity_Lookup__c =glmap.GL_Activity__c;
                    oppItem.GL_Department_Lookup__c = glmap.GL_Department__c;
                    oppItem.GL_Location_Lookup__c = glmap.ETSALES_GL_Location__c;
                    oppItem.GL_Project_Code_Lookup__c = glmap.GL_Project__c;
                    oppItem.GL_Zone_Lookup__c = glmap.GL_Zone_Lookup__c;
                    System.debug('GL Zone Lookup from GLMap: '+glmap.GL_Zone_Lookup__c);
                    System.debug('GL Zone Lookup for opp: '+oppItem.GL_Zone_Lookup__c);
                    oppItem.GL_Region__c = glmap.ETSALES_GL_Location__r.GL_Region__c;
                    oppItem.ETSALES_Sector__c = glmap.Sector__c;
                    
                }
            }
        }
        
    }
    public static void gltenderLocation(List<Opportunity> newOpportunity){
        List<ETSALES_Tender__c> tenderList=new List<ETSALES_Tender__c>();
        system.debug('Opportunity @@@@ '+newOpportunity );
        for(Opportunity oppItem :newOpportunity){
            ETSALES_Tender__c etd=  new ETSALES_Tender__c();
            etd.Id=oppItem.ETSALES_Tender__c ;
            etd.GL_Zone_Lookup__c=oppItem.GL_Zone_Lookup__c;
            etd.GL_Location_Lookup__c=oppItem.GL_Location_Lookup__c;
            etd.GL_Zone_Text__c=oppItem.GL_Zone_Lookup__r.Name;
            etd.GL_Activity_Lookup__c=oppItem.GL_Activity_Lookup__c;
            etd.GL_Department_Lookup__c=oppItem.GL_Department_Lookup__c;
            etd.GL_Project_Lookup__c=oppItem.GL_Project_Code_Lookup__c;
            etd.GL_Region__c=oppItem.GL_Region__c;
            system.debug('User Mapping Id: '+etd);
            
            
            tenderList.add(etd);
        }
        system.debug('User Mapping Id: '+tenderList);
        
        if(tenderList.size()>0)   update tenderList;     
    }
    
    public static void glCodeAddition1(List<Opportunity> newOpportunity){
        System.debug('Entered glCodeAddition1');
        Set<Id> oppOwnerSet = new Set<Id>();
        for(Opportunity oppItem : newOpportunity){
            oppOwnerSet.add(oppItem.OwnerId);
        }
        
        List<User_GL_Mapping__c> mappingRecList = [SELECT Id,Name,User__c,GL_Activity__c,GL_Department__c,ETSALES_GL_Location__c,GL_Project__c,
                                                   GL_Activity__r.Name,GL_Department__r.Name,ETSALES_GL_Location__r.Name,ETSALES_GL_Location__r.GL_Zone__c,
                                                   ETSALES_GL_Location__r.GL_Region__c,GL_Project__r.Name 
                                                   FROM User_GL_Mapping__c WHERE User__c IN: oppOwnerSet];
        
        for(Opportunity oppItem :newOpportunity){
            for(User_GL_Mapping__c mappingItem : mappingRecList ){
                system.debug('Opportunity Id : '+oppItem.OwnerId );
                system.debug('User Mapping Id: '+mappingItem.User__c);
                if(oppItem.OwnerId == mappingItem.User__c){
                    oppItem.GL_Activity__c = mappingItem.GL_Activity__r.Name;
                    oppItem.GL_Project__c = mappingItem.GL_Project__r.Name;
                    oppItem.GL_Department__c = mappingItem.GL_Department__r.Name;
                    oppItem.GL_Location__c = mappingItem.ETSALES_GL_Location__r.Name;
                    oppItem.GL_Region__c = mappingItem.ETSALES_GL_Location__r.GL_Region__c;
                    oppItem.GL_Zone__c = mappingItem.ETSALES_GL_Location__r.GL_Zone__c;
                }
            }
        }
        
    }
    
    public static void assignopportunityowner(List<opportunity> oppList){
        //added by shubham- for opportunity assignment for adnoc profile 
        Map<String, String> adnocAccOppMap = new Map<String, String>();
        ADNOC_Opportunity_Assignment__mdt[] adnocAssignmentmtdList = [SELECT MasterLabel,AccountId__c,Opportunity_Owner_Id__c
                                                                      FROM ADNOC_Opportunity_Assignment__mdt];
        for(ADNOC_Opportunity_Assignment__mdt ad:adnocAssignmentmtdList){
            adnocAccOppMap.put(ad.AccountId__c, ad.Opportunity_Owner_Id__c);
        }  
        
        Map<String, List<Opportunity_Assignment__mdt>> serviceCategoryMap = new Map<String, List<Opportunity_Assignment__mdt>>();
        Opportunity_Assignment__mdt[] InActiveEmailRecords = [Select MasterLabel, Location__c, is_Multi_City__c,
                                                              Record_Type__c, Owner_Id__c from Opportunity_Assignment__mdt];
        Set<String> userNameList = new Set<String>();
        for(Opportunity_Assignment__mdt record:InActiveEmailRecords) {
            userNameList.add(record.Owner_Id__c);
            if(record.Record_Type__c != null){
                if(serviceCategoryMap.containskey(record.Record_Type__c.tolowercase())){
                    List<Opportunity_Assignment__mdt> oppAssignList = serviceCategoryMap.get(record.Record_Type__c.tolowercase());
                    oppAssignList.add(record);
                    serviceCategoryMap.put(record.Record_Type__c.tolowercase(), oppAssignList);
                }else{
                    serviceCategoryMap.put(record.Record_Type__c.tolowercase(), new List<Opportunity_Assignment__mdt>{record});
                }
            }
            
        }
        Map<String, User> userMap = new Map<String, User>();
        System.debug('userNameList' + userNameList);
        for(User us : [select id,userName from user WHERE userName IN :userNameList]){
            userMap.put(us.userName, us);
        }
        List<opportunity> oppListToBeUpdated  = new  List<opportunity> ();
        System.debug('userMap ' + userMap);
        
        User u=[Select Id,Name,AccountId from User where Id=:userInfo.getUserId() LIMIT 1];
        
        system.debug('adnocAccOppMap= '+adnocAccOppMap);
        system.debug('user rec= '+u);
        
        for(Opportunity opp: [SELECT Category__c, OwnerId, recordtypeid, Preferred_Location__c FROM Opportunity WHERE id IN :oppList]){
            
            if(adnocAccOppMap.containsKey(u.AccountId)){
                system.debug('inside if72');
                opp.OwnerId = adnocAccOppMap.get(u.AccountId);
                oppListToBeUpdated.add(opp);
            }else{
                system.debug('inside else 77');
                if(opp.Category__c != null && serviceCategoryMap.containskey(opp.Category__c.tolowercase())){
                    for(Opportunity_Assignment__mdt oppAssMdt : serviceCategoryMap.get(opp.Category__c.tolowercase())){
                        if((oppAssMdt.Location__c == null || oppAssMdt.Location__c == '') && oppAssMdt.Owner_Id__c != null){
                            System.debug('oppAssMdt123' + oppAssMdt);
                            opp.OwnerId = userMap.get(oppAssMdt.Owner_Id__c).id;
                        }
                        if(opp.Preferred_Location__c != null && oppAssMdt.Location__c != null && !oppAssMdt.is_Multi_City__c && opp.Preferred_Location__c == oppAssMdt.Location__c){
                            opp.OwnerId = userMap.get(oppAssMdt.Owner_Id__c).id;
                            System.debug('oppAssMdt.Owner_Id__c ' + userMap.get(oppAssMdt.Owner_Id__c).id);
                        }else if(oppAssMdt.is_Multi_City__c && opp.Preferred_Location__c != null && oppAssMdt.Location__c != null && oppAssMdt.Location__c.containsIgnoreCase(opp.Preferred_Location__c) ){
                            opp.OwnerId = userMap.get(oppAssMdt.Owner_Id__c).id;
                        }
                    }
                    //  opp.RecordTypeId = recordtypeId;
                    oppListToBeUpdated.add(opp);
                    
                }
            }
            
        }
        system.debug('inside oppListToBeUpdated='+JSON.serializePretty(oppListToBeUpdated));
        update oppListToBeUpdated;
    }
    /*Tyre Project Realted Code*/
    Public static void updateOppDetails(list<Opportunity> trgNew){
        
        list<Opportunity> oppList = [select id,ETT_Tyre_Auto_Number__c from opportunity where ETT_Tyre_Auto_Number__c!= null order by ETT_Tyre_Auto_Number__c desc];
        decimal maxNum=0; 
        if (!oppList.isEmpty()){
            maxNum= oppList[0].ETT_Tyre_Auto_Number__c; 
        }
        
        Id RebuServiceRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETT_Tyre_Refurbishing_Services').getRecordTypeId();
        Id SuppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Tyre_Supplier').getRecordTypeId();
        
        
        for(Opportunity opp : trgNew){
            
            if(opp.RecordTypeId == RebuServiceRecType || opp.RecordTypeId == SuppRecType){
                
                opp.Name = opp.Name +'-'+ (maxNum + 1);
                opp.ETT_Tyre_Auto_Number__c =  maxNum + 1;
                
                maxNum++;
            }
        }
        
        
    }
    /**
* Author: Akash 
* Desc: // here code by akash new method [OppValidationOnStage]for Opportunity update CLOSED WON Show A ERROR validation
* DATE: 11/11/2022
*  Code updated on 26.12.2023 for changed the stage for Legal contract, Sales Agreeemt and Closed Won --Arunsarathy 26.12.2023
* */
    
    public static void OppValidationOnStage(List<Opportunity> newlist){
        
        try {
            map<Id,string> AccIdVsAccNumber = new Map<Id,string>();
            for(Opportunity  oppItem : [select id,account.accountnumber,accountId from opportunity where id=:newlist and account.accountnumber=null]){
                AccIdVsAccNumber.put(oppItem.AccountId,oppItem.account.accountnumber);
                
            }
            Map<String,integer> accIdVsConCount = new Map<String,integer>();
            Map<String,integer> accIdVsfileCount = new Map<String,integer>();
            Set<Id> accIdset = AccIdVsAccNumber.keySet();
            
            AggregateResult[] contactAgg = [SELECT Count(Id) conCount,AccountID accId FROM contact where accountId=:AccIdVsAccNumber.keySet() group by AccountID ];
            if(accIdset.size()>0){
                AggregateResult[] fileAgg = [SELECT Count(ContentDocumentId) fileCount, LinkedEntityId AccId FROM ContentDocumentLink WHERE LinkedEntityId IN:accIdset group by LinkedEntityId ];
                for(AggregateResult  File : fileAgg ){
                    accIdVsfileCount.put(String.valueOf(File.get('AccId')),Integer.valueOf(File.get('fileCount')));
                }
                
            }
            
            
            for(AggregateResult agg : contactAgg){
                
                accIdVsConCount.put(String.valueOf(agg.get('accId')),Integer.valueOf(agg.get('conCount')));
                
            }
            
            
            Id RTId_Leasing = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
            Id RTId_Manpower = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Manpower').getRecordTypeId();
            Id RTId_Transportation = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Transportation').getRecordTypeId();
            Id RTId_Maintainance = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Maintainance').getRecordTypeId();
            Id RTId_Logistics = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Logistics').getRecordTypeId();
            Id RTId_Limousine_B2B = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Chauffeur_and_Limousine_B2B').getRecordTypeId();
            
            
            for(Opportunity Opp : newlist){
                
                if(AccIdVsAccNumber.containskey(opp.AccountId) && (opp.RecordTypeId==RTId_Leasing || opp.RecordTypeId==RTId_Manpower || opp.RecordTypeId==RTId_Transportation || opp.RecordTypeId==RTId_Maintainance || opp.RecordTypeId==RTId_Logistics || opp.RecordTypeId==RTId_Limousine_B2B)){
                    
                    
                    if((Opp.StageName =='Legal Contract'|| Opp.StageName =='Sales Agreement' || Opp.StageName =='Closed Won') && accIdVsConCount.get(opp.AccountId) == null ){ // changed the stage for Legal contract, Sales Agreeemt and Closed Won --Arunsarathy 26.12.2023
                        
                        opp.AccountId.addError(label.Sales_Opp_Err_Msg2);
                    }
                    
                    if((Opp.StageName =='Legal Contract'|| Opp.StageName =='Sales Agreement' || Opp.StageName =='Closed Won') && accIdVsfileCount.get(opp.AccountId) == null){ // changed the stage for Legal contract, Sales Agreeemt and Closed Won --Arunsarathy 26.12.2023
                        
                        opp.AccountId.addError(label.Sales_Opp_Err_Msg);
                        
                    }
                }
            }
            
        }
        
        catch (NullPointerException ex) {
            System.debug('Exception'+ex);
        }
    }
    /*Code Added by Sreelakshmi SK -- START*/  
    /* Method Name: additionalGrowthFormula
* Description: Method to assign values to Additional Growth formula based on condition
* Created Date: 20/2/2023
* Last Modified: 14/03/2023
*/
    public static void additionalGrowthFormula(Map<Id,Opportunity> oppNewMap, Map<Id,Opportunity> oppOldMap){
        List<Opportunity> updateOppList= new List<Opportunity>();
        set <Id> recordTypeIds= new set <Id>();
        
        recordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Manpower').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Transportation').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Logistics').getRecordTypeId());
        recordTypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Chauffeur_and_Limousine_B2B').getRecordTypeId());
        
        for(Opportunity opp:oppNewMap.Values()){
            Opportunity tempOpp=new Opportunity();
            tempOpp.id=opp.id;
            
            if(recordTypeIds.contains(opp.RecordTypeId)){
                if((opp.Contract_Years__c!=null || opp.Contract_Months__c!=null || opp.Contract_Weeks__c!=null || opp.Contract_Days__c!=null) && (opp.Contract_Years_Previous_Contract__c!=null || opp.Contract_Months_Previous_Contract__c!=null || opp.Contract_Weeks_Previous_Contract__c!=null || opp.Contract_Days_Previous_Contract__c!=null)){ 
                    System.debug('Entered if loop 2');
                    if(opp.Contract_Years__c !=oppOldMap.get(opp.Id).Contract_Years__c || opp.Contract_Years_Previous_Contract__c !=oppOldMap.get(opp.Id).Contract_Years_Previous_Contract__c || opp.Amount !=oppOldMap.get(opp.Id).Amount || opp.Amount_Previous_Contract__c!=oppOldMap.get(opp.Id).Amount_Previous_Contract__c || opp.Contract_Months__c !=oppOldMap.get(opp.Id).Contract_Months__c || opp.Contract_Months_Previous_Contract__c !=oppOldMap.get(opp.Id).Contract_Months_Previous_Contract__c || opp.Contract_Weeks_Previous_Contract__c !=oppOldMap.get(opp.Id).Contract_Weeks_Previous_Contract__c || opp.Contract_Weeks__c !=oppOldMap.get(opp.Id).Contract_Weeks__c || opp.Contract_Days_Previous_Contract__c !=oppOldMap.get(opp.Id).Contract_Days_Previous_Contract__c || opp.Contract_Days__c !=oppOldMap.get(opp.Id).Contract_Days__c) {
                        
                        Decimal ContractYearPrv;
                        Decimal ContractMonthPrv;
                        Decimal ContractWeekPrv;
                        Decimal ContractDaysPrv;
                        
                        Decimal ContractYearCrnt;
                        Decimal ContractMonthCrnt;
                        Decimal ContractWeekCrnt;
                        Decimal ContractDaysCrnt;
                        
                        Decimal AmountCrnt;
                        Decimal AmountPrv;
                        
                        if(opp.Contract_Years_Previous_Contract__c==null){ContractYearPrv=0;} else{ContractYearPrv=Integer.valueOf(opp.Contract_Years_Previous_Contract__c);}
                        if(opp.Contract_Months_Previous_Contract__c==null){ContractMonthPrv=0;} else{ContractMonthPrv=Integer.valueOf(opp.Contract_Months_Previous_Contract__c);}
                        if(opp.Contract_Weeks_Previous_Contract__c==null){ContractWeekPrv=0;} else{ContractWeekPrv=Integer.valueOf(opp.Contract_Weeks_Previous_Contract__c);}
                        if(opp.Contract_Days_Previous_Contract__c==null){ContractDaysPrv=0;} else{ContractDaysPrv=Integer.valueOf(opp.Contract_Days_Previous_Contract__c);}
                        
                        if(opp.Contract_Years__c==null){ContractYearCrnt=0;} else{ContractYearCrnt=Integer.valueOf(opp.Contract_Years__c);}
                        if(opp.Contract_Months__c==null){ContractMonthCrnt=0;} else{ContractMonthCrnt=Integer.valueOf(opp.Contract_Months__c);}
                        if(opp.Contract_Weeks__c==null){ContractWeekCrnt=0;} else{ContractWeekCrnt=Integer.valueOf(opp.Contract_Weeks__c);}
                        if(opp.Contract_Days__c==null){ContractDaysCrnt=0;} else{ContractDaysCrnt=Integer.valueOf(opp.Contract_Days__c);}
                        
                        if(opp.Amount==null){AmountCrnt=0;} else{AmountCrnt=opp.Amount;}
                        if(opp.Amount_Previous_Contract__c==null){AmountPrv=0;} else{AmountPrv=opp.Amount_Previous_Contract__c;}
                        
                        Decimal periodPrv= (365*( 4*( (12* ContractYearPrv) + ContractMonthPrv ) + ContractWeekPrv ) + (48*ContractDaysPrv))/(48*365);
                        Decimal periodCrnt= (365*( 4*( (12* ContractYearCrnt) + ContractMonthCrnt ) + ContractWeekCrnt ) + (48*ContractDaysCrnt))/(48*365);
                         System.debug('periodPrv'+periodPrv);
                          System.debug('periodCrnt'+periodCrnt);
                        Decimal CommonFormula= ( AmountCrnt / periodCrnt )-( AmountPrv / periodPrv );
                         System.debug('CommonFormula'+CommonFormula);
                        Decimal Formula1= CommonFormula*periodCrnt;
                         System.debug('Formula1'+Formula1);
                        Decimal Formula2= (CommonFormula*periodPrv)+1;
                         System.debug('Formula2'+Formula2);
                        Decimal Formula3= Formula1 + 1;
                         System.debug('Formula3'+Formula3);
                        
                        if(opp.Contract_Years__c==null && opp.Contract_Years_Previous_Contract__c!=null){
                            if(Integer.valueOf(opp.Contract_Years_Previous_Contract__c)>=1){
                                tempOpp.Annual_Amount_Additional_Growth__c= Formula1;
                            }  
                        }
                        
                        else if(opp.Contract_Years_Previous_Contract__c==null && opp.Contract_Years__c!=null){
                            if(Integer.valueOf(opp.Contract_Years__c)>=1){
                                tempOpp.Annual_Amount_Additional_Growth__c= null;
                            }
                            
                        }
                        
                        else if(opp.Contract_Years__c==null && opp.Contract_Years_Previous_Contract__c==null){
                            tempOpp.Annual_Amount_Additional_Growth__c= Formula3;
                        }
                         System.debug('tempOpp.Annual_Amount_Additional_Growth__c'+tempOpp.Annual_Amount_Additional_Growth__c);
                        updateOppList.add(tempOpp);
                    }
                }
                else{
                    if(opp.Contract_Years__c !=oppOldMap.get(opp.Id).Contract_Years__c || opp.Contract_Years_Previous_Contract__c !=oppOldMap.get(opp.Id).Contract_Years_Previous_Contract__c || opp.Amount !=oppOldMap.get(opp.Id).Amount || opp.Amount_Previous_Contract__c!=oppOldMap.get(opp.Id).Amount_Previous_Contract__c || opp.Contract_Months__c !=oppOldMap.get(opp.Id).Contract_Months__c || opp.Contract_Months_Previous_Contract__c !=oppOldMap.get(opp.Id).Contract_Months_Previous_Contract__c || opp.Contract_Weeks_Previous_Contract__c !=oppOldMap.get(opp.Id).Contract_Weeks_Previous_Contract__c || opp.Contract_Weeks__c !=oppOldMap.get(opp.Id).Contract_Weeks__c || opp.Contract_Days_Previous_Contract__c !=oppOldMap.get(opp.Id).Contract_Days_Previous_Contract__c || opp.Contract_Days__c !=oppOldMap.get(opp.Id).Contract_Days__c){
                        
                        tempOpp.Annual_Amount_Additional_Growth__c=null;
                        updateOppList.add(tempOpp);
                    }
                    
                }
            }
            
        }
        
        if(updateOppList.size()>0){
            update updateOppList;
        }
        
    }
    
/* 
*  Author: Manisha
*  Method Name:  OppTypeValidationForInsert
*  Description:  Validation on opportunity while creating new business type - if any opp already exist for that account in
                 closed won/sales agreement stage throw validation error.

*  Method Name: OppTypeValidationForUpdate
*  Description: Validation on opportunity while creating new business type - if any opp already exist for that account in
                closed won/sales agreement stage throw validation error.
*  Created Date: 02/06/2023
*/
    
    
    public static void OppTypeValidationForInsert(List<Opportunity> newOppList) {
        Set<Id> accountIds = new Set<Id>();
        Profile p = [select id,Name from Profile where id=:Userinfo.getProfileid()];
        list<string> profileList = new list<string>();
        profileList = system.label.skipOppValidationProfile.split(',');
        
        if(!newOppList.isempty() && newOppList.size()>0){
            for (Opportunity opp : newOppList) {
                  if (opp.Type == 'New Business' && !profileList.contains(p.name)){
                        accountIds.add(opp.AccountId);
                 }    
              }
           }
        
        List<Opportunity> existingOpportunities = [SELECT Id, Name, AccountId, Type FROM Opportunity
                                                   WHERE AccountId IN :accountIds AND (StageName = 'Closed Won')];
        
     
        Map<Id, Opportunity> accountIdVsOppInfo = new Map<Id, Opportunity>();
        
        if(!existingOpportunities.isempty() && existingOpportunities.size()>0){
            for (Opportunity existingOpp : existingOpportunities) {
                accountIdVsOppInfo.put(existingOpp.AccountId, existingOpp);
            }
        }
        
        if(!accountIdVsOppInfo.isempty() && accountIdVsOppInfo.size()>0){
            for (Opportunity opp : newOppList) {
                if (accountIdVsOppInfo.containsKey(opp.AccountId)) {
                    opp.addError('Validation Error: There is an opportunity with Stage "Closed Won" for the same Account. Please change the Opportunity Type');
                }
            }
        }
    }
    
  
    public static void OppTypeValidationForUpdate(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap) {
      Set<Id> accountIds = new Set<Id>();
      Profile p = [select id,Name from Profile where id=:Userinfo.getProfileid()];
        list<string> profileList = new list<string>();
        profileList = system.label.skipOppValidationProfile.split(',');

        for (Opportunity opp : newOppList) {
            if (oldOppMap != null && oldOppMap.get(opp.Id).Type != opp.Type && opp.Type == 'New Business' && !profileList.contains(p.name) ){
                accountIds.add(opp.AccountId);
            }
        }
      List<Opportunity> existingOpportunities = [SELECT Id, Name, AccountId, Type FROM Opportunity WHERE AccountId IN :accountIds AND (StageName = 'Closed Won' )];
      Map<Id, Opportunity> accountIdVsOppInfo = new Map<Id, Opportunity>();
   
      for (Opportunity existingOpp : existingOpportunities) {
        accountIdVsOppInfo.put(existingOpp.AccountId, existingOpp);
      }

      if(!accountIdVsOppInfo.isempty() && accountIdVsOppInfo.size()>0){
      for (Opportunity opp : newOppList) {
        if (accountIdVsOppInfo.containsKey(opp.AccountId)) {
            opp.addError('Validation Error: There is an opportunity with Stage "Closed Won" for the same Account. Please change the Opportunity Type');
        }
      }
    }
  }

}