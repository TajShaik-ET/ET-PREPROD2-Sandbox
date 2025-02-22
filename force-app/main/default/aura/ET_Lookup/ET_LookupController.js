({
    doInit : function(component,event,helper){
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        console.log('lang***'+lang);
        console.log('clSearchSchool***'+component.get('v.clSearchSchool'));
        if(lang=='ar'){
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
            $A.util.addClass(component.find("iconDiv"), 'slds-input-has-icon--left');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__body');
            $A.util.removeClass(component.find("iconDiv"), 'slds-input-has-icon--right');
            component.set("v.lang", 'ar');
        }else{ //if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find("mainDiv"), 'slds-modal__body');
            $A.util.addClass(component.find("iconDiv"), 'slds-input-has-icon--right');
            $A.util.removeClass(component.find("mainDiv"), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find("iconDiv"), 'slds-input-has-icon--left');
            component.set("v.lang", 'en');
        } 
    },
    doCheck: function(component, event){
        var selectedRecord = component.get("v.selectedRecord");
        console.log('selectedRecord***'+selectedRecord);
        return selectedRecord;
    },
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        console.log("forOpen***"+forOpen);
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selection 
    clear :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );   
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        console.log("lookUpTarget***"+lookUpTarget);
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
})