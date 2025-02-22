({
    fetchCaseTypes : function(component){
        var utility = component.find("ETI_UtilityMethods");
        var backendMethod = "getCaseTypes";
        var params = {
            //"caseRecordType": component.get("v.caseRecordTypeName")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('response***'+JSON.stringify(response));
                var storeResponse = response;
                component.set("v.listControllingValues", storeResponse);
                component.set('v.loaded',true);
            }),
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast(component.get('v.Error'), $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )
    },
    saveCase: function(component){
        component.set("v.disableSave",true); 
        console.log('caseRecord>>  ', JSON.stringify(component.get("v.caseRecord")));
        var utility = component.find("ETI_UtilityMethods");
        var backendMethod = "saveCase";
        component.set("v.caseRecord.ETI_Customer_Vehicle__c", component.get("v.selectedVehId"));
        component.set("v.caseRecord.Origin", 'CRM Portal');
        var params = {
            "caseRecord": component.get("v.caseRecord")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                component.set("v.isfeebackModal",false);
                var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": component.get("v.Success"),
                        "type":"success",
                        "message": component.get("v.Case_Created_Message")
                    });
                    resultsToast.fire();
            }),
            $A.getCallback(function(error) {
                component.set("v.disableSave",false); 
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast(component.get('v.Error'), $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )
    },
     getUserVehicleDetails : function(component, event, helper) {
        console.log('recordId>> '+component.get('v.recordId'));
        var recordId = component.get('v.recordId');
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getUserVehicles");
        action.setParams({
            "userId": userId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var res  =response.getReturnValue();  
            if(recordId!=null && recordId!=undefined){
                for(var i = 0; i < res.length; i++){
                    if(res[i].Id==recordId){
                		component.set("v.VehicleList", res[i]);
                        component.set("v.selectedVehId", res[i].Id);
                        break;
                    }
                }
            }else
            	component.set("v.VehicleList", res);
            console.log('veh res***'+JSON.stringify(component.get('v.VehicleList')));
        });
        $A.enqueueAction(action);
    },
})