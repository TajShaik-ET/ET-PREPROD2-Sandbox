({
    doInit: function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        if(lang=='ar'){
            $A.util.addClass(component.find("ltgButton"), 'btn_table_AR');
            $A.util.removeClass(component.find("ltgButton"), 'btn_table');
            
        }else{
            $A.util.addClass(component.find("ltgButton"), 'btn_table');
            $A.util.removeClass(component.find("ltgButton"), 'btn_table_AR');
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