({
	doInit : function(component, event, helper) {
		
        helper.getEmailConfigDetails(component, event, helper);
      
	},
    
   handleEmailRowActions : function(component, event, helper){
         var action = event.getParam('action');
        var row = event.getParam('row');
         switch (action.name) {
            case 'edit_Email':
               
                component.set( "v.emailRecord", row );
                let ele = component.find( "recordEmailPopup" );
                $A.util.removeClass( ele, "slds-hide" ); 
                
                break;
         }
    },
    
    handleCancelEmail :function(component, event, helper){
    
     let ele = component.find( "recordEmailPopup" );
        $A.util.addClass( ele, "slds-hide" );
    },
    
    handleUpdateEmail : function(component, event, helper){
        
        helper.updateEmailConfig(component);
    }
})