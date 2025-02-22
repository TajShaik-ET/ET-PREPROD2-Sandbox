({
    handleLogin: function (component, event, helper) {
        var username = component.find("username").get("v.value");
        var password = component.find("password").get("v.value");
        var userInfo = component.get('v.userInfo');
        console.log('handleLogin userInfo:');
        //console.table(userInfo);
        component.set("v.showSpinner", true);
        component.set("v.showProcessingPage", true);
        var startUrl = 'https://icrm--business.sandbox.my.site.com/customer/s/signup?un=' + username;
        startUrl = decodeURIComponent(startUrl);
        //console.log(username + ' - ' + password);
        var action = component.get("c.login");
        action.setParams({ username: username, password: password, startUrl: startUrl, userInfoStr: JSON.stringify(userInfo) });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('handleLogin state: ' + state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                //console.log('result: ' + result);
                if (result !== true) {
                    component.set("v.showLoginError", true);
                    component.set("v.loginErrMsg", 'Unable to login. Contact ET Admin!');
                    component.set("v.showSpinner", false);
                    component.set("v.showProcessingPage", false);
                } else {
                    component.set("v.showSpinner", false);
                    component.set("v.showProcessingPage", false);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error('Error:');
                console.table(errors);
                if (errors) {
                    component.set("v.showSpinner", false);
                    component.set("v.showProcessingPage", false);
                    component.set("v.showLoginError", true);
                    if (errors[0] && errors[0].message) {
                        component.set("v.loginErrMsg", errors[0].message);
                    } else {
                        component.set("v.loginErrMsg", 'Unable to login. Contact ET Admin!');
                    }
                }
            } else {
                console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
    },

    getSSOUserData: function (component, event, helper, dataStrEncr) {
        //console.log('getSSOUserData dataStrEncr: ' + dataStrEncr);
        var action = component.get("c.getSSOUserData");
        action.setParams({ dataStrEncr: dataStrEncr });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('getSSOUserData state: ' + state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result:');
                //console.table(result);
                component.set("v.userInfo", result);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error('getSSOUserData Error:');
                console.table(errors);
                if (errors) {
                    component.set("v.showSpinner", false);
                    component.set("v.showProcessingPage", false);
                }
            } else {
                console.log("Unknown error");
            }
        });
        $A.enqueueAction(action);
    },

    parseUrlParams: function () {
        var params = {};
        var search = window.location.search.substring(1);
        if (search) {
            var pairs = search.split("&");
            pairs.forEach(function (pair) {
                var [key, value] = pair.split("=");
                params[decodeURIComponent(key)] = decodeURIComponent(value || "");
            });
        }
        return Object.entries(params).map(([key, value]) => ({ key, value }));
    },

})