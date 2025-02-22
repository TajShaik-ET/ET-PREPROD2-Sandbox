/***
Class       : surveyPageController
Author      : Sreelakshmi SK
Description : Test class for surveyPageController
Created on  : 11 May 23
***/

@isTest
public class surveyPageControllerTest {
    public static testmethod void createSurveyRecTest(){
        Survey__c surveyRecord=new Survey__c();
        
        insert surveyRecord;
        Case caseRecord= new Case();
        caseRecord.Id=caseRecord.Id;
        caseRecord.Survey_Responded__c=true;
        
        try
        {
            surveyPageController.createSurveyRec(surveyRecord,caseRecord);
        }
        catch(exception e)
        {
        }         
    }
    
    public static testmethod void getSurveyRecordTest(){
        Case newCase= new Case();
        insert newCase;
        
        surveyPageController.utilityMethod();
        surveyPageController.getSurveyRecord(newCase.id);
    }
}