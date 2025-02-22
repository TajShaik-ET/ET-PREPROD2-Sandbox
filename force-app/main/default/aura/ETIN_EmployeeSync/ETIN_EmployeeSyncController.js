({
	SyncMethod: function(component, event, helper) {
       
        
        if( component.get("v.EmpNumber") != null )
        helper.callServer(component, event, helper);
        else
            helper.showInfo(component, event, helper);
    },
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    }
    
})