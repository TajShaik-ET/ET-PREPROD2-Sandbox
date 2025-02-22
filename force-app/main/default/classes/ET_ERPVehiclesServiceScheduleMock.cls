@isTest
global class ET_ERPVehiclesServiceScheduleMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
         ET_ERPVehicle.XxetVehicleMasterDetMv testObj1 = new ET_ERPVehicle.XxetVehicleMasterDetMv();
         testObj1.internalNo='101';
		 testObj1.vehMode=' ';
		 testObj1.description=' ';
		 testObj1.segActivityCenter=' ';
		 testObj1.location=' ';
		 testObj1.vehicleStatus=' ';
		 testObj1.plateNumber=' ';
		 testObj1.plateColour=' ';
		 testObj1.plateType=' ';
		 testObj1.plateIssue=' ';
         testObj1.registrationDate=Date.newInstance(2020, 12, 9);
         testObj1.regRenewalDate=Date.newInstance(2020, 12, 9);
         testObj1.mainType=' ';
         testObj1.subType=' ';
         testObj1.make=' ';
         testObj1.model=' ';
		 testObj1.chassisNumber=' ';
		 testObj1.engineNumber=' ';
         testObj1.contractNo=1234567890;
         List<ET_ERPVehicle.XxetVehicleMasterDetMv> testObj2 = new List<ET_ERPVehicle.XxetVehicleMasterDetMv>();
      	 testObj2.add(testObj1);
      	 ET_ERPVehicle.XxetVehicleMasterDetMvCollection  obj = new ET_ERPVehicle.XxetVehicleMasterDetMvCollection();
         obj.XxetVehicleMasterDetMv = testObj2;
         ET_ERPVehicle.Output response_x= new ET_ERPVehicle.Output();
         response_x.Status ='success';
         response_x.Message ='success';
         response_x.XxetVehicleMasterDetMvCollection =obj;
        
        response.put('response_x', response_x); 
   }
}