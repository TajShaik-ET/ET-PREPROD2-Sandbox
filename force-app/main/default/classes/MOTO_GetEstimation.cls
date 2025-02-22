/*  Developer Name : Srihari Koyila
*   Class purpose  : ERP integrstion for GET method to Get estimation details in Opportunity and save pdf.
* 
* */
public class MOTO_GetEstimation {
    
    public static String docValue{get;set;}
    public String bdata{get;set;}
    // constructor for vfpage as padf
    public MOTO_GetEstimation(ApexPages.StandardController Opportunity){
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('MOTO_GetServiceEstimation');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        String estimationNo = ApexPages.currentPage().getParameters().get('estimNo');
        try{
            Http httpProtocol = new Http();
            String result = Null;
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization','Basic '+paramvalue);   
            request.setMethod('GET');
            
            if(ET_REST_Authorize_Helper.runningInASandbox()){
                request.setEndpoint(connection.Dev_Endpoint__c+estimationNo);
                system.debug(connection.Dev_Endpoint__c);
            }else{
                request.setEndpoint(connection.LiveEndpoint_c__c+estimationNo);
            }  
            //1931859
            system.debug('request'+request);
            request.setTimeout(90000);
            request.setHeader('Content-Type', 'application/json');
            response = httpProtocol.send(request);
            system.debug('body--'+response.getBody());
            ET_MotoWrapperClass etw = ET_MotoWrapperClass.parse(response.getBody());
            List<WrapperPayment> lstWrap= new List<WrapperPayment>();
            for(ET_MotoWrapperClass.EstimationSQLOutput zone : etw.EstimationSQLOutput){
                WrapperPayment wp= new WrapperPayment();
                docValue=wp.document=zone.document;
                lstWrap.add(wp);
            }
            
        }catch(Exception e){               //throw all other exception message            
            throw new AuraHandledException(e.getMessage());} 
    }
    
