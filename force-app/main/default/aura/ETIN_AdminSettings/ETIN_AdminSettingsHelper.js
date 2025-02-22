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
    
    callGetRenewalDetails :function(component, event, helper) {  
               
        var exeAction = component.get("c.getRenewalButton");
        
         helper.serverSideCall(component,exeAction).then(
            function(res) { 
               component.set('v.RenewalBtn', res);
               
                res.forEach(function(item){
                    if(item.Name == 'PopUp_Button'){
                         component.set('v.popUpBtn', item);
                        
                    }
                });
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
   
    
    callGetMasterDocDetails :function(component, event, helper) {  
        
     
        var actions = [
            {
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_record',
                
            },
            {
                'label': 'Delete',
                'iconName': 'utility:delete',
                'name': 'Delete'
            }
        ];
        
        component.set('v.DocMasterColumns', [
          
            {label: 'Emirates', fieldName: 'Emirate__c', type: 'text'},
            {label: 'Document Label', fieldName: 'Label_Name__c', type: 'text'},
            /*{label: 'Dev Name', fieldName: 'Name', type: 'text'},*/
            {label: 'Visibility', fieldName: 'Visibility__c', type: 'boolean'},
            {label: 'Mandatory', fieldName: 'Mandatory__c', type: 'boolean'},
            {label: 'Format', fieldName: 'Formats__c', type: 'text'},
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
               
        var exeAction = component.get("c.getDocMasterCustom");
        
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
    
    callGetClaimDocDetails : function(component, event, helper) {
        
       //console.log('----called---');
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
        
        component.set('v.ClaimDocColumns', [
          
          
            {label: 'Document Label', fieldName: 'Label__c', type: 'text'},
            /*{label: 'Dev Name', fieldName: 'Name', type: 'text'},*/
            {label: 'Visibility', fieldName: 'Visibility__c', type: 'boolean'},
             {label: 'Mandatory', fieldName: 'Mandatory__c', type: 'boolean'},
            {label: 'Format', fieldName: 'Accepted_Format__c', type: 'text'},
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
       var exeAction = component.get("c.getInsuranceClaimDocs");
        
         this.serverSideCall(component,exeAction).then(
            function(res) {
             // console.log('----res--J-'+res);
               component.set('v.ClaimDocdata', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error--claim-'+JSON.stringify(error));
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
    saveMasterDoc :  function(component){
        
      
        var exeAction = component.get("c.saveRecordMasterDocMdt");
        exeAction.setParam("metadataRecord", component.get("v.record"));
        component.set( "v.record", {} );
        let ele = component.find( "recordPopup" );
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
                
            //console.log( response.getReturnValue() );
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
                        "message":'Please check with your system admin!',
                        "mode":"dismissible"
                    });
                    toastReference.fire();
                    
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
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
    
    DeleteMasterDocRec :  function(component, event, helper,row) { 
          
         var exeAction = component.get("c.DeleteRecordMasterDocMdt");
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
                
               // console.log('Error---'+JSON.stringify(error));
                
            }
        );
    
    },
    
    updateMasterDoc :function(component, event, helper){
       
        var exeAction = component.get("c.updateRecordMasterDocMdt");
        exeAction.setParam("Row", component.get("v.record"));
        component.set( "v.record", {} );
        let ele = component.find( "recordPopup" );
        $A.util.addClass( ele, "slds-hide" );
       
       this.serverSideCall(component,exeAction).then(
         function(res) {
               console.log('----res---'+res);
               
             
                var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"success",
                "title":"success",
                "message":'Record has been updated!',
                "mode":"dismissible"
            });
            toastReference.fire();
                 $A.get('e.force:refreshView').fire();
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
                
            }
        );
            
    },
    
   callGetMasterPlansDetails :function(component,event, helper){
       
          var actions = [
            {
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_Plan',
                
            },
            {
                'label': 'Delete',
                'iconName': 'utility:delete',
                'name': 'Delete_plan'
            }
        ];
        
        component.set('v.PlanMasterColumns', [
          
            {label: 'Emirates', fieldName: 'Emirates__c', type: 'text'},
           /* {label: 'Dev Name', fieldName: 'Name', type: 'text'},*/
            {label: 'Company', fieldName: 'Insurance_Company__c', type: 'text'},
             {label: 'Condition', fieldName: 'Condition__c', type: 'text'},
             {label: 'Salary', fieldName: 'Salary__c',type:'currency'}, 
            {label: 'Plan', fieldName: 'Plans__c', type: 'text'},
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
               
        var exeAction = component.get("c.getInsurancePlanMaster");
        
         this.serverSideCall(component,exeAction).then(
            function(res) {
              // console.log('----res-Plans--'+res);
               component.set('v.PlanMasterdata', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
       
        
    },
    saveMasterPlan : function(component){
        
      
      var exeAction = component.get("c.saveRecordMasterPlans");
        exeAction.setParam("data", component.get("v.PlanRecord"));
        component.set( "v.PlanRecord", {} );
        let ele = component.find( "recordPlanPopup" );
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
                
                //$A.get('e.force:refreshView').fire();
                
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
        this.callGetMasterPlansDetails(component);
    },
    DeleteMasterPlanRec : function(component, event, helper,row) {
        
        var exeAction = component.get("c.DeletePlanMasterRec");
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
                 //$A.get('e.force:refreshView').fire();
            }
        ).catch(
            function(error) {
                
               // console.log('Error---'+JSON.stringify(error));
                
            }
        );
        this.callGetMasterPlansDetails(component);

    },
    
    updateMasterPlan : function(component, event, helper){
              
        var exeAction = component.get("c.updatePlanMaster");
        exeAction.setParam("Row", component.get("v.PlanRecord"));
        component.set( "v.PlanRecord", {} );
        let ele = component.find( "recordPlanPopup" );
        $A.util.addClass( ele, "slds-hide" );
       
       this.serverSideCall(component,exeAction).then(
         function(res) {
               console.log('----res---'+res);
               
             
                var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"success",
                "title":"success",
                "message":'Record has been updated!',
                "mode":"dismissible"
            });
            toastReference.fire();
                // $A.get('e.force:refreshView').fire();
            
              
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
                
            }
        );
        try{
                       
            this.callGetMasterPlansDetails(component);
        }catch(e){
            //alert(e.message);
        }
    },
   
    
    saveClaimDoc :function(component,event, helper){
        
              
        var exeAction = component.get("c.SaveClaimDocs");
        exeAction.setParam("Row", component.get("v.ClaimRecord"));
        component.set( "v.ClaimRecord", {} );
        let ele = component.find( "recordClaimPopup" );
        $A.util.addClass( ele, "slds-hide" );
       
        this.serverSideCall(component,exeAction).then(
         function(res) {
             console.log('----res--upClaim-'+res);
                        
            
             
          var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"success",
                "title":"success",
                "message":'Record has been Created!',
                "mode":"dismissible"
            });
            toastReference.fire();  
              //$A.get('e.force:refreshView').fire();
            //  component.set('v.ClaimDocdata', {});
          
            }
        ).catch(
            function(error) {
                
                console.log('Error--ipclaim-'+JSON.stringify(error.message));
                
            }
        );
        
      this.callGetClaimDocDetails(component);                    
     /* exeAction.setCallback( this, function( response ) {
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
                
                //$A.get('e.force:refreshView').fire();
                
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
        */
        
        
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
              //$A.get('e.force:refreshView').fire();
            //  component.set('v.ClaimDocdata', {});
          
            }
        ).catch(
            function(error) {
                
                console.log('Error--ipclaim-'+JSON.stringify(error.message));
                
            }
        ); 
        this.callGetClaimDocDetails(component);
    },
    
    DeleteClaimDoc : function(component, event, helper,row) {
        
        var exeAction = component.get("c.DeleteClaimDocRec");
        exeAction.setParam("Row", row);
        
         this.serverSideCall(component,exeAction).then(
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
                // $A.get('e.force:refreshView').fire();
            }
        ).catch(
            function(error) {
                
               console.log('Error---'+JSON.stringify(error));
                
            }
        );
       
        this.callGetClaimDocDetails(component);
       
       /* try{
             helper.callGetClaimDocDetails(component);
        }catch(e){
            alert(e.message);
        }*/
      
    },
    
    callGetDefaultInsPart : function(component, event, helper) {  
               
        var exeAction = component.get("c.getDefaultInsPartners");
        
         helper.serverSideCall(component,exeAction).then(
            function(res) {
               //console.log('----res--InsPart-'+res);
               component.set('v.InsPartnerList', res);
                component.set('v.selectedSerachFilterValue', res[0].Account_ID__c); 
                component.set('v.selectedSerachFilterValue2', res[1].Account_ID__c); 
                
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
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
        
    },
    
    
})