/* Class       : ETC_updateVehicle_Bookings_From_Cabman
   Description : To update back Cabman Reference Number for Bookings created in Cabman.
				 To Register all Transactions of input and output Request -- Integration_Log__c
				 To Register all Exceptions								  -- Exception_Log__c
   Params      : Input - VehicleBooking auto number and Cabman reference number
   Response    : VehNo, Success or failure, Message - success or failed message
   Test Class  : ?
*/

/*

****Service call from External system******

 API URI       :https://icrm--preprod.my.salesforce.com/services/apexrest/VehicleBookingAPI/
			   :<<Instance URL>>/services/apexrest/VehicleBookingAPI/
 Method    	   : PATCH
 Authorization 		   : Bearer <<Access Token>>
 Content-Type 		   : application/json

*/

/* Input and output 

Input JSON :

// Input from RPA:

 

[ {

      "VehNo":"Item-0037",

      "CabmanRefernceId":"123"

   },

   {
      "VehNo":"Item-0038",

      "CabmanRefernceId":"234"

   }

]


// out put JSON:
// Successful Response:

 

[

    {

        "VehNo": "Item-0037",

        "success": true,

        "message": "Successfully Updated"

    },

    {

        "VehNo": "Item-0038",

        "success": true,

        "message": "Successfully Updated"

    }

]

 

// Validation or failed Bookings:

[

    {

        "VehNo": null,

        "success": false,

        "message": "Pick up Date Time must be in Future"

    },

    {

        "VehNo": null,

        "success": false,

        "message": "Pick up Date Time must be in Future"

    }

]




*/


/*
	****Authentication from external system******
	URL : https://icrm--preprod.my.salesforce.com/services/oauth2/token
	Method : POST
	Type : form-Data
	username : integration.user@et.ae.preprod
	password : integration@123xoFlV1hZ0NTfF7NefjUqXUVcr
	client_id : 3MVG954MqIw6FnnPoltlRvDbpAPvMmgBdM1l6fFCuX9tdvkpLHYHAkeFyfNQQ8XfZifo5M3Jq.4aaneRQlt0P
	Client Secret : 1A7F787FFF093F266106BC08833D226F6FC6673C2E0C37C19D663996C3CD99AF
 	grant_type : password

*/

