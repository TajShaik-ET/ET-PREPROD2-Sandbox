/*
Name		: TraineeCertificatePdfController
Test Class	: TraineeCertificatePdfController_Test
Author		: Sreelakshmi SK
Created Date: 30 May 2023
Deascription: Extension class for Trainee_Certificate vfp
*/

public class TraineeCertificatePdfController {
    public list<ETDI_Trainees__c> TraineeRecord{get; set;}  
    public TraineeCertificatePdfController(ApexPages.StandardController controller){
        Id traineeId = ApexPages.currentPage().getParameters().get('id');
        String fileName = ApexPages.currentPage().getParameters().get('fileName');
        System.debug(traineeId+' -- '+fileName);
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+fileName+'.pdf'); 
    }
}