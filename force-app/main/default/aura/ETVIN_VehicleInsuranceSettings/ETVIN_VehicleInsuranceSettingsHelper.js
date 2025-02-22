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
    
	 GetClaimMasterDocDetails :function(component, event, helper) {  
        
    
       var actions = [
            {
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_claimDoc',
                
            },
            {
                'label': 'Delete',
                'iconName': 'utility:delete',
                'name': 'Delete_claimDoc'
            }
        ];
        
        component.set('v.DocMasterColumns', [
                      
            {label: 'Document Label', fieldName: 'Label__c', type: 'text'},
            {label: 'Format', fieldName: 'Accepted_Format__c', type: 'text'},
            {label: 'Visibility', fieldName: 'Visibility__c', type: 'boolean'},            
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
               
        var exeAction = component.get("c.getDocMasterClaims");
        
         helper.serverSideCall(component,exeAction).then(
            function(res) {
               console.log('----res---'+res);
               component.set('v.DocMasterdata', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        ); 
    },
     saveClaimDoc :function(component){
        
        var exeAction = component.get("c.SaveClaimDocs");
        exeAction.setParam("Row", component.get("v.ClaimRecord"));
        component.set( "v.ClaimRecord", {} );
        let ele = component.find( "recordClaimPopup" );
        $A.util.addClass( ele, "slds-hide" );
       
      exeAction.setCallback( this, function( response ) {
         var state = response.getState();
            if( state === "SUCCESS") {
                
                
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"success",
                    "title":"success",
                    "message":'Your action has been completed!',
                    "mode":"dismissible"
                });
                toastReference.fire();
                
                $A.get('e.force:refreshView').fire();
                
               // console.log( response.getReturnValue() );
            }
            else if (state === "INCOMPLETE") {
                alert('Error in the response');
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":'Please check with your system admin!',
                    "mode":"dismissible"
                });
                toastReference.fire();
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":errors[0].message,
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                        
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                             
                        }
                    } else {
                        //console.log("Unknown error");
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":'Please check with your system admin!',
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                    }
                }
        });
        
        $A.enqueueAction(exeAction); 
        
    },
    
     updateClaimDoc : function(component, event, helper){
    
       var exeAction = component.get("c.updateClaimData");
        exeAction.setParam("Row", component.get("v.ClaimRecord"));
        component.set( "v.ClaimRecord", {} );
        let ele = component.find( "recordClaimPopup" );
        $A.util.addClass( ele, "slds-hide" );
       
        
     this.serverSideCall(component,exeAction).then(
         function(res) {
             console.log('----res--upClaim-'+res);
                        
            // this.callGetClaimDocDetails(component, event, helper);
             
          var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"success",
                "title":"success",
                "message":'Record has been updated!',
                "mode":"dismissible"
            });
            toastReference.fire();  
              $A.get('e.force:refreshView').fire();
            //  component.set('v.ClaimDocdata', {});
          
            }
        ).catch(
            function(error) {
                
                console.log('Error--ipclaim-'+JSON.stringify(error.message));
                
            }
        ); 
    },
     errorMsgHandler : function(component, event, helper, Msg) {
        
        var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Error",
                "title":"Error",
                "message":'Please enter '+Msg,
                "mode":"dismissible"
            });
            toastReference.fire();
    },
    
     DeleteClaimDoc : function(component, event, helper,row) {
       
        var exeAction = component.get("c.DeleteClaimDocRec");
        exeAction.setParam("Row", row);
        
         helper.serverSideCall(component,exeAction).then(
            function(res) {
               //console.log('----res---'+res);
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"success",
                "title":"success",
                "message":'Record has been deleted!',
                "mode":"dismissible"
            });
            toastReference.fire();
                 $A.get('e.force:refreshView').fire();
            }
        ).catch(
            function(error) {
                
               console.log('Error--DelClaim-'+JSON.stringify(error.message));
                
            }
        );
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
                        
         // helper.getEmailConfigDetails(component, event, helper);
             
         var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"success",
                "title":"success",
                "message":'Record has been updated!',
                "mode":"dismissible"
            });
            toastReference.fire(); 
             
            $A.get('e.force:refreshView').fire(); 
             
             //component.set("v.selectedTabId","two");
             try{
                 
             }catch(e){
                 
                 console.log('----'+e.message);
             }
           
          
            }
        ).catch(
            function(error) {
                
                console.log('Error--ipclaim-'+JSON.stringify(error.message));
                
            }
        ); 
        
    },
    
    callGetDefaultInsPart : function(component, event, helper) {  
        
         var action = component.get('c.getDefaultInsPartner');
      
         action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                  
                  component.set('v.InsPartnerList', response.getReturnValue());
                  component.set('v.selectedSerachFilterValue',response.getReturnValue().Account_ID__c);
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
          }); 
        
        $A.enqueueAction(action);  
           
    },
    
    getPartnerList : function(component, event, helper){
        
        
       var exeAction = component.get("c.getPartnerAccList");
       
       this.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log('rec---'+JSON.stringify(res));
                component.set("v.PartnerList",res);
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
    }
    
})