({
	serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                    console.log(state);
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
    
   UpdateDocument : function(component,event,helper,Id) {  
        
      
       var docName = component.get("v.selectedDocValue");
       
       var exeAction = component.get("c.UpdateFiles");  
       exeAction.setParams({
           "documentId":Id,  
           "title": docName,  
           "recordId": component.get("v.recordId")  
       });  
       
       
       helper.serverSideCall(component,exeAction).then(
           function(res) { 
               
               component.set("v.files",res);
               helper.updateCancelRecord(component, event, helper,docName,true);
                helper.getRequiredDocList(component, event, helper);
               
             /*  var actionEvt = getEvent("Actionname");
               actionEvt.setParams({
                   "message": 'refresh'
               });
               
               actionEvt.fire(); */
               location.reload();
             });
       
   }, 
 
      getRequiredDocList : function(component, event, helper){
        
        var exeAction = component.get("c.getRelatedDocList");
        exeAction.setParams({
            "RecID": component.get("v.recordId")
        }); 
        
         helper.serverSideCall(component,exeAction).then(
             function(res) { 
                 console.log('--'+res)
                 component.set("v.DocOptions",res);
             });
    },
    deleteDocumentRecord : function(component, event, helper){
        
        var selectedPillId =event.target.id;  
        
         var docLabel = selectedPillId.substring(selectedPillId.lastIndexOf("_")+1); //to get Last word
          
         var docID = selectedPillId.substring(0,selectedPillId.lastIndexOf("_"));  //to get first part 
       
        var exeAction = component.get("c.deleteRecord");
        exeAction.setParams({
            "RecID": docID  
        }); 
        
        helper.serverSideCall(component,exeAction).then(
            function(res) { 
                if(res == 'success'){
                      helper.handlerShowToastMsg('Success','File is deleted successfully','success');
                     helper.getAllDocs(component, event, helper);
                     helper.updateCancelRecord(component, event, helper,docLabel,false);
                }
            });
    },
    
    updateCancelRecord : function(component, event, helper,docLabel, statusVal){
      
         var exeAction = component.get("c.updateRecord");
        exeAction.setParams({
            "RecID": component.get("v.recordId"),
            "DocLabel":docLabel,
            "status": statusVal
        }); 
        
        helper.serverSideCall(component,exeAction).then(
            function(res) { 
                helper.getRequiredDocList(component, event, helper);
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
    
    getVehicleEmailNotification : function(component, event, helper){
        
         var exeAction = component.get("c.getVehicleEmailRecipients");
       
        
         helper.serverSideCall(component,exeAction).then(
             function(res) { 
                 
                 component.set("v.emailUserList",res);
             });
    },
    
    sendEmailToDiffControllers : function(component, event, helper,selectedList){
         
        var exeAction = component.get("c.sendEmailtoTheList");
        exeAction.setParams({
            "senderList": selectedList
           
        }); 
        
        helper.serverSideCall(component,exeAction).then(
            function(res) { 
                if(res == 'success'){
                   
                    component.set("v.closePopup",false);
                    component.set("v.CheckboxValue1",false);
                    component.set("v.CheckboxValue2",false);
                    component.set("v.CheckboxValue3",false);
                    //alert()
                    helper.handlerShowToastMsg('Success','Email has been sent successfully','success');
                }
            });
    }
    
})