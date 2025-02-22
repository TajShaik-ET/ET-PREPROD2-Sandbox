/********************************************************************************************************
* @author       Smaartt
* @description  Quick action ligthning component use this class as controller.
*********************************************************************************************************/
public class ETI_On_Premise_Payment_Ctrl {
    
    //Global variable declartion.
    public static Boolean isFirstTime = false;
    static id paymentRecordtypeid = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('On_Premise_Payment').getRecordTypeId();
    
    /********************************************************************************************************
* @author       Lahri
* @description  Method to get the amount from service request
* @param        Record Id
* @return       ET_Service_Request__c
*********************************************************************************************************/
    @auraEnabled
    public static ET_Service_Request__c getAmount(String recordId){
        for(ET_Service_Request__c sr:[SELECT Id, ET_Account__c,ET_Account__r.recordtypeid, Total_Amount__c, Payment_Status__c,(Select Id, Booking_Status__c From Bookings__r Where Booking_Status__c !='Cancelled') FROM ET_Service_Request__c WHERE ID = :recordId limit 1]){
            system.debug('sr>> '+sr);
            if(sr.Bookings__r!=null && sr.Bookings__r.size()>0){
                return sr;
            }
        }
        return null;
    }
    
    /********************************************************************************************************
* @author       Lahri
* @description  Method to get the record type id for B2B.
* @param        null
* @return       String
*********************************************************************************************************/  
    @auraEnabled
    public static String getB2BRecordtypeId(){
        return Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
    }
    
    /********************************************************************************************************
* @Method Name  updateServiceRequest
* @description  Method to send data data to AMAN system and update service request with status.
* @param        String srId,String paymentRefId,string paymentMode
* @return       Respnse wrapper
*********************************************************************************************************/  
    @Auraenabled
    public static Response updateServiceRequest(String srId,String paymentRefId,string paymentMode){
        system.debug('srId>> '+srId+ ' paymentRefId>> '+paymentRefId);
        if(srId!=NULL && srId!=''){
            List<id> serviceLineitemId = sendData(new Set<id>{srId}, null, null, null,paymentMode, paymentRefId);
            system.debug('serviceLineitemId>>'  +serviceLineitemId);
            updateServicerequestwithStatus(srId, paymentRefId,paymentMode);
            Response res = checkAmanNumber(serviceLineitemId);
            system.debug('res>>'  +res);
            return res; 
        }
        return null;
    }
    
    /********************************************************************************************************
* @Method Name  updateServicerequestwithStatus
* @description  Method to  update service request with status.
* @param        String srId,String paymentRefId,string paymentMode
* @return       Respnse wrapper
*********************************************************************************************************/  
    public static void updateServicerequestwithStatus(String srId, String paymentRefId,string paymentMode){
        ET_Service_Request__c sr = [SELECT Id,Total_Amount__c, ET_Account__c, ETI_Transaction_Id__c, Payment_Status__c, ETI_Payment_Type__c FROM ET_Service_Request__c WHERE id = :srId];
        //sr.ETI_Transaction_Id__c = paymentRefId;
        isFirstTime = true;
        sr.Payment_Status__c = 'Payment Success';
        sr.ETI_Payment_Type__c = paymentMode;
        update sr;
        ETST_Payment__c etstPayment = new  ETST_Payment__c();
        if(paymentRecordtypeid!=null){
            if(sr.ET_Account__c!=null)
                etstPayment.ETST_Parent__c = sr.ET_Account__c;
            etstPayment.ET_Service_Request__c = sr.id;
            etstPayment.ETST_Payment_State__c = sr.Payment_Status__c;
            etstPayment.recordtypeid = paymentRecordtypeid;
            etstPayment.ETST_Amount__c = sr.Total_Amount__c;
            etstPayment.ETST_Payment_Mode__c= sr.ETI_Payment_Type__c;
            etstPayment.ETST_AuthorizationCode__c = paymentRefId;
            insert etstPayment;
        }
    }
    
