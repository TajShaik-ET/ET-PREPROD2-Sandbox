({
	doInit : function(component, event, helper) {
        
	 
	},
    onForceLoad : function(component, event, helper) {
      let email = component.get("v.record.Customer_Email__c");
      component.set("v.emailVal",email);
    },
    
    sendEmail : function(component, event, helper){
      let email  = component.get("v.emailVal");
      var emailField = component.find("email");
        
      var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      
        if(email){  
          
            if(email.match(regExpEmailformat)){
                emailField.set("v.errors", [{message: null}]);
                $A.util.removeClass(emailField, 'slds-has-error');  
                serverCall();
            }else{
                $A.util.addClass(emailField, 'slds-has-error');
                emailField.set("v.errors", [{message: "Please Enter a Valid Email Address"}]);               
            }  
        
            function serverCall(){    
                 component.set("v.disableBtn",true);
                var action = component.get('c.sendEmailToCustomer');
                action.setParams({ 
                    emails:email,
                    RecId:component.get('v.recordId')
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (state === "SUCCESS") {  
                        
                        helper.showToast('success','Success','Email has been sent successfully'); 
                        $A.get("e.force:closeQuickAction").fire();
                         component.set("v.disableBtn",false);
                        if(component.get("v.isCommunity")){
                           var pageChangeEvent = component.getEvent("closePopup");
                        pageChangeEvent.fire(); 
                        }
                        
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                component.set("v.disableBtn",false);
                                console.log("Error message: " + errors[0].message);
                                helper.showToast('error','error','Please check with ET Admin');       
                            }
                        } else {
                            console.log("Unknown error");
                            
                        }
                    }
                }); 
                
                $A.enqueueAction(action);
            }  
        }else {
            helper.showToast('warning','warning','Please enter email address');
        }
    },
    closeModel : function(component, event, helper){
        var pageChangeEvent = component.getEvent("closePopup");
        pageChangeEvent.fire(); 
    }
})