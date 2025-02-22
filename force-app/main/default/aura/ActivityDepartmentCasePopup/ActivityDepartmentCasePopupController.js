({
    toggle: function (component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var lang = url.searchParams.get("lang");
        component.set('v.loadEdirForm',true);   
        var recordname = component.find("mySelect").get("v.value");
        //console.log('recordname----->'+recordname);
        if (recordname === component.get('v.clNone')){
            helper.resetFlags(component, event, helper);
            component.find('OppMessage').setError(''); 
        }else if (recordname === component.get('v.clGlobalEventRequest')) {
            component.find('OppMessage').setError('');
            helper.resetFlags(component, event, helper);            
            component.set("v.GlobalEventRequest", true);
            component.set("v.RecordTypeId",$A.get("$Label.c.GlobalEventRecordId"));
        }
        
    },
    doInit : function(component, event, helper){
        helper.addAccountRecord(component, 1);
        helper.addRowHelper(component, 1);
        var test = component.get('v.userParentProfileWrap');
        // console.log('test log '+JSON.stringify(test));
        helper.setCommunityLanguage(component, event, helper);
        if (navigator.geolocation) {
            // console.log("able to retrieve your location");
            navigator.geolocation.getCurrentPosition(function(position) {
                var latit = position.coords.latitude;
                var longit = position.coords.longitude;
                component.set('v.lat',latit);
                component.set('v.lon',longit);
                component.set('v.vfUrl','/Business/apex/ETST_GoogleMapFinder?lat='+latit+'&long='+longit);
                //console.log('vfUrl'+component.get('v.vfUrl'));
            });
        }else{
            console.log("Unable to retrieve your location");
        }     
        
        var urlString=window.location.href;
        var vfOrigin = urlString.substring(0, urlString.indexOf("/Business/s"));
        window.addEventListener("message", $A.getCallback(function(event) {
            if (event.origin !== vfOrigin) {
                return;
            }
            console.log(event);
            var message = event.data;
            // console.log('message-->'+message);
            var res = message.split("~");
            if(res.length > 0){ 
                component.set('v.lat',res[0]);
                component.set('v.lon',res[1]);
            }
        }), false);
        helper.doInit(component, event, helper);
        // $A.util.addClass(component.find("spinner"), "slds-hide"); 
    },
    handleOnError : function(component, event, helper) {
        console.log("inside error");
        console.log(JSON.stringify(event));
    },
    handleOnErrorCase : function(component, event, helper) {
        console.log("inside error");
        console.log(JSON.stringify(event));
    },
    handleOnSuccess : function(component, event, helper) { 
        var params = event.getParams(); //get event params
        var recordId = params.response.id; //get record id
        console.log('Record Id - ' + recordId); 
        
    },
    closeModel: function (component, event, helper) {
        component.set('v.newCase',false);
        actionEvt.setParams({
            "actionname": 'refresh' 
        });
        
    },
    refresh: function(component, event, helper) {
        helper.doInit(component, event, helper);
    },
    openMapController : function(component, event, helper) {   
        component.set('v.currentLocIndex',event.currentTarget.dataset.index);
        component.set('v.currentDestClick',event.currentTarget.dataset.filename);
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
    getLocationDetails: function(component, event, helper){
        component.set('v.openMap',false);
        var lat=component.get('v.lat');
        var long=component.get('v.lon');
        if(lat!=null && lat!='' && lat!=undefined){
            helper.getLocationDetails(component, event, helper,lat,long);
        }
        component.set("v.searchText", '');
    },
    addRow : function(component, event, helper) {
        var dynamicRowsList = component.get("v.dynamicRowsList");
        // Create a new row object and set the School Name for the new row
        var newRow = {
            'schid': '',
            'schcode': '',
            'rowNumber': dynamicRowsList.length + 1
            
        };
        dynamicRowsList.push(newRow);
        component.set("v.dynamicRowsList", dynamicRowsList);
        /*        var loopVar = 1;
        if(event.getSource().get('v.name') === 'multipleRows' && !$A.util.isEmpty('v.numberOfRows') ) {
            loopVar = component.get('v.numberOfRows'); 
            
        }
     
        helper.addRowHelper(component, loopVar);*/
        
    },
    deleteRow : function(component, event, helper) {
        var dynamicRowsList = component.get("v.dynamicRowsList");
        var index = dynamicRowsList.findIndex(x => x.rowNumber === event.getSource().get('v.name'))
        if(index != -1)
            dynamicRowsList.splice(index, 1);
        component.set("v.dynamicRowsList", dynamicRowsList);
    },
    save : function(component, event, helper){
        component.set('v.showSpinner',true);
        event.preventDefault();
        var typeofcase = component.get("v.typeOfCase");
        
        console.log(typeofcase);
        var eventFields = event.getParam("fields");
        var recordname = component.find("mySelect").get("v.value");
        var showValidationError = false;
        var validationFailReason = '';
        var result = new Date();
        var emergencyDate = new Date();
        emergencyDate.setDate(emergencyDate.getDate());
        result.setDate(result.getDate() + 3);
        var today = $A.localizationService.formatDate(result, "YYYY-MM-DD");
        var emergencytoday = $A.localizationService.formatDate(emergencyDate, "YYYY-MM-DD");
        var fields = component.find("assResId"); 
        debugger;
        if ($A.util.isEmpty(typeofcase)) {
            showValidationError = true;
            validationFailReason = 'Type of Case is mandatory. Please select a value.';
        } else {
            
            fields.forEach(function (field) {
                if (field.get("v.fieldName") === 'Trip_Date__c') {
                    if (typeofcase === 'Urgent' || typeofcase === 'عاجل') {
                        if ($A.util.isEmpty(field.get("v.value"))) {
                            showValidationError = true;
                            validationFailReason = 'Please enter the date of the trip';
                            
                        } else if (field.get("v.value") === emergencytoday) {
                            showValidationError = true;
                            helper.showToast(component, event, helper, 'Error!', 'error', 'sticky', '5000', 'Please select greater than today');
                        }
                    } else if (typeofcase === 'Normal') {
                        if ($A.util.isEmpty(field.get("v.value"))) {
                            showValidationError = true;
                            validationFailReason = 'Please select a date greater than Today';
                            
                        } else if (field.get("v.value") < today) {
                            showValidationError = true;
                            helper.showToast(component, event, helper, 'Error!', 'error', 'sticky', '5000', 'Please select a date greater than +3 Today');
                        }
                    }
                }
                else if (field.get("v.fieldName") === 'Count_Of_Students__c') {
                    if ($A.util.isEmpty(field.get("v.value"))) {
                        showValidationError = true;
                        validationFailReason = 'Please fill  details in the field Count Of Student.';
                        
                    }
                }
                    else if (field.get("v.fieldName") === 'Cycle__c') {
                        if ($A.util.isEmpty(field.get("v.value"))) {
                            showValidationError = true;
                            validationFailReason = 'Please fill details in the Cycle field.';
                            
                        }
                    }
                        else if (field.get("v.fieldName") === 'Supervisors_Count_From_School__c') {
                            if ($A.util.isEmpty(field.get("v.value"))) {
                                showValidationError = true;
                                validationFailReason = 'Please fill details in the field Supervisors Count From School .';
                                
                            }
                        }
                            else if (field.get("v.fieldName") === 'Trip_Coordinator_Name__c') {
                                if ($A.util.isEmpty(field.get("v.value"))) {
                                    showValidationError = true;
                                    validationFailReason = 'Please fill  details in the field Trip Coordinator Name.';
                                    
                                }
                            }
                                else if (field.get("v.fieldName") === 'Coordinator_Phone__c') {
                                    if ($A.util.isEmpty(field.get("v.value"))) {
                                        showValidationError = true;
                                        validationFailReason = 'Please fill  details in the field Coordinator Phone ';
                                        
                                    }
                                }
                                    else if (field.get("v.fieldName") === 'Arrival_Time_To_Activity__c') {
                                        if ($A.util.isEmpty(field.get("v.value"))) {
                                            showValidationError = true;
                                            validationFailReason = 'Please fill  details in the field Arrival Time To Activity  ';
                                            
                                        }
                                    }
                                        else if (field.get("v.fieldName") === 'Trip_Time_From__c') {
                                            if ($A.util.isEmpty(field.get("v.value"))) {
                                                showValidationError = true;
                                                validationFailReason = 'Please fill details in the field Trip Time From  ';
                                                
                                            }
                                        }
                                            else if (field.get("v.fieldName") === 'Trip_Time_To__c') {
                                                if ($A.util.isEmpty(field.get("v.value"))) {
                                                    showValidationError = true;
                                                    validationFailReason = 'Please fill details in the field Trip Time To';
                                                    
                                                }
                                            }
                                                else if (field.get("v.fieldName") === 'School_Names__c') {
                                                    if ($A.util.isEmpty(field.get("v.value"))) {
                                                        showValidationError = true;
                                                        validationFailReason = 'Please fill  details in the field School Name ';
                                                        
                                                    }
                                                }
                
            });
            
        }
        if (showValidationError) {
            component.find('OppMessage').setError(validationFailReason, false);
            component.set('v.showSpinner',false);
        } else {
            let caseForm = component.find('caseForm').submit();
            
        }
    },
    //This controllers Not used  
    
    getschooldet: function(component, event, helper) {
        //console.log('school'+component.get('v.schid'));
        var action = component.get('c.getschoolDetails');
        var schoolid=component.get('v.schid').toString();
        action.setParams({
            schoolid: schoolid
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultVale= result;                
                for(var i in resultVale){ 
                    //console.log('value'+resultVale[i].AccountNumber); 
                    component.set('v.schcode',resultVale[i].AccountNumber);
                }
                
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
    // When a keyword is entered in search box
    searchRecords : function( component, event, helper ) {
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
            helper.searchRecordsHelper( component, event, helper, '' );
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    // When an item is selected
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }
            var recId = (event.currentTarget.id);
            var recordIdString = recId.toString();
            var action = component.get('c.getschoolDetails');
            action.setParams({
                schoolid: recordIdString
            });
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                var state = response.getState();
                //console.log(state);
                if (state === "SUCCESS") {  
                    var resultVale= result;                
                    for(var i in resultVale){ 
                        
                        // console.log('value'+resultVale[i].AccountNumber); 
                        component.set('v.schcode',resultVale[i].AccountNumber);
                    }
                    
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
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    showRecords : function( component, event, helper ) {
        if(!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    // To remove the selected item.
    removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },
    
    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    addRowArabic: function(component, event, helper) {
        helper.addAccountRecord(component, event);
    }, 
    removeRow: function(component, event, helper) {
        var listRemoveRow = component.get("v.requestLineList");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        listRemoveRow.splice(index, 1);
        component.set("v.requestLineList", listRemoveRow);
    },
    handleSchoolChange: function(cmp, event, helper){
        var selectedRecordData = event.getParam("message");
        var index = event.getParam("index");
        console.log(JSON.stringify(selectedRecordData));
        var schoolId=selectedRecordData.Id;
        var schoolCode =selectedRecordData.AccountNumber;
        var caseSchoolList = cmp.get("v.requestLineList");
        caseSchoolList[index].School_Names__c =schoolId;
    },
    /*
    saveArabic: function(component, event, helper) {
        component.set('v.showSpinner',true);
    
        if (helper.tripDateAndTime(component, event)) {
            if (helper.validateAccountList(component, event)) {
                let caseForm = component.find('caseForm').submit();
            }
            
            //helper.saveAccountList(component, event,helper,caseId);
        }
        
       
    },
    */
    saveArabic: function(component, event, helper) {
        component.set('v.showSpinner', true);
        if (helper.checkBeforeInsertGlobalReq(component, event)) {
           // alert('Validation Pass 1');
            let caseForm = component.find('caseForm').submit();
            // If you need to perform additional actions after submission, you can do so here.
        }
        
        // Note: If the conditions are not met, the form won't be submitted.
        
        
    },
    caseHandleOnSuccessAR : function(component, event, helper) {
        debugger;
        let param = event.getParams();
        let caseId = param.response.id;
        component.set("v.CaseId",caseId);
        if (helper.validateAccountList(component, event)) {
            helper.saveAccountList(component, event,helper,caseId);
        }
        
    },
    caseHandleOnSuccess : function(component, event, helper) {
        try{
            let param = event.getParams();
            let caseId = param.response.id;
            component.set("v.CaseId",caseId);
            let forms  = component.find('caseFormMOE'); 
            let formCount =  component.get("v.dynamicRowsList").length;
            if(formCount === 1){
                forms.submit();           
                component.set('v.newCase',false);		
                //$A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is created succesfully!",
                    "type": "success",
                }).fire();            
                
                actionEvt.setParams({
                    "actionname": 'refresh'
                });
                
                actionEvt.fire();
            }else{
                forms.forEach( form =>{        
                    form.submit();
                    component.set('v.newCase',false);
                    $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case is created succesfully!",
                    "type": "success",
                }).fire();
                
                $A.get("e.force:closeQuickAction").fire();   
                
            }); 
        }
    }catch(e){
    
}
 },
 
 
 })