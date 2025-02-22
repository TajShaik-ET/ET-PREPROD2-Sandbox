({
    accountDetails : function(component, event, helper) {
        var action = component.get("c.getChangelocationFromContact");
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state>>---- '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result onload>> '+JSON.stringify(result));
                component.set("v.emirate",result);
                if(result=='Sharjah')
                    component.set('v.isSpea',true);
                this.fetchServiceRequests(component);
            }
        });
        $A.enqueueAction(action);
    },
    fetchServiceRequests : function(component, event, helper) {
        component.set("v.IsSpinner", true);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        // alert(userId);
        var action = component.get("c.getUpcomingServiceRequests");
        action.setParams({
            "stDate" : component.get("v.startDate"),
            "enDate" : component.get("v.endDate"),
            "emirate": component.get("v.emirate")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result= response.getReturnValue();
            console.log('result>> '+JSON.stringify(result));
            let servicelistWrap = [];
            for(let index= 0; index < result.length; index++){
                let isPaynow = false;
                //and(and(service.Payment_Status__c!='Payment Pending',service.Payment_Status__c!='Failed', service.Payment_Status__c!='Await3D',service.Payment_Status__c!='Refund Requested',service.Payment_Status__c!='Payment Success'),service.Total_Amount__c)
                let service  = result[index];
                let isServiceCheck =  service.Payment_Status__c!='' &&service.Payment_Status__c!='Await3D' && service.Payment_Status__c!='Refund Requested'&& service.Payment_Status__c!='Payment Success' && service.Total_Amount__c;
               
                if(isServiceCheck){
                    isPaynow = true;
                    if(service.ET_Payments__r != undefined){
                        
                        for(let paymentIndex = 0 ; paymentIndex < service.ET_Payments__r.length; paymentIndex++ ){
                            let payment = service.ET_Payments__r[paymentIndex];
                            if(payment.ETST_Payment_State__c == null||payment.ETST_Payment_State__c == ''||payment.ETST_Payment_State__c == 'Await3D' || payment.ETST_Payment_State__c == 'AWAIT_3DS' || payment.ETST_Payment_State__c == 'Payment Success'){
                               isPaynow = false; 
                            }
                        }
                    }
                    //isPaynow
                }
                let wrp ={
                    "serviceRecord": result[index],
                    "isPayNowVisible": isPaynow
                };
                servicelistWrap.push(wrp);
            }
            component.set("v.serviceReqList", servicelistWrap);
            component.set("v.showBookings", false);
            component.set("v.IsSpinner", false);
        });
        $A.enqueueAction(action);
    },
    fetchBookingsHelper : function(component, event, helper,reqId) {
        //var reqId = event.currentTarget.getAttribute("data-value");
      
        console.log('reqId>> '+reqId);
        component.set("v.IsSpinner", true);
        // event.getSource().get("v.value")
        var action = component.get("c.getUpcomingBookings");
        action.setParams({
            "srReqId" : reqId,
            "stDate" : component.get("v.startDate"),
            "enDate" : component.get("v.endDate"),
            "emirate": component.get("v.emirate")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result= response.getReturnValue();
            console.log('result>> '+JSON.stringify(result));
            component.set("v.VehicleList", result);
            component.set("v.allBookingData", result);
            component.set("v.showBookings", true);
            component.set("v.totalRecords",result.length);
            console.log('totalRecords>> '+component.get("v.totalRecords"));
            component.set("v.totalPages", Math.ceil(result.length/component.get("v.pageSize")));
            component.set("v.currentPageNumber",1);
            console.log('totalPages length>> '+component.get("v.totalPages"));
            this.buildData(component, helper);
            component.set("v.IsSpinner", false);
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
    /**
     * Author:Janardhan
     * Date:21-12-2022
     * Desc: Separate method created for SPEA reschedule process,there is no extra payment for 
     * SPEA rescheudle bookings.
     * */
     rescheduleBookingSpea:function(component, event, helper) {        
      
        component.set("v.IsReSchduleBookingSpea",true);
        var result = new Date();
        var result1 = new Date();
        result.setDate(result.getDate());
        var todayErrMsgFormat = $A.localizationService.formatDate(result, "dd MMM yyyy");
        component.set('v.minDateErrmsg',todayErrMsgFormat);
        var today = $A.localizationService.formatDate(result, "YYYY-MM-DD");
        result1.setDate(result1.getDate() + parseInt($A.get("$Label.c.ETI_BookingMaxDateLimitInDays")));
        var maxDate = $A.localizationService.formatDate(result1, "YYYY-MM-DD");
        var maxErrMsgFormat = $A.localizationService.formatDate(result1, "dd MMM yyyy");
        component.set('v.maxDateErrmsg',maxErrMsgFormat);
        component.set('v.minDate',today);
        component.set('v.maxDate',maxDate);
        var rows = component.get('v.VehicleList');
        var rowid = event.currentTarget.getAttribute("data-value");
        component.set("v.selectedBkngRow",rows[rowid]);
       
       console.log(rows[rowid])
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
            if(rows[rowid].Payment_Status__c=='Captured' || rows[rowid].Payment_Status__c=='Payment Success'){
                console.log(rows[rowid].Booking_Date__c)
                var bookingDate  = new Date(rows[rowid].Booking_Date__c);
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
                    if(!isReschedule && diffDays<$A.get("$Label.c.ETI_Full_Amount_Refund_Days") ){
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
                               // refundPercentage=each.Refund_Percentage__c;
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
                            //refundPercentage=each.Refund_Percentage__c;
                        } else {
                            isRescheduleCancel=true;
                            return false;  
                        }

                        /*if (!confirm(msg)) {
                            console.log('No');
                            return false;
                        }else {
                           refundPercentage=each.Refund_Percentage__c;
                        }*/
                    }
               });
            }else {
                var r = confirm(component.get("v.Booking_wont_Reschedule_Message"));//Your Booking wont be Reschedule, Your booking is going to cancel. You have to create New Booking.
                if (r == true) {
                    
                } else {
                    isRescheduleCancel=true;
                    return false;  
                }
                /*if (!confirm(msg)) {
                    console.log('No');
                    return false;
                } */
            }
        }catch(err){
            alert(err.message);
        }
        if(!isRescheduleCancel){
            var item=event.currentTarget.getAttribute("data-value");
            console.log('item>> '+item);
            console.log('rows[item].Id>> '+rows[item].Id);
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
                "bookingid": rows[item].Id,
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
        var bookingDate  = new Date(rows[rowid].Booking_Date__c);
        var currentDat = new Date();
        var rescheduleMtd;
        //console.log(bookingDate);
        //console.log(currentDat);
        var diffval = currentDat - bookingDate;
        const diffTime = Math.abs(currentDat - bookingDate);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
        console.log('@@@@@  ' + diffDays);
        var refundPercentage;
        let isRescheduleCancel=false;
        let isReschedule=false;
        if(rows[rowid].Payment_Status__c=='Captured' || rows[rowid].Payment_Status__c=='Payment Success'){
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
                            //refundPercentage=each.Refund_Percentage__c;
                        } else {
                            isRescheduleCancel=true;
                            return false;  
                        }
                        /*if (!confirm(msg)) {
                           console.log('No');
                           return false;
                        } else {
                        }*/
                    }
                }else if(!isReschedule && each.Max_Time_Limit__c >= $A.get("$Label.c.ETI_Full_Amount_Refund_Days")){
                    isReschedule=true;
                    var r = confirm(component.get("v.Refunded_full_Amount_Message"));
                    if (r == true) {
                        rescheduleMtd=each;
                       //refundPercentage=each.Refund_Percentage__c;
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
            console.log('rescheduleMtd: '+rescheduleMtd);
            var rows = component.get('v.VehicleList');
            component.set('v.VehicleList', rows);
            console.log(JSON.stringify(rows)); 
            console.log('bookingId@@@'+rows[item].Id);
            console.log(rows[item]);            
            component.set('v.IsSpinner', true);
            var metaDataId;
            if(rescheduleMtd!=undefined){
                metaDataId=rescheduleMtd.Id;
        	}
            console.log('metaDataId@@@@'+metaDataId);
            console.log('metaDataId: '+metaDataId);
            var action = component.get("c.getBookingDataForUpdate");
            action.setParams({
                "bookingId": rows[item].Id, //item.Id
                "metaDataId": metaDataId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                if (component.isValid() && state === "SUCCESS") {
                    $A.get('e.force:refreshView').fire();
                    console.log('response>> ', JSON.stringify(response.getReturnValue()));
                    if(response.getReturnValue() == null){
                        var msg= component.get("v.Unexpected_Error_Message");
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
                    errorMsg = response.getError()[0];
                    console.log(errorMsg);
                    var msg=component.get("v.Unexpected_Error_Message");
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
    },
    /*
     * this function will build table data
     * based on current page selection
     * */
    buildData : function(component, helper) {
        var wrpData = [];
        var vehlist=[];   
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var vehicleWrp = component.get("v.allBookingData");
        var vehicleData = component.get("v.VehicleList");
        console.log('vehicleWrp '+JSON.stringify(vehicleWrp));
        console.log('vehicleData>> '+JSON.stringify(vehicleData));
        var totalRecords = component.get("v.totalRecords");
        console.log('vehicleWrp length>> '+vehicleWrp.length);
        console.log('pageNumber>> '+pageNumber);
        console.log('pageSize>> '+pageSize);
        var x = (pageNumber-1)*pageSize;
        var end=(pageNumber)*pageSize;
		console.log('x>> '+x);
        console.log('end>> '+end);
        component.set("v.recordStart", x+1);
        //creating data-table data
        console.log('end>> ',end);
        for(; x<end; x++){
            if(vehicleWrp[x]){
            	wrpData.push(vehicleWrp[x]);
            }
        }
        console.log('vehlist '+JSON.stringify(vehlist));
        console.log('wrpData>> '+JSON.stringify(wrpData));
        component.set("v.VehicleList", wrpData);
        //component.set("v.VehicleList", vehlist);
        if(end>totalRecords)
        	component.set("v.recordEnd", totalRecords);
        else 
            component.set("v.recordEnd", end);
        this.generatePageList(component, pageNumber);
    },
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        console.log('pageNumber22>> ',pageNumber);
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        console.log('totalPages>> '+totalPages);
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        console.log('pageList>> '+pageList);
        component.set("v.pageList", pageList);
    },
})