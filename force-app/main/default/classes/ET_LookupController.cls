public class ET_LookupController {
    @AuraEnabled
    public static List<sObject> fetchLookUpValues(String searchKeyWord, String ObjectName, string studentType, 
                                                  String currentValue, string lang) {
                                                      List<ETST_School_Type__mdt> schoolTypes = ETST_School_Type__mdt.getall().values();
                                                      for(ETST_School_Type__mdt schType : schoolTypes){
                                                          if(schType.School_Type_AR__c == studentType){
                                                              studentType=schType.Label;
                                                          }
                                                      } 
                                                      String searchKey = '%'+searchKeyWord+'%';   
                                                      List<sObject> returnList = new List<sObject>();
                                                      String sQuery;
                                                      if(ObjectName=='User'){
                                                          sQuery =  'select id,Name from ' +ObjectName + ' where Name LIKE:searchKey order by Name DESC LIMIT 5'; 
                                                      }
                                                      if(ObjectName=='ETST_School__c'){
                                                          if(!system.Test.isRunningTest()){
                                                              String userAccountId=[select accountId from user where id=:userInfo.getUserId()].accountId;  
                                                              String loc=[select ET_Preferred_Location__c from Account where id=:userAccountId].ET_Preferred_Location__c;
                                                              System.debug('loc ' + loc);
                                                          }
                                                          
                                                          System.debug('studentType ' + studentType);
                                                          System.debug('currentValue ' + currentValue);
                                                          System.debug('searchKey ' + searchKey);
                                                          if(lang =='ar'){
                                                              sQuery =  'select id,Name,ETST_Name_AR__c,ETST_School_Name_AR_City__c,ETST_School_Code__c, ETST_School_Name_City__c from ' +ObjectName + ' where Name LIKE:searchKey ';
                                                              if(studentType!=null && studentType!=''){
                                                                  sQuery +=  ' AND ETST_Account_Type__c=:studentType ';    
                                                              } 
                                                              if(currentValue!=null && currentValue!=''){
                                                                  sQuery +=  ' AND ETST_Name_AR__c!=:currentValue ';    
                                                              }
                                                              sQuery +=  ' order by createdDate DESC LIMIT 5';
                                                          } else {
                                                              sQuery =  'select id,Name,ETST_School_Name_City__c,ETST_School_Code__c from ' +ObjectName + ' where Name LIKE:searchKey ';
                                                              if(studentType!=null && studentType!=''){
                                                                  sQuery +=  ' AND ETST_Account_Type__c=:studentType ';    
                                                              }
                                                              if(currentValue!=null && currentValue!=''){
                                                                  sQuery +=  ' AND Name!=:currentValue ';    
                                                              }
                                                              sQuery +=  ' order by createdDate DESC LIMIT 5';
                                                          }
                                                          
                                                      }
                                                      System.debug('sQuery ' + sQuery);
                                                      List<sObject> lstOfRecords = Database.query(sQuery);       
                                                      for(sObject obj: lstOfRecords) {
                                                          returnList.add(obj);
                                                          
                                                      }
                                                      system.debug('returnList***'+returnList);
                                                      return returnList;
                                                  }
}