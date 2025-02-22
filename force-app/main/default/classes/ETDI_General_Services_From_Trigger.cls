public class ETDI_General_Services_From_Trigger {

public static List<Theory_Class_Schedule__c> theoryList;
public static List<ETDI_Payment_History__c> PaymentHistoryList; 
public static  List<ETDI_Scheduled_Exam__c> etdiScheduledExamObjList ;   
public static  List<ETDI_Assessment_Schedule__c> assessmentScheduleObjlist; 
public static  List<ETDI_Practical_Schedule__c> practicalScehduleObjList ;
public static  String Licensetype ='';
public static String PersonName='';
public static String TrafficeFileNumber='';
public static String mockTestResult;
public static String permitStatus;    
    
public static List<Date> practicalscheduledatelist;
    
  public static void validateMobileTFNCallETDI(Map<Id,Case> CaseNewMap)
    {
        List<Case> caseList = [Select id,Description from Case where id IN:CaseNewMap.keySet()];
        List<Case> updateCaseList = new List<Case>();
        for(Case cs : caseList){
          String etdierror ='';           
          checkNumberAndCallETDIdetails(cs.id);                
           if(etdierror!='')
           {
              cs.Description =  etdierror;
              updateCaseList.add(cs); 
           }                        
        }
        
        if(updateCaseList.size()>0)
        {
            update updateCaseList;
        }
        
    }
    @future(callout = true)
    public static void checkNumberAndCallETDIdetails(Id CaseId)
    {
        String tokenError = '';
        Case cas = [Select id,Description,AccountId from Case where id=:CaseId];
        
        Account acc= [Select id , ETIN_Mobile_Number__c,PersonMobilePhone,TFN_Number__c,Phone from Account where id=:cas.AccountId];
        String MobileNumber = '';
        String TFNNumber='';
        String getResponseValues='';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        } 
        else if (acc.ETIN_Mobile_Number__c!=null)
        {
             MobileNumber = acc.ETIN_Mobile_Number__c; 
        }
        if(acc.TFN_Number__c!=null&&acc.TFN_Number__c!='')
        {
            TFNNumber = acc.TFN_Number__c;
        }        
        system.debug('MobileNumber='+MobileNumber+'TFNNumber'+TFNNumber);
        if(MobileNumber==''&&TFNNumber=='')
        {
            //throw new AuraHandledException('TFN Number or Mobile number is not provided for ETDI. Please provide in Account.');
            tokenError = 'TFN Number or Mobile number is not provided for ETDI. Please provide in Account.';
          //  return tokenError;
          
        }
        else if(TFNNumber!= ''&&MobileNumber=='')
        {
            Map<String,object> TokenserviceResponse = new  Map<String,object>();
            
            HttpRequest request = new HttpRequest();
            
            
            request= ETDI_Service_Requests.createRequest('GET', '/ETASWApi/api/WebApi/doGetAuthroizedTokenByTFN');
            //     request.setBody(body);
            request.setHeader('TFN', TFNNumber);       
            
            System.debug('entered getTokenUsingTFNStaging');
            Map<String, Object> responseResult =new Map<String, Object>();
            Http http = new Http();
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200) {
                
                
                responseResult = null;
                System.debug('Error in Request. Error Body = '+response.getBody());
                System.debug('Error in Request. Error Response = '+response.getStatusCode());
            }
            else{
                if(response.getStatusCode() == 200){
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());                
                    responseResult =result;               
                    System.debug('Success');
                    System.debug('Response Body='+response.getBody());                
                }
                
            }
            
            if(TokenserviceResponse!=null)
            {
                String TokenServiceMessage = (String)TokenserviceResponse.get('Message');
                if(TokenServiceMessage=='Authorized')
                {
                    List<Object> objectNames = (List<Object>)TokenserviceResponse.get('Data');
                    Map<String, Object> tokenservicemap = new Map<String, Object>();
                    tokenservicemap = (Map<String, Object>)objectNames[0];
                    String Token = (String)tokenservicemap.get('Token');
                    String UserId = (String)tokenservicemap.get('UserId');
                    String StudentID = (String)tokenservicemap.get('StudentId');
                    System.debug('Final Token='+tokenservicemap.get('Token'));
                    System.debug('User Id='+tokenservicemap.get('UserId'));
                    System.debug('StudentId ='+tokenservicemap.get('StudentId'));
                    getResponseValues = Token + ',' + UserId + ',' + StudentID;
                    
                }
            }
            
            
            if(getResponseValues=='')
            {
               //throw new AuraHandledException('Provided TFN number is not present in ETDI.');  
                tokenError = 'Provided TFN number is not present in ETDI.';
               // return tokenError;
            }
        }
        else if(TFNNumber!= ''&&MobileNumber!='')
        {
            Map<String,object> TokenserviceResponse = new  Map<String,object>();
            
            HttpRequest request = new HttpRequest();

            request= ETDI_Service_Requests.createRequest('GET', '/ETASWApi/api/WebApi/doGetAuthroizedTokenByTFN');
            //     request.setBody(body);
            request.setHeader('TFN', TFNNumber);       
            
            System.debug('entered getTokenUsingTFNStaging');
            Map<String, Object> responseResult =new Map<String, Object>();
            Http http = new Http();
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200) {
                
                responseResult = null;
                System.debug('Error in Request. Error Body = '+response.getBody());
                System.debug('Error in Request. Error Response = '+response.getStatusCode());
            }
            else{
                if(response.getStatusCode() == 200){
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());                
                    responseResult =result;               
                    System.debug('Success');
                    System.debug('Response Body='+response.getBody());                
                }
                
            }
            
            if(TokenserviceResponse!=null)
            {
                String TokenServiceMessage = (String)TokenserviceResponse.get('Message');
                if(TokenServiceMessage=='Authorized')
                {
                    List<Object> objectNames = (List<Object>)TokenserviceResponse.get('Data');
                    Map<String, Object> tokenservicemap = new Map<String, Object>();
                    tokenservicemap = (Map<String, Object>)objectNames[0];
                    String Token = (String)tokenservicemap.get('Token');
                    String UserId = (String)tokenservicemap.get('UserId');
                    String StudentID = (String)tokenservicemap.get('StudentId');
                    System.debug('Final Token='+tokenservicemap.get('Token'));
                    System.debug('User Id='+tokenservicemap.get('UserId'));
                    System.debug('StudentId ='+tokenservicemap.get('StudentId'));
                    getResponseValues = Token + ',' + UserId + ',' + StudentID;
                    
                }
            }
            
            if(getResponseValues=='')
            {
             TokenserviceResponse = new  Map<String,object>();
           
            String   MobileNumber1 = MobileNumber.replace('+', '');   
             request = new HttpRequest();
            
            String body = '{"mobile": "'+MobileNumber1 + '"}';
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebApi/doGetAuthroizedTokenByMobile');
            //     request.setBody(body);
            request.setBody(body);
                
            System.debug('entered getTokenUsingMobileStaging');
            responseResult =new Map<String, Object>();
             http = new Http();
             response = http.send(request);
            if (response.getStatusCode() != 200) {
                
                
                TokenserviceResponse = null;
                System.debug('Error in Request. Error Body = '+response.getBody());
                System.debug('Error in Request. Error Response = '+response.getStatusCode());
            }
            else{
                if(response.getStatusCode() == 200){
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());                
                    TokenserviceResponse =result;               
                    System.debug('Success');
                    System.debug('Response Body='+response.getBody());                
                }
                
            }
            
                if(TokenserviceResponse!=null)
                {
                    String TokenServiceMessage = (String)TokenserviceResponse.get('Message');
                    if(TokenServiceMessage=='Authorized')
                    {
                        List<Object> objectNames = (List<Object>)TokenserviceResponse.get('Data');
                        Map<String, Object> tokenservicemap = new Map<String, Object>();
                        tokenservicemap = (Map<String, Object>)objectNames[0];
                        String Token = (String)tokenservicemap.get('Token');
                        String UserId = (String)tokenservicemap.get('UserId');
                        String StudentID = (String)tokenservicemap.get('StudentId');
                        System.debug('Final Token='+tokenservicemap.get('Token'));
                        System.debug('User Id='+tokenservicemap.get('UserId'));
                        System.debug('StudentId ='+tokenservicemap.get('StudentId'));
                        getResponseValues = Token + ',' + UserId + ',' + StudentID;
                        
                    }
                }
                
                
                if(getResponseValues=='')
                {
                //  throw new AuraHandledException('TFN Number and Phone Number provided is not User in ETDI System.');    
                    tokenError = 'TFN Number and Phone Number provided is not User in ETDI System.';
                   // return tokenError;
                }
            }
        }
        else if(TFNNumber== ''&&MobileNumber!='')
        {
            if(!MobileNumber.contains('+971'))
            {
               // throw new AuraHandledException('Phone Number is required and should be in +971xxxxxxxxx format'); 
                tokenError = 'Phone Number is required and should be in +971xxxxxxxxx format';
              //  return tokenError;
            }
            else
            {             
            Map<String,object> TokenserviceResponse = new  Map<String,object>();
         //  MobileNumber = MobileNumber.replace('+', '');
            String MobileNumber1 = MobileNumber.replace('+', '');    
            HttpRequest request = new HttpRequest();
            
            String body = '{"mobile": "'+MobileNumber1 + '"}';
            request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebApi/doGetAuthroizedTokenByMobile');
            //     request.setBody(body);
            request.setBody(body);
                
            System.debug('entered getTokenUsingMobileStaging');
            Map<String, Object> responseResult =new Map<String, Object>();
            Http http = new Http();
            HttpResponse response = http.send(request);
            if (response.getStatusCode() != 200) {
                
                
                TokenserviceResponse = null;
                System.debug('Error in Request. Error Body = '+response.getBody());
                System.debug('Error in Request. Error Response = '+response.getStatusCode());
            }
            else{
                if(response.getStatusCode() == 200){
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());                
                    TokenserviceResponse =result;               
                    System.debug('Success');
                    System.debug('Response Body='+response.getBody());                
                }
                
            }
            
                if(TokenserviceResponse!=null)
                {
                    String TokenServiceMessage = (String)TokenserviceResponse.get('Message');
                    if(TokenServiceMessage=='Authorized')
                    {
                        List<Object> objectNames = (List<Object>)TokenserviceResponse.get('Data');
                        Map<String, Object> tokenservicemap = new Map<String, Object>();
                        tokenservicemap = (Map<String, Object>)objectNames[0];
                        String Token = (String)tokenservicemap.get('Token');
                        String UserId = (String)tokenservicemap.get('UserId');
                        String StudentID = (String)tokenservicemap.get('StudentId');
                        System.debug('Final Token='+tokenservicemap.get('Token'));
                        System.debug('User Id='+tokenservicemap.get('UserId'));
                        System.debug('StudentId ='+tokenservicemap.get('StudentId'));
                        getResponseValues = Token + ',' + UserId + ',' + StudentID;
                        
                    }
                }
                
                if(getResponseValues=='')
                {
                   // throw new AuraHandledException('Phone Number provided is not User in ETDI System.');
                      tokenError = 'Phone Number provided is not User in ETDI System.';
                    //return tokenError;
                }
            }            
        }
        
        if(tokenError != '')
        {
            cas.Description = tokenError;
            update cas;
        }
        else
        {
            if(getResponseValues!='')
            {
                     
                List<String> tokenResponse = getResponseValues.split(',');
                String Token = tokenResponse[0];
                String UserId = tokenResponse[1];
                String StudentId = tokenResponse[2];
                System.debug('token='+getResponseValues);

            try{
                getTheorySchedule( acc.Id,Token,UserId,StudentId);   
            }
            catch(Exception e){}    
            try{
                getPaymentHistory( acc.Id,Token,UserId,StudentId);   
            }
            catch(Exception e){} 
            try{
                getProfileInformation(acc.Id,Token,UserId,StudentId); 
            }
            catch(Exception e){}            
            try{
                getPracticalSchedule(acc.Id,Token,UserId,StudentId);  
            }
            catch(Exception e){}
            try{
                getScheduledAssessment(acc.Id,Token,UserId,StudentId);  
            }
            catch(Exception e){}
            try{
                getScheduledExams(acc.Id,Token,UserId,StudentId);
            }
            catch(Exception e){}  
                  try{
                getMockTestResult(acc.Id,Token,UserId,StudentId);
            }
            catch(Exception e){}  
                  try{
                getPermitStatus(acc.Id,Token,UserId,StudentId);
            }
            catch(Exception e){}  
            
             
                ETDI_Detail__c etdiDetail = new ETDI_Detail__c();
                etdiDetail.Account__c= acc.Id;
                etdiDetail.Mobile__c = MobileNumber;
                insert etdiDetail; 
                if(theoryList!=null)
                {
                    if(theoryList.size()>0)
                {
                    List<Theory_Class_Schedule__c> theorylistinsert = new List<Theory_Class_Schedule__c>();
                    for(Theory_Class_Schedule__c theory:theoryList)
                    {
                        theory.ETDI_Detail__c = etdiDetail.id;
                        theorylistinsert.add(theory);
                    }
                    if(theorylistinsert.size()>0)
                    {
                        insert theorylistinsert;
                    }
                }
				}
                if(PaymentHistoryList!=null)
                {
                   if(PaymentHistoryList.size()>0)
                {
                    List<ETDI_Payment_History__c> PaymentHistoryListinsert = new List<ETDI_Payment_History__c>();
                    for(ETDI_Payment_History__c pay:PaymentHistoryList)
                    {
                        pay.ETDI_Detail__c = etdiDetail.id;
                        PaymentHistoryListinsert.add(pay);
                    }
                    if(PaymentHistoryListinsert.size()>0)
                    {
                        insert PaymentHistoryListinsert;
                    }
                } 
				}
                
                if(etdiScheduledExamObjList!=null)
                {
                    if(etdiScheduledExamObjList.size()>0)
                {
                    List<ETDI_Scheduled_Exam__c> etdiScheduledExamObjListinsert = new List<ETDI_Scheduled_Exam__c>();
                    for(ETDI_Scheduled_Exam__c exam:etdiScheduledExamObjList)
                    {
                        exam.ETDI_Detail__c = etdiDetail.id;
                        etdiScheduledExamObjListinsert.add(exam);
                    }
                    if(etdiScheduledExamObjListinsert.size()>0)
                    {
                        insert etdiScheduledExamObjListinsert;
                        
                         List<ETDI_Scheduled_Exam__c> insertedexamscehdule = [Select id,Exam_Date__c,Exam_Name__c,Exam_Result__c from ETDI_Scheduled_Exam__c where id In:etdiScheduledExamObjListinsert];
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
                            ETDI_Detail__c updateEtdidetail =  [Select id,Exam_Name__c,Exam_Result__c,Exam_Date__c from ETDI_Detail__c where id=:etdiDetail.id];
                            updateEtdidetail.Exam_Name__c = examname;
                            updateEtdidetail.Exam_Result__c = examresult;
                            updateEtdidetail.Exam_Date__c = latestexamdate;
                            update   updateEtdidetail;
                        }
                        
                    }
                    }
                }
				}
                if(assessmentScheduleObjlist!=null)
                {
                  if(assessmentScheduleObjlist.size()>0)
                {
                    List<ETDI_Assessment_Schedule__c> assessmentListinsert = new List<ETDI_Assessment_Schedule__c>();
                    for(ETDI_Assessment_Schedule__c assess:assessmentScheduleObjlist)
                    {
                        assess.ETDI_Detail__c = etdiDetail.id;
                        assessmentListinsert.add(assess);
                    }
                    if(assessmentListinsert.size()>0)
                    {
                        insert assessmentListinsert;
                    }
                }  
                }
                 
                if(practicalScehduleObjList!=null)
                {
                    if(practicalScehduleObjList.size()>0)
                {
                    List<ETDI_Practical_Schedule__c> practicalListinsert = new List<ETDI_Practical_Schedule__c>();
                    for(ETDI_Practical_Schedule__c practical:practicalScehduleObjList)
                    {
                        practical.ETDI_Detail__c = etdiDetail.id;
                        practicalListinsert.add(practical);
                    }
                    if(practicalListinsert.size()>0)
                    {
                        insert practicalListinsert;
                        
                         Date latestDate = practicalscheduledatelist[0];
                    String LatestInstructorName = '';
                    for(Date dt:practicalscheduledatelist)
                    {
                        if(latestDate<dt)
                        {
                            latestDate = dt;
                        }
                    }
                    List<ETDI_Practical_Schedule__c> insertpracticalscehdule = [Select id,Date__c,Instructor_Name__c from ETDI_Practical_Schedule__c where id In:practicalListinsert];
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
                            ETDI_Detail__c updateEtdidetail =  [Select id,Instructor_Name__c from ETDI_Detail__c where id=:etdiDetail.id];
                            updateEtdidetail.Instructor_Name__c = LatestInstructorName;
                            update   updateEtdidetail;
                        }
                        
                    }
                    
                    }
                }
				}
                 
                
                if((Licensetype!='')||(PersonName!='')||(TrafficeFileNumber!=''))
                {
                    etdiDetail.License_Type__c = Licensetype;
                    etdiDetail.Student_Name__c = PersonName;
                    etdiDetail.Mock_Test_Result__c = mockTestResult;
                    etdiDetail.Traffic_File_Number__c = TrafficeFileNumber;
                    if(permitStatus!=null&&permitStatus!='')
                    {
                        etdiDetail.Permit_Status__c = permitStatus;
                    }
                    
                    //   etdipersondetail.Instructor_Name__c = InstructorName;
                    update etdiDetail;
                }
                
                if(etdiDetail.Id!=null)
                {
                     List<ETDI_Detail__c> etdiDetailDeleteList = [Select id,Name from ETDI_Detail__c where Account__c =: acc.id And id !=:etdiDetail.Id AND Mobile__c=:acc.PersonMobilePhone];
                    if(etdiDetailDeleteList.size()>0)
                    {
                        delete etdiDetailDeleteList;
                    }
                }
                System.debug('aftercreatecalls');
            }
          
        
        }
         
       // return tokenError;
    }
    public static void getTheorySchedule(Id AccountId,String Token,String UserId, String StudentId)
    {
        // account id = '0013M00000TjtyQQAR'
        String body ='';
        
        
        HttpRequest request = new HttpRequest();
        
        body = '{"studentid": "'+UserId + '"}';
        
        
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebAPI/doGetTheoryClassesSchedule');        
        request.setBody(body);
        
        Map<String,object> getTheoryResponse = ETDI_Service_Requests.getServiceResult(request,Token);
        theoryList = new List<Theory_Class_Schedule__c>();
        if(getTheoryResponse!=Null)
        {
            String ResponseMessage =(String)getTheoryResponse.get('Message');
            
            System.debug('Message = '+ResponseMessage);
            List<Object> TheorySchedules = (List<Object>)getTheoryResponse.get('Data');
           
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
              //  theory.ETDI_Detail__c = ETDIDetailID;
                theoryList.add(theory);
                System.debug('Theory Class Schedule Data'+TheorySchedule); 
                //  }
                
                
            }
                      
            
        }
      
        
    }
    
    public static void getPaymentHistory(Id AccountId,String Token,String UserId, String StudentId)
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
                
                PaymentHistoryList = new List<ETDI_Payment_History__c>();
                
                Integer count = 0;   
                for(Object Payment:PaymentHistory)
                {
                    ETDI_Payment_History__c payHistory = new ETDI_Payment_History__c();
                    Map<String, Object> PaymentMap =  (Map<String, Object>)Payment;
                    
                    payHistory.Transaction_ID__c = (Decimal)PaymentMap.get('ID') ;
                    payHistory.Payment_Category__c=(String)PaymentMap.get('PAYMENT_CATEGORY_NAME') ;
                    String data = (String)PaymentMap.get('TRAN_DATE');
                    payHistory.Transaction_Date__c   = (DateTime)JSON.deserialize('"' + data + '"', DateTime.class);
                    // payHistory.Transaction_Date__c=(String)PaymentMap.get('TRAN_DATE') ;
                    payHistory.Amount__c=(Decimal)PaymentMap.get('AMOUNT') ;
                 //   payHistory.ETDI_Detail__c = ETDIDetailID;
                    System.debug('Payment='+Payment);
                    
                    PaymentHistoryList.add(payHistory);
                }
                               
            }
            
        }       
           
        
    }
    
    
    public static void getScheduledExams(Id AccountId,String Token,String UserId, String StudentId)
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
                etdiScheduledExamObjList = new List<ETDI_Scheduled_Exam__c>();
                Integer count = 0;   
                for(Object ScheuleExam:ScheduledExamsList)
                {
                    ETDI_Scheduled_Exam__c ScheduledExam = new ETDI_Scheduled_Exam__c();
                    Map<String, Object> ScheduledExamsMap =  (Map<String, Object>)ScheuleExam;
                    
                    ScheduledExam.Customer_Service_Exam_ID__c    = String.valueOf(ScheduledExamsMap.get('CUSTOMER_SERVICE_EXAM_ID'));
                    ScheduledExam.Exam_Centre__c = (String)ScheduledExamsMap.get('EXAM_CENTRE');
                    ScheduledExam.Exam_Name__c = (String)ScheduledExamsMap.get('NAME_EN');
                    ScheduledExam.Exam_Result__c = (String)ScheduledExamsMap.get('EXAM_RESULT');
                    ScheduledExam.Schedule_Exam_ID__c = String.valueOf(ScheduledExamsMap.get('ID'));
                    String data = (String)ScheduledExamsMap.get('EXAM_DATE');
                    ScheduledExam.Exam_Date__c   = (DateTime)JSON.deserialize('"' + data + '"', DateTime.class);
                   // ScheduledExam.ETDI_Detail__c = ETDIDetailID;
                    System.debug('ScheuleExam='+ScheuleExam);
                    etdiScheduledExamObjList.add(ScheduledExam);
                }
                
            }
            else{
                System.debug('Message ='+ResponseMessage);
            }
            
        }
          
    }

    public static void getProfileInformation(Id AccountId,String Token,String UserId, String StudentId)
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
            //    ETDI_Detail__c etdipersondetail = [Select id, Student_Name__c,License_Type__c from ETDI_Detail__c where id=:ETDIDetailID];
                
                Integer count = 0;   
                for(Object ProfileInformation:ProfileInformationList)
                {
                    Map<String, Object> ProfileInfoMap =  (Map<String, Object>)ProfileInformation;
                    
                    Licensetype= (String)ProfileInfoMap.get('LICENSE_TYPE'); 
                    PersonName = (String)ProfileInfoMap.get('PERSON_NAME_EN');
                    TrafficeFileNumber = (String)ProfileInfoMap.get('TFN');
                     
                    System.debug('ProfileInformation='+ProfileInformation);
                }
                
            }
            
        }      
        
    }
   
    public static void getScheduledAssessment(Id AccountId,String Token,String UserId, String StudentId)
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
                
                assessmentScheduleObjlist = new List<ETDI_Assessment_Schedule__c>();  
                for(Object Assesment:ScheuledAssessmentList)
                {
                    ETDI_Assessment_Schedule__c assessmentSchedule = new ETDI_Assessment_Schedule__c();
                    Map<String, Object> assessmentScheduleClassMap =  (Map<String, Object>)Assesment;
                    
                    assessmentSchedule.Training_Name__c  = (String)assessmentScheduleClassMap.get('TRAINING_NAME');
                    assessmentSchedule.Status__c     = (String)assessmentScheduleClassMap.get('STATUS');  
                    assessmentSchedule.Instructor_Name__c    = (String)assessmentScheduleClassMap.get('INSTRUCTOR_NAME');  
                    assessmentSchedule.Class_Schedule_Id__c  =String.valueOf(assessmentScheduleClassMap.get('CUST_CLASS_SCH_ID'));  
                    assessmentSchedule.Seq_Number__c     = (Decimal)assessmentScheduleClassMap.get('SEQ_NUM');
                    String strTimeChange=(String)assessmentScheduleClassMap.get('TIME'); 
                    String[] strTimeSplit = strTimeChange.split(':');
                    assessmentSchedule.Time__c = Time.newInstance( Integer.valueOf(strTimeSplit[0]),Integer.valueOf(strTimeSplit[1]),0,0); 
                    // pendingschClass.Time__c   = (String)PendingScheduleClassMap.get('TIME'); 
                    // date coming from APi is in dd/MM/yyyy format . so we will convert it into yyyy-MM-dd format 
                    String getdate = (String)assessmentScheduleClassMap.get('DATE');
                    String[] strDateSplit = getdate.split('-');            
                    assessmentSchedule.Date__c = Date.valueOf(strDateSplit[2] + '-' + strDateSplit[0] + '-' + strDateSplit[1]); 
                    //   pendingschClass.Date__c     = (String)PendingScheduleClassMap.get('DATE');  
                    //assessmentSchedule.ETDI_Detail__c  = ETDIDetailID;  
                    System.debug('assessmentScheduleClassMap='+assessmentScheduleClassMap);
                    assessmentScheduleObjlist.add(assessmentSchedule);
                }
                               
            }
            else{
                System.debug('Message ='+ResponseMessage);
            }
            
        }     
        
    }    
    public static void getPracticalSchedule(Id AccountId,String Token,String UserId, String StudentId)
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
                practicalScehduleObjList = new List<ETDI_Practical_Schedule__c>();
                Integer count = 0;
               practicalscheduledatelist = new List<Date>();
                
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
                   // practicalScheduleobj.ETDI_Detail__c=ETDIDetailID;
                    practicalScehduleObjList.add(practicalScheduleobj);
                    System.debug('PracticalSchedule='+PracticalSchedule);
                }                               
                
            }
            else{
                System.debug('Message ='+ResponseMessage);
            }
            
        }      
        
    }   
     public static void getMockTestResult(Id AccountId,String Token,String UserId, String StudentId)
     {     String body ='';
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
            //    ETDI_Detail__c etdipersondetail = [Select id, Mock_Test_Result__c from ETDI_Detail__c where id=:ETDIDetailID];
                mockTestResult ='';
                
                Integer count = 0;   
                for(Object mockTest:mockTestList)
                {
                    Map<String, Object> mockInfoMap =  (Map<String, Object>)mockTest;
                    
                    mockTestResult= (String)mockInfoMap.get('RESULT'); 
                    
                    System.debug('mockTest='+mockTest);
                }
               /* if((mockTestResult!=''))
                {
                    etdipersondetail.Mock_Test_Result__c = mockTestResult;	                  
                    //   etdipersondetail.Instructor_Name__c = InstructorName;
                    update etdipersondetail;
                }*/
            }
            
        }      
        
    } 
    
     public static void getPermitStatus(Id AccountId,String Token,String UserId, String StudentId)
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
                permitStatus = (String)getpermitStatusResponse.get('Status');
              //  ETDI_Detail__c etdipersondetail = [Select id, Permit_Status__c from ETDI_Detail__c where id=:ETDIDetailID];
                                          
          /*      if((permitStatus!=''))
                {
                    etdipersondetail.Permit_Status__c = permitStatus;   	                  
                    //   etdipersondetail.Instructor_Name__c = InstructorName;
                    update etdipersondetail;
                }*/
            }
            
        }      
        
    }
    
}