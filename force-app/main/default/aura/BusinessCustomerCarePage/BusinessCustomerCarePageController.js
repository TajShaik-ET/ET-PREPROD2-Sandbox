({
    handleOnLoad : function(component, event, helper) {
        component.find("complaintTypeFeedback").set("v.value", "Feedback");
    },
    caseRatingChange : function(component, event, helper) {
        var rating = event.getParam("rating");
        component.find("caseRatingId").set("v.value",rating.toString());
    },
    handleOnSuccess : function(component, event, helper) {
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
        console.log('-------inside submit**');
        event.preventDefault(); //Prevent default submit
        helper.submitCase(component, event, helper);
        /*var eventFields = event.getParam("fields"); //get the fields
        alert(eventFields["ETST_Complaint_Type__c"]);
        eventFields["Status"] = 'New'; //Add Description field Value
        eventFields["Origin"] = 'CRM Portal';
        eventFields["RecordtypeId"] = '0123L0000000LeZ';
        eventFields["AccountId"]=component.get("v.AccountId")
        eventFields["ContactId"]=component.get("v.contactId")
        component.find('caseForm').submit(eventFields); //Submit Form*/
    },
    handleOnError: function (cmp, event, helper) {
        // alert('handleOnError errorMessage ');
        var error = event.getParams();
        console.log(JSON.stringify(error));
        
        // Get the error message
        var errorMessage = event.getParam("message");
        console.log(JSON.stringify(errorMessage));
        
       // alert('errorMessage '+errorMessage);
    }
    
})