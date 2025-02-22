({
	 serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                   //console.log(state);
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
    
    getRenewInsRecds : function(component, event, helper) {
        
         component.set('v.RecColumns', [
          
             {label: 'Ref Number', fieldName: 'link2', type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
             {label: 'Empolyee Id', fieldName: 'Employee_ID__c', type: 'text'},
             {label: 'Member', fieldName: 'Member_Name__c',type: 'text'},
             {label: 'Plan', fieldName: 'Plan__c',type: 'text'},
             {label: 'Relation', fieldName: 'Relation__c',type: 'text'},
             {label: 'Request Status', fieldName: 'Status__c',type: 'text'},
             {label: 'Renewal Notes', fieldName: 'Comments__c',type: 'text'},
             {label: 'Owner', fieldName: 'owner',type: 'text'},
             {label: 'Created By', fieldName: 'creator',type: 'text'}
        ]);
        
        var exeAction = component.get("c.getInsuranceDetails");
       
        this.serverSideCall(component,exeAction).then(
            function(res) {
             
              var records =res;
             records.forEach(function(record){ 
             
               record.link2 = '/'+record.Id;                       
               record.owner = record.Owner.Name;
               record.creator = record.CreatedBy.Name;
               
             }); 
             
             //console.log("------res----"+JSON.stringify(res));
                
                component.set('v.InsRecDetails', res);
                
                var truevalues = res.filter(function(element) {
                    return (element.Status__c == 'New' || element.Status__c=='Pending with Zone Coordinator' );
                });
                component.set('v.InsZOneRecords', truevalues);
                
                var hrValues = res.filter(function(element) {
                    return (element.Status__c == 'Pending with HR Manager');
                });
                component.set('v.InsHRRecords', hrValues);
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error.message));
            }
        );
        
        
        
    },
    
    submitToZone : function(component, event, helper) {
      component.set("v.showSpinner",true);
        console.log(component.get("v.selectedRowIdList"))
         var exeAction = component.get("c.submitToZoneHRManager");
       exeAction.setParams({
            "recIDs":component.get("v.selectedRowIdList")
           
        });
       
        this.serverSideCall(component,exeAction).then(
            function(res) {
             
                component.set("v.showSpinner",false);       
           // console.log("------res----"+JSON.stringify(res));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "success",
                    "title" : "Success",
                    "message" : 'Your request has been submit to Zone HR Manager',
                    "mode" : "dismissible"
                });
                toastReference.fire(); 
                
                $A.get('e.force:refreshView').fire();    
               
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
                var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "error",
                        "title" : "error",
                        "message" : 'Your request is not submitted,Please check with system administrator',
                        "mode" : "dismissible"
                    });
                    toastReference.fire();
            }
        );
    },
    
    getLoggedUserDetails : function(component, event, helper) {
        var exeAction = component.get("c.fetchUser");
        
         this.serverSideCall(component,exeAction).then(
            function(res) {
     
                if(res.Profile.Name == $A.get("$Label.c.INS_ZoneCordProfileName")){
                    
                     component.set('v.showSubmitBtn', true); 
                }
                console.log(res)
                component.set('v.userInfo', res);   
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
        
    },
    submitToInsAdmin :function(component, event, helper) {
        
        var exeAction = component.get("c.submitToInsuranceAdmin");
        exeAction.setParams({
            "recList":component.get("v.selectedRowList")
            
        });
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                //component.set("v.showSpinner",false);       
                // console.log("------res----"+JSON.stringify(res));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "success",
                    "title" : "Success",
                    "message" : 'Your request has been submit to Insurance Admin',
                    "mode" : "dismissible"
                });
                toastReference.fire(); 
                
                $A.get('e.force:refreshView').fire();    
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "error",
                    "title" : "error",
                    "message" : 'Your request is not submitted,Please check with system administrator',
                    "mode" : "dismissible"
                });
                toastReference.fire();
            }
        );
        
        
    },
    getInsAdminRecds : function(component, event, helper) {
        
         component.set('v.RecAdminColumns', [
          
            {label: 'Ref Number', fieldName: 'link2', type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
             {label: 'Empolyee Id', fieldName: 'Employee_ID__c', type: 'text'},
             {label: 'Member', fieldName: 'Member_Name__c',type: 'text'},
             {label: 'Plan', fieldName: 'Plan__c',type: 'text'},
             {label: 'Relation', fieldName: 'Relation__c',type: 'text'},
             {label: 'Request Status', fieldName: 'Status__c',type: 'text'},
             {label: 'Renewal Notes', fieldName: 'Comments__c',type: 'text'},
             //{label: 'Owner', fieldName: 'owner',type: 'text'},
             {label: 'Created By', fieldName: 'creator',type: 'text'}
        ]);
        
        var exeAction = component.get("c.getInsuranceAdminDetails");
       
        this.serverSideCall(component,exeAction).then(
            function(res) {
             
              var records =res;
             records.forEach(function(record){ 
             
                 record.link2 = '/'+record.Id; 
                 record.owner = record.Owner.Name;
                 record.creator = record.CreatedBy.Name;
               
             }); 
             
             //console.log("------res----"+JSON.stringify(res));
                
                component.set('v.InsAdminRecDetails', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    submitToZoneCoordinator : function(component, event, helper) {
        
         var exeAction = component.get("c.submitToZoneCoord");
        exeAction.setParams({
            "recList":component.get("v.selectedRowList")
            
        });
         component.set("v.showSpinner",true);   
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                component.set("v.showSpinner",false);       
                //console.log("------res----"+JSON.stringify(res));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "success",
                    "title" : "Success",
                    "message" : 'Your reject request has been submit to Zone Coordinator',
                    "mode" : "dismissible"
                });
                toastReference.fire(); 
                
                $A.get('e.force:refreshView').fire();    
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "error",
                    "title" : "error",
                    "message" : 'Your request is not submitted,Please check with system administrator',
                    "mode" : "dismissible"
                });
                toastReference.fire();
            }
        );
        
        
    },
    
    ApprovedByInsAdmin : function(component, event, helper) {
        
         var exeAction = component.get("c.ApprovedByAdminMethod");
        exeAction.setParams({
            "recList":component.get("v.selectedRowList")
            
        });
         component.set("v.showSpinner",true);   
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                component.set("v.showSpinner",false);       
                //console.log("------res----"+JSON.stringify(res));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "success",
                    "title" : "Success",
                    "message" : 'Renewal request has been Approved',
                    "mode" : "dismissible"
                });
                toastReference.fire(); 
                
                $A.get('e.force:refreshView').fire();    
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "error",
                    "title" : "error",
                    "message" : 'Your request is not submitted,Please check with system administrator',
                    "mode" : "dismissible"
                });
                toastReference.fire();
            }
        );
    },
    
    RejectedByInsAdmin :function(component, event, helper) {
        
        console.log("------enter Reject Helper----");
        
         var exeAction = component.get("c.RejectedByAdminMethod");
        exeAction.setParams({
            "recList":component.get("v.selectedRowList")
            
        });
         component.set("v.showSpinner",true);   
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                component.set("v.showSpinner",false);       
                console.log("------res----"+JSON.stringify(res));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "success",
                    "title" : "Success",
                    "message" : 'Renewal request has been submit to HR Manager',
                    "mode" : "dismissible"
                });
                toastReference.fire(); 
                
                $A.get('e.force:refreshView').fire();    
                
            }
        ).catch(
            function(error) {
                 component.set("v.showSpinner",false); 
                console.log('Error---'+JSON.stringify(error.message));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "error",
                    "title" : "error",
                    "message" : 'Your request is not submitted,Please check with system administrator',
                    "mode" : "dismissible"
                });
                toastReference.fire();
            }
        );
    },
    ErrorMsg : function(component, event, helper) {
        
         var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "warning",
                    "title" : "warning",
                    "message" : 'Please select atleast one record !',
                    "mode" : "dismissible"
                });
                toastReference.fire(); 
        
    }
        
})