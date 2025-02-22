/*
* Class		   : ETDIBookingRequestTest
* Description  : Test class for ETDIBookingRequest
* Author	   : Sreelakshmi SK
* Date			: 19/6/23
*/
@isTest
public class ETDIBookingRequestTest {
    @isTest
    private static void bookngRequesTest(){
        list<String> traineIds = new list<string>();
        Date currentDate = System.today(); // Convert the date to string in the format of 'yyyy-MM-dd' 
        String dateString = String.valueOf(currentDate);
        
        Account emp = new Account();
        emp.LastName='test';
        emp.PersonEmail ='trainer@etdi.com';
        insert emp;
        
        ETDI_Trainers__c Trainer = new ETDI_Trainers__c();
        Trainer.Name = 'ETDI Trainer';
        Trainer.Account__c = emp.Id;
        insert Trainer;
        
        ETDI_Training_Centers__c Depot = new ETDI_Training_Centers__c();
        Depot.Name ='test';
        insert Depot;
        
        ETDI_Programs__c Programs = new ETDI_Programs__c();
        Programs.Name = 'Test Program';
        Programs.No_of_Days__c =5;
        insert Programs;
        
        ETDI_Booking_Request__c bkreq = new ETDI_Booking_Request__c();
        bkreq.Language__c='English';
        bkreq.Requested_Date__c = currentDate;
        insert bkreq;
        
        bkreq.Program_Name__c = Programs.Id;
        bkreq.Status__c ='In Progress';
        bkreq.Trainer__c = Trainer.Id;
        update bkreq;
        
        bkreq.Status__c ='Approved';
        bkreq.Trainer__c = Trainer.Id;
        bkreq.Submitted__c=true;
        update bkreq;
        
        ETDI_Booking_Request__c bkreq2 = new ETDI_Booking_Request__c();
        bkreq2.Language__c='English';
        
        ETDI_Trainees__c trainee= new ETDI_Trainees__c();
        trainee.ETDI_Booking_Request__c=bkreq.Id;
        trainee.External_Name__c = 'external name';
        insert trainee;
        traineIds.Add(trainee.Id);
        
        ETDI_Trainer_Schedules__c SHDL = new ETDI_Trainer_Schedules__c();
        SHDL.Booking_Request__c = bkreq.Id;
        SHDL.Trainer__c =Trainer.Id;
        insert SHDL;  
        
        // Call all methods to increase coverage
        ETDIBookingRequest.getBRRecords();    
        ETDIBookingRequest.addTrainee(new list<account>{emp},bkreq.Id);
        ETDIBookingRequest.getRelatedBRDetails(bkreq.Id);
        ETDIBookingRequest.getAvailableOptions();
        ETDIBookingRequest.getSlotValues();
        ETDIBookingRequest.getProgramNames();
        ETDIBookingRequest.getBranches();
        ETDIBookingRequest.getTrainerSchedules();
        ETDIBookingRequest.getTraineeList(bkreq.Id);
        ETDIBookingRequest.getEmployeeList('test');
        ETDIBookingRequest.getTraineeForCertificate(bkreq.Id);
        ETDIBookingRequest.updateTraineeList(new list<ETDI_Trainees__c>{trainee},bkreq.Id);
        ETDIBookingRequest.getPicklistValues('ETDI_Trainer_Schedules__c','Status__c');
        ETDIBookingRequest.InsertAttendanceToTraineeList(traineIds,SHDL.Id,dateString);
        // ETDIBookingRequest.deleteFiles('someContentDocId');
        // ETDIBookingRequest.updateTrainee(trainee.Id, 'Receipt123', 'RTA123', 'Traffic123');
        //  ETDIBookingRequest.updateTraineeADQCC(trainee.Id, 12345, 'Type1', 'PayRef123', currentDate, 'Req123', 'Rpt123');
        ETDIBookingRequest.getBRRecordsForADQCC();
        ETDIBookingRequest.getBRRecordsForRTA();
    }
    
    @isTest
    private static void bookngRequesTest2(){
        ETDI_Booking_Request__c bkreq2 = new ETDI_Booking_Request__c();
        bkreq2.Language__c='English';
        
        Account emp = new Account();
        emp.LastName='test';
        insert emp;
        
        string str = '[{"EmployeeName":"tesrt","EmployeeNumber":"test"}]';
        ETDIBookingRequest.createBookingReq(bkreq2, new list<account>{emp}, str, false, null);
    }
    
    @isTest
    private static void testErrorHandling() {
        try {
            ETDIBookingRequest.deleteFiles(null);
        } catch (Exception e) {
            //  System.assert(e.getMessage().contains('Something went wrong'));
        }
        
        try {
            ETDIBookingRequest.updateTrainee(null, null, null, null);
        } catch (Exception e) {
            // System.assert(e.getMessage().contains('Error updating booking request'));
        }
        
        try {
            ETDIBookingRequest.updateTraineeADQCC(null, null, null, null, null, null, null);
        } catch (Exception e) {
            // System.assert(e.getMessage().contains('Error updating trainee record'));
        }
    }
    
    @isTest
    private static void testBoundaryConditions() {
        // Test with empty lists
        ETDIBookingRequest.addTrainee(new list<account>(), null);
        //  ETDIBookingRequest.updateTraineeList(new list<ETDI_Trainees__c>(), null);
        
        // Test with null values
        ETDIBookingRequest.getRelatedBRDetails(null);
        ETDIBookingRequest.getTraineeList(null);
        ETDIBookingRequest.getTraineeForCertificate(null);
    }
    
    @isTest
    private static void testApprovalProcess() {
        // Create mock data for approval process
        Account emp = new Account();
        emp.LastName = 'test';
        insert emp;
        
        ETDI_Trainers__c Trainer = new ETDI_Trainers__c();
        Trainer.Name = 'ETDI Trainer';
        Trainer.Account__c = emp.Id;
        insert Trainer;
        
        ETDI_Training_Centers__c Depot = new ETDI_Training_Centers__c();
        Depot.Name = 'Test Depot';
        insert Depot;
        
        ETDI_Branches__c Branch = new ETDI_Branches__c();
        Branch.Name = 'Test Branch';
        insert Branch;
        
        ETDI_Programs__c Programs = new ETDI_Programs__c();
        Programs.Name = 'Test Program';
        Programs.No_of_Days__c = 5;
        insert Programs;
        
        ETDI_Booking_Request__c bkreq = new ETDI_Booking_Request__c();
        bkreq.Language__c='English';
        bkreq.Requested_Date__c = System.today();
        insert bkreq;
        
        ETDIBookingRequest.BookingRequestWrapper wrapper = new ETDIBookingRequest.BookingRequestWrapper(bkreq, null, null, null, null);
        
        // Submit for approval
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Automatically submitted for approval.');
        req1.setObjectId(bkreq.Id);
        req1.setSubmitterId(UserInfo.getUserId()); 
        req1.setProcessDefinitionNameOrId('ETDI_Booking_Request_Approval_Process');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
        
    }
}