({
    doInit : function(component, event, helper){
        helper.doInit(component, event, helper);
        helper.setCommunityLanguage(component, event, helper);
    },
    homeSelected : function(component, event, helper) {
        helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("home"), 'active1');
        var lang = component.get("v.clLang");
        var urlEvent = $A.get("e.force:navigateToURL");
        console.log("urlEvent***"+JSON.stringify(urlEvent));
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"?lang="+lang});   // Pass your community URL
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
        
    },
    specialRequestSelected : function(component, event, helper) {
        helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("specialReq"), 'active1');
        var lang = component.get("v.clLang");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"special-requests"+"?lang="+lang});   // Pass your community URL
        urlEvent.fire(); 
        
    },
      faqSelected :  function(component, event, helper) {
         helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("faq"), 'active1');
        var lang = component.get("v.clLang");
       
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/Business/s/faq"+"?lang="+lang
        });
        urlEvent.fire(); 
    },
    generalCaseSelected : function(component, event, helper) {
        helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("genReq"), 'active1');
        var lang = component.get("v.clLang");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"moe-general-case"+"?lang="+lang});   // Pass your community URL
        urlEvent.fire(); 
        
    },
    customerCareSelected : function(component, event, helper) {
        helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("care"), 'active1');
        var lang = component.get("v.clLang");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"customer-care"+"?lang="+lang});   // Pass your community URL
        urlEvent.fire(); 
        
    },
    //new
    specialDashboardSelected : function(component, event, helper) {
        helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("SpecialDashboard"), 'active1');
        var lang = component.get("v.clLang");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"ese-special-request-dashboard"+"?lang="+lang});   // Pass your community URL
        urlEvent.fire(); 
        
    },
    exploreServicesSelected : function(component, event, helper) {
        helper.hideActiveClaass(component, event, helper);
        $A.util.addClass(component.find("explore"), 'active1');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"explore-services" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
    offersSelected : function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"offers-and-promotions" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
    propertySelected : function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"my-accounts" });   // Pass your community URL
        urlEvent.fire(); 
        
    },
    profileSelected : function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({ "url": $A.get("$Label.c.Business_Community_URL")+"my-profile" });   // Pass your community URL
        urlEvent.fire(); 
        
    }
})