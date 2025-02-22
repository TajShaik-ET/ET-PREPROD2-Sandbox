({
	handleLogin : function(component, event, helper) {
       
	    var username = component.find("username").get("v.value");
        var password = component.find("password").get("v.value");
       component.set("v.showSpinner",true);
        //var startUrl = 'https://icrm--business.sandbox.my.site.com/customer/services/auth/oauth/UAE_PASS';        
        var startUrl = 'https://icrm--business.sandbox.my.site.com/customer/s/signup?un='+username;
        //var startUrl = 'https://stg-id.uaepass.ae/idshub/authorize?response_type=code&client_id=sandbox_stage&scope=urn:uae:digitalid:profile:general&state=HnlHOJTkTb66Y5H&redirect_uri=https://icrm--business.sandbox.my.site.com/customer/s/signup&acr_values=urn:safelayer:tws:policies:authentication:level:low';
        startUrl = decodeURIComponent(startUrl);
      
        var action = component.get("c.login");
        action.setParams({username:username, password:password, startUrl:startUrl});
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            console.log(rtnValue)
            if (rtnValue !== null) {
                component.set("v.showError",true);
                component.set("v.errorMessage",rtnValue);
                 component.set("v.showSpinner",false);
            }else{
                 component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
	},
    
    authenticateUAEPass :  function(component, event, helper,userName) {
       
      //To link CRM user scenario
         
      window.open('https://stg-id.uaepass.ae/idshub/authorize?response_type=code&client_id=sandbox_stage&scope=urn:uae:digitalid:profile:general&state=HnlHOJTkTb66Y5H&redirect_uri=https://icrm--business.sandbox.my.site.com/customer/s/signup?un='+userName+'&acr_values=urn:safelayer:tws:policies:authentication:level:low','_top');
        
    },
    
    linkUserAccountWithUPass : function(component, event, helper,userName,codeVal) {
         
     
     try{
      var action = component.get('c.linkCrmUserWithUpass');
      
        action.setParams({userName : userName,codeVal:codeVal});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
                    
            if (state === "SUCCESS") {  
             
                let data = response.getReturnValue();
             
                if(data && data == 'Success'){
                
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "Your user has been linked with UAE PASS successfully."
                    });
                    toastEvent.fire();
                    
                   window.open('https://icrm--business.sandbox.my.site.com/customer/s/','_top');

                   /* var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/customer/s"
                    });
                    urlEvent.fire();
                    /*window.setTimeout(
                        $A.getCallback(function() {
                           
                        }), 2000
                    );*/
                  
                }
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message)                       
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
          }); 
        
        $A.enqueueAction(action);
     }catch(e){
         console.log(e.message)
     }
    },
     getCommunityForgotPasswordUrl : function (component, event, helpler) {
        var action = component.get("c.getForgotPasswordUrl");
        action.setCallback(this, function(a){
        var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.communityForgotPasswordUrl',rtnValue);
            }
        });
        $A.enqueueAction(action);
    },
})