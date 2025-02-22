({
    doInit : function(component, event, helper) {
        var url_string = window.location.href; 
        var url = new URL(url_string);
        console.log('url***'+url);
        var requestId = url.searchParams.get("recordId");
        component.set("v.requestId",requestId);
        var noupdatesImage = $A.get('$Resource.ETST_No_Updates');
        component.set("v.noupdatesImage", noupdatesImage)
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__body');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__body');
        };
        if(requestId!=null && requestId!='' && requestId!=undefined)
        helper.doInit(component, event, helper);
    }
})