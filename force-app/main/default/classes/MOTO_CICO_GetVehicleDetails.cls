/*
Developer Name - Srihari Koyila
Developed Date - 08 June 2023
Class Name     - MOTO_CICO_GetVehicleDetails
Class purpose  - this class contains POST method for MOTO_CICO_GetVehicleDetails .
Test Class: MOTO_IntegrationTest , Oracle_Integration_Mock

-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              25/11/22           Initial Version 
2.          v2.0              13/04/23           Update response info
****************************************************************************************************************/         

public without sharing class MOTO_CICO_GetVehicleDetails{
    @AuraEnabled
    public static string GetVehicleDetails(string ChassisNumber,string recordId){
        string resVal = null;
        system.debug(ChassisNumber);
        system.debug(recordId);
        
        
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('MOTO_GetVehicleDetails');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        try{
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization','Basic '+paramvalue);   
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
            
             list<Opportunity> accid =[select Id,Account.Id from Opportunity where Id=:recordId limit 1];
             system.debug('GetVehicleDetails-accid--'+accid);
            if(accid.size()>0){
                account acc = new account(id=accId[0].AccountId);
                Opportunity Oppnty = new Opportunity(id=recordId);

                if(response.getStatusCode() == 200){      
                 
                MOTO_GetVehicleDetailWrapper res = MOTO_GetVehicleDetailWrapper.parse(response.getBody());
                 
                    if(res.Status =='S'){
                        
                        MOTO_GetVehicleDetailWrapper.VehicleCollection veh = res.VehicleCollection;
                       
                        if(veh != null && veh.XxetVehicleMasterDetailV.size()>0){
                            MOTO_GetVehicleDetailWrapper.XxetVehicleMasterDetailV vehInfo= veh.XxetVehicleMasterDetailV[0];
                                                        
                            Oppnty.Vehicle_Internal_Number__c =(String)(vehInfo.internalNo);
                            Oppnty.Vehicle_Plate_Number__c =(String)(vehInfo.plateNumber);
                            Oppnty.Vehicle_Mileage_number__c =(Decimal)(vehInfo.odometer);
                            Oppnty.Chassis_Number__c =ChassisNumber;
                            Oppnty.Integration_Message__c = 'Private Vehicle is created successfully in ERP';
                            resVal =Oppnty.Integration_Message__c;
                            update Oppnty;
                           
                            if(vehInfo.customerNumber != null){
                                acc.AccountNumber =vehInfo.customerNumber;
                       	        acc.ETSALES_Customer_Account_Id__c =(String)(vehInfo.customerId);
                                update acc;
                            }else{
                                string accresVal='--No Account';
                                resVal +=accresVal;
                            }
                            
                            
                        }else{
                             resVal ='No Vehicle';
                        }
                        
                                               
                    }else{
                        
                       resVal ='Error in Status';
                    }
                    
                }else{                    
                   
                   resVal ='Error in response';
                }
                
            }else{
                  resVal ='Error in accid';
            }
			
        }catch(Exception e){    //throw all other exception message  
            system.debug(e.getMessage());
            system.debug('---ca'+e.getCause());
            system.debug('----Line'+e.getLineNumber());
            system.debug('---Trac-'+e.getStackTraceString());
            system.debug('---Type-'+e.getTypeName());
            throw new AuraHandledException(e.getMessage());} 
        return resVal;
    }
    
    
    
    
    
}