({
	serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                   console.log('State>>>'+state);
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       console.log('server Error--'+response.getError());
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
    getEmailConfigDetails : function(component, event, helper) { 
        
        
          var actions = [
            {
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_Email',
                
            }
        ];
        
        component.set('v.EmailMasterColumns', [
                      
            {label: 'Name', fieldName: 'Label__c', type: 'text'},
            {label: 'Email', fieldName: 'Email__c', type: 'text'},
                   
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
               
         var exeAction = component.get("c.getEmailConfigData");
       
         helper.serverSideCall(component,exeAction).then(
            function(res) {
             
                 
     
              component.set("v.emailConfigList", res);
               // console.log('---'+JSON.stringify(res));
           /* var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"success",
                "title":"success",
                "message":'Record has been deleted!',
                "mode":"dismissible"
            });
            toastReference.fire();
                 $A.get('e.force:refreshView').fire(); */
            }
        ).catch(
            function(error) {
                
               console.log('Error---'+JSON.stringify(error.message));
                
            });
    
    },
    
    updateEmailConfig : function(component, event, helper){
   
       var exeAction = component.get("c.updateEmailConfigData");
        exeAction.setParam("Row", component.get("v.emailRecord"));
        component.set( "v.emailRecord", {} );
        let ele = component.find( "recordEmailPopup" );
        $A.util.addClass( ele, "slds-hide" );
       
        
     this.serverSideCall(component,exeAction).then(
         function(res) {
            // console.log('----res--email-'+res);
                        
          //helper.getEmailConfigDetails(component, event, helper);
             
         var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"success",
                "title":"success",
                "message":'Record has been updated!',
                "mode":"dismissible"
            });
            toastReference.fire(); 
             
             //$A.get('e.force:refreshView').fire(); 
           
          
            }
        ).catch(
            function(error) {
                
                console.log('Error--ipclaim-'+JSON.stringify(error.message));
                
            }
        ); 

    }
})