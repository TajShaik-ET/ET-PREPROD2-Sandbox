({
    doInit : function(component, event, helper,status) {
        var action = component.get('c.getCaseData');
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state           
            if (state == 'SUCCESS') {
                var response=a.getReturnValue();
                console.log(JSON.stringify(response)+'response');
                if(response!=undefined && response!=null && response!=''){
                     component.set('v.listofRecord', response);
                    component.set('v.recentApprover', response.Sub_Status__c);
                    component.set('v.currentApprover', response.Status_Category__c); 
                    component.set('v.currentrecType', response.RecordType.DeveloperName); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateCaseStatus : function(component, event, helper) {
        component.set("v.isDisabled", true); 
        var recordId = component.get("v.recordId");
        component.set("v.caseIds", recordId);
        var action = component.get('c.updateMOECaseStatus');
        action.setParams({
            "caseIds":component.get("v.caseIds"),
            "status":"Approve",
            "ccmRemarks":component.get("v.ccmRemarks"),
            "Solution":component.get("v.Solution"),
            "Comments":component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state            
            if (state == 'SUCCESS') {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case record is updated successfully!",
                    "type": "success",
                }).fire();
                var workspaceAPI = component.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    var focusedTabId = response.tabId;
                    workspaceAPI.closeTab({
                        tabId: focusedTabId,
                        includeAllSubtabs: false
                    });
                })
                .catch(function(error) {
                    console.log(error);
                });
            }
        });
        $A.enqueueAction(action);    	
    },
    
   validateProfile: function(component, event, helper) {
        debugger;
        var action = component.get("c.getuserDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var userProfile = response.getReturnValue();
                console.error('Error retrieving user profile: ' + userProfile);
                // Check if the user's profile matches the required profile
                if (userProfile.Profile.Name === 'ET - School Transportation Manager') { // Replace 'Your_Profile_Name' with the actual profile name
                    // Profile validation passed
                  // alert(' User Profile '+userProfile.Profile.Name);
                    
                     component.set('v.userProfile',userProfile.Profile.Name); 
                    // Proceed with your logic
                } else {
                    // Profile validation failed
                   alert('User does not belong to the required profile.');
                    // Display an error message or take appropriate action
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    // Handle the error
                    console.error('Error retrieving user profile: ' + errors[0].message);
                    // Display an error message or take appropriate action
                }
            } else {
                console.error('Unexpected state: ' + state);
                // Display an error message or take appropriate action
            }
        });
        $A.enqueueAction(action);
    },
     validateRecords : function(component, event, helper) {
        debugger;
        let records = component.get("v.listofRecord");
        if (!records || records.length === 0) {
            console.error('Error: No records found.');
            this.showToast("Error", "No records found", "error");
            return false; // Return false indicating validation failure
        }
        // Iterate through each record and validate
        for (let i = 0; i < records.length; i++) {
            let record = records[i];
            // Perform your validation checks here
            // For example, check if any required field is null
            switch (record.RecordType.DeveloperName){
                case 'Growth_Request':                    
                  /*  if (record.Type_OF_Fleet__c === 'No') {
                        // Skip validation for this record
                        continue;
                    }
                    */
                if (!record.Bus_Internal_Number__c || !record.Service_Start_Date__c) {
                    let errorMessage = "Please add the following required fields: ";
                    if (!record.Bus_Internal_Number__c) {
                        errorMessage += "Bus Internal Number, ";
                    }
                    if (!record.Service_Start_Date__c) {
                        errorMessage += "Service Start Date, ";
                    }
                    errorMessage = errorMessage.slice(0, -2); // Remove trailing comma and space
                    helper.showToast("Error", "Required Fields", errorMessage, "error");
                    return false; // Return false indicating validation failure
                    console.log(record);
                }
                    break;
                case 'Handicap_Services_Transport_or_Nanny_Request':
                    if (!record.Bus_Internal_Number__c ||!record.Vehicle_Type__c ) {
                    let errorMessage = "Please add the following required fields: ";
                        if (!record.Bus_Internal_Number__c) {
                            errorMessage += "Bus Internal Number, ";
                        }
                        if (!record.Vehicle_Type__c) {
                            errorMessage += "vehicle type";
                        }
              
                    errorMessage = errorMessage.slice(0, -2); // Remove trailing comma and space
                    helper.showToast("Error", "Required Fields", errorMessage, "error");
                    return false; // Return false indicating validation failure
                }
                 break;
                case 'Requests_for_trips_activities_events':
                   if (!record.Bus_Type__c) {
                    let errorMessage = "Please add the following required fields: ";
                    if (!record.Bus_Type__c) {
                        errorMessage += "Bus Type Required , ";
                    }
                
                    errorMessage = errorMessage.slice(0, -2); // Remove trailing comma and space
                    helper.showToast("Error", "Required Fields", errorMessage, "error");
                    return false; // Return false indicating validation failure
                }
                    
                    break;
                    /*
                case 'Request_for_the_Companian_Handicap_Transportation':
                    if (!record.Bus_Internal_Number__c || !record.Type_Of_Bus__c || !record.No_of_Vehicle__c || !record.Service_Start_Date__c) {
                    let errorMessage = "Please add the following required fields: ";
                    if (!record.Bus_Internal_Number__c) {
                        errorMessage += "Bus Internal Number, ";
                    }
                    if (!record.Type_Of_Bus__c) {
                        errorMessage += "Type of Bus, ";
                    }
                    if (!record.No_of_Vehicle__c) {
                        errorMessage += "Number of Vehicles, ";
                    }
                    if (!record.Service_Start_Date__c) {
                        errorMessage += "Service Start Date, ";
                    }
                    errorMessage = errorMessage.slice(0, -2); // Remove trailing comma and space
                    helper.showToast("Error", "Required Fields", errorMessage, "error");
                    return false; // Return false indicating validation failure
                }
                 
                    break;
                    */
                default:
                    return true;  // Return false indicating validation failure
            }
        }
        return true; // Return true indicating validation success
        
    },
    
       showToast: function(title, fieldLabel, errorMessage, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": fieldLabel + ': ' + errorMessage,
            "type": type
        });
        toastEvent.fire();
    },
})