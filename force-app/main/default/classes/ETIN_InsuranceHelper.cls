/**
 * Author: Janardhan
 * Desc: 
 * Test Class: ETIN_InsuranceHelperTest
 * Modifications: Janardhan- 24.02.23 - Added new method - UserAccessCheck
 * 
 * */

public class ETIN_InsuranceHelper {
    
  /* public static void CardNumberValidation(list<ETIN_Insurance__c> Insurance){
        
      map<String,Id> CardNumbervsConID = new map<String,Id>();
        
        set<string> cardNumberList = new set<string>();
        set<id> InsIds = new set<id>();
        
        for(ETIN_Insurance__c et : Insurance){
            
            cardNumberList.add(et.Card_Number__c);
            //InsIds.add(et.Id);
        }
        for(contact con : [select id,ETIN_Insurance_Card_Number__c from contact where ETIN_Insurance_Card_Number__c=:cardNumberList]){
            
            CardNumbervsConID.put(con.ETIN_Insurance_Card_Number__c,con.Id);
        }
        
        for(ETIN_Insurance__c et : Insurance){
            
            
            if(et.Card_Number__c != null && CardNumbervsConID.containskey(et.Card_Number__c) && CardNumbervsConID.get(et.Card_Number__c) != et.Employee__c && et.Renew_Request__c == false){
                
                et.Card_Number__c.addError('Duplicate Card Number - You cannot create new insurance with same number');
            }
        }
        
            
        
    } */ 
    
    public static void duplicateAdditions(list<ETIN_Insurance__c> Insurance){
        
     
        map<Id,Integer> empIdvsRecCount = new map<Id,Integer>();
        map<Id,Integer> empFamildIdvsRecCount = new map<Id,Integer>();
        set<id> empIds = new set<id>();
        set<id>familyIds = new set<id>();
        
        for(ETIN_Insurance__c insval :Insurance){
            empIds.add(insval.EmployeeAcc__c);
            
           
            familyIds.add(insval.Employee_Family__c);
        }
        
        //'where Renew_Request__c = false AND' removed from below 2 queries, added this year condition - Janardhan 05/07/22
        //AND Insurance_Current_Status__c!='Cancelled' ** added on 16/11/22 - Janardhan **

        for(AggregateResult agg : [select count(id) co,EmployeeAcc__c from ETIN_Insurance__c where Relation__c ='Principal' AND EmployeeAcc__c=:empIds AND Effective_Date__c=THIS_YEAR AND Insurance_Current_Status__c!='Cancelled' GROUP BY EmployeeAcc__c] ){
            
            empIdvsRecCount.put((Id)agg.get('EmployeeAcc__c'),(Integer)agg.get('co'));
        }
        for(AggregateResult agg : [select count(id) co,Employee_Family__c from ETIN_Insurance__c Where Employee_Family__c=:familyIds AND Effective_Date__c=THIS_YEAR AND Employee_Family__c!= null AND Insurance_Current_Status__c!='Cancelled' GROUP BY Employee_Family__c] ){
            
            empFamildIdvsRecCount.put((Id)agg.get('Employee_Family__c'),(Integer)agg.get('co'));
        }
        
        
        for(ETIN_Insurance__c et : Insurance){
           
            system.debug(empIdvsRecCount.get(et.Employee_Family__c)+'----');
            system.debug('---empfa-'+empIdvsRecCount.get(et.Employee_Family__c)+'-emp--'+empIdvsRecCount.get(et.EmployeeAcc__c));
            
            if(empIdvsRecCount.get(et.EmployeeAcc__c) != null && empIdvsRecCount.containskey(et.EmployeeAcc__c)  && empIdvsRecCount.get(et.EmployeeAcc__c) >= 1 && et.Relation__c =='Principal' && et.Renew_Request__c == false ){
                
                et.EmployeeAcc__c.addError('Duplicate Addition - You cannot create new employee addition request');
                
            }
            if(empFamildIdvsRecCount.get(et.Employee_Family__c) != null && empFamildIdvsRecCount.containskey(et.Employee_Family__c)  && empFamildIdvsRecCount.get(et.Employee_Family__c) >= 1 && et.Renew_Request__c == false ){
                
                et.EmployeeAcc__c.addError('Duplicate Addition - You cannot create new family addition request');
                
            }
            
            
        }  
    }
    
    public static void OldInsuranceStatusUpdate(list<ETIN_Insurance__c> Insurance){ 
     //This logic is used to inacitve insurances after renewal insurance is activated
     set<Id> oldInsuranceIds = new set<Id>();
     list<ETIN_Insurance__c> updateList = new list<ETIN_Insurance__c>();
        
        for(ETIN_Insurance__c et : Insurance){
            
            if(et.Insurance_Current_Status__c == 'Active' && et.Renew_Request__c == true && et.Renew_Status__c == false){
               oldInsuranceIds.add(et.Previous_Insurance__c);  
            }
           
        }
     if(oldInsuranceIds.size() > 0)
        for(ETIN_Insurance__c etU : [select id,Insurance_Current_Status__c from ETIN_Insurance__c where id=:oldInsuranceIds]){
             
            ETIN_Insurance__c etUpdate = new ETIN_Insurance__c();
            etUpdate.id = etU.Id;
            etUpdate.Insurance_Current_Status__c = 'Inactive';
            
            updateList.add(etUpdate);
         }
      
        if(updateList.size() > 0){
            try{
                update updateList;
                
            }catch(Exception e) {
                
                system.debug('Error:--updating old insurnace status '+ e.getMessage());    
                
            }
        }
          

    
    }
    /**
     * Author: Janardhan
     * Desc: created this method to throw validation of ADNOC HR team if employee is not assigned to ADNOC account.
     * */
    
    /*public static void UserAccessCheck(List<ETIN_Insurance__c> trgNew){
     
     
        set<string> groupNames = new set<string>();
                
        for(GroupMember gm : [select groupId,group.name from GroupMember where UserOrGroupId=:userInfo.getUserId()]){
            
            groupNames.add(gm.group.name);
            
        }
        
        if(groupNames.contains('ADNOC_HR_Team')){
            
            list<string> labelIds = system.label.ADNOC_Accounts.split(',');
            set<id> accIds = new set<id>();
            set<string> empIds = new set<string>();
            map<id,string> accIdVsEmpNo = new map<id,string>();
            
            //adding ParentAccId to the list
            for(string str :labelIds){
                accIds.add(str);
            }  
            for(account acc : [select id from Account where parentId=:labelIds]){
                accIds.add(acc.id);
            }
           
            //getting all the active agreements - resource for Adnoc
            if(accIds != null && accIds.size()>0)
            for(SALine_Assigned_Resource__c ar : [select id,Employee__c from SALine_Assigned_Resource__c where Account__c=:accIds AND Sales_Agreement__r.Contract_Status__c='ACTIVE']){
                
                empIds.add(ar.Employee__c);
                
            }             
          
            if( empIds.size()>0)
            for(ETIN_Insurance__c ins  : trgNew){
               
                if(!empIds.contains(ins.EmployeeAcc__c)){ 
                    
                    ins.EmployeeAcc__c.addError('You don\'t have access to create new Insurance.Please check with Insurance Admin.');
                    
                }              
            } 
        }        
    }   */
    
}