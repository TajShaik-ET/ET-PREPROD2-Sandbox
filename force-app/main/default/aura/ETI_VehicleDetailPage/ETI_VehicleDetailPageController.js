({
    doinit: function (component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        helper.getRegistrationType(component, event, helper);
        helper.getVehicleServicType(component, event, helper);
        helper.getADFCATypes(component, event, helper);
        helper.getSelectedTypes(component, event, helper);
        helper.getRequireDocs(component, event, helper);
        $A.createComponent(
            "c:ETI_ShowVehicleDetails",
            {
                "aura:id": "VehicleDetailsCmp"
            },
            function (newcomponent) {
                if (component.isValid()) {
                    var newCmp = component.find("cmpBody");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body);
                }
            }
        );
    },
    openModel: function (component, event, helper) {
		helper.getAmanLookups(component, event, helper);
        component.set("v.isOpen", true);
        component.set("v.isFilesNotUploaded",false);
    },
    
    closeModel: function (component, event, helper) {
        component.set("v.isOpen", false);
        component.set("v.showReg", true);
        let fileName = [];
        component.set("v.fileName", fileName);
        var con = component.get("v.VehicleInfo");
        component.set("v.VehicleInfo.Registration_Type__c", '');
        component.set("v.VehicleInfo.Chassis_No__c", '');
        component.set("v.VehicleInfo.Custom_Number__c", '');
        component.set("v.VehicleInfo.ET_Vehicle_type__c", '');
        //component.set("v.VehicleInfo.Vehicle_Type__c", ''); //Commented on 23/10/20
        component.set("v.VehicleInfo.Plate_No__c", '');
        component.set("v.VehicleInfo.Plate_Color__c", '');
        component.set("v.VehicleInfo.Plate_Source__c", '');
        component.set("v.VehicleInfo.Plate_Type__c", '');
        component.set("v.selectedValue", '');
        component.set("v.isTearmAndCondition",false);
        component.set("v.isOpenwhennoservice", '');
        var files = [];
        component.set("v.fileToBeUploaded",files);
    },

   clearvalues: function (component, event, helper) {
        component.set("v.errorReg", false);
        component.set("v.isFilesNotUploaded",false);
        component.find('ETSChassis').setCustomValidity("");
        component.find('ETSChassis').reportValidity();
        component.set("v.isOpenwhennoservice", false);
        var con = component.get("v.VehicleInfo");
        component.set("v.VehicleInfo.Chassis_No__c", '');
        component.set("v.VehicleInfo.Plate_No__c", '');
        component.set("v.VehicleInfo.Plate_Color__c", '');
        component.set("v.VehicleInfo.Plate_Source__c", '');
        component.set("v.VehicleInfo.Plate_Type__c", '');
        component.set("v.selectedValue", '');
    },
    ShowVehiclepopup: function (component, event, helper) {
        var con = component.get("v.SelectedVehicles");
        var setRows = [];
        if(con.length == 0){
            var msg=component.get("v.Atleast_select_one_Vehicle");
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Info!",msg,"","Sticky","info");
            return false;
        }
        for (var i = 0; i < con.length; i++) {
            setRows.push(con[i].Id);
        }
        var action = component.get("c.checkVehicleBookings");
        action.setParams({
            "rowid": setRows
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state>> '+state);
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                var msg=component.get("v.Vehicle_Deleted_Message");
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Info"),msg,"","Sticky","info");
                var urlEvent = $A.get("e.force:navigateToURL");
                //"url": '/eti-homepage?Loc='+component.get("v.selectedEmirate")   
                var url_string = window.location.href;
                var url = new URL(url_string);
                var lang = url.searchParams.get("lang");
                if(lang==null)
                    lang='en';                             
                urlEvent.setParams({
                    "url": '/eti-homepage?lang='+lang                           
                });
                urlEvent.fire();
                /*var a = component.get('c.doinit');
                a.setParams({
                    "component": component,
                    "event": event,
                    "helper":helper
                });
                $A.enqueueAction(a);*/
                
            }else {
                var msg=component.get("v.Unable_to_Complete_Message");
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
            }
        });
        $A.enqueueAction(action);
    },
    closeVehiclepopup: function (component, event, helper) {
        component.set("v.isOpendeletevehicle", false);
    },
    clearvalues1: function (component, event, helper) {
        component.set("v.isOpenwhennoservice", false);
        component.set("v.errorChassis", false);
        component.set("v.isFilesNotUploaded",false);
        component.set("v.VehicleInfo.Chassis_No__c", '');
        component.set("v.VehicleInfo.Plate_No__c", '');
        component.set("v.VehicleInfo.Plate_Color__c", '');
        component.set("v.VehicleInfo.Plate_Source__c", '');
        component.set("v.VehicleInfo.Plate_Type__c", '');
    },
    SaveNew: function (component, event, helper) {
        component.set("v.isOpen", false);
    },

    // Method For Event Handler
    SelectedData: function (component, event) {
        //Get the event message attribute
        var message = event.getParam("selectedRecords");
        component.set("v.SelectedVehicles", message);
    },
    //To delete Vehicle
    deletevehicle: function (component, event, helper) {
        var con = component.get("v.SelectedVehicles");
        var action = component.get("c.deleteVehicles");
        var setRows = [];
        for (var i = 0; i < con.length; i++) {
            setRows.push(con[i].Id);
        }
        action.setParams({
            "rowid": setRows
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            //alert(JSON.stringify(response.getReturnValue()));
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    handleTermAndCond: function(component, event){
        try{
          var val =  component.find('termsandconditioncheckbox').getElement().checked;
            if(val){
                var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                $A.util.removeClass(parentElement, 'slds-has-error');
                $A.util.addClass(errorElement, 'slds-hide');
            }else{
                var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                $A.util.addClass(parentElement, 'slds-has-error');
                $A.util.removeClass(errorElement, 'slds-hide');
            }
            component.set('v.isTearmAndCondition', val);
        }catch(err){
            console.log(err.message)
        }
    },
    //Method to Save the Vehicle
    saveVeh: function (component, event, helper) {
        console.log('VehicleInfo>> '+JSON.stringify(component.get("v.VehicleInfo")));
        console.log('Type>> '+JSON.stringify(component.get("v.VehicleInfo.Registration_Type__c")));
        var con = component.get("v.VehicleInfo");
        var isValueMissing = false;
        var selectedValue=component.get("v.selectedValue");
        if(selectedValue!='' && selectedValue!=null)
        	component.set("v.VehicleInfo.Selected_Type__c",selectedValue);
        console.log('VehicleInfo11>> '+JSON.stringify(component.get("v.VehicleInfo")));
        if(component.get("v.VehicleInfo.Registration_Type__c")==''){
            component.set('v.errorReg',true);
            isValueMissing = true;
        }else {
            component.set('v.errorReg',false);
        }
        component.set("v.IsSpinner", true);
        if(component.get("v.VehicleInfo.Registration_Type__c")=='Registered'){
            if(component.get("v.selectedValue")==''){
                component.set('v.errorChassis',true);
                isValueMissing = true;
            }
        }
        if (component.get("v.VehicleInfo.ET_Vehicle_type__c") == '') {
            component.set('v.errorvehicleType',true);
            isValueMissing = true;
        }else {
            component.set('v.errorvehicleType',false);
        } 
        if (component.get("v.VehicleInfo.ADFCA_Type__c") == '') {
            component.set('v.errorADFCAType',true);
            isValueMissing = true;
        }else {
            component.set('v.errorADFCAType',false);
        } 
        if(component.get("v.selectedValue")=='Plate Combination' || component.get("v.isOpenwhennoservice")){
            component.set('v.errorChassis',false);
            if (component.find('ETSPlate').get('v.value') == '' || component.find('ETSPlate').get('v.value') == null || component.find('ETSPlate').get('v.value') == undefined) {
                component.find('ETSPlate').setCustomValidity("This field is required");
                component.find('ETSPlate').reportValidity();
                isValueMissing = true;
            }else 
            {
                component.find('ETSPlate').setCustomValidity("");
                component.find('ETSPlate').reportValidity();
            }
            var letters = /^[0-9]+$/;
            if(!component.find('ETSPlate').get('v.value').toString().match(letters)){
                component.find('ETSPlate').setCustomValidity("Please enter only numbers.");
                component.find('ETSPlate').reportValidity();
                isValueMissing = true;
            }else if(component.find('ETSPlate').get('v.value').length > 5){
                component.find('ETSPlate').setCustomValidity("Plate No should be 5 numbers.");
                component.find('ETSPlate').reportValidity();
                isDataMissing = true;
            }else{
                component.find('ETSPlate').setCustomValidity("");
                component.find('ETSPlate').reportValidity();
            }
            if(component.get("v.VehicleInfo.Plate_Color__c")==''){
                component.set('v.errorPlateColor',true);
                isValueMissing = true;
            }else
                component.set('v.errorPlateColor',false);
            if(component.get("v.VehicleInfo.Plate_Type__c")==''){
                component.set('v.errorPlateType',true);
                isValueMissing = true;
            }else 
                component.set('v.errorPlateType',false);
            if(component.get("v.VehicleInfo.Plate_Source__c")==''){
                component.set('v.errorPlateSource',true);
                isValueMissing = true;
            }else 
                component.set('v.errorPlateSource',false);
        }
        console.log('isValueMissing11>> '+isValueMissing);

        if (component.get("v.VehicleInfo.Registration_Type__c")=='Un-Registered'){
            if (component.find('ETSChassis').get('v.value') == '' || component.find('ETSChassis').get('v.value') == null || component.find('ETSChassis').get('v.value') == undefined) {
                component.find('ETSChassis').setCustomValidity("This field is required");
                component.find('ETSChassis').reportValidity();
                isValueMissing = true;
            }else {
                component.find('ETSChassis').setCustomValidity("");
                component.find('ETSChassis').reportValidity();
            }
             //Validate for engine number
            if (component.find('ETSEngineNo').get('v.value') == '' || component.find('ETSEngineNo').get('v.value') == null || component.find('ETSEngineNo').get('v.value') == undefined) {
                component.find('ETSEngineNo').setCustomValidity(component.get("v.Field_is_required"));
                component.find('ETSEngineNo').reportValidity();
                isValueMissing = true;
            }else {
                component.find('ETSEngineNo').setCustomValidity("");
                component.find('ETSEngineNo').reportValidity();
            }
            
            var customerNumber = con.Custom_Number__c;
            if( customerNumber== ''  || customerNumber == null ||  customerNumber == undefined){
                component.find('customNo').setCustomValidity("This field is required");
                component.find('customNo').reportValidity();
                component.set("v.IsSpinner", false);
                isValueMissing = true;
            }else {
                component.find('customNo').setCustomValidity("");
                component.find('customNo').reportValidity();
            }
            var modelYear = component.get('v.VehicleInfo.Vehicle_Year__c');
            if( modelYear== ''  || modelYear == null ||  modelYear == undefined){
                component.find('ModelYear').setCustomValidity("This field is required");
                component.find('ModelYear').reportValidity();
                component.set("v.IsSpinner", false);
               isValueMissing = true;
            }
            
            //alert(helper.isNumber(val))
            if(!helper.isNumber(modelYear)){
                component.find('ModelYear').setCustomValidity("Please fill only numeric value.");
                component.find('ModelYear').reportValidity();
                 component.set("v.IsSpinner", false);
                isValueMissing = true;
            }
            if(helper.isNumber(modelYear)){
                var d = new Date();
                var today = d.getFullYear() +1;
                if(modelYear > today){
                    component.find('ModelYear').setCustomValidity("Year can be only 4 digits and not future value.");
                    component.find('ModelYear').reportValidity();
                    isValueMissing = true;
                }else{
                    component.find('ModelYear').setCustomValidity("");
                    component.find('ModelYear').reportValidity();
                }
                
            }
            console.log('isValueMissing>> '+isValueMissing);
            if(isValueMissing){
                component.set("v.IsSpinner", false);
                return false;
            }else { 
                var inputField = component.find('ETSChassis');
                var value = inputField.get('v.value');
                console.log('value>> '+value);
                var fileInput = component.get("v.fileToBeUploaded");
                var totalDocList = component.get('v.requiredDocsList').length;
                console.log('fileInput.length: '+fileInput.length);
                console.log('totalDocList: '+totalDocList);
                if(fileInput.length == 0 || totalDocList != fileInput.length){
                    component.set("v.IsSpinner",false);
                    component.set("v.isFilesNotUploaded",true);
                    window.scrollTo(0, 0);
                    return false;
                }
                let termsAndCond= component.get('v.isTearmAndCondition');
                if(!termsAndCond){
                    component.set("v.IsSpinner", false);
                    var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                    var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                    $A.util.addClass(parentElement, 'slds-has-error');
                    $A.util.removeClass(errorElement, 'slds-hide');
                    return false;
                }
                helper.duplicateCheck(component, event, true);
            }
        }
        if(isValueMissing){
            component.set("v.IsSpinner", false);
            return false;
        } 
        if (con.Registration_Type__c === 'Registered') {
            var con = component.get("v.VehicleInfo");
            var slec = component.get("v.selectedValue");
            console.log('slec>> '+slec);
            let termsAndCond= component.get('v.isTearmAndCondition');
            if(!termsAndCond){
                component.set("v.IsSpinner", false);
                var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                $A.util.addClass(parentElement, 'slds-has-error');
                $A.util.removeClass(errorElement, 'slds-hide');
                return false;
            }
            if (slec === 'Chassis No') {
                if (component.find('ETSChassis').get('v.value') == '' || component.find('ETSChassis').get('v.value') == null || component.find('ETSChassis').get('v.value') == undefined) {
                    component.find('ETSChassis').setCustomValidity("This field is required");
                    component.find('ETSChassis').reportValidity();
                    component.set("v.IsSpinner", false);
                    return false;
                }else {
                    component.find('ETSChassis').setCustomValidity("");
                    component.find('ETSChassis').reportValidity();
                }
                var inputField = component.find('ETSChassis');
                var value = inputField.get('v.value');
                console.log('value>> '+value);
                helper.duplicateCheck(component, event, false);
            }
            if (slec === 'Plate Combination') {
                con.Plate_Source_Code__c=con.Plate_Source__c;
                con.Plate_Type_Code__c=con.Plate_Type__c;
                con.Plate_Color_Code__c=con.Plate_Color__c;
                var mandatoryFieldsList = component.get("v.mandatoryFields");
                console.log('mandatoryFieldsList '+mandatoryFieldsList);
                var mandatoryFieldsCmps = [];
                for (var id in mandatoryFieldsList) {
                    mandatoryFieldsCmps.push(component.find(mandatoryFieldsList[id]));
                }
                console.log('mandatoryFieldsCmps '+mandatoryFieldsCmps);
                component.set("v.IsSpinner", false);
                if (mandatoryFieldsList.length != undefined && mandatoryFieldsList.length > 0) {
                    var allValid = mandatoryFieldsCmps.reduce(function (validSoFar, inputCmp) {
                        inputCmp.showHelpMessageIfInvalid();
                        return validSoFar && !inputCmp.get('v.validity').valueMissing;
                    }, true);
                    if (allValid) {
                        helper.duplicateCheck(component, event, false);
                    }
                }
            }
            if(slec === '')
            {
                con.Plate_Source_Code__c=con.Plate_Source__c;
                con.Plate_Type_Code__c=con.Plate_Type__c;
                con.Plate_Color_Code__c=con.Plate_Color__c;
                helper.duplicateCheck(component, event, false);
            }
        }
    },
    // FIle Upload Methods
    handleFilesChange: function (component, event, helper) {
        var Filelist = [];
        var files =[];
        //Filelist = component.get("v.fileName");
        //var files = component.get("v.fileToBeUploaded");
        if (event.getSource().get("v.files").length > 0) {
            var aa = event.getSource().get("v.name");
            var fileName1 = event.getSource().get("v.files");
			console.log('fileName1..',fileName1);
            for (var i = 0; i < fileName1.length; i++) {
                Filelist.push({Name :fileName1[i].name,Id : aa});
            }
            files.push(fileName1);
            component.set("v.fileToBeUploaded",files);
            console.log('Filelist',Filelist);
        }
        component.set("v.fileName", Filelist);
    },

    removeFile: function (component, event, helper) {
        var index = event.target.dataset.index;
        //alert('index'+index);
        var fileslist = component.get("v.fileName");
        var removefileToBeUploaded= component.get("v.fileToBeUploaded");
        console.log('beforeremovefileToBeUploaded..',removefileToBeUploaded);
        //alert(fileslist);
        var toremovefile = event.currentTarget.dataset.filename;
        fileslist.splice(index, 1);
        removefileToBeUploaded.splice(index, 1);
         console.log('afterremovefileToBeUploaded..',removefileToBeUploaded)
        component.set("v.fileName", fileslist);
        component.set("v.fileToBeUploaded", removefileToBeUploaded);
    },
    // FIle Upload Methods End

    requestForService: function (component, event, helper) {
        var action = component.get("c.getBookingData");
        var con = component.get("v.SelectedVehicles");
        if (con == null || con == undefined || con == 0) {
            var msg=component.get("v.Select_atleast_one_Vehicle");
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Info"),msg,"","Sticky","info");
            return null;
        }
       console.log('Selected Object Is :: '  + JSON.stringify(con));
        action.setParams({
            "lstVehicle": con
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("{!v.booking}", response.getReturnValue());
                component.set("v.isOpenRequestForService", true);
            }
        });
        $A.enqueueAction(action);
    },
    closeRequestForService: function (component, event, helper) {
        component.set("v.isOpenRequestForService", false);

    },
    /*closePaymentDetail: function (component, event, helper) {
        component.set("v.showPaymentDetail", false);
    },
    cardPayment: function (component, event, helper) {
        //component.set("v.isPayment", true);
        var whichButton = event.getSource().getLocalId();
        var con = component.get("v.Afterbooking");
        //console.log(con[0].Id);
        component.set("v.paymentvehicleid", con[0].Id);
        var con1 = component.get("v.paymentvehicleid");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/eti-vehiclepayment?recordId=" + con1 + "&button=" + whichButton
        });
        urlEvent.fire();
    }, */

    getBookedSlotsController: function (component, event, helper) {
        helper.getBookingSlotOptions(component, event, helper);
        var bookingDate = component.get("v.booking[0].Date_And_Time__c");
        var branch = component.get("v.booking[0].Branch__c");
        var bookingSlots = component.get("v.bookingSlotOptions");
        var index;
        if (bookingDate !== undefined && branch !== undefined) {
            helper.showSpinner(component);
            var action = component.get("c.getBookedSlots");
            action.setParams({
                bookingDate: bookingDate,
                branch: branch
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    result.forEach(bookedSlots => {
                        index = bookingSlots.findIndex(bookingSlot => bookingSlot === bookedSlots.ETI_Booking_slots__c);
                        if (index !== -1)
                            bookingSlots.splice(index, 1);
                        component.set("v.bookingSlotOptions", bookingSlots);
                    });
                    helper.hideSpinner(component);
                    helper.showSlots(component);
                }
                else {
                     var msg=component.get("v.Problem_booked_slots");
 					 var utility = component.find("ETI_UtilityMethods");
					 var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");   
                }
            });
            $A.enqueueAction(action);
        }
    },
    openFeedbackModal: function(component, event, helper){
        component.set('v.isfeebackModal',true);
    },
   onVehicleTypeChange: function (component, event, helper) {
       if(component.get("v.VehicleInfo.ET_Vehicle_type__c")!='')
           component.set('v.errorvehicleType',false);
   },
   onADFCATypeChange: function (component, event, helper) { 
       if(component.get("v.VehicleInfo.ADFCA_Type__c")!='')
           component.set('v.errorADFCAType',false);
   },
   onSourceChange : function (component, event, helper) {
       var data = component.get("v.VehicleInfo");
       data.Plate_Type__c='';
       data.Plate_Color__c='';
       component.set("v.VehicleInfo",data);
       component.set('v.isShowColor',false);
       if(component.get("v.VehicleInfo.Plate_Source__c")!=''){
           component.set('v.errorPlateSource',false);
           component.set('v.isShowType',true);
       }else
           component.set('v.isShowType',false);
       /*if(component.get("v.VehicleInfo.Plate_Type__c")!=''){
           component.set('v.errorPlateType',false);
       }    */    
    },
    onTypeChange : function (component, event, helper) {
       var data = component.get("v.VehicleInfo");
       data.Plate_Color__c='';
       component.set("v.VehicleInfo",data);  
       if(component.get("v.VehicleInfo.Plate_Type__c")!=''){
           component.set('v.errorPlateType',false);
           component.set('v.isShowColor',true);
       }else
           component.set('v.isShowColor',false);
       /*if(component.get("v.VehicleInfo.Plate_Color__c")!=''){
           component.set('v.errorPlateColor',false);
       }  
       if(component.get("v.VehicleInfo.Plate_Source__c")!=''){
          component.set('v.errorPlateSource',false);
       }*/
    },
    onColorChange: function (component, event, helper) {
       if(component.get("v.VehicleInfo.Plate_Color__c")!=''){
           component.set('v.errorPlateColor',false);
       }  
    },
    plateNoValidation  : function (component, event, helper) {
       var letters = /^[0-9]+$/;
       if(!component.find('ETSPlate').get('v.value').toString().match(letters))
       {
            if(component.get('v.clLang') == 'en'){
                component.find('ETSPlate').setCustomValidity("Please enter only numbers");
            }
            else if(component.get('v.clLang') == 'ar'){
             	component.find('ETSPlate').setCustomValidity("لمرجو ادخال أربعة ارقام فقط");
            }
           component.find('ETSPlate').reportValidity();
           isValueMissing = true;
       }else{
           component.find('ETSPlate').setCustomValidity("");
           component.find('ETSPlate').reportValidity();
       }                            
   },
   handleOnChmageOfModelyear: function(component, event, helper){
       var val = component.get('v.VehicleInfo.Vehicle_Year__c');
       if(helper.isNumber(val)){
           var d = new Date();
           var today = d.getFullYear() + 1;
           if(val > today){
               component.find('ModelYear').setCustomValidity(component.get("v.Year_4_digits_and_not_future"));
               component.find('ModelYear').reportValidity();
           }else{
               component.find('ModelYear').setCustomValidity("");
               component.find('ModelYear').reportValidity();
           }
       }else{
           component.find('ModelYear').setCustomValidity(component.get("v.Enter_only_numbers"));
           component.find('ModelYear').reportValidity();
       }
   },
   handleOnChmageOfChassis: function(component, event, helper){
       var val = component.get('v.VehicleInfo.Chassis_No__c');
       if(val == null || val == '' || val == undefined){
           component.find('ETSChassis').setCustomValidity(component.get("v.Field_is_required"));
           component.find('ETSChassis').reportValidity();
       }else{
           component.find('ETSChassis').setCustomValidity("");
           component.find('ETSChassis').reportValidity();
       }
       var upperChassis = val.toUpperCase();
       component.set('v.VehicleInfo.Chassis_No__c', upperChassis);
   },
   handleOnChmageOfCustomNumber: function(component, event, helper){
       var val = component.get('v.VehicleInfo.Custom_Number__c');
       if(val == null || val == '' || val == undefined){
           component.find('customNo').setCustomValidity(component.get("v.Field_is_required"));
           component.find('customNo').reportValidity();
       }else{
           component.find('customNo').setCustomValidity("");
           component.find('customNo').reportValidity();
       }
   }
})