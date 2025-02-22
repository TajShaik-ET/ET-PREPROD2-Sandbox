({
    getVehcileBookings : function(component, event, helper) {
        debugger;
        component.set('v.bookingColumns', [{label: 'Booking Num', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
                                           {label: 'Type', fieldName: 'ETST_Service_Type__c', type: 'text'},
                                           {label: 'Billing Total(with VAT)', fieldName: 'Total_Booking_Cost_With_Vat__c', type: 'currency'}
                                          ]);
        component.set('v.refundcolumns', [{label: 'Booking Num', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
                                          {label: 'Type', fieldName: 'ETST_Service_Type__c', type: 'text'},
                                          {label: 'Billing Total(with VAT)', fieldName: 'Total_Booking_Cost_With_Vat__c', type: 'currency'},
                                          {label: 'Refund Amount', fieldName: 'refundAmount', type: 'currency'}
                                         ]);
        var recId = component.get("v.recordId");
        var action = component.get('c.getVehicleBookings');
        console.log(recId);
        action.setParams({
            "recId":recId
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                if(records.length == 0){
                    component.set('v.noBookings', true);
                }else{
                    records.forEach(function(record){
                        record.linkName = '/'+record.Id;
                    });  
                }
                component.set('v.vehicleBookings', records);
                component.set('v.dataloaded',true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);	
    },
    
    saveRefunds :function(component, event, helper) {
        var action = component.get('c.createRefund');
        component.set('v.loading', !component.get('v.loading'));
        action.setParams({
            "lineItems":component.get("v.selectedBookings")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.loading', !component.get('v.loading'));
               // alert('refund created');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": 'Booking has been cancelled and refund created.',
                    "type": "Success"
                });
                toastEvent.fire();
                // Close the action panel
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
               // alert('error');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": 'Something gone wrong please try after sometime or contact support.',
                    "type": "Error"
                });
                toastEvent.fire();
                component.set('v.loading', !component.get('v.loading'));
            }
        }));
        $A.enqueueAction(action);	
    },
    calculateRefundAmount : function(component, event, helper) {
        debugger;
        var ids = component.get("v.selectedBookingIds");
        console.log('json '+ids)
        var action = component.get('c.calculateRefundAmount');
        action.setParams({
            "vehBkngs": ids
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            var totalRefundAmount = 0;
            if (state === "SUCCESS") {
                var results =response.getReturnValue();
                var bookings =component.get('v.selectedBookings');
                component.set('v.refundMap',results);
                for(var i=0;i<bookings.length;i++){
                    bookings[i].refundAmount=0;
                    if(results[bookings[i].Id]!=undefined){
                        bookings[i].refundAmount=results[bookings[i].Id]; 
                        totalRefundAmount+= bookings[i].refundAmount; 
                    } 
                }
                component.set('v.selectedBookings',bookings);
                component.set('v.page','page2');
                component.set('v.totalRefundAmount',totalRefundAmount);
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);	
    }
})