({
    doInit : function(component, event, helper) {
           	
    },
    closeModel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    saveRecord : function(component, event, helper){    
        
        if(component.get("v.comments")){
            component.set("v.showSpinner",true);
            helper.saveRecordHelper(component, event, helper);  
        }else{
            helper.showToastMessage('Error','Error','Comments are required.')
        }
        
       
    },
    
})