@RestResource(urlMapping = '/createCase/*')
Global Class CreateCase {
    @HttpPost
    Global Static List<ResponseWrapper> doPost() {
        RestRequest req = RestContext.request;
        String json = req.requestBody.toString();
        System.debug('========== Request : '+json);
        try {
            List<CreateCaseParser> parserList = CreateCaseParser.parse(json);
            Set<String> vehicles = new Set<String>();
            Set<String> contactpers = new Set<String>();
            Map<String,Id> vehicleNameIdMap = new Map<String,Id>();
            Map<String,Id> contactpersonIdMap = new Map<String,Id>();
            for(CreateCaseParser cp : parserList) {
                vehicles.add(cp.assignedVehicle);
                contactpers.add(cp.contactPerson);
            }
            List<Vehicle_Master__c> vehicleMasterList = [SELECT Id, Name FROM Vehicle_Master__c WHERE Name IN: vehicles];
            List<Account> ContactpersonList = [SELECT Id, ETIN_Employee_Id__c FROM Account WHERE ETIN_Employee_Id__c IN: contactpers];
            system.debug('vehicleMasterList '+vehicleMasterList);
            for(Vehicle_Master__c vm : vehicleMasterList) {
                vehicleNameIdMap.put(vm.Name, vm.Id);
            }
			if(contactpers.size()>0)
			{
            for(Account cp : [SELECT Id, ETIN_Employee_Id__c FROM Account WHERE ETIN_Employee_Id__c IN: contactpers limit 49000]) {
                contactpersonIdMap.put(cp.ETIN_Employee_Id__c, cp.Id);
            }
			}
            List<Case> caseList = new List<Case>();
            List<Account> parentAccount = [SELECT Id, Name FROM Account WHERE Name = 'Internal ET Account' LIMIT 1];
            if(parentAccount.size() > 0) {
                for(CreateCaseParser cp : parserList) {
                    Case c = new Case();
                    c.Subject = 'Arkani Request';
                    if(contactpersonIdMap.size()>0){
                        c.AccountId = contactpersonIdMap.get(cp.contactPerson);
                    }
                    else{
                        c.AccountId = parentAccount[0].Id;
                    }
                    c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(cp.type).getRecordTypeId();
                    c.Assigned_Vehicle_Text__c = cp.assignedVehicle;
                    c.ET_Vehicle_Master__c = vehicleNameIdMap.get(cp.assignedVehicle);
                    c.Driver_Name__c = cp.driverName;
                    c.Activity_Location__c = cp.activityLocation;
                    c.Description = cp.description;
                    c.Arkani_Incident_ID__c = cp.arkaniIncidentId;
					c.Device_Type__c = cp.devicetype;
                    c.Origin = cp.origin;
                    c.Phone_Number__c = cp.contactNumber;
                    c.Current_Location__c=cp.currentLocation;
                    caseList.add(c);
                }
            }
            /*=============Can be optimized the response using this code, but required one unique parameter from the 3rd party system=================
                Database.SaveResult[] saveResult = Database.insert(caseList, false);
                for(Database.SaveResult sr : saveResult) {
                    System.debug('==== : '+ sr);
                }
            ==================================================================================================================*/
            insert caseList;
            string caseNo = [select CaseNumber from Case where Id=:caseList[0].Id].CaseNumber;            
            List<ResponseWrapper> response = new List<ResponseWrapper>();
            ResponseWrapper r = new ResponseWrapper();
            r.casenumber = caseNo;
            r.success = true;
            r.message = 'Cases Created Successfully';            
            response.add(r);
            return response;
        }catch(Exception ex) {
            List<ResponseWrapper> response = new List<ResponseWrapper>();
            ResponseWrapper r = new ResponseWrapper();
            r.casenumber='';
            r.success = false;           
            r.message = ex.getMessage();
            response.add(r);
            return response;
        }
    }
    
    Global Class ResponseWrapper {
        public Boolean success;
        public String message;
        public String casenumber;
    }
    
    Global Class RequestWrapper {
        public String type;
        public String assignedVehicle;
        public String driverName;
        public String activityLocation;
        public String description;
        public String origin;
        public String arkaniIncidentId;
		public String devicetype;
    }
}