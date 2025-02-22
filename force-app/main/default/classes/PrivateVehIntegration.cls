/*
 Developer Name - Srihari Koyila
 Developed Date - 25 November 2022
 Class Name     - PrivateVehIntegration
 Class purpose  - this class contains POST method for PrivateVehIntegration called from MOTO_SendPersonAccountToERP.
        -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              25/11/22           Initial Version 
2.          v2.0              13/04/23           Update response info
****************************************************************************************************************/         
public class PrivateVehIntegration implements Queueable,Database.AllowsCallouts{
 
    public string AccNumber;
    public string OppId;
    
    public PrivateVehIntegration(string AccNumber,string OppId){
        this.AccNumber=AccNumber;
        this.OppId = OppId;
        
    }
    
    public void execute(QueueableContext con){
        system.debug(AccNumber);
        system.debug(OppId);            
        
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('MOTO_NonETVehicleCreation');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        Opportunity Opp=[select id,Vehicle_Internal_Number__c,Integration_Message__c from Opportunity where Id =: OppId];
         
        String QueryString='Select id,Chassis_Number__c,Plate_Color_Master__c,Plate_Source_Master__c,Plate_Type_Master__c,Vehicle_Plate_Number__c,Trade_In_Chassis_Number__c,Vehicle_Model_Year__c, Vehicle_Model__r.Oracle_Family_Code__c,Vehicle_Brand__r.Oracle_Make_Code__c from Opportunity  where id=:OppId';
        Opportunity Oppnty= new Opportunity(); 
        Oppnty     = Database.query(QueryString);
        String chassisNum       = Oppnty.Chassis_Number__c!=null?Oppnty.Chassis_Number__c:'';
        String makeCode         = Oppnty.Vehicle_Brand__r.Oracle_Make_Code__c!=null?Oppnty.Vehicle_Brand__r.Oracle_Make_Code__c:'';
        String familyCode       = Oppnty.Vehicle_Model__r.Oracle_Family_Code__c!=null?Oppnty.Vehicle_Model__r.Oracle_Family_Code__c:'';
        String yearModel        = Oppnty.Vehicle_Model_Year__c!=null?Oppnty.Vehicle_Model_Year__c:'';
        String TradeInChassisNumber =Oppnty.Trade_In_Chassis_Number__c!=null?Oppnty.Trade_In_Chassis_Number__c:'';
        String plateNum         = Oppnty.Vehicle_Plate_Number__c!=null?Oppnty.Vehicle_Plate_Number__c:'';
        String PlateColorMaster = Oppnty.Plate_Color_Master__c!=null?Oppnty.Plate_Color_Master__c:'';
        String PlateSourceMaster= Oppnty.Plate_Source_Master__c!=null?Oppnty.Plate_Source_Master__c:'';
        String PlateTypeMaster  = Oppnty.Plate_Type_Master__c!=null?Oppnty.Plate_Type_Master__c:'';
       
         JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('chassisNum',chassisNum);
            gen.writeStringField('makeCode',makeCode);
            gen.writeStringField('familyCode',familyCode);
            gen.writeStringField('yearModel',yearModel);
            gen.writeStringField('plateNum',plateNum);
            gen.writeStringField('plateSourceCode',PlateSourceMaster);
            gen.writeStringField('plateColorCode',PlateColorMaster);
            gen.writeStringField('plateTypeCode',PlateTypeMaster);  
            gen.writeStringField('organizationId','2043');
            gen.writeStringField('activityCode','410');
            gen.writeStringField('customerId',AccNumber);
            gen.writeEndObject();
            String jsonData = gen.getAsString();
          
            HttpRequest request = new HttpRequest();
            System.debug('body='+jsonData);
        
        if(ET_REST_Authorize_Helper.runningInASandbox()){
                request.setEndpoint(connection.Dev_Endpoint__c);
                
            }else{
                request.setEndpoint(connection.LiveEndpoint_c__c);
            }  
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonData);      
        request.setHeader('Authorization','Basic '+paramvalue);   
        Map<String, Object> responseResult =new Map<String, Object>();
       
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        System.debug('response body='+response.getBody());
         if (response.getStatusCode() != 200) {
            
            System.debug('Failed ');
            Opp.Integration_Message__c ='Failed';
            responseResult = null;             
            //acc.Integration_Message__c  ='Unable to send request to ERP';
        }
        else{
            if(response.getStatusCode() == 200){
                System.debug('Sucess ');
                Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                responseResult =result;
                system.debug('--res--'+responseResult);
                
                if(string.valueOf(result.get('PV_OUT_ERROR_STATUS')) =='Y' || string.valueOf(result.get('PV_OUT_ERROR_STATUS'))=='E'){                   
                    //Opp.Integration_Status__c = 'Error';
                    Opp.Integration_Message__c = string.valueOf(result.get('PV_OUT_ERROR_MSG'));
                   
                }
               
            }
            
        }
        if(responseResult!=null)
        {
          
            String ResponseStatus =(String)responseResult.get('PV_OUT_ERROR_STATUS');
          
            if(ResponseStatus =='S')
            {
                string  PVOUTINTERNALNO =(String)responseResult.get('PV_OUT_INTERNAL_NO');
                system.debug('---'+PVOUTINTERNALNO);
               
                Opp.Vehicle_Internal_Number__c=PVOUTINTERNALNO;                
                Opp.Integration_Message__c ='Non ET Vehicle is Created Successfully';
               
                
            }
            
            
        }
         update Opp;
        
    }
}