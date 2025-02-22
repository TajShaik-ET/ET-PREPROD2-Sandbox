({
	doInit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		component.set('v.maxDate',today);
        helper.showSpinner(component);
        helper.doInit(component, event);
        helper.hideSpinner(component);
    },
    
    getCaseDetails : function(component, event, helper) {
         var hasError = false;
         var today = $A.localizationService.formatDate(new Date(), "DD-MM-YYYY");
         var endDate = $A.localizationService.formatDate(component.get("v.endDate"), "DD-MM-YYYY");
         if(component.get("v.endDate") == null ){
            component.find('EndDateField').set("v.errors", [{message:component.get("v.Field_is_required")}]);
             hasError = true;
        }else if(endDate > today ){
            var msg  = 'Value must be '+today+' or earlier';
            component.find('EndDateField').set("v.errors", [{message:msg}]);
            
            hasError = true;
        } else{
            component.find('EndDateField').set("v.errors", null);
        }
        if(component.get("v.startDate") == null ){
            component.find('StartDateField').set("v.errors", [{message:component.get("v.Field_is_required")}]);
            hasError = true;
            
        }else if(component.get("v.startDate") > component.get("v.endDate")){
            component.find('StartDateField').set("v.errors", [{message:component.get("v.Start_Date_less_than_End_Date")}]);
            hasError = true;
        }else  {
            component.find('StartDateField').set("v.errors", null);
        }
        if(!hasError){
            helper.showSpinner(component);
            helper.doInit(component, event);
            helper.hideSpinner(component); 
        }
    },
    cancelSave: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/Business/s/home-inspection?lang='+component.get("v.clLang")                        
        });
        urlEvent.fire();
    }
    
})