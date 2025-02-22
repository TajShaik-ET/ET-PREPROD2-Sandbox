({
    doinit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper);
        var VehicleInfoDataList = component.get("v.VehicleInfoDataList");
        VehicleInfoDataList.push({'sObjectType':'ET_Customer_Vehicle__c'});
        component.set("v.VehicleInfoDataList",VehicleInfoDataList);
        helper.getAmanLookups(component, event, helper);
    },
    clearPlateColorError: function (component, event, helper) {
        if (component.find('plateColor').get('v.value') == '' || component.find('plateColor').get('v.value') == null || component.find('plateColor').get('v.value') == undefined) {
            component.set('v.errorPlateColor',true);
            isDataMissing = true;
        }else {
            component.set('v.errorPlateColor',false);
        }
    },
    clearPlateTypeError: function (component, event, helper) {
         if (component.find('plateType').get('v.value') == '' || component.find('plateType').get('v.value') == null || component.find('plateType').get('v.value') == undefined) {
             component.set('v.errorPlateType',true);
             isDataMissing = true;
         }else {
             component.set('v.errorPlateType',false);
         }
    },
    clearvalues1: function (component, event, helper) {
        var data= component.get('v.VehicleInfoData');
        console.log('data..'+JSON.stringify(data));
        if(component.get("v.VehicleInfoData.Selected_Type__c") == 'Chassis No'){
            console.log('data..');
            component.set("v.errorChassis", false);
            //component.set("v.VehicleInfoData.Chassis_No__c", '');
            component.set('v.errorPlateColor',false);
            component.set('v.errorPlateType',false);
            component.set('v.errorPlateSource',false);
            component.find('plateNo').setCustomValidity("");
            component.find('plateNo').reportValidity();
        }else {
            console.log('data else..'+JSON.stringify(data));
            component.find('chassisNo').setCustomValidity("");
            component.find('chassisNo').reportValidity();
            /*data.Plate_No__c='';
            data.Plate_Color__c='';
            data.Plate_Source__c='';
            data.Plate_Type__c='';*/
        }
        component.set("v.VehicleInfoData", data);
        console.log('final data..'+JSON.stringify(component.get("v.VehicleInfoData")));
        component.set('v.isMessgeExist',false);
    },
    openFeedbackModal: function(component, event, helper){
        component.set('v.isfeebackModal',true);
    },
    
    cancelSave: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        // "url": '/eti-homepage?Loc='+component.get("v.selectedEmirate")  
        urlEvent.setParams({
            "url": '/eti-homepage?lang='+component.get("v.clLang")                          
        });
        urlEvent.fire();
    },
    getdata:function(component, event, helper) {
        try{
            var showHParam = helper.getJsonFromUrl().showH;
            var setrow=[];
            var con= component.get('v.recordId');
            console.log('Is_Verified__c: '+component.find("Is_Verified__c").get("v.value"));
            component.set('v.Chassisno',component.find("Chassis_No__c").get("v.value"));
            component.set('v.userdata',component.find("Account__c").get("v.value"));
            var currentchassisno= component.get('v.Chassisno');
            var currentuserdata=component.get('v.userdata');
            var vehicle=[];
            var vehiclerecord={Id:con,Chassis_No__c:currentchassisno,Account__c:currentuserdata};
            vehicle.push(vehiclerecord);
            console.log('vehicle11...'+JSON.stringify(vehicle));
            component.set('v.showHistory',showHParam);
            component.set('v.VehicleInfoData',vehicle);
            console.log('VehicleInfoData..'+JSON.stringify(component.get('v.VehicleInfoData')));
        }
        catch(error){
            console.log(error.message);
        }
    },
    /*getVerifiedDataByChassis: function(component, event, helper){
        if(component.get("v.VehicleInfoData.Selected_Type__c") == 'Chassis No'){
        	var data= JSON.parse(JSON.stringify(component.get('v.VehicleInfoData')));
            var verifiedData= component.get('v.verifiedVehicleInfo');
            //var resultArray =JSON.parse(JSON.stringify(data));
            console.log('data>> '+JSON.stringify(data));
            console.log('verifiedData>> '+JSON.stringify(verifiedData));
        }
    },*/
    getVerifiedDataByChassis: function(component, event, helper){
        var wrp = component.get("v.VehicleInfoData");
        var verifiedData = component.get('v.verifiedVehicleInfo');
        console.log('wrp>> '+JSON.stringify(wrp));
        console.log('verifiedData>> '+JSON.stringify(verifiedData));
        if(component.get("v.VehicleInfoData.Selected_Type__c") == 'Chassis No'){
            if(wrp.Registration_Type__c == 'Registered'){
                if(wrp.Chassis_No__c!=verifiedData.Chassis_No__c){
                    component.set("v.IsSpinner", true);
                    //wrp.Plate_No__c='';
                    /*wrp.Plate_Color__c='';
                    wrp.Plate_Source__c='';
                    wrp.Plate_Type__c='';*/
                    console.log('wrp>> '+JSON.stringify(wrp));
                    console.log('verifid wrp>> '+JSON.stringify(component.get("v.verifiedVehicleInfo")));
                }
            }
            if(wrp.Chassis_No__c!=null && wrp.Chassis_No__c!=''){ 
                component.set('v.isMessgeExist',false);
                component.find('chassisNo').setCustomValidity("");
                component.find('chassisNo').reportValidity();
                if(wrp.Registration_Type__c == 'Registered')
                	helper.getVehicleInfo(component, event, wrp);
            }
            else {
                component.find('chassisNo').setCustomValidity(component.get("v.Field_is_required"));
                component.find('chassisNo').reportValidity();
                component.set('v.isMessgeExist',true);
                component.set('v.errorType','warning');
                component.set('v.errorMessage',component.get("v.Enter_Valid_Chassis_No"));
            }
        }
    },
    validateYear: function(component, event, helper){
        var data = component.get("v.VehicleInfoData");
        var letters = /^[0-9]+$/;
        if(data.Vehicle_Year__c!=null && data.Vehicle_Year__c!=''){ 
            component.set('v.isMessgeExist',false);
            component.find('vehicleYear').setCustomValidity("");
            component.find('vehicleYear').reportValidity();
            if(!component.find('vehicleYear').get('v.value').toString().match(letters))
            {
                component.find('vehicleYear').setCustomValidity(component.get("v.Enter_only_numbers"));
                component.find('vehicleYear').reportValidity();
            }else if(component.find('vehicleYear').get('v.value').length !=4){
                component.find('vehicleYear').setCustomValidity(component.get("v.Year_should_be_4_numbers"));
                component.find('vehicleYear').reportValidity();
            }else {
                component.find('vehicleYear').setCustomValidity("");
                component.find('vehicleYear').reportValidity();
            }
        }else if(wrp.Registration_Type__c != 'Registered'){
            component.find('vehicleYear').setCustomValidity(component.get("v.Field_is_required"));
            component.find('vehicleYear').reportValidity();
            component.set('v.isMessgeExist',true);
            component.set('v.errorType','warning');
            component.set('v.errorMessage',component.get("v.Enter_Valid_Year"));
        }
    },
    getVerifiedDataByPlate: function(component, event, helper){
        var wrp = component.get("v.VehicleInfoData");
        if(wrp.Selected_Type__c == 'Plate Combination' && wrp.Registration_Type__c == 'Registered'){
            component.set('v.isMessgeExist',false);
            let isDataMissing=helper.dataValidate(component, event, helper);
            console.log('isDataMissing..'+isDataMissing);
            if(isDataMissing){
                component.set("v.IsSpinner", false);
                return false;
            }  
            console.log('isDataMissing '+isDataMissing)
            if(!isDataMissing) {
                component.set("v.IsSpinner", true);
                console.log('wrp>>--verifyByPlate '+wrp);
                //wrp.Chassis_No__c='';
                if(wrp.Plate_No__c !=null && wrp.Plate_No__c !=''){
                    component.find('plateNo').setCustomValidity("");
                    component.find('plateNo').reportValidity();
                }
                if(wrp.Plate_Source__c !='' && wrp.Plate_Source__c != null)
                	component.set('v.errorPlateSource',false)
                
                if(wrp.Plate_No__c !=null && wrp.Plate_No__c !='' && wrp.Plate_Color__c !='' && wrp.Plate_Color__c != null
                   && wrp.Plate_Source__c !='' && wrp.Plate_Source__c != null && wrp.Plate_Type__c !='' && wrp.Plate_Type__c != null){ 
                    component.set('v.isMessgeExist',false);
                    helper.getVehicleInfo(component, event, wrp);
                }else {
                    component.set('v.isMessgeExist',true);
                    component.set('v.errorMessage',component.get("v.Enter_Valid_Plate_Combination"));
                    component.set('v.errorType','warning');
                    component.set("v.IsSpinner", false);
                    component.set("v.VehicleInfoData",wrp);
                }
            }
        }
      
        if(wrp.Plate_Source__c !=null && wrp.Plate_Source__c !=''){
            console.log('Source>> ')
        	component.set('v.errorPlateSource',false);
        }
    },
    saveVehicleDetails: function(component, event, helper) {
        component.find("editForm").submit();
        console.log('selectedEmirate>> '+component.get("v.selectedEmirate")  );
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/eti-homepage?Loc='+component.get("v.selectedEmirate")+'&lang='+component.get("v.clLang")                            
        });
        urlEvent.fire();
    },
    updateVehicle: function(component, event, helper) {
        component.set('v.isMessgeExist',false);
        var data= component.get('v.VehicleInfoData');
        console.log('data..'+JSON.stringify(component.get('v.VehicleInfoData')));
        console.log('showHistory..'+component.get('v.showHistory'));
        let isDataMissing= true;
        let isDuplicate= true;
        isDataMissing=helper.dataValidate(component, event, helper);
        console.log('isDataMissing..'+isDataMissing);
        if(!isDataMissing){
            isDuplicate=helper.duplicateCheck(component, event, helper);
            console.log('isDuplicate<< '+isDuplicate);
            if(!isDuplicate){
                console.log('isDataMissing Else..'+isDataMissing);
                var action = component.get("c.updateVehicleDetails");
                action.setParams({
                    "vehicleDetails": component.get('v.VehicleInfoData')
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    console.log('state '+state);
                    var result = response.getReturnValue();
                    if (component.isValid() && state === "SUCCESS") {
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": '/eti-homepage?lang='+component.get("v.clLang")                            
                        });
                        urlEvent.fire();
                    }
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Success"),component.get("v.Record_Updated_Message"),"","dismissible","success");
                });
                $A.enqueueAction(action);
            }
            component.set("v.IsSpinner", false);
        }
    },
    requestforservicepage:function(component, event, helper) {
        try{
            component.set("v.hideReqForServiceBtn",true);
            var data= component.get('v.VehicleInfoData');
            console.log('data..'+JSON.stringify(component.get('v.VehicleInfoData')));
            var VehicleInfoDataList = component.get("v.VehicleInfoDataList");
            console.log('VehicleInfoDataList..'+JSON.stringify(component.get('v.VehicleInfoDataList')));
            VehicleInfoDataList.push(data);
            component.set("v.VehicleInfoDataList",VehicleInfoDataList);
            console.log(JSON.stringify(component.get("v.VehicleInfoDataList")));
            var action = component.get("c.getBookingData");
            action.setParams({
                "lstVehicle":component.get("v.VehicleInfoDataList")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state111 '+state);
                if (component.isValid() && state === "SUCCESS") {
                    var res = response.getReturnValue();
                    res.shift(); 
                    console.log('res ' +res);
                    component.set("v.booking", response.getReturnValue());
                    console.log('booking data'+JSON.stringify(response.getReturnValue()));
                    component.set("v.isOpenRequestForService",true);
                }else if(state == "ERROR"){
                    var errors = response.getError(); 
                    console.log(errors[0].message);
                    component.set("v.hideReqForServiceBtn",false);
                }
            });
            $A.enqueueAction(action);
        }
        catch(error)
        {
            console.log(error.message);
             component.set("v.hideReqForServiceBtn",false);
        }
    },
})