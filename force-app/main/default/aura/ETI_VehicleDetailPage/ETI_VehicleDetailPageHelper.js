({
    MAX_FILE_SIZE: 3000000,
    CHUNK_SIZE: 750000,
    
    getAmanLookups: function (component, event, helper) {
        var action = component.get("c.getAmanLookupDetails");
        action.setParams({
            selectedLang: component.get("v.clLang")
        });
        action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            var returning = [];
            var result = response.getReturnValue();
            var pType = [];
            var pSource = [];
            var pColor = [];
            var vType =[];
            result.plateTypes.forEach(test => {
                pType.push({
                label : test.lookupName,
                value : test.lookupCode
            	});                
        	});
            result.plateSources.forEach(test => {
                pSource.push({
                label : test.lookupName,
                value : test.lookupCode
            	});                
        	});
        	result.plateColors.forEach(test => {
                pColor.push({
                label : test.lookupName,
                value : test.lookupCode
            	});   
    		});
            result.vehicleTypes.forEach(test => {
                vType.push({
                label : test.lookupName,
                value : test.lookupCode
            	});
            });
            component.set("v.PlateType", pType);
            component.set("v.Platesource", pSource);
            component.set("v.Platecolor", pColor);
            component.set("v.lookupVehicleTypes", vType);
    	}else {
            var msg=component.get("v.Plate_Combinations_Values");
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
    	}
    	});
    	$A.enqueueAction(action);
    },
    getBookingSlotOptions: function (component, event, helper) {
        var action = component.get("c.getPickListValues");
        action.setParams({
            selectedObject: "ETI_Booking__c",
            selectedField: "ETI_Booking_slots__c"
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returning = [];
                var result = response.getReturnValue();
                component.set("v.bookingSlotOptions", result);
            }
            else {
                var msg=component.get("v.Problem_Available_Slots");
 				var utility = component.find("ETI_UtilityMethods");
				var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
            }
        });
        $A.enqueueAction(action);
    },
    getRegistrationType: function (component, event, helper) {
        var selectedField ='Registration_Type__c';
        if(component.get("v.clLang")=='ar')
            selectedField = 'Registration_Type_AR__c';
        var action = component.get("c.getPickListValues");
        action.setParams({
            selectedObject: "ET_Customer_Vehicle__c",
            selectedField: selectedField
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returning = [];
                var result = response.getReturnValue();
                component.set("v.RegistrationType", result);
            }
            else {
                var msg=component.get("v.Problem_Registration_Types");
 				var utility = component.find("ETI_UtilityMethods");
				var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
            }
        });
        $A.enqueueAction(action);
    },
    getVehicleServicType: function (component, event, helper) {
        var selectedField ='ET_Vehicle_type__c';
        if(component.get("v.clLang")=='ar')
            selectedField = 'ET_Vehicle_type_AR__c';
        var action = component.get("c.getPickListValues");
        action.setParams({
            selectedObject: "ET_Customer_Vehicle__c",
            selectedField: selectedField
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.vehicleTypes", result);
            }else {
                var msg=component.get("v.Problem_Vehicle_Types");
 				var utility = component.find("ETI_UtilityMethods");
				var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
            }
        });
        $A.enqueueAction(action);
    },  
    getADFCATypes: function (component, event, helper) {
        var selectedField ='ADFCA_Type__c';
        if(component.get("v.clLang")=='ar')
            selectedField = 'ADFCA_Type_AR__c';
        var action = component.get("c.getPickListValues");
        action.setParams({
            selectedObject: "ET_Customer_Vehicle__c",
            selectedField: selectedField
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.ADFCATypes", result);
            }else {
                var msg=component.get("v.Problem_ADFCA_Types");
 				var utility = component.find("ETI_UtilityMethods");
				var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
            }
        });
        $A.enqueueAction(action);
    },      
    getSelectedTypes: function (component, event, helper) {
        var selectedField ='Selected_Type__c';
        if(component.get("v.clLang")=='ar')
            selectedField = 'Selected_Type_AR__c';
        var action = component.get("c.getPickListValues");
        action.setParams({
            selectedObject: "ET_Customer_Vehicle__c",
            selectedField: selectedField
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.ChooseDataInfo", result);
            }else {
                var msg=component.get("v.Problem_ADFCA_Types");
 				var utility = component.find("ETI_UtilityMethods");
				var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
            }
        });
        $A.enqueueAction(action);
    }, 
    //File Upload Helper Methods STart
    uploadHelper: function (component) {
        var con = component.get("v.VehicleInfo");
        var fileInput = component.get("v.fileToBeUploaded");
        console.log('fileToBeUploaded..',fileInput);
        console.log('fileList size>> '+fileInput.length);
		var fileCount=0;
        console.log('fileCount>> '+fileCount);
        var file = [];
        for (var i = 0; i < fileInput.length; i++) {
            // alert('fileInput.length..'+fileInput.length);
            file.push(fileInput[i][0]);
            console.log('file fileInput..',file);
            var self = this;
            if (file.size > self.MAX_FILE_SIZE) {
                component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
                return;
            }
            fileCount++;
        }
        self.uploadFile(component, file, con, 0, null);
        console.log('fileCount size>> '+fileCount);
   	},
    uploadFile: function (component, file, con, indexVal, parentId) {
        if ((indexVal < file.length)) {
           var self = this;
            // create a FileReader object 
            var objFileReader = new FileReader();
            // set onload function of FileReader object   
            objFileReader.onload = $A.getCallback(function () {
                var fileContents = objFileReader.result;
                var base64 = 'base64,';
                var dataStart = fileContents.indexOf(base64) + base64.length;
                fileContents = fileContents.substring(dataStart);
                // call the uploadProcess method 
                self.uploadProcess(component, file[indexVal], fileContents, con, file, indexVal, parentId);
            });
            objFileReader.readAsDataURL(file[indexVal]);
        }else{
            this.hideSpinner(component);
            var msg=component.get("v.Record_Created_Message");
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Success"),msg,"","dismissible","success");
            component.set("v.isOpen", false);
            var url_string = window.location.href;
            var url = new URL(url_string);
            var lang = url.searchParams.get("lang");
            if(lang==null)
                lang='en'; 
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/eti-homepage?lang='+lang                         
            });
            urlEvent.fire();
        }
        
    },
    uploadProcess: function (component, file, fileContents, con, fileList, indexVal, parentId) {
        // alert ('entered 4');
        var self = this;
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, con, fileList, indexVal, parentId);
    },    
    uploadInChunk: function (component, file, fileContents, startPosition, endPosition, con, fileList, indexVal, parentId) {
         // call the apex method 'saveChunk'
         var getchunk = fileContents.substring(startPosition, endPosition);
        let termsAndCondition = component.get('v.isTearmAndCondition');
         var action = component.get("c.saveTheFile");
         //   alert('on..'+con);
         action.setParams({
             fileName: file.name,
             base64Data: encodeURIComponent(getchunk),
             contentType: file.type,
             vehicle1: con,
             parentId : parentId,
             termsAndCondition : termsAndCondition
         });
         
         // set call back 
         action.setCallback(this, function (response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                 console.log('indexVal>> '+indexVal);
                 console.log('fileList size>> '+fileList.length);
                 var result = response.getReturnValue();
				 if (indexVal < fileList.length) {
                     indexVal = 1 + indexVal;
                     //con.id = response.getReturnValue();
                     this.uploadFile(component, fileList, con, indexVal, response.getReturnValue());
                     // this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                 } else  {
                   
                 }
             	// handel the response errors        
             } else if (state === "INCOMPLETE") {
                 //alert("From server: " + response.getReturnValue());
             } else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         console.log("Error message: " + errors[0].message);
                     }
                 } else {
                     console.log("Unknown error");
                 }
             }
         });
         // enqueue the action
         $A.enqueueAction(action);
    },
    duplicateCheck: function (component, event, isFileUpload) { 
        console.log('VehicleInfo>> '+JSON.stringify(component.get("v.VehicleInfo")));
        console.log('verifiedVehicleInfo>> '+JSON.stringify(component.get("v.verifiedVehicleInfo")));
        console.log('isFileUpload>> '+isFileUpload);
        console.log('selectedValue>> '+component.get("v.selectedValue"));
        component.set("v.IsSpinner", true);
        var vehicle = component.get("v.VehicleInfo");
        var verifiedVehicle = component.get("v.verifiedVehicleInfo");
        //Below Condtion added if cutomer providing extra information when Server down then bypass duplicate check with same details
        if((verifiedVehicle==null || verifiedVehicle==undefined) || (component.get("v.selectedValue")=='Chassis No' && verifiedVehicle.Chassis_No__c!=vehicle.Chassis_No__c) 
           || (component.get("v.selectedValue")=='Plate Combination' && (verifiedVehicle.Plate_No__c!=vehicle.Plate_No__c 
              || verifiedVehicle.Plate_Color__c!=vehicle.Plate_Color__c || verifiedVehicle.Plate_Source__c!=vehicle.Plate_Source__c
              || verifiedVehicle.Plate_Type__c!=vehicle.Plate_Type__c))){
            console.log('INNN>> ');
            var action = component.get("c.checkDuplicatevehicle");
            action.setParams({
                vehicle : vehicle,
                limitVar : 0
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var result = response.getReturnValue();
                if (component.isValid() && state === "SUCCESS") {
                     //Duplicate with different user
                     if(result === 'Duplicate vehicle'){
                         console.log('vehicle if>> '+JSON.stringify(vehicle));
                         var msg=component.get("v.Vehicle_already_exist");
                         if (!confirm(msg)) {
                             component.set("v.IsSpinner", false);
                             return true;
                         }else {
                             component.set("v.verifiedVehicleInfo", vehicle);
                             component.set("v.IsSpinner", false);
                             console.log('isFileUpload if>> '+isFileUpload);
                             if(!isFileUpload)
                                 this.SaveVehicle(component);
                             else 
                                 this.uploadHelper(component);
                         }
                     }else if(result === 'Duplicate with same User'){
                         component.set("v.IsSpinner", false);
                         var msg=component.get("v.Vehicle_already_exist_System");
                         var utility = component.find("ETI_UtilityMethods");
                         var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                     }else{
                         if(!isFileUpload)
                             this.SaveVehicle(component);
                         else 
                             this.uploadHelper(component);
                     }
                }else {
                    var msg=component.get("v.Unexpected_Error_Message");
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                    component.set("v.IsSpinner", false);
                }
           });
           $A.enqueueAction(action);
    	}else {
            if(!isFileUpload)
                this.SaveVehicle(component);
            else 
                this.uploadHelper(component);
        }
    },
    SaveVehicle: function (component) {
         console.log('savevehicle>> ');
         component.set("v.IsSpinner", true);
         var con = component.get("v.VehicleInfo");
         //alert('con' + JSON.stringify(con));
         var action1 = component.get("c.saveVehicle");
         action1.setParams({
             "vehicle": con,
             userId : $A.get("$SObjectType.CurrentUser.Id")
         });
         action1.setCallback(this, function (response) {
             var state = response.getState();
             //var result=JSON.stringify(response.getReturnValue());
             var result = response.getReturnValue();
             if (component.isValid() && state === "SUCCESS") {
                 if (result === 'No Service') {
                     var msg=component.get("v.Service_Not_Available");
 					 var utility = component.find("ETI_UtilityMethods");
					 var promise = utility.showToast(component.get("v.Info"),msg,"","sticky","info");
                     //component.set("v.VehicleInfo.Registration_Type__c", '');
                     //component.set("v.selectedValue", '');
                     con.Is_Verified__c=false;
                     component.set("v.VehicleInfo",con);
                     if(component.get("v.selectedValue") === 'Chassis No')
                     	component.set("v.isOpenwhennoservice", true);
                     component.set("v.showReg", false);
                 }else {
                     var response = result.includes(";");
                     console.log('response '+response);
                     var res = result.split(";");
                     console.log('res '+res);
                     if(response){
                         var msg=component.get("v.Service_Not_Available");
                         var utility = component.find("ETI_UtilityMethods");
                         var promise = utility.showToast(component.get("v.Info"),msg,"","sticky","info");
                         console.log('res[0] '+res[0]);
                         result=res[0];
                     }else{
                         var utility = component.find("ETI_UtilityMethods");
                         var promise = utility.showToast(component.get("v.Success"),component.get("v.Record_Created_Message"),"","dismissible","success");
                     }
                     component.set("v.isOpen", false);
                     $A.get('e.force:refreshView').fire();
                     var urlEvent = $A.get("e.force:navigateToURL");
                     var url_string = window.location.href;
                     var url = new URL(url_string);
                     var lang = url.searchParams.get("lang");
                     if(lang==null)
                         lang='en';
                     urlEvent.setParams({
                         "url": "/customer/s/vehicle-page?recordId="+result+"&lang="+lang
                     });
                     urlEvent.fire();
                 }
             }
             component.set("v.IsSpinner", false);
             console.log('Detail Page66');
         });
         $A.enqueueAction(action1);
    },
    getRequireDocs: function (component, event, helper) {
        var action = component.get("c.getRequiredDocumentsForUnregistered");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.requiredDocsList", result);
            }
            else {
                console.log('Docs fetch result..'+response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
             
    showSpinner: function (component) {
        component.set("v.IsSpinner", true);
    },
                     
	hideSpinner: function (component) {
        component.set("v.IsSpinner", false);
    },
    showSlots: function (component) {
        component.set("v.showAvailableSlots", true);
    },
            
    hideSlots: function (component) {
        component.set("v.showAvailableSlots", false);
    },
    validateETSChassisCode :function(val){
        console.log('val>> '+val);
        //var letters = /^[0-9]+$/;
        if( /[^a-zA-Z0-9]/.test( val ) ) {
           return false;
        }
        return true;     
 	},
    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    isNumber:function(str) {
        var pattern = /^\d+$/;
        return pattern.test(str);  // returns a boolean
    },

})