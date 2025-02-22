/*
*********************************************************
Apex Class Name    : ContentVersionTriggerHelper
Created Date       : January 08, 2024
@description       : This is class is used restrict uploading files for closed cases
@author            : Smaartt 
Modification Log:
Ver   Date         Author                               Modification
1.0   25-08-2023   Santosh Kumar                       Initial Version

*********************************************************
*/
public Without Sharing class ContentVersionTriggerHelper {
    /*
*********************************************************
@Method Name    : checkValidation
@author         : Santosh kumar
@description    : method to is used to check validation rules
@Validation Rule:('Bypass_Case_validation_Rules')          
********************************************************
*/ 
    public static void checkValidation(){
        String systemAdminProfileId = System.Label.SystemAdmin_ProfileId;
        Boolean bypassValiation = UserInfo.getProfileId() == systemAdminProfileId ? true : FeatureManagement.checkPermission('Bypass_Case_validation_Rules');
        List<ContentVersion> cvVersionsList =  Trigger.new;
        System.debug('cvVersionsList:'+cvVersionsList); 
        System.debug('bypassValiation:'+bypassValiation);
        if(!bypassValiation || Test.isRunningTest()){ 
            Map<Id,List<ContentVersion>> locationIdVsListOfCV = new Map<Id,List<ContentVersion>>();
            for(ContentVersion cv: cvVersionsList){
                if(((String)cv.FirstPublishLocationId) != null){
                    if(((String)cv.FirstPublishLocationId).startsWith('500')){
                        if(!locationIdVsListOfCV.containsKey(cv.FirstPublishLocationId)){
                            locationIdVsListOfCV.put(cv.FirstPublishLocationId,new List<ContentVersion>());
                        }
                        locationIdVsListOfCV.get(cv.FirstPublishLocationId).add(cv);
                    }
                }
                System.debug('FirstPublishLocationId:'+cv.FirstPublishLocationId);
            }
            if(locationIdVsListOfCV.size() > 0){
                for(Case cs: [SELECT Id FROM Case WHERE RecordType.Name LIKE '%School%' AND Id IN:locationIdVsListOfCV.keySet() AND isClosed = true]){
                    System.debug('cs.Id:'+cs.Id);
                    for(ContentVersion cv: locationIdVsListOfCV.get(cs.Id)){
                        cv.addError(System.Label.Case_Attachment_Error_Meassae);
                    }
                }
            }
        }
    }
}