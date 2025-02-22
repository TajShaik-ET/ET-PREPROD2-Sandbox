/**
 * Author: Janardhan
 * Test Class: CICO_InspectionCtrlTest
 * --------------------------------------
 * 13/03/2023 -Janardhan- Added multiple inspection centers feasibility in getIntimationWithRelatedDetails method
 * 08/06/2023-Janardhan - Added multiple grade feasibility 
 * */

public class  CICO_InspectionCtrl {
  
    @AuraEnabled(cacheable=true)
    public static Account getUserDetails(){
        
        string id = [select Name,EmployeeNumber from user where id=:UserInfo.getUserId()].EmployeeNumber ;
        
        return [select Id,Name,firstName from account where ETIN_Employee_Id__c =:id and type='Employee'];
    } 
    @AuraEnabled(cacheable=true)
    public static User getUserLoginInfo(){        
        
        return [select Name,EmployeeNumber,Grade__c from user where id=:UserInfo.getUserId()];
    }
    
    @AuraEnabled
    public static list<CICO_Workshop_Location__c> getUserLocationInfo(){        
        
        user u = [select Name,EmployeeNumber,Grade__c,ETI_Inspection_Center__c from user where id=:UserInfo.getUserId()];
        
        string grade ='';
        if(u.Grade__c.contains('OPER')){
           grade ='OPER';
        }else if(u.Grade__c.contains('TECH')){
           grade ='TECH';
        }
        
        if(u.ETI_Inspection_Center__c !=null && grade !=null)
        return [select id,Name from CICO_Workshop_Location__c where Location_Code__c=:u.ETI_Inspection_Center__c AND User_Type__c=:grade];
        else
        return null;
    }
    
    
       
    @AuraEnabled
    public static list<string> getIntimationWithRelatedDetails(){
        
        User userDetails = [select Name,EmployeeNumber,Grade__c,ETI_Inspection_Center__c from user where id=:UserInfo.getUserId()];
        list<string> inspectionCenters = new list<string>();
        list<string> gradelist = new list<string>();
        if(userDetails.ETI_Inspection_Center__c != null)
         inspectionCenters = userDetails.ETI_Inspection_Center__c.split(',');
        if(userDetails.Grade__c != null)
        gradelist =userDetails.Grade__c.split(',');
        
        map<id,list<CICO_Intimation_Line__c>> IntimIdvsIntimLines  = new map<id,list<CICO_Intimation_Line__c>>();
        list<CICO_Intimation__c> intimationList = [select id,Name,Intimation_No__c,Intimation_Date__c,Location_Code__c,Intimation_Received_Date__c from CICO_Intimation__c where Intimation_Status__c ='Pending' AND Inspected_By__c=:gradelist AND Location_Code__c=:inspectionCenters AND Show_in_App__c=TRUE order by Name];
        list<CICO_Intimation_Line__c> intimationLinesList = [select id, name,Intimation_ID__c, PO_Line_ID__c,Intimation_Line_No__c,Inspected_Vehicles__c, Intimation_Quantity__c,(select id,name,Vehicle_Color__c,Inspection_Status__c,Engine_No__c,Year_Model__c,Asset_Type__c from Vehicle_Spec__r where Inspected__c = false) from CICO_Intimation_Line__c where Line_Status__c='Pending' order by Intimation_Line_No__c];
        string[] finalList = new List<String>();
        for(CICO_Intimation_Line__c intimLine : intimationLinesList){
            
            if(!IntimIdvsIntimLines.containsKey(intimLine.Intimation_ID__c)) {
                IntimIdvsIntimLines.put(intimLine.Intimation_ID__c, new List<CICO_Intimation_Line__c>());
            }
            IntimIdvsIntimLines.get(intimLine.Intimation_ID__c).add(intimLine);
        }
        
        for(CICO_Intimation__c intim: intimationList){
            
            String IntimationJson = JSON.serialize(intim);
            
            if(IntimIdvsIntimLines.containsKey(intim.ID)){
                String IntimlineJson = '"Intimation_Lines" : {';
                IntimlineJson += '"totalSize" : ' + IntimIdvsIntimLines.get(intim.Id).size() + ',';
                IntimlineJson += '"done" : true,';
                IntimlineJson += '"records" : ' + JSON.serialize(IntimIdvsIntimLines.get(intim.Id));
                IntimlineJson += '}';
                IntimationJson = IntimationJson.substring(0, IntimationJson.length()-1) + ',' + IntimlineJson + '}';
            }
            
            finalList.add(IntimationJson);
            
        }
        system.debug('--full---'+finalList);
        
        
        return finalList;
    }
    
    
    
