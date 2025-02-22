({
	handleEdit:function(component, event, helper) {
       // alert('in edit');
        //debugger;
        //component.set("v.editDetails", "true");
        //Navigate to Booking Page
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/car-rental-booking-form?reqId="+component.get("v.bReqId")
        });
        urlEvent.fire();
        
    },
})