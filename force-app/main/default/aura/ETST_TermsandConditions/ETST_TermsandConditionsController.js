({
    doInit : function(component,event,helper){
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        console.log('clSearchSchool***'+component.get('v.clSearchSchool'));
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__body');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__body');
        } 
        helper.doInit(component, event, helper);
    },
    openModel: function(component, event, helper) {
        //var isCheck = component.get("v.isCheckbox");
        //if(isCheck==true){
            component.set("v.isOpen", true);
        //}
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