({
   /* getAccountInfo : function(component, event, helper) {
      //  alert("1st function");
       component.set("v.showSpinner",true);
        var action = component.get("c.getAccountDetails");
        action.setParams({
            AccountID: component.get("v.recordId")
        });
        action.setCallback(this, function(data){
           
            var state = data.getState();
            // component.set("v.showSpinner",false);
            //   alert(state);
            if (state === "SUCCESS") {
                // var accountData = Object;
                console.log('data.getReturnValue() ',data.getReturnValue());
                var accountData = data.getReturnValue();
                //   alert("inside success");
                // alert(accountData["Integration_Status__c"]);
                //  alert(accountData.Integration_Status__c);
                //alert(accountData.AccountNumber);
                component.set("v.IntegrationStatus",accountData.Integration_Status__c);
                component.set("v.CustomerAccountId",accountData.ETSALES_Customer_Account_Id__c);
                
                var integrationStatus = component.get("v.IntegrationStatus");
                var CustomerAccountId = component.get("v.CustomerAccountId");
               // alert("2nd function");
                //alert(AccountNumber);
                // alert(integrationStatus);
               if(CustomerAccountId)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "message": "Account is already Sync with Oracle. Customer Account is Present"
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    return false;
                }
               if(integrationStatus=='Success')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "message": "Account is already Sync with Oracle. Integration Status is Success"
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    return false;
                }
                
                var action2 = component.get("c.integrateAccountToOracleButton");
                action2.setParams({
                    AccountID: component.get("v.recordId")
                });
                action2.setCallback(this, function(data2){
                    var state1 = data2.getState();
                      component.set("v.showSpinner",false);
                    if(state1 === "SUCCESS")
                    {
                        var integrationStatus = data2.getReturnValue();
                        if(integrationStatus)
                        {
                              var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type":"Success",
                            "message": "Account Sync Request is Raised.Please check status after some time."
                            
                        });
                        toastEvent.fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        }else
                        {
                             var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type" : "error",
                            "message": "Account Sync Integration Failed."
                        });
                        toastEvent.fire();  
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                        }
                      
					}
                    else
                    {
                        var errors = data2.getError();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type" : "error",
                            "message": errors[0].message
                        });
                        toastEvent.fire();  
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                    }
                    
                });
                    
                    $A.enqueueAction(action2);
            }
            else
            {
                  component.set("v.showSpinner",false);
                 var errors = data.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": errors[0].message
                });
                toastEvent.fire();  
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    checkforError : function(component, event, helper) {
        var integrationStatus = component.get("v.IntegrationStatus");
        var AccountNumber = component.get("v.AccountNumber");
        alert("2nd function");
        alert(AccountNumber);
        alert(integrationStatus);
        if(AccountNumber!='')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": "New Account Sync is not possible.Account Number is already Present"
            });
            toastEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
            return false;
        }
        else if(integrationStatus=='Success')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": "Account is already Sync with Oracle. Integrated Status is Success"
            });
            toastEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
            return false;
        }
        
        
    }*/
    
    callAccountERP : function(component, event, helper) {

        var action = component.get('c.callERPAccountIntegration');
      
        action.setParams({
            AccountId : component.get("v.recordId")           
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                
                
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
          });
        
        $A.enqueueAction(action);  
    }
})