({
	doInit: function(component, event, helper) {
        helper.doInit(component, event, helper);
        helper.getProfileDetails(component, event, helper);
        helper.getCaseCounts(component, event, helper);
    },
    gotoExplorePage : function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"explore-services" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
    
    gotoLimoServicesPage : function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"home-et-car-services" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
    gotoBusinessPage: function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"my-business" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
     redirectToVehicleInspection : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        //urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"home-inspection" });   // Pass your community URL
        urlEvent.setParams({ "url": "/Business/s/home-inspection" });
        urlEvent.fire(); 
        
    },
    customerCareSelected : function(component, event, helper) {
        var lang = component.get("v.clLang");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"customer-care"+"?lang="+lang});   // Pass your community URL
        urlEvent.fire(); 
        
    },
    specialRequestSelected : function(component, event, helper) {
        var lang = component.get("v.clLang");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"special-requests"});   // Pass your community URL
        urlEvent.fire(); 
        
    },
    myBusinessSelected : function(component, event, helper) {
        //helper.hideActiveClaass(component, event, helper);
        $A.util.removeClass(component.find("home"), 'active1');
        $A.util.addClass(component.find("business"), 'active1');
        var lang = component.get("v.clLang");
        var urlEvent = $A.get("e.force:navigateToURL");
        console.log("urlEvent***"+JSON.stringify(urlEvent));
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"my-business"+"?lang="+lang});   // Pass your community URL
        urlEvent.fire(); 
        
    }
})