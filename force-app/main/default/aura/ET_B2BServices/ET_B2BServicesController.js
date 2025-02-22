({
    doinit : function(component, event, helper) {
        helper.accountDetails(component, event, helper) ;
    },
    redirectSchoolTransport : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"home-school-transport" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
    redirectToVehicleInspection : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"home-inspection" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
    redirectToSpeaInspection : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"home-inspection?isSpea=true" });   // Pass your community URL
        urlEvent.fire(); 
        
    }
})