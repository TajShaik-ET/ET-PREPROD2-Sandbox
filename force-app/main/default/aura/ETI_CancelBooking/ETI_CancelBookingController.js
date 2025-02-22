({
	onInit : function(component, event, helper) {
        component.set('v.loading', true);
        var action = component.get("c.getBookingDataById");
        action.setParams({
            "bookingId": component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
               var result= response.getReturnValue();
                console.log('bookings  ', result);
                var CurrentDate = $A.localizationService.formatDateUTC(new Date(), "YYYY-MM-DD");
                console.log('booking Date  ', result[0].Booking_Date__c);
                console.log('CurrentDate  ', CurrentDate);
                if(result[0].Test_Result__c=='Pending' && result[0].Booking_Date__c>=CurrentDate)
                	component.set('v.bookings', result);
                else {
                    var msg='You are not allowed to cancel this booking.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Error",msg,"","dismissible","error");
                    $A.get("e.force:closeQuickAction").fire();
                }
            }
            component.set('v.loading', false);
        });
        $A.enqueueAction(action);
        helper.fetchRescheduleCancelMetaData(component, event, helper) ;
	},
    handleError: function (component, event, helper) {
        component.set('v.loading', false);
        component.find('bkngMessage').setError('Undefined error occured');
    },
    handleSubmit: function(component, event, helper) {
        event.preventDefault();
        helper.handleOnSubmit(component);
    },
    
})