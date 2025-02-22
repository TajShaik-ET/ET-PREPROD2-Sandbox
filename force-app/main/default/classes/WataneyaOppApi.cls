@RestResource(urlMapping='/WATANEYAOPP/*')
global class WataneyaOppApi {
    
    @HttpPost
    global static void doPost(){
        string jsonRequestStr = RestContext.request.requestBody.toString();
        string msgStr;
        boolean success;
        String OpporId;
        String response;
        RequestWrapper wrapper = RequestWrapper.parse(jsonRequestStr);
        
        try{
            // Get the record type ID for PersonAccount
            String accRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'PersonAccount' LIMIT 1].Id;
            String oppRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'Al_Wataneya_Sell_a_Car' LIMIT 1].Id;
            // Create Account
            string AccountId;
            List<Account> acct = [Select id, Name, PersonEmail  from Account where PersonEmail =: wrapper.email Limit 1];
            system.debug('acct.size>>>>>>>>' + acct.size());
            if(acct.size() < 1)
            {
                Account acc = new Account();
                acc.FirstName = wrapper.firstName;
                acc.LastName = wrapper.lastName;
                acc.PersonEmail = wrapper.email;
                acc.PersonMobilePhone = wrapper.mobile;
                acc.Fax = wrapper.fax;
                acc.ETT_P_O_Box__c = wrapper.poBox;
                acc.RecordTypeId = accRecordTypeId;
                insert acc;
				
				AccountId = acc.Id;
           
			}
            else{
                AccountId = acct[0].Id;
            }
             // Create map for Vehicle Brand and Model
        	/*Map<String, String> brandMap = new Map<String, String>();
            Map<String, String> modelMap = new Map<String, String>();
            String brand;
            String model;
        
        
         		List<Vehicle_Brand_Master__c> brandList = [Select id, Name from Vehicle_Brand_Master__c];
                List<Vehicle_Model_Master__c> modelList = [Select id, Name from Vehicle_Model_Master__c];
                if(brandList.size() > 0){
                    for(Vehicle_Brand_Master__c brnd : brandList)
                        brandMap.put(brnd.Name,brnd.Id);
                }
                if(wrapper.vehBrand != NULL && brandMap.containsKey(wrapper.vehBrand))
                    {
                        brand = brandMap.get(wrapper.vehBrand);
                    }
                
                if(modelList.size() > 0){
                    for(Vehicle_Model_Master__c mdl : modelList)
                        modelMap.put(mdl.Name,mdl.Id);
                }
                if(wrapper.vehModel != NULL && brandMap.containsKey(wrapper.vehModel))
                {
                   model = modelMap.get(wrapper.vehModel);
                }
                else
                {
                    model = modelMap.get('Other');
                }
        
        system.debug('Brand>>>>>'+ brand);
        system.debug('model>>>>>'+ model);*/


            // Create Opportunity
            system.debug('Account Id>>>>' + AccountId);
            Opportunity opp = new Opportunity();
            opp.Internal_Number__c = wrapper.clientId;
            opp.Name = wrapper.lastName;
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.today().addMonths(1); //close date
            opp.AccountId = AccountId;
			opp.Emirates_ID__c = wrapper.emiratesID;
            opp.Passport_Number__c = wrapper.passportNum;
            opp.Customer_Category__c = wrapper.customerCategory;
            opp.Customer_Category_Importance__c = wrapper.customerCategoryImp;
            opp.TRN_Number__c = wrapper.trnNumber;
            opp.Body_Type__c = wrapper.bodyType;
			/*if(brand != NULL)
            {
                opp.Vehicle_Brand__c = brand;
            }
            if(model != NULL)
            {
                opp.Vehicle_Model__c = model;
            }*/
            opp.Make__c = wrapper.vehBrand;
            opp.Model__c = wrapper.vehModel;
            opp.Vehicle_Plate_Number__c = wrapper.vehPlateNum;
            opp.Vehicle_Model_Year__c = wrapper.vehModelYear;
            opp.Vehicle_Mileage_number__c = Decimal.valueOf(wrapper.vehMileage);
            opp.Chassis_Number__c = wrapper.vehChassisNum;
            opp.Type_of_Vehicle__c = wrapper.vehType;
            opp.Accidented__c = wrapper.accidented;
            opp.Commision__c = wrapper.commision;
            opp.Auction_Fees__c = wrapper.auctionFee;
            opp.Customer_Minimum_Selling_Price__c = Decimal.valueOf(wrapper.customerMinimumSelling);
            opp.Recovery__c = wrapper.recovery;
            opp.Vehicle_Inspection_Auction__c = wrapper.vehInspection;
            opp.Body_Polishing__c = wrapper.bodyPolishing;
            opp.Bank_Name__c = wrapper.bankName;
            opp.Bank_Account_Number__c = wrapper.bankAccountNum;
            opp.IBAN_Number__c = wrapper.bankIBAN;
            opp.Bank_Address__c = wrapper.bankAddress;
            opp.Swift_Code__c = wrapper.bankSwiftCode;
            opp.Customer_Name__c = wrapper.bankCustomerName;
            opp.RecordTypeId = oppRecordTypeId;
            opp.StageName = 'Sold';
            insert opp;

            OpporId = opp.Id;
                    success = true;
                    msgStr = 'Account and Opportunity Created Successfully'; 
            
        }catch(Exception ex) {
            OpporId = '';
            success = false;
            msgStr = ex.getMessage();
			
			ET_Error_Logs__c err = new ET_Error_Logs__c();
            err.ET_Exception_Message__c	 =  msgStr;
            err.ET_Module__c = 'Wataneya OPP API';            
            insert err;            
        }
        
        
        //Get Response
        response = getResponse(success,OpporId,msgStr);
        //Send Response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = blob.valueOf(response);
    }
    
    //Request Wrapper
    public class RequestWrapper {
        public string clientId;
		public String firstName;    
        public String lastName;
		public String email;
        public String mobile;
        public String fax;
        public String poBox;
        public String emiratesID;
        public String passportNum;
        public String customerCategory;
        public String customerCategoryImp;
        public String trnNumber;
        public String bodyType;
        public String vehBrand;
        public String vehModel;
        public String vehPlateNum;
        public String vehModelYear;
        public String vehMileage;
        public String vehChassisNum;
        public String vehType;
        public String commision;
        public String auctionFee;
        public String accidented;
        public String customerMinimumSelling;
        public String recovery;
        public String vehInspection;
        public String bodyPolishing;
        public String bankName;
        public String bankAccountNum;
        public String bankIBAN;
        public String bankAddress;
        public String bankSwiftCode;
        public String bankCustomerName;
        
    }
    //Parse - Deseriliaze Request
    public static RequestWrapper parse(String json){
        return (RequestWrapper) System.JSON.deserialize(json, RequestWrapper.class);
    }
    //Response Wrapper
    public class ResponseWrapper {
        public boolean success;
        public String OppId;
        public String message;
        
    }
    //Create Response
    public static string getResponse(boolean success, string opp, string msg){
        ResponseWrapper respWrapper = new ResponseWrapper();
        respWrapper.success = success;
        respWrapper.OppId = opp;
        respWrapper.message = msg;
        
        return JSON.serialize(respWrapper);
    }
    
}