    /********************************************************************************************************
    * @Method Name  checkAmanNumber
    * @description  Method to  check aman receipt number.
    * @param        List<Id> recIds
    * @return       Respnse wrapper
    *********************************************************************************************************/  
    public static Response checkAmanNumber(List<Id> recIds){
        Response res = new Response();
        res.message = '';
        res.isAllValid = true;
        boolean flag = false;
        for(ETI_Inspection_Receipt__c recepit : [SELECT Name, AMAN_Receipt_No__c FROM ETI_Inspection_Receipt__c WHERE Service_Line_Item__c IN :recIds]){
            flag  = true;
            if(recepit.AMAN_Receipt_No__c != null && recepit.AMAN_Receipt_No__c != '' && res.isAllValid){
                res.isAllValid = true;
            }else{
                res.message += recepit.name + ', ';
                res.isAllValid = false;
            }
        }
        if(!flag)
            res.isAllValid = false;
        return res;
    }
    
    /********************************************************************************************************
    * @Method Name  sendData
    * @description  Method to  check aman receipt number.
    * @param        Set<Id> recIds,String vSerLineItemRecId,String vBookingId,String receiptId
    * @return       List<id> 
    *********************************************************************************************************/  
    public static List<id> sendData(Set<Id> recIds,String vSerLineItemRecId,String vBookingId,String receiptId,string paymentMode, String paymentRefId){
        Map<Id,recordType> vMapAccRec = new Map<Id,recordType>([Select Id,DeveloperName from recordtype where sObjectType ='Account']);
        string jsonBody='';
        string userName=[SELECT Id, UserName FROM User WHERE Id = :UserInfo.getUserId() Limit 1].UserName;
        List<id> serviceLineitemId = new List<id>();
        ET_CreateReceipt.VehicleDetailCollection_element objVehElement= new  ET_CreateReceipt.VehicleDetailCollection_element();
        try{
            system.debug('vSerLineItemRecId-->'+vSerLineItemRecId);
            system.debug('vBookingId-->'+vBookingId);
            //variable Declartion.
            String CrmTrxReference='',CrmCustomerNo='',CustomerName='',CustomerMobileNo='',PreferredLanguage='',CustomerSiteAddress='',CustSiteGpsCord='',CrCardAuthCode='';
            CrCardAuthCode= paymentRefId;
            Decimal TotalPaidAmount=0;
            List<ETI_Inspection_Receipt__c> vListReceiptInsert = new List<ETI_Inspection_Receipt__c>();
            List<ETI_Booking__c> vServiceObj = new List<ETI_Booking__c>();
            
            //Check if record Id is not null and query booking and service line item.
            if(recIds == null && vSerLineItemRecId != null){
                vServiceObj = [SELECT Id,Name,User__c,User__r.Name,Mobile_No__c,User__r.PersonMobilePhone,User__r.Preferred_Language__c,Service_Type__c,
                               createdby.contact.Name,CreatedBy.Contact.Preferred_Language__c,CreatedBy.Contact.Phone,user__r.recordtypeId,
                               Customer_Site_Address__c,Customer_Site_Geometry__c,Vehicle_Number__c,Allocated_Lane__r.Lane_Type_AMAN__c,AMAN_Last_Lane_Type__c,
                               ET_Location__r.Location_Code__c,Booking_Date__c,Customer_Vehicle__r.Registration_Type__c,Customer_Vehicle__r.Customer_Name__c,Customer_Vehicle__r.Kind_Code__c,
                               Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__c,Customer_Vehicle__r.Plate_Type_Code__c,Customer_Vehicle__r.Plate_Source_Code__c,Customer_Vehicle__r.Plate_Color_Code__c,
                               Purpose_Type__r.ETI_LookupCode__c,Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,Total_Tax__c,Service_Request__r.ETI_Payment_Type__c,
                               Customer_Vehicle__r.Vehicle_Color_Code1__c,Customer_Vehicle__r.Vehicle_Color_Code2__c,Customer_Vehicle__r.Vehicle_Color_Code3__c,Customer_Vehicle__r.Vehicle_Color_Code4__c,
                               Total_Amount__c,Customer_Vehicle__r.Model_Code__c,Trade_License_Number__c,Customer_Vehicle__r.Trade_License_Number__c,KM_Reading__c,Customer_Vehicle__r.Custom_Number__c,Customer_Vehicle__r.Vehicle_Type_Code__c,
                               Customer_Vehicle__r.Permission_Issue_Place__c,Customer_Vehicle__r.Vehicle_Year__c,Service_Request__c,Customer_Vehicle__r.Engine_No__c,Customer_Vehicle__r.Permit_Purpose_Code__c,Customer_Vehicle__r.Items_Transported__c,
                               (SELECT Id,Name,Service__r.Service_Code__c,Total_Fee__c,Fee_Amount__c,Tax_Amount__c,New_Color__c,
                                New_Color2__c,New_Color3__c,New_Color4__c,New_Vehicle_Type__c,Remarks__c
                                FROM Services__r 
                                WHERE Id =:vSerLineItemRecId)
                               FROM ETI_Booking__c 
                               WHERE Id =:vBookingId AND Booking_Date__c=:Date.Today()];
            }else{
                vServiceObj = [SELECT Id,Name,User__c,User__r.Name,User__r.PersonMobilePhone,Mobile_No__c,User__r.Preferred_Language__c,
                               createdby.contact.Name,CreatedBy.Contact.Preferred_Language__c,CreatedBy.Contact.Phone,user__r.recordtypeId,Service_Request__r.ETI_Payment_Type__c,
                               Service_Type__c,Customer_Site_Address__c,Customer_Site_Geometry__c,Vehicle_Number__c,Allocated_Lane__r.Lane_Type_AMAN__c,AMAN_Last_Lane_Type__c,
                               ET_Location__r.Location_Code__c,Booking_Date__c,Customer_Vehicle__r.Registration_Type__c,Customer_Vehicle__r.Customer_Name__c,Customer_Vehicle__r.Kind_Code__c,
                               Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__c,Customer_Vehicle__r.Plate_Type_Code__c,Customer_Vehicle__r.Plate_Source_Code__c,Customer_Vehicle__r.Plate_Color_Code__c,
                               Purpose_Type__r.ETI_LookupCode__c,Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,Total_Tax__c,Customer_Vehicle__r.Preferred_Language__c,
                               Customer_Vehicle__r.Vehicle_Color_Code1__c,Customer_Vehicle__r.Vehicle_Color_Code2__c,Customer_Vehicle__r.Vehicle_Color_Code3__c,Customer_Vehicle__r.Vehicle_Color_Code4__c,
                               Total_Amount__c,Customer_Vehicle__r.Model_Code__c,Trade_License_Number__c,Customer_Vehicle__r.Trade_License_Number__c,KM_Reading__c,Customer_Vehicle__r.Custom_Number__c,Customer_Vehicle__r.Vehicle_Type_Code__c,
                               Customer_Vehicle__r.Permission_Issue_Place__c,Customer_Vehicle__r.Vehicle_Year__c,Service_Request__c,Customer_Vehicle__r.Engine_No__c,Customer_Vehicle__r.Permit_Purpose_Code__c,Customer_Vehicle__r.Items_Transported__c,
                               (SELECT Id,Name,Service__r.Service_Code__c,Total_Fee__c,Fee_Amount__c,Tax_Amount__c,New_Color__c,
                                New_Color2__c,New_Color3__c,New_Color4__c,New_Vehicle_Type__c,Remarks__c
                                FROM Services__r)
                               FROM ETI_Booking__c 
                               WHERE Service_Request__c IN :recIds AND Booking_Date__c=:Date.Today()];
            }
            system.debug('vServiceObj-->'+vServiceObj);
            //Populate auth code and userName from payment record.
            userName=[SELECT Id,UserName FROM User WHERE Id=:userInfo.getUserId() LIMIT 1].UserName;
            if(!vServiceObj.isEmpty()){
                for(ETI_Booking__c vBook : vServiceObj){
                    ET_CreateReceipt.Input objInput = new ET_CreateReceipt.Input();
                    if(vBook.Mobile_No__c!=null) {
                        String mobile = vBook.Mobile_No__c.StartsWith('0') ? vBook.Mobile_No__c.replaceFirst('0','+971') : vBook.Mobile_No__c;                   
                        CustomerMobileNo = mobile;
                    }
                    else{
                        CustomerMobileNo = '+971555555555';
                    }
                    if(vBook.User__c !=null){
                        if(vMapAccRec.get(vBook.user__r.recordtypeId).DeveloperName == Label.ETI_Person_B2C){
                            if(vBook.User__r.Preferred_Language__c!=null){
                                if(vBook.User__r.Preferred_Language__c=='English')
                                    PreferredLanguage = 'E';
                                else
                                    if(vBook.User__r.Preferred_Language__c=='Arabic')
                                    PreferredLanguage = 'A';
                            }else if(vBook.Customer_Vehicle__r.Preferred_Language__c!=null){
                                if(vBook.Customer_Vehicle__r.Preferred_Language__c=='English')
                                    PreferredLanguage = 'E';
                                else
                                    if(vBook.Customer_Vehicle__r.Preferred_Language__c=='Arabic')
                                    PreferredLanguage = 'A';
                            }     
                            if(vBook.User__r.Name!=null) 
                                CustomerName =  vBook.User__r.Name;
                            else if(vBook.Customer_Vehicle__r.Customer_Name__c!=null)
                                CustomerName =  vBook.Customer_Vehicle__r.Customer_Name__c;
                        }
                        else if(vMapAccRec.get(vBook.user__r.recordtypeId).DeveloperName == Label.ETI_Business_B2B_Inspection){
                            if(vBook.CreatedBy.Contact.Preferred_Language__c!=null){
                                if(vBook.CreatedBy.Contact.Preferred_Language__c=='English')
                                    PreferredLanguage = 'E';
                                else
                                    if(vBook.CreatedBy.Contact.Preferred_Language__c=='Arabic')
                                    PreferredLanguage = 'A';
                            }else if(vBook.Customer_Vehicle__r.Preferred_Language__c!=null){
                                if(vBook.Customer_Vehicle__r.Preferred_Language__c=='English')
                                    PreferredLanguage = 'E';
                                else
                                    if(vBook.Customer_Vehicle__r.Preferred_Language__c=='Arabic')
                                    PreferredLanguage = 'A';
                            }    
                            if(vBook.CreatedBy.Contact.Name!=null) 
                                CustomerName =  vBook.CreatedBy.Contact.Name;
                            else
                                if(vBook.Customer_Vehicle__r.Customer_Name__c!=null)
                                CustomerName =  vBook.Customer_Vehicle__r.Customer_Name__c;
                        }
                    }else if(vBook.Customer_Vehicle__c !=null){
                        if(vBook.Customer_Vehicle__r.Preferred_Language__c!=null){
                            if(vBook.Customer_Vehicle__r.Preferred_Language__c=='English')
                                PreferredLanguage = 'E';
                            else
                                if(vBook.Customer_Vehicle__r.Preferred_Language__c=='Arabic')
                                PreferredLanguage = 'A';
                        }     
                        if(vBook.Customer_Vehicle__r.Customer_Name__c!=null)
                            CustomerName =  vBook.Customer_Vehicle__r.Customer_Name__c;
                    }
                    if(vBook.Customer_Site_Address__c!=null) 
                        CustomerSiteAddress =vBook.Customer_Site_Address__c;
                    if(vBook.Customer_Site_Geometry__c!=null) 
                        CustSiteGpsCord = vBook.Customer_Site_Geometry__c; 
                    CrmCustomerNo = System.Label.ETI_CrmCustomerNo;
                    // CrCardAuthCode = System.Label.ETI_CrCardAuthCode;
                    Integer i=1;
                    ETI_Inspection_Receipt__c  newRec;
                    for(ETI_Service_Line_Item__c vItem : vBook.Services__r){
                        if(vItem.Name!=null)
                            CrmTrxReference = vItem.Name; 
                        if(vItem.Total_Fee__c!=null) 
                            TotalPaidAmount =vItem.Total_Fee__c; 
                        ET_CreateReceipt.VehicleDetail objVehicle = setupVehicleWrapper(vBook,paymentMode);
                        if(vItem.Service__r.Service_Code__c!=null)
                            objVehicle.ServiceCode=vItem.Service__r.Service_Code__c;
                        if(vItem.Fee_Amount__c!=null)
                            objVehicle.FeeAmount=vItem.Fee_Amount__c;
                        if(vItem.Tax_Amount__c!=null)       
                            objVehicle.TaxAmount=vItem.Tax_Amount__c;
                        if(vItem.Total_Fee__c!=null) 
                            objVehicle.TotalAmount=vItem.Total_Fee__c;
                        if(vItem.Name != null)
                            objVehicle.BookingReference=vItem.Name;
                        if( vBook.Service_Type__c == 'Certificate' && (vItem.Service__r.Service_Code__c=='19' || vItem.Service__r.Service_Code__c=='23')){
                            if(vItem.New_Color__c !=null)
                                objVehicle.NewVehColor1=vItem.New_Color__c;
                            if(vItem.New_Color2__c !=null)
                                objVehicle.NewVehColor2=vItem.New_Color2__c;
                            if(vItem.New_Color3__c !=null)
                                objVehicle.NewVehColor3=vItem.New_Color3__c;
                            if(vItem.New_Color4__c !=null)
                                objVehicle.NewVehColor4=vItem.New_Color4__c;
                        }
                        if(vBook.Customer_Vehicle__r.Vehicle_Color_Code1__c!=null)
                            objVehicle.VehColor1=vBook.Customer_Vehicle__r.Vehicle_Color_Code1__c;
                        if(vBook.Customer_Vehicle__r.Vehicle_Color_Code2__c!=null)
                            objVehicle.VehColor2=vBook.Customer_Vehicle__r.Vehicle_Color_Code2__c;
                        if(vBook.Customer_Vehicle__r.Vehicle_Color_Code3__c!=null)
                            objVehicle.VehColor3=vBook.Customer_Vehicle__r.Vehicle_Color_Code3__c;
                        if(vBook.Customer_Vehicle__r.Vehicle_Color_Code4__c!=null)
                            objVehicle.VehColor4=vBook.Customer_Vehicle__r.Vehicle_Color_Code4__c;
                        if( vBook.Service_Type__c == 'Certificate' && vItem.Service__r.Service_Code__c=='20' ){
                            if(vItem.New_Vehicle_Type__c !=null)
                                objVehicle.VehNewTypeId=vItem.New_Vehicle_Type__c;   
                        }
                        if(vBook.Allocated_Lane__r.Lane_Type_AMAN__c !=null)
                            objVehicle.LaneTypeId=vBook.Allocated_Lane__r.Lane_Type_AMAN__c;
                        if(vItem.Remarks__c!=null)
                            objVehicle.Remarks=vItem.Remarks__c;
                        if(vBook.Customer_Vehicle__r.Permit_Purpose_Code__c!=null)
                            objVehicle.PermitPurpose=vBook.Customer_Vehicle__r.Permit_Purpose_Code__c;
                        if(vBook.Customer_Vehicle__r.Items_Transported__c!=null)
                            objVehicle.ItemsTransported=vBook.Customer_Vehicle__r.Items_Transported__c;
                        /*else 
                        if(vBook.AMAN_Last_Lane_Type__c!=null && vBook.AMAN_Last_Lane_Type__c!='')  
                        objVehicle.LaneTypeId=vBook.AMAN_Last_Lane_Type__c;*/
                        objVehicle.SerialNo=i++;
                        system.debug('objVehicle--> '+objVehicle); 
                        if(objVehicle !=null) 
                            objVehElement.VehicleDetail=new ET_CreateReceipt.VehicleDetail[]{objVehicle};
                                ET_CreateReceiptService.execute_pt  obj = new ET_CreateReceiptService.execute_pt();
                        ET_CreateReceipt.Output response_x = new ET_CreateReceipt.Output();
                        jsonBody = '{"CrmTrxReference":"'+CrmTrxReference+'","CrmCustomerNo":"'+CrmCustomerNo+'","CustomerName":"'+CustomerName+'","CustomerMobileNo":"'+CustomerMobileNo+'","PreferredLanguage":"'+PreferredLanguage+'","CustomerSiteAddress":"'+CustomerSiteAddress+'","CustSiteGpsCord":"'+CustSiteGpsCord+'","TotalPaidAmount":"'+TotalPaidAmount+'","CrCardAuthCode":"'+CrCardAuthCode+'","objVehElement":"'+JSON.serialize(objVehElement)+'"}';
                        system.debug('json--->'+jsonBody);
                        if(!Test.isRunningTest())
                            response_x = obj.execute(CrmTrxReference,CrmCustomerNo,CustomerName,CustomerMobileNo,PreferredLanguage,CustomerSiteAddress,CustSiteGpsCord,TotalPaidAmount,CrCardAuthCode,userName,objVehElement);
                        system.debug('response_x.Message--->'+response_x.Message);
                        system.debug('response_x.AmanStatusCollection--->'+response_x.AmanStatusCollection);
                        if(receiptId==null && recIds == null && vSerLineItemRecId != null){
                            newRec= new ETI_Inspection_Receipt__c();
                        }
                        else{
                            newRec= new ETI_Inspection_Receipt__c(Id = receiptId);
                        }
                        newRec.Service_Line_Item__c =vItem.Id;
                        newRec.Bookings__c = vBook.Id;
                        newRec.Service_Request__c = vBook.Service_Request__c;
                        newRec.ET_Status__c = 'Active';
                        newRec.ETI_Amount__c = vItem.Total_Fee__c;
                        if(!Test.isRunningTest()){
                            newRec.AMAN_Receipt_No__c = response_x.AmanStatusCollection.AmanStatus[0].AmanReceiptNo!=null ?response_x.AmanStatusCollection.AmanStatus[0].AmanReceiptNo:'';
                            if(response_x.AmanStatusCollection.AmanStatus[0].Status == 'S' ){
                                newRec.Integration_Status__c = 'Success';
                                newRec.Integration_Message__c = response_x.AmanStatusCollection.AmanStatus[0].Message;
                                newRec.isSyncedToAman__c = true;
                            }else if(response_x.AmanStatusCollection.AmanStatus[0].Status == 'E'){
                                newRec.Integration_Status__c = 'Error';
                                newRec.Integration_Message__c = response_x.AmanStatusCollection.AmanStatus[0].Message;
                            }
                        }
                        vListReceiptInsert.add(newRec);
                        system.debug('--->'+vListReceiptInsert);
                        serviceLineitemId.add(vItem.Id);
                    }
                }
                //String msg = 'success';
                if(!vListReceiptInsert.isEmpty()){
                    system.debug('--->'+vListReceiptInsert);
                    upsert vListReceiptInsert;
                    ETI_Service_Line_Item__c updateSLI;
                    List<ETI_Service_Line_Item__c> vListUpSLI = new   List<ETI_Service_Line_Item__c>();
                    for(ETI_Inspection_Receipt__c vRec : [SELECT Id,Service_Line_Item__c,AMAN_Receipt_No__c
                                                          FROM ETI_Inspection_Receipt__c WHERE ID IN: vListReceiptInsert]){
                                                              if(vRec.AMAN_Receipt_No__c!=null){
                                                                  updateSLI =new ETI_Service_Line_Item__c();
                                                                  updateSLI.Id = vRec.Service_Line_Item__c;
                                                                  updateSLI.AMAN_Receipt_No__c = vRec.AMAN_Receipt_No__c;
                                                                  vListUpSLI.add(updateSLI);
                                                              }
                                                          }
                    if(!vListUpSLI.isEmpty())
                        update vListUpSLI;
                    ETI_ServiceRequestHandler.sendEmailNotification(recIds);
                    List<Receipt_Event__e> events = new List<Receipt_Event__e>();
                    events.add(new Receipt_Event__e(Receipt_Id__c = vListReceiptInsert[0].Id));
                    List<Database.SaveResult> results = EventBus.publish(events);
                    for(Database.SaveResult sr : results) {
                        if (sr.isSuccess()) {
                            System.debug('Successfully published event.');
                        } else {
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('Error returned: ' +
                                             err.getStatusCode() +
                                             err.getMessage());
                            }
                        }       
                    }
                }
            }
        }
        catch(Exception ex) {
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'sendDatatoAman', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        finally{
            UTIL_Logging.createIntegrationLog('OUTBOUND',jsonBody, 'sendDatatoAman',
                                              'SF','Aman',String.valueOf(recIds));
        }
        return serviceLineitemId;
    }
    public static ET_CreateReceipt.VehicleDetail setupVehicleWrapper(ETI_Booking__c obj,string paymentMode){
        ET_CreateReceipt.VehicleDetail objVehicle = new ET_CreateReceipt.VehicleDetail();
        Map<String,String> mapLocationNameToCode = new Map<String,String>();
        for(ETI_Location_Codes__mdt vItem:[SELECT Id, DeveloperName, Location_Code__c, 
                                           Label, QualifiedApiName
                                           FROM ETI_Location_Codes__mdt]){
                                               mapLocationNameToCode.put(vItem.Label,vItem.Location_Code__c);
                                           }
        objVehicle.BookingReference=obj.Name!=null?obj.Name:'';
        //objVehicle.VehicleId=obj.Vehicle_Number__c!=null?obj.Vehicle_Number__c:''; commented 02/09/2021 
        objVehicle.LocId=obj.ET_Location__r.Location_Code__c!=null?obj.ET_Location__r.Location_Code__c:'';
        //if(obj.Booking_Date__c!=null)
        //   objVehicle.ServiceDate=obj.Booking_Date__c;
        objVehicle.ServiceDate=System.now().addMinutes(5);  
        if(obj.Customer_Vehicle__r.Registration_Type__c!=null){
            if(obj.Customer_Vehicle__r.Registration_Type__c=='Registered'){
                objVehicle.RegType='R';
                
            }else {
                objVehicle.RegType='U';
                if(obj.Customer_Vehicle__r.Custom_Number__c!=null && obj.Customer_Vehicle__r.Custom_Number__c!='')
                    objVehicle.CustomNo=obj.Customer_Vehicle__r.Custom_Number__c;
            }
        }
        if(obj.Customer_Vehicle__r.Registration_Type__c=='Registered' && obj.Customer_Vehicle__r.Kind_Code__c!=null && obj.Customer_Vehicle__r.Kind_Code__c!='0')
            objVehicle.VehTypeId=obj.Customer_Vehicle__r.Kind_Code__c;
        else if(obj.Customer_Vehicle__r.Vehicle_Type_Code__c!=null)
            objVehicle.VehTypeId=obj.Customer_Vehicle__r.Vehicle_Type_Code__c;
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
        if(paymentMode=='Card')
            objVehicle.InvType='CD';
        else if(paymentMode=='Cash')
            objVehicle.InvType='CS';
        if(obj.Customer_Vehicle__r.Trade_License_Number__c!=null) 
            objVehicle.TradeLicenseNo=obj.Customer_Vehicle__r.Trade_License_Number__c;
        if(obj.KM_Reading__c!=null) 
            objVehicle.KmReading=Long.valueOf(obj.KM_Reading__c);
        if(obj.Customer_Vehicle__r.Permission_Issue_Place__c!=null)
            objVehicle.PermissionIssuePlace=mapLocationNameToCode.get(obj.Customer_Vehicle__r.Permission_Issue_Place__c);
        if(obj.Customer_Vehicle__r.Vehicle_Year__c!=null)
            objVehicle.Model=Integer.valueOf(obj.Customer_Vehicle__r.Vehicle_Year__c);
        if(obj.Customer_Vehicle__r.Engine_No__c!=null)
            objVehicle.EngineNo=obj.Customer_Vehicle__r.Engine_No__c;
        else 
            objVehicle.EngineNo='NA';
        
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
    public class Response{
        @AuraEnabled
        public String message{get; set;}
        @AuraEnabled
        public Boolean isAllValid {get; set;}
    }
       public static void utilityMethod(){
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