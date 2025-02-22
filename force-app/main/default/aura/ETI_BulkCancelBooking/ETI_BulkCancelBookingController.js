({
    doInit : function(component, event, helper) {
        helper.getVehcileBookings(component, event, helper,null);
    },
    
    handleAllSelect: function(component, event, helper){
        try {
            var allBookingData=component.get("v.allBookingData");
            var bookingWrapper=component.get("v.bookingWrapper");
            for(let idx = 0 ; idx < allBookingData.length; idx++){
                if(component.get("v.isSelectAll"))
                	allBookingData[idx].isSelected=true;
                else 
                	allBookingData[idx].isSelected=false;
                for (var jdx = 0; jdx < bookingWrapper.length; jdx++) {
                    if(allBookingData[idx].isSelected==true && allBookingData[idx].booking.Id==bookingWrapper[jdx].booking.Id) 
                        bookingWrapper[jdx].isSelected=true;
                    else if(allBookingData[idx].isSelected==false && allBookingData[idx].booking.Id==bookingWrapper[jdx].booking.Id) 
                        bookingWrapper[jdx].isSelected=false;
                }
            }
            for (var jdx = 0; jdx < bookingWrapper.length; jdx++) {
                if(component.get("v.isSelectAll"))
                    bookingWrapper[jdx].isSelected=true;
                else 
                    bookingWrapper[jdx].isSelected=false;
            }
            component.set('v.bookingWrapper', bookingWrapper);
            component.set('v.allBookingData', allBookingData);
            helper.calculateRefundAmount(component, helper, allBookingData);
        } catch (error) {
            //alert(error.message);
            var msg='Unable to complete your Request, Please try again or contact system admin.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Info!",msg,"","Sticky","info");
        }
    },
    handleSelect: function(component, event, helper) {
        var bookingId=event.getSource().get("v.value");
        var allBookingData=component.get("v.allBookingData");
        try{
            for(let idx = 0; idx < allBookingData.length; idx++){
                if(allBookingData[idx].isSelected==false && allBookingData[idx].booking.Id==bookingId)
                    allBookingData[idx].isSelected=true;
                else if(allBookingData[idx].isSelected==true && allBookingData[idx].booking.Id==bookingId)
                    allBookingData[idx].isSelected=false;
            }
            component.set('v.allBookingData', allBookingData);
            console.log('allBookingData '+JSON.stringify(allBookingData));
            helper.calculateRefundAmount(component, helper, allBookingData);
        } catch (error) {
            var msg='Unable to complete your Request, Please try again or contact system admin.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Info!",msg,"","Sticky","info");
        }
    },
    searchKeyUp: function (component, event,helper) {
        var queryTerm = "%" + component.find('searchField').get('v.value') + "%";
        console.log('queryTerm>> '+queryTerm);
        helper.getVehcileBookings(component, event, helper, queryTerm);
    },
    closeCancelBookings : function(component, event, helper) {   
        component.set("v.showBulkCancelBookings", false);
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    submitBulkCancel: function(component, event, helper) { 
        var totalRefundAmount=component.get("v.totalRefundAmount");
        var allBookingData=component.get("v.allBookingData");
        var selectedbookings =[];
        if (component.find('fieldId').get('v.value') == '' || component.find('fieldId').get('v.value') == null || component.find('fieldId').get('v.value') == undefined){
            component.find('fieldId').setCustomValidity("This field is required");
            component.find('fieldId').reportValidity();
            return true;
        }else{
            component.find('fieldId').setCustomValidity("");
            component.find('fieldId').reportValidity();
        }
        for(var i=0;i<allBookingData.length;i++){
            if(allBookingData[i].isSelected)
                selectedbookings.push(allBookingData[i].booking.Id);
        }
        if(selectedbookings.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": 'warning',
                "mode": 'dismissible',
                "title": "Warning!",
                "message": "Please atleast one booking."
            });
            toastEvent.fire(); 
        }else {    
            var r = confirm("Total Refund Amount is AED "+totalRefundAmount);
            if (r == true){
            	component.set("v.showSubmit", false);
                helper.sendRefundRequest(component, helper, selectedbookings);
            	//component.set("v.showBulkCancelBookings", false);
            }
        }
    },
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
})