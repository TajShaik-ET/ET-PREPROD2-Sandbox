({
    doInit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.maxDate',today);
        helper.doInit(component, event, helper);
    },
    openBookingAndVehicleDetails : function(component, event, helper) {
        try{
            var ServiceId= event.currentTarget.getAttribute('data-id');
            component.set("v.serviceid",ServiceId);  
            helper.getBookingAndVehicle1(component, event, helper);
            component.set("v.isOpen",true);  
            /*var query = location.search.substr(1);
            var result = {};
            query.split("?").forEach(function(part) {
                var item = part.split("=");
                result[item[0]] = decodeURIComponent(item[1]);
            });
            console.log('@@@@@', result);
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/s/showpaymentbooking-page?Loc=" + result.Loc + '&ServiceId=' + event.currentTarget.getAttribute('data-id')
            });
                console.log('########  ', event.currentTarget.getAttribute('data-id'));
            urlEvent.fire();*/
        }
        catch(error){
            alert(error.message);
        }    
    },
    closeModel: function (component, event, helper) {
        component.set("v.isOpen",false);  
    },
    getPaymentHistory : function(component, event, helper) {
        var hasError = false;
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        //var today = $A.localizationService.formatDate(new Date(), "DD-MM-YYYY");
        var endDate = $A.localizationService.formatDate(component.get("v.endDate"), "DD-MM-YYYY");
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
    
     openInvoicePdf: function(Component,event,helper){
        var value =  event.currentTarget.getAttribute("data-value");
        console.log(value);
        window.open('/apex/ETI_B2BInvoice?Id='+value, '_blank');
    },
    
    cancelSave: function(component, event, helper) {
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
})