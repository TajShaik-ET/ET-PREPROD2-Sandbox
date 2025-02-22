({
    updateTransportRequestStatus : function(component, event, helper) {
        console.log('Updating the status...');
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "updateTransportRequestStatus";
        var params = {
            "serviceRecordId" : component.get("v.recordId"),
            "status" :"Payment success",
            "isActive":true
        };
        //"status" : $A.get("$Label.c.ETST_Payment_Success_In_Review")
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('Updated the status...');
                helper.redirectTo(component, '/etst-home-page');
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    redirectTo : function(component, page) {
      var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                            "url": page                            
                        });
        urlEvent.fire();

    },
    createInvoice: function(component, event, helper) {
        console.log("record Id***"+component.get("v.recordId"));
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "createInvoice";
        var params = {
            "serviceRecordId" : component.get("v.recordId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                window.open("/apex/ETST_InvoicePage?&id="+component.get("v.recordId"),'_blank');

                //helper.redirectTo(component, "/apex/ETST_InvoicePage?&id="+component.get("v.recordId"));
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    getInvoice: function(component, event, helper){
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getInvoice";
        var params = {
            "serviceRecordId" : component.get("v.recordId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.invoiceRecord', response);
                if(response!=null && response!=undefined){
                if(response.ETST_Type__c == 'Cheque' || response.ETST_Type__c == 'Bank Transfer / Cash Deposit') 
                   component.set('v.isInvoicePresent', true);
                }
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )
    },
    getStudent: function(component, event, helper){
        var value = component.get('v.recordId');
        console.log('studentId***'+value);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getStudent";
        var params = {
            "serviceRecordId" : component.get("v.recordId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.studentRecord', response.student);
                component.set('v.courierAddress', response.address);
                var options=component.get('v.paymentOptions');
                if(response.chequeAllowed){
                    options.push({'label': 'Cheque', 'value': '4'});
                }
                component.set('v.paymentOptions',options);
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