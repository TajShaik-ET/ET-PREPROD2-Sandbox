({
	doInit : function(component, event, helper) {
		
         helper.GetClaimMasterDocDetails(component, event, helper);
         helper.getEmailConfigDetails(component, event, helper);
        helper.callGetDefaultInsPart(component, event, helper);
        helper.getPartnerList(component, event, helper);
     
      
	},
    
    newClaimDoc : function(component, event, helper){
        
         component.set( "v.ClaimRecord", {} );
        let ele = component.find( "recordClaimPopup" );
        $A.util.removeClass( ele, "slds-hide" );
        
    },
     handleCancelNewClaim : function(component, event, helper){
        
         let ele = component.find( "recordClaimPopup" );
        $A.util.addClass( ele, "slds-hide" );
        
    },
    stopSpecialChar : function(component,event,helper){
        
        if (event.key.match(/[a-zA-Z0-9- ]/g) ||event.key =='Backspace'){
            
            
        } else {
            event.preventDefault();
            
        }
    },
    stopSpecialChar1 : function(component,event,helper){
        
        if (event.key.match(/[a-zA-Z0-9-., ]/g) ||event.key =='Backspace'){
            
            
        } else {
            event.preventDefault();
            
        }
    },
     handleSaveClaim :function(component, event, helper){
        
      let record = component.get( "v.ClaimRecord" );
       console.log(record.Label__c);
        if(!record.Label__c.trim()){
            
             helper.errorMsgHandler(component,event, helper,'Document Label');
            
        }else if(!record.Accepted_Format__c.trim()){
            
           helper.errorMsgHandler(component,event, helper,'accepted Format');
           
        }else {
            
             helper.saveClaimDoc(component);
        }        
    },
    handleRowAction :function(component, event, helper){
        
         var action = event.getParam('action');
        var row = event.getParam('row');
        
        
       switch (action.name) {
            case 'edit_claimDoc':
               
                component.set( "v.EditClaimRecord", true );
                component.set( "v.ClaimRecord", row );
                let ele = component.find( "recordClaimPopup" );
                $A.util.removeClass( ele, "slds-hide" ); 
                
                break;
               
            case 'Delete_claimDoc':
              
                helper.DeleteClaimDoc(component, event, helper, row);
                break;
        }
    },
    handleEditClaim :function(component, event, helper){
        
      let record = component.get( "v.ClaimRecord" );
        
        if( record.Label__c == undefined || record.Label__c=='' ){
            
             helper.errorMsgHandler(component,event, helper,'Document Label');
            
        }else if( record.Accepted_Format__c == undefined || record.Accepted_Format__c == '' ){
            
           helper.errorMsgHandler(component,event, helper,'Document Format');
           
        }else {
            
             helper.updateClaimDoc(component);
        }        

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
    },
    
    handleEditInsPartner : function(component, event, helper) {
        
        component.set("v.InsPartnerBtnVisiblilty", true);
        component.set("v.FieldVisibility", false);
        
    },
      handleCancelInsPartner :function(component, event, helper) {
        
        component.set("v.InsPartnerBtnVisiblilty", false);
        component.set("v.FieldVisibility", true);
        //$A.get('e.force:refreshView').fire();
        
    },
     handleSaveInsPartner : function(component, event, helper) {
        
        component.set("v.InsPartnerBtnVisiblilty", false);
        component.set("v.FieldVisibility", true);
       
         var updateList = component.get("v.InsPartnerList");         
         updateList[0].Account_ID__c = component.get("v.selectedSerachFilterValue");
         
        var exeAction = component.get("c.updateInsPartnerDefault");
        exeAction.setParams({ 
            "newValue":updateList
            
        });
          exeAction.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            
            if (state === "SUCCESS") {  
                
                 helper.callGetDefaultInsPart(component, event, helper);
             
                var result=response.getReturnValue();
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Success",
                    "title":"success",
                    "message":'Your data is updated successfully',
                    "mode":"dismissible"
                });
                toastReference.fire();
                //$A.get('e.force:refreshView').fire(); 
            }
            else if (state === "ERROR") {
             
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":'Please check with System admin'+errors[0].message,
                            "mode":"sticky"
                        });
                        toastReference.fire();
                    }
                } else {
                    console.log("Unknown error");
                     component.set("v.ShowModule",false);
                    //alert('Unknown');
                }
            }
        }); 
        
        $A.enqueueAction(exeAction);  
         
      
    }
    
})