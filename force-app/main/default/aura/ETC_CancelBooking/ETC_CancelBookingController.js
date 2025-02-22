({
    doInit : function(component, event, helper) {
        helper.getVehcileBookings(component, event, helper);
        
    },
    
    handleSelect : function(component, event, helper) {
        
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        var ids = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            console.log('Selected rows name '+selectedRows[i].Id);
            ids.push(selectedRows[i].Id);
            setRows.push(selectedRows[i]);        
        }
        component.set("v.selectedBookings", setRows);
        component.set("v.selectedBookingIds", ids);
        console.log('id- '+ids);
    },
    
    handleNext : function(component, event, helper) {  
        var rows = component.get("v.selectedBookings");
        if(rows.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": 'info',
                "mode": 'dismissible',
                "title": "Warning!",
                "message": "Please atleast one record."
            });
            toastEvent.fire(); 
        }else{
            helper.calculateRefundAmount(component, event, helper);
        }
    },
    handleSave : function(component, event, helper) {        
        helper.saveRefunds(component, event, helper);
    }
})