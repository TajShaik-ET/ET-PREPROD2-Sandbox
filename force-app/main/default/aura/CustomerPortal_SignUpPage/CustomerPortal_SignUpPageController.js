({
	doInit : function(component, event, helper) {
		
        let urlVal = new URL(window.location.href);
        let searchParams = urlVal.searchParams;
        let codeVal = searchParams.get('code');
        let userName = searchParams.get('un');
        let errMsg = searchParams.get('error');
        let errCode = searchParams.get('ErrorCode');
         component.set('v.showErrMsg',true); //added by jana
        if(errCode){
           
            component.set("v.ErrCode",errCode);
            if(errCode == 'Remote_Error' || errCode=='No_Oauth_State'){
              component.set('v.showErrMsg',true);
           
            }else{
                
              component.set('v.showDefError',true); 
           // component.set('v.showQues',true); 
            
            }
           //component.set('v.showProcessingPage',false); 
           
        }else{
              component.set('v.showDefError',true); 
        }
        //commented below code as part of phase 1
       /* if(!codeVal && !userName && !errMsg && !errCode){
            component.set('v.showProcessingPage',false); 
            component.set('v.showQues',true);
          
        }
        if(errMsg){
            component.set('v.showQues',false); 
            component.set('v.showErrMsg',true); 
            component.set('v.showProcessingPage',false);
            component.set('v.cancelErrMsg',errMsg);
        }
        
        if(codeVal && userName== null){
            
            var action = component.get("c.getUAEPassUserInfo");
            action.setParams({codeVal:codeVal});
            
            action.setCallback(this, function(response) {
            var state = response.getState();
                    
            if (state === "SUCCESS") {  
             
               var rtnValue = response.getReturnValue();
                console.log(rtnValue);
                 
                if(rtnValue && rtnValue.error){
                     component.set('v.showQues',true);
                    component.set('v.showProcessingPage',false); 
                }else{
                    component.set('v.userInfo',rtnValue); 
                    component.set('v.showLoginForm',false);
                    component.set('v.showQues',false); 
                    component.set('v.showProcessingPage',false); 
                    component.set('v.showSignupForm',true);
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
          
            
        }
        if(userName && codeVal == null){
            //Only Username redirect to uae pass url
           
           helper.authenticateUAEPass(component, event, helper,userName);
            
        }
        if(userName && codeVal){
          
           helper.linkUserAccountWithUPass(component, event, helper,userName,codeVal);
                   
        }*/
       
             
	},
    handleTest : function(component, event, helper) {
        
        helper.linkUserAccountWithUPass(component, event, helper,'Test1','test2');
    },
    handleYesClick :function(component, event, helper) {
        
        component.set("v.showLoginForm",true);
        component.set("v.showQues",false);
        
       // window.open('https://icrm--business.sandbox.my.site.com/customer/services/auth/link/UAE_PASS','_top');

        
    },
    handleNoClick:function(component, event, helper) {
        
       
        if (window.history) {
            console.log(window.history)
            var myOldUrl = window.location.href;
            window.addEventListener('hashchange', function(){
                
               window.history.pushState({}, null, myOldUrl);
            });
       } 
        //window.open('https://icrm--business.sandbox.my.site.com/customer/services/auth/sso/UAE_PASS','_top');
       window.open('https://stg-id.uaepass.ae/idshub/authorize?response_type=code&client_id=sandbox_stage&scope=urn:uae:digitalid:profile:general&state=HnlHOJTkTb66Y5H&redirect_uri=https://icrm--business.sandbox.my.site.com/customer/s/signup&acr_values=urn:safelayer:tws:policies:authentication:level:low','_top');

        //window.open('https://stg-id.uaepass.ae/idshub/authorize?response_type=code&client_id=sandbox_stage&scope=urn:uae:digitalid:profile:general&state=HnlHOJTkTb66Y5H&redirect_uri=https://icrm--business.sandbox.my.site.com/customer/services/authcallback/UAE_PASS&acr_values=urn:safelayer:tws:policies:authentication:level:low','_top');

      //window.open('https://icrm--business.sandbox.my.site.com/customer/services/auth/oauth/UAE_PASS','_top')
       
    },
    linkWithUPassHandler : function(component, event, helper) {
      

     //commented custom logic
      try{
         helper.handleLogin(component, event, helper);
        }catch(e){
            console.log(e.message)
        }
       
        
       
    },
    onKeyUp: function(component, event, helper){
        //checks for "enter" key
        if (event.getParam('keyCode')===13) {
            helper.handleLogin(component, event, helper);
        }
    },
    
    createUserHandler :  function(component, event, helper){
       component.set("v.showSpinner",true);
        let userInfo = component.get('v.userInfo');
        var action = component.get('c.createUser');
      
        action.setParams({data : userInfo});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
                   
            if (state === "SUCCESS") {  
              
                let data = response.getReturnValue();
              
                if(data){
                     component.set("v.showSpinner",true); 
                   
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "Your user has been created successfully and redirecting to login page."
                    });
                    toastEvent.fire();
                  
                  window.open('https://icrm--business.sandbox.my.site.com/customer/s/','_top');
                 
                   
                }else{
                                    
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var errors = response.getError();
                        component.set("v.showSpinner",false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"Error",
                            "mode":"sticky",
                            "message": errors[0].message
                        });
                        toastEvent.fire();
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
          }); 
        
        $A.enqueueAction(action);
        
    },
    showSpinnerHandler : function(component, event, helper){
         component.set("v.showSpinner",true);   
    },    
    hideSpinnerHandler :function(component, event, helper){
        
         component.set("v.showSpinner",false);  
        
    }
    
})