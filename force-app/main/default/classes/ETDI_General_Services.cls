public class ETDI_General_Services {
    
    @AuraEnabled
    public static void validateMobileNumber1(Id CaseId)
    {
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id ,ETIN_Mobile_Number__c, PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        /*else if(acc.ETIN_Mobile_Number__c!=null)
{
MobileNumber = acc.ETIN_Mobile_Number__c; 
}*/
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            
            
            createETDIDetails(acc.id,Token,UserId,StudentId);
            System.debug('aftercreatecalls');
        }
        
        
        
    }  
    public static void createETDIDetails(Id AccountId,String Token,String UserId, String StudentId)
    {
        Account acc= [Select id , ETIN_Mobile_Number__c,PersonMobilePhone,Phone from Account where id=:AccountId];
        String body ='';
        String MobileNumber = '';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }       
        
        //   MobileNumber = '971553926850'; // gulam number 
        // MobileNumber = '971565467501'; // Ali number 
        //MobileNumber = '971501679029'; // Vijay number 
        ETDI_Detail__c etdiDetail = new ETDI_Detail__c();
        etdiDetail.Account__c= AccountId;
        etdiDetail.Mobile__c = MobileNumber;
        insert etdiDetail;
        system.debug('etdiDetail '+etdiDetail.Id);
        
        if(etdiDetail.id!=null)
        {
            system.debug('etdiDetail in '+etdiDetail.Id);
            system.debug('AccountId in '+AccountId);
            system.debug('Token in '+Token);
            system.debug('UserId in '+UserId);
            system.debug('StudentId in '+StudentId);
            
            // getPracticalSchedule(AccountId,etdiDetail.id);
            //getProfileInformation(AccountId, etdiDetail.id); 
            
            try{
                // System.enqueueJob(new getTheoryScheduleQueable(AccountId,etdiDetail.Id,Token,UserId,StudentId));
                
                getTheorySchedule( AccountId,etdiDetail.id,Token,UserId,StudentId);   
            }
            catch(Exception e){
                system.debug('exception '+e);
            }    
            try{
                getPaymentHistory( AccountId, etdiDetail.id,Token,UserId,StudentId);   
            }
            catch(Exception e){} 
            try{
                getProfileInformation(AccountId, etdiDetail.id,Token,UserId,StudentId); 
            }
            catch(Exception e){}            
            try{
                getPracticalSchedule(AccountId, etdiDetail.id,Token,UserId,StudentId);  
            }
            catch(Exception e){}
            try{
                getScheduledAssessment(AccountId, etdiDetail.id,Token,UserId,StudentId);  
            }
            catch(Exception e){}
            try{
                getScheduledExams(AccountId, etdiDetail.id,Token,UserId,StudentId);
            }
            catch(Exception e){} 
             try{
                getMockTestResult(AccountId, etdiDetail.id,Token,UserId,StudentId);
            }
            catch(Exception e){}  
              try{
                getPermitStatus(AccountId, etdiDetail.id,Token,UserId,StudentId);
            }
            catch(Exception e){}    
            List<ETDI_Detail__c> etdiDetailDeleteList = [Select id,Name from ETDI_Detail__c where Account__c =: acc.id And id !=:etdiDetail.Id AND Mobile__c=:acc.PersonMobilePhone];
            if(etdiDetailDeleteList.size()>0)
            {
                delete etdiDetailDeleteList;
            }
        }
        
        
    }
    @future(callout = true)
    public static void getTheorySchedule(Id AccountId,Id ETDIDetailID,String Token,String UserId, String StudentId)
    {
        system.debug('getTheorySchedule ');
        // account id = '0013M00000TjtyQQAR'
        String body ='';
        
        
        HttpRequest request = new HttpRequest();
        
        body = '{"studentid": "'+UserId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetTheoryClassesSchedule');		
        request.setBody(body);
        
        Map<String,object> getTheoryResponse = ETDI_Service_Requests.getServiceResult(request,Token);
        
        if(getTheoryResponse!=Null)
        {
            String ResponseMessage =(String)getTheoryResponse.get('Message');
            
            System.debug('Message = '+ResponseMessage);
            List<Object> TheorySchedules = (List<Object>)getTheoryResponse.get('Data');
            List<Theory_Class_Schedule__c> theoryList = new List<Theory_Class_Schedule__c>();
            Integer count = 0;   
            for(Object TheorySchedule:TheorySchedules)
            {
                count = count +1;
                //  if(count == 1)
                //{
                Theory_Class_Schedule__c theory = new Theory_Class_Schedule__c();
                Map<String, Object> TheoryScheduleMap =  (Map<String, Object>)TheorySchedule;
                theory.Slot_Schedule_ID__c = (Decimal)TheoryScheduleMap.get('SLOT_SCH_ID');    
                theory.Course_Name__c = (String)TheoryScheduleMap.get('COURSE');
                theory.Course_Title__c = (String)TheoryScheduleMap.get('COURSE_TITLE');
                //api is providing date in MM-dd-yyyy format and we will change into yyyy-MM-dd for salesforce to accept
                String getdate = (String)TheoryScheduleMap.get('DATE');
                String[] strDateSplit = getdate.split('-');            
                theory.Course_Date__c = Date.valueOf(strDateSplit[2] + '-' + strDateSplit[0] + '-' + strDateSplit[1]); 
                
                String strTimeChange=(String)TheoryScheduleMap.get('TIME'); 
                String[] strTimeSplit = strTimeChange.split(':');
                theory.Course_Time__c = Time.newInstance( Integer.valueOf(strTimeSplit[0]),Integer.valueOf(strTimeSplit[1]),0,0);             
                theory.Status__c = (String)TheoryScheduleMap.get('STATUS');
                theory.ETDI_Detail__c = ETDIDetailID;
                theoryList.add(theory);
                System.debug('Theory Class Schedule Data'+TheorySchedule); 
                //  }
                
                
            }
            
            if(theoryList.size()>0)
            {
                insert theoryList;
            }
            else
            {
                System.debug('No Record found for thoery Schedule');
            }
            
        }
        
        
    }
    @future(callout = true)
    public static void getPaymentHistory(Id AccountId, Id ETDIDetailID,String Token,String UserId, String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String body ='';
        
        HttpRequest request = new HttpRequest();
        
        body = '{"userid": "'+UserId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetPaymentHistory');		
        request.setBody(body);
        
        Map<String,object> getPaymentHistoryResponse = ETDI_Service_Requests.getServiceResult(request,Token);
        
        if(getPaymentHistoryResponse!=Null)
        {
            String ResponseMessage =(String)getPaymentHistoryResponse.get('Message');
            
            System.debug('Message = '+ResponseMessage);
            
            if(ResponseMessage =='Successfully Returned')
            {
                List<Object> PaymentHistory = (List<Object>)getPaymentHistoryResponse.get('Data');
                
                List<ETDI_Payment_History__c> PaymentHistoryList = new List<ETDI_Payment_History__c>();
                
                Integer count = 0;   
                for(Object Payment:PaymentHistory)
                {
                    ETDI_Payment_History__c payHistory = new ETDI_Payment_History__c();
                    Map<String, Object> PaymentMap =  (Map<String, Object>)Payment;
                    
                    payHistory.Transaction_ID__c = (Decimal)PaymentMap.get('ID') ;
                    payHistory.Payment_Category__c=(String)PaymentMap.get('PAYMENT_CATEGORY_NAME') ;
                    String data = (String)PaymentMap.get('TRAN_DATE');
                    payHistory.Transaction_Date__c	 = (DateTime)JSON.deserialize('"' + data + '"', DateTime.class);
                    // payHistory.Transaction_Date__c=(String)PaymentMap.get('TRAN_DATE') ;
                    payHistory.Amount__c=(Decimal)PaymentMap.get('AMOUNT') ;
                    payHistory.ETDI_Detail__c = ETDIDetailID;
                    System.debug('Payment='+Payment);
                    
                    PaymentHistoryList.add(payHistory);
                }
                
                if(PaymentHistoryList.size()>0)
                {
                    insert PaymentHistoryList;
                }
                else
                {
                    System.debug('No Record found for Payment History');
                }
                
            }
            
        }       
        
        
    }
    
    @future(callout = true)
    public static void getScheduledExams(Id AccountId,Id ETDIDetailID,String Token,String UserId, String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String body ='';     
        HttpRequest request = new HttpRequest();
        
        
        body = '{"userid": "'+UserId + '","channel":"4"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/DoGetScheduledExams');		
        request.setBody(body);
        
        Map<String,object> getScheduleExamsResponse = ETDI_Service_Requests.getServiceResult(request,Token);
        
        if(getScheduleExamsResponse!=Null)
        {
            String ResponseMessage =(String)getScheduleExamsResponse.get('Message');
            
            System.debug('Message = '+ResponseMessage);
            
            if(ResponseMessage.contains('Successfully Returned'))
            {
                List<Object> ScheduledExamsList = (List<Object>)getScheduleExamsResponse.get('Data');
                List<ETDI_Scheduled_Exam__c> etdiScheduledExamObjList = new List<ETDI_Scheduled_Exam__c>();
                Integer count = 0;   
                for(Object ScheuleExam:ScheduledExamsList)
                {
                    ETDI_Scheduled_Exam__c ScheduledExam = new ETDI_Scheduled_Exam__c();
                    Map<String, Object> ScheduledExamsMap =  (Map<String, Object>)ScheuleExam;
                    
                    ScheduledExam.Customer_Service_Exam_ID__c	 = String.valueOf(ScheduledExamsMap.get('CUSTOMER_SERVICE_EXAM_ID'));
                    ScheduledExam.Exam_Centre__c = (String)ScheduledExamsMap.get('EXAM_CENTRE');
                    ScheduledExam.Exam_Name__c = (String)ScheduledExamsMap.get('NAME_EN');
                    ScheduledExam.Exam_Result__c = (String)ScheduledExamsMap.get('EXAM_RESULT');
                    ScheduledExam.Schedule_Exam_ID__c = String.valueOf(ScheduledExamsMap.get('ID'));
                    String data = (String)ScheduledExamsMap.get('EXAM_DATE');
                    ScheduledExam.Exam_Date__c	 = (DateTime)JSON.deserialize('"' + data + '"', DateTime.class);
                    ScheduledExam.ETDI_Detail__c = ETDIDetailID;
                    System.debug('ScheuleExam='+ScheuleExam);
                    etdiScheduledExamObjList.add(ScheduledExam);
                }
                
                if(etdiScheduledExamObjList.size()>0)
                {
                    insert etdiScheduledExamObjList;
                    
                    List<ETDI_Scheduled_Exam__c> insertedexamscehdule = [Select id,Exam_Date__c,Exam_Name__c,Exam_Result__c from ETDI_Scheduled_Exam__c where id In:etdiScheduledExamObjList];
                    Map<Date,ETDI_Scheduled_Exam__c> latestDateExamScheduleMap = new  Map<Date,ETDI_Scheduled_Exam__c>();
                    List<Date> examsdates = new List<Date>();
                    for(ETDI_Scheduled_Exam__c exam:insertedexamscehdule)
                    {
                        DateTime dtime =  exam.Exam_Date__c;
                        Date examdt = Date.newInstance(dtime.year(), dtime.month(), dtime.day());
                        examsdates.add(examdt);
                        if(!latestDateExamScheduleMap.containsKey(examdt))
                        {
                            latestDateExamScheduleMap.put(examdt,exam) ;
                        }
                    }
                    
                    Date latestexamdate = examsdates[0];
                    String examname='';                   
                    String examresult = '';
                    for(Date dt:examsdates) 
                    {
                        if(latestexamdate<dt)
                        {
                            latestexamdate = dt;
                        }
                    }
                    if(latestDateExamScheduleMap.size()>0)
                    {
                        if(latestDateExamScheduleMap.containsKey(latestexamdate))  
                        {
                            ETDI_Scheduled_Exam__c latestexam  =   latestDateExamScheduleMap.get(latestexamdate);  
                            examname = latestexam.Exam_Name__c;
                            DateTime dTime = latestexam.Exam_Date__c;
                            
                            latestexamdate = Date.newInstance(dTime.year(), dTime.month(), dTime.day());
                            examresult = latestexam.Exam_Result__c;
                        }
                        
                        if(examname != '')
                        {
                            ETDI_Detail__c updateEtdidetail =  [Select id,Exam_Name__c,Exam_Result__c,Exam_Date__c from ETDI_Detail__c where id=:ETDIDetailID];
                            updateEtdidetail.Exam_Name__c = examname;
                            updateEtdidetail.Exam_Result__c = examresult;
                            updateEtdidetail.Exam_Date__c = latestexamdate;
                            update   updateEtdidetail;
                        }
                        
                    }
                    
                }
                else
                {
                    System.debug('No Record found for Exam Schedule');
                }
            }
            else{
                System.debug('Message ='+ResponseMessage);
            }
            
        }
        
    }
    
    @future(callout = true)
    public static void getProfileInformation(Id AccountId,Id ETDIDetailID,String Token,String UserId, String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String body ='';
        HttpRequest request = new HttpRequest();
        body = '{"userid": "'+UserId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetProfileInformation');		
        request.setBody(body);
        
        Map<String,object> getProfileInformationResponse = ETDI_Service_Requests.getServiceResult(request,Token);
        
        if(getProfileInformationResponse!=Null)
        {
            String ResponseMessage =(String)getProfileInformationResponse.get('Message');
            
            System.debug('Message = '+ResponseMessage);
            
            if(ResponseMessage.contains('Successfully Returned'))
            {
                List<Object> ProfileInformationList = (List<Object>)getProfileInformationResponse.get('Data');
                ETDI_Detail__c etdipersondetail = [Select id, Student_Name__c,License_Type__c from ETDI_Detail__c where id=:ETDIDetailID];
                String Licensetype ='';
                String InstructorName = '';
                String TrafficeFileNumber =  '';
                String PersonName='';
                Integer count = 0;   
                for(Object ProfileInformation:ProfileInformationList)
                {
                    Map<String, Object> ProfileInfoMap =  (Map<String, Object>)ProfileInformation;
                    
                    Licensetype= (String)ProfileInfoMap.get('LICENSE_TYPE'); 
                    PersonName = (String)ProfileInfoMap.get('PERSON_NAME_EN');
                    TrafficeFileNumber = (String)ProfileInfoMap.get('TFN');
                    //    InstructorName= (String)ProfileInfoMap.get('SLOT_SCH_ID'); ;    
                    System.debug('ProfileInformation='+ProfileInformation);
                }
                if((Licensetype!='')||(InstructorName!='')||(PersonName!='')||(TrafficeFileNumber!=''))
                {
                    etdipersondetail.License_Type__c = Licensetype;
                    etdipersondetail.Student_Name__c = PersonName;
                    etdipersondetail.Traffic_File_Number__c = TrafficeFileNumber;
                    //   etdipersondetail.Instructor_Name__c = InstructorName;
                    update etdipersondetail;
                }
            }
            
        }      
        
    }
    @future(callout = true)
    public static void getScheduledAssessment(Id AccountId,Id ETDIDetailID,String Token,String UserId, String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String body ='';      
        String TokenServiceMessage= '';
        HttpRequest request = new HttpRequest();
        
        
        body = '{"studentid": "'+UserId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetAssessmentScheduleChatBot');		
        request.setBody(body);
        
        Map<String,object> getScheduledAssessmentResponse = ETDI_Service_Requests.getServiceResult(request,Token);
        
        if(getScheduledAssessmentResponse!=Null)
        {
            String ResponseMessage =(String)getScheduledAssessmentResponse.get('Message');
            
            System.debug('Message = '+ResponseMessage);
            
            if(ResponseMessage.contains('Successfully Returned'))
            {
                List<Object> ScheuledAssessmentList = (List<Object>)getScheduledAssessmentResponse.get('Data');
                
                List<ETDI_Assessment_Schedule__c> assessmentScheduleObjlist = new List<ETDI_Assessment_Schedule__c>();  
                for(Object Assesment:ScheuledAssessmentList)
                {
                    ETDI_Assessment_Schedule__c assessmentSchedule = new ETDI_Assessment_Schedule__c();
                    Map<String, Object> assessmentScheduleClassMap =  (Map<String, Object>)Assesment;
                    
                    assessmentSchedule.Training_Name__c	 = (String)assessmentScheduleClassMap.get('TRAINING_NAME');
                    assessmentSchedule.Status__c	 = (String)assessmentScheduleClassMap.get('STATUS');  
                    assessmentSchedule.Instructor_Name__c	 = (String)assessmentScheduleClassMap.get('INSTRUCTOR_NAME');  
                    assessmentSchedule.Class_Schedule_Id__c	 =String.valueOf(assessmentScheduleClassMap.get('CUST_CLASS_SCH_ID'));  
                    assessmentSchedule.Seq_Number__c	 = (Decimal)assessmentScheduleClassMap.get('SEQ_NUM');
                    String strTimeChange=(String)assessmentScheduleClassMap.get('TIME'); 
                    String[] strTimeSplit = strTimeChange.split(':');
                    assessmentSchedule.Time__c = Time.newInstance( Integer.valueOf(strTimeSplit[0]),Integer.valueOf(strTimeSplit[1]),0,0); 
                    // pendingschClass.Time__c	 = (String)PendingScheduleClassMap.get('TIME'); 
                    // date coming from APi is in dd/MM/yyyy format . so we will convert it into yyyy-MM-dd format 
                    String getdate = (String)assessmentScheduleClassMap.get('DATE');
                    String[] strDateSplit = getdate.split('-');            
                    assessmentSchedule.Date__c = Date.valueOf(strDateSplit[2] + '-' + strDateSplit[0] + '-' + strDateSplit[1]); 
                    //   pendingschClass.Date__c	 = (String)PendingScheduleClassMap.get('DATE');  
                    assessmentSchedule.ETDI_Detail__c	 = ETDIDetailID;  
                    System.debug('assessmentScheduleClassMap='+assessmentScheduleClassMap);
                    assessmentScheduleObjlist.add(assessmentSchedule);
                }
                
                if(assessmentScheduleObjlist.size()>0)
                {
                    insert assessmentScheduleObjlist;
                    
                }
                else
                {
                    System.debug('No Record found for assessment Schedule');
                }
            }
            else{
                System.debug('Message ='+ResponseMessage);
            }
            
        }     
        
    }
    @future(callout = true)
    public static void getPracticalSchedule(Id AccountId,Id ETDIDetailID,String Token,String UserId, String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String body ='';        
        HttpRequest request = new HttpRequest();     
        body = '{"studentid": "'+UserId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetPracticalScheduleChatBot');		
        request.setBody(body);
        
        Map<String,object> getPracticalScheduleResponse = ETDI_Service_Requests.getServiceResult(request,Token);
        
        if(getPracticalScheduleResponse!=Null)
        {
            String ResponseMessage =(String)getPracticalScheduleResponse.get('Message');
            
            System.debug('Message = '+ResponseMessage);
            
            if(ResponseMessage.contains('Successfully Returned'))
            {
                List<Object> PracticalScheduleList = (List<Object>)getPracticalScheduleResponse.get('Data');
                List<ETDI_Practical_Schedule__c> practicalScehduleObjList = new List<ETDI_Practical_Schedule__c>();
                Integer count = 0;
                List<Date> practicalscheduledatelist = new List<Date>();
                
                for(Object PracticalSchedule:PracticalScheduleList)
                {
                    ETDI_Practical_Schedule__c practicalScheduleobj = new ETDI_Practical_Schedule__c();
                    Map<String, Object> practicalScheduleMap =  (Map<String, Object>)PracticalSchedule;
                    practicalScheduleobj.Training_Name__c = (String)practicalScheduleMap.get('TRAINING_NAME');
                    String getdate = (String)practicalScheduleMap.get('DATE');
                    String[] strDateSplit = getdate.split('-');            
                    practicalScheduleobj.Date__c = Date.valueOf(strDateSplit[2] + '-' + strDateSplit[0] + '-' + strDateSplit[1]); 
                    practicalscheduledatelist.add(practicalScheduleobj.Date__c);
                    practicalScheduleobj.Instructor_Name__c = (String)practicalScheduleMap.get('INSTRUCTOR_NAME'); 
                    practicalScheduleobj.Class_Schedule_Id__c = String.valueOf(practicalScheduleMap.get('CUST_CLASS_SCH_ID')); 
                    practicalScheduleobj.Seq_Number__c = (Decimal)practicalScheduleMap.get('SEQ_NUM'); 
                    practicalScheduleobj.Status__c = (String)practicalScheduleMap.get('STATUS'); 
                    String strTimeChange=(String)practicalScheduleMap.get('TIME'); 
                    String[] strTimeSplit = strTimeChange.split(':');
                    practicalScheduleobj.Time__c = Time.newInstance( Integer.valueOf(strTimeSplit[0]),Integer.valueOf(strTimeSplit[1]),0,0); 
                    practicalScheduleobj.ETDI_Detail__c=ETDIDetailID;
                    practicalScehduleObjList.add(practicalScheduleobj);
                    System.debug('PracticalSchedule='+PracticalSchedule);
                }
                
                if(practicalScehduleObjList.size()>0)
                {
                    insert practicalScehduleObjList;
                    
                    Date latestDate = practicalscheduledatelist[0];
                    String LatestInstructorName = '';
                    for(Date dt:practicalscheduledatelist)
                    {
                        if(latestDate<dt)
                        {
                            latestDate = dt;
                        }
                    }
                    List<ETDI_Practical_Schedule__c> insertpracticalscehdule = [Select id,Date__c,Instructor_Name__c from ETDI_Practical_Schedule__c where id In:practicalScehduleObjList];
                    Map<Date,String> latestinstructorMap = new  Map<Date,String>();
                    for(ETDI_Practical_Schedule__c prac:insertpracticalscehdule)
                    {
                        if(!latestinstructorMap.containsKey(prac.Date__c))
                        {
                            latestinstructorMap.put(prac.Date__c,prac.Instructor_Name__c) ;
                        }
                    }
                    
                    if(latestinstructorMap.size()>0)
                    {
                        if(latestinstructorMap.containsKey(latestDate))  
                        {
                            LatestInstructorName =   latestinstructorMap.get(latestDate);  
                        }
                        
                        if(LatestInstructorName != '')
                        {
                            ETDI_Detail__c updateEtdidetail =  [Select id,Instructor_Name__c from ETDI_Detail__c where id=:ETDIDetailID];
                            updateEtdidetail.Instructor_Name__c = LatestInstructorName;
                            update   updateEtdidetail;
                        }
                        
                    }
                    
                    
                }
                else
                {
                    System.debug('No Record found for Practical Schedule');
                }
                
            }
            else{
                System.debug('Message ='+ResponseMessage);
            }
            
        }      
        
    }  
    @future(callout = true)
    public static void getMockTestResult(Id AccountId,Id ETDIDetailID,String Token,String UserId, String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String body ='';
        HttpRequest request = new HttpRequest();
        body = '{"userid": "'+StudentId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetMockTestResult');		
        request.setBody(body);
        
        Map<String,object> getmockTestResponse = ETDI_Service_Requests.getServiceResult(request,Token);
        System.debug('getmockTestResponse = '+getmockTestResponse);
        if(getmockTestResponse!=Null)
        {
            String ResponseMessage =(String)getmockTestResponse.get('Message');
            
            System.debug('Message = '+ResponseMessage);
            
            if(ResponseMessage.contains('Successfully Returned'))
            {
                List<Object> mockTestList = (List<Object>)getmockTestResponse.get('Data');
                ETDI_Detail__c etdipersondetail = [Select id, Mock_Test_Result__c from ETDI_Detail__c where id=:ETDIDetailID];
                String mockTestResult ='';
                
                Integer count = 0;   
                for(Object mockTest:mockTestList)
                {
                    Map<String, Object> mockInfoMap =  (Map<String, Object>)mockTest;
                    
                    mockTestResult= (String)mockInfoMap.get('RESULT'); 
                    
                    System.debug('mockTest='+mockTest);
                }
                if((mockTestResult!=''))
                {
                    etdipersondetail.Mock_Test_Result__c = mockTestResult;	                  
                    //   etdipersondetail.Instructor_Name__c = InstructorName;
                    update etdipersondetail;
                }
            }
            
        }      
        
    }
    @future(callout = true)
    public static void getPermitStatus(Id AccountId,Id ETDIDetailID,String Token,String UserId, String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String body ='';
        HttpRequest request = new HttpRequest();
        body = '{"userid": "'+StudentId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetPermitStatus');		
        request.setBody(body);
        
        Map<String,object> getpermitStatusResponse = ETDI_Service_Requests.getServiceResult(request,Token);
        System.debug('getmockTestResponse = '+getpermitStatusResponse);
        if(getpermitStatusResponse!=Null)
        {
            Boolean ResponseMessage =(Boolean)getpermitStatusResponse.get('Success');
            
            System.debug('Message = '+ResponseMessage);
            
            if(ResponseMessage)
            {
               String permitStatus = (String)getpermitStatusResponse.get('Status');
                ETDI_Detail__c etdipersondetail = [Select id, Permit_Status__c from ETDI_Detail__c where id=:ETDIDetailID];
                                          
                if((permitStatus!=''))
                {
                    etdipersondetail.Permit_Status__c = permitStatus;   	                  
                    //   etdipersondetail.Instructor_Name__c = InstructorName;
                    update etdipersondetail;
                }
            }
            
        }      
        
    }
    @AuraEnabled
    public static string getOldLicenseType(Id caseId){
        Case cas = [Select id,AccountId from Case where id=:caseId];
        Account acc= [Select id , (Select id,License_Type__c from ETDI_Details__r),ETDI_License__c from Account where id=:cas.AccountId];
        String License = '';
        For(ETDI_Detail__c etdi:acc.ETDI_Details__r)
        {
            License =  etdi.License_Type__c;
            if(License!='')
            {
                break;
            }
            
        }
        return License;
    }
    @AuraEnabled
    public static void changeInstructor(Id CaseId,String InstructorChangeReason)
    {
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            
            
            //  createETDIDetails(acc.id,Token,UserId,StudentId);
            changeInstructorPostMethod(acc.id,InstructorChangeReason,CaseId, Token, UserId, StudentId);
            System.debug('aftercreatecalls');
        }           
        
    }
    
    public static string getStudentName(String userID, String Token){
        String body1 ='';
        String StudentName='';
        HttpRequest request1 = new HttpRequest();
        body1 = '{"userid": "'+UserId + '"}';
        
        
        request1= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetProfileInformation');		
        request1.setBody(body1);
        
        Map<String,object> getProfileInformationResponse = ETDI_Service_Requests.getServiceResult(request1,Token);
        
        if(getProfileInformationResponse!=Null)
        {
            String ResponseMessage =(String)getProfileInformationResponse.get('Message');
            
            System.debug('Message = '+ResponseMessage);
            
            if(ResponseMessage.contains('Successfully Returned'))
            {
                List<Object> ProfileInformationList = (List<Object>)getProfileInformationResponse.get('Data');                                                             
                
                Integer count = 0;   
                for(Object ProfileInformation:ProfileInformationList)
                {
                    Map<String, Object> ProfileInfoMap =  (Map<String, Object>)ProfileInformation;
                    
                    
                    StudentName = (String)ProfileInfoMap.get('PERSON_NAME_EN');
                    
                    System.debug('StudentName='+StudentName);
                }
            }
        }
        return StudentName;
    }
    
    @future(callout = true)
    public static void changeInstructorPostMethod(Id AccountId,String InstructorChangeReason,Id CaseId,String Token,String UserId,String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String StudentName='';
        StudentName = getStudentName(UserId,Token);
        
        String body ='';        
        String TokenServiceMessage='';
        HttpRequest request = new HttpRequest();
        //      System.debug('request = '+  request.getBody());               
        
        body = '{"requesttypeid":"2","reason":"'+InstructorChangeReason+'",'+'"userid": "'+StudentId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doRequestRegisterChatBoot');		
        request.setBody(body);
        
        string getInstructorChangeResponse = ETDI_Service_Requests.changeRequestForETDI(request,Token);
        
        if(getInstructorChangeResponse!=Null)
        {
            
            
            String finalresponse = getInstructorChangeResponse;
            System.debug('finalresponse ='+getInstructorChangeResponse);
            
            //Case ca= [Select id ,Change_Instructor_Reponse__c from case where id = :CaseId];
            // ca.Change_Instructor_Reponse__c = finalresponse;
            //update ca;
            ETDI_Service_Request__c servicerequest = new ETDI_Service_Request__c();
            servicerequest.Account__c = AccountId;
            servicerequest.Request_Type__c = '	Instructor Change';
            //   servicerequest.Old_Value__c = ;
            // servicerequest.New_Value__c = NewLicenceType;
            servicerequest.Service_Request_On__c = System.today();
            servicerequest.Service_Response__c = finalresponse;
           if(finalresponse.contains('(')&&finalresponse.contains(')'))
            {
                Integer startIndex = finalresponse.indexOf('(');
                Integer endIndex = finalresponse.indexOf(')');
                String srNoTemp = finalresponse.substring(startIndex,endIndex);
                System.debug('srNoTemp = '+srNoTemp);
                if(srNoTemp.length()>2)
                {
                    srNoTemp = srNoTemp.substring(2,srNoTemp.length()-1);
                    try{
                        servicerequest.Service_Request_Num__c =  srNoTemp;
                        servicerequest.Status__c = 'Pending'; 
                        System.debug('srNoTemp = '+srNoTemp);
                    }
                    catch(Exception e)
                    {
                    } 
                }
                
			}
            servicerequest.ETDI_Student_Name__c = StudentName;
            servicerequest.Case__c=CaseId;
            insert servicerequest;
            
        }
        
        
        
    }
    @AuraEnabled
    public static void changecourse(Id CaseId,String OldLicenceType, String NewLicenceType)
    {
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            
            
            //  createETDIDetails(acc.id,Token,UserId,StudentId);
            //changeInstructorPostMethod(acc.id,InstructorChangeReason,CaseId, Token, UserId, StudentId);
            changeCoursePostMethod(acc.id,OldLicenceType,NewLicenceType,CaseId,Token, UserId, StudentId);
            //    System.debug('aftercreatecalls');
        }
        
        
        
        
        
    }
    @future(callout = true)
    public static void changeCoursePostMethod(Id AccountId,String OldLicenceType,String NewLicenceType,Id CaseId,String Token, String UserId,String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String body ='';        
        String TokenServiceMessage='';
        String StudentName='';
        StudentName = getStudentName(UserId,Token);
        HttpRequest request = new HttpRequest();
        //      System.debug('request = '+  request.getBody());
        
        
        Map<String,Integer> vehiceltypes = new Map<String,Integer>();
        vehiceltypes.put('LAV', 1);
        vehiceltypes.put('LMV', 2);
        vehiceltypes.put('HVB', 3);
        vehiceltypes.put('MOT', 4);
        vehiceltypes.put('HVT', 5);
        vehiceltypes.put('HFL', 6);
        vehiceltypes.put('LFL', 7);
        vehiceltypes.put('SHO', 8);
        vehiceltypes.put('BLD', 9);
        
        Integer oldvehicleid = vehiceltypes.get(OldLicenceType);
        Integer newvehicleid = vehiceltypes.get(NewLicenceType);   
        
        body = '{"requesttypeid":"1","currentvehicleid":"'+oldvehicleid+'",'+'"changenewvehicleid":"'+oldvehicleid+'",'+'"userid": "'+StudentId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doRequestRegisterChatBoot');		
        request.setBody(body);
        
        string getCourseChangeServiceResponse = ETDI_Service_Requests.changeRequestForETDI(request,Token);
        
        if(getCourseChangeServiceResponse!=Null)
        {
            
            String finalresponse = getCourseChangeServiceResponse;
            System.debug('finalresponse ='+getCourseChangeServiceResponse);
            ETDI_Service_Request__c servicerequest = new ETDI_Service_Request__c();
            servicerequest.Account__c = AccountId;
            servicerequest.Request_Type__c = 'Course Change';
            servicerequest.Old_Value__c = OldLicenceType;
            servicerequest.New_Value__c = NewLicenceType;
            servicerequest.Service_Request_On__c = System.today();
            servicerequest.Service_Response__c = getCourseChangeServiceResponse;
            if(finalresponse.contains('(')&&finalresponse.contains(')'))
            {
                Integer startIndex = finalresponse.indexOf('(');
                Integer endIndex = finalresponse.indexOf(')');
                String srNoTemp = finalresponse.substring(startIndex,endIndex);
                System.debug('srNoTemp = '+srNoTemp);
                if(srNoTemp.length()>2)
                {
                    srNoTemp = srNoTemp.substring(2,srNoTemp.length()-1);
                    try{
                        servicerequest.Service_Request_Num__c =  srNoTemp;
                        servicerequest.Status__c = 'Pending'; 
                        System.debug('srNoTemp = '+srNoTemp);
                    }
                    catch(Exception e)
                    {
                    } 
                }
                
			}
            servicerequest.Case__c=CaseId;
            servicerequest.ETDI_Student_Name__c=StudentName;
            insert servicerequest;
            
        }
        
    }
    @AuraEnabled
    public static Map<String,List<String>> getClassScheduleOfInstructor(Id CaseId)
    {   
        Map<String,List<String>> availableSlots = new Map<String,List<String>>();
        
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+Token);
            String body='';                        
            HttpRequest request = new HttpRequest();
            
            body = '{"userid": "'+StudentId + '"}';
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/GetSchedulingData');		
            request.setBody(body);
            
            Map<String,object> getClassSchedulingResponse = ETDI_Service_Requests.getServiceResult(request,Token);
            
            if(getClassSchedulingResponse!=null)
            {
                
                List<Object> classSchedulingTimingList = (List<Object>)getClassSchedulingResponse.get('Data');
                Boolean dateAvailable = false;
                
                
                for(Object classdateTime:classSchedulingTimingList)
                {
                    
                    Map<String, Object> classDateScheduleMap =  (Map<String, Object>)classdateTime;
                    
                    String getdates = (String)classDateScheduleMap.get('DATE');
                    String availTime = (String)classDateScheduleMap.get('TIME');
                    System.debug('Dates fetched='+getdates);
                    
                    List<String> dates = getdates.split(',');
                    Date dt = System.today().adddays(1);
                    string dateStr = DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('dd MMM yyyy');
                    for(Integer i=1 ; i<=15;i++)
                    {
                        for(String datecheck:dates)
                        {
                            // System.debug('datecehck='+datecheck);
                            if(datecheck.contains(dateStr))
                            {
                                dateAvailable = true; 
                                System.debug('Matched');
                            }
                            
                            
                        }
                        dt = dt.addDays(1);
                        dateStr = DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('dd MMM yyyy');
                    }
                    if(dateAvailable==false)
                    {
                        throw new AuraHandledException('Date Slot is not available for next 7 days.'); 
                    }
                    for(String datecheck:dates)
                    {
                        System.debug('datecehck='+datecheck);
                        Integer enterPresent = datecheck.indexOf('\n');
                        String datec = datecheck.substring(0,enterPresent);
                        //datec = datec.replace(' ','-');
                        System.debug('datec='+datec);
                        //   Date datevale= getConvertDateTime(datec);
                        //  List<String> timelist = availTime.split(':');
                        // Time availTimeSlot = Time.newInstance(Integer.valueOf(timelist[0]), Integer.valueOf(timelist[1]), 0, 0);
                        //System.debug('datevale='+datevale);
                        if(availableSlots.containsKey(datec)){
                            availableSlots.get(datec).add(availTime);
                        }else{
                            availableSlots.put(datec,new List<String>{availTime});
                        }
                    }
                    
                    
                }
                
                
                
            }
            
        }           
        
        System.debug('available Slots='+availableSlots);
        return availableSlots;
    }  
    @AuraEnabled
    public static String getInstructorID(Id CaseId)
    {
        
        String InstructorID = '';
        
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+Token);
            
            String body='';
            
            HttpRequest request = new HttpRequest();
            
            body = '{"userid": "'+StudentId + '"}';
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/GetSchedulingData');		
            request.setBody(body);
            
            Map<String,object> getClassSchedulingResponse = ETDI_Service_Requests.getServiceResult(request,Token);
            
            if(getClassSchedulingResponse!=null)
            {
                
                InstructorID = (String)getClassSchedulingResponse.get('InstructorId');
                
            }   
        }
        
        
        System.debug('InstructorID='+InstructorID);
        return InstructorID;
    }
    @AuraEnabled
    public static String bookClass(Id CaseId,String bookingDate,String bookingTime,String InstructorId)
    {
        String bookClassResponse = '';
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        else if(acc.Phone!=null)
        {
            MobileNumber = acc.Phone;
        }
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            
            
            String body='';
            
            System.debug('token='+getResponseValues);
            
            HttpRequest request = new HttpRequest();
            System.debug('bookingDate='+bookingDate);
            System.debug('bookingTime='+bookingTime);
            System.debug('InstructorId='+InstructorId);
            System.debug('StudentId='+StudentId);
            //  DateTime dt = bookingDate;
            // String bookdate = dt.newInstance(dt.year(), dt.month(), dt.day()).format('dd MMM yyyy');
            body = '{"requesttypeid":"3","date":"'+bookingDate+'",'+'"time":"'+bookingTime+'",'+'"instructorid":"'+InstructorId+'",'+'"userid": "'+StudentId + '"}';
            System.debug('Body of book class='+body);       
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/BookClasses');		
            request.setBody(body);
            
            bookClassResponse = ETDI_Service_Requests.changeRequestForETDI(request,Token);
            System.debug('before if ='+bookClassResponse);
            String StudentName='';
            StudentName = getStudentName(UserId,Token);
            if(bookClassResponse.contains('Class scheduled successfully'))
            {
                
                String finalresponse = bookClassResponse;
                System.debug('finalresponse ='+finalresponse);
                String newvalue = 'Class booked on '+bookingDate+' at '+ bookingTime;
                ETDI_Service_Request__c servicerequest = new ETDI_Service_Request__c();
                servicerequest.Account__c = acc.id;
                servicerequest.Request_Type__c = 'Class Booking';
                //  servicerequest.Old_Value__c = OldLicenceType;
                servicerequest.New_Value__c = newvalue;
                servicerequest.Service_Request_On__c = System.today();
                servicerequest.Service_Response__c = bookClassResponse;
                if(finalresponse.contains('(')&&finalresponse.contains(')'))
            {
                Integer startIndex = finalresponse.indexOf('(');
                Integer endIndex = finalresponse.indexOf(')');
                String srNoTemp = finalresponse.substring(startIndex,endIndex);
                System.debug('srNoTemp = '+srNoTemp);
                if(srNoTemp.length()>2)
                {
                    srNoTemp = srNoTemp.substring(2,srNoTemp.length()-1);
                    try{
                        servicerequest.Service_Request_Num__c =  srNoTemp;
                        servicerequest.Status__c = 'Pending'; 
                        System.debug('srNoTemp = '+srNoTemp);
                    }
                    catch(Exception e)
                    {
                    } 
                }
                
			}
                servicerequest.Case__c=CaseId;
                servicerequest.ETDI_Student_Name__c=StudentName;
                insert servicerequest;
                
            }
            else
            {
                System.debug('bookClassResponse='+bookClassResponse);
                throw new AuraHandledException(bookClassResponse); 
            }
            
            
            
        }       
        
        
        System.debug('bookClassResponse='+bookClassResponse);
        return bookClassResponse;
    }
    @AuraEnabled
    public static Map<String,Integer> getExamType(Id CaseId)
    {
        Map<String,Integer> getExamtypeResponse = new Map<String,Integer>();
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            
            String body='';
            
            System.debug('token='+getResponseValues);
            
            HttpRequest request = new HttpRequest();
            //  DateTime dt = bookingDate;
            // String bookdate = dt.newInstance(dt.year(), dt.month(), dt.day()).format('dd MMM yyyy');
            body = '{"userid": "'+UserId + '"}';
            
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetExamTypes');		
            request.setBody(body);
            
            Map<String,object> getExamTypeResponseMap = ETDI_Service_Requests.getServiceResult(request,Token);
            
            
            
            if(getExamTypeResponseMap!=null)
            {
                
                List<Object> ExamTypeList = (List<Object>)getExamTypeResponseMap.get('Data');
                
                for(Object examType:ExamTypeList)
                {
                    
                    Map<String, Object> examTypeMap =  (Map<String, Object>)examType;
                    
                    String examName = (String)examTypeMap.get('NAME_EN');
                    Integer examID = (Integer)examTypeMap.get('ID');
                    System.debug('examName='+examName + ' exam Id ='+examID);
                    getExamtypeResponse.put(examName,examID);    
                    
                }
            }
            else
            {
                throw new AuraHandledException('Exam Type is not present for this user.'); 
            }
            
            
        }           
        
        
        System.debug('getExamtypeResponse='+getExamtypeResponse);
        return getExamtypeResponse;
    }
    @AuraEnabled
    public static String bookExam(Id CaseId,Integer examType,String bookingDate,String examName)
    {
        String bookExamResponse = '';
        
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            
            
            String body='';
            
            System.debug('token='+getResponseValues);
            
            HttpRequest request = new HttpRequest();
            //DateTime dt = Date.newInstance(bookingDate.year(), bookingDate.month(), bookingDate.day());
            //String bookdate = dt.format('dd-MM-yyyy');
            
            body = '{"requesttypeid":"4","bookingdate":"'+bookingDate+'",'+'"examtype":"'+examType+'",'+'"userid": "'+StudentId + '"}';
            System.debug('body display='+body);
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doRequestRegisterChatBoot');		
            request.setBody(body);
            
            bookExamResponse = ETDI_Service_Requests.changeRequestForETDI(request,Token);
            String StudentName='';
            StudentName = getStudentName(UserId,Token);
            if(bookExamResponse.contains('Your request has been submitted.'))
            {
                
                String finalresponse = bookExamResponse;
                System.debug('finalresponse ='+bookExamResponse);
                String newvalue = examName+' exam booked on '+ bookingdate ;
                ETDI_Service_Request__c servicerequest = new ETDI_Service_Request__c();
                servicerequest.Account__c = acc.id;
                servicerequest.Request_Type__c = 'Exam booking';
                //servicerequest.Old_Value__c = OldLicenceType;
                servicerequest.New_Value__c = newvalue;
                servicerequest.Service_Request_On__c = System.today();
                servicerequest.Service_Response__c = bookExamResponse;
                if(finalresponse.contains('(')&&finalresponse.contains(')'))
            {
                Integer startIndex = finalresponse.indexOf('(');
                Integer endIndex = finalresponse.indexOf(')');
                String srNoTemp = finalresponse.substring(startIndex,endIndex);
                System.debug('srNoTemp = '+srNoTemp);
                if(srNoTemp.length()>2)
                {
                    srNoTemp = srNoTemp.substring(2,srNoTemp.length()-1);
                    try{
                        servicerequest.Service_Request_Num__c =  srNoTemp;
                        servicerequest.Status__c = 'Pending'; 
                        System.debug('srNoTemp = '+srNoTemp);
                    }
                    catch(Exception e)
                    {
                    } 
                }
                
			}
                servicerequest.Case__c=CaseId;
                servicerequest.ETDI_Student_Name__c=StudentName;
                insert servicerequest;
                
            }
            else{
                System.debug('resp='+bookExamResponse);
                throw new AuraHandledException(bookExamResponse); 
            }
        }           
        
        
        System.debug('bookExamResponse='+bookExamResponse);
        return bookExamResponse;
    }    
    @AuraEnabled
    public static String getPendingClasses(Id CaseId)
    {
        String getPendingClassJsonString = '';
        
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            
            String body='';
            
            System.debug('token='+getResponseValues);
            
            HttpRequest request = new HttpRequest();
            //  DateTime dt = bookingDate;
            // String bookdate = dt.newInstance(dt.year(), dt.month(), dt.day()).format('dd MMM yyyy');
            body = '{"userid": "'+UserId + '"}';
            
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetPendingScheduleClasses');		
            request.setBody(body);
            
            Map<String,object> getpendingClassResponseMap = ETDI_Service_Requests.getServiceResult(request,Token);
            System.debug('getpendingclasss='+getpendingClassResponseMap);
            if(getpendingClassResponseMap!=null)
            {
                ResponseJSONWrapper wrapper = new ResponseJSONWrapper();
                
                List<Object> getPendingClassesList = (List<Object>)getpendingClassResponseMap.get('Data');
                if(!(getPendingClassesList.size()>0))
                {
                    throw new AuraHandledException('No class is pending to cancel.'); 
                }
                wrapper.pendingClasses = getPendingClassesList;
                getPendingClassJsonString = JSON.serialize(wrapper);
                
            }
            else
            {
                throw new AuraHandledException('Exam Type is not present for this user.'); 
            }
            
        } 
        
        System.debug('getPendingClassResponse='+getPendingClassJsonString);
        return getPendingClassJsonString;
    }
    @AuraEnabled
    public static void getSelectedCancelClass(Id CaseId,List<String> selectedClassSheduleId,String allPendingClass,String Reason)
    {
        System.debug('allPendingClass='+allPendingClass);
        Map<String,Object> allpendingclassesJsonMap = (Map<String,Object>)JSON.deserializeUntyped(allPendingClass);
        List<Object> allpendingclassesJson = (List<Object>)allpendingclassesJsonMap.get('pendingClasses');
        for(String selectedSheduleId:selectedClassSheduleId)
        {
            for(Object pendingclass:allpendingclassesJson)
            {
                system.debug('pendingclass '+pendingclass);
                Map<String, Object> pendingClassMap =  (Map<String, Object>)pendingclass;
                
                Integer pendingsheduleId = (Integer)pendingClassMap.get('CUST_CLASS_SCH_ID');  
                String pendingsheduleIdStr = String.valueOf(pendingsheduleId);
                String pendingclassDate = (String)pendingClassMap.get('DATE'); 
                String classTime = (String)pendingClassMap.get('TIME');
                List<String>  classtimelist = classTime.split(':');
                String pendingClassTime = classtimelist[0] + ':'+classtimelist[1];
                System.debug('pendingClassTime='+pendingClassTime);                    
                pendingsheduleIdStr = pendingsheduleIdStr.trim();
                selectedSheduleId = selectedSheduleId.trim();
                if(pendingsheduleIdStr==selectedSheduleId)
                {
                    cancelClass(CaseId,Reason,pendingclassDate,pendingClassTime, pendingsheduleId);   
                }
                
            }
        }
        System.debug('selectedClassSheduleId='+selectedClassSheduleId);
        System.debug('records='+allPendingClass);        
    }
    @future(callout = true)
    public static void cancelClass(Id CaseId,String Reason,String classDate,String classTime, Integer scheduleId)
    {
        String cancelClassResponse = '';
        
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+Token);
            
            String body='';
            
            System.debug('token='+Token);
            
            HttpRequest request = new HttpRequest();
            
            body = '{"requesttypeid":"5","reason":"'+Reason+'",'+'"time":"'+classTime+'",'+'"date":"'+classDate+'",'+'"scheduleid":"'+scheduleId+'",'+'"userid": "'+StudentId + '"}';
            
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doRequestRegisterChatBoot');		
            request.setBody(body);
            
            cancelClassResponse = ETDI_Service_Requests.changeRequestForETDI(request,Token);
            String StudentName='';
            StudentName = getStudentName(UserId,Token);
            if(cancelClassResponse.contains('Your request has been submitted'))
            {
                
                String finalresponse = cancelClassResponse;
                System.debug('finalresponse ='+cancelClassResponse);
                String newvalue = 'Class Cancelled on '+classDate+' at '+classTime;
                ETDI_Service_Request__c servicerequest = new ETDI_Service_Request__c();
                servicerequest.Account__c = acc.id;
                servicerequest.Request_Type__c = 'Class Cancellation';
                //servicerequest.Old_Value__c = OldLicenceType;
                servicerequest.New_Value__c = newvalue;
                servicerequest.Service_Request_On__c = System.today();
                servicerequest.Service_Response__c = cancelClassResponse;
                if(finalresponse.contains('(')&&finalresponse.contains(')'))
            {
                Integer startIndex = finalresponse.indexOf('(');
                Integer endIndex = finalresponse.indexOf(')');
                String srNoTemp = finalresponse.substring(startIndex,endIndex);
                System.debug('srNoTemp = '+srNoTemp);
                if(srNoTemp.length()>2)
                {
                    srNoTemp = srNoTemp.substring(2,srNoTemp.length()-1);
                    try{
                        servicerequest.Service_Request_Num__c =  srNoTemp;
                        servicerequest.Status__c = 'Pending'; 
                        System.debug('srNoTemp = '+srNoTemp);
                    }
                    catch(Exception e)
                    {
                    } 
                }
                
			}
                servicerequest.Case__c=CaseId;
                servicerequest.ETDI_Student_Name__c=StudentName;
                insert servicerequest;
                
            }
            else{
                System.debug('cancelClassResponse='+cancelClassResponse);
                //   throw new AuraHandledException(cancelClassResponse); 
            }
            
        }           
        System.debug('cancelClassResponse='+cancelClassResponse);
        //  return cancelClassResponse;
    }
    @AuraEnabled
    public static String getPendingExams(Id CaseId)
    {
        
        String getPendingExamJsonString = '';
        
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            
            String body='';
            
            System.debug('token='+getResponseValues);
            
            HttpRequest request = new HttpRequest();
            //  DateTime dt = bookingDate;
            // String bookdate = dt.newInstance(dt.year(), dt.month(), dt.day()).format('dd MMM yyyy');
            body = '{"userid": "'+StudentId + '"}';
            
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetPendingExams');		
            request.setBody(body);
            
            Map<String,object> getpendingExamsResponseMap = ETDI_Service_Requests.getServiceResult(request,Token);
            
            if(getpendingExamsResponseMap!=null)
            {
                ResponseJSONWrapper wrapper = new ResponseJSONWrapper();
                
                List<Object> getPendingExamsList = (List<Object>)getpendingExamsResponseMap.get('Data');
                System.debug('getPendingExamsList size ='+getPendingExamsList.size());
                if(!(getPendingExamsList.size()>0))
                {
                    throw new AuraHandledException('No Exams is pending to cancel.'); 
                }
                
                wrapper.pendingExams = getPendingExamsList;
                getPendingExamJsonString = JSON.serialize(wrapper);
                
            }
            else
            {
                throw new AuraHandledException('Exam Type is not present for this user.'); 
            }
            
        }           
        
        System.debug('getPendingClassResponse='+getPendingExamJsonString);
        return getPendingExamJsonString;
    }
    @AuraEnabled
    public static void getSelectedCancelExam(Id CaseId,List<String> selectedServiceExamIDs,String allPendingExam,String Reason)
    {
        System.debug('allPendingExam='+allPendingExam);
        Map<String,Object> allpendingExamsJsonMap = (Map<String,Object>)JSON.deserializeUntyped(allPendingExam);
        List<Object> allpendingExamsJson = (List<Object>)allpendingExamsJsonMap.get('pendingExams');
        for(String serviceExamID:selectedServiceExamIDs)
        {
            for(Object pendingExam:allpendingExamsJson)
            {
                system.debug('pendingExam '+pendingExam);
                Map<String, Object> pendingExamsMap =  (Map<String, Object>)pendingExam;
                
                Integer pendingExamTypeID = (Integer)pendingExamsMap.get('EXAM_ID'); 
                String pendingexamName = (String)pendingExamsMap.get('EXAM_CODE'); 
                Integer pendingServiceExamID = (Integer)pendingExamsMap.get('CUSTOMER_SERVICE_EXAM_ID');                     
                String pendingExamDate = (String)pendingExamsMap.get('EXAM_DATE');                
                List<String> eDateList = pendingExamDate.split('T');
                Date dt = Date.valueOf(eDateList[0]);
                String finalPendingExamDate = DateTime.newInstance(dt.year(), dt.month(), dt.day()).format('dd-MM-yyyy');
                
                String pendingServiceExamIDStr = String.valueOf(pendingServiceExamID);
                pendingServiceExamIDStr = pendingServiceExamIDStr.trim();
                serviceExamID = serviceExamID.trim();
                if(pendingServiceExamIDStr==serviceExamID)
                {
                    cancelExam(CaseId,Reason,pendingExamTypeID, finalPendingExamDate,pendingexamName);   
                }
                
            }
        }
        System.debug('selectedExamType='+selectedServiceExamIDs);
        System.debug('records='+allPendingExam);        
    }
    @future(callout = true)
    public static void cancelExam(Id CaseId,String Reason, Integer examTypeId,String examDate,String cancelexamName)
    {
        
        String cancelExamResponse = '';
        
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            
            
            String body='';
            
            System.debug('token='+getResponseValues);
            
            HttpRequest request = new HttpRequest();
            
            body = '{"requesttypeid":"6","reason":"'+Reason+'",'+'"examtype":"'+examTypeId+'",'+'"date":"'+examDate+'",'+'"userid": "'+StudentId + '"}';
            
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doRequestRegisterChatBoot');		
            request.setBody(body);
            
            cancelExamResponse = ETDI_Service_Requests.changeRequestForETDI(request,Token);
            String StudentName='';
            StudentName = getStudentName(UserId,Token);
            if(cancelExamResponse.contains('Your request has been submitted'))
            {
                
                String finalresponse = cancelExamResponse;
                System.debug('finalresponse ='+cancelExamResponse);
                String newvalue = 'Exam cancellation request raised for '+cancelexamName + ' which was scheduled on ' + ExamDate;
                ETDI_Service_Request__c servicerequest = new ETDI_Service_Request__c();
                servicerequest.Account__c = acc.id;
                servicerequest.Request_Type__c = 'Exam Cancellation';
                //servicerequest.Old_Value__c = OldLicenceType;
                servicerequest.New_Value__c = newvalue;
                servicerequest.Service_Request_On__c = System.today();
                servicerequest.Service_Response__c = cancelExamResponse;
                if(finalresponse.contains('(')&&finalresponse.contains(')'))
            {
                Integer startIndex = finalresponse.indexOf('(');
                Integer endIndex = finalresponse.indexOf(')');
                String srNoTemp = finalresponse.substring(startIndex,endIndex);
                System.debug('srNoTemp = '+srNoTemp);
                if(srNoTemp.length()>2)
                {
                    srNoTemp = srNoTemp.substring(2,srNoTemp.length()-1);
                    try{
                        servicerequest.Service_Request_Num__c =  srNoTemp;
                        servicerequest.Status__c = 'Pending'; 
                        System.debug('srNoTemp = '+srNoTemp);
                    }
                    catch(Exception e)
                    {
                    } 
                }
                
			}
                servicerequest.Case__c=CaseId;
                servicerequest.ETDI_Student_Name__c=StudentName;
                insert servicerequest;
                
            }
            else{
                System.debug('cancelClassResponse='+	cancelExamResponse);
                //throw new AuraHandledException(cancelExamResponse); 
            }
            
            
        }           
        
        System.debug('cancelClassResponse='+cancelExamResponse);
        
    }
    
    @AuraEnabled
    public static String changeToOnlineLecture(Id CaseId,String Reason)
    {
        String changeToOnlineLectureResponse = '';
        
        Case cas = [Select id,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
        
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }
        if(MobileNumber==''&&TFNNumber=='')
        {
            throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            getResponseValues = ETDI_Service_Requests.checkTokenForTFN(acc.id);
            
            if(getResponseValues=='')
            {
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
                throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
            }
            else
            {             
                getResponseValues = ETDI_Service_Requests.checkTokenForMobileNumber(acc.id);
                
                if(getResponseValues=='')
                {
                    throw new AuraHandledException('Phone Number provided is not User in ETDI System.'); 
                }
            }            
        }
        
        
        if(getResponseValues!='')
        {
            
            List<String> tokenResponse = getResponseValues.split(',');
            String Token = tokenResponse[0];
            String UserId = tokenResponse[1];
            String StudentId = tokenResponse[2];
            System.debug('token='+getResponseValues);
            String StudentName='';
            StudentName = getStudentName(UserId,Token);
            String body='';
            
            System.debug('token='+getResponseValues);
            
            HttpRequest request = new HttpRequest();
            
            body = '{"requesttypeid":"7","reason":"'+Reason+'",'+'"userid": "'+StudentId + '"}';
            
            
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doRequestRegisterChatBoot');		
            request.setBody(body);
            
            changeToOnlineLectureResponse = ETDI_Service_Requests.changeRequestForETDI(request,Token);

            if(changeToOnlineLectureResponse.contains('Your request has been submitted'))
            {
                
                String finalresponse = changeToOnlineLectureResponse;
                System.debug('finalresponse ='+changeToOnlineLectureResponse);
                //  String newvalue = 'Class Cancelled on '+classDate+' at '+classTime;
                ETDI_Service_Request__c servicerequest = new ETDI_Service_Request__c();
                servicerequest.Account__c = acc.id;
                servicerequest.Request_Type__c = 'Change To Online Lecture';
                //servicerequest.Old_Value__c = OldLicenceType;
                //   servicerequest.New_Value__c = newvalue;
                servicerequest.Service_Request_On__c = System.today();
                servicerequest.Service_Response__c = changeToOnlineLectureResponse;
                if(finalresponse.contains('(')&&finalresponse.contains(')'))
            {
                Integer startIndex = finalresponse.indexOf('(');
                Integer endIndex = finalresponse.indexOf(')');
                String srNoTemp = finalresponse.substring(startIndex,endIndex);
                System.debug('srNoTemp = '+srNoTemp);
                if(srNoTemp.length()>2)
                {
                    srNoTemp = srNoTemp.substring(2,srNoTemp.length()-1);
                    try{
                        servicerequest.Service_Request_Num__c =  srNoTemp;
                        servicerequest.Status__c = 'Pending'; 
                        System.debug('srNoTemp = '+srNoTemp);
                    }
                    catch(Exception e)
                    {
                    } 
                }
                
			}
                servicerequest.Case__c=CaseId;
                servicerequest.ETDI_Student_Name__c=StudentName;
                insert servicerequest;
                
            }
            else{
                System.debug('changeToOnlineLectureResponse='+changeToOnlineLectureResponse);
                throw new AuraHandledException(changeToOnlineLectureResponse);
            }
            
            
        } 
        
        
        System.debug('changeToOnlineLectureResponse='+changeToOnlineLectureResponse);
        return changeToOnlineLectureResponse;
    } 
    
    public class ResponseJSONWrapper {       
        public List<Object> pendingClasses;
        public List<Object> pendingExams;
    }  
}