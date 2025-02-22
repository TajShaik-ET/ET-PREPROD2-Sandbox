({
    
    fetchCaseTypes : function(component){
        var meta = document.createElement("meta");
        meta.setAttribute("name", "viewport");
        meta.setAttribute("content", "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0");
        document.getElementsByTagName('head')[0].appendChild(meta);
        
        var studentRec = component.get('v.studentRecord');
        if(studentRec !=null && studentRec !='' && studentRec !='undefined'){
            component.set("v.caseRecord.ETST_Student__c",studentRec);
        }
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getCaseTypes";
        var params = {
            //"caseRecordType": component.get("v.caseRecordTypeName")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('response***'+JSON.stringify(response));
                var storeResponse = response;
                //storeResponse.unshift('--None--');
                component.set("v.listControllingValues", storeResponse.caseTypes);
                component.set("v.studentsList", storeResponse.students);
                component.set('v.loaded',true);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )
    },
    saveCase: function(component){
        var meta = document.createElement("meta");
        meta.setAttribute("name", "viewport");
        meta.setAttribute("content", "width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0");
        document.getElementsByTagName('head')[0].appendChild(meta); 
        
        component.set("v.caseRecord.Origin",'CRM Portal');
        component.set("v.disableSave",true); 
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "saveCase";
        var params = {
            "caseRecord": component.get("v.caseRecord")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                component.set("v.isfeebackModal",false);
                var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "type":"success",
                        "message": "The case is created successfully!"
                    });
                    resultsToast.fire();
            }),
            
            $A.getCallback(function(error) {
                component.set("v.disableSave",false); 
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )
    },
    
})