@RestResource(urlMapping='/VehicleBookingAPI/*')
global class ETC_updateVehicle_Bookings_From_Cabman {
    
    @HttpPatch
    global static List<ResponseWrapper>  doPatch(){
        // PATCH Method
        List<ResponseWrapper> rwList = new List<ResponseWrapper>();
        List<Integration_Log__c> historyList = new List<Integration_Log__c>();
        List<Exception_Log__c> ExceptionList = new List<Exception_Log__c>();
        
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            system.debug('req ->'+req);
            String jsoninput = req.requestBody.toString();
            System.debug('========== Request : '+jsoninput);
            
            //deserialize request ..
            List<inputParser> inputReqList = new List<inputParser>();
            inputReqList = (List<inputParser>) JSON.deserialize(jsoninput, List<inputParser>.class);
            system.debug('input parsed data = ' +  inputReqList);
            
            /*********** Variable intilization*********************/
            Set<String> vehBkngs_auto_Numbers  = new Set<String>();
            Map<String,Id> vehBkngs_autoNumber_Id_map = new Map<String,Id>();
            Map<String,String> vehBkngs_Id_autoNumber_map = new Map<String,String>();
            List<ETCAR_Service_Request_Line_Item__c> toUpdateList = new List<ETCAR_Service_Request_Line_Item__c>();
			
            // set maps required...
            if(inputReqList != null && inputReqList.size() > 0){
                for(inputParser input : inputReqList){
                    vehBkngs_auto_Numbers.add(input.VehNo);
                }
            }
            
            system.debug('vehBkngs_auto_Numbers= ' +  vehBkngs_auto_Numbers);
            
            for(ETCAR_Service_Request_Line_Item__c bkng : [select id, name from ETCAR_Service_Request_Line_Item__c where name in:vehBkngs_auto_Numbers]){
                vehBkngs_autoNumber_Id_map.put(bkng.name, bkng.id);// Key = auto number && Value = Salesforce Id
                vehBkngs_Id_autoNumber_map.put(bkng.id,bkng.name);// Key = Salesforce Id && Value = auto number
            }
            
            // update Vehicle Bookings
            
            if(inputReqList != null && inputReqList.size() > 0){
                for(inputParser input : inputReqList){
                    String sfid = vehBkngs_autoNumber_Id_map.get(input.VehNo);
                    ETCAR_Service_Request_Line_Item__c vBkng = new ETCAR_Service_Request_Line_Item__c();
                    vBkng.id = sfid;
                    vBkng.ETC_Cabman_Reference_Number__c = input.CabmanRefernceId;
                    toUpdateList.add(vBkng);
                }
            }
            system.debug('toUpdateList  = '+ toUpdateList);
            
            // update DML operation - allowing partial success
            Database.SaveResult[] saveResult;
            if(toUpdateList != null && toUpdateList.size() > 0){
                saveResult = Database.update(toUpdateList, false);
                system.debug('saveResult = '+ JSON.serializePretty(saveResult));
            }
            
            //iterate over updateList and create Response wrapper
            for(Database.SaveResult saveRes : saveResult) {
                
                ResponseWrapper rw = new ResponseWrapper();
                if(vehBkngs_Id_autoNumber_map.containsKey(saveRes.getID())){
                    rw.VehNo = vehBkngs_Id_autoNumber_map.get(saveRes.getID());
                }
                system.debug('in Response VehNo = '+ rw.VehNo);
                    if(saveRes.isSuccess()) {
                        rw.success = true;
                        rw.message = 'Successfully Updated';
                    }
                    else
                    {
                        rw.success = false;
                        for(Database.Error err : saveRes.getErrors()) {
                            rw.message = err.getMessage();
                        }
                    }
                    rwList.add(rw);
            }
            
         // log Transaction
         logTransaction(jsoninput , JSON.serializePretty(rwList) );   
            
        }
        catch(Exception e){
            system.debug('Exception ='+ e.getMessage());
            system.debug('Exception Trace='+ e.getStackTraceString());
            system.debug('Exception line='+ e.getLineNumber());
            // log Exception
            logException(e.getMessage() , e.getStackTraceString() + ' and Line Number = '+ e.getLineNumber());
            ResponseWrapper rw = new ResponseWrapper();
            rw.VehNo = '';
            rw.success = False;
            rw.message = e.getMessage();
            rwList.add(rw);
        }
        system.debug('Response = '+ rwList);
        return rwList;
    }
    
/* 
	Description : Input from Cabman 
	Input - VehNo & CabmanRefernce Number
*/
    Global class inputParser {
        public String VehNo;
        public String CabmanRefernceId;
    }
    
/* Response :
	Success Response with Veh No
	Any Exception in logic
	For any failed updation with error message
*/
    Global Class ResponseWrapper {
        public String VehNo;
        public Boolean success;
        public String message;
    }
    
    public static void logTransaction(String input, String output){
        Integration_Log__c log = new Integration_Log__c();
        log.Integration_Type__c = 'INBOUND';
        log.Json_Response__c = output;
        log.Pay_Load__c = input;
        log.Process_Name__c = 'Salesforce-Cabman';
        log.Source_System__c = 'cabman';
        log.Target_System__c = 'salesforce';
        
        insert log;
    }
    
    public static void logException(String exceptmsg, String excepDetail ){
        Exception_Log__c log = new Exception_Log__c();
        log.Application_Name__c = 'Cabman';
        //log.Class_Name__c =;
        log.Error_Message__c =exceptmsg;
        log.Running_User__c = UserInfo.getUserId() ;
        log.Exception_Details__c = excepDetail;
        
        insert log;
    }
    
}