    //save pdf here
    @AuraEnabled
    public static void GenerateQuoteDoc(string ServiceEtimationNo,string recordId){
        System.debug('ServiceEtimationNo>>>>>>>>' + ServiceEtimationNo);
        System.debug('recordId>>>>>>>>' + recordId);
        String pdfUrl;
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('MOTO_GetServiceEstimation');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        
        Http httpProtocol = new Http();
        String result = Null;
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization','Basic '+paramvalue); 
        request.setMethod('GET');
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c+ServiceEtimationNo);
            system.debug(connection.Dev_Endpoint__c);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c+ServiceEtimationNo);
        }  
        system.debug('request'+request);
        request.setTimeout(90000);
        request.setHeader('Content-Type', 'application/json');
        response = httpProtocol.send(request);
        system.debug(response.getBody());
        
        ET_MotoWrapperClass etw = ET_MotoWrapperClass.parse(response.getBody());
        List<WrapperPayment> lstWrap= new List<WrapperPayment>();
        for(ET_MotoWrapperClass.EstimationSQLOutput zone : etw.EstimationSQLOutput){
            WrapperPayment wp= new WrapperPayment();
            docValue=wp.document=zone.document;
            lstWrap.add(wp);
        }
        
        blob bdata = EncodingUtil.base64Decode(docValue);
        system.debug('bdata>>>>>>>>' + bdata);
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S'; 
        cv.PathOnClient = ServiceEtimationNo+'.pdf';
        cv.Origin = 'H';
        cv.Title = ServiceEtimationNo+'.pdf';
        cv.VersionData = bdata;
        insert cv;
        //get the ContentDocumentId
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        //Insert ContentDocumentLink
        ContentDocumentLink cdl = new ContentDocumentLink();
        //Add ContentDocumentId
        cdl.ContentDocumentId = conDocId;
        //salesforce record Id
        cdl.LinkedEntityId = recordId;
        //V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cdl.ShareType = 'V';
        //AllUsers, InternalUsers, SharedUsers
        insert cdl;
        
        Opportunity Oppnty = new Opportunity();
        Oppnty.id=recordId;
        Oppnty.Service_Estimate_No__c=ServiceEtimationNo;
        Update Oppnty;
        
        sendEstimateEmail(bdata, recordId);
        createShareableLink(recordId, cv.Id);
        //return pdfUrl;
        
    }
    
    Public class WrapperPayment{
        @AuraEnabled
        Public String document{get;set;}  
    }
    //
    @AuraEnabled
    public static String getserviceEstimateNo(String recordId) {
        String serviceEstimateNo;
        // Query the record to get the Service_Estimate_No__c field valu
        // Replace this with your actual query logic
        Opportunity opp = [SELECT Service_Estimate_No__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
        
        if (opp != null) {
            serviceEstimateNo = opp.Service_Estimate_No__c;
        } else {
            // Handle the case where no record is found for the given recordId
            serviceEstimateNo = 'Record not found';
        }
        
        return serviceEstimateNo;
    }
    
    public static void sendEstimateEmail(blob doc, String recordId)
    {
     	List<Opportunity> opp = [Select id, Name, Service_Estimate_No__c, Account.Name , Account.PersonEmail   from Opportunity where id =:recordId Limit 1];   
        String fName =  opp[0].Name; //.substringBefore(' ');
        
        // Create and send email using Messaging.SingleEmailMessage class
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{opp[0].Account.PersonEmail});
        email.setSubject('Estimation PDF');
        email.setHtmlBody('Dear ' +fName+',<br/><br/>We have inspected your vehicle, please find your updated service estimate attached for your review and approval. If you have any questions or need to make amendments, please contact your service advisor.<br/><br/>Thank you,<br/><br/>Emirates Moto Service Center Team');
        
        // Attach PDF to email
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName(opp[0].Service_Estimate_No__c + '.pdf');
        attachment.setContentType('application/pdf');
        attachment.setBody(doc);
        email.setFileAttachments(new List<Messaging.EmailFileAttachment>{attachment});
        // Send email
        Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        
        // Debugging for email sending results
        System.debug('Email sending results: ' + sendResults);
        
        
    }
    
    public static void createShareableLink(Id opportunityId, Id documentId) {
        String pdfLink;
        String accName;
        String accPhone;
        // Create a ContentDistribution record
        ContentDistribution distribution = new ContentDistribution();
        distribution.ContentVersionId = documentId;
        distribution.Name = 'Share Link for Opportunity ' + opportunityId;
        distribution.RelatedRecordId = opportunityId;
        distribution.PreferencesAllowOriginalDownload = false; // Set to true if you want to allow download

        // Insert the ContentDistribution record
        insert distribution;

        // Retrieve the public link
        distribution = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id = :distribution.Id LIMIT 1];
		pdfLink = distribution.DistributionPublicUrl;
        
        // Print or use the public link as needed
        System.debug('Shareable Link: ' + pdfLink);
        //return pdfLink;
        /*List<Opportunity> opp = [Select Id, Name, Account.Name, Account.PersonMobilePhone from Opportunity where id =: opportunityId Limit 1];
        accName = opp[0].Account.Name;
        accPhone = opp[0].Account.PersonMobilePhone;*/
        
		//shortUrl(pdfLink, opportunityId);
		sendSMStoCustomer(new List<Id>{opportunityId},pdfLink);    
    }
    /*@AuraEnabled
    public static void shortUrl(String url, String oppId){
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://cutt.ly/api/api.php?key='+system.label.Moto_Cutly_Key+'&short='+url+'&userDomain=1%22');
        request.setMethod('GET');
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug(response);
		 system.debug('Body>>>>>>>>> '+response.getBody());
        Map<String,Object> responseData  = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
		System.debug('responseData>>>>>'+ responseData);
       	System.debug('responseData>>>>>'+ responseData.get('url'));
		Map<String,Object> resUrl = (Map<String,Object>) responseData.get('url');
			System.debug('resUrl>>>>>'+ resUrl);
			String Shorturl = (String) resUrl.get('shortLink');
			System.debug('title>>>>>'+ Shorturl);
			//String Composedmsg = 'Dear '+ accName +', We have inspected your vehicle, please find your updated service estimate here: '+Shorturl;
			//System.debug('Composedmsg>>>>>'+ Composedmsg);
			sendSMStoCustomer(new List<Id>{oppId},url);    
}*/
    public static void sendSMStoCustomer(list<Id> smsRelRecIds, String Url){
        system.debug('IN sendSMStoCustomer>>>>>');
        for(Opportunity opp : [Select id,Name, Account.PersonMobilePhone from Opportunity where Id=:smsRelRecIds Limit 1]){
             string composedMsg ='';
            	composedMsg = 'Dear '+opp.Name+', We have inspected your vehicle, please find your updated service estimate here '+ system.label.MOTO_Short_URL;
            
            
            if(opp.Account.PersonMobilePhone != null && opp.Account.PersonMobilePhone.length() >= 9){
                system.debug('SMSAPI');
                //Moto_SendSMS_LeadAppointmentCreation.sendSMSAPI(le.Account.PersonMobilePhone,composedMsg,system.label.Moto_SMS_SenderID);
                //sendSMSAPI(le.Account.PersonMobilePhone,composedMsg,system.label.Moto_SMS_SenderID);
				sendSMSAPI(opp.Account.PersonMobilePhone,composedMsg,system.label.Moto_SMS_SenderID, Url);
            }            
        }
        
    }
    
    @future(callout = true)
    public static void sendSMSAPI(String mobNumber,String msg,String SenderId, String Url){
        
        string mobile = '';
        string finalmsg = msg.replace(' ','%20');   
        
		//Check Mobile Number Format
        mobile = mobNumber.replaceAll('[A-Za-z]', '');//remove any alphabets
        mobile = '971'+mobNumber.right(9);//It works for UAE Country only
        
        HttpRequest request = new HttpRequest();
        //request.setEndpoint(system.label.Moto_SMS_EndpointURL+'senderid='+SenderId+'&mobileno='+mobile+'&msgtext='+finalmsg+'&priority=High&CountryCode=ALL');
        request.setEndpoint(system.label.MOTO_Short_SMS_API+'&shorturl='+system.label.MOTO_Short_URL+ '&ShowStatus=Y&senderid='+SenderId+'&CountryCode=+971&mobileno='+mobile+'&msgtext='+finalmsg+'&shredirecturl='+Url);
		request.setMethod('GET');
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug(response);
        
    }
    
    
    
}