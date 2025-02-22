/**************************************************************************************************************
Class       : ETDIBookingRequest
Author      : Sreelakshmi SK
Test class  :ETDIBookingRequestTest
CreatedDate : 
Description : Controller for ETDI components
TestClass  : 
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date        Author          Details
1.          V1.0              			          	   Initial Version 
2.          V2.0               14/02/2025   Sudheer
****************************************************************************************************************/

public without sharing class ETDIBookingRequest {
    
    /*
Method      : getRelatedBRDetails
Author      : Sreelakshmi SK
CreatedDate : 16.06.2023
*/  
    
    @AuraEnabled
    public static List<ETDI_Booking_Request__c> getRelatedBRDetails(String bkreqId) {
        return [select id,Name,CreatedDate,Status__c,Requested_Date__c,Language__c,Trainer__c,Trainer__r.Name, Trainer_Name__c, Branch__c,Branch__r.Name, Depot__c,Depot__r.Name,Program_Name__c,Program_Name__r.Name,Exam_Required__c,LastDayOfProgram__c,Total_Days__c from ETDI_Booking_Request__c where Id=:bkreqId];
    }    
    
    /*
Method      : addTrainee
Author      : Sreelakshmi SK
CreatedDate : 16.06.2023
*/    
    
    @AuraEnabled
    public static string addTrainee(list<Account> empList,string bkreqId) {
        String retStr = 'ERROR';
        Savepoint sp = Database.setSavepoint();
        list<ETDI_Trainees__c> traineeList = new list<ETDI_Trainees__c>();
        for(Account emp : empList){
            ETDI_Trainees__c tr = new ETDI_Trainees__c();
            tr.Employee__c= emp.Id;
            tr.ETDI_Booking_Request__c = bkreqId;
            traineeList.add(tr);
        }
        if(traineeList.size()>0){
            try{
                insert traineeList;
                retStr = 'SUCCESS';
            }catch(Exception e) {
                Database.rollback(sp);
            }               
        }
        return retStr;
    }    
    
    /*
Method      : getAvailableOptions
Author      : Sreelakshmi SK
CreatedDate : 16.06.2023
*/ 
    
    @AuraEnabled
    public static List<String> getAvailableOptions(){
        List<String> AvailableOptions= new List<String>();
        Schema.DescribeFieldResult fieldResult = ETDI_Booking_Request__c.Exam_Required__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            AvailableOptions.add(pickListVal.getLabel());
        }     
        return AvailableOptions;
    }
    
    /*
Method      : getSlotValues
Author      : Sreelakshmi SK
CreatedDate : 29.05.2023
*/ 
    
    @AuraEnabled
    public static List<String> getSlotValues(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = ETDI_Booking_Request__c.Slot__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
    /*
Method      : getProgramNames
Author      : Sreelakshmi SK
CreatedDate : 22.05.2023
*/ 
    
    @AuraEnabled  
    public static List<ETDI_Programs__c> getProgramNames(){
        list<ETDI_Programs__c> ProgramList= new list<ETDI_Programs__c>();
        ProgramList=[select Name from ETDI_Programs__c];
        return ProgramList;
    }    
    
    /*
Method      : getBranches
Author      : Sreelakshmi SK
CreatedDate : 18.05.2023
*/ 
    
    @AuraEnabled  
    public static List<ETDI_Branches__c> getBranches(){
        list<ETDI_Branches__c> branchList= new list<ETDI_Branches__c>();
        //branchList=[select id,Name from ETDI_Branches__c];
        branchList=[select Name,(select Name,Capacity__c from ETDI_Training_Centers__r) from ETDI_Branches__c];
        return branchList;
    }
    
    /*
Method      : deleteFiles
Author      : Sreelakshmi SK
CreatedDate : 17.05.2023
*/        
    
    @AuraEnabled  
    public static void deleteFiles(string contentDocId){ 
        ContentDocument deleteContent = new ContentDocument(Id=contentDocId);
        try {
            delete deleteContent;
        }
        catch (Exception e) {
            throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
        }
    } 
    
    /*
Method      : getTraineeList
Author      : Sreelakshmi SK
CreatedDate : 27.04.2023
*/    
    @AuraEnabled
    public static List<ETDI_Trainees__c> getTraineeList(String BookingId){
        System.debug('BookingId:'+BookingId);
        return [select id,name,Employee__r.Name,ETDI_Booking_Request__c,Employee__r.ETIN_Employee_Id__c,CreatedDate,ETDI_Booking_Request__r.Exam_Required__c,Practical_Marks__c,Remarks__c,Theoretical_Marks__c,ETDI_Booking_Request__r.Total_Days__c,ETDI_Booking_Request__r.LastDayOfProgram__c from ETDI_Trainees__c where ETDI_Booking_Request__c=:BookingId order by Employee__r.ETIN_Employee_Id__c LIMIT 500];
    }  
    
    @AuraEnabled
    public static List<ETDI_Trainees__c> getTraineeForCertificate(String BookingId){
        System.debug('BookingId:'+BookingId);
        return [select id,name,Employee__r.Name,ETDI_Booking_Request__c,Employee__r.ETIN_Employee_Id__c,CreatedDate,ETDI_Booking_Request__r.Exam_Required__c,ETDI_Booking_Request__r.Total_Days__c,ETDI_Booking_Request__r.LastDayOfProgram__c from ETDI_Trainees__c where ETDI_Booking_Request__c=:BookingId AND Attended__c=true order by Employee__r.ETIN_Employee_Id__c LIMIT 500];
    }  
    
    @AuraEnabled
    public static void updateTraineeList(List<ETDI_Trainees__c> TraineeList,string bookingId){
        update TraineeList;
        
        system.debug('bookingId:'+bookingId);
        ETDI_Booking_Request__c bookingRequest=new ETDI_Booking_Request__c();
        bookingRequest.Id=bookingId;
        system.debug('bookingRequest.Id:'+bookingRequest.Id);
        bookingRequest.Status__c='Completed';
        bookingRequest.Completed_Date__c=date.today();
        update bookingRequest;
    }
    //SK
    
    @AuraEnabled
    public static List<Attendance__c> InsertAttendanceToTraineeList(List<String> TraineeIds, String ScheduleRecIds, String formattedDate) {
        
        List<Attendance__c> attendanceList = new List<Attendance__c>();
        List<ETDI_Trainer_Schedules__c> trainerSchedulesToUpdate = new List<ETDI_Trainer_Schedules__c>();
        
        for (String traineeId : TraineeIds) {
            Attendance__c attendance = new Attendance__c();
            attendance.ETDI_Trainees__c = traineeId;
            attendance.ETDI_Trainer_Schedules__c = ScheduleRecIds;
            attendance.Day__c = Date.valueOf(formattedDate);
            attendanceList.add(attendance);
        }
        
        try {
            insert attendanceList;
            // Query Trainer Schedule record for update
            ETDI_Trainer_Schedules__c trainerSchedule = [SELECT Id, Attendance_Completed__c FROM ETDI_Trainer_Schedules__c WHERE Id = :ScheduleRecIds LIMIT 1];
            // Update Trainer Schedule record
            trainerSchedule.Attendance_Completed__c = true;
            trainerSchedule.Status__c = 'Completed';
            trainerSchedulesToUpdate.add(trainerSchedule);
            update trainerSchedulesToUpdate;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        
        return attendanceList;
    }
    
    
    
    /*
Method      : getTrainerSchedules
Author      : Sreelakshmi SK
CreatedDate : 24.04.2023
*/    
    @AuraEnabled
    public static list<ETDI_Trainer_Schedules__c> getTrainerSchedules(){
        
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id,Username,Email FROM User WHERE Id = :currentUserId];
        String userName = currentUser.Username;
        String email = currentUser.Email;
        system.debug('email:'+email);
        
        list<ETDI_Trainer_Schedules__c> ETDSHLS =[select id,Status__c,Attendance_Completed__c, name,Booking_Request__c,Booking_Request__r.Name,Booking_Request__r.Language__c,Booking_Request__r.Number_of_Trainees__c,Schedule_Date_Time__c,Trainer__c,Booking_Request__r.Status__c,CreatedDate,Booking_Request__r.Total_Days__c,Booking_Request__r.End_Date_OfProgram__c,Booking_Request__r.Program_Name__r.Name from ETDI_Trainer_Schedules__c where (Status__c = 'Booked' OR Status__c = 'Completed') and Booking_Request__c!=null and Trainer__r.Account__r.PersonEmail=:email order by name desc LIMIT 100];
        
        return ETDSHLS;
    }
    /*
Method      : get Adqcc and Rta
Author      : Sudheer
CreatedDate : 17.02.2025
*/   
    @AuraEnabled
    public static List<ETDI_Booking_Request__c> getBRRecordsForADQCC() {
        Id currentUserId = UserInfo.getUserId();
        List<ETDI_Booking_Request__c> bookingRequests = [
            SELECT Id, Name,
            (SELECT Id, Employee__r.ET_Emirates_Id__c, Employee_Number__c, Employee__r.Name, 
             Employee__r.ETIN_Joining_Date__c, Employee__r.ETIN_Job_Name__c,
             Organization_Name__c, Location__c, Employee__r.ETST_Gender__c, 
             Employee__r.ET_Nationality__c,Permit_Type__c,ADQCC_Fees__c,Request_No__c,Submitted_Date__c,Payment_Referance__c,Receipt_No__c,Payment_Date__c FROM ETDI_Trainees__r), 
            Program_Name__r.Price__c,Program_Name__r.Name
            FROM ETDI_Booking_Request__c 
            WHERE OwnerId = :currentUserId 
            AND Program_Name__r.ADQCC_required__c = 'Yes' 
            ORDER BY CreatedDate DESC 
            LIMIT 100
        ];
        
        return bookingRequests;
    }
    
    
    @AuraEnabled
    public static List<BookingRequestWrapper> getBRRecordsForRTA() {
        Id currentUserId = UserInfo.getUserId();
        
        List<ETDI_Trainees__c> trainees = [
            SELECT Id, ETDI_Booking_Request__c
            FROM ETDI_Trainees__c
            WHERE External_Name__c != null
            AND ETDI_Booking_Request__r.OwnerId = :currentUserId
        ];
        
        Set<Id> bookingRequestIds = new Set<Id>();
        for (ETDI_Trainees__c trainee : trainees) {
            bookingRequestIds.add(trainee.ETDI_Booking_Request__c);
        }
        
        if (bookingRequestIds.isEmpty()) {
            return new List<BookingRequestWrapper>();
        }
        
        List<ETDI_Booking_Request__c> bookingRequests = [
            SELECT Id, Name, Program_Name__c, Program_Name__r.No_of_Days__c,
            (SELECT Id, External_Name__c, Traffic__c, License_Permit__c, Company__c,
             Nationality__c, Franchise_Limo__c, Remarks__c, Registration_Location__c,
             Group__c, Receipt_No__c, RTA_Receipt__c
             FROM ETDI_Trainees__r
             WHERE External_Name__c != null),
            (SELECT Id, Schedule_Date_Time__c, Trainer__r.Name
             FROM ETDI_Trainer_Schedules__r),
            Program_Name__r.Price__c, Program_Name__r.Name
            FROM ETDI_Booking_Request__c
            WHERE Id IN :bookingRequestIds
            ORDER BY CreatedDate DESC
            LIMIT 100
        ];
        
        Set<Id> traineeIds = new Set<Id>();
        for (ETDI_Booking_Request__c br : bookingRequests) {
            for (ETDI_Trainees__c trainee : br.ETDI_Trainees__r) {
                traineeIds.add(trainee.Id);
            }
        }
        
        Map<Id, Integer> traineeAttendanceMap = new Map<Id, Integer>();
        if (!traineeIds.isEmpty()) {
            List<AggregateResult> attendanceResults = [
                SELECT ETDI_Trainees__c traineeId, COUNT(Id) countPresent
                FROM Attendance__c
                WHERE ETDI_Trainees__c IN :traineeIds
                GROUP BY ETDI_Trainees__c
            ];
            
            for (AggregateResult ar : attendanceResults) {
                traineeAttendanceMap.put(
                    (Id) ar.get('traineeId'),
                    (Integer) ar.get('countPresent')
                );
            }
        }
        
        List<BookingRequestWrapper> wrapperList = new List<BookingRequestWrapper>();
        for (ETDI_Booking_Request__c booking : bookingRequests) {
            ETDI_Trainer_Schedules__c trainerSchedule = 
                (booking.ETDI_Trainer_Schedules__r.size() > 0) 
                ? booking.ETDI_Trainer_Schedules__r[0] 
                : null;
            
            for (ETDI_Trainees__c trainee : booking.ETDI_Trainees__r) {
                Integer daysPresent = traineeAttendanceMap.get(trainee.Id) != null
                    ? traineeAttendanceMap.get(trainee.Id)
                    : 0;
                
                Decimal totalProgramDays = booking.Program_Name__r.No_of_Days__c != null
                    ? booking.Program_Name__r.No_of_Days__c
                    : 0;
                
                Decimal daysAbsent = totalProgramDays - daysPresent;
                
                wrapperList.add(new BookingRequestWrapper(
                    booking,
                    trainerSchedule,
                    trainee,
                    daysPresent,
                    daysAbsent
                ));
            }
        }
        
        return wrapperList;
    }
    
    public class BookingRequestWrapper {
        @AuraEnabled
        public ETDI_Booking_Request__c bookingRequest { get; set; }
        
        @AuraEnabled
        public ETDI_Trainer_Schedules__c trainerSchedule { get; set; }
        
        @AuraEnabled
        public ETDI_Trainees__c trainee { get; set; }
        
        @AuraEnabled
        public Integer daysPresent { get; set; }
        
        @AuraEnabled
        public Decimal daysAbsent { get; set; }
        
        public BookingRequestWrapper(
            ETDI_Booking_Request__c bookingRequest,
            ETDI_Trainer_Schedules__c trainerSchedule,
            ETDI_Trainees__c trainee,
            Integer daysPresent,
            Decimal daysAbsent
        ) {
            this.bookingRequest = bookingRequest;
            this.trainerSchedule = trainerSchedule;
            this.trainee = trainee;
            this.daysPresent = daysPresent;
            this.daysAbsent = daysAbsent;
        }
    }
    
    
    @AuraEnabled
    public static void updateTrainee(Id traineeId,String ReceiptNo, String RTAReceiptNo,String TrafficFile) {
        try {
            ETDI_Trainees__c trainee = new ETDI_Trainees__c(
                Id = traineeId,
                Receipt_No__c = ReceiptNo,
                RTA_Receipt__c = RTAReceiptNo,
                Traffic__c = TrafficFile
            );
            update trainee;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating booking request: ' + e.getStackTraceString());
        }
    }
    
    @AuraEnabled
    public static void updateTraineeADQCC(Id traineeId, Decimal empNo, String type, String payRef, Date payDate, String reqNo, String rptNo,Date subdate) {
        try {
            
            ETDI_Trainees__c trainee = new ETDI_Trainees__c();
            trainee.Id = traineeId;
            trainee.Employee_Number__c = empNo;
            trainee.TYPE__c = type;
            trainee.Payment_Referance__c = payRef;
            trainee.Payment_Date__c = payDate;
            trainee.Request_No__c = reqNo;
            trainee.Receipt_No__c = rptNo;
            trainee.Submitted_Date__c = subdate;
            
            update trainee;
            
        } catch (Exception e) {
            System.debug('Error updating booking request: ' + e.getStackTraceString());
            throw new AuraHandledException('Error updating trainee record: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<ETDI_Booking_Request__c> getBRRecords() {
        Id currentUserId=UserInfo.getUserId();
        return [select id,Name,CreatedDate,Status__c,Requested_Date__c,Language__c,Trainer__c,Trainer__r.Name, Trainer_Name__c, Branch__c,Branch__r.Name, Depot__c,Depot__r.Name,Program_Name__c,Program_Name__r.Name from ETDI_Booking_Request__c where OwnerId=:currentUserId order by createdDate Desc LIMIT 100];
    }
    
    @AuraEnabled
    public static list<Account> getEmployeeList(string searchKey) {
        string query = 'SELECT Id,Name,ETIN_Employee_Id__c,(SELECT Id, Name, Email FROM Users) from Account where (Name LIKE  \'%'+ searchKey +'%\' OR ETIN_Employee_Id__c LIKE  \'%'+ searchKey +'%\') AND Type= \'Employee\' AND ETIN_Termination_Date__c = null limit 5';
        return Database.Query(query);
    } 
    
    @AuraEnabled
    public static string createBookingReq(ETDI_Booking_Request__c bkngReq,list<Account> empList,string empData, Boolean isExternal,String selectedData) {
        String retStr = 'ERROR';       
        Savepoint sp = Database.setSavepoint();
        insert bkngReq;
        if(bkngReq.Id != null){
            list<ETDI_Trainees__c> trainessList = new list<ETDI_Trainees__c>();
            if(empData != null && isExternal == false){
                list<empDataWrapper> empDataList = (List<empDataWrapper>) System.JSON.deserialize(empData, List<empDataWrapper>.class);
                for(empDataWrapper emp : empDataList){
                    if(emp.EmployeeNumber!= null){                    
                        ETDI_Trainees__c tr = new ETDI_Trainees__c();
                        tr.Employee__r=  new Account(ETIN_Employee_Id__c=emp.EmployeeNumber);   
                        tr.ETDI_Booking_Request__c = bkngReq.Id;
                        trainessList.add(tr);
                    }
                    
                }
            }else if(isExternal && selectedData != null){
                System.debug('selectedData: ' + selectedData);
                try{
                    List<Object> selectedDataList = (List<Object>) JSON.deserializeUntyped(selectedData);
                    for (Object item : selectedDataList) {
                        // Cast each item to a Map<String, Object>
                        Map<String, Object> rowData = (Map<String, Object>) item;
                        System.debug('rowData -> '+rowData);
                        ETDI_Trainees__c tr = new ETDI_Trainees__c();
                        tr.External_Name__c = (String) rowData.get('name'); 
                        tr.Traffic__c = (String) rowData.get('trafficFile');
                        tr.License_Permit__c = (String) rowData.get('license');
                        tr.Company__c = (String) rowData.get('company');
                        tr.Nationality__c = (String) rowData.get('nationality');
                        tr.Franchise_Limo__c = (String) rowData.get('franchise');
                        tr.Remarks__c = (String) rowData.get('remarks');
                        tr.Registration_Location__c = (String) rowData.get('registrationLocation');
                        tr.Group__c = (String) rowData.get('group');
                        tr.ETDI_Booking_Request__c = bkngReq.Id;
                        trainessList.add(tr);
                    }
                }catch(Exception e){
                    System.debug('Error --< '+e.getStackTraceString());
                    System.debug('Error --< '+e.getMessage());
                }
            }  
            if(!empList.isEmpty() && empList.size()>0){
                for(Account emp : empList){
                    ETDI_Trainees__c tr = new ETDI_Trainees__c();
                    tr.Employee__c= emp.Id;
                    tr.ETDI_Booking_Request__c = bkngReq.Id;
                    trainessList.add(tr);
                }
            }
            
            system.debug('TraineesListSize:'+trainessList.size());
            if(trainessList.size()>0){
                try{
                    insert trainessList;
                    ETDI_Booking_Request__c etdiQuery =[select id,Name,Trainer__c,Program_Name__r.Department__c from ETDI_Booking_Request__c where Id=:bkngReq.Id];
                    system.debug(etdiQuery.Program_Name__r.Department__c);
                    
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Automatically submitted for approval.');
                    req1.setObjectId(bkngReq.Id);
                    req1.setSubmitterId(UserInfo.getUserId()); 
                    req1.setProcessDefinitionNameOrId('ETDI_Booking_Request_Approval_Process');
                    req1.setSkipEntryCriteria(true);
                    Approval.ProcessResult result = Approval.process(req1);
                    retStr = 'SUCCESS';
                    
                }catch(Exception e) {
                    Database.rollback(sp);
                }               
            }   
        }
        
        return retStr;
    }
    
    public class empDataWrapper{
        public String EmployeeName;
        public String EmployeeNumber;
    }
    //SK
    
    @AuraEnabled(cacheable=true) 
    public static Map<String,String> getPicklistValues(string objObject, string fld) { 
        Map<String,String> allOpts = new Map<String,String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objObject).getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(fld).getDescribe();
        
        list < Schema.PicklistEntry > values =fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.put(a.getLabel(),a.getValue());
        }
        return allOpts;
    }
}