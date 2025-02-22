({
    doInit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.minDate',today);
        component.set('v.minDateForError', helper.changeDateFormat(today));
        if(screen.width<=480)
            component.set("v.isMobileView", true);
        else 
            component.set("v.isMobileView", false);
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
        helper.fetchVehicleHelper(component, event, helper) ;
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
            //alert('vijayam');
            helper.showSpinner(component);
            helper.fetchVehicleHelper(component, event, helper) ;
            helper.hideSpinner(component); 
        }            
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
        helper.rescheduleBooking(component, event, helper);
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
        window.open('/apex/ETI_Invoice?Id='+value, '_blank');
    },
    sendInvoicePdf: function (component, event, helper) {
        var value =  event.currentTarget.getAttribute("data-value");
        console.log('value>> '+value);
        component.set('v.IsSpinner', true);
        var action = component.get("c.sendInvoiceNotification");
        action.setParams({
            requestId: value
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            console.log('state111>> '+state);
            if(state === "SUCCESS"){
                toastEvent.setParams({ 
                        "title": component.get("v.Success"),
                    	"type":"Success",
                        "message":component.get("v.Invoice_Sent_to_Email")
                    });
            }else{
                toastEvent.setParams({ 
                    "title": component.get("v.Error"),
                    "type":"error",
                    "message":component.get("v.Unexpected_Error_Message")
                });
            }
            toastEvent.fire();
            component.set('v.IsSpinner', false);
        });
        $A.enqueueAction(action);
	},
    handleonchangestartdate :function(component,event,helper){
        component.set('v.startDateForError', helper.changeDateFormat(component.get('v.startDate')));
    },
    payByCard :function(component, event, helper){
        var rowid = event.currentTarget.getAttribute("data-value");
        console.log(rowid);
        var rows = component.get('v.VehicleList');
        console.log('####  ', rows[rowid].booking.Service_Request__c)
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
           "url": "/eti-vehiclepayment\?recordId=" + rows[rowid].booking.Service_Request__c +"&button=card&src=et"+"&lang="+component.get("v.clLang")
        });
        urlEvent.fire();
    },
    cancelSave: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/eti-homepage?lang='+component.get("v.clLang")                          
        });
        urlEvent.fire();
    },
})