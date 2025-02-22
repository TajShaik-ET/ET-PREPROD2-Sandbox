({
    doInit : function(component, event, helper) {
        
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getStudentDetails";
        //console.log('id--'+component.get("v.recordId"));
        var params = {
            "activeFlag" : 'Inactive'
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                //console.log('response.studentList-->'+JSON.stringify(response.studentList));
                component.set('v.transportTypes',response.transportTypes);
                component.set('v.serviceTypes',response.serviceTypes);
                component.set('v.studentList',response.studentList); 
                var corousalSize=component.get('v.corousalSize'); 
                component.set('v.studentCourosalList',response.studentList.slice(0,corousalSize)); 
                component.set('v.noofStudents',response.studentList.length);
                
                //component.set('v.serviceList',response.serviceList);
                component.set('v.cancellationReasons',response.cancellationReasons);   
               // component.set('v.schoolAreas',response.schoolAreas);
                /*for (var i = 0; i < response.studentList.length; i++) {
                    var row = response.studentList[i];
                    if (row.ETST_Transport_Request__c) row.trId = row.ETST_Transport_Request__r.Id;
                }
                component.set('v.studentList',response.studentList);               
            */
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    }
})