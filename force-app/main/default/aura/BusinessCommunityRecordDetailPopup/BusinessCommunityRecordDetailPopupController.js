({
    doInit: function (component, event, helper) {
        debugger;
        helper.setCommunityLanguage(component, event, helper); 
        //helper.getcaseCommentsbyUser(component, event,helper);
       
    }, 
    
    closeModel: function(component, event, helper) {  
        component.set("v.showIFrame", false);
    },
})