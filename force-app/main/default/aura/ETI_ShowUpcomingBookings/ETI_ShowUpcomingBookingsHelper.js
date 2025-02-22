({
    fetchVehicleHelper : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        // alert(userId);
        var action = component.get("c.getUpcomingBookings");
        action.setParams({
            "stDate" : component.get("v.startDate"),
            "enDate" : component.get("v.endDate")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result= response.getReturnValue();
            console.log('result>> '+JSON.stringify(result));
            component.set("v.VehicleList", result);
        });
        $A.enqueueAction(action);
    },
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
            
        });
        $A.enqueueAction(action);
    },
    rescheduleBooking : function(component, event, helper) {
        let metadatamap = component.get('v.reshudleCancelMetaData');
        console.log('@@', metadatamap);
        var rowid = event.currentTarget.getAttribute("data-value");
        console.log(rowid);
        var rows = component.get('v.VehicleList');
        console.log('rows>> ', JSON.stringify(rows));
        var refundPercentage;
        let isRescheduleCancel=false;
        var rescheduleMtd;
        try{
            console.log('Payment_Status ' + rows[rowid].Payment_Status__c);
            if(rows[rowid].booking.Payment_Status__c=='Payment Success'){
                console.log(rows[rowid].booking.Booking_Date__c)
                var bookingDate  = new Date(rows[rowid].booking.Booking_Date__c);
                var currentDat = new Date();
                var diffval = currentDat - bookingDate;
                const diffTime = Math.abs(currentDat - bookingDate);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                console.log('@@@@@diffDays  ' + diffDays);
                console.log('#### ' + $A.get("$Label.c.ETI_Full_Amount_Refund_Days"));
                console.log('Reschedule ' + metadatamap.Reschedule);
                console.log('####');
                let isReschedule=false;
                metadatamap.Reschedule.forEach(function(each) {
                    console.log('each>> '+JSON.stringify(each));
                    if(!isReschedule && diffDays<$A.get("$Label.c.ETI_Full_Amount_Refund_Days")){
                        console.log('each111>> '+JSON.stringify(each));//&& (each.Max_Time_Limit__c >= diffDays || diffDays == 1)
                        if(diffDays<=each.Max_Time_Limit__c && each.Max_Time_Limit__c!=$A.get("$Label.c.ETI_Full_Amount_Refund_Days") ){
                            console.log('each222>> '+JSON.stringify(each));
                            isReschedule=true;
                            if(each.Refund_Percentage__c!=null || each.Refund_Percentage__c!=undefined)
                                var r = confirm("Your Booking wont be Reschedule, Your booking is going to cancel. You have to create New Booking and You will be refunded "+ each.Refund_Percentage__c+ "% of total amount.");
                            else
                                var r = confirm("Your Booking wont be Reschedule, Your booking is going to cancel. You have to create New Booking and You will be refunded "+ each.Refund_Amount__c+ " of total amount.");
                            console.log('r>> '+r); 
                            if (r == true) {
                                rescheduleMtd=each;
                            } else {
                                console.log('r11>> '+r); 
                                isRescheduleCancel=true;
                                return false;  
                            }
                        }
                    }else if(!isReschedule && each.Max_Time_Limit__c >= $A.get("$Label.c.ETI_Full_Amount_Refund_Days")){
                        isReschedule=true;
                        var r = confirm(component.get("v.Booking_wont_Reschedule_Full_Amount"));
                        if (r == true) {
                            rescheduleMtd=each;
                        } else {
                            isRescheduleCancel=true;
                            return false;  
                        }
                    }
                });
            }else {
                var r = confirm(component.get("v.Booking_wont_Reschedule_Message"));
                if (r == true) {
                    
                } else {
                    isRescheduleCancel=true;
                    return false;  
                }
            }
        }catch(err){
            alert(err.message);
        }
        if(!isRescheduleCancel){
            var item=event.currentTarget.getAttribute("data-value");
            console.log('item>> '+item);
            console.log('rows[item].Id>> '+rows[item].booking.Id);
            component.set('v.VehicleList', rows);
            component.set('v.IsSpinner', true);
            console.log('rescheduleMtd: '+JSON.stringify(rescheduleMtd));
            var metaDataId;
            if(rescheduleMtd!=undefined){
                metaDataId=rescheduleMtd.Id;
        	}
            console.log('metaDataId: '+metaDataId);
            var action = component.get("c.getRescheduledBookingData");
            action.setParams({
                "bookingid": rows[item].booking.Id,
                "metaDataId": metaDataId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('state>> '+state);
                if (component.isValid() && state === "SUCCESS") {
                    console.log('response>> ', JSON.stringify(response.getReturnValue()));
                    if(response.getReturnValue() == null){
                        var msg=component.get("v.Unexpected_Error_Message");
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                    }else {
                        rows.splice(item, 1);
                        component.set("v.bookingWrp",response.getReturnValue());
                        component.set("v.reSchduleBooking", true);
                        /*var msg='Your request has been completed successfully.';
                            var utility = component.find("ETI_UtilityMethods");
                            var promise = utility.showToast("Success!",msg,"","dismissible","success");*/
                        }
                    }else {
                        var msg=component.get("v.Unexpected_Error_Message");
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                    }
                    component.set('v.IsSpinner', false);
                });
            $A.enqueueAction(action);
        }
    },
    cancelBooking : function(component, event, helper) {
        let metadatamap = component.get('v.reshudleCancelMetaData');
        console.log('@@', metadatamap);
        var rowid = event.currentTarget.getAttribute("data-value");
        console.log(rowid);
        var rows = component.get('v.VehicleList');
        console.log('####  ', rows[rowid])
        var bookingDate  = new Date(rows[rowid].booking.Booking_Date__c);
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
        if(rows[rowid].booking.Payment_Status__c=='Payment Success'){
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
                    var r = confirm(component.get("v.Refunded_full_Amount_Message"));
                    if (r == true) {
                        rescheduleMtd=each;
                    } else {
                        isRescheduleCancel=true;
                       return false;  
                    }
                }
           });
        }else {
            var r = confirm(component.get("v.Cancel_Booking_Message"));
            if (r == true) {
                
            } else {
                isRescheduleCancel=true;
                return false;  
            }
        }
        if(!isRescheduleCancel){
            var item=event.currentTarget.getAttribute("data-value");
            console.log('item: '+item);
            console.log(JSON.stringify(component.get("v.VehicleList")));
            var rowid = event.target.getAttribute("id");
            console.log('rowid: '+rowid);
            console.log('rescheduleMtd: '+rescheduleMtd);
            var rows = component.get('v.VehicleList');
            component.set('v.VehicleList', rows);
            console.log(JSON.stringify(rows)); 
            console.log(rows[item].booking.Id);
            console.log(rows[item]);            
            component.set('v.IsSpinner', true);
            //console.log('rescheduleMtd.Id: '+rescheduleMtd.Id);
            var metaDataId;
            if(rescheduleMtd!=undefined){
                metaDataId=rescheduleMtd.Id;
        	}
            console.log('metaDataId: '+metaDataId);
            var action = component.get("c.getBookingDataForUpdate");
            action.setParams({
                "bookingId": rows[item].booking.Id, //item.Id
                "metaDataId": metaDataId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                if (component.isValid() && state === "SUCCESS") {
                    $A.get('e.force:refreshView').fire();
                    console.log('response>> ', JSON.stringify(response.getReturnValue()));
                    if(response.getReturnValue() == null){
                        var msg= component.get("v.Unexpected_Error_Message");//'Unable to complete your request due to unexpected error, Please try again or contact customer care.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                    }else {
                        var rows = component.get('v.VehicleList');
                        rows.splice(item, 1);
                        component.set('v.VehicleList', rows);
                        var msg= component.get("v.Request_completed_Message");
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast(component.get("v.Success"),msg,"","dismissible","success");
                    }
                }else if(state = "ERROR"){
                    var msg= component.get("v.Unexpected_Error_Message");
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                }else {
                    console.log('else block state: '+state);
                }
                component.set('v.IsSpinner', false);
            });
            $A.enqueueAction(action);
        }
    },
    showSpinner: function(component){
        component.set("v.IsSpinner",true);  
    },
    
    hideSpinner: function(component){
        component.set("v.IsSpinner",false);  
    }, 
    /* ,
    handleConfirmDialog : function(component, event, helper) {
       
       var msg ='Your Booking wont be Reschedule, Your booking is going to cancel. You have to create New Booking';
        if (!confirm(msg)) {
            console.log('No');
            return false;
        } else {
            
             component.set('v.reSchduleBooking', true);
            console.log('Yes');
          
        }
    }*/
    changeDateFormat :function(date1){
        var date = new Date(date1);
        var year = date.getFullYear();
        
        var month = (1 + date.getMonth()).toString();
        month = month.length > 1 ? month : '0' + month;
        
        var day = date.getDate().toString();
        day = day.length > 1 ? day : '0' + day;
        
        return month + '/' + day + '/' + year;
    }
})