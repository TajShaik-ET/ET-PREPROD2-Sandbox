({
    doInit: function(component, event, helper){
        // debugger;
        var action = component.get('c.getUserAccountDetails');
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.AccountId', result.accRecord);
                component.set('v.AccountName', result.accRecordName);
                component.set('v.AccountARName', result.accRecordARName);
                component.set('v.contactId', result.cntRecord);
            }
        });
        $A.enqueueAction(action);
        
    },
    resetFlags: function(component,event,helper){
        component.set("v.GlobalEventRequest", false);
        
    },
    getLocationDetails: function(component, event, helper,latit,longit,isPick){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getLocationDetails";
        var params = {
            "latitude" : latit,
            "longitude" : longit
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                // component.set('v.tripLoc',response);  
                debugger;            
                var fields = component.find("tripDestFrm"); 
                
                if(component.get("v.dynamicRowsList").length > 1){
                    fields.forEach(function (field,index) {
                        if(field.get("v.fieldName") === 'Trip_Destination_From__c' && component.get("v.currentLocIndex")==index && component.get("v.currentDestClick")=='DestFrom'){
                            
                            field.set("v.value",response);                      
                        }                  
                        
                    });
                }
                
                else{
                    if(fields.get("v.fieldName") === 'Trip_Destination_From__c' && component.get("v.currentDestClick")=='DestFrom'){
                        fields.set("v.value",response);                     
                    }
                    
                }
                
                var fieldsTo = component.find("tripDestTo");
                
                if(component.get("v.dynamicRowsList").length > 1){
                    fieldsTo.forEach(function (field,index) {
                        if(field.get("v.fieldName") === 'Trip_Destination_To__c' && component.get("v.currentLocIndex")==index && component.get("v.currentDestClick")=='DestTo'){
                            
                            field.set("v.value",response);
                            
                        }                     
                        
                    });
                }else{
                    if(fieldsTo.get("v.fieldName") === 'Trip_Destination_To__c' && component.get("v.currentDestClick")=='DestTo'){
                        
                        fieldsTo.set("v.value",response);
                        
                    }
                    
                }
                
                var fieldsTo = component.find("assemblypoint");
                
                if(component.get("v.dynamicRowsList").length > 1){
                    fieldsTo.forEach(function (field,index) {
                        if(field.get("v.fieldName") === 'Assembly_Point__c' && component.get("v.currentLocIndex")==index && component.get("v.currentDestClick")=='AssemPoint'){
                            
                            field.set("v.value",response);
                            
                        }                     
                        
                    });
                }else{
                    if(fieldsTo.get("v.fieldName") === 'Assembly_Point__c' && component.get("v.currentDestClick")=='AssemPoint'){
                        
                        fieldsTo.set("v.value",response);
                        
                    }
                    
                }
                
                
                
                component.get("v.currentDestClick",null);
                
                $A.util.addClass(component.find("invalidpickup"), "slds-hide");
            }),
            
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("ET MOE", "Please try again later or contact ET Support", "error", "dismissible");
            })
        )	
    },
    getAddressRecommendations: function(component, event,helper,searchText){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getAddressSet";
        var params = {
            "SearchText" : searchText
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                var addressResponse = JSON.parse(response);
                var predictions = addressResponse.predictions;
                var addresses = [];
                if (predictions.length > 0) {
                    var placeId=predictions[0].place_id;
                    helper.getAddressDetailsByPlaceId(component,event,helper,placeId);
                    $A.util.addClass(component.find("invalidLoc"), "slds-hide");   
                }else{
                    $A.util.removeClass(component.find("invalidLoc"), "slds-hide"); 
                    component.set('v.mapLoaded',true);
                    
                }
                
                component.set("v.AddressList", addresses);
                console.log('AddressList'+component.get("v.AddressList"));
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("ET MOE", "Please try again later or contact ET Support", "error", "dismissible");
            })
        )	
        
    },
    getAddressDetailsByPlaceId: function(component,event,helper,placeId){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getAddressDetailsByPlaceId";
        var params = {
            PlaceID:placeId 
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response'+response);
                var addressResponse = JSON.parse(response);
                component.set('v.lat',addressResponse.result.geometry.location.lat);
                component.set('v.lon',addressResponse.result.geometry.location.lng);
                component.set('v.mapLoaded',true);
                component.set('v.vfUrl','/Business/apex/ETST_GoogleMapFinder?lat='+addressResponse.result.geometry.location.lat+'&long='+addressResponse.result.geometry.location.lng);
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
                utility.showToast("ET MOE", "Please try again later or contact ET Support", "error", "dismissible");
            })
        )	 
    },
    addRowHelper : function(component, noOfRows) {
        for(var index = 0; index < noOfRows; index++) {
            var dynamicRowsList = component.get("v.dynamicRowsList");
            dynamicRowsList.push({	            
                'rowNumber':dynamicRowsList.length + 1
            });
            component.set("v.dynamicRowsList", dynamicRowsList);
            console.log('data ',dynamicRowsList);
        }
    },
    searchRecordsHelper : function(component, event, helper, value) {
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get('v.searchString');
        component.set('v.message', '');
        component.set('v.recordsList', []);
        // Calling Apex Method
        var action = component.get('c.fetchRecords');
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'searchString' : searchString,
            'value' : value
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {
                if(result.length > 0) {
                    // To check if value attribute is prepopulated or not
                    if( $A.util.isEmpty(value) ) {
                        component.set('v.recordsList',result);        
                    } else {
                        component.set('v.selectedRecord', result[0]);
                    }
                } else {
                    component.set('v.message', "No Records Found for '" + searchString + "'");
                }
            } else {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }
            }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            $A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    showToast: function(component, event, helper, title, type, mode, duration, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "mode": mode,
            "duration": duration,
            "message": message
        });
        toastEvent.fire();
        
    },
    /*
    tripDateAndTime:function(component,event){
          var isValid = true;
        debugger;
        var typeOfCase = component.get("v.typeOfCase");
        var jsonData = component.get("v.requestLineList");
        for (var i = 0; i < jsonData.length; i++) {
            var data = jsonData[i];
            var tripDateValue = data.Trip_Date__c;
            for (var key in data) {
                // Additional validation for arrival time if selected date is lesser than 24 hours
                if (key === 'Arrival_Time_To_Activity__c' && tripDateValue) {
                    var arrivalDate = new Date(tripDateValue + " " + data[key]);
                    console.log('121  '+arrivalDate); 
                    var arrivalTimeDifference = arrivalDate - new Date();
                    console.log('122  '+arrivalTimeDifference); 
                    var arrivalHoursDifference = Math.floor(arrivalTimeDifference / (1000 * 60 * 60));
                    console.log('123 '+arrivalHoursDifference);
                    if (arrivalHoursDifference < 24) {
                        alert('Arrival time must be at least 24 hours from now');
                    } 
                    
                }
            }
        }
         return isValid;
    },
    */
    validateAccountList: function(component, event) {
        debugger;
        var resultnormal = new Date();
        resultnormal.setDate(resultnormal.getDate() + 3);
        var plus3fromToday = $A.localizationService.formatDate(resultnormal, "YYYY-MM-DD");
        var emergencyDate = new Date();
        var emergencytoday = $A.localizationService.formatDate(emergencyDate, "YYYY-MM-DD");
        emergencyDate.setDate(emergencyDate.getDate());
        var typeOfCase = component.get("v.typeOfCase");
        var isValid = true;
        var jsonData = component.get("v.requestLineList");
        var missingFields = {};
        
        
      /*  for (var i = 0; i < jsonData.length; i++) {
            var data = jsonData[i];
            // Check if any field is null or empty
            for (var key in data) {
                if (data.hasOwnProperty(key) && (data[key] === null || data[key] === '')) {
                    isValid = false;
                    missingFields[key] = true;
                    var tripDateValue = data.Trip_Date__c;
                    // Format date and time fields
                    if (key === 'Trip_Date__c' && data[key]) {
                        
                        var tripDate = new Date(data[key]);
                        data[key] = tripDate.toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });
                        
                    }
                    
                    if (key === 'Arrival_Time_To_Activity__c' && data[key] ) {
                        // var arrivalTime = new Date(data[key]);
                        //var formattedTime = $A.localizationService.formatTimeUTC(arrivalTime);
                        // data[key] = formattedTime;
                    }
                    
                    if (key === 'Leaving_time_from_Location__c' && data[key]) {
                        // var leavingTime = new Date(data[key]);
                        
                        // data[key] = leavingTime.toISOString().substr(11, 12); // Extracts HH:mm:ss.SSSZ from the ISO string
                    }
                    // Additional validation for specific fields
                    if (key === 'School_Names__c') {
                        missingFields[key] = 'اسم المدرسة مطلوب لذا لا يمكنك تخطيه';
                    }
                    
                }
            }
            
            // Additional validation based on typeOfCase
            if (typeOfCase === 'عادي') {
                if (tripDateValue < plus3fromToday) {
                    isValid = false;
                    missingFields[key] = 'إذا كان طلبك عادياً فإنك تختار التاريخ بعد ثلاثة أيام من اليوم';
                }
            }
            
        }
        component.set("v.requestLineList", jsonData);
        
        
        if (!isValid) {
            // There is a missing or invalid Trip_Date__c field, show the error
            this.showFieldErrors(component, missingFields);
            
        }
        */
        
        return isValid;
    },
    showFieldErrors: function(component, missingFields) {
        component.set('v.showSpinner',false);
        for (var field in missingFields) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Error',
                message: missingFields[field],
                duration: '2000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
        }
    },
    showToast: function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    checkBeforeInsertGlobalReq: function(component, event, helper) {
        // Get the values from the component
        debugger;
        var todayDate = new Date();
        todayDate.setDate(todayDate.getDate() + 3);
        var plus3fromToday = $A.localizationService.formatDate(todayDate, "YYYY-MM-DD");
        var typeOfCase = component.get("v.typeOfCase");
        var jsonData = component.get("v.requestLineList");
        // Perform validation
        if (!typeOfCase) {
            // Type of case is empty or only contains whitespace
            // Show toast message for validation error
            this.showToast("Error", "Type of Case is required.", "error");
            component.set('v.showSpinner',false);
            return false;
        }
        if (!jsonData || jsonData.length === 0) {
            // jsonData is empty or undefined
            // Show toast message for validation error
            this.showToast("Error", "Request Line List is required.", "error");
            component.set('v.showSpinner',false);
            return false;
        }
       
        // Additional validation for 'Urgent' type of case
        for (var i = 0; i < jsonData.length; i++) {
            var data = jsonData[i];
            
            
            // Check if any field value is missing or empty
            for (var key in data) {
            
                if (data.hasOwnProperty(key)) {
                    var tripDateValue = data.Trip_Date__c;
                    var value = data[key];
                    if (value === undefined || value === null || value === "") {
                        this.showToast("Error", key + " is required.", "error");
                        component.set('v.showSpinner', false); // Hide the spinner
                        return false;
                    }
                    console.log("Key: ", key, ", Value: ", value);
                    if(key==='Arrival_Time_To_Activity__c' || key === 'Leaving_time_from_Location__c'){
                       // console.log("Value before appending 'Z':", value);
                        value += 'Z';
                        data[key] = value;
                        console.log("Value after appending 'Z':", value);
                        
                    }
                    if(typeOfCase === 'عادي'){
                        if (tripDateValue < plus3fromToday) {
                            this.showToast("Error", "Normal Request Date Should  greater than 3 days", "error");
                            component.set('v.showSpinner', false); // Hide the spinner
                            return false;
                        }
                    }
                }
            /*  if (typeOfCase === 'عاجل' && tripDateValue) {
                    var today = new Date();
                    today.setHours(0, 0, 0, 0); // Set time to midnight for comparison
                    var selectedDate = new Date(tripDateValue);
                    selectedDate.setHours(0, 0, 0, 0); // Set time to midnight for comparison
                    if (selectedDate.getTime() === today.getTime()) {
                        var currentHour = new Date().getHours();
                        if (currentHour < 7 || currentHour >= 14) {
                            this.showToast("Error", "For today, requests can only be created during working hours (07:00 to 14:00)", "error");
                            component.set('v.showSpinner', false); // Hide the spinner
                            return false;
                        }
                        this.showToast("Error", "For Urgent requests, trip date should not be today. Please add a date greater than today.", "error");
                        component.set('v.showSpinner', false);
                        return false;
                    }
                }*/
                
                if (typeOfCase === 'عاجل' && tripDateValue) {
                    var today = new Date();
                    today.setHours(0, 0, 0, 0); // Set time to midnight for comparison
                    var selectedDate = new Date(tripDateValue);
                    selectedDate.setHours(0, 0, 0, 0); // Set time to midnight for comparison
                      if (today.getDay() === 5 && new Date().getHours() >= 11) {
                        this.showToast("Error", "Requests cannot be created after 11:00 AM on Fridays.", "error");
                        component.set('v.showSpinner', false); // Hide the spinner
                        return false;
                    }
                    if (selectedDate.toDateString() === today.toDateString()) {
                        // Case: Selected date is the same as today
                        this.showToast("Error", "Requests cannot be created for the same date as today", "error");
                        component.set('v.showSpinner', false); // Hide the spinner
                        return false;
                    }
                    if (selectedDate.getTime() === today.getTime()) {
                        var currentHour = new Date().getHours();
                        if (currentHour < 7 || currentHour >= 14) {
                            this.showToast("Error", "For today, requests can only be created during working hours (07:00 am to 2:00 pm)", "error");
                            component.set('v.showSpinner', false); // Hide the spinner
                            return false;
                        }
                      
                    } else if (selectedDate > today) { // Check if trip date is in the future
                        var currentHour = new Date().getHours();
                        if (currentHour >= 14) { // Check if current time is after 13:00
                            this.showToast("Error", "For future dates, requests can only be created during working hours (before 2:00 pm)", "error");
                            component.set('v.showSpinner', false); // Hide the spinner
                            return false;
                        }
                    } else {
                        // Handle the case where the selected date is in the past
                        this.showToast("Error", "For Urgent requests, trip date should be today. Please select today's date.", "error");
                        component.set('v.showSpinner', false);
                        return false;
                    }
                }
                
                
            }
         
           
        }
        
     // If all validation passes, return true
     return true;
     console.log('final data   ',jsonData);
     component.set("v.requestLineList", jsonData);
     // Example: Insert global request logic
     // helper.insertGlobalRequest(component);
 },
    saveAccountList: function(component, event, helper) {
        
        console.log('Inside SaveAccountList..');
        var caseId = component.get("v.CaseId");
        console.log('case ID '+caseId);
        var requestLinesJSON = JSON.stringify(component.get("v.requestLineList"));
        console.log('line data.'+ requestLinesJSON);
        var createCaseAction = component.get("c.saveRequestLines");
        createCaseAction.setParams({
            "caseId": caseId,
            "requestLinesJSON": requestLinesJSON
        });
        createCaseAction.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('state: '+state);
            console.log('result: '+JSON.stringify(result));
            if (state === "SUCCESS") {
                // Show success toast message
                if(result.isSuccess == true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Request lines saved successfully.",
                        "type": "success"
                    });
                    toastEvent.fire();
                    location.reload();
                    console.log("Request lines saved successfully!");
                }else if(result.isSuccess == false && result.message != null){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'sticky',
                        "title": "Error!",
                        "message": 'Request is failed to create. !Please contact System Admin. Error: '+result.message,
                        "type": "error",
                    });
                    toastEvent.fire();
                    console.log('message: '+result.message);
                }
                component.set('v.showSpinner',false);
            } else if (state === "ERROR") {
                // Handle errors and show an error toast message
                var errors = response.getError();
                if (errors) {
                    for (var i = 0; i < errors.length; i++) {
                        console.error("Error message: " + errors[i].message);
                    }
                }
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "An error occurred while saving request lines.",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });
        
        $A.enqueueAction(createCaseAction);
    },
    addAccountRecord: function(component, event) {
        var eseReqLineObjectFiled = component.get("v.requestLineList");
        eseReqLineObjectFiled.push({
            'School_Names__c':'',       
            'Trip_Date__c':'',
            'Trip_Destination_From__c':'',
            'Trip_Destination_To__c':'',
            'Trip_Coordinator_Name__c':'',
            'Coordinator_Phone__c':'',
            'Email__c': '',
            'Cycle__c':'',
            'Count_Of_Students__c':'',
            'Special_Need_Students_Count__c':'',
            'Supervisors_Count_From_School__c':'',
            'Arrival_Time_To_Activity__c':'',
            'Assembly_Point__c':'',
            'Landmark_Trip_To__c':'',
            'Landmark_Trip_From__c':'',
            'Gender_AR__c':'',
            'Leaving_time_from_Location__c':''
            
        });
        component.set("v.requestLineList", eseReqLineObjectFiled);
    },
    handlefileAttached: function(component, event, helper, caseId) {
        try {
            debugger;
            var fileList = component.get("v.fileList") || [];
            var recordIdString = caseId; // Ensure you pass the case ID correctly
            
            var action = component.get("c.attachFileToCase");
            action.setParams({
                recordId: recordIdString,
                filesData: JSON.stringify(fileList)
            });
    
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    alert("File attached to Case.");
                    
                    $A.get('e.force:showToast').setParams({
                        "title": "Success",
                        "message": "Case is created successfully!",
                        "type": "success"
                    }).fire();
                    
                    component.set('v.showSpinner', false);
                    // Optionally reload or refresh the data
                    // location.reload();
                } else {
                    console.error("Error attaching file to Case: ", response.getError());
                    $A.get('e.force:showToast').setParams({
                        "title": "Error",
                        "message": "Error attaching file to Case!",
                        "type": "error"
                    }).fire();
                }
            });
    
            $A.enqueueAction(action);
    
        } catch (e) {
            console.error("Exception: " + e.message);
            $A.get('e.force:showToast').setParams({
                "title": "Error",
                "message": "Exception occurred while attaching file to Case!",
                "type": "error"
            }).fire();
        }
    }
    
})