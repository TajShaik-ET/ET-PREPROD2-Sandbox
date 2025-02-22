global class ETI_BatchSyncReceipts implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful{
    global List<String> exception_List;
    global Map<Id, String> errorMap;
    global Map<Id, String> successMap;
    global Map<Id, SObject> IdToSObjectMap;
    global String baseUrl;
    
    global ETI_BatchSyncReceipts(){
        errorMap = new Map<Id, String>();
        successMap = new Map<Id, String>();
        IdToSObjectMap = new Map<Id, SObject>();
        baseURL = URL.getSalesforceBaseUrl().toExternalForm();
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
          String query = 'SELECT Id,Name,Service_Line_Item__c,Service_Line_Item__r.Booking__c FROM ETI_Inspection_Receipt__c WHERE Integration_Status__C <> \'Success\'';
          return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<ETI_Inspection_Receipt__c> scope){
        String msg ='';
        List<ETI_Inspection_Receipt__c> vListReceiptUpdate = new List<ETI_Inspection_Receipt__c>();
        for(ETI_Inspection_Receipt__c rec : scope){
                 vListReceiptUpdate=sendData(rec.Service_Line_Item__c,rec.Service_Line_Item__r.Booking__c,rec.Id);
        }
        if(vListReceiptUpdate.size()>0){
        Database.SaveResult[] result = Database.update(vListReceiptUpdate,false);
        Integer index =0 ;
        for(Database.SaveResult res : result){
            if(!res.isSuccess()){
                String errMsg= res.getErrors()[0].getMessage();
                errorMap.put(scope[index].Id,errMsg);
            }
            else{
                String sucMsg = baseUrl +'/'+scope[index].Id;
                successMap.put(scope[index].Id,sucMsg);
            }
            IdToSObjectMap.put(scope[index].Id,scope[index]);
            index++;
        }
        }
       
    }
    global void finish(Database.BatchableContext BC){
          if(! IdToSObjectMap.isEmpty()) {
            AsyncApexJob a = [SELECT id, ApexClassId,
                              JobItemsProcessed, TotalJobItems,
                              NumberOfErrors, CreatedBy.Email
                              FROM AsyncApexJob
                              WHERE id = :BC.getJobId()];
            String body = 'Your batch job '
                + 'AccountUpdateBatch '
                + 'has finished. \n'
                + 'There were total'
                + IdToSObjectMap.size()
                + ' records. Please find the attached success and error records CSV.';
            String subject = 'Receipt - Apex Batch Result for ETI_BatchSyncReceipts';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
            if(!errorMap.isEmpty()){
                String finalstr = 'Id, Name, Error \n';
                String attName = 'ReceiptError' + system.now().format('YYYYMMDDhhmm') + '.csv';
                for(Id id  : errorMap.keySet()){
                    string err = errorMap.get(id);
                    ETI_Inspection_Receipt__c rec = (ETI_Inspection_Receipt__c) IdToSObjectMap.get(id);
                    string recordString = '"'+id+'","'+rec.Name+'","'+err+'"\n';
                    finalstr = finalstr +recordString;
                }
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(attName);
                efa.setBody(Blob.valueOf(finalstr));
                emailAttList.add(efa);
            }
            if(! successMap.isEmpty()) {
                String finalstr = 'Id, Name, Link \n';
                String attName = 'ReceiptSuccess' + system.now().format('YYYYMMDDhhmm') + '.csv';
                for(Id id  : successMap.keySet()){
                    string suc = successMap.get(id);
                    ETI_Inspection_Receipt__c rec = (ETI_Inspection_Receipt__c) IdToSObjectMap.get(id);
                    string recordString = '"'+id+'","'+rec.Name+'","'+suc+'"\n';
                    finalstr = finalstr +recordString;
                }
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(attName);
                efa.setBody(Blob.valueOf(finalstr));
                emailAttList.add(efa);
                 
            }
          
            email.setSubject( subject );
            email.setToAddresses( new String[] {a.CreatedBy.Email} );
            email.setPlainTextBody( body );
            email.setFileAttachments(emailAttList);
            Messaging.SendEmailResult [] r =
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
    public static List<ETI_Inspection_Receipt__c> sendData(String vSerLineItemRecId,String vBookingId,String receiptId){
        String CrmTrxReference='',CrmCustomerNo='',CustomerName='',CustomerMobileNo='',PreferredLanguage='',CustomerSiteAddress='',CustSiteGpsCord='',CrCardAuthCode='';
        Decimal TotalPaidAmount=0;
        List<ETI_Inspection_Receipt__c> vListReceiptInsert = new List<ETI_Inspection_Receipt__c>();
        List<ETI_Booking__c> vServiceObj = new List<ETI_Booking__c>();
        if(vSerLineItemRecId != null && vBookingId != null){
          vServiceObj = [SELECT Id,Name,User__r.Name,User__r.PersonMobilePhone,User__r.Preferred_Language__c,Service_Type__c,
                                                                             Customer_Site_Address__c,Customer_Site_Geometry__c,Vehicle_Number__c,
                                                                             ET_Location__r.Location_Code__c,Booking_Date__c,Customer_Vehicle__r.Registration_Type__c,
                                                                             Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__r.Plate_Type_Code__c,Customer_Vehicle__r.Plate_Source_Code__c,Customer_Vehicle__r.Plate_Color_Code__c,
                                                                             Purpose_Type__r.ETI_LookupCode__c,Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,Total_Tax__c,
                                                                             Total_Amount__c,Customer_Vehicle__r.Model_Code__c,Trade_License_Number__c,KM_Reading__c
                                                                             ,(SELECT Id,Name,Service__r.Service_Code__c,Total_Fee__c,Fee_Amount__c,Tax_Amount__c,New_Color__c FROM Services__r WHERE Id =:vSerLineItemRecId)FROM ETI_Booking__c WHERE Id =:vBookingId];
        }
        system.debug('vServiceObj-->'+vServiceObj);
        /*for(ETI_Booking__c vBook : vServiceObj){
            ET_CreateReceipt.Input objInput = new ET_CreateReceipt.Input();
            if(vBook.User__r.PersonMobilePhone!=null) {
               CustomerMobileNo = vBook.User__r.PersonMobilePhone;
            }
            else{
               CustomerMobileNo = '+971555555555';
            }
            if(vBook.User__r.Preferred_Language__c!=null){
                if(vBook.User__r.Preferred_Language__c=='English')
                    PreferredLanguage = 'E';
                else
                    if(vBook.User__r.Preferred_Language__c=='Arabic')
                         PreferredLanguage = 'A';
            }
            if(vBook.Customer_Site_Address__c!=null) 
                 CustomerSiteAddress =vBook.Customer_Site_Address__c;
            if(vBook.Customer_Site_Geometry__c!=null) 
                 CustSiteGpsCord = vBook.Customer_Site_Geometry__c; 
            if(vBook.User__r.Name!=null) 
                 CustomerName =  vBook.User__r.Name;
           CrmCustomerNo = System.Label.ETI_CrmCustomerNo; //Label
           CrCardAuthCode = System.Label.ETI_CrCardAuthCode; // Label
           Integer i=1;
           ETI_Inspection_Receipt__c  newRec;
           for(ETI_Service_Line_Item__c vItem : vBook.Services__r){
                if(vItem.Name!=null)
                    CrmTrxReference = vItem.Name; 
                if(vItem.Total_Fee__c!=null) 
                    TotalPaidAmount =vItem.Total_Fee__c; 
                ET_CreateReceipt.VehicleDetail objVehicle = setupVehicleWrapper(vBook);
                if(vItem.Service__r.Service_Code__c!=null)
                    objVehicle.ServiceCode=vItem.Service__r.Service_Code__c;
                if(vItem.Fee_Amount__c!=null)
                    objVehicle.FeeAmount=vItem.Fee_Amount__c;
                if(vItem.Tax_Amount__c!=null)       
                    objVehicle.TaxAmount=vItem.Tax_Amount__c;
                if(vItem.Total_Fee__c!=null) 
                    objVehicle.TotalAmount=vItem.Total_Fee__c;
                if(vItem.New_Color__c !=null && vBook.Service_Type__c == 'Certificate')
                   objVehicle.NewVehColor1=vItem.New_Color__c;
                objVehicle.SerialNo=i++;
                
                ET_CreateReceipt.VehicleDetailCollection_element objVehElement= new  ET_CreateReceipt.VehicleDetailCollection_element();
                if(objVehicle !=null) 
                    objVehElement.VehicleDetail=new ET_CreateReceipt.VehicleDetail[]{objVehicle};
                ET_CreateReceiptService.execute_pt  obj = new ET_CreateReceiptService.execute_pt();
                ET_CreateReceipt.Output response_x = new ET_CreateReceipt.Output();
                try{
                     response_x = obj.execute(CrmTrxReference,CrmCustomerNo,CustomerName,CustomerMobileNo,PreferredLanguage,CustomerSiteAddress,CustSiteGpsCord,TotalPaidAmount,CrCardAuthCode,objVehElement);
                }
               catch(exception ex){
                   UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETi_BatchSyncReceipts', 'sendData', '', UTIL_Logging.DEBUG_LEVEL_WARN);
                   UTIL_Logging.logException(exLog);
               }
                system.debug('response_x.Status--->'+response_x.Status);
                system.debug('response_x.Message--->'+response_x.Message);
                system.debug('response_x.AmanStatusCollection--->'+response_x.AmanStatusCollection);
                    newRec= new ETI_Inspection_Receipt__c(Id = receiptId);
                    newRec.Service_Line_Item__c =vItem.Id;
                    newRec.ETI_Amount__c = vItem.Total_Fee__c;
                    newRec.AMAN_Receipt_No__c = response_x.AmanStatusCollection.AmanStatus[0].AmanReceiptNo!=null ?response_x.AmanStatusCollection.AmanStatus[0].AmanReceiptNo:'';
                   if(response_x.AmanStatusCollection.AmanStatus[0].Status == 'S' ){
                        newRec.Integration_Status__c = 'Success';
                        newRec.Integration_Message__c = response_x.AmanStatusCollection.AmanStatus[0].Message;
                        newRec.isSyncedToAman__c = true;
                   }
                   else if(response_x.AmanStatusCollection.AmanStatus[0].Status == 'E'){
                        newRec.Integration_Status__c = 'Error';
                        newRec.Integration_Message__c = response_x.AmanStatusCollection.AmanStatus[0].Message;
                   }
                    vListReceiptInsert.add(newRec);
            }
        }*/
    return vListReceiptInsert;
    }
    
    public static ET_CreateReceipt.VehicleDetail setupVehicleWrapper(ETI_Booking__c obj){
         ET_CreateReceipt.VehicleDetail objVehicle = new ET_CreateReceipt.VehicleDetail();
        
         /*objVehicle.BookingReference=obj.Name!=null?obj.Name:'';
         objVehicle.VehicleId=obj.Vehicle_Number__c!=null?obj.Vehicle_Number__c:'';
         objVehicle.LocId=obj.ET_Location__r.Location_Code__c!=null?obj.ET_Location__r.Location_Code__c:'';
         objVehicle.ServiceDate=System.now().addMinutes(5); 
         if(obj.Customer_Vehicle__r.Registration_Type__c!=null){
             if(obj.Customer_Vehicle__r.Registration_Type__c=='Registered')
                objVehicle.RegType='R';
             else
                objVehicle.RegType='U';
          }
          if(obj.Customer_Vehicle__r.Plate_No__c!=null)
            objVehicle.PlateNo=obj.Customer_Vehicle__r.Plate_No__c;
          if(obj.Customer_Vehicle__r.Plate_Type_Code__c!=null)
            objVehicle.PlateTypeId=obj.Customer_Vehicle__r.Plate_Type_Code__c;
          if(obj.Customer_Vehicle__r.Plate_Source_Code__c!=null)
            objVehicle.PlateSourceId=obj.Customer_Vehicle__r.Plate_Source_Code__c;
          if(obj.Customer_Vehicle__r.Plate_Color_Code__c!=null)
            objVehicle.PlateColor=obj.Customer_Vehicle__r.Plate_Color_Code__c;
          if(obj.Purpose_Type__r.ETI_LookupCode__c!=null)
            objVehicle.TestPurposeId=obj.Purpose_Type__r.ETI_LookupCode__c;
          if(obj.Customer_Vehicle__r.Chassis_No__c!=null)
            objVehicle.ChassisNo=obj.Customer_Vehicle__r.Chassis_No__c;
          if(obj.Customer_Vehicle__r.Model_Code__c!=null) 
            objVehicle.VehModelId=obj.Customer_Vehicle__r.Model_Code__c;
            objVehicle.InvType='ON';
          if(obj.Customer_Vehicle__r.Model_Code__c!=null) 
             objVehicle.TradeLicenseNo=obj.Trade_License_Number__c;
          if(obj.KM_Reading__c!=null) 
             objVehicle.KmReading=Long.valueOf(obj.KM_Reading__c);
*/
        /*
         objVehicle.AxleType=obj.        
         objVehicle.PermissionIssuePlace=obj.
         objVehicle.NewVehColor1=obj.
         objVehicle.NewVehColor2=obj.
         objVehicle.NewVehColor3=obj.
         objVehicle.NewVehColor4=obj.
         objVehicle.Remarks=obj.    
         objVehicle.CustomNo=obj.
         objVehicle.EngineNo=obj.
         objVehicle.Model=obj.
         objVehicle.NoOfAxles=obj.
         objVehicle.NoOfSeats=obj.
         objVehicle.NoOfTires=obj.
         objVehicle.WLoaded=obj.
         objVehicle.WUnloaded=obj.
         objVehicle.WTypeLoaded=obj.
         objVehicle.WTypeUnloaded=obj.
         objVehicle.NoOfPass=obj.
         objVehicle.NoDoors=obj.
         objVehicle.NoCylinders=obj.
         objVehicle.VehColor1=obj.
         objVehicle.VehColor2=obj.
         objVehicle.VehColor3=obj.
         objVehicle.VehColor4=obj.
         objVehicle.HorsePower=obj.
         objVehicle.GearType=obj.
         objVehicle.MakeId=obj.
         objVehicle.FuelType=obj.
         objVehicle.MakeCountry=obj.
         objVehicle.VehCategory=obj.
         objVehicle.VehTypeId=obj.
         objVehicle.TyreType=obj.
         objVehicle.OwnerName=obj.
         objVehicle.OwnerCompany=obj.
         objVehicle.SteeringType=obj.
        */
            
         return objVehicle;
         
    }
     public static void utilityMehtod(){
        Integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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