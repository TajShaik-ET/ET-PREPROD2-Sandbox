({
    
    closeModel: function (component, event, helper) {
        component.set('v.newCase',false);
        var actionEvt = $A.get("e.c:ETST_sendDataEvent");
        actionEvt.setParams({
            "actionname": 'refresh' 
        });
        actionEvt.fire();
        /* $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Case is created succesfully!",
            "type": "success",
        }).fire();*/
    },
    skipModel:function (component, event, helper) {
        component.set('v.newCase',false);
        var actionEvt = $A.get("e.c:ETST_sendDataEvent");
        actionEvt.setParams({
            "actionname": 'refresh' 
        });
        actionEvt.fire();
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Case is created succesfully!",
            "type": "success",
        }).fire();
    },
    toggle: function (component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var lang = url.searchParams.get("lang");
        component.set('v.loadEdirForm',true);
        var nav = component.find("mySelect").get("v.value");
        //var nav = sel.get("v.value");
        console.log('nav----->'+nav);
        $A.util.removeClass(component.find("submit"), "slds-hide");
        if (nav === component.get('v.clNone')){
            helper.resetFlags(component, event, helper);
            component.find('OppMessage').setError(''); 
        }
        else if (nav === component.get('v.clGrowthRequestsforVehicleNannyandCoordinator')) {
            component.find('OppMessage').setError('');
            console.log('--->inside invoice');	           
            helper.resetFlags(component, event, helper); 
            component.set("v.GrowthRequest", true);
            component.set("v.RecordTypeId",$A.get("$Label.c.GrowthReqRecTypeId"));
        }else if(nav === component.get('v.clHandicapServicesTransportationorNannyRequest')){
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper); 
            component.set("v.HandicapService", true);
            component.set("v.RecordTypeId",$A.get("$Label.c.HandicapRecTypeId"));  
        }else if(nav === component.get('v.clTeachersTransportationRequest')){
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper); 
            component.set("v.NewTeacherTransport", true);
            component.set("v.RecordTypeId",$A.get("$Label.c.TeachersRecTypeId"));
        }else if(nav === component.get('v.clAwarenessSessionRequest')){
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper); 
            component.set("v.AwarenessSession", true);
            component.set("v.RecordTypeId",$A.get("$Label.c.AwarenessRecTypeId"));
        }else if(nav === component.get('v.clRequestaboardingpassforCompanionHandycamptransportation')){
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper); 
            component.set("v.RequestaboardingpassforCompanionHandycamptransportation", true);
            console.log('--->inside invoice RequestaboardingpassforCompanionHandycamptransportation true');	
            component.set("v.RecordTypeId",$A.get("$Label.c.Companian_Handicap_TransportationRecTypeId"));
        }
            else if(nav === component.get('v.clActivitiesEvents')){
                component.find('OppMessage').setError('');
                helper.resetFlags(component, event, helper); 
                component.set("v.NewTripsRequest", true); 
                component.set("v.RecordTypeId",$A.get("$Label.c.ActivitiesRecTypeId"));
                component.set('v.loaded',true);
            }
    },
    doInit : function(component, event, helper){  
        var test = component.get('v.userParentProfileWrap');
        console.log('test log '+JSON.stringify(test));
        helper.setCommunityLanguage(component, event, helper);
        if (navigator.geolocation) {
            console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit =  position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.lat',latit);
                component.set('v.lon',longit);
                component.set('v.vfUrl','/Business/apex/ETST_GoogleMapFinder?lat='+latit+'&long='+longit);
                console.log('vfUrl'+component.get('v.vfUrl'));
            });
        }else{
            console.log("Unable to retrieve your location");
        }     
        
        var urlString=window.location.href;
        var vfOrigin = urlString.substring(0, urlString.indexOf("/Business/s"));
        window.addEventListener("message", $A.getCallback(function(event) {
            
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                //console.log(event.data);
                return;
            }
            // Handle the message
            console.log(event);
            var message = event.data;
            console.log('message-->'+message);
            /*if(message=='PaymentCancelled'){
                //helper.redirectTo(component, '/etst-home-page');
            }*/
            var res = message.split("~");
            if(res.length > 0){ 
                component.set('v.lat',res[0]);
                component.set('v.lon',res[1]);
                
            }
            
        }), false);
        helper.doInit(component, event, helper);
        // $A.util.addClass(component.find("spinner"), "slds-hide"); 
    },
    handleOnLoad : function(component, event, helper) {
        component.set('v.loaded',true);
        //$A.util.addClass(component.find("spinner"), "slds-hide");    
    },
    handleOnError : function(component, event, helper) {
        component.set('v.isDisabled',false);
        console.log("inside error");
        console.log(JSON.stringify(event));
    },
    refresh: function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    handleUploadFinished: function(component, event, helper) {
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Case is created succesfully!",
            "type": "success",
        }).fire();
        component.set('v.newCase',false);
        var actionEvt = $A.get("e.c:ETST_sendDataEvent");
        actionEvt.setParams({
            "actionname": 'refresh'
        });
        
        actionEvt.fire();
    },
    getLocationDetails: function(component, event, helper){
        component.set('v.openMap',false);
        var lat=component.get('v.lat');
        var long=component.get('v.lon');
        if(lat!=null && lat!='' && lat!=undefined){
            helper.getLocationDetails(component, event, helper,lat,long);
        }
        component.set("v.searchText", '');
    },
    handleOnSuccess : function(component, event, helper) { 
        var type = component.find("mySelect").get("v.value");
        var payload = event.getParams().response;
        component.set('v.newCaseId',payload.id);
        var casid=component.get("v.newCaseId");  
        helper.handlefileAttached(component, event, helper,casid);
       // component.set('v.showSpinner', false);
        if(type==component.get("v.clGrowthRequestsforVehicleNannyandCoordinator")){
            component.set('v.newCase',false);
            //alert("Case cretaed Successful");
            helper.showToast(component, "Success", "Success!", "Case is created succesfully!","success","info_alt","pester");
            var actionEvt = $A.get("e.c:ETST_sendDataEvent");
            actionEvt.setParams({
                "actionname": 'refresh'
            });
            actionEvt.fire();
        }
        /* 
      console.log('success');
        $A.util.addClass(component.find("submit"), "slds-hide");
        //$A.util.removeClass(component.find("spinner"), "slds-hide");    
        console.log('-----@@@inside success');
        var payload = event.getParams().response;
        console.log('payload '+payload.id);
        component.set('v.newCaseId',payload.id);
        var type = component.find("mySelect").get("v.value");
        if(type==component.get("v.clActivitiesEvents") || type==component.get("v.clAwarenessSessionRequest") || type==component.get("v.clRequestaboardingpassforCompanionHandycamptransportation")||type==component.get("v.clHandicapServicesTransportationorNannyRequest") ){
           // alert('inside if ');
            helper.resetFlags(component, event, helper); 
        		$A.util.removeClass(component.find("uploadImage"), "slds-hide");
           
                
                //$A.util.addClass(component.find("submit"), "slds-hide");
        }else{
           //  alert('inside else  ');
            component.set('v.newCase',false);
			
            //$A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:showToast').setParams({
                "title": "Success",
                "message": "Case is created succesfully!",
                "type": "success",
            }).fire();
            
            var actionEvt = $A.get("e.c:ETST_sendDataEvent");
                actionEvt.setParams({
                    "actionname": 'refresh'
                });
                
                actionEvt.fire();
        }
        //$A.get('e.force:refreshView').fire();
        //$A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Record has been saved!",
            "type": "success",
        }).fire();*/
    },
    
    handleChange: function (cmp, event) {
         var selectedOptionValue = event.getParam("value");
     //  alert(selectedOptionValue);
     //  component.set('v.zoneType', selectedOptionValue); 
        
       //  
    },
    handleOnSubmit : function(component, event, helper) {
        debugger;
        
     
        component.set('v.showSpinner', true);
        console.log('Case is Submitting ');
        event.preventDefault();
        //component.find('myform').submit(eventFields);
        var showValidationError = false;
        var validationFailReason='';
        var phonePattern = /^(?:\+971|971|00971)[0-9]{9}$/;
        var textPattern = /^[a-zA-Z\s]*$/;
        var numberPattern = /^\d*$/;
        var phoneNumber = component.get("v.phoneNumber");
        var parentName = component.get("v.ParentName");
        var InternalNumber = component.get("v.InternalNumber");
        var sisNumber = component.get("v.sisnumb");
        var studentName = component.get("v.studentName");
        
        
        var type = component.find("mySelect").get("v.value");
        var noofpassenger=component.get("v.noofpassenger");    
        var noofattendance=component.get("v.noofattendance");
        var noofstudents=component.get("v.noofstudents");
        var noofteachers=component.get("v.noofteachers");
        var cordinatorValue=component.get("v.cordinatorName");
        
        // var schoolname=component.get("v.selectedRecord");
        var schoolname = component.get("v.AccountId");
        var startDate = component.get("v.startDate");
        var selectedDate = new Date(startDate);
        selectedDate.setHours(0, 0, 0, 0); 
        var endDate = component.get("v.endDate");
         // var startDate = component.get("v.startDate");
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD THH:mm:ss");
        var result = new Date();
        result.setDate(result.getDate() + 14);
        var today = $A.localizationService.formatDate(result, "YYYY-MM-DD");
        var todayactivities = new Date();
        todayactivities.setHours(0, 0, 0, 0);
        var result2 = new Date();
        result2.setDate(result2.getDate() + 2);
        var today2 = $A.localizationService.formatDate(result2, "YYYY-MM-DD");
        // File Uploding new added
                var filesSpecailNeedsCard = component.get('v.fileSpecialNeedCard') || [];
        var fileStudentId = component.get('v.fileStudentEmirtaesID') || [];
        var fileResidancePermit = component.get('v.fileCompanionResidencePermit') || [];
        var fileHealthProblems = component.get('v.fileHealthProblems') || [];
        var filesDataStudentName = component.get('v.fileListOfStudentName') || [];
        var filesData = component.get('v.fileActvityVsAwerness') || [];
        var filesDataEmiratesID = component.get('v.fileListOfEmiratesId') || [];
        var filesDataMedical = component.get('v.fileListOfMedical') || [];
        var filesDataPassport = component.get('v.fileListPassport') || [];
        var filesDataAcademic = component.get('v.fileListAcademic') || [];
        var filesDataAcquaintance = component.get('v.fileListAcquaintance') || [];
        console.log('File Special Needs Card :' + filesSpecailNeedsCard.length);
        console.log('File Student ID :' + fileStudentId.length);
        console.log('File Residence Permit :' + fileResidancePermit.length);
        console.log('File Health Problems :' + fileHealthProblems.length);
        console.log('File Student Name Data :' + filesDataStudentName.length);
        console.log('File Awareness Data :' + filesData.length);
        console.log('File Emirates ID :' + filesDataEmiratesID.length);
        console.log('File Medical :' + filesDataMedical.length);
        console.log('File Passport :' + filesDataPassport.length);
        console.log('File Academic :' + filesDataAcademic.length);
        console.log('File Acquaintance :' + filesDataAcquaintance.length); 
        // Concatenating lists
        var fileStudentnamevsActivityAwareness = filesData.concat(filesDataStudentName);
        console.log('Combined Awareness and Student Name Data :' + fileStudentnamevsActivityAwareness.length);
        
        var EIDvsMedicalDataFiles = filesDataEmiratesID.concat(filesDataMedical);
        console.log('Combined EID and Medical Data :' + EIDvsMedicalDataFiles.length);
        
        var allFilesCompanion = filesDataEmiratesID.concat(
            filesDataPassport,
            filesDataMedical,
            filesDataAcademic,
            filesDataAcquaintance,
            filesSpecailNeedsCard,
            fileStudentId,
            fileResidancePermit,
            fileHealthProblems
        );
        console.log('All Companion Files :' + allFilesCompanion.length);
        var filews = component.get("v.showFileUpload");
        var istypefiles = component.get("v.selectedFileName");
        component.set("v.mergedListofEIDvsMedical", EIDvsMedicalDataFiles);
        component.set("v.mergedAllFilesCompanion", allFilesCompanion);
        component.set("v.mergedAllFilesstudentvsActivity", fileStudentnamevsActivityAwareness);
        
        if(type==component.get("v.clRequestaboardingpassforCompanionHandycamptransportation")){
            if(filesDataPassport.length ==0 && filesDataMedical.length ==0 && filesDataAcademic.length ==0 && filesDataAcquaintance.length==0 && filesSpecailNeedsCard.length==0 && fileStudentId.length==0 && fileResidancePermit==0 && fileHealthProblems==0 && fileListOfCriminalRecord==0 ){
                showValidationError = true;
                helper.showToast(component, "Error", "Error Message!", "Attachment is required","error","info_alt","pester");
                // validationFailReason = 'Attachment is required, please select a file to continue';
            }
        }
        if(type==component.get("v.clHandicapServicesTransportationorNannyRequest")){
            if(filesDataEmiratesID.length ==0 || filesDataMedical.length ==0){
                showValidationError = true;
                helper.showToast(component, "Error", "Error Message!", "Attachment is required","error","info_alt","pester");
            }
        }
        if((filesData.length==0 && type==component.get("v.clActivitiesEvents"))){
            if(filesData.length ==0 || filesDataStudentName.length ==0){
            showValidationError = true;
            helper.showToast(component, "Error", "Error Message!", "Attachment is required","error","info_alt","pester");
            }
            
        }
        if((filesData.length==0 && type==component.get("v.clAwarenessSessionRequest"))){
            showValidationError = true;
            helper.showToast(component, "Error", "Error Message!", "Attachment is required","error","info_alt","pester");
        }
        if (type == component.get("v.clActivitiesEvents")) {
          if (component.get("v.startDate") != '' && component.get("v.startDate") < today) {
                showValidationError = true;
                helper.showToast(component, "Error", "Preferred Start Date", "Preferred Start date should be 2 days greater than today", "error", "info_alt", "pester");
            }
            
            if (selectedDate.getTime() === todayactivities.getTime()) {
                var currentHour = new Date().getHours();
                if (currentHour < 7 || currentHour >= 14) {
                    helper.showToast("Error", "For today, requests can only be created during working hours (06:00 am to 2:00 pm)", "error");
                    component.set('v.showSpinner', false); // Hide the spinner
                    showValidationError = true;
                }
                
            }
            /*  
            if (endDate < startDate) {
                showValidationError = true;
                helper.showToast(component, "Error", "Preferred End Date", "End date should be greater than the start date", "error", "info_alt", "pester");
            }
            */
            if (phonePattern.test(phoneNumber)) {
               // showValidationError = false;
                component.set("v.phoneNumberError", false);
                // alert("Valid UAE phone number");
            } else {
                // Phone number is not valid, display an error message
                showValidationError = true;
                component.set("v.phoneNumberError", true);
                 //alert("Invalid UAE phone number");
              helper.showToast(component, "Error", "Phone Number", "Invalid UAE phone number", "error", "info_alt", "pester");
            }
        }
        if (type == component.get("v.clGrowthRequestsforVehicleNannyandCoordinator")) {
            if (phonePattern.test(phoneNumber) && textPattern.test(cordinatorValue)) {
                showValidationError = false;
                component.set("v.phoneNumberError", false);
                component.set("v.cordinatorNameError", false);
            } else {
                showValidationError = true;
                
                component.set("v.phoneNumberError", !phonePattern.test(phoneNumber));
                component.set("v.cordinatorNameError", !textPattern.test(cordinatorValue));
                
               
            }
        }
         if (type == component.get("v.clHandicapServicesTransportationorNannyRequest")) {
             if (component.get("v.startDate") != '' && component.get("v.startDate") < today2) {
                 showValidationError = true;
                 helper.showToast(component, "Error", "Preferred Start Date", "Preferred Start date should be 3 days greater than today", "error", "info_alt", "pester");
             }
           /* if (phonePattern.test(phoneNumber) && textPattern.test(cordinatorValue) && textPattern.test(parentName) && textPattern.test(studentName) ) {
                showValidationError = false;
                component.set("v.errorMessage", false);

                
            } else {
                showValidationError = true;
                
                component.set("v.phoneNumberError", !phonePattern.test(phoneNumber));
                component.set("v.errorMessage", !textPattern.test(cordinatorValue));
                component.set("v.errorMessage", !textPattern.test(parentName));
                 component.set("v.errorMessage", !textPattern.test(studentName));
                
               
            }*/
        }
        
        
        if(component.get("v.startDate") != '' && component.get("v.startDate") < today && type==component.get("v.clAwarenessSessionRequest")){
            showValidationError = true;
            component.set('v.showSpinner', false);
            //validationFailReason = '';
            helper.showToast(component, "Error", "Error Message!", "Preferred Start date should be 2 weeks greater than today","error","info_alt","pester");
        }
        if(noofpassenger<=0){
            showValidationError = true;
            // validationFailReason = 'No of passengers should not be less than or equal to 0(zero)';
            component.set('v.noofpassengerError',true);
        }
        
        if(noofattendance<=0){
            showValidationError = true;
            // validationFailReason = 'No of attendance should not be less than or equal to 0(zero)';
            component.set('v.noofattendanceError',true);
        }
        if(noofstudents<=0){
            showValidationError = true;
            //  validationFailReason = 'No of students should not be less than or equal to 0(zero)';
            component.set('v.noofstudentsError',true);
        }
        if(noofteachers<=0){
            showValidationError = true;
            // validationFailReason = 'No of teachers should not be less than or equal to 0(zero)';
            component.set('v.noofteachersError',true);
        }
          
       
        if(showValidationError)
            component.set('v.showSpinner', false);
        
        if(!showValidationError) {
            
            component.find('OppMessage').setError('');    
            console.log('-------2----');
            var eventFields = event.getParam("fields"); //get the fields
            //Add Description field Value
            console.log('type***'+type);
            var userParentProfileWrap = component.get('v.userParentProfileWrap');
            console.log('userParentProfileWrap '+JSON.stringify(userParentProfileWrap));
            var privateProfileLabel =  $A.get("$Label.c.ET_Private_School_Profile_Name");
            if(userParentProfileWrap.loggedinUserProfileName != privateProfileLabel){
                if(type==component.get("v.clActivitiesEvents")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Department Of School Activities';
                }else if(type==component.get("v.clGrowthRequestsforVehicleNannyandCoordinator")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Operation Supervisors';
                }else if(type==component.get("v.clTeachersTransportationRequest")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Personnel Management';
                }else if(type==component.get("v.clHandicapServicesTransportationorNannyRequest")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending Hemam for Inclusive Education services';
                }else if(type==component.get("v.clAwarenessSessionRequest")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Head of Safety Unit';
                }else if(type==component.get("v.clRequestaboardingpassforCompanionHandycamptransportation")){
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending Hemam for Inclusive Education services';
                }
                    else{
                        eventFields["Status"] = 'New';
                    }
            }else if(userParentProfileWrap.loggedinUserProfileName == privateProfileLabel){
                if(type==component.get("v.clActivitiesEvents")){
                    eventFields["Status"] = 'In Progress';
                    if(userParentProfileWrap.isParent){
                        eventFields["Status_Category__c"] = 'Pending with Main School';
                    }else{
                        eventFields["Status_Category__c"] = 'Pending with School Transportation Manager'; 
                    }
                }
                else if(type==component.get("v.clHandicapServicesTransportationorNannyRequest")){
                    eventFields["Status"] = 'In Progress';
                    if(userParentProfileWrap.isParent){
                        eventFields["Status_Category__c"] = 'Pending with MOE-Inclusive Education for Student of Determination';
                    }
                }
                    else if(type==component.get("v.clGrowthRequestsforVehicleNannyandCoordinator")){
                        eventFields["Status"] = 'In Progress';
                        if(userParentProfileWrap.isParent){
                            eventFields["Status_Category__c"] = 'Pending with Statistics Coordinator';
                        }
                    }
                        else if(type==component.get("v.clTeachersTransportationRequest")){
                            eventFields["Status"] = 'In Progress';
                            if(userParentProfileWrap.isParent){
                                eventFields["Status_Category__c"] = 'Pending with Main School';
                            }     
                            
                        }
                            else if(type==component.get("v.clAwarenessSessionRequest")){
                                eventFields["Status"] = 'In Progress';
                                if(userParentProfileWrap.isParent){
                                    eventFields["Status_Category__c"] = 'Pending with Head of Safety Unit';
                                }
                                
                            }
                                else if(type==component.get("v.clRequestaboardingpassforCompanionHandycamptransportation")){
                                    eventFields["Status"] = 'In Progress';
                                    if(userParentProfileWrap.isParent){
                                        eventFields["Status_Category__c"] = 'Pending Hemam for Inclusive Education services';
                                    }
                                    
                                }
                                    else{
                                        eventFields["Status"] = 'New';
                                    }
                
            }
            eventFields["Origin"] = 'CRM Portal';
            
            eventFields["AccountId"]=component.get("v.AccountId");
            console.log(component.get("v.values"));
            let arrayData = component.get("v.values");
            let concatenatedData = arrayData.join(', ');
            eventFields["Zone_Type_Growth_Request__c"] = concatenatedData;
            let arrayDataAR = component.get("v.valuesAR");
            let concatenatedDataAR = arrayData.join(', ');
            eventFields["Zone_Type_Growth_Request__c"] = concatenatedDataAR;
            
           
           // eventFields["Zone_Type_Growth_Request"]=component.get("v.zoneType");
            console.log('accid',component.get("v.AccountId"));
            eventFields["ContactId"]=component.get("v.contactId");
            eventFields["Trip_Destination__c"]=component.get("v.tripLoc");
            if(component.get('v.clLang') =='ar'){
                eventFields["ETST_Student__c"]=component.get("v.selectedRecord.value"); 
            }        
            //return false;
            component.find('caseFormMOE').submit(eventFields);
            //Submit Form
            console.log('CASE is Submitting SuccesFully');
        }else {
            console.log('_Case Submit has some Ererror ________');
            component.find('OppMessage').setError(validationFailReason, false);
            component.set('v.isDisabled',false);
            // helper.showToast(component, "error", "Error Message!", "Attachment is required");
            
        }
        
    },
  
    validateNumberInput: function(component, event, helper) {
    var selectedOptionValue = event.getSource().get("v.value");
    if (/[^0-9]/.test(selectedOptionValue)) {
        // Display an error message using the notifications library
        component.find('notifLib').showToast({
            "title": "Error",
            "message": "Please enter numbers only.",
            "variant": "error"
        });
        // Reset the input value to remove non-numeric characters
        var numericValue = selectedOptionValue.replace(/[^0-9]/g, '');
        event.getSource().set("v.value", numericValue);
    }
},
    
    openMapController : function(component, event, helper) {        
        component.set('v.openMap',true);
    },
    closeMapModel: function(component, event, helper) {
        component.set('v.openMap',false); 
        component.set("v.searchText", '');
    },
    getSearchResultbyEnter: function(component, event, helper) {  
        window.addEventListener("keyup", function(event) {
            if(event.code == "Enter"){
                component.set('v.mapLoaded',false);
                helper.getAddressRecommendations(component, event,helper, component.get('v.searchText'));
            } 
        }, true);
    },
    getSearchResult: function(component, event, helper) {
        component.set('v.mapLoaded',false);
        helper.getAddressRecommendations(component, event,helper, component.get('v.searchText'));
        
    },
    getstudentdet: function(component, event, helper) {
        var action = component.get('c.getstudentDetails');
        var studid=component.get('v.studdid').toString();
        action.setParams({
            studentid: studid
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.table(result);                
                component.set('v.sisnumb', result.ETST_Student_Id__c);
                component.set('v.sgrade', result.ETST_Division__c);
                component.set('v.sparent', result.ETST_Account_Name__c);
                component.set('v.sparentAR', result.ETST_Account_Name__r.ETST_Full_Name_AR__c);
                console.log(result.ETST_Student_Id__c);
                console.log(result.ETST_Division__c);
                console.log(result.ETST_Account_Name__c);
            }else if (state === "ERROR") {
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
        $A.enqueueAction(action);
        // component.set('v.sisnumb','testid');
    },
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            console.log('Test'+JSON.stringify(recordsList));
            //alert(event.currentTarget.id);
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }
            var recId = (event.currentTarget.id);
            var recordIdString = recId.toString();
            var action = component.get('c.getstudentDetails');
            action.setParams({
                studentid: recordIdString
            });
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                var state = response.getState();
                console.log(state);
                if (state === "SUCCESS") {             
                    component.set('v.sisnumb', result.ETST_Student_Id__c);
                    component.set('v.sgrade', result.ETST_Division__c);
                    component.set('v.sparent', result.ETST_Account_Name__c);
                    component.set('v.sparentAR', result.ETST_Account_Name__r.ETST_Full_Name_AR__c);
                    console.log(result.ETST_Student_Id__c);
                }else if (state === "ERROR") {
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
            $A.enqueueAction(action);
            component.set('v.selectedRecord',selectedRecord);
            component.set('v.value',selectedRecord.value);
            component.set('v.studName',selectedRecord.label);
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
        
    },
    searchRecords : function( component, event, helper ) {
        if( !$A.util.isEmpty(component.get('v.searchString')) ) { 
            helper.searchRecordsHelper( component, event, helper, '' );
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    showRecords : function( component, event, helper ) {
        if(!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },
    blurEvent : function( component, event, helper ){
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    handleChangeSubRequest1: function(component, event, helper) {
        var selectedOptionValue = event.getSource().get("v.value");
       
        var selectedValues = ["Transportation", "Other", "أخرى","Other health problems","مشاكل صحية أخرى"]; // Add multiple values here
        var showFileUpload = selectedValues.includes(selectedOptionValue);
        console.log(''+showFileUpload);
        component.set("v.showFileUpload", showFileUpload);
    },
    handleChangeSubRequest2: function(component, event, helper) {
        var selectedOptionValue = event.getSource().get("v.value");
        
    },
    //Files Uploading with data All Controller
      removeFile: function (component, event, helper) {
        // Retrieve the attribute name and index from the event
        var attributeName = event.currentTarget.dataset.attribute;
          
          // e.g., "v.fileListOfEmiratesId"
        var index = event.currentTarget.dataset.record;

        // Use the reusable helper method to perform the removal
        helper.removeFileFromList(component, attributeName, index);
    },
    filesUploadeHandler: function(component, event, helper) {
        var fileName = event.getSource().get("v.name");
        //alert('Name of file '+fileName);
        var targetAttribute = "";
        switch (fileName) {
            case 'StudentAawareness':
                targetAttribute = "v.fileActvityVsAwerness";
                break;
            case 'EmiratesID':
                targetAttribute = "v.fileListOfEmiratesId";
                break;
            case 'MedicalReport':
                targetAttribute = "v.fileListOfMedical";
                break;
            case 'CircularTrip':
                targetAttribute = "v.fileActvityVsAwerness";
                break;
            case 'StudentName':
                targetAttribute = "v.fileListOfStudentName";
                break;
            case 'SpecialNeedCard':
                targetAttribute = "v.fileSpecialNeedCard";
                break;
            case 'Academics':
                targetAttribute = "v.fileListAcademic";
                break;
            case 'Acquaintance':
                targetAttribute = "v.fileListAcquaintance";
                break;
            case 'ResidencePermit':
                targetAttribute = "v.fileCompanionResidencePermit";
                break;
            case 'Passport':
                targetAttribute = "v.fileListPassport";
                break;
            case 'HealthDocument':
                targetAttribute = "v.fileHealthProblems";
                break;
            case 'StudentEmiratesID':
                targetAttribute = "v.fileStudentEmirtaesID";
                break;
            case 'CriminalRecord':
                targetAttribute = "v.fileListOfCriminalRecord";
                break;

                
            default:
                console.error("Invalid idname");
                return;
        }
        helper.handleFileUpload(component, event, targetAttribute);        
        
    },
    
   
})