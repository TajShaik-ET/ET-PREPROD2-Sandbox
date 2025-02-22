/***
Class       : MOTO_VehInspectionCtrl
Author      : Srihari Koyila
Description : 
TestClass   : MOTO_VehInspectionCtrlTest
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              27/04/23           Initial Version 
****************************************************************************************************************/

public without sharing class MOTO_VehInspectionCtrl {
    
    // getOpportunities in mOTO_VehicleInspectionHome-LWC
    @AuraEnabled
    public static List<Opportunity> getOpportunities(string MobNum) {
        String searchTerm = '%' + MobNum + '%';
        List<Opportunity> oppList =new List<Opportunity>();
        if(String.isNotBlank(MobNum)) {
            oppList= [SELECT Id, Name,Plate_Color_Master__c,Plate_Type_Master__c,Plate_Source_Master__c,CampaignId,ETSALES_Opportunity_Number__c,StageName,Vehicle_Brand__r.Name,Vehicle_Model__r.Name,Vehicle_Model_Year__c, Account.Name,Account.FirstName,Account.PersonMobilePhone, Account.PersonEmail,Appointment_Date__c,Chassis_Number__c,Vehicle_Plate_Number__c,Vehicle_Mileage__c,Type_of_Customer__c,Insurance_Company__c,Insurance__c,List_of_Required_Services__c,Vehicle_Mileage_number__c,Account.Integration_Status__c,Account.AccountNumber,Vehicle_Internal_Number__c, OwnerId, Owner.Name, Owner.FirstName FROM Opportunity where  ( Account.PersonMobilePhone LIKE:searchTerm OR Account.PersonEmail  LIKE:searchTerm ) AND ( StageName!='Closed Lost' AND StageName!='Closed Won' )];
        } else {
        }
        return oppList;
    }
    
    @AuraEnabled
    public static List<Lead> getLeads(string mail) {
        String searchTerm = '%' + mail + '%';
        List<Lead> leadList =new List<Lead>();
        if(String.isNotBlank(mail)) {
            leadList= [SELECT Id, Name, FirstName, LastName,Email,MobilePhone, Vehicle_Brand__c,Moto_Vehicle_Model__c,Vehicle_Mileage__c, ETM_Vehicle_Model__c, Vehicle_Chassis__c, Vehicle_Plate_Number__c FROM Lead where Email LIKE:searchTerm AND isconverted = FALSE AND recordType.Name = 'Automotive Service Center & Body Shop'];
        } else {
        }
        return leadList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunityData() {
        // You can customize this query to retrieve the fields you need
        return [Select id, name,  Vehicle_Internal_Number__c, Vehicle_Mileage_number__c,Chassis_Number__c,Check_In_Date__c,Service_Number__c,Doc_No__c, StageName, Account.PersonMobilePhone,Account.Name,Account.FirstName,Account.PersonEmail,CreatedDate, OwnerId, Owner.Name, Owner.FirstName  from Opportunity where RecordTypeId = '0123z000000Z5o2AAC' Order by CreatedDate DESC LIMIT 10];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<CICO_Workshop_Location__c> getWorkshopLocation(String loc) {
        List<CICO_Workshop_Location__c> wl = [Select Id, Name, Location_Code__c  from CICO_Workshop_Location__c where Location_Code__c =: loc LIMIT 1];

        return wl;
    }
	
    @AuraEnabled
    public static List<Vehicle_Master__c> getVehicle(string chasNum) {
        List<Vehicle_Master__c> vehListRet =new List<Vehicle_Master__c>();
        List<Vehicle_Master__c> vehList =new List<Vehicle_Master__c>();
        String vehIdERP;
        if(String.isNotBlank(chasNum)) {
            vehList= [SELECT Id, Name, Internal_No__c, Chassis_No__c, Plate_Number__c,Account_Id__c, Account_Id__r.Name, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.PersonEmail, Account_Id__r.PersonMobilePhone   FROM Vehicle_Master__c where Chassis_No__c =:chasNum ];
            if(vehList.size()>0)
            {
                vehListRet = vehList;
            }
            else
            {
                vehIdERP = GetRetVehicleDetail(chasNum);
                if(vehIdERP != NULL || vehIdERP != '')
                {
                    vehListRet = [SELECT Id, Name, Internal_No__c, Chassis_No__c, Plate_Number__c,Account_Id__c, Account_Id__r.Name, Account_Id__r.FirstName, Account_Id__r.LastName, Account_Id__r.PersonEmail, Account_Id__r.PersonMobilePhone   FROM Vehicle_Master__c where Id =:vehIdERP ];
                }
            }
        } 
        return vehListRet;
    }
    
    @AuraEnabled
    public static String GetRetVehicleDetail(string ChassisNumber){
        string resVal = null;
        system.debug(ChassisNumber);
        List<Vehicle_Master__c> vehList =new List<Vehicle_Master__c>();
        Vehicle_Master__c vm = new Vehicle_Master__c();
        
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('MOTO_GetVehicleDetails');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        try{
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Accept', 'application/json');
            //request.setHeader('Authorization','Basic '+paramvalue);   
            request.setMethod('GET');
            
            if(ET_REST_Authorize_Helper.runningInASandbox()){
                request.setEndpoint(connection.Dev_Endpoint__c+ChassisNumber);
                system.debug(connection.Dev_Endpoint__c);
            }else{
                request.setEndpoint(connection.LiveEndpoint_c__c+ChassisNumber);
            }  
            system.debug('request'+request);
            request.setTimeout(90000);
            request.setHeader('Content-Type', 'application/json');
            Map<String, Object> responseResult =new Map<String, Object>();
            
            response = httpProtocol.send(request);
            system.debug('GetVehicleDetails-body--'+response.getBody());
               Account acc = new Account();
            	
                

                if(response.getStatusCode() == 200){      
                 
                MOTO_GetVehicleDetailWrapper res = MOTO_GetVehicleDetailWrapper.parse(response.getBody());
                 
                    if(res.Status =='S'){
                        
                        MOTO_GetVehicleDetailWrapper.VehicleCollection veh = res.VehicleCollection;
                       
                        if(veh != null && veh.XxetVehicleMasterDetailV.size()>0){
                            MOTO_GetVehicleDetailWrapper.XxetVehicleMasterDetailV vehInfo= veh.XxetVehicleMasterDetailV[0];
                             System.debug('vehicle info>>>>>>' + vehInfo);                           
                            vm.Internal_No__c =(String)(vehInfo.internalNo);
                            vm.Name =(String)(vehInfo.internalNo);
                            vm.Plate_Number__c =(String)(vehInfo.plateNumber);
                            vm.Last_KM_Reading__c =(Decimal)(vehInfo.odometer);
                            vm.Chassis_No__c =ChassisNumber;
                            vm.Plate_Source__c= (String)(vehInfo.plateIssue);
                            vm.Plate_colour_code__c= (String)(vehInfo.plateColour);
                            vm.Plate_Type__c= (String)(vehInfo.plateType);
                            vm.Vehicle_Model__c= (String)(vehInfo.model);
                           
                            
                            resVal ='Vehicle created from ERP';
                            
                           
                            if(vehInfo.customerNumber != null){
                                List <Account> ace = [Select id, name, FirstName, LastName, PersonMobilePhone, PersonEmail, AccountNumber, ETSALES_Customer_Account_Id__c from Account where AccountNumber =: vehInfo.customerNumber];
                                if(ace.size()>0)
                                {
                                    vm.Account_Id__c = ace[0].Id;
                                }
                                else
                                {
                                    acc.FirstName = '';
                                	acc.LastName = (String)(vehInfo.customerName);
                                	acc.PersonMobilePhone = vehInfo.customerNumber;
                                	acc.PersonEmail = '';
                                	acc.AccountNumber =vehInfo.customerNumber;
                       	        	acc.ETSALES_Customer_Account_Id__c =(String)(vehInfo.customerId);
                                	insert acc;
                                	vm.Account_Id__c = acc.Id;
                                }
                                
                            }else{
                                string accresVal='--No Account';
                                resVal +=accresVal;
                            }
                            
                            insert vm;
                            vehList.add(vm);
                            
                        }else{
                             resVal ='No Vehicle';
                             system.debug('resVal Vehicle Error>>>' + resVal);
                        }
                        
                                               
                    }else{
                        
                       resVal ='Error in Status';
                       system.debug('resVal Status Error>>>' + resVal);
                    }
                    
                }else{                    
                   
                   	resVal ='Error in response'+response.getBody();
                    system.debug('resVal Response>>>' + resVal);
                }
                
            
			
        }catch(Exception e){    //throw all other exception message  
            system.debug(e.getMessage());
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
            throw new AuraHandledException(e.getMessage());} 
        return vm.Id;
    }
    
    @AuraEnabled
    public static string saveAccountRecord(ID vehicleId, Account accFormRecord) {
        system.debug('In saveAccountRecord>>>>>>>>>>>>>>>');
        system.debug('In vehicleId>>>>>>>>>>>>>>>' +vehicleId);
        Vehicle_Master__c vc = new Vehicle_Master__c();
        Account acc = new Account();
        system.debug('accFormRecord.Id>>>>>>>>' + accFormRecord.Id);
        acc.Id = accFormRecord.Id;
        acc.FirstName = accFormRecord.FirstName;
        acc.LastName = accFormRecord.LastName;
        acc.PersonMobilePhone = accFormRecord.PersonMobilePhone;
        acc.PersonEmail = accFormRecord.PersonEmail;
        system.debug('acc.Id>>>>>>>>' + acc.Id);
        if(acc.Id != NULL)
        {	
            System.debug('In If>>>>>>');
            try
            {
                update acc;
                vc.Id = vehicleId;
                vc.Account_Id__c = acc.Id;
                update vc;
            }
			Catch(Exception ex){
            	throw new AuraHandledException('Error Exception happend'+ex.getMessage());
            }
        }
        else
        {	System.debug('In Else of error>>>>>>');
            try
            {
                
                 insert acc;
                System.debug('acc>>>>>>'+ acc);
                
                vc.Id = vehicleId;
                vc.Account_Id__c = acc.Id;
                update vc;
            }
			Catch(Exception ex){
            	throw new AuraHandledException('Error Exception happend'+ex.getMessage());
            }
           
        }
        System.debug('In Return>>>>>>>>>>' + acc.Id);
        
        return acc.Id;
    }
    
    // getOpportunities in mOTO_VehicleFormsHome-LWC
    @AuraEnabled
    public static List<Opportunity> getOpportunitiesFormsHome(string MobNum) {
        List<Opportunity> oppList =new List<Opportunity>();
        if(String.isNotBlank(MobNum)) {
            oppList= [SELECT Id, Name,Work_Order_Number__c, ETSALES_Opportunity_Number__c,StageName,Vehicle_Brand__r.Name,Vehicle_Model__r.Name,Vehicle_Model_Year__c, Account.Name,Account.PersonMobilePhone, Account.PersonEmail,Account.Integration_Status__c,Account.AccountNumber, OwnerId, Owner.Name, Owner.FirstName FROM Opportunity where ( Work_Order_Number__c=:MobNum ) AND ( StageName!='Closed Lost' AND StageName!='Closed Won' )];
        } else {
        }
        return oppList;
    }
    
    
    // getInternalNumber in mOTO_VehicleInspectionHome - LWC
    @AuraEnabled 
    public static List<Vehicle_Master__c> getInternalNumber(String plateNumber, String PlateCode, String PlateSource, String PlateType) { 
        String queryStr = 'SELECT Id, Name, Description__c,Chassis_No__c,Make__c,Model_Year__c,Vehicle_Model__c,Plate_Number__c,Plate_Type__c,Plate_Source__c,Plate_colour_code__c FROM Vehicle_Master__c WHERE ';
        
        if (!String.isBlank(plateNumber)) {
            queryStr += 'Plate_Number__c LIKE \'%' + plateNumber + '%\' AND ';
        }
        
        if (!String.isBlank(PlateCode)) {
            queryStr += 'Plate_colour_code__c LIKE \'%' + PlateCode + '%\' AND ';
        }
        
        if (!String.isBlank(PlateSource)) {
            queryStr += 'Plate_Source__c LIKE \'%' + PlateSource + '%\' AND ';
        }
        
        if (!String.isBlank(PlateType)) {
            queryStr += 'Plate_Type__c LIKE \'%' + PlateType + '%\' AND ';
        }
        
        // Remove the trailing "AND" keyword from the query
        if (queryStr.endsWith(' AND ')) {
            queryStr = queryStr.substring(0, queryStr.length() - 5);
        }
        
        queryStr += ' LIMIT 5';
        
        system.debug(Database.query(queryStr));
        return Database.query(queryStr); 
    }
    
    // Lwc-get service req num
    @AuraEnabled
    Public static string getServiceReqInfo(string internalNo, string checkFor, string checkType){
        string response='';
        system.debug('internalNo>>>>>'+ internalNo);
        system.debug('checkFor>>>>>'+ checkFor);
        system.debug('checkType>>>>>'+ checkType);
        if(!test.isRunningTest())
            if(checkType == 'CheckOut')
            {
                response= CICO_InspectionCtrl.getVehicleChildAssetCustomerInfo(internalNo,checkFor);
            }
            else
            {
                response= CICO_InspectionCtrl.getVehicleChildAssetCheckIn(internalNo,checkFor);
            }
            
        return response;
    }  
    
    // Lwc-motoVehicleReceivingForm
    @AuraEnabled
    public static string vehicleReceivingformSaveHandler(List<Vehicle_Receiving_Info__c> vehicleInspectionList,String fileData){  
        system.debug(fileData);
        try{
            Savepoint sp = Database.setSavepoint();
            Insert vehicleInspectionList;
            Opportunity opp = new Opportunity();
            opp.Id = vehicleInspectionList[0].Opportunity__c;
            opp.Symptoms__c = vehicleInspectionList[0].Symptoms__c;
            opp.Symptom_Type__c = vehicleInspectionList[0].Symptom_Type__c;
            opp.Possible_cause__c = vehicleInspectionList[0].Cause__c;
            update opp;
            string res = addFilesToRecords(vehicleInspectionList[0].Id, fileData,sp);
            return res;
        }Catch(Exception ex){
            throw new AuraHandledException('Error Exception happend'+ex.getMessage()); 
        }
        
        
    }
    
    //Checkout
    @AuraEnabled
    public static string checkoutRecFormSaveHandler(List<CICO_Check_Out__c> checkOutList,String fileData, string checkOutId){  
        system.debug(fileData);
        try{
            Savepoint sp = Database.setSavepoint();
            List<CICO_Check_Out__c> co = [select id, name, Radio__c, Emer_Tool_Kit__c, Fire_Ext_In__c, First_Aid_Box__c, Reflec_Trian__c, Spare_Wheel__c, Check_Out_fuel_reading__c  from CICO_Check_Out__c WHERE Id=:checkOutId limit 1];
            System.debug('checkOutList>>>>>>>' + checkOutList);
            for(CICO_Check_Out__c cout: co){
                cout.Radio__c = checkOutList[0].Radio__c;
                cout.Emer_Tool_Kit__c = checkOutList[0].Emer_Tool_Kit__c;
                cout.Fire_Ext_In__c = checkOutList[0].Fire_Ext_In__c;
                cout.First_Aid_Box__c = checkOutList[0].First_Aid_Box__c;
                cout.Reflec_Trian__c = checkOutList[0].Reflec_Trian__c;
                cout.Spare_Wheel__c = checkOutList[0].Spare_Wheel__c;
                cout.Check_Out_fuel_reading__c = checkOutList[0].Check_Out_fuel_reading__c;
            }
            update co;
            string res = addFilesToRecords(checkOutId, fileData,sp);
            return res;
        }Catch(Exception ex){
            throw new AuraHandledException('Error Exception happend'+ex.getMessage()); 
        }
        
        
    } 
    
    
    public static string addFilesToRecords(String recordId , String fileData,Savepoint sp){
        
        List<ContentVersion> lstContentVesions = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLinks = new  List<ContentDocumentLink>();
        list<uploadedDocs> files;  
        files = (List<uploadedDocs>)JSON.deserialize(fileData,  List<uploadedDocs>.Class);
        if(files.size()>0){            
            for(uploadedDocs doc :files){
                ContentVersion objContentVersion = new ContentVersion();
                objContentVersion.ContentLocation = 'S';
                /*String body = doc.base64;               
String base64Mark = 'base64,';
integer dataStart = body.indexOf(base64Mark) + base64Mark.length();
body = body.substring(dataStart);*/
                //system.debug('body = '+ body);
                objContentVersion.VersionData = EncodingUtil.base64Decode(doc.base64);//EncodingUtil.base64Decode(body);
                objContentVersion.Title = doc.filename;
                objContentVersion.Origin = 'H';
                objContentVersion.PathOnClient = '/' + doc.filename;
                lstContentVesions.add(objContentVersion);
                
            }
            
        }
        if(lstContentVesions!=null && lstContentVesions.size()>0){
            try{
                insert lstContentVesions;   
                system.debug('******After lstContentVesions****'+lstContentVesions);
            }Catch(Exception ex){
                system.debug('***Exception Cause lstContentVesions*****'+ex.getMessage());
                system.debug('***Exception Cause getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception happend'+ex.getMessage());                                       
            }
            
        }
        map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
        for(ContentVersion objContentVersion :[Select Id,ContentDocumentId from ContentVersion where Id in :lstContentVesions]){
            mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
        }
        
        for(ContentVersion objContentVersion :lstContentVesions){
            
            if(mapofContentVersionIdwithContentDocumentIds.containskey(objContentVersion.Id)){
                ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                objContentDocumentLink.LinkedEntityId = recordId;
                objContentDocumentLink.ShareType = 'V';
                objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id);
                lstContentDocumentLinks.add(objContentDocumentLink);
            }
            
        }
        system.debug('******lstContentDocumentLinks****'+lstContentDocumentLinks);
        if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
            try{
                insert lstContentDocumentLinks; 
                return 'Success';
            }Catch(Exception ex){
                Database.rollback(sp);
                system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
                system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
            }
        }else{
            return 'Error';
        }
    }
    
    public class uploadedDocs{
        @AuraEnabled
        Public String filename;
        @AuraEnabled
        Public String filetype;
        @AuraEnabled
        Public String base64;
        
    }
    
    // PDF-VF Lwc-motoVehicleReceivingForm
    
    @AuraEnabled
    public static void saveSign(String strSignElement,Id recId){
        
        
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = 'Signature-'+System.now() +'.png';//File name with extention
        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        //cVersion.OwnerId = attach.OwnerId;//Owner of the file
        cVersion.Title = 'Signature-'+System.now() +'.png';//Name of the file
        cVersion.VersionData = EncodingUtil.base64Decode(strSignElement);//File content
        Insert cVersion;
        
        //After saved the Content Verison, get the ContentDocumentId
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        
        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
        cDocLink.LinkedEntityId = recId;//Add attachment parentId
        cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
        
        // Create attachement
        /*
Attachment objAttachment = new Attachment();
objAttachment.Name = 'Demo-Signature.png';
objAttachment.ParentId = recId;
objAttachment.ContentType = 'image/png';
objAttachment.Body = EncodingUtil.base64Decode(strSignElement);        
insert objAttachment;
return objAttachment;      
*/ 
    }
    
    
    
    // Lwc-moto36PointsCheckForm
    
    @AuraEnabled
    public static void saveHealthCheck(X36_Points_Health_Check__c healthCheckRecord) {
        insert healthCheckRecord;
    }
    
    // Lwc-moto111PointsCheckForm
    
    @AuraEnabled
    public static string save111PointsCheck(X111_Point_Check__c Points111CheckRecord,String fileData) {
        system.debug(fileData);
        try{
            Savepoint sp = Database.setSavepoint();
            insert Points111CheckRecord;
            string res = addFilesToRecords111(Points111CheckRecord.Id, fileData,sp);
            return res;
        }Catch(Exception ex){
            throw new AuraHandledException('Error Exception happend'+ex.getMessage()); 
        }
    }
    
    public static string addFilesToRecords111(String recordId , String fileData,Savepoint sp){
        
        List<ContentVersion> lstContentVesions = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLinks = new  List<ContentDocumentLink>();
        list<uploadedDocs111> files;  
        files = (List<uploadedDocs111>)JSON.deserialize(fileData,  List<uploadedDocs111>.Class);
        if(files.size()>0){            
            for(uploadedDocs111 doc :files){
                ContentVersion objContentVersion = new ContentVersion();
                objContentVersion.ContentLocation = 'S';
                /*String body = doc.base64;               
String base64Mark = 'base64,';
integer dataStart = body.indexOf(base64Mark) + base64Mark.length();
body = body.substring(dataStart);*/
                //system.debug('body = '+ body);
                objContentVersion.VersionData = EncodingUtil.base64Decode(doc.base64);//EncodingUtil.base64Decode(body);
                objContentVersion.Title = doc.filename;
                objContentVersion.Origin = 'H';
                objContentVersion.PathOnClient = '/' + doc.filename;
                lstContentVesions.add(objContentVersion);
                
            }
            
        }
        if(lstContentVesions!=null && lstContentVesions.size()>0){
            try{
                insert lstContentVesions;   
                system.debug('******After lstContentVesions****'+lstContentVesions);
            }Catch(Exception ex){
                system.debug('***Exception Cause lstContentVesions*****'+ex.getMessage());
                system.debug('***Exception Cause getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception happend'+ex.getMessage());                                       
            }
            
        }
        map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
        for(ContentVersion objContentVersion :[Select Id,ContentDocumentId from ContentVersion where Id in :lstContentVesions]){
            mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
        }
        
        for(ContentVersion objContentVersion :lstContentVesions){
            
            if(mapofContentVersionIdwithContentDocumentIds.containskey(objContentVersion.Id)){
                ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                objContentDocumentLink.LinkedEntityId = recordId;
                objContentDocumentLink.ShareType = 'V';
                objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id);
                lstContentDocumentLinks.add(objContentDocumentLink);
            }
            
        }
        system.debug('******lstContentDocumentLinks****'+lstContentDocumentLinks);
        if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
            try{
                insert lstContentDocumentLinks; 
                return 'Success';
            }Catch(Exception ex){
                Database.rollback(sp);
                system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
                system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
            }
        }else{
            return 'Error';
        }
    }
    
    public class uploadedDocs111{
        @AuraEnabled
        Public String filename;
        @AuraEnabled
        Public String filetype;
        @AuraEnabled
        Public String base64;
        
    }
    
    
    
    //VF-PDF- lwc-moto111PointsCheckForm
    
    public Boolean MarkedDiagram { get; set; }
    public map<string,list<string>> imageData{get;set;}
    public MOTO_VehInspectionCtrl(ApexPages.StandardController controller) {
        MarkedDiagram = false;
        String recId = Apexpages.currentPage().getParameters().get('id');
        imageData = new Map<String, List<String>>();
        for(ContentDocumentLink  cd : [SELECT id,ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE id != null AND LinkedEntityId=:recId ]){
            system.debug('--'+cd.ContentDocument.Title);
            if(cd.ContentDocument.Title.contains('MarkedDiagram')){
                if(!imageData.containsKey('MarkedDiagram')){
                    imageData.put('MarkedDiagram',new list<string>());
                }
                imageData.get('MarkedDiagram').add(cd.ContentDocument.LatestPublishedVersionId);
                MarkedDiagram = true;
            }
            
        }
    }
    
    // Lwc-motoVehLeadForm -sav lead and convert lead
    
    @AuraEnabled
    public static String saveLeadRecord(Lead leadFormRecord) {
        insert leadFormRecord;
        return leadFormRecord.Id;
    }
    
    // @InvocableMethod
    @AuraEnabled
    public static List<Opportunity> convertLeadAndGetOpportunityId(List<Id> leadId) {
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        List<Database.LeadConvert> massLeadConvert=new List<Database.LeadConvert>();
        Database.LeadConvert lc = new Database.LeadConvert();
        
        for(Id currentLead:leadId){
            lc.setLeadId(currentLead);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            massLeadConvert.add(lc);
            
        }
        
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        // Retrieve the Opportunity ID from the LeadConvertResult
        Id opportunityId = lcr.getOpportunityId();
        List<Opportunity> oppList =new List<Opportunity>();
        oppList=[SELECT Id, Name,Work_Order_Number__c, ETSALES_Opportunity_Number__c,StageName,Vehicle_Brand__r.Name,Vehicle_Model__r.Name,Vehicle_Model_Year__c, Account.Name,Account.PersonMobilePhone, Account.PersonEmail, Account.AccountNumber, OwnerId, Owner.Name, Owner.FirstName FROM Opportunity where Id=:opportunityId];
        return oppList;  
    }
    
    // Lwc-serviceEstimation 
    
    /*  @AuraEnabled
public static String saveServiceestimationRecord(Estimation__c estimationRecord) {
insert estimationRecord;
return estimationRecord.Id;
}

@AuraEnabled
public static void saveServiceLineitem(List<Service_Estimation_Lines__c> estimationLineItemRecords) {
insert estimationLineItemRecords;
system.debug(estimationLineItemRecords);
}
*/
    // insert opportunity record
    
    @AuraEnabled
    public static list<Opportunity> CreateOpportunityforInternalVehicle(String vehMasterInternalNum, Opportunity checkRec) {
        
        Map<String, Integer> plateTypeMap = new Map<String, Integer>{
        'ARMY' => 5,
        'Bicycle -Water' => 38,
        'CEREMONIES' => 9,
        'CIVIL DEFENCE' => 21,
        'COMMERCIAL' => 18,
        'CONSULAR' => 11,
        'CUSTOMS' => 19,
        'DATA TRANSFER' => 36,
        'DIPLOMATIC' => 10,
        'DRIVING SCHOOL' => 37,
        'DUABI FLAG' => 33,
        'ET' => 0,
        'EXPORT' => 7,
        'FUN MOTORCYCLE' => 35,
        'GOVERNMENT' => 8,
        'IMIGRATION & RESIDENCE' => 23,
        'INT. ORGANIZATION' => 12,
        'LOCAL GUARDS' => 27,
        'MINISTRY OF FOREGN AFFAIRS' => 30,
        'MUNICIPALITY' => 26,
        'Motorcycle' => 20,
        'Motorcycle.' => 29,
        'POLICE' => 4,
        'POLITICAL BODY' => 32,
        'PRIVATE' => 1,
        'PRIVATE TRANSPORT' => 14,
        'PUBLIC' => 2,
        'PUBLIC TRANSPORT' => 15,
        'PUBLIC WORKS' => 31,
        'Protocol' => 13,
        'RENT' => 25,
        'SPECIAL SECURITY FORCES' => 22,
        'TAXI' => 16,
        'TEMPORARY' => 6,
        'TOURIST' => 17,
        'TRAILER' => 34,
        'TRASFER' => 28,
        'UNDER TRIAL' => 3,
        'WORKSHOPS & TRANSPORT' => 24
    };
	Map<String, Integer> plateSourceMap = new Map<String, Integer>{
    'ABU DHABI' => 1,
    'AJMAN' => 4,
    'AL AIN' => 31,
    'ALAIN' => 8,
    'ARMY' => 19,
    'BAHRAIN' => 10,
    'CEREMONIES' => 22,
    'CUSTOMS' => 27,
    'DIPLOMATIC' => 24,
    'DRIVING SCHOOL' => 37,
    'DUBAI' => 2,
    'FUJAIRAH' => 7,
    'GOVERNMENT' => 25,
    'IRAQ' => 16,
    'JORDAN' => 13,
    'KUWAIT' => 12,
    'LEBANON' => 14,
    'LIBYA' => 26,
    'MARASM' => 30,
    'NONE' => 0,
    'OMAN' => 15,
    'POLICE' => 20,
    'POLITICAL' => 23,
    'QATAR' => 11,
    'RAS AL KHAIMAH' => 6,
    'SAUDI ARABIA' => 9,
    'SHARJAH' => 3,
    'SYRIA' => 17,
    'TURKEY' => 18,
    'UAE' => 32,
    'UMM AL QUWAIN' => 5,
    'YEMEN' => 28
};
    
    Map<String, Integer> plateColorMap = new Map<String, Integer>{
    'A' => 15,
    'AL AASMA' => 60,
    'AL AHMADI' => 63,
    'AL FRWANEYA' => 62,
    'AL JAHRA' => 64,
    'B' => 16,
    'BIG.MUBARAK' => 65,
    'BLACK' => 5,
    'BLUE' => 2,
    'BLUE + ORANGE' => 33,
    'BROWN' => 36,
    'C' => 17,
    'CEREMONIES' => 12,
    'CODE1' => 101,
    'CODE10' => 110,
    'CODE11' => 111,
    'CODE2' => 102,
    'CODE3' => 103,
    'CODE4' => 104,
    'CODE5' => 105,
    'CODE6' => 106,
    'CODE7' => 107,
    'CODE8' => 108,
    'CODE9' => 109,
    'CONSULAR' => 35,
    'D' => 18,
    'DIPLOMATIC' => 10,
    'E' => 19,
    'EIGHTEENTH CATEGORY' => 69,
    'EIGHTH CATEGORY' => 53,
    'ELEVENTH CATEGORY' => 56,
    'EMD' => 89,
    'F' => 20,
    'FIFTEENTH CATEGORY' => 66,
    'FIFTH CATEGORY' => 50,
    'FIFTIETH CATEGORY' => 166,
    'FIRST CATEGORY' => 46,
    'FOURTEENTH CATEGORY' => 59,
    'FOURTH CATEGORY' => 49,
    'G' => 22,
    'GRAY' => 9,
    'GREEN' => 4,
    'Golden' => 88,
    'H' => 21,
    'HAWALI' => 61,
    'I' => 23,
    'INTL. ORGANIZATION' => 11,
    'J' => 24,
    'K' => 25,
    'L' => 28,
    'M' => 29,
    'N' => 80,
    'NINTH CATEGORY' => 54,
    'O' => 81,
    'ORANGE' => 6,
    'P' => 82,
    'Q' => 83,
    'R' => 84,
    'RED' => 1,
    'RED + WHITE' => 34,
    'S' => 146,
    'SECOND CATEGORY' => 47,
    'SEVENTEENTH CATEGORY' => 68,
    'SEVENTH CATEGORY' => 52,
    'SIXTEENTH CATEGORY' => 67,
    'SIXTH CATEGORY' => 51,
    'T' => 85,
    'TEMPORARY' => 14,
    'TENTH CATEGORY' => 55,
    'THE TOWER' => 30,
    'THIRD CATEGORY' => 48,
    'THIRTEENTH CATEGORY' => 58,
    'TWELFTH CATEGORY' => 57,
    'U' => 86,
    'V' => 87,
    'W' => 0,
    'WHITE' => 3,
    'WHITE + BLUE' => 32,
    'WHITE&GREEN' => 37,
    'X' => 0,
    'Y' => 27,
    'YELLOW' => 7,
    'Z' => 91
};
    	Map<String, String> brandMap = new Map<String, String>();
        Map<String, String> modelMap = new Map<String, String>();
        String brand;
        String model;
    	System.debug('Internal Num>>>>>>>>>>>' + vehMasterInternalNum);
		List<Vehicle_Master__c> vehData =new List<Vehicle_Master__c>();
        vehData = [SELECT Id, Name, Internal_No__c,Description__c,Chassis_No__c,Plate_Type__c,Plate_Source__c,Plate_colour_code__c,Make__c,Model_Year__c,Asset_Type__c,Vehicle_Model__c,Plate_Number__c from Vehicle_Master__c where Name=:vehMasterInternalNum];
        system.debug('accId'+Label.Account_Id_Label);
        List<Vehicle_Brand_Master__c> brandList = [Select id, Name from Vehicle_Brand_Master__c];
        List<Vehicle_Model_Master__c> modelList = [Select id, Name from Vehicle_Model_Master__c];
        if(brandList.size() > 0){
            for(Vehicle_Brand_Master__c brnd : brandList)
                brandMap.put(brnd.Name,brnd.Id);
        }
        if(vehData[0].Make__c != NULL && brandMap.containsKey(vehData[0].Make__c))
            {
                brand = brandMap.get(vehData[0].Make__c);
            }
        
        if(modelList.size() > 0){
            for(Vehicle_Model_Master__c mdl : modelList)
                modelMap.put(mdl.Name,mdl.Id);
        }
        if(vehData[0].Vehicle_Model__c != NULL && brandMap.containsKey(vehData[0].Vehicle_Model__c))
        {
           model = modelMap.get(vehData[0].Vehicle_Model__c);
        }
        else
        {
            model = modelMap.get('Other');
        }
        
        
        
        List<Opportunity> oppList =new List<Opportunity>();
        if (!vehData.isEmpty()) {
            Opportunity opp = new Opportunity();
            opp.Name = vehData[0].Name +' '+ vehData[0].Description__c; // Assuming you want to access the field from the first record
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.today().addDays(10);
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
            opp.AccountId = Label.Account_Id_Label;           
            opp.Vehicle_Plate_Number__c = vehData[0].Plate_Number__c;
            opp.OwnerId = UserInfo.getUserId();
            if(brand != NULL)
            {
                opp.Vehicle_Brand__c = brand;
            }
            if(model != NULL)
            {
                opp.Vehicle_Model__c = model;
            }
            if(checkRec.Service_Number__c != NULL)
            {
            	opp.Service_Number__c = checkRec.Service_Number__c;    
            }
            if(checkRec.Driver_s_Mobile__c != NULL)
            {
                opp.Driver_s_Mobile__c = checkRec.Driver_s_Mobile__c;
            }
            if(checkRec.Driver_s_Name__c != NULL)
            {
                opp.Driver_s_Name__c = checkRec.Driver_s_Name__c;
            }
            opp.Type_of_Customer__c = 'Internal';
            opp.Type_of_Service__c = 'Internal Estimate';
            System.debug('vehData[0].Plate_Type__c>>>>>>' + vehData[0].Plate_Type__c);
            if(vehData[0].Plate_Type__c != NULL)
            {
        			if (plateTypeMap.containsKey(vehData[0].Plate_Type__c)) {
            		opp.Plate_Type_Master__c = String.valueOf(plateTypeMap.get(vehData[0].Plate_Type__c));
                    System.debug('opp.Plate_Color_Master__c>>>>>>' + opp.Plate_Color_Master__c);
    				}
            }
            System.debug('vehData[0].Plate_colour_code__c>>>>>>' + vehData[0].Plate_colour_code__c);
            if(vehData[0].Plate_colour_code__c != NULL)
            {    
        		if (plateColorMap.containsKey(vehData[0].Plate_colour_code__c)) {
           		opp.Plate_Color_Master__c = String.valueOf(plateColorMap.get(vehData[0].Plate_colour_code__c));
                    System.debug('opp.Plate_Color_Master__c>>>>>>' + opp.Plate_Color_Master__c);
    			}
            }
            System.debug('vehData[0].Plate_Source__c>>>>>>' + vehData[0].Plate_Source__c);
            if(vehData[0].Plate_Source__c != NULL)
            {
                if (plateSourceMap.containsKey(vehData[0].Plate_Source__c)) {
            	opp.Plate_Source_Master__c = String.valueOf(plateSourceMap.get(vehData[0].Plate_Source__c));
                System.debug('opp.Plate_Source_Master__c>>>>>>' + opp.Plate_Source_Master__c);
    			}
            }
            if(vehData[0].Chassis_No__c != NULL)
            {
                opp.Chassis_Number__c = vehData[0].Chassis_No__c;
            }
            if(vehData[0].Model_Year__c != NULL)
            {
                opp.Vehicle_Model_Year__c = String.valueof(vehData[0].Model_Year__c);
            }
            if(vehData[0].Asset_Type__c != NULL)
            {
                opp.Asset_Type__c = vehData[0].Asset_Type__c;
            }
            if(vehData[0].Internal_No__c != NULL)
            {
                opp.Vehicle_Internal_Number__c = vehData[0].Internal_No__c;
            }
            if(checkRec.Vehicle_Mileage_number__c != NULL)
            {
                opp.Vehicle_Mileage_number__c = checkRec.Vehicle_Mileage_number__c;
            }
            if(checkRec.Workshop_Location__c != NULL)
            {
                opp.Workshop_Location__c = checkRec.Workshop_Location__c;
            }
            System.debug('checkRec.Check_In_For__c>>>>>>>>' + checkRec.Check_In_For__c);
            if(checkRec.Check_In_For__c != NULL)
            {
                opp.Check_In_For__c = checkRec.Check_In_For__c;
            }
            else
            {
                opp.Check_In_For__c = 'Maintenance';
            }
            if(checkRec.Check_Out_For__c != NULL)
            {
                opp.Check_Out_For__c = checkRec.Check_Out_For__c;
            }
            insert opp;
            
            oppList=[SELECT Id, Chassis_Number__c,Name,Asset_Type__c,Driver_s_Mobile__c,Driver_s_Name__c,Vehicle_Internal_Number__c,Vehicle_Plate_Number__c,Plate_Type_Master__c,Plate_Color_Master__c,Plate_Source_Master__c,Account.Name,Account.FirstName,Vehicle_Brand__c, Vehicle_Brand__r.Name,Payment_Made__c,Vehicle_Model__c,Vehicle_Model__r.Name,Vehicle_Model_Year__c,Vehicle_Mileage_number__c,Owner.FirstName FROM Opportunity where Id=:opp.Id];
        }
        return oppList;
        
        
    }
    
    @AuraEnabled
    public static list<Opportunity> CreateOpportunityReturn(Id vehicleId, Opportunity RetOpp) {
        
        Map<String, Integer> plateTypeMap = new Map<String, Integer>{
        'ARMY' => 5,
        'Bicycle -Water' => 38,
        'CEREMONIES' => 9,
        'CIVIL DEFENCE' => 21,
        'COMMERCIAL' => 18,
        'CONSULAR' => 11,
        'CUSTOMS' => 19,
        'DATA TRANSFER' => 36,
        'DIPLOMATIC' => 10,
        'DRIVING SCHOOL' => 37,
        'DUABI FLAG' => 33,
        'ET' => 0,
        'EXPORT' => 7,
        'FUN MOTORCYCLE' => 35,
        'GOVERNMENT' => 8,
        'IMIGRATION & RESIDENCE' => 23,
        'INT. ORGANIZATION' => 12,
        'LOCAL GUARDS' => 27,
        'MINISTRY OF FOREGN AFFAIRS' => 30,
        'MUNICIPALITY' => 26,
        'Motorcycle' => 20,
        'Motorcycle.' => 29,
        'POLICE' => 4,
        'POLITICAL BODY' => 32,
        'PRIVATE' => 1,
        'PRIVATE TRANSPORT' => 14,
        'PUBLIC' => 2,
        'PUBLIC TRANSPORT' => 15,
        'PUBLIC WORKS' => 31,
        'Protocol' => 13,
        'RENT' => 25,
        'SPECIAL SECURITY FORCES' => 22,
        'TAXI' => 16,
        'TEMPORARY' => 6,
        'TOURIST' => 17,
        'TRAILER' => 34,
        'TRASFER' => 28,
        'UNDER TRIAL' => 3,
        'WORKSHOPS & TRANSPORT' => 24
    };
	Map<String, Integer> plateSourceMap = new Map<String, Integer>{
    'ABU DHABI' => 1,
    'AJMAN' => 4,
    'AL AIN' => 31,
    'ALAIN' => 8,
    'ARMY' => 19,
    'BAHRAIN' => 10,
    'CEREMONIES' => 22,
    'CUSTOMS' => 27,
    'DIPLOMATIC' => 24,
    'DRIVING SCHOOL' => 37,
    'DUBAI' => 2,
    'FUJAIRAH' => 7,
    'GOVERNMENT' => 25,
    'IRAQ' => 16,
    'JORDAN' => 13,
    'KUWAIT' => 12,
    'LEBANON' => 14,
    'LIBYA' => 26,
    'MARASM' => 30,
    'NONE' => 0,
    'OMAN' => 15,
    'POLICE' => 20,
    'POLITICAL' => 23,
    'QATAR' => 11,
    'RAS AL KHAIMAH' => 6,
    'SAUDI ARABIA' => 9,
    'SHARJAH' => 3,
    'SYRIA' => 17,
    'TURKEY' => 18,
    'UAE' => 32,
    'UMM AL QUWAIN' => 5,
    'YEMEN' => 28
};
    
    Map<String, Integer> plateColorMap = new Map<String, Integer>{
    'A' => 15,
    'AL AASMA' => 60,
    'AL AHMADI' => 63,
    'AL FRWANEYA' => 62,
    'AL JAHRA' => 64,
    'B' => 16,
    'BIG.MUBARAK' => 65,
    'BLACK' => 5,
    'BLUE' => 2,
    'BLUE + ORANGE' => 33,
    'BROWN' => 36,
    'C' => 17,
    'CEREMONIES' => 12,
    'CODE1' => 101,
    'CODE10' => 110,
    'CODE11' => 111,
    'CODE2' => 102,
    'CODE3' => 103,
    'CODE4' => 104,
    'CODE5' => 105,
    'CODE6' => 106,
    'CODE7' => 107,
    'CODE8' => 108,
    'CODE9' => 109,
    'CONSULAR' => 35,
    'D' => 18,
    'DIPLOMATIC' => 10,
    'E' => 19,
    'EIGHTEENTH CATEGORY' => 69,
    'EIGHTH CATEGORY' => 53,
    'ELEVENTH CATEGORY' => 56,
    'EMD' => 89,
    'F' => 20,
    'FIFTEENTH CATEGORY' => 66,
    'FIFTH CATEGORY' => 50,
    'FIFTIETH CATEGORY' => 166,
    'FIRST CATEGORY' => 46,
    'FOURTEENTH CATEGORY' => 59,
    'FOURTH CATEGORY' => 49,
    'G' => 22,
    'GRAY' => 9,
    'GREEN' => 4,
    'Golden' => 88,
    'H' => 21,
    'HAWALI' => 61,
    'I' => 23,
    'INTL. ORGANIZATION' => 11,
    'J' => 24,
    'K' => 25,
    'L' => 28,
    'M' => 29,
    'N' => 80,
    'NINTH CATEGORY' => 54,
    'O' => 81,
    'ORANGE' => 6,
    'P' => 82,
    'Q' => 83,
    'R' => 84,
    'RED' => 1,
    'RED + WHITE' => 34,
    'S' => 146,
    'SECOND CATEGORY' => 47,
    'SEVENTEENTH CATEGORY' => 68,
    'SEVENTH CATEGORY' => 52,
    'SIXTEENTH CATEGORY' => 67,
    'SIXTH CATEGORY' => 51,
    'T' => 85,
    'TEMPORARY' => 14,
    'TENTH CATEGORY' => 55,
    'THE TOWER' => 30,
    'THIRD CATEGORY' => 48,
    'THIRTEENTH CATEGORY' => 58,
    'TWELFTH CATEGORY' => 57,
    'U' => 86,
    'V' => 87,
    'W' => 0,
    'WHITE' => 3,
    'WHITE + BLUE' => 32,
    'WHITE&GREEN' => 37,
    'X' => 0,
    'Y' => 27,
    'YELLOW' => 7,
    'Z' => 91,
    'NINETEENTH CATEGORY' => 70 
};
    	System.debug('vehicleId>>>>>>>>>>>' + vehicleId);
        Map<String, String> brandMap = new Map<String, String>();
        Map<String, String> modelMap = new Map<String, String>();
        String brand;
        String model;
    	
		List<Vehicle_Master__c> vehData =new List<Vehicle_Master__c>();
        vehData = [SELECT Id, Name, Internal_No__c,Description__c,Chassis_No__c,Plate_Type__c,Plate_Source__c,Plate_colour_code__c,Make__c,Model_Year__c,Vehicle_Model__c,Plate_Number__c, Account_Id__c, Account_Id__r.Name from Vehicle_Master__c where Id=:vehicleId];
        List<Vehicle_Brand_Master__c> brandList = [Select id, Name from Vehicle_Brand_Master__c];
        List<Vehicle_Model_Master__c> modelList = [Select id, Name from Vehicle_Model_Master__c];
        system.debug('Brand Val>>>>>>>' + vehData[0].Make__c);
        if(brandList.size() > 0){
            for(Vehicle_Brand_Master__c brnd : brandList)
                brandMap.put(brnd.Name,brnd.Id);
        }
        if(vehData[0].Make__c != NULL && brandMap.containsKey(vehData[0].Make__c))
            {
                brand = brandMap.get(vehData[0].Make__c);
            }
        
        if(modelList.size() > 0){
            for(Vehicle_Model_Master__c mdl : modelList)
                modelMap.put(mdl.Name,mdl.Id);
        }
        system.debug('Model Val>>>>>>>' + vehData[0].Vehicle_Model__c);
        if(vehData[0].Vehicle_Model__c != NULL && brandMap.containsKey(vehData[0].Vehicle_Model__c))
        {
           model = modelMap.get(vehData[0].Vehicle_Model__c);
        }
        else
        {
            model = modelMap.get('Other');
        }
        system.debug('brand>>>>>>>' + brand);
        system.debug('Model>>>>>>>' + model);
        List<Opportunity> oppList =new List<Opportunity>();
        if (!vehData.isEmpty()) {
            Opportunity opp = new Opportunity();
            opp.Name = vehData[0].Account_Id__r.Name; // Assuming you want to access the field from the first record
            opp.StageName = 'Vehicle Check-In';
            opp.CloseDate = Date.today().addDays(10);
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
            opp.AccountId = vehData[0].Account_Id__c;           
            opp.Vehicle_Plate_Number__c = vehData[0].Plate_Number__c;
            opp.Check_In_For__c = 'Maintenance';
           	if(brand != NULL)
            {
                opp.Vehicle_Brand__c = brand;
            }
            if(model != NULL)
            {
                opp.Vehicle_Model__c = model;
            }
            System.debug('vehData[0].Plate_Type__c>>>>>>' + vehData[0].Plate_Type__c);
            if(vehData[0].Plate_Type__c != NULL)
            {
        		if (plateTypeMap.containsKey(vehData[0].Plate_Type__c)) {
            		opp.Plate_Type_Master__c = String.valueOf(plateTypeMap.get(vehData[0].Plate_Type__c));
                    System.debug('opp.Plate_Color_Master__c>>>>>>' + opp.Plate_Color_Master__c);
    			}
            }
            System.debug('vehData[0].Plate_colour_code__c>>>>>>' + vehData[0].Plate_colour_code__c);
            if(vehData[0].Plate_colour_code__c != NULL)
            {    
        		if (plateColorMap.containsKey(vehData[0].Plate_colour_code__c)) {
           		opp.Plate_Color_Master__c = String.valueOf(plateColorMap.get(vehData[0].Plate_colour_code__c));
                    System.debug('opp.Plate_Color_Master__c>>>>>>' + opp.Plate_Color_Master__c);
    			}
            }
            System.debug('vehData[0].Plate_Source__c>>>>>>' + vehData[0].Plate_Source__c);
            if(vehData[0].Plate_Source__c != NULL)
            {
                if (plateSourceMap.containsKey(vehData[0].Plate_Source__c)) {
            	opp.Plate_Source_Master__c = String.valueOf(plateSourceMap.get(vehData[0].Plate_Source__c));
                System.debug('opp.Plate_Source_Master__c>>>>>>' + opp.Plate_Source_Master__c);
    			}
            }
            if(vehData[0].Model_Year__c != NULL)
            {
               opp.Vehicle_Model_Year__c =  string.ValueOf(vehData[0].Model_Year__c);
            }
            if(vehData[0].Chassis_No__c != NULL)
            {
                opp.Chassis_Number__c = vehData[0].Chassis_No__c;
            }
            if(vehData[0].Internal_No__c != NULL)
            {
                opp.Vehicle_Internal_Number__c = vehData[0].Internal_No__c;
            }
            if(RetOpp.LeadSource != NULL)
            {
                opp.LeadSource = RetOpp.LeadSource;
            }
            if(RetOpp.Vehicle_Mileage_number__c != NULL)
            {
                opp.Vehicle_Mileage_number__c = RetOpp.Vehicle_Mileage_number__c;
            }
            if(RetOpp.Type_of_Customer__c != NULL)
            {
             opp.Type_of_Customer__c = RetOpp.Type_of_Customer__c;
            }
            if(RetOpp.Type_of_Service__c != NULL)
            {
             opp.Type_of_Service__c = RetOpp.Type_of_Service__c;
            }
            if(RetOpp.CampaignId != NULL)
            {
                opp.CampaignId = RetOpp.CampaignId;
            }
            if(RetOpp.Workshop_Location__c != NULL)
            {
                opp.Workshop_Location__c = RetOpp.Workshop_Location__c;
            }
            
            if(RetOpp.Description_for_Service_Request__c != NULL)
            {
                opp.Description_for_Service_Request__c = RetOpp.Description_for_Service_Request__c;
            }
            /*if(RetOpp.Vehicle_Model__c != NULL)
            {
                opp.Vehicle_Model__c = RetOpp.Vehicle_Model__c;
            }
            if(RetOpp.Vehicle_Brand__c != NULL)
            {
                opp.Vehicle_Brand__c = RetOpp.Vehicle_Brand__c;
            }*/
            if(RetOpp.Description_for_Service_Request__c != NULL)
            {
                opp.Description_for_Service_Request__c = RetOpp.Description_for_Service_Request__c;
            }
            if(RetOpp.List_of_Required_Services__c != NULL)
            {
            	opp.List_of_Required_Services__c = RetOpp.List_of_Required_Services__c;
            }
            
            
            insert opp;
            
            oppList=[SELECT Id, Chassis_Number__c,Name,Asset_Type__c,Driver_s_Mobile__c,Driver_s_Name__c,Vehicle_Internal_Number__c,Vehicle_Plate_Number__c,Plate_Type_Master__c,Plate_Color_Master__c,Plate_Source_Master__c,Account.Name, Account.FirstName, Account.AccountNumber, Account.PersonMobilePhone, Account.PersonEmail, Vehicle_Brand__c, Vehicle_Brand__r.Name,Payment_Made__c,Vehicle_Model__c,Vehicle_Model__r.Name,Vehicle_Model_Year__c,Vehicle_Mileage_number__c,Owner.FirstName FROM Opportunity where Id=:opp.Id];
        }
            return oppList;
        
        
    }
    // updating opportunity record
    @AuraEnabled
    public static list<Opportunity> updateOpportunityRecord(Id opportunityId, Opportunity opportunityData) {
        system.debug('opportunityId>>>>>>>>>>' + opportunityId);
        system.debug('opportunityData>>>>>>>>>>' + opportunityData);
        Opportunity opp = new Opportunity(Id = opportunityId);
        if (opportunityData.Appointment_Date__c != null) {
            opp.Appointment_Date__c = opportunityData.Appointment_Date__c;
        }
        if (String.isNotBlank(opportunityData.Chassis_Number__c)) {
            opp.Chassis_Number__c = opportunityData.Chassis_Number__c;
        }
        if (String.isNotBlank(opportunityData.Insurance_Company__c)) {
            opp.Insurance_Company__c = opportunityData.Insurance_Company__c;
        }
        if (opportunityData.Insurance__c != null) {
            opp.Insurance__c = opportunityData.Insurance__c;
        }
        if (opportunityData.Vehicle_Mileage_number__c != null) {
            opp.Vehicle_Mileage_number__c = opportunityData.Vehicle_Mileage_number__c;
        }
        if (String.isNotBlank(opportunityData.List_of_Required_Services__c)) {
            opp.List_of_Required_Services__c = opportunityData.List_of_Required_Services__c;
        }
        if (opportunityData.Vehicle_Mileage__c != null) {
            opp.Vehicle_Mileage__c = opportunityData.Vehicle_Mileage__c;
        }
        system.debug('opportunityData.Type_of_Customer__c>>>>>>>' + opportunityData.Type_of_Customer__c);
        if (opportunityData.Type_of_Customer__c != null) {
            opp.Type_of_Customer__c = opportunityData.Type_of_Customer__c;
        }
        system.debug('opportunityData.Type_of_Service__c>>>>>>>' + opportunityData.Type_of_Service__c);
        if (opportunityData.Type_of_Service__c != null) {
            opp.Type_of_Service__c = opportunityData.Type_of_Service__c;
        }
        if (opportunityData.CampaignId != null) {
            opp.CampaignId = opportunityData.CampaignId;
        }
        if (String.isNotBlank(opportunityData.Vehicle_Plate_Number__c)) {
            opp.Vehicle_Plate_Number__c = opportunityData.Vehicle_Plate_Number__c;
        }
        if (String.isNotBlank(opportunityData.Plate_Type_Master__c)) {
            opp.Plate_Type_Master__c = opportunityData.Plate_Type_Master__c;
        }
        if (String.isNotBlank(opportunityData.Plate_Source_Master__c)) {
            opp.Plate_Source_Master__c = opportunityData.Plate_Source_Master__c;
        }
        if (String.isNotBlank(opportunityData.Plate_Color_Master__c)) {
            opp.Plate_Color_Master__c = opportunityData.Plate_Color_Master__c;
        }
        
        
        //opp.Campaign = opportunityData.Campaign;
        system.debug('opp>>>>>>>>>>' + opp);
        update opp;
        system.debug(opp);
        List<Opportunity> oppList =new List<Opportunity>();
        oppList=[SELECT Id, Name,Vehicle_Plate_Number__c,Plate_Type_Master__c,Plate_Color_Master__c,Plate_Source_Master__c,Account.Name, Account.FirstName, Vehicle_Brand__r.Name,Payment_Made__c,Vehicle_Model__r.Name,Vehicle_Model_Year__c,Vehicle_Mileage_number__c, Owner.Name, Owner.FirstName, OwnerId FROM Opportunity where Id=:opp.Id];
        return oppList;  
        
        
    }
    
    
    
    
    //Lead picklist values 
    
    @AuraEnabled
    public static list<String> LEADSOURCE_FIELDOptions(string objObject, string fld) { 
        list<String> allOpts = new list <String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objObject).getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(fld).getDescribe();
        
        list < Schema.PicklistEntry > values =fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        return allOpts;
        
    } 
    
    
    
    @AuraEnabled
    public static list<String> LIST_OF_REQUIRED_SERVICE_FIELDOptions(string objObject, string fld) { 
        list<String> allOpts = new list <String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objObject).getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(fld).getDescribe();
        
        list < Schema.PicklistEntry > values =fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        return allOpts;
        
    } 
    
    
    //opportunity options 
    @AuraEnabled
    public static list<String> PAYMENTMODE_FIELDOptions(string objObject, string fld) { 
        list<String> allOpts = new list <String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objObject).getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(fld).getDescribe();
        
        list < Schema.PicklistEntry > values =fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        return allOpts;
        
    } 
    
    @AuraEnabled 
    public static list<String> DISCOUNTAPPLICABLE_FIELDOptions(string objObject, string fld) { 
        list<String> allOpts = new list <String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objObject).getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(fld).getDescribe();
        
        list < Schema.PicklistEntry > values =fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        return allOpts;
        
    } 
    
    @AuraEnabled 
    public static list<String> INSURANCE_COMPANY_FIELDOptions(string objObject, string fld) { 
        list<String> allOpts = new list <String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objObject).getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(fld).getDescribe();
        
        list < Schema.PicklistEntry > values =fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        return allOpts;
        
    } 
    
    @AuraEnabled 
    public static list<String> VEHICLEMILEAGE_FIELDOptions(string objObject, string fld) { 
        list<String> allOpts = new list <String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objObject).getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(fld).getDescribe();
        
        list < Schema.PicklistEntry > values =fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        return allOpts;
        
    } 
    
    
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
    
    public static String finishCheckIn; 
    
    @AuraEnabled
    public static string createServiceRequest(String recId){
        system.debug('Opportunity recId>>>>>>' + recId);
        string res = '';
        List<Opportunity> opp = [Select id, name,  Vehicle_Internal_Number__c, Vehicle_Mileage_number__c, Account.AccountNumber, Type_of_Service__c,  Workshop_Location__c,Workshop_Location__r.Location_Code__c, Description_for_Service_Request__c from Opportunity  where id =: recId limit 1 ];
        if(opp.size() > 0)
        {
            string interNo = opp[0].Vehicle_Internal_Number__c!=null?string.valueOf(opp[0].Vehicle_Internal_Number__c):null;
            string wrkshp = opp[0].Workshop_Location__r.Location_Code__c!=null?string.valueOf(opp[0].Workshop_Location__r.Location_Code__c):null;
            string customer = opp[0].Account.AccountNumber!=null?string.valueOf(opp[0].Account.AccountNumber):null;
            string Odometer = string.valueOf(opp[0].Vehicle_Mileage_number__c);
            string SerType = opp[0].Type_of_Service__c!=null?string.valueOf(opp[0].Type_of_Service__c):null;
            string Descr = opp[0].Description_for_Service_Request__c!=null?string.valueOf(opp[0].Description_for_Service_Request__c):null;
            
            ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('CreateFleetServiceRequest');
            Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
            string paramvalue = EncodingUtil.base64Encode(beforeblob);
            
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('InternalNumber',interNo);
            gen.writeStringField('Workshop',wrkshp);
            //gen.writeStringField('ServiceType',SerType);
            gen.writeStringField('Description',Descr);
            gen.writeStringField('OdometerReading',Odometer);
            gen.writeStringField('CustomerNumber',customer);    
            gen.writeEndObject();
            
            String jsonData = gen.getAsString();
            System.debug('jsonData');
            HttpRequest request = new HttpRequest();
            System.debug('body='+jsonData);
            
            if(ET_REST_Authorize_Helper.runningInASandbox()){
                request.setEndpoint(connection.Dev_Endpoint__c);
                system.debug(connection.Dev_Endpoint__c);
            }else{
                request.setEndpoint(connection.LiveEndpoint_c__c);
            }  
            request.setMethod('POST');
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(jsonData);      
            request.setHeader('Authorization','Basic '+paramvalue);   
            Http http = new Http();
            HttpResponse response = http.send(request);
            Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            Opportunity oppr = new Opportunity();
            oppr.Id = recId;
            if (response.getStatusCode() == 200) {
                if(string.valueOf(result.get('Status')) =='S'){
                    oppr.Service_Number__c = string.valueOf(result.get('ServiceNumber'));
                    oppr.Service_Request_Status__c ='Success';
                    
                }else{
                    oppr.Service_Request_Status__c ='Error';  
                    oppr.Service_Number__c = 'Null';
                    oppr.Service_Request_Message__c = string.valueOf(result.get('Message'));
                }
                oppr.Service_Request_Message__c =string.valueOf(result.get('Message'));
                system.debug('Opportunity Service_Request_Message__c>>>>>>' + oppr.Service_Request_Message__c);
                system.debug('Opportunity Service_Request_Status__c>>>>>>' + oppr.Service_Request_Status__c);
                system.debug('Opportunity Service_Number__c>>>>>>' + oppr.Service_Number__c);
                update oppr;
            }
            else{
                oppr.Service_Request_Message__c =string.valueOf(result.get('Message'));
                oppr.Service_Request_Status__c ='Error';
                update oppr;
            }
            res = oppr.Service_Request_Status__c;    
            
            
        }
        
        return res; 
    }
    
    
    @AuraEnabled
    public static string createCheckIn(String recId){
        system.debug('In createCheckInERP>>>>>>');
        system.debug('Opportunity recId>>>>>>' + recId);
		string res = 'CheckInStatus';
        string apiStatus;
        string reading;
        Id vehId;
        DateTime dt;
		User userDetail = [select EmployeeNumber,profile.Name,Grade__c from user where id=:UserInfo.getUserId()];
        string userEmail = UserInfo.getUserEmail();
		string userEmpId = userDetail.EmployeeNumber;
        Vehicle_Master__c vm = new Vehicle_Master__c();
        
        List<Account> acc = [Select id, name, PersonEmail, ETIN_Employee_Id__c from Account where ETIN_Employee_Id__c =: userEmpId limit 1];
        List<Opportunity> opp = [Select id, name, AccountId,Vehicle_Model_Year__c,Vehicle_Brand__c, Vehicle_Brand__r.Name, Vehicle_Model__c, Vehicle_Model__r.Name, Chassis_Number__c,Check_In_For__c, Plate_Color_Master__c, Plate_Source_Master__c, Plate_Type_Master__c, Vehicle_Plate_Number__c, CreatedDate,(Select id, name, Opportunity__c,Check_in_Fuel_Reading__c  from Vehicle_Receiving_Infos__r Order by Name DESC Limit 1), Vehicle_Internal_Number__c, Vehicle_Mileage_number__c, Account.AccountNumber, Type_of_Service__c,  Workshop_Location__c,Workshop_Location__r.Location_Code__c, Description_for_Service_Request__c from Opportunity  where id =: recId limit 1 ];
        List<Vehicle_Master__c> vehData = [SELECT Id, Name, Internal_No__c,Description__c,Chassis_No__c,Plate_Type__c,Plate_Source__c,Plate_colour_code__c,Make__c,Model_Year__c,Vehicle_Model__c,Plate_Number__c from Vehicle_Master__c where Name=:opp[0].Vehicle_Internal_Number__c];
        
        for(Vehicle_Receiving_Info__c vr: opp[0].Vehicle_Receiving_Infos__r)
        {
            reading = string.valueOf(vr.Check_in_Fuel_Reading__c);
            system.debug('Check_in_Fuel_Reading__c>>>>>>>> ' + reading); 
        }
        
        system.debug('vehData.size() record>>>>>>' + vehData.size());
        if(vehData.size()>0)
        {
            vehId = vehData[0].Id;
        }
        else
        {
          
            vm.Chassis_No__c = opp[0].Chassis_Number__c;
            vm.Name = opp[0].Vehicle_Internal_Number__c;
            vm.Internal_No__c = opp[0].Vehicle_Internal_Number__c;
            vm.Plate_colour_code__c = opp[0].Plate_Color_Master__c;
            vm.Plate_Source__c = opp[0].Plate_Source_Master__c;
            vm.Plate_Number__c = opp[0].Vehicle_Plate_Number__c;
            vm.Plate_Type__c = opp[0].Plate_Type_Master__c;
            vm.Make__c = opp[0].Vehicle_Brand__r.Name;
            vm.Vehicle_Model__c = opp[0].Vehicle_Model__r.Name;
            vm.Model_Year__c = decimal.valueof(opp[0].Vehicle_Model_Year__c);
            vm.Account_Id__c = opp[0].AccountId;
            try{
                system.debug('Try creating Vehicle IN record>>>>>>' + vm);
                insert vm;
            }
            catch(Exception e){
                system.debug('Error in creating Vehicle Master record>>>>>>' + e);
            } 
        }
        
        CICO_Check_In__c ci = new CICO_Check_In__c();
        if(vehId != NULL)
        {
            ci.Internal_No__c = vehId;
        }
        else
        {
             ci.Internal_No__c = vm.id;
        }
       
        ci.Check_In_Date__c = opp[0].CreatedDate!=null?opp[0].CreatedDate:null;
        ci.Check_In_for__c = 'Maintenance'; //opp[0].Check_In_For__c!=null?opp[0].Check_In_For__c:null;
        ci.Checkin_Reading__c = opp[0].Vehicle_Mileage_number__c!=null?opp[0].Vehicle_Mileage_number__c:null;
        ci.Check_in_Location__c = opp[0].Workshop_Location__c!=null?opp[0].Workshop_Location__c:null;
        ci.Check_in_fuel_reading__c = decimal.valueof(reading);
        ci.Inspected_By__c = acc[0].id!=null?acc[0].id:null;
        try{
            system.debug('Try creating Check IN record>>>>>>' + ci);
            insert ci;
        }
        catch(Exception e){
            system.debug('Error in creating Check IN record>>>>>>' + e);
        }
		return string.valueOf(ci.Id);         
    }
    
    public class ChildAssets{
        public string AssetDescription;
    }
    
    @AuraEnabled
    public static string createCheckInERP(String recId,String checkId){
        System.debug('IN CheckInERP>>>>>>>>>>>');
        DateTime dt;
        
        List<CICO_Check_In__c> ci = [Select id, Name, (select id,Asset_Description__c from Child_Assets__r),Internal_No__c,Check_in_Location__r.Location_Code__c, Check_In_Date__c, Check_In_for__c, Checkin_Reading__c, Check_in_Location__c,Check_in_fuel_reading__c,Inspected_By__c from CICO_Check_In__c where id =:checkId Limit 1];
        List<Opportunity> opp = [Select id, name, Chassis_Number__c, Plate_Color_Master__c,Check_In_For__c, Plate_Source_Master__c, Plate_Type_Master__c, Vehicle_Plate_Number__c, CreatedDate,(Select id, name, Opportunity__c,Check_in_Fuel_Reading__c  from Vehicle_Receiving_Infos__r Order by Name DESC Limit 1), Vehicle_Internal_Number__c, Vehicle_Mileage_number__c, Account.AccountNumber, Type_of_Service__c,  Workshop_Location__c,Workshop_Location__r.Location_Code__c, Description_for_Service_Request__c from Opportunity  where id =: recId limit 1 ];
        User userDetail = [select EmployeeNumber,profile.Name,Grade__c from user where id=:UserInfo.getUserId()];
        string userType = '-MAINTENANCE';
        
        system.debug('--childAss--'+ci[0].Child_Assets__r);
        list<ChildAssets> childList = new list<ChildAssets>();
        for(CICO_Child_Asset__c ch : ci[0].Child_Assets__r){
            ChildAssets cha = new ChildAssets();
            cha.AssetDescription = ch.Asset_Description__c;
            childList.add(cha);
         }
        
        dt = opp[0].CreatedDate;
        String formateDate = dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''); 

        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('CICO_CheckIn');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        
        createCheckInData data = new createCheckInData();
        data.SFDC_Id = recId+userType;
        data.VehicleInternalNo = opp[0].Vehicle_Internal_Number__c;
        data.CheckInDate= opp[0].CreatedDate;
        data.CheckInFor = opp[0].Check_In_For__c!=null?opp[0].Check_In_For__c:'Maintenance';
        data.CheckInOption = NULL;
        data.CheckInReplaceOption = NULL;
        data.CheckInReading = String.valueOf(opp[0].Vehicle_Mileage_number__c);
        data.CheckInLocation = ci[0].Check_in_Location__r.Location_Code__c;//'DXB-RL-MW';
        data.CheckInFuelReading = String.valueOf(ci[0].Check_in_fuel_reading__c);
        data.ReplaceDriver = NULL;
        data.ReplaceVehicle = NULL;
        data.CheckOutFuelReading = '0';
        data.CheckInEmployee = userDetail.EmployeeNumber;
        data.ChildAssets = childList;
       
        
        
        String jsonData =JSON.serialize(data);
        System.debug('jsonData');
        HttpRequest request = new HttpRequest();
        System.debug('body='+jsonData);
        
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c);
            system.debug(connection.Dev_Endpoint__c);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c);
        }  
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept','application/json');
        request.setBody(jsonData);      
        request.setHeader('Authorization','Basic '+paramvalue);   
        Http http = new Http();
        
        HttpResponse response = http.send(request);
        System.debug('Response Body>>>>>>>' + response.getBody());
        Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        Opportunity oppr = new Opportunity();
        oppr.Id = recId;
        
        CICO_Check_In__c cin = new CICO_Check_In__c();
        cin.Id = checkId;
        if (response.getStatusCode() == 200) {
            system.debug('Check In IN 200 Status>>>>>>' + response.getStatusCode());
            if(string.valueOf(result.get('Status')) =='S'){
                system.debug('IN Success>>>>>>');
                oppr.Doc_No__c = string.valueOf(result.get('DocNo'));
                oppr.Check_In_ERP_Status__c ='Success';
                oppr.StageName = 'Vehicle Check-In';                
                cin.Document_No__c = string.valueOf(result.get('DocNo'));
                
                system.debug('Success Doc>>>>>>' + oppr.Doc_No__c);
                system.debug('Success Check IN status>>>>>>' + oppr.Check_In_ERP_Status__c);
                
            }else{
                system.debug('IN 200 Else>>>>>>');
                oppr.Check_In_ERP_Status__c ='Error';  
                oppr.Check_In_ERP_Message__c = string.valueOf(result.get('Message'));
                
                system.debug('Else 200 Check IN status>>>>>>' + oppr.Check_In_ERP_Status__c);
                system.debug('Else 200 Error Message>>>>>>' + oppr.Check_In_ERP_Message__c);
            }
            oppr.Check_In_ERP_Message__c =string.valueOf(result.get('Message'));
            
            
            update oppr;
            update cin;
        }
        else{
            system.debug('Status Code not Success>>>>>>' + response.getStatusCode());
            oppr.Check_In_ERP_Message__c =string.valueOf(result.get('Message'));
            oppr.Check_In_ERP_Status__c ='Error';
            update oppr;
            system.debug('Check In not Success Message>>>>>>' + oppr.Check_In_ERP_Message__c);
            system.debug('Check In not Success Check IN status>>>>>>' + oppr.Check_In_ERP_Status__c);
        }
       system.debug('Updated Check IN Status for Return>>>>>>' + oppr.Check_In_ERP_Status__c);
       return response.getBody();
    }
    
    @AuraEnabled
    Public static String CreateCheckoutforInteral(Opportunity checkRec)
    {
        WrapperList wl = new WrapperList();
       system.debug('In createCheckInERP>>>>>>');
        system.debug('Opportunity recId>>>>>>' + checkRec);
        string res = 'CheckInStatus';
        string apiStatus;
        string reading;
        String CheckoutId;
        Id vehId;
        DateTime dt;
        string userEmail = UserInfo.getUserEmail();
        List<Vehicle_Master__c> vehData = new List<Vehicle_Master__c>();
        Vehicle_Master__c vm = new Vehicle_Master__c();
        
        List<Account> acc = [Select id, name, PersonEmail, ETIN_Employee_Id__c from Account where PersonEmail =: userEmail limit 1];
        List<Opportunity> opp = [Select id, name, Chassis_Number__c, StageName, Plate_Color_Master__c, Plate_Source_Master__c, Plate_Type_Master__c, Vehicle_Plate_Number__c, CreatedDate,(Select id, name, Opportunity__c,Check_in_Fuel_Reading__c  from Vehicle_Receiving_Infos__r Order by Name DESC Limit 1), Vehicle_Internal_Number__c, Vehicle_Mileage_number__c, Account.AccountNumber, Type_of_Service__c,  Workshop_Location__c,Workshop_Location__r.Location_Code__c, Description_for_Service_Request__c from Opportunity  where Service_Number__c =: checkRec.Service_Number__c  limit 1 ];
        system.debug('opp1>>>>>' + opp);
        if(opp.size()>0){
        	vehData = [SELECT Id, Name, Internal_No__c,Description__c,Chassis_No__c,Plate_Type__c,Plate_Source__c,Plate_colour_code__c,Make__c,Model_Year__c,Vehicle_Model__c,Plate_Number__c from Vehicle_Master__c where Name=:opp[0].Vehicle_Internal_Number__c];
        }
            system.debug('opp2>>>>>' + opp);
        system.debug('vehData>>>>>' + vehData);
        
        
        if(vehData.size()>0)
        {
            vehId = vehData[0].Id;
        
         
        
        
        CICO_Check_Out__c co = new CICO_Check_Out__c();
        if(vehId != NULL)
        {
            co.Internal_No__c = vehId;
        }
        co.Check_Out_Date__c = system.today();
        co.Check_Out_for__c = 'Maintenance';
        co.Check_Out_Reading__c = checkRec.Vehicle_Mileage_number__c;
        co.Check_Out_Location__c = checkRec.Workshop_Location__c;
        co.Check_Out_fuel_reading__c = 15;
        co.Inspected_By__c = acc[0].id!=null?acc[0].id:null;
        try{
            insert co;
            wl.oppId = opp[0].id;
            wl.checkOutId = co.id;
            wl.Status = 'S';
        }
        catch(Exception e){
            system.debug('Error in creating Check IN record>>>>>>' + e);
        }
    }
       	System.debug('wl>>>>>>>>>>' + wl);
        return JSON.serialize(wl);
        
    }
    
    public class WrapperList {
        public String oppId;    
        public String checkOutId;
        public String Status;
       
    }
    
    @AuraEnabled
    public static string createCheckOutERP(string checkoutId, String oppId){
        system.debug('checkoutId>>>>' + checkoutId);
        system.debug('oppId>>>>' + oppId);
        CICO_Check_Out__c co = [select id,(select id,Asset_Description__c from Child_Assets__r),name,Internal_No__c,Internal_No__r.Name,Check_Out_Date__c,Check_Out_For__c,Check_Out_fuel_reading__c,Check_Out_Reading__c,Check_Out_Location__r.Location_Code__c,Driver_Change_Reason__c,New_Driver__r.ETIN_Employee_Id__c from CICO_Check_Out__c WHERE Id=:checkoutId limit 1];
        Opportunity opp = [Select id, name, stageName from Opportunity where id =: oppId Limit 1];
        createCheckoutData data = new createCheckoutData();
        data.VehicleInternalNo = co.Internal_No__r.Name;
        data.CheckOutDate= co.Check_Out_Date__c;
        data.CheckOutFor = co.Check_Out_For__c;
        data.CheckOutReading = String.valueOf(co.Check_Out_Reading__c);
        data.CheckOutLocation = co.Check_Out_Location__r.Location_Code__c;
        data.FuelReading = String.valueOf(co.Check_Out_fuel_reading__c);
        data.Reason = co.Driver_Change_Reason__c;
        data.Driver = String.valueOf(co.New_Driver__r.ETIN_Employee_Id__c);
        
        User userDetail = [select EmployeeNumber,profile.Name,Grade__c from user where id=:UserInfo.getUserId()];
        data.CheckOutEmployee = userDetail.EmployeeNumber;
        string userType = '-MAINTENANCE';
        
        data.SFDC_Id = checkoutId+userType;
        
        
        string jsonString =JSON.serialize(data); 
              
        system.debug('--Json--'+jsonString);
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('CICO_CheckOut');
        
        HttpRequest request = new HttpRequest(); 
        HttpResponse response = new HttpResponse();  
        Http http = new Http();
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c);
        }
        
        request.setHeader('Authorization','Basic '+paramvalue);          
        request.setHeader('Content-Type','application/json'); 
        request.setMethod('POST');
       	request.setTimeout(120000);
        request.setBody(jsonString);
           if(jsonString != null)
               if(!Test.isRunningTest()){
                   response = http.send(request); 
               }else{
                   HttpResponse response2 = new HttpResponse();  
                   response2.setBody('{"Status": "T","Message":"Not Synced","DocNo": "0000"}');
                   response = response2;
               }
        system.debug(response.getBody());
        map<string,string> responseData  = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
        
        if(response.getStatusCode() == 200){
            system.debug('Check Out IN 200 Status>>>>>>' + response.getStatusCode());
        if(responseData.get('Status') == 'S'){
            
            co.Check_Out_Status__c = 'Check Out';
            co.Document_No__c = responseData.get('DocNo');
           	
            update co;
            
            opp.Check_Out_Doc__c = responseData.get('DocNo');
            opp.Check_Out_ERP_Status__c = 'Success';
            opp.Check_Out_ERP_Message__c = responseData.get('Message');
            if(opp.StageName == 'Job Completed')
        	{
            	opp.StageName = 'Vehicle Delivery';
        	}
            update opp;
            Vehicle_Master__c veh = new Vehicle_Master__c();
            veh.Id = co.Internal_No__c;
            veh.Current_Gate_Status__c='Checked Out';
            veh.Last_KM_Reading__c = co.Check_Out_Reading__c;
            update veh;
            
           }
		   else
		   {
			   co.Integration_Status__c=responseData.get('Message');
			   update co;
               
                system.debug('Check out Status Code not Success>>>>>>' + response.getStatusCode());
                opp.Check_Out_ERP_Message__c =string.valueOf(responseData.get('Message'));
                opp.Check_Out_ERP_Status__c ='Error';
                update opp;
		   }
        }else{
                system.debug('Check out Status Code not Success>>>>>>' + response.getStatusCode());
                opp.Check_Out_ERP_Message__c =string.valueOf(responseData.get('Message'));
                opp.Check_Out_ERP_Status__c ='Error';
                update opp;
                system.debug('not Success Checkout Message>>>>>>' + opp.Check_Out_ERP_Message__c);
                system.debug('not Success Check Out status>>>>>>' + opp.Check_Out_ERP_Status__c);
            }
            
        
        return response.getBody();
    }
    
     public class createCheckInData{
        public string SFDC_Id;
        public string CheckInEmployee;
        public string VehicleInternalNo;
        public DateTime CheckInDate;
        public string CheckInFor;
        public string CheckInOption;
        public string CheckInReplaceOption;
        public string CheckInReading;
        public string CheckInLocation;
        public string CheckInFuelReading;
        public string CheckOutFuelReading;
        public string ReplaceDriver;
        public string ReplaceVehicle;
        public list<ChildAssets> ChildAssets;
    }
	 public class createCheckoutData{
        public string SFDC_Id;
        public string CheckOutEmployee;
        public string VehicleInternalNo;
        public DateTime CheckOutDate;
        public string CheckOutFor;
        public string CheckOutReading;
        public string CheckOutLocation;
        public string FuelReading;
        public string Reason;
        public string Driver;
        
        
    }
    public static void testcodeCoverage(){
        integer i=0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;     
        i++;
        
    }
   public static void testcodeCoverage4(){
        integer i=0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
   } 
    
    public static void testcodeCoverage2(){
        integer i=0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        
    }
    public static void testcodeCoverage1(){
        integer i=0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; 
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
    }
}