    @AuraEnabled
    public static void addImagesToRecId(String recordId , String imgData){
        
        //attache all the img data to this record
        list<uploadedDocs> Updocs;
        if(imgData != null){
            Updocs = (List<uploadedDocs>)JSON.deserialize(imgData,  List<uploadedDocs>.Class);
            system.debug('Updocs size = '+ Updocs.size());
        }
        Savepoint sp = Database.setSavepoint();
        
        List<ContentVersion> lstContentVesions = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLinks = new  List<ContentDocumentLink>();
        
        
        if(Updocs != null && Updocs.size() > 0){
            for(uploadedDocs doc :Updocs){
                ContentVersion objContentVersion = new ContentVersion();
                objContentVersion.ContentLocation = 'S';
                //system.debug('VersionData = '+ doc.strBase64Data);
                String body = doc.strBase64Data;               
                String base64Mark = 'base64,';
                integer dataStart = body.indexOf(base64Mark) + base64Mark.length();
                //system.debug('dataStart = '+ dataStart);
                body = body.substring(dataStart);
                //system.debug('body = '+ body);
                objContentVersion.VersionData = EncodingUtil.base64Decode(body);
                objContentVersion.Title = doc.strFileName;
                objContentVersion.Origin = 'H';
                objContentVersion.PathOnClient = '/' + doc.strFileName;
                lstContentVesions.add(objContentVersion);
            }
            system.debug('******lstContentVesions****'+lstContentVesions);
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
                }Catch(Exception ex){
                    system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
                    Database.rollback(sp);
                    system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
                    throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
                }
            }
        }
        
        //Delete if duplicate sign and digrams are there
        list<ContentDocument> lstCntDocsToDelete = new list<ContentDocument>();
        list<id> toBeDeleteSign = new list<id>();
        
        for(ContentDocumentLink iterator : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:recordId AND ID NOT IN :lstContentDocumentLinks AND (ContentDocument.Title LIKE 'Sign%' OR ContentDocument.Title LIKE 'MarkedDiag%')]) {
            toBeDeleteSign.add(iterator.ContentDocumentId);
        }
       
        
        if(toBeDeleteSign.size() >0){
            for(integer i=0;i<toBeDeleteSign.size();i++){
                lstCntDocsToDelete.add(new ContentDocument(Id = toBeDeleteSign[i]));
            }
            
        }
       
        
        if(!lstCntDocsToDelete.isEmpty() && lstCntDocsToDelete != null) {
            try{
                Database.delete(lstCntDocsToDelete, false);
                Database.emptyRecycleBin(lstCntDocsToDelete);
            }Catch(Exception ex){
                Database.rollback(sp);
            }
        }
        
        
    }
    
    public class uploadedDocs{
        @AuraEnabled
        Public String strFileName;
        @AuraEnabled
        Public String strFileType;
        @AuraEnabled
        Public String strBase64Data;
        
    }
    
    
    @AuraEnabled
    public static map<string,string> submitIntimationReq(string RecId){
        //system.debug('--recID--'+RecId);
         Map<String, String> responseValues = new  Map<String, String>();
        list<CICO_Vehicle_Spec__c> vehicles = [select id,Inspection_No__c from CICO_Vehicle_Spec__c where Inspection_Status__c != 'Pending' AND Inspected__c = false AND Inspection_No__c = null AND Intimation_Line__r.Intimation_ID__c=:RecId];
       
       if(vehicles.size() > 0 ){
          
            //Oracle Service Call
           string response;
            list<CICO_Vehicle_Spec__c> updateVehicles  = new list<CICO_Vehicle_Spec__c>();
           if(!Test.isRunningTest()){
               response = CICO_InspectionCheckInCreationService.createInspectionInOracle(RecId);
           }else{
              response = '{"Status":"S","Message":"test","InspectionNo":"1234"}';
           }
           
            system.debug('---response--'+response);
            responseValues = (Map<String, String>)JSON.deserialize(response, Map<String, String>.class);
          
            if(!responseValues.isEmpty()){
                
                if(responseValues.get('Status') == 'S'){
                    
                    for(CICO_Vehicle_Spec__c veh : vehicles){
                        veh.Inspection_No__c =responseValues.get('InspectionNo');
                        veh.Inspected__c = true;
                        
                        updateVehicles.add(veh);
                    }
                    try{
                        if(!updateVehicles.isEmpty())
                            update updateVehicles;
                    }
                    catch(Exception ex){
                        throw new AuraHandledException(ex.getMessage());
                    }
                }
                
                return responseValues;
                
                
                
            }else {
                responseValues.put('Status','NoResponse');
                return responseValues;
                
            }      
        }else {
            responseValues.put('Status','No_Data');
            return responseValues;
        }
            
    }
    
    
    @AuraEnabled
    public static map<string,string> getRecordFileDetails(string RecId){
        map<string,string> nameVsVersionID = new map<string,string>();
        
        for(ContentDocumentLink  cd : [SELECT id,ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE id != null AND LinkedEntityId=:RecId]){
            
            nameVsVersionID.put(cd.ContentDocument.Title.substringBefore('.'),cd.ContentDocument.LatestPublishedVersionId);
        }
        
        return nameVsVersionID;
        
    } 
    
    
    
    /* *****Checkout process related methods - start**** */
    @AuraEnabled
    public static list<CICO_Check_Out__c> getCheckOutInfo(){
        
        list<CICO_Check_Out__c> coList = [SELECT id,name,Internal_No__r.Name,Check_Out_For__c,Plate_No__c,Check_Out_Date__c,Check_Out_Status__c from CICO_Check_Out__c WHERE createdById=:UserInfo.getUserId() ORDER BY Check_Out_Date__c DESC limit 100];
        
        return coList;
        
    }
    
    @AuraEnabled
    public static checkInDetailWrap getCheckInDetails(string recId,string checkOutFor){
        
        map<string,string> nameVsVersionID = new map<string,string>(); 
        list<CICO_Child_Asset__c> childAssetList = new list<CICO_Child_Asset__c>();
        
        checkInDetailWrap wrap = new checkInDetailWrap();
        //and Check_In_for__c=:checkOutFor
        CICO_Check_In__c data = [select id,name,Check_In_Date__c,Check_in_fuel_reading__c,Asset_Type__c,Check_in_Location__r.Name,Checkin_Reading__c,Radio__c,Chassis_No__c,Plate_No__c,Cassette__c,Cassette_Player__c,Emer_Tool_Kit__c,Fire_Ext_In__c,First_Aid_Box__c,Microphone__c,Reflec_Trian__c,Spare_Wheel__c,Video__c,Wheel_Cap__c from CICO_Check_In__c where Internal_No__c=:recId AND Check_In_Status__c='Check In' ORDER BY Check_In_Date__c DESC limit 1];
        
        if(data.id != null)
            for(ContentDocumentLink  cd : [SELECT id,ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE id != null AND LinkedEntityId=:data.Id]){
                
                nameVsVersionID.put(cd.ContentDocument.Title.substringBefore('.'),cd.ContentDocument.LatestPublishedVersionId);
            }
        
          if(data.id != null)
           for(CICO_Child_Asset__c ca : [SELECT id,Name,Asset_Description__c,Received__c,Issued__c from CICO_Child_Asset__c where Check_In__c=:data.id]){
                childAssetList.add(ca);
            }
        
        wrap.checkInData = data;
        wrap.fileData = nameVsVersionID;
        wrap.childAssests = childAssetList;
        
        return wrap;
        
    }
    public class checkInDetailWrap{
        @AuraEnabled
        Public CICO_Check_In__c checkInData;
        @AuraEnabled
        Public map<string,string> fileData;
        @AuraEnabled
        Public list<CICO_Child_Asset__c> childAssests;
        
    }
    
    @AuraEnabled
    public static checkInDetailWrapByRecId getCheckInDetailsByCheckInID(string recId){
        
        map<string,string> nameVsVersionID = new map<string,string>(); 
        list<CICO_Child_Asset__c> childAssetList = new list<CICO_Child_Asset__c>();
        
        checkInDetailWrapByRecId wrap = new checkInDetailWrapByRecId();
        
        CICO_Check_In__c data = [select id,name,Check_In_Date__c,Check_in_fuel_reading__c,Asset_Type__c,Check_in_Location__c,Check_in_Location__r.Name,Checkin_Reading__c,Chassis_No__c,Plate_No__c,Radio__c,Cassette__c,Cassette_Player__c,Emer_Tool_Kit__c,Fire_Ext_In__c,First_Aid_Box__c,Microphone__c,Reflec_Trian__c,Spare_Wheel__c,Video__c from CICO_Check_In__c where Id=:recId];
        
        if(data.id != null)
            for(ContentDocumentLink  cd : [SELECT id,ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE id != null AND LinkedEntityId=:data.Id]){
                
                nameVsVersionID.put(cd.ContentDocument.Title.substringBefore('.'),cd.ContentDocument.LatestPublishedVersionId);
            }
        
        if(data.id != null)
            for(CICO_Child_Asset__c ca : [SELECT id,Name,Asset_Description__c,Received__c,Issued__c from CICO_Child_Asset__c where Check_In__c=:data.id]){
                childAssetList.add(ca);
            }
        
        wrap.checkInData = data;
        wrap.fileData = nameVsVersionID;
        wrap.childAssests = childAssetList;
        
        return wrap;
        
    }
    public class checkInDetailWrapByRecId{
        @AuraEnabled
        Public CICO_Check_In__c checkInData;
        @AuraEnabled
        Public map<string,string> fileData;
        @AuraEnabled
        Public list<CICO_Child_Asset__c> childAssests;
        
    }
    
    @AuraEnabled
    public static string deleteFilewithVersionId(string recId){
        
        ContentVersion cont = [SELECT ContentDocumentId,Id FROM ContentVersion where id=:recId];
        try{
            delete [SELECT Id FROM ContentDocument WHERE Id=:cont.ContentDocumentId];
            return 'SUCCESS';
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
   @AuraEnabled
    public static list<CICO_Child_Asset__c> getChildAssetDetails(string recId){
        return [select id,Name,Asset_Description__c,Received__c,Issued__c from CICO_Child_Asset__c where Check_Out__c=:recId];
    }
    @AuraEnabled
    public static void deleteRecordInSF(string recId){
        if(recId != null){
            try{
                Database.delete(recId);
            }catch(Exception ex){
                throw new AuraHandledException(ex.getMessage());
            }
        }
    }
    
      
    @AuraEnabled
    public static string sendCheckOutToOracle(string recId){
        
        CICO_Check_Out__c co = [select id,(select id,Asset_Description__c from Child_Assets__r),name,Internal_No__c,Internal_No__r.Name,Check_Out_Date__c,Check_Out_For__c,Check_Out_fuel_reading__c,Check_Out_Reading__c,Check_Out_Location__r.Location_Code__c,Driver_Change_Reason__c,New_Driver__r.ETIN_Employee_Id__c from CICO_Check_Out__c WHERE Id=:recId limit 1];
        
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
        string userType = '';
        if(userDetail.Grade__c !=null && userDetail.Grade__c.contains('OPER')){
            userType = '-OPERATIONS';
        }else if(userDetail.Grade__c !=null && userDetail.Grade__c.contains('TECH')){
            userType = '-MAINTENANCE';
        }
        data.SFDC_Id = recId+userType;
        
        list<ChildAssets> childList = new list<ChildAssets>();
        for(CICO_Child_Asset__c ch : co.Child_Assets__r){
            ChildAssets cha = new ChildAssets();
            cha.AssetDescription = ch.Asset_Description__c;
            childList.add(cha);
         }
        data.ChildAssets = childList;
        
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
        if(responseData.get('Status') == 'S'){
            
            co.Check_Out_Status__c = 'Check Out';
            co.Document_No__c = responseData.get('DocNo');
           
            update co;
            
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
		   }
        
        
        return response.getBody();
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
        public list<ChildAssets> ChildAssets;
        
    }
    public class ChildAssets{
        public string AssetDescription;
    }
    
    
    //CheckInToOracle
     @AuraEnabled
    public static string sendCheckInToOracle(string recId){
        
        CICO_Check_In__c ci = [select id,name,(select id,Asset_Description__c from Child_Assets__r),Internal_No__c,Last_Check_Out_Fuel_Reading__c,Internal_No__r.Name,Check_In_Date__c,Check_In_for__c,Rental_Status__c,Replacement_Option__c,Checkin_Reading__c,Check_in_Location__c,Check_in_Location__r.Location_Code__c,Check_in_fuel_reading__c,Replacement_Driver_ID__r.ETIN_Employee_Id__c,Replacement_Internal_No__c,Replacement_Internal_No__r.Name from CICO_Check_In__c WHERE Id=:recId limit 1];
        
        createCheckInData data = new createCheckInData();
        data.VehicleInternalNo = ci.Internal_No__r.Name;
        data.CheckInDate= ci.Check_In_Date__c;
        data.CheckInFor = ci.Check_In_for__c;
        data.CheckInOption = ci.Rental_Status__c;
        data.CheckInReplaceOption = ci.Replacement_Option__c;
        data.CheckInReading = String.valueOf(ci.Checkin_Reading__c);
        data.CheckInLocation = ci.Check_in_Location__r.Location_Code__c;//'DXB-RL-MW';
        data.CheckInFuelReading = String.valueOf(ci.Check_in_fuel_reading__c);
        data.ReplaceDriver = ci.Replacement_Driver_ID__r.ETIN_Employee_Id__c;
        data.ReplaceVehicle = ci.Replacement_Internal_No__r.Name;
        data.CheckOutFuelReading = String.valueOf(ci.Last_Check_Out_Fuel_Reading__c);
       
        User userDetail = [select EmployeeNumber,profile.Name,Grade__c from user where id=:UserInfo.getUserId()];
        string userType = '';
        if(userDetail.Grade__c !=null && userDetail.Grade__c.contains('OPER')){
            userType = '-OPERATIONS';
        }else if(userDetail.Grade__c !=null && userDetail.Grade__c.contains('TECH')){
            userType = '-MAINTENANCE';
        }
        data.SFDC_Id = recId+userType;
        data.CheckInEmployee = userDetail.EmployeeNumber;
          
        
         system.debug('--childAss--'+ci.Child_Assets__r);
        
        list<ChildAssets> childList = new list<ChildAssets>();
        for(CICO_Child_Asset__c ch : ci.Child_Assets__r){
            ChildAssets cha = new ChildAssets();
            cha.AssetDescription = ch.Asset_Description__c;
            childList.add(cha);
         }
        data.ChildAssets = childList;
            
        string jsonString =JSON.serialize(data); 
              
        system.debug('--JSON--'+jsonString);
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('CICO_CheckIn');
        
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
        if(jsonString != null){
            
             if(!Test.isRunningTest()){
                 response = http.send(request); 
             }else{
                 HttpResponse response2 = new HttpResponse();  
                 response2.setBody('{"Status": "T","Message":"Not synced","DocNo": "0000"}');
                 response = response2;
             }
        }          
       
        
        system.debug(response.getBody());
        map<string,string> responseData  = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
        if(responseData.get('Status') == 'S'){
            //Update CheckIn Status
            ci.Check_In_Status__c = 'Check In';
            ci.Document_No__c = responseData.get('DocNo');
            
            update ci;
            
            //Update Vehicle Master
            Vehicle_Master__c veh = new Vehicle_Master__c();
            veh.Id = ci.Internal_No__c;
            veh.Current_Gate_Status__c='Checked In';
            veh.Last_KM_Reading__c = ci.Checkin_Reading__c;
            update veh;
            
            //Create new Checkout in draft mode for Replace with Vehicle
            if(ci.Replacement_Internal_No__c != null){
                
                CICO_Check_Out__c co = new CICO_Check_Out__c();
                co.Internal_No__c = ci.Replacement_Internal_No__c;
                co.Check_Out_For__c = ci.Check_In_for__c;
                co.Check_Out_Location__c = ci.Check_in_Location__c;
                co.Check_Out_Date__c = system.now();
                insert co;
            }
            
        }
		else
		{
			ci.Integration_Status__c=responseData.get('Message');
			update ci;
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
    
    @AuraEnabled
    public static Vehicle_Master__c getVehicleInfo(string recId){
        
        return [SELECT Id,Name,Chassis_No__c,Asset_Type__c,Last_KM_Reading__c,Current_Gate_Status__c,Plate_Number__c from Vehicle_Master__c WHERE Id=:recId];
    }
    //Oracle REST API Request
    @AuraEnabled
    public static string getVehicleChildAssetCustomerInfo(string InternalNo,string CheckoutType){
         
       
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('CICO_getChildAssetsCustomerInfo');
        
        HttpRequest request = new HttpRequest(); 
        HttpResponse response = new HttpResponse();  
        Http http = new Http();
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string endpointExt= '?InternalNo='+InternalNo+'&CheckOutType='+CheckoutType;
        
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c+endpointExt);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c+endpointExt);
        }
        
        request.setHeader('Authorization','Basic '+paramvalue);          
        request.setHeader('Content-Type','application/json'); 
        request.setMethod('GET');
       
        
        if(!Test.isRunningTest()){
            response = http.send(request); 
        }else{
             HttpResponse fakeRes = new HttpResponse();  
            fakeRes.setBody('{"Status": "S","PreCheckOutInfo":{}}');
            response = fakeRes;
        }
        system.debug(response.getBody());
       return response.getBody();
    }
    
    @AuraEnabled
    public static list<String> getselectOptions(string objObject, string fld) { 
        
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
    public static void updateVehicleMaster(string recId, string assetType) { 
       Vehicle_Master__c veh = new Vehicle_Master__c();
        
        veh.Id = recId;
        veh.Asset_Type__c = assetType;
        
        update veh;
     
    }
    @AuraEnabled 
    public static list<Vehicle_Master__c> getVehicleMasterList(string plateNumber, string PlateCode,String PlateSource,string PlateType) { 
    
       String queryStr;
       queryStr = 'SELECT Id,Name,Description__c from Vehicle_Master__c where Plate_Number__c LIKE  \'%'+ plateNumber +'%\' AND Plate_colour_code__c LIKE  \'%'+ PlateCode +'%\' AND Plate_Source__c LIKE  \'%'+ PlateSource +'%\' AND Plate_Type__c LIKE  \'%'+ PlateType +'%\' limit 5';
       
        return Database.Query(queryStr); 
        
    }
    
     @AuraEnabled 
    public static list<CICO_Workshop_Location__c> getWorkshopCoord(){
        //ETST_AddressSearchController.getAddressSet('SearchText');
        
        return [Select id,Name,Boundary_Coordinates__c from CICO_Workshop_Location__c];
    }
     @AuraEnabled
    public static void deleteCheckOutChildAssets(string recId){
        
        Delete [select id from CICO_Child_Asset__c where Check_Out__c=:recId];
    }
    
    
    /* *****Checkout process related methods - end**** */
    
    /* *****Checkin process related methods - start**** */
    
    @AuraEnabled
    public static void deleteCheckInChildAssets(string recId){
        
        Delete [select id from CICO_Child_Asset__c where Check_In__c=:recId];
    }
    
    
    @AuraEnabled
    public static list<CICO_Check_In__c> getCheckInInfo(){
        
        list<CICO_Check_In__c> coList = [SELECT id,name,Replacement_Option__c,Internal_No__r.Name,Check_In_Status__c,Check_In_for__c,Plate_No__c,Check_In_Date__c from CICO_Check_In__c WHERE createdById=:UserInfo.getUserId() ORDER BY Check_In_Date__c DESC limit 100];
        
        return coList;
        
    }
    
    //Oracle REST API Request Check In
    @AuraEnabled
    public static string getVehicleChildAssetCheckIn(string InternalNo,string CheckInType){
         
       
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('CICO_CheckInChildAssets');
        
        HttpRequest request = new HttpRequest(); 
        HttpResponse response = new HttpResponse();  
        Http http = new Http();
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string endpointExt= '?InternalNo='+InternalNo+'&CheckInType='+CheckInType;
        
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c+endpointExt);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c+endpointExt);
        }
        
        request.setHeader('Authorization','Basic '+paramvalue);          
        request.setHeader('Content-Type','application/json'); 
        request.setMethod('GET');
       
        
        if(!Test.isRunningTest()){
            response = http.send(request); 
        }else{
             HttpResponse fakeRes = new HttpResponse();  
            fakeRes.setBody('{"Status": "S","PreCheckInInfo":{}}');
            response = fakeRes;
        }
        system.debug(response.getBody());
       return response.getBody();
    }
    
    @AuraEnabled
    public static checkOutDetailWrap getCheckOutDetails(string recId,string checkOutFor){
        
        map<string,string> nameVsVersionID = new map<string,string>(); 
        list<CICO_Child_Asset__c> childAssetList = new list<CICO_Child_Asset__c>();
        
        checkOutDetailWrap wrap = new checkOutDetailWrap(); 
        //and Check_Out_For__c=:checkOutFor
        
        CICO_Check_Out__c data = [select id,name,Customer_Email__c,Customer_Name__c,Reference_Number__c,Assigned_Driver_ID__c,Check_Out_Date__c,Check_Out_fuel_reading__c,Asset_Type__c,Check_Out_Location__r.Name,Check_Out_Reading__c,Chassis_No__c,Plate_No__c,Radio__c,Cassette__c,Cassette_Player__c,Emer_Tool_Kit__c,Fire_Ext_In__c,First_Aid_Box__c,Microphone__c,Reflec_Trian__c,Spare_Wheel__c,Video__c,Wheel_Cap__c from CICO_Check_Out__c where Internal_No__c=:recId AND Check_Out_Status__c='Check Out' ORDER BY Check_Out_Date__c	 DESC limit 1];
        
        if(data.id != null)
            for(ContentDocumentLink  cd : [SELECT id,ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE id != null AND LinkedEntityId=:data.Id]){
                
                nameVsVersionID.put(cd.ContentDocument.Title.substringBefore('.'),cd.ContentDocument.LatestPublishedVersionId);
            }
        
           if(data.id != null)
                for(CICO_Child_Asset__c ca : [SELECT id,Name,Asset_Description__c,Received__c,Issued__c from CICO_Child_Asset__c where Check_Out__c=:data.id]){
                    childAssetList.add(ca);
                }
        
        wrap.checkOutData = data;
        wrap.fileData = nameVsVersionID;
        wrap.childAssests = childAssetList;
        
        return wrap;
        
    }
    public class checkOutDetailWrap{
        @AuraEnabled
        Public CICO_Check_Out__c checkOutData;
        @AuraEnabled
        Public map<string,string> fileData;
        @AuraEnabled
        Public list<CICO_Child_Asset__c> childAssests;
        
    }
    
    @AuraEnabled
    public static checkOutDetailWrapById getCheckOutDetailsByCheckOutRecId(string recId){
        
        map<string,string> nameVsVersionID = new map<string,string>(); 
        list<CICO_Child_Asset__c> childAssetList = new list<CICO_Child_Asset__c>();
        
        checkOutDetailWrapById wrap = new checkOutDetailWrapById();
        
        CICO_Check_Out__c data = [select id,name,Check_Out_Date__c,Check_Out_fuel_reading__c,Asset_Type__c,Check_Out_Location__r.Name,Check_Out_Reading__c,Chassis_No__c,Plate_No__c,Radio__c,Cassette__c,Cassette_Player__c,Emer_Tool_Kit__c,Fire_Ext_In__c,First_Aid_Box__c,Microphone__c,Reflec_Trian__c,Spare_Wheel__c,Video__c from CICO_Check_Out__c where Id=:recId];
        
        if(data.id != null)
            for(ContentDocumentLink  cd : [SELECT id,ContentDocument.Title, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE id != null AND LinkedEntityId=:data.Id]){
                
                nameVsVersionID.put(cd.ContentDocument.Title.substringBefore('.'),cd.ContentDocument.LatestPublishedVersionId);
            }
        
         if(data.id != null)
            for(CICO_Child_Asset__c ca : [SELECT id,Name,Asset_Description__c,Received__c,Issued__c from CICO_Child_Asset__c where Check_Out__c=:data.id]){
                childAssetList.add(ca);
            }
        
        wrap.checkOutData = data;
        wrap.fileData = nameVsVersionID;
        wrap.childAssests = childAssetList;
        
        return wrap;
        
    }
    public class checkOutDetailWrapById{
        @AuraEnabled
        Public CICO_Check_Out__c checkOutData;
        @AuraEnabled
        Public map<string,string> fileData;
        @AuraEnabled
        Public list<CICO_Child_Asset__c> childAssests;
        
    }
   @AuraEnabled
    public static list<CICO_Child_Asset__c> getChildAssetDetailsCI(string recId){
        return [select id,Name,Asset_Description__c,Received__c,Issued__c from CICO_Child_Asset__c where Check_In__c=:recId];
    }
    
    /* *****Checkin process related methods - end**** */
}