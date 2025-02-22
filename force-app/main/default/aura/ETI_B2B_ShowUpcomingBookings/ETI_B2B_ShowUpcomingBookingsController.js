({
    doInit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.minDate',today);
        component.set('v.minDateForError', helper.changeDateFormat(today));
        var actions = [
            { label: 'Cancel Booking', name: 'cancel' },
            { label: 'Reschedule Booking', name: 'reschedule' }
        ];
        component.set('v.VehicleColumns', [
            {label: 'Chassis No', fieldName: 'Chassis_No__c', type: 'text'},
            {label: 'Booking Date', fieldName: 'Booking_Date__c', type: 'text'},
            {label: 'Service Type', fieldName: 'Service_Type__c', type: 'text'},
            {label: 'Location', fieldName: 'Location__c', type: 'text'}, 
            {label: 'Branch', fieldName: 'Branch__c', type: 'text'},
            {label: 'Booking Status', fieldName: 'Booking_Status__c', type: 'text'},
            { type: 'action', typeAttributes: { rowActions: actions }}
            
        ]);
        helper.showSpinner(component);
        helper.accountDetails(component, event, helper) ;
        helper.fetchRescheduleCancelMetaData(component, event, helper) ;
        helper.hideSpinner(component);
    },
    getVehicleDetails : function (component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "DD-MM-YYYY");
        var endDate = $A.localizationService.formatDate(component.get("v.endDate"), "DD-MM-YYYY");
        var startDate = $A.localizationService.formatDate(component.get("v.startDate"), "DD-MM-YYYY");
        var hasError = false;
        if(component.get("v.startDate") == null || component.get("v.startDate") == '' ){
            component.find('StartDateField').set("v.errors", [{message:component.get("v.Field_is_required")}]);
            hasError = true;
        }else if(startDate < today ){
            component.find('StartDateField').set("v.errors", [{message:"Value must be "+today+" or later"}]);
            hasError = true;
        }else if(component.get("v.startDate") > component.get("v.endDate")){
            component.find('StartDateField').set("v.errors", [{message:component.get("v.Start_Date_less_than_End_Date")}]);
            hasError = true;
        }else{
             component.find('StartDateField').set("v.errors", null);
        }
        if(component.get("v.endDate") == null ){
            component.find('EndDateField').set("v.errors", [{message:component.get("v.Field_is_required")}]);
            hasError = true;
        } else{
            component.find('EndDateField').set("v.errors", null);
        }
        if(!hasError){
            helper.showSpinner(component);
            helper.fetchBookingsHelper(component, event, helper,component.get("v.selectedserviceReq")) ;
            helper.hideSpinner(component); 
        }            
    },
    fetchBookingDetails: function (component, event, helper) {
        var reqId = event.currentTarget.getAttribute("data-value");
        component.set("v.selectedserviceReq", reqId);
        component.set("v.startDate", null);
        component.set("v.endDate", null);
        helper.fetchBookingsHelper(component, event, helper,reqId) ;
    },
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'cancel':
                helper.cancelBooking(component, event, helper,row);
                break;
            case 'reschedule':
                helper.rescheduleBooking(component, event, helper,row);
                break;
        }
    },
    rescheduleBooking1:function(component, event, helper){
       if(component.get("v.emirate")=='Sharjah'){
            
            helper.rescheduleBookingSpea(component, event, helper);
            
        }else{
           helper.rescheduleBooking(component, event, helper);
        }
        // helper.rescheduleBooking(component, event, helper);
    },
    cancelBooking1:function(component, event, helper){
        helper.cancelBooking(component, event, helper);
    },
    getSelectedName: function (component, event) {
        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
        for ( var i = 0; i < selectedRows.length; i++ ) {
            setRows.push(selectedRows[i]); 
        }
        var searchCompleteEvent = component.getEvent("DataEvent"); 
        searchCompleteEvent.setParams({
            selectedRecords : setRows 
        }); 
        searchCompleteEvent.fire(); 
    },
    closeRequestForService: function(component, event, helper) {
        component.set("v.reSchduleBooking", false);
    },
    createBooking : function(component, event, helper) {
        var bkng = component.get("v.booking");
        var action1 = component.get("c.saveBooking");
        action1.setParams({
            "lstBooking": bkng
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state--'+state);            
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.isOpenRequestForService", false);
                $A.get('e.force:refreshView').fire();    
            }
        });
        $A.enqueueAction(action1);       
    },
    openInvoicePdf: function(Component,event,helper){
        var value =  event.currentTarget.getAttribute("data-value");
        console.log(value);
        window.open('/apex/ETI_B2BInvoice?Id='+value, '_blank');
    },
    handleonchangestartdate :function(component,event,helper){
        component.set('v.startDateForError', helper.changeDateFormat(component.get('v.startDate')));
    },
    payByCard :function(component, event, helper){
        var rowid = event.currentTarget.getAttribute("data-value");
        console.log(rowid);
        var src='et';
        if(component.get("v.emirate")=='Sharjah')
            src='spea';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/b2bvehiclepaymentinspection\?recordId=" + rowid +"&button=card&src="+src+"&lang="+component.get("v.clLang")
        });
        urlEvent.fire();
    },
    cancelSave: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/Business/s/home-inspection?lang='+component.get("v.clLang")                            
        });
        urlEvent.fire();
    },
    closeModel: function (component, event, helper) {
        component.set("v.selectedserviceReq", null);
        component.set("v.showBookings", false);
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
    fetchAvailableSlots :function(component, event, helper) { 
      
        var action = component.get("c.getSPEASlotDetialsReschedule");
        action.setParams({
            bkngDate : component.get("v.rescheduleBkngDate")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            
            if(state === "SUCCESS"){
               
                var result = response.getReturnValue();               
                
                if(result){                    
                    component.set("v.availableSlots",result);                 
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Info!",
                        "message":component.get("v.Slots_Availability")
                    });
                    toastEvent.fire();
                }
            }else{
                alert('error')
            }
        });
         $A.enqueueAction(action);
    },
     closeSpeaRes :function(component, event, helper){
        component.set("v.IsReSchduleBookingSpea",false);
    },
    
    saveRescheduleInfo : function(component, event, helper){
      
        let bkngNewDate = component.get("v.rescheduleBkngDate");
        let rescheduleSlot = component.get("v.rescheduleSlot");
        
            if(!bkngNewDate){
                 component.find('bookingNewDate').reportValidity();
            }else if(!rescheduleSlot){
                 component.find('rescheduleSlot').showHelpMessageIfInvalid();   
            }else{
                component.set("v.showSpinnerReschedule",true);
                let bkngRow = component.get("v.selectedBkngRow");
                bkngRow.Booking_Date__c=bkngNewDate;
                bkngRow.Preferred_Time__c=rescheduleSlot;
                
                var action = component.get('c.updateSpeaBookingDetails');                
                action.setParams({
                   bkng:bkngRow
                });
               
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (state === "SUCCESS") {   
                        helper.fetchBookingsHelper(component, event, helper, component.get("v.selectedserviceReq")) ;
                           
                        component.set("v.showSpinnerReschedule",false);
                        component.set("v.IsReSchduleBookingSpea",false);                      
                        component.set("v.rescheduleBkngDate",null);
                        component.set("v.rescheduleSlot",null);
                       
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type":"Success",
                            "message":"Your booking has been rescheduled sucessfully."
                        });
                        toastEvent.fire();
                    }
                    else if (state === "ERROR") {
                        component.set("v.showSpinnerReschedule",false);
                        var errors = response.getError();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"Error",
                            "message":"Unable to reschedule this booking, please check with admin."
                        });
                        toastEvent.fire();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                                
                            }
                        } else {
                            console.log("Unknown error");
                            
                        }
                    }
                }); 
                
                $A.enqueueAction(action);                
                
            }    
          
    }
})