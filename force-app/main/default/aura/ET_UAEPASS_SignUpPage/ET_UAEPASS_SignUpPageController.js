({
    doInit: function (component, event, helper) {
        var urlParams = helper.parseUrlParams();
        console.log('Init urlParams:');
        //console.table(urlParams);
        let urlVal = new URL(window.location.href);
        let searchParams = urlVal.searchParams;
        let errDesc = searchParams.get('ErrorDescription');
        let errCode = searchParams.get('ErrorCode');
        if (errCode != null && errCode != '') {
            component.set("v.ErrCode", errCode);
            component.set("v.showProcessingPage", false);
            if (errCode == 'REGISTRATION_HANDLER_ERROR' && errDesc != null) {
                //window.open('https://stg-id.uaepass.ae/idshub/authorize?response_type=code&client_id=et_salesforce_web_stage&scope=urn:uae:digitalid:profile:general&state=HnlHOJTkTb66Y5H&redirect_uri=https://icrm--business.sandbox.my.site.com/customer/services/authcallback/UAE_PASS&acr_values=urn:safelayer:tws:policies:authentication:level:low','_top');
                component.set("v.showQues", true);
                component.set('v.showErrMsg', false);
                helper.getSSOUserData(component, event, helper, errDesc);
            } else if (errCode == 'Remote_Error' || errCode == 'Invalid_Request' || errCode == 'NO_ACCESS' || errCode == 'No_Oauth_State') {
                component.set('v.showErrMsg', true);
            } else {
                component.set('v.showErrMsg', true);
            }
        }
    },

    handleYesClick: function (component, event, helper) {
        console.log('handleYesClick');
        //window.open('https://stg-id.uaepass.ae/idshub/authorize?response_type=code&client_id=sandbox_stage&scope=urn:uae:digitalid:profile:general&state=HnlHOJTkTb66Y5H&redirect_uri=https://icrm--business.sandbox.my.site.com/customer/s/signupaccountexist&acr_values=urn:safelayer:tws:policies:authentication:level:low','_top');
        component.set("v.showLoginForm", true);
        component.set("v.showQues", false);
        component.set("v.showSignupForm", false);
    },

    /*handleNoClick: function(component, event, helper) {
        console.log('handleNoClick');
        //window.open('https://stg-id.uaepass.ae/idshub/authorize?response_type=code&client_id=sandbox_stage&scope=urn:uae:digitalid:profile:general&state=HnlHOJTkTb66Y5H&redirect_uri=https://icrm--business.sandbox.my.site.com/customer/s/signup&acr_values=urn:safelayer:tws:policies:authentication:level:low','_top');
        component.set("v.showLoginForm",false);
        component.set("v.showQues",false);
        component.set("v.showSignupForm",true);
    },*/

    linkWithUPassHandler: function (component, event, helper) {
        try {
            helper.handleLogin(component, event, helper);
        } catch (e) {
            console.log(e.message)
        }
    },

    onKeyUp: function (component, event, helper) {
        if (event.getParam('keyCode') === 13) {
            helper.handleLogin(component, event, helper);
        }
    },

    createUserHandler: function (component, event, helper) {
        component.set("v.showProcessingPage", true);
        component.set("v.showSpinner", true);
        let userInfo = component.get('v.userInfo');
        var action = component.get('c.createUser');
        action.setParams({ userInfoStr: JSON.stringify(userInfo), accRecType: 'Person_B2C' });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let data = response.getReturnValue();
                console.log('createUserHandler data:')
                //console.table(data);
                if (data) {
                    component.set("v.showSpinner", false);
                    component.set("v.showProcessingPage", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": "Your user has been created successfully and redirecting to portal."
                    });
                    toastEvent.fire();
                    //window.open('https://icrm.my.site.com/customer/s/','_top');
                    //window.open('https://icrm--business.sandbox.my.site.com/customer/services/auth/sso/UAE_PASS', '_top'); //Businsess Sandbox
                    window.open('https://icrm.my.site.com/customer/services/auth/sso/uaepass', '_top'); //Production
                } else {
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var errors = response.getError();
                        component.set("v.showSpinner", false);
                        component.set("v.showProcessingPage", false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type": "Error",
                            "mode": "sticky",
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

    showSpinnerHandler: function (component, event, helper) {
        component.set("v.showSpinner", true);
    },

    hideSpinnerHandler: function (component, event, helper) {
        component.set("v.showSpinner", false);
    }

})