({
    doinit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper);
        var visisbility = component.get("v.placeOfVisibility");
        console.log('visisbility--'+JSON.stringify(visisbility));
        var action = component.get("c.getTermsandConditions");
        action.setParams({
            Visisbility:visisbility
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state--'+state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('termsConditions--'+JSON.stringify(result));
                component.set("v.termsConditions",result);
            }
        });
        $A.enqueueAction(action);
    },
    openModel: function(component, event, helper) {
        var isCheck = component.get("v.isCheckbox");
        if(isCheck==true){
            component.set("v.isOpen", true);   
        }
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
        component.find("checkboxField").set("v.checked", false);
    },
    
    likenClose: function(component, event, helper) {
        component.set("v.isOpen", false);
        component.find("checkboxField").set("v.checked", true);       
    },
    
    doCheck: function(component, event){
        var checkbox = component.get("v.isCheckbox");
        console.log('checkbox***'+checkbox);
        return checkbox;
    } 
})