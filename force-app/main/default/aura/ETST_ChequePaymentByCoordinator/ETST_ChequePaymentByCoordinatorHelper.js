({
    doInit : function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");            
        var backendMethod = "getServiceDetails";
        var params = {
            "recordId" : component.get("v.recordId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response***'+JSON.stringify(response.service));
                component.set('v.serviceRequest',response.service);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    createPaymentRecord : function(component, event, helper) {
        component.set('v.loaded', false);;
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "createPayment";
        var params = {
            "newPayment" : component.get("v.paymentRecord"),
            "serviceRequest" : component.get("v.serviceRequest"),
            "mode" : 'Cheque'
            
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {                
                utility.showToast("School Transport", 'Cheque Payment is completed successfully', "success", "dismissible");                
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire(); 
            }),            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
                component.set('v.loaded', true);
                $A.util.removeClass(component.find("previousDiv"), "slds-hide");
                //$A.util.removeClass(component.find("newStudentButton"), "slds-hide");                
            })
        )	
    },
})