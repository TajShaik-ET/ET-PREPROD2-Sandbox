/**
 * @description       : 
 * @author            : Srihari.Koyila@Smaartt.com-SK
 * @group             : 
 * @last modified on  : 08-07-2024
 * @last modified by  : Srihari.Koyila@Smaartt.com-SK
 * Modifications Log
 * Test Class         : ET_overTimeAutomationControllerTest
 * Ver   Date         Author                          Modification
 * 1.0   08-06-2024   Srihari.Koyila@Smaartt.com-SK   Initial Version
**/
public class ET_OverTimeAutoIntegration {
    
    
    @Future(callout=true)
    public static void getOverTimeData(string recordid){
        system.debug('recordid'+recordid);
        String resVal;
        OverTime_Sheets__c OT_Sheets = [SELECT Id, Name, OverTime_Uploader__c, Uploaded_Date__c
                                        FROM OverTime_Sheets__c
                                        WHERE id=: recordId];
        
        List<Overtime_Calculater__c> OT_Calc =[SELECT Id,Employee_No__c, Employee_Name__c,Time_In__c, Time_Out__c, Total_of_Hours__c, Contract_No__c, Cust_Name__c, Cost_Recovery__c, Location__c, Category__c, Activity__c, Total_Rate__c, Type__c,CreatedDate
                                         FROM Overtime_Calculater__c
                                         WHERE OverTime_Sheets__c = :OT_Sheets.Id ];
        system.debug('OT_Calc '+OT_Calc);
        List<OTWrapper> OTWrapperList = new List<OTWrapper>();
        // Populate the OTWrapper list with OT_Calc data
       
        for (Overtime_Calculater__c calc : OT_Calc) {
            OTWrapper wrapper = new OTWrapper();
             wrapper.emp_no = String.valueOf(calc.Employee_No__c); 
             wrapper.date_Z = '2024-06-09';  
             String checkinTimeStr = String.valueOf(calc.Time_In__c);
             wrapper.checkin = checkinTimeStr.substring(0, checkinTimeStr.length() - 6);
             String checkoutTimeStr = String.valueOf(calc.Time_Out__c);
             wrapper.checkout = checkoutTimeStr.substring(0, checkoutTimeStr.length() - 6);
             wrapper.work_hours = String.valueOf(calc.Total_of_Hours__c); 
             wrapper.month = '2024-06-30'; 
             String CreatedDate = String.valueOf(calc.CreatedDate);
             wrapper.created_by = CreatedDate.substring(0, CreatedDate.length() - 15);
             OTWrapperList.add(wrapper);
        }
        List<String> bodyList = new List<String>();
        for (OTWrapper wrapper : OTWrapperList) {
            String body = 
            '{"emp_no":"'+wrapper.emp_no+'",' +
            '"date":"'+wrapper.date_Z+'",' + 
            '"checkin":'+wrapper.checkin+',' +
            '"checkout":'+wrapper.checkout+',' +
            '"work_hours":'+wrapper.work_hours+',' +
            '"month":"'+wrapper.month+'",' +
            '"created_by":'+wrapper.created_by+'}';

            // Add the constructed body to the list
            bodyList.add(body);
        }
        String finalBody = '[' + String.join(bodyList, ',') + ']';
        System.debug('finalBody: ' + finalBody);

        // Enqueue the Queueable job to handle the callout
        System.enqueueJob(new MakeCalloutQueueable(recordId,finalBody));
        
    }

    public class MakeCalloutQueueable implements Queueable, Database.AllowsCallouts {
        private String recordId;
        private String finalBody;
        public MakeCalloutQueueable(String recordId, String finalBody) {
            this.recordId = recordId;
            this.finalBody = finalBody;
        }

        public void execute(QueueableContext context) {
            String resVal;
            ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('ET_OverTimePost');
            Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
            string paramvalue = EncodingUtil.base64Encode(beforeblob);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            if(ET_REST_Authorize_Helper.runningInASandbox()){
                request.setEndpoint(connection.Dev_Endpoint__c);
            }else{
                request.setEndpoint(connection.LiveEndpoint_c__c);
            }  
            request.setMethod('POST');
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(finalBody);      
            request.setHeader('Authorization','Basic '+paramvalue);   
            
            HttpResponse response = http.send(request);
            System.debug('response-' + JSON.serializePretty(response.getBody()));
    
            Map<String, Object> responseResult =new Map<String, Object>();
            OverTime_Sheets__c OT_SheetUpdate = new OverTime_Sheets__c(Id=recordId);
            Overtime_Calculater__c OT_Update = new Overtime_Calculater__c();
            if (response.getStatusCode() != 200) {
                System.debug('Failed ');
                OT_SheetUpdate.Integration_Message__c  ='Unable to send request to ERP';
                resVal ='Error';
                responseResult = null; 
                update OT_SheetUpdate;
            } else{
                if(response.getStatusCode() == 200){
                    System.debug('Sucess ');
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    responseResult =result;
                    system.debug('--res--'+responseResult);
                    if(string.valueOf(result.get('Status')) =='E'){
                        OT_SheetUpdate.Integration_Status__c = 'Error';
                        OT_SheetUpdate.Integration_Message__c = string.valueOf(result.get('Message'));
                        update OT_SheetUpdate;  
                        resVal ='Error';
                    }
                }
                
            }
            if(responseResult!=null) {
                String ResponseMessage =(String)responseResult.get('Message');
                String ResponseStatus =(String)responseResult.get('Status');
                System.debug('ResponseStatus='+ResponseStatus);
                System.debug('ResponseMessage='+ResponseMessage);
                if(ResponseStatus.contains('S')){
                    
                    OT_SheetUpdate.Integration_Status__c = ResponseStatus;
                    OT_SheetUpdate.Integration_Message__c = ResponseMessage;
                    
                    update OT_SheetUpdate;
                   
                    resVal ='Success';
                }
            }
        }
    }




    public class OTWrapper {
        public String emp_no { get; set; } 
        public String date_Z { get; set; } 
        public String checkin { get; set; } 
        public String checkout { get; set; } 
        public String work_hours { get; set; } 
        public String month { get; set; } 
        public String created_by { get; set; } 
    }
}