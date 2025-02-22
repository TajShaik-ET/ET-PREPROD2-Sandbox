({
    redirectCustomerPortal : function(component, event, helper) {
       /* var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.oneETUrl")+"/customer" });   // Pass your community URL
        urlEvent.fire();*/ 
       window.open($A.get("$Label.c.oneETUrl")+"/customer/s",'_top'); 
    },
    redirectToBusinessPortal : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.oneETUrl")+"/Business/s" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
    redirectToEmpPortal : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.oneETUrl")+"/Employee" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
})