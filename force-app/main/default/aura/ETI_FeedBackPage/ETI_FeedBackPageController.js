({
    doInit: function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        helper.getUserVehicleDetails(component, event, helper);
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__body');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__body');
        } 
        helper.fetchCaseTypes(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isfeebackModal",false);
    },
    handleSaveCase: function(component, event, helper) {
         var allValid =component.find('CaseField').reduce(function (validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
           
            if (allValid) {
            helper.saveCase(component, event, helper);
        }else{
            console.log('enterd else');
        }
    },
   showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    }
})