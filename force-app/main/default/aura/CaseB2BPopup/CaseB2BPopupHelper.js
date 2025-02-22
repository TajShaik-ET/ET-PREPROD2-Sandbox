({
    submitCase: function(component, event, helper) {
        debugger;
        var showValidationError = false;
        // Add your validation logic here
        var selectedValue = component.get('v.selectedRecord.value');
        if (!showValidationError) {
            var action = component.get('c.getUserDetails');
            var eventFields = event.getParam('fields');
            eventFields["Status"] = 'In Progress'; //Add Description field Value
            eventFields["Origin"] = 'CRM Portal';
           // eventFields["School_Name_Acc__c"]=selectedValue;
            //var recName=eventFields["ETST_Complaint_Type__c"];
            // eventFields["Status_Category__c"] = 'Pending with Operation Manager';
            var type=component.get('v.complaintAgainstType');
            var userLoginInfo = component.get('v.userInfo');
            console.log('User INFO ',userLoginInfo);

            if(userLoginInfo.Profile.Name=='HSE Inspector'){
                eventFields["Status_Category__c"] = 'Pending with HSE Quality Coordinator';
            }
            else if(userLoginInfo.Profile.Name=='ESE Transportation Inspector'){
                eventFields["Status_Category__c"] = 'Pending with Operation Coordinator';
           }
            else{
                eventFields["Status_Category__c"] = 'Pending with Operation Coordinator';
            }
          
            
            if (type == 'Feedback And Appreciation') {
                recName = 'Feedback';
            }
            
            action.setParams({
                "recName": 'MOE Issue'
            });
            
            action.setCallback(this, function(response) {
                var result = response.getReturnValue();
                var state = response.getState();
                console.log(JSON.stringify(result));
                if (state === 'SUCCESS') {
                    eventFields['RecordTypeId'] = result.recId;
                    eventFields['AccountId'] = result.u.AccountID;
                    eventFields['ContactId'] = result.u.ContactId;
                    
                    console.log('School_Name_Acc__c set to: ' + eventFields['School_Name_Acc__c']);
                    component.find('caseForm').submit(eventFields);
                    
                    window.setTimeout(
                        $A.getCallback(function() {
                            component.set('v.Spinner', false);
                        }), 10000
                    );
                    
                } else if (state === 'ERROR') {
                    console.log(JSON.stringify(response.getError()));
                }
            });
            
            $A.enqueueAction(action);
        } else {
            // Handle validation error
            console.log('Validation error occurred.');
            component.set('v.Spinner', false);
        }
    },
    getLoggedInUserInfo: function(component, event, helper){
        console.log('getLoggedInUserInfo');
        var action = component.get('c.getLoggedInUserDetails');
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
            console.log(JSON.stringify(result));
            if (state === "SUCCESS") {
                component.set('v.userInfo',result);
                
            }else if(state === "ERROR"){
                //alert('inside error');
                console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
        console.log('getLoggedInUserInfo');
    },
    handlefileAttached: function(component, event, helper,casid) {
        try{
            var filesData = component.get('v.fileList'); 
            console.log(casid.toString());
            var action = component.get("c.attachFileToCase");
            if (filesData && filesData.length > 0) {
                action.setParams({
                    recordId: casid.toString(),
                    filesData: JSON.stringify(filesData)
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        console.log(state);
                        console.log("File attached to Case.");
                        //component.set('v.newCase',false);
                        $A.get("e.force:closeQuickAction").fire();
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
                    } else if(state === "ERROR"){
                        console.log(JSON.stringify(response.getError()));
                    }
                });
                $A.enqueueAction(action);
            }
        }catch (e){
            console.log(e.message);
            actionEvt.fire();
            $A.get('e.force:showToast').setParams({
                "title": "error",
                "message": "Error attaching file to Case!",
                "type": "success",
            }).fire();
            console.log("Error attaching file to Case: " + response.getError());
        }
    },
    searchRecordsHelper : function(component, event, helper, value) {
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        var searchString = component.get('v.searchString');
        var recordTypeName = component.get("v.recordTypeName");
        console.log('test'+recordTypeName);
        component.set('v.message', '');
        component.set('v.recordsList', []);
        // Calling Apex Method
        var action = component.get('c.fetchRecords');
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'searchString' : searchString,
            'value' : value,
            'recordTypeName':'ETSALES_B2B_Account'
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
    getParameterByName: function(component, event, param) {
        var queryString = window.location.search;
        console.log(queryString);
        var urlParams = new URLSearchParams(queryString);
        var paramValue = urlParams.get(param)
        return paramValue;
    },
    checkBeforeInsertValidation :function(component, event, param) {
        var descriptionData = component.get('v.description'); 
        
        if (!descriptionData || descriptionData=='undefined') {
            // Type of case is empty or only contains whitespace
            // Show toast message for validation error
            this.showErrorToast("Error/ خطأ", "A description is required to submit a request. / .الوصف مطلوب لتقديم الطلب", "error");
            component.set('v.Spinner',false);
            return false;
        }else{
            return true;
        }        
    },
    showErrorToast: function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
})