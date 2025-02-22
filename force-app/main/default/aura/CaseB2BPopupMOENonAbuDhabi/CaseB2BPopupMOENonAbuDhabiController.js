({

    closeModel: function (component, event, helper) {
        component.set('v.newCase', false);
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
    skipModel: function (component, event, helper) {
        component.set('v.newCase', false);
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
        component.set('v.loadEdirForm', true);
        var nav = component.find("mySelect").get("v.value");
        //var nav = sel.get("v.value");
        console.log('nav----->' + nav);
        $A.util.removeClass(component.find("submit"), "slds-hide");

        if (nav === component.get('v.clNone')) {
            helper.resetFlags(component, event, helper);
            component.find('OppMessage').setError('');
        }
        else if (nav === component.get('v.clFleetGrowthRequest')) {
            component.find('OppMessage').setError('');
            console.log('--->inside invoice');
            helper.resetFlags(component, event, helper);
            component.set("v.GrowthRequest", true);
            component.set("v.RecordTypeId", $A.get("$Label.c.Fleet_Growth_Request_Rec_Type"));
            
        } else if (nav === component.get('v.clSpecialNeedsTransportationRequest')) {
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper);
            component.set("v.HandicapService", true);
       
            component.set("v.RecordTypeId", $A.get("$Label.c.Special_Needs_Transportation_Request_Rec_Type"));
            
        } else if (nav === component.get('v.clSpecialNeedsActivityAndEventRequest')) {
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper);
            component.set("v.NewTripsRequest", true);
            component.set("v.RecordTypeId", $A.get("$Label.c.Special_Needs_Activities_and_Events_Request_Rec_Type"));
            
        } else if (nav === component.get('v.clAwarenessSessionRequest')) {
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper);
            component.set("v.AwarenessSession", true);
            component.set("v.RecordTypeId", $A.get("$Label.c.AwarenessRecTypeId"));
        } else if (nav === component.get('v.clSpecialNeedsCompanionRequest')) {
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper);
            component.set("v.RequestaboardingpassforCompanionHandycamptransportation", true);
            console.log('RequestaboardingpassforCompanionHandycamptransportation true');
            component.set("v.RecordTypeId", $A.get("$Label.c.Special_Needs_Companion_Request_Rec_Type"));
        }
        else if (nav === component.get('v.clActivitiesEvents')) {
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper);
            component.set("v.NewTripsRequest", true);
            component.set("v.RecordTypeId", $A.get("$Label.c.ActivitiesRecTypeId"));
            component.set('v.loaded', true);
        }


    },
    doInit: function (component, event, helper) {
        var test = component.get('v.userParentProfileWrap');
        console.log('test log ' + JSON.stringify(test));
        helper.setCommunityLanguage(component, event, helper);
        if (navigator.geolocation) {
            console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function (position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.lat', latit);
                component.set('v.lon', longit);
                component.set('v.vfUrl', '/Business/apex/ETST_GoogleMapFinder?lat=' + latit + '&long=' + longit);
                console.log('vfUrl' + component.get('v.vfUrl'));
            });
        } else {
            console.log("Unable to retrieve your location");
        }

        var urlString = window.location.href;
        var vfOrigin = urlString.substring(0, urlString.indexOf("/Business/s"));
        window.addEventListener("message", $A.getCallback(function (event) {

            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                //console.log(event.data);
                return;
            }
            // Handle the message
            console.log(event);
            var message = event.data;
            console.log('message-->' + message);
            /*if(message=='PaymentCancelled'){
                //helper.redirectTo(component, '/etst-home-page');
            }*/
            var res = message.split("~");
            if (res.length > 0) {
                component.set('v.lat', res[0]);
                component.set('v.lon', res[1]);

            }

        }), false);
        helper.doInit(component, event, helper);
        // $A.util.addClass(component.find("spinner"), "slds-hide"); 
    },
    handleOnLoad: function (component, event, helper) {
        component.set('v.loaded', true);
        //$A.util.addClass(component.find("spinner"), "slds-hide");    
    },
    handleOnError: function (component, event, helper) {
        component.set('v.isDisabled', false);
        console.log("inside error");
        console.log(JSON.stringify(event));
    },
    refresh: function (component, event, helper) {
        helper.doInit(component, event, helper);
    },
    handleUploadFinished: function (component, event, helper) {
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Case is created succesfully!",
            "type": "success",
        }).fire();
        component.set('v.newCase', false);
        var actionEvt = $A.get("e.c:ETST_sendDataEvent");
        actionEvt.setParams({
            "actionname": 'refresh'
        });

        actionEvt.fire();
    },
    getLocationDetails: function (component, event, helper) {
        component.set('v.openMap', false);
        var lat = component.get('v.lat');
        var long = component.get('v.lon');
        if (lat != null && lat != '' && lat != undefined) {
            helper.getLocationDetails(component, event, helper, lat, long);
        }
        component.set("v.searchText", '');
    },
    handleOnSuccess: function (component, event, helper) {


        var payload = event.getParams().response;
        console.log('payload ' + payload.id);

        console.table('Students Data' + JSON.stringify(payload));
        component.set('v.newCaseId', payload.id);
        var casid = component.get("v.newCaseId");
helper.handlefileAttached(component, event, helper, casid);   
       
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

    handleOnSubmit: function (component, event, helper) {
       debugger;
        component.set('v.showSpinner', true);
        console.log('-------Your case is Created Succesfully---');
        event.preventDefault();
        console.log("startDate***" + component.get("v.startDate"));
        console.log("endDate***" + component.get("v.endDate"));
        var showValidationError = false;
        var validationFailReason = '';

        var type = component.find("mySelect").get("v.value");
       
        var noofpassenger = component.get("v.noofpassenger");

        var noofattendance = component.get("v.noofattendance");

        var noofstudents = component.get("v.noofstudents");

        var noofteachers = component.get("v.noofteachers");
        
        var schoolname = component.get("v.AccountId");

        var startDate = component.get("v.startDate");
         var endDate = component.get("v.endDate");
        // var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD THH:mm:ss");
        var result = new Date();
        result.setDate(result.getDate() + 14);
        var today = $A.localizationService.formatDate(result, "YYYY-MM-DD");
        var result2 = new Date();
        result2.setDate(result2.getDate() + 3);
        var today2 = $A.localizationService.formatDate(result2, "YYYY-MM-DD");
        var phonePattern = /^(?:\+971|971|00971)[0-9]{9}$/;
         var phoneNumber = component.get("v.phoneNumber");
        // File Uploding new added
        var filesData = component.get('v.fileActvityVsAwerness');
        var filesDataEmiratesID = component.get('v.fileListOfEmiratesId');
        var filesDataMedical = component.get('v.fileListOfMedical');
        var filesDataPassport = component.get('v.fileListPassport');
        var filesDataAcademic = component.get('v.fileListAcademic');
        var filesDataAcquaintance = component.get('v.fileListAcquaintance');
        var fEIDvsMedical = component.get('v.mergedListofEIDvsMedical');
        var EIDvsMedicalDataFiles = filesDataEmiratesID.concat(filesDataMedical);
        var allFilesCompanion = filesDataEmiratesID.concat(filesDataMedical, filesDataAcademic, filesDataPassport, filesDataAcquaintance);
        var filews = component.get("v.showFileUpload");
        var istypefiles = component.get("v.selectedFileName");
          var endDate = component.get("v.endDate");

        component.set("v.mergedListofEIDvsMedical", EIDvsMedicalDataFiles);
        component.set("v.mergedAllFilesCompanion", allFilesCompanion);

        if (type == component.get("v.clRequestaboardingpassforCompanionHandycamptransportation")) {
            if (filesDataPassport.length == 0 && fEIDvsMedical.length == 0 && filesDataAcademic.length == 0 && filesDataAcquaintance.length == 0) {
                showValidationError = true;
                helper.showToast(component, "Error", "Error Message!", "Attachment is required");
                // validationFailReason = 'Attachment is required, please select a file to continue';
            }

        }
        if (type == component.get("v.clHandicapServicesTransportationorNannyRequest")) {
            if (filesDataEmiratesID.length == 0 && filesDataMedical.length == 0) {
                showValidationError = true;
                helper.showToast(component, "Error", "Error Message!", "Attachment is required","error","info_alt","pester");
                // validationFailReason = 'Attachment is required, please select a file to continue';
            }

        }

        if ((filesData.length == 0 && type == component.get("v.clActivitiesEvents"))) {
            showValidationError = true;
            helper.showToast(component, "Error", "Error Message!", "Attachment is required","error","info_alt","pester");

            // validationFailReason = 'Attachment is required';

        }
        if ((filesData.length == 0 && type == component.get("v.clAwarenessSessionRequest"))) {
            showValidationError = true;
            helper.showToast(component, "Error", "Error Message!", "Attachment is required","error","info_alt","pester");

            // validationFailReason = 'Attachment is required';
        }


        if (type == component.get("v.clActivitiesEvents")) {
            if (component.get("v.startDate") != '' && component.get("v.startDate") < today2) {
                showValidationError = true;
                helper.showToast(component, "Error", "Preferred Start Date", "Preferred Start date should be 3 days greater than today", "error", "info_alt", "pester");
            }
          /*  
            if (endDate <= startDate) {
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
        if(type ==='Special Needs Activities and Events Request'){
            if (component.get("v.startDate") != '' && component.get("v.startDate") < today2) {
                showValidationError = true;
                helper.showToast(component, "Error", "Preferred Start Date", "Preferred Start date should be 3 days greater than today", "error", "info_alt", "pester");
            }
        }
    
        if(component.get("v.startDate") != '' && component.get("v.startDate") < today && type==component.get("v.clAwarenessSessionRequest")){
            showValidationError = true;
            //validationFailReason = '';
            helper.showToast(component, "Error", "Error Message!", "Preferred Start date should be 2 weeks greater than today","error","info_alt","pester");
        }
      
       
        if (noofpassenger <= 0) {
            showValidationError = true;
            // validationFailReason = 'No of passengers should not be less than or equal to 0(zero)';
            component.set('v.noofpassengerError', true);
        }

        if (noofattendance <= 0) {
            showValidationError = true;
            // validationFailReason = 'No of attendance should not be less than or equal to 0(zero)';
            component.set('v.noofattendanceError', true);
        }
        if (noofstudents <= 0) {
            showValidationError = true;
            //  validationFailReason = 'No of students should not be less than or equal to 0(zero)';
            component.set('v.noofstudentsError', true);
        }
        if (noofteachers <= 0) {
            showValidationError = true;
            // validationFailReason = 'No of teachers should not be less than or equal to 0(zero)';
            component.set('v.noofteachersError', true);
        }
       /* 
        if (phonePattern.test(phoneNumber)) {
            showValidationError = false;
            component.set("v.phoneNumberError", false);
            // alert("Valid UAE phone number");
        } else {
            // Phone number is not valid, display an error message
            showValidationError = true;
            component.set("v.phoneNumberError", true);
            // alert("Invalid UAE phone number");
        }
        */
        
      
        if (showValidationError)
            component.set('v.showSpinner', false);

        if (!showValidationError) {

            component.find('OppMessage').setError('');
            console.log('-------2----');
            debugger;
            var eventFields = event.getParam("fields"); //get the fields
            //Add Description field Value
            console.log('type***' + type);

            var userParentProfileWrap = component.get('v.userParentProfileWrap');
            console.log('userParentProfileWrap ' + JSON.stringify(userParentProfileWrap));
            var privateProfileLabel = $A.get("$Label.c.ET_Private_School_Profile_Name");
            if (userParentProfileWrap.loggedinUserProfileName != privateProfileLabel) {
                if (type == component.get("v.clActivitiesEvents")) {
                    eventFields["Status"] = 'In Progress';
                    //evetFields ["Northern_Emirates__c"]="True";
                    eventFields["Status_Category__c"] = 'Pending with Operation Supervisors';
                } else if (type == component.get("v.clGrowthRequestsforVehicleNannyandCoordinator")) {
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Operation Supervisors';
                } else if (type == component.get("v.clTeachersTransportationRequest")) {
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Personnel Management';
                } else if (type == component.get("v.clHandicapServicesTransportationorNannyRequest")) {
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending Hemam for Inclusive Education services';
                } else if (type == component.get("v.clAwarenessSessionRequest")) {
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Head of Safety Unit';
                } else if (type == component.get("v.clRequestaboardingpassforCompanionHandycamptransportation")) {
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending Hemam for Inclusive Education services';
                }
                
                //Added by Suraj
                else if (type == component.get("v.clFleetGrowthRequest")) {
                    eventFields["Status"] = 'In Progress';
                    eventFields["Status_Category__c"] = 'Pending with Operation Supervisors';
                }
                else if (type == component.get("v.clSpecialNeedsActivityAndEventRequest")) {
                    eventFields["Status"] = 'In Progress';
                    
                        eventFields["Status_Category__c"] = 'Pending with ESE Support Center';
                    
                }
                 else if (type == component.get("v.clSpecialNeedsTransportationRequest")) {
                    eventFields["Status"] = 'In Progress';
                    
                        eventFields["Status_Category__c"] = 'Pending with ESE Support Center';
                    
                }
                     else if (type == component.get("v.clSpecialNeedsCompanionRequest")) {
                         eventFields["Status"] = 'In Progress';
                         
                         eventFields["Status_Category__c"] = 'Pending with ESE Support Center';
                         
                     }
                else {
                    eventFields["Status"] = 'New';
                }
            } 
            if(component.get("v.values")!=undefined && component.get("v.values").length>0)
            eventFields["Zone_Type__c"]=component.get("v.values").join(';');
            
            if(component.get("v.valuesAR")!=undefined && component.get("v.valuesAR").length>0)
            eventFields["Zone_Type_AR__c"]=component.get("v.valuesAR").join(';');

            
            
            
            eventFields["Origin"] = 'CRM Portal';
            //  alert('acc id'+component.get("v.AccountId"));
            eventFields["AccountId"] = component.get("v.AccountId");
            console.log('accid', component.get("v.AccountId"));
            eventFields["ContactId"] = component.get("v.contactId");
            eventFields["Trip_Destination__c"] = component.get("v.tripLoc");

            console.log('student ' + component.get("v.selectedRecord.value"));
            if (component.get('v.clLang') == 'ar') {
                eventFields["ETST_Student__c"] = component.get("v.selectedRecord.value");
            }
            console.log('before sub,mit');
            console.log('school name ' + component.get("v.AccountName"));
            //return false;
           component.find('caseFormMOE').submit(eventFields);
            //Submit Form
            console.log('CASE is Submitting Success');
            // helper.showToast(component, "success", "Success", "Case created successfully");
            //  $A.get('e.force:refreshView').fire();
        } else {
            console.log('-------3----');
            component.find('OppMessage').setError(validationFailReason, false);
            component.set('v.isDisabled', false);

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
    openMapController: function (component, event, helper) {
        component.set('v.openMap', true);
    },
    closeMapModel: function (component, event, helper) {
        component.set('v.openMap', false);
        component.set("v.searchText", '');
    },

    getSearchResultbyEnter: function (component, event, helper) {
        window.addEventListener("keyup", function (event) {
            if (event.code == "Enter") {
                component.set('v.mapLoaded', false);
                helper.getAddressRecommendations(component, event, helper, component.get('v.searchText'));
            }
        }, true);
    },
    getSearchResult: function (component, event, helper) {
        component.set('v.mapLoaded', false);
        helper.getAddressRecommendations(component, event, helper, component.get('v.searchText'));

    },
    getstudentdet: function (component, event, helper) {

        console.log('stud' + component.get('v.studdid'));

        var action = component.get('c.getstudentDetails');
        var studid = component.get('v.studdid').toString();

        action.setParams({
            studentid: studid
        });
        action.setCallback(this, function (response) {
            var result = response.getReturnValue();

            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                console.table(result);
                //console.log(result.Name);
                //


                component.set('v.sisnumb', result.ETST_Student_Id__c);

                component.set('v.sgrade', result.ETST_Division__c);
               // component.set('v.sparent', result.ETST_Account_Name__c);
               
                //component.set('v.sparentAR', result.ETST_Account_Name__r.ETST_Full_Name_AR__c);
                console.log(result.ETST_Student_Id__c);
                console.log(result.ETST_Division__c);
                console.log(result.ETST_Account_Name__c);
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
        $A.enqueueAction(action);
        // component.set('v.sisnumb','testid');
    },



    // When an item is selected
    selectItem: function (component, event, helper) {

        if (!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            console.log('Test' + JSON.stringify(recordsList));
            //alert(event.currentTarget.id);
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if (index != -1) {
                var selectedRecord = recordsList[index];
            }


            var recId = (event.currentTarget.id);
            var recordIdString = recId.toString();
            var action = component.get('c.getstudentDetails');

            action.setParams({
                studentid: recordIdString
            });
            action.setCallback(this, function (response) {
                var result = response.getReturnValue();
                var state = response.getState();
                console.log(state);
                if (state === "SUCCESS") {
                    component.set('v.sisnumb', result.ETST_Student_Id__c);
                    component.set('v.sgrade', result.ETST_Division__c);
                    component.set('v.sparent', result.ETST_Account_Name__c);
                    component.set('v.sparentAR', result.ETST_Account_Name__r.ETST_Full_Name_AR__c);
                    console.log(result.ETST_Student_Id__c);
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
            $A.enqueueAction(action);


            component.set('v.selectedRecord', selectedRecord);
            component.set('v.value', selectedRecord.value);
            component.set('v.studName', selectedRecord.label);

            $A.util.removeClass(component.find('resultsDiv'), 'slds-is-open');



        }

    },



    // When a keyword is entered in search box
    searchRecords: function (component, event, helper) {
        if (!$A.util.isEmpty(component.get('v.searchString'))) {

            helper.searchRecordsHelper(component, event, helper, '');
        } else {
            $A.util.removeClass(component.find('resultsDiv'), 'slds-is-open');
        }
    },

    showRecords: function (component, event, helper) {
        if (!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'), 'slds-is-open');


        }
    },

    // To remove the selected item.
    removeItem: function (component, event, helper) {
        component.set('v.selectedRecord', '');
        component.set('v.value', '');
        component.set('v.searchString', '');
        setTimeout(function () {
            component.find('inputLookup').focus();
        }, 250);
    },

    // To close the dropdown if clicked outside the dropdown.
    blurEvent: function (component, event, helper) {
        $A.util.removeClass(component.find('resultsDiv'), 'slds-is-open');
    },
    handleChangeSubRequest1: function (component, event, helper) {
        var selectedOptionValue = event.getSource().get("v.value");

        var selectedValues = ["Transportation", "Other", "أخرى"]; // Add multiple values here
        var showFileUpload = selectedValues.includes(selectedOptionValue);
        console.log('' + showFileUpload);
        component.set("v.showFileUpload", showFileUpload);
    },

    handleChangeSubRequest2: function (component, event, helper) {
        var selectedOptionValue = event.getSource().get("v.value");
        /*  alert(selectedOptionValue);
          if (selectedOptionValue === "Transportation") {
              console.log('A1');
              component.set("v.ifTransportationAR", "وسائل النقل");
          } else if (selectedOptionValue === "Bus Supervisor") {
              console.log('A2 ');
              component.set("v.ifSupervisorAR", "مشرف حافلة");
          }
          
          if (selectedOptionValue === "وسائل النقل") {
              console.log('B1');
              component.set("v.ifTransportation", "Transportation");
          } else if (selectedOptionValue === "مشرف حافلة") {
              console.log('B2');
              component.set("v.ifSupervisor", "Bus Supervisor");
          }
          */

    },

    //Files Uploading with data All Controller
    filesUploadeActvityVsAwerness: function (component, event, helper) {
        var idname = event.getSource().get("v.name")
        try {
            var files = component.get("v.uploadedDocs");
            console.log(files);
            var fileUploadWrapper = component.get("v.fileActvityVsAwerness");
            console.log(fileUploadWrapper);
            var contentWrapperArr = [];
            if (files && files.length > 0 && fileUploadWrapper.length < 1) {
                for (var i = 0; i < files[0].length; i++) {
                    var file = files[0][i];
                    if (file.size <= 1000000) {
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;
                        reader.onloadend = function (e) {
                            var base64 = reader.result.split(',')[1]
                            fileUploadWrapper.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64
                            });
                            contentWrapperArr.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64
                            });
                            console.log(fileUploadWrapper);
                            component.set("v.fileActvityVsAwerness", fileUploadWrapper)
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "File uploaded successfully.",
                                "type": "success"
                            });
                            toastEvent.fire();
                        }
                        function handleEvent(event) {
                            if (contentWrapperArr.length == i) {
                                component.set("v.fileActvityVsAwerness", fileUploadWrapper)
                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please upload file less than 1 MB.",
                            "mode": "sticky"
                        });
                        toastEvent.fire();
                    }
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You cannot upload more than one file.",
                    "mode": "sticky"
                });
                toastEvent.fire();
            }

        } catch (e) {
            console.log(e.message);
        }
    },
    filesUploadeEmiratesID: function (component, event, helper) {
        var uniqueName = event.getSource().get("v.name")
        component.set("v.selectedFileName", uniqueName)
        try {
            var files = component.get("v.uploadedDocs");
            console.log(files);
            var fileUploadWrapper = component.get("v.fileListOfEmiratesId");

            console.log(fileUploadWrapper);
            var contentWrapperArr = [];

            if (files && files.length > 0 && fileUploadWrapper.length < 1) {
                for (var i = 0; i < files[0].length; i++) {
                    var file = files[0][i];

                    if (file.size <= 1000000) {
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;
                        reader.onloadend = function (e) {
                            var base64 = reader.result.split(',')[1]
                            fileUploadWrapper.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64

                            });
                            contentWrapperArr.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64
                            });
                            console.log(fileUploadWrapper);
                            component.set("v.fileListOfEmiratesId", fileUploadWrapper)

                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "File uploaded successfully.",
                                "type": "success"
                            });
                            toastEvent.fire();
                        }
                        function handleEvent(event) {
                            if (contentWrapperArr.length == i) {

                                component.set("v.fileListOfEmiratesId", fileUploadWrapper)

                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please upload file less than 1 MB.",
                            "mode": "sticky"
                        });
                        toastEvent.fire();
                    }
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You cannot upload more than one file.",
                    "mode": "sticky"
                });
                toastEvent.fire();
            }

        } catch (e) {
            console.log(e.message);
        }
    },
    filesUploadeMedicalReports: function (component, event, helper) {
        var uniqueName = event.getSource().get("v.name")
        component.set("v.selectedFileName", uniqueName)

        try {
            var files = component.get("v.uploadedDocs");
            console.log(files);
            var fileUploadWrapper = component.get("v.fileListOfMedical");

            console.log(fileUploadWrapper);
            var contentWrapperArr = [];

            if (files && files.length > 0 && fileUploadWrapper.length < 1) {
                for (var i = 0; i < files[0].length; i++) {
                    var file = files[0][i];

                    if (file.size <= 1000000) {
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;
                        reader.onloadend = function (e) {
                            var base64 = reader.result.split(',')[1]
                            fileUploadWrapper.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64

                            });
                            contentWrapperArr.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64
                            });
                            console.log(fileUploadWrapper);
                            component.set("v.fileListOfMedical", fileUploadWrapper)

                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "File uploaded successfully.",
                                "type": "success"
                            });
                            toastEvent.fire();
                        }
                        function handleEvent(event) {
                            if (contentWrapperArr.length == i) {

                                component.set("v.fileListOfMedical", fileUploadWrapper)

                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please upload file less than 1 MB.",
                            "mode": "sticky"
                        });
                        toastEvent.fire();
                    }
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You cannot upload more than one file.",
                    "mode": "sticky"
                });
                toastEvent.fire();
            }

        } catch (e) {
            console.log(e.message);
        }
    },
    filesUploadePassport: function (component, event, helper) {
        var uniqueName = event.getSource().get("v.name")
        component.set("v.selectedFileName", uniqueName)

        try {
            var files = component.get("v.uploadedDocs");
            console.log(files);
            var fileUploadWrapper = component.get("v.fileListPassport");

            console.log(fileUploadWrapper);
            var contentWrapperArr = [];

            if (files && files.length > 0 && fileUploadWrapper.length < 1) {
                for (var i = 0; i < files[0].length; i++) {
                    var file = files[0][i];

                    if (file.size <= 1000000) {
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;
                        reader.onloadend = function (e) {
                            var base64 = reader.result.split(',')[1]
                            fileUploadWrapper.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64

                            });
                            contentWrapperArr.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64
                            });
                            console.log(fileUploadWrapper);
                            component.set("v.fileListPassport", fileUploadWrapper)

                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "File uploaded successfully.",
                                "type": "success"
                            });
                            toastEvent.fire();
                        }
                        function handleEvent(event) {
                            if (contentWrapperArr.length == i) {

                                component.set("v.fileListPassport", fileUploadWrapper)

                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please upload file less than 1 MB.",
                            "mode": "sticky"
                        });
                        toastEvent.fire();
                    }
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You cannot upload more than one file.",
                    "mode": "sticky"
                });
                toastEvent.fire();
            }

        } catch (e) {
            console.log(e.message);
        }
    },
    fileUploadeAcadmics: function (component, event, helper) {
        var idname = event.getSource().get("v.name")

        try {
            var files = component.get("v.uploadedDocs");
            console.log(files);
            var fileUploadWrapper = component.get("v.fileListAcademic");

            console.log(fileUploadWrapper);
            var contentWrapperArr = [];

            if (files && files.length > 0 && fileUploadWrapper.length < 1) {
                for (var i = 0; i < files[0].length; i++) {
                    var file = files[0][i];

                    if (file.size <= 1000000) {
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;
                        reader.onloadend = function (e) {
                            var base64 = reader.result.split(',')[1]
                            fileUploadWrapper.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64

                            });
                            contentWrapperArr.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64
                            });
                            console.log(fileUploadWrapper);
                            component.set("v.fileListAcademic", fileUploadWrapper)

                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "File uploaded successfully.",
                                "type": "success"
                            });
                            toastEvent.fire();
                        }
                        function handleEvent(event) {
                            if (contentWrapperArr.length == i) {

                                component.set("v.fileListAcademic", fileUploadWrapper)

                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please upload file less than 1 MB.",
                            "mode": "sticky"
                        });
                        toastEvent.fire();
                    }
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You cannot upload more than one file.",
                    "mode": "sticky"
                });
                toastEvent.fire();
            }

        } catch (e) {
            console.log(e.message);
        }
    },
    filesUploadeAcquaintance: function (component, event, helper) {
        var idname = event.getSource().get("v.name")


        try {
            var files = component.get("v.uploadedDocs");
            console.log(files);
            var fileUploadWrapper = component.get("v.fileListAcquaintance");

            console.log(fileUploadWrapper);
            var contentWrapperArr = [];

            if (files && files.length > 0 && fileUploadWrapper.length < 2) {
                for (var i = 0; i < files[0].length; i++) {
                    var file = files[0][i];

                    if (file.size <= 1000000) {
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;
                        reader.onloadend = function (e) {
                            var base64 = reader.result.split(',')[1]
                            fileUploadWrapper.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64
                            });
                            contentWrapperArr.push({
                                'filename': file.name,
                                'filetype': file.type,
                                'base64': base64
                            });
                            console.log(fileUploadWrapper);
                            component.set("v.fileListAcquaintance", fileUploadWrapper);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "File uploaded successfully.",
                                "type": "success"
                            });
                            toastEvent.fire();
                        }
                        function handleEvent(event) {
                            if (contentWrapperArr.length == i) {

                                component.set("v.fileListAcquaintance", fileUploadWrapper);

                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please upload file less than 1 MB.",
                            "mode": "sticky"
                        });
                        toastEvent.fire();
                    }
                }
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You cannot upload more than one file.",
                    "mode": "sticky"
                });
                toastEvent.fire();
            }

        } catch (e) {
            console.log(e.message);
        }
    },

    removeRecord: function (component, event, helper) {

        var fileNameofDocument = component.get("v.selectedFileName");
        var index = event.currentTarget.dataset.record;
        var fileActivityList = component.get("v.fileActvityVsAwerness");
        fileActivityList.splice(index, 1);
        component.set("v.fileActvityVsAwerness", fileActivityList);

    },
    removeEIDFile: function (component, event, helper) {

        var index = event.currentTarget.dataset.record;
        var emiratesIdList = component.get("v.fileListOfEmiratesId");
        emiratesIdList.splice(index, 1);
        component.set("v.fileListOfEmiratesId", emiratesIdList);
    },
    removeMedicalReports: function (component, event, helper) {

        var index = event.currentTarget.dataset.record;
        var medicalList = component.get("v.fileListOfMedical");
        medicalList.splice(index, 1);
        component.set("v.fileListOfMedical", medicalList);
    },

    removePassportFile: function (component, event, helper) {

        var index = event.currentTarget.dataset.record;

        var passportList = component.get("v.fileListPassport");
        passportList.splice(index, 1);

        component.set("v.fileListPassport", passportList);
    },
    removeAcademic: function (component, event, helper) {

        var index = event.currentTarget.dataset.record;
        var academicList = component.get("v.fileListAcademic");
        academicList.splice(index, 1);
        component.set("v.fileListAcademic", academicList);

    },
    removeAcquaintance: function (component, event, helper) {

        var index = event.currentTarget.dataset.record;
        var acquaintanceList = component.get("v.fileListAcquaintance");
        acquaintanceList.splice(index, 1);
        component.set("v.fileListAcquaintance", acquaintanceList);
    }




})