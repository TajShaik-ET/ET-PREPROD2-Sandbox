public class ETST_MyServicesController {
  @AuraEnabled(cacheable=true)
  public static List<ET_Service_Request__c> getServiceRequests() {
    ID accID = [SELECT AccountId FROM User WHERE id = :Userinfo.getUserid()].AccountId;
    return [
      SELECT
        Id,
        Name,
        ETST_Is_Active__c,
        ETST_Payee__c,
        ETST_Student_Name__c,
        ETST_Service_Type__c,
        ETST_Transport_Type__c,
        ETST_Pick_Up_Start_Date__c,
        ETST_Pick_Up_End_Date__c,
        ETST_Fare_Charges__c,
        ETST_Refund_Amount__c,
        ETST_Status__c
      FROM ET_Service_Request__c
      WHERE
        ET_Account__c = :accID
        AND (RecordType.DeveloperName = 'ETST_School_Service_Request'
        OR RecordType.DeveloperName = 'ETST_School_Coordinator_Read_Only'
        OR RecordType.DeveloperName = 'ETST_School_Coordinator')
    ];
  }
}

//  ORDER BY createddate DESC
//  LIMIT 10