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
        	helper.doInit(component, event, helper);
    },
    getBookingHistory : function(component, event, helper) {
        var hasError = false;
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var endDate = $A.localizationService.formatDate(component.get("v.endDate"), "DD-MM-YYYY");
        console.log('today '+today);
        console.log('endDate '+endDate);
        console.log('endDate11 '+component.get("v.endDate"));
        if(component.get("v.endDate") == null ){
            component.find('EndDateField').set("v.errors", [{message:component.get("v.Field_is_required")}]);
            hasError = true;
        }//else if(endDate > today ){
        else if(component.get("v.endDate") > today ){
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
        }else {
            component.find('StartDateField').set("v.errors", null);
        }
        if(!hasError){
            helper.doInit(component, event, helper);
        }
    },    
    cancelSave: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        	urlEvent.setParams({
            	"url": '/Business/s/home-inspection?lang='+component.get("v.clLang")                            
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
            "url": '/Business/s/home-inspection?lang='+component.get("v.clLang")                           
        });
        urlEvent.fire();
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
      openInvoicePdf: function(Component,event,helper){
        var value =  event.currentTarget.getAttribute("data-value");
        console.log(value);
        window.open('/apex/ETI_B2BInvoice?Id='+value, '_blank');
    },
    
})