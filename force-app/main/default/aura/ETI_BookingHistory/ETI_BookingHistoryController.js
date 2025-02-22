({
    doInit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        var today1 = new Date();
        today1.setDate(today1.getDate()-1);
        var today = $A.localizationService.formatDate(today1, "YYYY-MM-DD");
		component.set('v.maxDate',today);
        var endday = component.get("v.endDate");
        if(endday > today){
            return false;
        }
        if(component.get("v.startDate") > component.get("v.endDate"))
        	alert(component.get("v.Start_Date_less_than_End_Date"));
        else 
        	helper.doInit(component, event);
    },
    
    getBookingHistory : function(component, event, helper) {
        var vehId=component.get("v.vehId");
        var hasError = false;
        var today = $A.localizationService.formatDate(new Date(), "DD-MM-YYYY");
        var endDate = $A.localizationService.formatDate(component.get("v.endDate"), "DD-MM-YYYY");
        if(component.get("v.endDate") == null ){
            component.find('EndDateField').set("v.errors", [{message:component.get("v.Field_is_required")}]);
            hasError = true;
        }else if(endDate > today && (vehId == null || vehId == undefined)){
            var msg  = 'Value must be '+today+' or earlier';
            component.find('EndDateField').set("v.errors", [{message:msg}]);
            hasError = true;
        }else{
            component.find('EndDateField').set("v.errors", null);
        }
        
        if(component.get("v.startDate") == null ){
            component.find('StartDateField').set("v.errors", [{message:component.get("v.Field_is_required")}]);
            hasError = true;
        }else if(component.get("v.startDate") > component.get("v.endDate")){
            component.find('StartDateField').set("v.errors", [{message:component.get("v.Start_Date_less_than_End_Date")}]);
            hasError = true;
        }
        else {
            component.find('StartDateField').set("v.errors", null);
        }
        if(!hasError){
        	helper.doInit(component, event);
        }
    },    
    
    cancelSave: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        	urlEvent.setParams({
            	"url": '/eti-homepage?lang='+component.get("v.clLang")                           
        	});
        urlEvent.fire();
     },
    handleRowAction: function (component, event, helper) {
       /* var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'show_details':
                //alert('Showing Details: ' + JSON.stringify(row));
                break;
            case 'delete':
                 alert('Delete action');
                 helper.deleteVehicle(component, event, helper,row);
                break;
        }*/
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
     cancelSave1: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/eti-homepage?lang='+component.get("v.clLang")                           
        });
        urlEvent.fire();
    },
       openInvoicePdf: function(Component,event,helper){
        var value =  event.currentTarget.getAttribute("data-value");
        console.log(value);
        window.open('/apex/ETI_B2BInvoice?Id='+value, '_blank');
    },
    
})