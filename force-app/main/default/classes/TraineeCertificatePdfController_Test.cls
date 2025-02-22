/*
 * Class		: TraineeCertificatePdfController_Test
 * Description  : Test class for TraineeCertificatePdfController
 * Author		: Sreelakshmi SK
 * Date			: 19/6/23
*/

@isTest
public class TraineeCertificatePdfController_Test {
    
    @isTest
    public static void testTraineeCertificatePdfController() {
        ETDI_Booking_Request__c bkreq = new ETDI_Booking_Request__c();
        bkreq.Language__c='English';
        insert bkreq;
        ETDI_Trainees__c trainee = new ETDI_Trainees__c();
        trainee.ETDI_Booking_Request__c=bkreq.id;
        insert trainee;
        list<ETDI_Trainees__c>traineeList=new list<ETDI_Trainees__c>();
        traineeList.add(trainee);
        PageReference pageRef = Page.Trainee_Certificate;
        pageRef.getParameters().put('id', trainee.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController standardController = new ApexPages.StandardController(trainee);
        TraineeCertificatePdfController controller = new TraineeCertificatePdfController(standardController);
        
    }
    
    @isTest
    public static void testTraineeRecordGetterSetter() {
        ETDI_Booking_Request__c bkreq = new ETDI_Booking_Request__c();
        bkreq.Language__c='English';
        insert bkreq;
        ETDI_Trainees__c trainee = new ETDI_Trainees__c();
        trainee.ETDI_Booking_Request__c=bkreq.id;
        insert trainee;
        List<ETDI_Trainees__c> trainees = new List<ETDI_Trainees__c>();
        trainees.add(trainee);
        TraineeCertificatePdfController controller = new TraineeCertificatePdfController(null);
        controller.TraineeRecord = trainees;
        List<ETDI_Trainees__c> retrievedTrainees = controller.TraineeRecord;
    }

}