({
    doInit: function (component, event, helper) {
        var action = component.get('c.getUserAccountDetails');
        action.setParams({
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.businessWrapper', a.getReturnValue());
                var cntmap=0;
                for(var cnt in result.poList){
                    cntmap++;
                } 
                var maintainenceCntmap=0;
                for(var cnt in result.maintenancePoList){
                    maintainenceCntmap++;
                } 
                var totalcount=cntmap+maintainenceCntmap;
                component.set('v.orderCount', totalcount);
                // component.set('v.orderCount', cntmap);
                component.set('v.invCount', result.invCount); 
                // component.set('v.activeSites', result.sitesCount);
                
                
            }
        });
        $A.enqueueAction(action);
    },
    getProfileDetails: function (component, event, helper) {
        var action = component.get('c.getProfileName');
        action.setParams({
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                component.set('v.profileName', result);
            }
        });
        $A.enqueueAction(action);
    },
    getCaseCounts : function (component, event, helper) {
        var action = component.get('c.getDashboardData');
        var searchFilterCall= false;
        action.setParams({
            
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state
            if (state == 'SUCCESS') {
                var result = a.getReturnValue();
                 
                component.set('v.openCases', result.newCount+result.inprogressCount);
                /*component.set('v.escalatedCases', result.inprogressCount);
                component.set('v.onHoldCases', result.rejectedCount);
                component.set('v.invalidCases', result.approvedCount);
                component.set('v.closedCases', result.closedCount);
                helper.setCommunityLanguage(component, event, helper); */
            }
        });
        $A.enqueueAction(action);
    },
})