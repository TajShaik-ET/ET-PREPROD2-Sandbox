({
serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                   // console.log(state);
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
    
    getAllDocs : function(component, event, helper){ 
    var action = component.get("c.getFiles");  
     action.setParams({  
       "recordId":component.get("v.recordId")  
     });      
     action.setCallback(this,function(response){  
       var state = response.getState();  
       if(state=='SUCCESS'){  
         var result = response.getReturnValue();  
         
         component.set("v.files",result);  
       }  
     });  
     $A.enqueueAction(action); 
        
    },
    
    UpdateDocument : function(component,event,Id) {  
     var action = component.get("c.UpdateFiles");  
    
     //alert('File Name'+fName);  
     action.setParams({"documentId":Id,  
              "title": component.get("v.selectedDocValue"),  
              "recordId": component.get("v.recordId")  
              });  
     action.setCallback(this,function(response){  
       var state = response.getState();  
       if(state=='SUCCESS'){  
         var result = response.getReturnValue();  
         //console.log('Result Returned: ' +result);  
         //component.find("fileName").set("v.value", " ");  
         component.set("v.files",result);  
       }  
     });  
     $A.enqueueAction(action);  
   }, 
    
  
      getVehicleTheftDetails : function(component, event, helper) {
        
         var actions = [
            {
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_theft',
                
            },
            {
                'label': 'Delete',
                'iconName': 'utility:delete',
                'name': 'Delete_theft'
            },
             {
                'label': 'Generate PDF File',
                'iconName': 'utility:archive',
                'name': 'generate_theft'
            }
        ];
        
        component.set('v.theftReportColumns', [
            
          {label: 'Theft Ref No', fieldName: 'recordLink',type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
          /*   {label: 'Name', fieldName: 'Name', type: 'text'},
           {label: 'Cancel_Request__c', fieldName: 'Cancel_Request__c', type: 'text'},*/
            {label: 'Cancel Req', fieldName: 'cancelReqLink',type: 'url',typeAttributes: { label:  { fieldName: 'cancelReqName' }, target:'_blank'}},
            
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        var exeAction = component.get("c.getTheftReportData");
        exeAction.setParams({"RecID":component.get("v.recordId")  
                           }); 
        
         helper.serverSideCall(component,exeAction).then(
            function(res) {
                var records =res;
                records.forEach(function(record){
                    
                    record.cancelReqName = record.Cancel_Request__r.Name;
                    record.cancelReqLink = '/'+record.Cancel_Request__c;
                    record.recordLink = '/'+record.Id;
                    
                });
                
                
               console.log('----res---'+res);
               component.set('v.theftReportData', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    
      getVehicleNOCDetails : function(component, event, helper) {
        
         var actions = [
            {
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_NOC',
                
            },
            {
                'label': 'Delete',
                'iconName': 'utility:delete',
                'name': 'Delete_NOC'
            },
             {
                'label': 'Generate Report',
                'iconName': 'utility:archive',
                'name': 'generate_NOC'
            }
        ];
        
        component.set('v.NOCReportColumns', [
            
          {label: 'NOC Ref No', fieldName: 'recordLink',type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
          /*   {label: 'Name', fieldName: 'Name', type: 'text'},
           {label: 'Cancel_Request__c', fieldName: 'Cancel_Request__c', type: 'text'},*/
            {label: 'Cancel Req', fieldName: 'cancelReqLink',type: 'url',typeAttributes: { label:  { fieldName: 'cancelReqName' }, target:'_blank'}},
            
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        var exeAction = component.get("c.getNOCReportData");
        exeAction.setParams({"RecID":component.get("v.recordId")  
                           }); 
        
         helper.serverSideCall(component,exeAction).then(
            function(res) {
                var records =res;
                records.forEach(function(record){
                    
                    record.cancelReqName = record.Correction_Cancel_Request__r.Name;
                    record.cancelReqLink = '/'+record.Correction_Cancel_Request__c;
                    record.recordLink = '/'+record.Id;
                    
                });
                
                
               console.log('----res---'+res);
               component.set('v.NOCReportData', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    
        getVehicleCancellationLetterDetails : function(component, event, helper) {
        
         var actions = [
            {
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_CanLetter',
                
            },
            {
                'label': 'Delete',
                'iconName': 'utility:delete',
                'name': 'Delete_CanLetter'
            },
             {
                'label': 'Generate Report',
                'iconName': 'utility:archive',
                'name': 'generate_CanLetter'
            }
        ];
        
        component.set('v.cancellLetterColumns', [
            
          {label: 'NOC Ref No', fieldName: 'recordLink',type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
          /*   {label: 'Name', fieldName: 'Name', type: 'text'},
           {label: 'Cancel_Request__c', fieldName: 'Cancel_Request__c', type: 'text'},*/
            {label: 'Cancel Req', fieldName: 'cancelReqLink',type: 'url',typeAttributes: { label:  { fieldName: 'cancelReqName' }, target:'_blank'}},
            
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        var exeAction = component.get("c.getCanceLetterData");
        exeAction.setParams({"RecID":component.get("v.recordId")  
                           }); 
        
         helper.serverSideCall(component,exeAction).then(
            function(res) {
                var records =res;
                records.forEach(function(record){
                    
                    record.cancelReqName = record.Cancel_Request__r.Name;
                    record.cancelReqLink = '/'+record.Cancel_Request__c;
                    record.recordLink = '/'+record.Id;
                    
                });
                
                
               console.log('----res---'+res);
               component.set('v.cancellLetterData', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    
     getVehicleProfCertDetails : function(component, event, helper) {
        
         var actions = [
            {
                'label': 'Edit',
                'iconName': 'utility:edit',
                'name': 'edit_ProfCert',
                
            },
            {
                'label': 'Delete',
                'iconName': 'utility:delete',
                'name': 'Delete_ProfCert'
            },
             {
                'label': 'Generate Report',
                'iconName': 'utility:archive',
                'name': 'generate_ProfCert'
            }
        ];
        
        component.set('v.ProfCertColumns', [
            
          {label: 'NOC Ref No', fieldName: 'recordLink',type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
          /*   {label: 'Name', fieldName: 'Name', type: 'text'},
           {label: 'Cancel_Request__c', fieldName: 'Cancel_Request__c', type: 'text'},*/
            {label: 'Cancel Req', fieldName: 'cancelReqLink',type: 'url',typeAttributes: { label:  { fieldName: 'cancelReqName' }, target:'_blank'}},
            
            {label: 'Actions', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        var exeAction = component.get("c.getProfCertData");
        exeAction.setParams({"RecID":component.get("v.recordId")  
                           }); 
        
         helper.serverSideCall(component,exeAction).then(
            function(res) {
                var records =res;
                records.forEach(function(record){
                    
                    record.cancelReqName = record.Cancel_Request__r.Name;
                    record.cancelReqLink = '/'+record.Cancel_Request__c;
                    record.recordLink = '/'+record.Id;
                    
                });
                
                
               console.log('----res---'+res);
               component.set('v.ProfCertData', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
    },
    deleteSobjectRecord : function(component, event, helper,refreshMethod){
        
         var row = event.getParam('row');
         var exeAction = component.get("c.deleteRecord");
        exeAction.setParams({
            "RecID": row.Id  
        }); 
        
         helper.serverSideCall(component,exeAction).then(
             function(res) { 
                 if(res == 'success'){
                    
                     helper.handlerShowToastMsg('Success','Record is successfully deleted','Success');
                     if(refreshMethod == 'getVehicleTheftDetails'){
                         helper.getVehicleTheftDetails(component, event, helper);
                     }else if(refreshMethod == 'getVehicleNOCDetails'){
                         
                         helper.getVehicleNOCDetails(component, event, helper);
                     }
                      
                   
                 }
             
             });
    },
    
    handlerShowToastMsg : function(Title,Msg,Type){
          var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type": Type,
                    "title":Title,
                    "message":Msg,
                    "mode":"dismissible"
                });
                toastReference.fire();
                
                $A.get('e.force:refreshView').fire();
    },
    
    getRequiredDocList : function(component, event, helper){
        
        var exeAction = component.get("c.getRelatedDocList");
        exeAction.setParams({
            "RecID": component.get("v.recordId")
        }); 
        
         helper.serverSideCall(component,exeAction).then(
             function(res) { 
                 
                 component.set("v.DocOptions",res);
             });
    },
    deleteDocumentRecord : function(component, event, helper,DocName){
        
          var selectedPillId =event.target.id;  
         var exeAction = component.get("c.deleteRecord");
        exeAction.setParams({
            "RecID": selectedPillId  
        }); 
        
         helper.serverSideCall(component,exeAction).then(
             function(res) { 
              
                    
                   
             
             });
    },
    
})