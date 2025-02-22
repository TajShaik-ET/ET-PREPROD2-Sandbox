({
    callServer : function(component, event, helper) {
        
        var empNo = component.get("v.EmpNumber");
        var action = component.get("c.syncWithERP");
        action.setParams({ "empNumber" : empNo });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.CallcoutMsg", response.getReturnValue());
                var strTemp = component.get("v.CallcoutMsg").substring(component.get("v.CallcoutMsg").indexOf('@')+ 1);
                

                if( strTemp == 'Success' && component.get("v.CallcoutMsg") =='Could not derive employee information from HRMS')
                    helper.showError(component, event, helper);
                else
                    helper.showSuccess(component, event, helper);
                if( strTemp == 'Failed')
                    helper.showError(component, event, helper);

                component.set("v.EmpNumber",'');
                component.set('v.isDisabled', true);  
            } 
            else {
                component.set("v.CallcoutMsg", response.getReturnValue());
                helper.showError(component, event, helper);
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    },
    showInfo : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Info',
            message: '!...Please enter the employee number to sync from ERP.',
            duration:' 5000',
            key: 'info_alt',
            type: 'info',
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: component.get("v.CallcoutMsg"),
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:component.get("v.CallcoutMsg"),
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    showWarning : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'This is a warning message.',
            duration:' 5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
        toastEvent.fire();
    }
   
})