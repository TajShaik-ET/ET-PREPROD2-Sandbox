({
    doInit: function(component, event, helper) {
       // Prepare a new record from template
        component.find("CaseRecordCreator").getNewRecord(
            "Case", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newCase");
                var error = component.get("v.newCaseError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.apiName);
            })
        );
    },
    handleSaveCase: function(component, event, helper) {
        
        var allValid =CaseField.reduce(function (validSoFar, CaseField) {
            CaseField.showHelpMessageIfInvalid();
            return validSoFar && !CaseField.get('v.validity').valueMissing;
        }, true);
        if (allValid)  {
            console.log('enterd');
            component.set("v.simpleNewCase.AccountId", component.get("v.recordId"));

            component.set("v.simpleNewCase.Origin", 'Web');
            component.set("v.simpleNewCase.Status", 'New');
             component.find("CaseRecordCreator").saveRecord(function(saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    component.set("v.isfeebackModal",false);
                    // record is saved successfully
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "message": "The record was saved."
                    });
                    resultsToast.fire();
                    
                } else if (saveResult.state === "INCOMPLETE") {
                    // handle the incomplete state
                    console.log("User is offline, device doesn't support drafts.");
                } else if (saveResult.state === "ERROR") {
                    // handle the error state
                    console.log('Problem saving Case, error: ' + JSON.stringify(saveResult.error));
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                }
            });
        }else{
            console.log('enterd else');
            
        }
    }
    
    
})