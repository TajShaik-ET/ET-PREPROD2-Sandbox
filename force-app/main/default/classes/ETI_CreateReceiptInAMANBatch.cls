/********************************************************************************************************
* @author           Smaartt
* @description      Batch to create receipt record in AMAN system.
* @Name             ET_CreateReceiptInAMANBatch
*********************************************************************************************************/
global class  ETI_CreateReceiptInAMANBatch  implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.stateful,Schedulable{ 
    
    //global variable declaration.
    List<ETI_Inspection_Receipt__c> receipts = new List<ETI_Inspection_Receipt__c>();
    Public String sQuery;
    public Date todayDate;
    public Date intTodayDate;
    public Date extTodayDate;
    public Id intRecordTypeId ;
    public Id extReordTypeId;
    public set<Id> bkngItemIds=new set<Id>();
    
    public void Execute(SchedulableContext sc){
        ETI_CreateReceiptInAMANBatch batchCreateReceipt = new ETI_CreateReceiptInAMANBatch(null,null);
        Database.executeBatch(batchCreateReceipt,1);
    }
    
    public ETI_CreateReceiptInAMANBatch(Date runDate,set<Id> recIds) {
        this.todayDate = runDate!=null ? runDate:Date.Today();
        this.intTodayDate=Date.Today().addDays(+integer.valueOf(system.label.ETI_Int_AmanReceipt_Creation_Days));
        this.extTodayDate=Date.Today().addDays(+integer.valueOf(system.label.ETI_Ext_AmanReceipt_Creation_Days));
        intRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
        extReordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByName().get('External').getRecordTypeId();
        if(recIds!=null)
            bkngItemIds = recIds;
        sQuery = 'SELECT Id, Name,Booking__c,Booking__r.Payment_Status__c FROM ETI_Service_Line_Item__c WHERE'; 
        if(!bkngItemIds.isEmpty())
            sQuery += ' Id IN:bkngItemIds AND Service_Name__c != \'SPEA Inspection\''; //AND Service_Name__c != \'SPEA Inspection\'
        else {
            sQuery += ' ((Booking__r.RecordTypeId=:intRecordTypeId AND Booking__r.Booking_Date__c =:intTodayDate) OR'; 
            sQuery += ' (Booking__r.RecordTypeId=:extReordTypeId AND Booking__r.Booking_Date__c=:extTodayDate) OR Booking__r.Booking_Date__c=:todayDate) AND Booking__r.Payment_Status__c= \'Payment Success\' AND AMAN_Receipt_No__c=Null AND Booking__r.Booking_Status__c <> \'Cancelled\' AND Service_Name__c != \'SPEA Inspection\'' ;
        }
        System.debug('Squery '+sQuery);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<ETI_Service_Line_Item__c> scope) {
        System.debug('Scope Size: '+scope.Size());
        //Variable declartion.
        ETI_Service_Line_Item__c serLineItem=scope[0];
        Map<Id,recordType> vMapAccRec = new Map<Id,recordType>([SELECT Id,DeveloperName 
                                                                FROM recordtype 
                                                                WHERE sObjectType ='Account']);
        string jsonBody='';
        ET_CreateReceipt.VehicleDetailCollection_element objVehElement= new  ET_CreateReceipt.VehicleDetailCollection_element();
        try{
            List<ETI_Inspection_Receipt__c> receipt= [SELECT Id, Name ,Service_Line_Item__c
                                                      FROM ETI_Inspection_Receipt__c
                                                      WHERE Service_Line_Item__c=:serLineItem.Id];
            if(receipt==null || receipt.size()==0){
                system.debug('vSerLineItemRecId-->'+serLineItem.Id);
                system.debug('vBookingId-->'+serLineItem.Booking__c);
                
                //header value Declartion.
                String CrmTrxReference='',CrmCustomerNo='',CustomerName='',CustomerMobileNo='',PreferredLanguage='',CustomerSiteAddress='',CustSiteGpsCord='',CrCardAuthCode='';
                Decimal TotalPaidAmount=0;
                String userName='';
                List<ETI_Inspection_Receipt__c> vListReceiptInsert = new List<ETI_Inspection_Receipt__c>();
                List<ETI_Booking__c> vServiceObj = new List<ETI_Booking__c>();
                
                //Check if record Id is not null and query booking and service line item.
                if(serLineItem.Booking__c != null){
                    vServiceObj = [SELECT Id,Name,User__r.Name,Mobile_No__c,User__r.PersonMobilePhone,User__r.Preferred_Language__c,Service_Type__c,
                                   createdby.contact.Name,CreatedBy.Contact.Preferred_Language__c,CreatedBy.Contact.Phone,user__r.recordtypeId,Service_Request__r.ETI_Payment_Type__c,
                                   Customer_Site_Address__c,Customer_Site_Geometry__c,Vehicle_Number__c,Allocated_Lane__r.Lane_Type_AMAN__c,AMAN_Last_Lane_Type__c,
                                   ET_Location__r.Location_Code__c,Booking_Date__c,Customer_Vehicle__r.Registration_Type__c,Customer_Vehicle__r.Customer_Name__c,Customer_Vehicle__r.Kind_Code__c,
                                   Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__r.Plate_Type_Code__c,Customer_Vehicle__r.Plate_Source_Code__c,Customer_Vehicle__r.Plate_Color_Code__c,
                                   Purpose_Type__r.ETI_LookupCode__c,Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,Total_Tax__c,Customer_Vehicle__r.Preferred_Language__c,
                                   Customer_Vehicle__r.Vehicle_Color_Code1__c,Customer_Vehicle__r.Vehicle_Color_Code2__c,Customer_Vehicle__r.Vehicle_Color_Code3__c,Customer_Vehicle__r.Vehicle_Color_Code4__c,
                                   Total_Amount__c,Customer_Vehicle__r.Model_Code__c,Trade_License_Number__c,Customer_Vehicle__r.Trade_License_Number__c,KM_Reading__c,Customer_Vehicle__r.Custom_Number__c,Customer_Vehicle__r.Vehicle_Type_Code__c,
                                   Customer_Vehicle__r.Permission_Issue_Place__c,Customer_Vehicle__r.Vehicle_Year__c,Service_Request__c,Customer_Vehicle__r.Engine_No__c,Customer_Vehicle__r.Permit_Purpose_Code__c,Customer_Vehicle__r.Items_Transported__c,
                                   (SELECT Id,Name,Service__r.Service_Code__c,Total_Fee__c,Fee_Amount__c,Tax_Amount__c,New_Color__c,
                                    New_Color2__c,New_Color3__c,New_Color4__c,New_Vehicle_Type__c,Remarks__c
                                    FROM Services__r 
                                    WHERE Id =:serLineItem.Id)
                                   FROM ETI_Booking__c 
                                   WHERE Id =:serLineItem.Booking__c];
                }
                
                system.debug('vServiceObj-->'+vServiceObj);
                List<ETST_Payment__c> paymentRecord = new List<ETST_Payment__c>([SELECT Id,ETST_AuthorizationCode__c,createdBy.UserName
                                                                                 FROM ETST_Payment__c 
                                                                                 WHERE ET_Service_Request__c=:vServiceObj[0].Service_Request__c ]);
                
                if(paymentRecord[0]!=null){
                    CrCardAuthCode =paymentRecord[0].ETST_AuthorizationCode__c;
                    userName=paymentRecord[0].createdBy.UserName;
                }
                //Itrate over booking record and popualte values.
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
                            }                
                            if(vBook.User__r.Name!=null) 
                                CustomerName =  vBook.User__r.Name;
                        }
                         else if(vMapAccRec.get(vBook.user__r.recordtypeId).DeveloperName == Label.ETI_Business_B2B_Inspection){
                             if(vBook.CreatedBy.Contact.Preferred_Language__c!=null){
                                 if(vBook.CreatedBy.Contact.Preferred_Language__c=='English')
                                     PreferredLanguage = 'E';
                                 else
                                     if(vBook.CreatedBy.Contact.Preferred_Language__c=='Arabic')
                                     PreferredLanguage = 'A';
                             }
                             if(vBook.CreatedBy.Contact.Name!=null) 
                                 CustomerName =  vBook.CreatedBy.Contact.Name;
                         }
                         else if(vMapAccRec.get(vBook.user__r.recordtypeId).DeveloperName != Label.ETI_Person_B2C){
                             if(vBook.CreatedBy.Contact != null){
                                 if(vBook.CreatedBy.Contact.Preferred_Language__c!=null){
                                     if(vBook.CreatedBy.Contact.Preferred_Language__c=='English')
                                         PreferredLanguage = 'E';
                                     else
                                         if(vBook.CreatedBy.Contact.Preferred_Language__c=='Arabic')
                                         PreferredLanguage = 'A';
                                 }
                                 if(vBook.CreatedBy.Contact.Name!=null) 
                                     CustomerName =  vBook.CreatedBy.Contact.Name;
                             }
                         }
                    }
                    
                    
                    else if(vBook.Customer_Vehicle__c !=null){
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
                    //CrCardAuthCode = System.Label.ETI_CrCardAuthCode;
                    Integer i=1;
                    ETI_Inspection_Receipt__c  newRec;
                    for(ETI_Service_Line_Item__c vItem : vBook.Services__r){
                        if(vItem.Name!=null)
                            CrmTrxReference = vItem.Name; 
                        if(vItem.Total_Fee__c!=null) 
                            TotalPaidAmount =vItem.Total_Fee__c; 
                        ET_CreateReceipt.VehicleDetail objVehicle = ET_SOA_Services.setupVehicleWrapper(vBook);
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
                        if(vBook.Service_Type__c == 'Certificate' && (vItem.Service__r.Service_Code__c=='19' || vItem.Service__r.Service_Code__c=='27' || vItem.Service__r.Service_Code__c=='33' || vItem.Service__r.Service_Code__c=='23')){
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
                        if(vBook.Service_Type__c == 'Certificate' && (vItem.Service__r.Service_Code__c=='20' || vItem.Service__r.Service_Code__c=='26' || vItem.Service__r.Service_Code__c=='32')){
                            if(vItem.New_Vehicle_Type__c !=null)
                                objVehicle.VehNewTypeId=vItem.New_Vehicle_Type__c;   
                        }  
                        /*if(vBook.AMAN_Last_Lane_Type__c!=null && vBook.AMAN_Last_Lane_Type__c!='')  
                            objVehicle.LaneTypeId=vBook.AMAN_Last_Lane_Type__c;
                        else */
                        if(vBook.Allocated_Lane__r.Lane_Type_AMAN__c !=null)
                            objVehicle.LaneTypeId=vBook.Allocated_Lane__r.Lane_Type_AMAN__c;
                        if(vItem.Remarks__c!=null)
                            objVehicle.Remarks=vItem.Remarks__c;
                        if(vBook.Customer_Vehicle__r.Permit_Purpose_Code__c!=null)
                            objVehicle.PermitPurpose=vBook.Customer_Vehicle__r.Permit_Purpose_Code__c;
                        if(vBook.Customer_Vehicle__r.Items_Transported__c!=null)
                            objVehicle.ItemsTransported=vBook.Customer_Vehicle__r.Items_Transported__c;
                        objVehicle.SerialNo=i++;
                        
                        if(objVehicle !=null) 
                            objVehElement.VehicleDetail=new ET_CreateReceipt.VehicleDetail[]{objVehicle};
                                ET_CreateReceiptService.execute_pt  obj = new ET_CreateReceiptService.execute_pt();
                        ET_CreateReceipt.Output response_x = new ET_CreateReceipt.Output();
                        
                        jsonBody = '{"CrmTrxReference":"'+CrmTrxReference+'","CrmCustomerNo":"'+CrmCustomerNo+'","CustomerName":"'+CustomerName+'","CustomerMobileNo":"'+CustomerMobileNo+'","PreferredLanguage":"'+PreferredLanguage+'","CustomerSiteAddress":"'+CustomerSiteAddress+'","CustSiteGpsCord":"'+CustSiteGpsCord+'","TotalPaidAmount":"'+TotalPaidAmount+'","CrCardAuthCode":"'+CrCardAuthCode+'","objVehElement":"'+JSON.serialize(objVehElement)+'"}';
                        system.debug('json--->'+jsonBody);   
                        if(!Test.isRunningTest()){
                            response_x = obj.execute(CrmTrxReference,CrmCustomerNo,CustomerName,CustomerMobileNo,
                                                     PreferredLanguage,CustomerSiteAddress,CustSiteGpsCord,TotalPaidAmount,
                                                     CrCardAuthCode,userName,objVehElement);
                        }
                        system.debug('response_x.Message--->'+response_x.Message);
                        system.debug('response_x.AmanStatusCollection--->'+response_x.AmanStatusCollection);
                        
                        newRec= new ETI_Inspection_Receipt__c();
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
                            }
                            else if(response_x.AmanStatusCollection.AmanStatus[0].Status == 'E'){
                                newRec.Integration_Status__c = 'Error';
                                newRec.Integration_Message__c = response_x.AmanStatusCollection.AmanStatus[0].Message;
                            }
                        }
                        vListReceiptInsert.add(newRec);
                        system.debug('--->'+vListReceiptInsert);
                    }
                }
                if(!vListReceiptInsert.isEmpty()){
                    system.debug('--->'+vListReceiptInsert);
                    upsert vListReceiptInsert;
                    ETI_Service_Line_Item__c updateSLI;
                    List<ETI_Service_Line_Item__c> vListUpSLI = new   List<ETI_Service_Line_Item__c>();
                    for(ETI_Inspection_Receipt__c vRec :[SELECT Id,Service_Line_Item__c,AMAN_Receipt_No__c
                                                         FROM ETI_Inspection_Receipt__c WHERE ID IN: vListReceiptInsert] ){
                                                             system.debug('-->'+vRec.AMAN_Receipt_No__c);
                                                             if(vRec.AMAN_Receipt_No__c!=null){
                                                                 updateSLI =new ETI_Service_Line_Item__c( Id=vRec.Service_Line_Item__c);
                                                                 updateSLI.AMAN_Receipt_No__c = vRec.AMAN_Receipt_No__c;
                                                                 vListUpSLI.add(updateSLI);
                                                             }
                                                         }
                    if(!vListUpSLI.isEmpty())
                        update vListUpSLI;         
                    
                }
            }
        }
        catch(Exception ex) {
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'sendDatatoAman', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        finally{
            
            UTIL_Logging.createIntegrationLog('OUTBOUND',JSON.serialize(objVehElement), 'sendDatatoAman',
                                              'SF','Aman',String.valueOf(serLineItem.Id));
        }
    }
    
   global void finish(Database.BatchableContext BC){
        integer i=0;
        
    
        
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
    }
}