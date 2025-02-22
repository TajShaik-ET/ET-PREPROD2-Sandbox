({
	doinit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getBookingRecord");
        action.setParams({ 
            recordId : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var servicereq = response.getReturnValue();
                if(servicereq != 'Success' ){
                    component.set('v.isConfirm', false);
                    component.set('v.isSpinnerOpen', false);
                }else{
                    component.set('v.isConfirm', true);
                    //window.location.reload();
                   // $A.get("e.force:closeQuickAction").fire(); 
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
		 //$A.get("e.force:closeQuickAction").fire(); 
	},
    handleSubmit : function(component, event, helper){
        try{
            component.set('v.isSpinnerOpen', true);
            event.preventDefault();       // stop the form from submitting
            let fields = event.getParam("fields");
            fields.Is_booking_Confirmed__c = true;
            fields.Booking_Status__c = 'Confirmed';
            component.find("theForm").submit(fields);
        }catch(err){
            alert(err.message)
        }
    },
    handleSuccess : function(component, event, helper){
        component.set('v.isSpinnerOpen', false);
        var msg='Your booking is confirmed successfully!!.';
        var utility = component.find("ETI_UtilityMethods");
        var promise = utility.showToast("Info!",msg,"","Sticky","info");
        $A.get("e.force:closeQuickAction").fire(); 
    },
    handleOnLoad : function(component, event, helper){
       component.set('v.isSpinnerOpen', false);  
    },
    cancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire(); 
    }
})