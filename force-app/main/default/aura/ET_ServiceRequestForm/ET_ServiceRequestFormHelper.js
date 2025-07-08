({
    getSObjectName: function(component,RecordId,helper){
        var action = component.get("c.getSObjectNameFromRecordId");
        action.setParams({"RecordId": String(RecordId)});
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(response){
            console.log('getSObjectName: ',response.getState());
            if(response.getState() == 'SUCCESS'){
                component.set('v.loaded', !component.get('v.loaded'));
                var result = response.getReturnValue();
                console.log('result in doinit of wrapper : ' + JSON.stringify(result));
                if(result != null){
                    
                    if(result == 'Opportunity'){
                        component.set("v.opportunityRecordId",RecordId);
                    }else if(result == 'ET_Pricing_Service_Request__c'){
                        component.set("v.serviceRequestRecordId",RecordId);
                        helper.getServiceReqRelatedInfoHelper(component,RecordId,helper);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getServiceReqRelatedInfoHelper: function (component, RecordId, helper) {
        var action = component.get("c.getServiceRelatedInfo");
        action.setParams({ "serviceRequestId": RecordId });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                component.set('v.loaded', !component.get('v.loaded'));
                var result = response.getReturnValue();
                console.log('service Request related info in main Form : ' + JSON.stringify(result));
                if (result != null) {
                    component.set("v.quoteId", result.quoteId);
                    component.set("v.totalProjectQuoteId", result.totalProjectQuoteId);
                    component.set("v.opportunityStatus", result.opportunityStatus);
                    component.set("v.opportunityRecordId", result.quoteDetail.opportunityId);
                    component.set("v.quotationStatus", result.quotationStatus);
                    component.set("v.changesAllowedInQuotation", result.changesAllowedInQuotation); 
                    component.set("v.quoteDetail", result.quoteDetail); 
                    console.log('quoteDetail: '+JSON.stringify(component.get("v.quoteDetail")));
                    component.set("v.validateNotificationSent", result.quoteDetail.Validate_Quotation_Notification_Sent__c); 
                    console.log('opportunityStatus = ' + result.opportunityStatus);
                    const tlSalesTeamProfiles = $A.get("$Label.c.TL_SalesTeam_Profiles");
                    const profileSalesTL = tlSalesTeamProfiles.split(';');
                    console.log('profileSalesTL = ' + profileSalesTL.includes(result.quoteDetail.CreatedBy.Profile.Name));
                    if(result.quoteDetail.Quote_Total_Investment__c >= 500000 || (profileSalesTL.includes(result.quoteDetail.CreatedBy.Profile.Name) && result.isInitiatedUser != true)){
                        component.set("v.hideDeleteQuote", true);
                    }else{
                        component.set("v.hideDeleteQuote", false);
                    }
                    if((profileSalesTL.includes(result.quoteDetail.CreatedBy.Profile.Name) && result.isInitiatedUser != true)){
                        component.set("v.hideOpenQuote", true);
                    }else{
                        component.set("v.hideOpenQuote", false);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    profilePermissions: function (component, event, helper) {
        var action = component.get("c.getProfileInfo");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getUserPermissions = ' + JSON.stringify(response.getReturnValue()));
                var resObj = response.getReturnValue();
                console.log('profile name__q' + resObj.Name);
                if (resObj.Name == 'System Administrator') {
                    component.set("v.isSysAdmin", true);
                    console.log('profile name__q' + resObj.Name);
                }
                const tlSalesTeamProfiles = $A.get("$Label.c.TL_SalesTeam_Profiles");
                const profileSalesTL = tlSalesTeamProfiles.split(';');
                console.log('profileSalesTL:');
                console.table(profileSalesTL);
                component.set("v.isSalesUser", profileSalesTL.includes(resObj.Name));
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message + "Method :" + 'UserPermissions');
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type": "Error",
                            "title": "Error",
                            "message": "Internal Server Error. Please Contact System Admin.",
                            "mode": "sticky"
                        });
                        toastReference.fire();
                        // alert('Internal Server Error. Please Contact System Admin.');
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getVehicleDetails: function (component, RecordId, helper) {
        var action = component.get("c.getVehicleRequests");
        action.setParams({ serviceRequestId: RecordId });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var vehicles = response.getReturnValue();
                console.log('vehicles: ' + JSON.stringify(vehicles));
                var isFuel = false;
                for (var idx = 0; idx < vehicles.length; idx++) {
                    if (vehicles[idx].ET_Vehicle_Fuel__c == 'Yes') {
                        isFuel = true;
                        break;
                    }
                }
                var isSubstitutional = false;
                for (var idx = 0; idx < vehicles.length; idx++) {
                    if (vehicles[idx].ET_Vehicle_Source__c == 'Substitutional') {
                        isSubstitutional = true;
                        break;
                    }
                }
                var isUsed = false;
                for (var idx = 0; idx < vehicles.length; idx++) {
                    if (vehicles[idx].ET_Vehicle_Condition__c == 'Used') {
                        isUsed = true;
                        break;
                    }
                }
                var isServiceType = false;
                for (var idx = 0; idx < vehicles.length; idx++) {
                    if (vehicles[idx].ET_Service_Type__c != 'General Rent') {
                        isServiceType = true;
                        break;
                    }
                }
                console.log('isFuel: ' + isFuel + ' isSubstitutional: ' + isSubstitutional + ' isUsed: ' + isUsed + ' isServiceType: ' + isServiceType);
                if (isFuel || isSubstitutional || isUsed || isServiceType) {
                    component.set("v.skipSalesUser", true);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
 
    //Taj
    sendEmailNotification: function (component, event, helper, notificationType) {
        console.log('notificationType',notificationType);
        var action = component.get("c.sendMailNotification");
        action.setParams({ type: notificationType, quoteId: component.get("v.quoteId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var mailSent = response.getReturnValue();
                console.log('mailSent', mailSent);
                if (mailSent == true)
                    this.showToastHelper(component, event, helper, 'Success', 'success', 'Email Notification sent to Pricing Team', 'dismissible');
                if (mailSent == false)
                    this.showToastHelper(component, event, helper, 'Error', 'error', 'failed to send Email Notification to Pricing Team', 'dismissible');
                $A.get("e.force:refreshView").fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    //Taj
    showToastHelper : function (component, event, helper, title, message, type, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title, //Info //Success //Error //Warning
            message: message,
            duration:'5000',
            type: type, //info //success //error //warning
            mode: mode //dismissible //pester //sticky
        });
        toastEvent.fire();
    },
})