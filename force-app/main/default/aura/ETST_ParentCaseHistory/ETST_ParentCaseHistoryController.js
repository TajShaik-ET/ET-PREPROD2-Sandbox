({
    doInit : function(component, event, helper) {        
        helper.doInit(component, event, helper);
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
    },
     cancelSave: function(component, event, helper) {
        helper.redirectTo(component, '/etst-home-page?lang='+component.get("v.clLang"));
    },
})