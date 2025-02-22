({
    
    doInit: function(component, event, helper)  {
     helper.setCommunityLanguage(component, event, helper);      
    },
    cancelSave: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/etst-home-page?lang='+component.get("v.clLang")
        });
        urlEvent.fire();
    },
})