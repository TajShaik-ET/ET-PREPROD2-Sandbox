({
    handleOnSuccess : function(component, event, helper) {        
        component.set('v.loaded',true);
        $A.get("e.force:closeQuickAction").fire();        
        $A.get('e.force:showToast').setParams({
            "title": "Success",
            "message": "Record has been saved!",
            "type": "success",
        }).fire();
        var actionEvt = $A.get("e.c:ETST_sendDataEvent");
        actionEvt.setParams({
            "actionname": 'refresh'
        });
        actionEvt.fire();
    },
    handleOnSubmit : function(component, event, helper) {
        console.log('-------inside submit');
        component.set('v.loaded',false);
        var eventFields = event.getParam("fields");
        eventFields["Status"] = 'New'; //Add Description field Value
        eventFields["Origin"] = 'CRM Portal';
        eventFields["Subject"] = 'MRO Case';
        eventFields["RecordTypeId"] = '0123z0000010YImAAM';
    },
    handleOnError: function (cmp, event, helper) {
       var error = event.getParams();
        // Get the error message
        var errorMessage = event.getParam("message");
        console.log('errorMessage '+errorMessage)
    }
    
})