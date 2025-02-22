({
    
    executeServerCall : function(component, event, helper) {
       
        return new Promise(function(resolve, reject) {
            
            console.log("backendMethod > "+event.getParam('arguments'));
            var methodArguments = event.getParam('arguments');
            var backendMethod = methodArguments.backendMethod;
            var params = methodArguments.params;
            
            console.log("backendMethod > ", backendMethod);
            console.log("params > ", params);
            
            var action = component.get("c." + backendMethod);
            action.setParams(params);
            action.setCallback(this, function(response) {
                
                // callback status identification
                var state = response.getState();
                console.log("state > ", state);
                var val = response.getReturnValue();
                if (state === "SUCCESS") {
                    console.log('successful > ', val);
                    resolve(val);
                    
                } else if (state === "ERROR") {
                    
                    var errors = response.getError();
                    if (errors[0] && errors[0].message) {
                        
                        // This is an error from the AuraHandledException
                        console.log('reject > ', errors[0].message);
                        reject(errors[0].message);
                        
                    } else {
                        
                        console.log('Unknown');
                        reject(Error("Unknown error"));
                        
                    }
                    
                }
                
            });
            $A.enqueueAction(action);
        });
        
    },
    
    showToast : function (component, event, helper) {
        
        var methodArguments = event.getParam('arguments');
        var message = methodArguments.message;
        var type = methodArguments.type;
        var mode = methodArguments.mode;
        var title = methodArguments.title;
        
        console.log("message > ", message);
        console.log("type > ", type);
        console.log("mode > ", mode);
        console.log("title > ", title);
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: mode,
            message: message,
            type: type,
            title: title
        });
        toastEvent.fire();
        
    },
    
    convertToUserFriendlyErrMsg : function (component, event, helper) {
        
        var methodArguments = event.getParam('arguments');
        var err = methodArguments.rawErrorMessage;
        
        console.log("rawErrorMessage > ", err);
        
        var errorToShow;
        if (err.includes("FIELD_INTEGRITY_EXCEPTION")) {
            if (err.includes("invalid date")) {
                errorToShow = "Error: Invalid date. Please check the date you've entered.";
            } else {
                errorToShow = err;
            }
        } else if (err.includes("INVALID_EMAIL_ADDRESS")) {
            errorToShow = 'Error: Invalid email address format.';
        }  else if (err.includes("duplicate value found: ETST_Emirates_Id__c")) {
            errorToShow = 'Error: Emirates Id already exists!'; 
        } else if (err.includes("REQUIRED_FIELD_MISSING")) {
            errorToShow = 'Error: A required field is missing. Please contact your administrator.';
        } else if (err.includes("FIELD_CUSTOM_VALIDATION_EXCEPTION")) {
            var marker = "FIELD_CUSTOM_VALIDATION_EXCEPTION,";
            errorToShow = "Error: "+err.substring(err.indexOf(marker)+marker.length, err.indexOf(": []"))+".";
        }else if (err.includes("ENTITY_IS_LOCKED")) {
            errorToShow = 'You cannot cancel the service now. Please wait for the coordiator response!'; 
        }else if (err.includes("duplicate value found: ETDM_Hospital_Email_Id__c")) {
            errorToShow = 'Error: Email Id already exists!'; 
        } 
        else { 
            errorToShow = err;
        }
        return errorToShow;
        
    },
    
    getWarningMessage : function (component, event, helper) {
        
        var methodArguments = event.getParam('arguments');
        var method = methodArguments.method;
        var args = methodArguments.arguments;
        
        console.log("method > ", method);
        console.log("arguments > ", args);
        
        var returnValue;
        switch (method) {
            case "xxx":
                returnValue = "xxx";
                break;                                                                                
            default:
                returnValue = "UNEXPECTED INPUT: Please contact your administrator";
        }
        
        return returnValue;
        
    }
})