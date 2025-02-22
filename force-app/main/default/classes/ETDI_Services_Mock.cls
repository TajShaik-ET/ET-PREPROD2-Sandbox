@isTest
global class ETDI_Services_Mock implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest req) {
       
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
       System.debug('getendpotnis ='+req.getEndpoint());
        String endpoint = req.getEndpoint();
            if(endpoint.contains('/ETASWApi/api/WebApi/doGetAuthroizedTokenByMobile')){                
                  res.setBody('{"Success": "Ture","Message": "Authorized","Data": [{"Token": "7c9d2699be1aae035e07fc81b904e3a2b9f4bd4aa4b13c76a5ea0f88214b0307","TokenExpiry": "6/9/2021 9:46:21 AM","StudentId": "744","UserId": "etdi.demo","Language": "Arabic","Status": "1"}]}');
            }
       else if(endpoint.contains('/ETASWApi/api/WebAPI/doGetTheoryClassesSchedule')){                
                    res.setBody('{"Success": "true","Message": "Successfully Returned","Data": [{"SLOT_SCH_ID": 93028,"IMAGE": "../../assets/global/img/etdi_logo_.png","COURSE_COMPLETED": "","END_TIME": "09:30:00","ENABLE_COURSE": "","COURSE": "Attitude and Responsibilities of the Driver","COURSE_TITLE": "Lesson 1","TIME": "08:30:00","DATE": "01-01-2000","LOCATION": null,"ROOM": "Online","INSTRUCTOR_ID": null,"INSTRUCTOR_NAME": null,"STATUS": "Online","IMAGE1": "","COURSE_ID": 9,"TRAINING_ID": 1}]}');
            }
        else if(endpoint.contains('/ETASWApi/api/WebAPI/doGetPaymentHistory')){                
                    res.setBody('{"Success": "true","Message": "Successfully Returned","Data": [{"ID": 111,"AMOUNT": 1.00,"PAYMENT_CATEGORY_NAME": "installment amount","TRAN_DATE": "2019-02-21T14:10:11"}]}');
            }
        else if(endpoint.contains('/ETASWApi/api/WebAPI/DoGetScheduledExams')){                
                    res.setBody('{"Success": "true","Message": "Successfully Returned","Data": [{"CUSTOMER_SERVICE_EXAM_ID": 11111,"NAME_EN": "Final Road Test","EXAM_DATE": "2021-04-08T00:00:00","EXAM_CENTRE": "Dubai","EXAM_RESULT": "Fail","ID": 1111}]}');
            }
        else if(endpoint.contains('/ETASWApi/api/WebAPI/doGetProfileInformation')){                
                    res.setBody('{"Success": "true","Message": "Successfully Returned","Data": [{"CUSTOMER_ID": 24907,"TFN": "15067906","EID": "784198339744124","NATIONALITY": "Pakistan","DOB": "26/10/1983","IMAGE": "","LICENSE_TYPE": "LMV","REGISTERED_FOR": "","USER_ID": 12041,"PERSON_NAME_EN": "GHULAM ABBAS GHULAM  RASOOL","GENDER": "Male","STAGE_NAME": "Road Test","STAGE_ID": 5,"MOBILE": "971553926850","STATUS": "Road Test Scheduled","REGISTRATION_EXPIRY": "09/05/2021","VEHICLE_ID": 2}]}');
            }
        else if(endpoint.contains('/ETASWApi/api/WebAPI/doGetAssessmentScheduleChatBot')){                
                    res.setBody('{"Success": "true","Message": "Successfully Returned","Data": [{"CUST_CLASS_SCH_ID": 111,"SEQ_NUM": 1,"TRAINING_NAME": "Assessment","TIME": "10:00:00","DATE": "11-18-2020","INSTRUCTOR_NAME": "test","STATUS": "Attended"}]}');
            }
        else if(endpoint.contains('/ETASWApi/api/WebAPI/doGetPracticalScheduleChatBot')){                
                   res.setBody('{"Success": "true","Message": "Successfully Returned","Data": [{"CUST_CLASS_SCH_ID": 1111,"SEQ_NUM": 1,"TRAINING_NAME": "Practical 1","TIME": "11:30:00","DATE": "04-07-2021","INSTRUCTOR_NAME": "test","STATUS": "Attended"}]}');
            }
        else if(endpoint.contains('/ETASWApi/api/WebAPI/doGetPendingScheduleClasses')){                
                   res.setBody('{"Success": "true","Message": "Successfully Returned","Data": [{"CUST_CLASS_SCH_ID": 1111,"SEQ_NUM": 1,"TIME": "08:30:00", "DATE": "15/12/2020", "INSTRUCTOR_NAME": "Test","STATUS": "Pending"}]}');
            }
         else if(endpoint.contains('/ETASWApi/api/WebAPI/doGetExamTypes')){                
                   res.setBody('{"Success": "true","Message": "Successfully Returned","Data": [{"ID": 1,"NAME_EN": "Knowledge Test","NAME_AR": "اختبار المعرفة","DESCRIPTION": "Test","IS_ETDI_EXAM": false,"IS_RTA_EXAM": true,"IS_ACTIVE": true,"CREATED_ON": "2017-08-23T12:22:46.587","CREATED_BY": 1,"UPDATED_ON": null,"UPDATED_BY": null,"IS_ETTC": null,"NAME_UR": "Test","LANGUAGE_ID": 1,"PRIORITY": 1,"CTS_TESTTYPE_CODE": "THEORY_TEST","CTS_TESTTYPE_DESC": "Theory Test"}]}');
            }
       else if(endpoint.contains('/ETASWApi/api/WebAPI/GetSchedulingData')){
           
                    //String entervalue = '\n';
                   res.setBody('{"Success": false,"Message": "","Data": [{"TIME": "09:30","DATE": "02 May 2021,"}],"InstructorId": "1104"}');
            }
       else if(endpoint.contains('/ETASWApi/api/WebAPI/doGetPendingExams')){                
                   res.setBody('{"Success": "true","Message": "Successfully Returned","Data": [{"CUSTOMER_SERVICE_EXAM_ID": 1111,"EXAM_CODE": "Test","EXAM_DATE": "2020-12-15T00:00:00","SCHEDULE_DATE": "15/12/2020", "EXAM_CENTRE": "Dubai","EXAM_RESULT":null,"EXAM_ID": 4,"VEHICLE_TYPE": "LAV"}]}');
            }
        else if(endpoint.contains('/ETASWApi/api/WebAPI/doRequestRegisterChatBoot')){                
                   res.setBody('Your request has been submitted.');
            }     
        else if(endpoint.contains('/ETASWApi/api/WebAPI/BookClasses')){                
                   res.setBody('Class scheduled successfully');
            }
        else if(endpoint.contains('doGetAuthroizedTokenByTFN')){    
                  res.setBody('{"Success": "Ture","Message": "Authorized","Data": [{"Token": "7c9d2699be1aae035e07fc81b904e3a2b9f4bd4aa4b13c76a5ea0f88214b0307","TokenExpiry": "6/9/2021 9:46:21 AM","StudentId": "744","UserId": "etdi.demo","Language": "Arabic","Status": "1"}]}');
            
                 //  res.setBody('{"Success": false,"Message": "Not Authorized"}');
            }
        else if(endpoint.contains('/doGetMockTestResult')){                
                  res.setBody('{"Success": "true","Message": "Successfully Returned data","Data": [{"RESULT":"passed"}]}');
            }
       else if(endpoint.contains('/doGetPermitStatus')){                
                  res.setBody('{"Success": true,"Status": "Active"}');
            }
         else{
               res.setBody('{"example":"test"}'); 
            }
        
        res.setStatusCode(200);
        return res;
}
}