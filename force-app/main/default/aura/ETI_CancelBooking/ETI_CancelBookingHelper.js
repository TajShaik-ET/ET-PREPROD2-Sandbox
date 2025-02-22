({
	fetchRescheduleCancelMetaData : function(component, event, helper) {
        var action = component.get("c.fetchRescheduleCancelMetaData");
        action.setParams({
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
               var result= response.getReturnValue();
                console.log('MetaData  ', result);
                component.set('v.reshudleCancelMetaData', result);
            }
            component.set('v.loading', false);
        });
        $A.enqueueAction(action);
    },
    handleOnSubmit : function(component, event, helper) {
        var bookings = component.get('v.bookings');
        console.log('bookings>>  ', JSON.stringify(bookings));
        var showValidationError = false;
        //var fields = component.find("newBookingField");
        var vaildationFailReason = '';
        /*fields.forEach(function (field) {
            if (field.get("v.fieldName") === 'Cancellation_Reason__c' && $A.util.isEmpty(field.get("v.value"))) {
                showValidationError = true;
                vaildationFailReason = "The field 'Cancellation Reason' cannot be empty!";
            }
        });*/
        if(component.find('newBookingField').get('v.value') == undefined || component.find('newBookingField').get('v.value') =='' || component.find('newBookingField').get('v.value') ==null){
            showValidationError = true;
            vaildationFailReason = "The field 'Cancellation Reason' cannot be empty!";
        }

        if (!showValidationError) {
            /*fields.forEach(function (field) {
                if(field.get("v.fieldName") === 'Cancellation_Reason__c')
                    bookings[0].Cancellation_Reason__c =field.get("v.value");
            });*/
            if(component.find('newBookingField').get('v.value') != undefined && component.find('newBookingField').get('v.value') !='' && component.find('newBookingField').get('v.value') !=null)
            	bookings[0].Cancellation_Reason__c = component.find('newBookingField').get('v.value');
             console.log('bookings end>>  ', JSON.stringify(bookings[0]));
            this.cancelRequest(component,bookings);
        } else {
            component.find('bkngMessage').setError(vaildationFailReason);
            component.set('v.loading', false); 
        }
    },
    cancelRequest : function(component, rows) {
        let metadatamap = component.get('v.reshudleCancelMetaData');
        console.log('@@', metadatamap);
        var rowid = component.get('v.recordId');
        console.log(rowid);
        console.log('bookings####  ', rows[0]);
        var bookingDate  = new Date(rows[0].Booking_Date__c);
        var currentDat = new Date();
        var rescheduleMtd;
        var diffval = currentDat - bookingDate;
        const diffTime = Math.abs(currentDat - bookingDate);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
        console.log('@@@@@  ' + diffDays);
        var refundPercentage;
        let isRescheduleCancel=false;
        let isReschedule=false;
        console.log('Cancel  ');
        if(rows[0].Payment_Status__c=='Payment Success' && rows[0].Booking_Status__c!='Cancelled'){
        	metadatamap.Cancel.forEach(function(each) {
                console.log('each>> '+JSON.stringify(each));
                if(!isReschedule && diffDays<$A.get("$Label.c.ETI_Full_Amount_Refund_Days") ){
                    console.log('each111>> '+JSON.stringify(each));//&& (each.Max_Time_Limit__c >= diffDays || diffDays == 1)
                    if(diffDays<=each.Max_Time_Limit__c && each.Max_Time_Limit__c!=$A.get("$Label.c.ETI_Full_Amount_Refund_Days") ){
                        isReschedule=true;
                        if(each.Refund_Percentage__c!=null || each.Refund_Percentage__c!=undefined)
                        	var r = confirm("You will be refunded "+ each.Refund_Percentage__c+ "% of total amount, still want to Cancel.");
                        else
                        	var r = confirm("You will be refunded "+ each.Refund_Amount__c+ " of total amount, still want to Cancel.");
                        if (r == true) {
                            rescheduleMtd=each;
                        } else {
                            isRescheduleCancel=true;
                            return false;  
                        }
                    }
                }else if(!isReschedule && each.Max_Time_Limit__c >= $A.get("$Label.c.ETI_Full_Amount_Refund_Days")){
                    isReschedule=true;
                    var r = confirm("You will be refunded the full Amount.");
                    if (r == true) {
                        rescheduleMtd=each;
                    } else {
                        isRescheduleCancel=true;
                       return false;  
                    }
                }
           });
        }if(rows[0].Booking_Status__c=='Cancelled'){
            
        }else {
            var r = confirm("Are you sure you want to cancel this Booking.");
            if (r == true) {
                
            } else {
                isRescheduleCancel=true;
                return false;  
            }
        }
        if(!isRescheduleCancel){
            console.log('rescheduleMtd: '+rescheduleMtd);
            component.set('v.loading', true);
            var metaDataId;
            if(rescheduleMtd!=undefined){
                metaDataId=rescheduleMtd.Id;
        	}
            console.log('metaDataId: '+metaDataId);
            var action = component.get("c.doCancelBooking");
            action.setParams({
                "booking": rows[0], 
                "metaDataId": metaDataId,
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                if (component.isValid() && state === "SUCCESS") {
                    $A.get('e.force:refreshView').fire();
                    console.log('response>> ', JSON.stringify(response.getReturnValue()));
                    if(response.getReturnValue() == null || response.getReturnValue() == false){
                        var msg='Unable to complete your request due to unexpected error, Please try again or contact system admin.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast("Error",msg,"","dismissible","error");
                    }else {
                        var msg='Your request has been completed successfully.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast("Success!",msg,"","dismissible","success");
                    }
                }else if(state = "ERROR"){
                    var msg='Unexpected error occurred while processing your request. Please try again or contact system admin.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Error",msg,"","dismissible","error");
                }else {
                    console.log('else block state: '+state);
                }
                component.set('v.loading', false);
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            });
            $A.enqueueAction(action);
        }
    },
    })