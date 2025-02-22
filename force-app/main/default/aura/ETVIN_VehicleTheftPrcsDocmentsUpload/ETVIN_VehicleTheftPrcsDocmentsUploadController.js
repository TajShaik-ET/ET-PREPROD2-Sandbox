({
	doInit : function(component, event, helper) {
		
        helper.getAllDocs(component, event, helper);
        helper.getRequiredDocList(component, event, helper);
        helper.getVehicleEmailNotification(component, event, helper);
	},
    onChangeDocVal : function(component, event, helper) {
        
        var selectedVal = component.get("v.selectedDocValue");
                
        if(selectedVal != 'blank'){
            
            component.set("v.DisableFileUpload",false);
        }else {
            
            component.set("v.DisableFileUpload",true);
        }
        
        
    },
    
     handleUploadFinished : function(component, event, helper) {
      
        var customLabel = component.get("v.selectedDocValue");
        var uploadedFiles = event.getParam("files");
       
        var documentId = uploadedFiles[0].documentId;
        component.set("v.DisableFileUpload",true);
        helper.UpdateDocument(component,event,helper,documentId);
       // helper.getAttachmentList(component, event, helper);
        
    },
      clearAttachment :function(component, event, helper){
       
          var selectedPillId =event.target.id;  
      
          helper.deleteDocumentRecord(component, event, helper);
       
    },
    
    OpenFile :function(component,event,helper){ 
        var rec_id = event.currentTarget.id;
   
        $A.get('e.lightning:openFiles').fire({
            //Lightning Openfiles event  
                recordIds: [rec_id] //file id  	
               });  
    }, 
    notifyWithEmail : function(component,event,helper){ 
       
        component.set("v.closePopup",true);
   
    },
    
    closeModelPopup : function(component,event,helper){ 
    
        component.set("v.closePopup",false);
    },
    
    sendEmailtoList : function(component,event,helper){ 
        
        var selectedList = [];
        
        if(component.get("v.CheckboxValue1")){
            
           selectedList.push('Salik Controller');
            
        }
        if(component.get("v.CheckboxValue2")){
             selectedList.push('Fuel Controller');
            
        }
        if(component.get("v.CheckboxValue3")){
             selectedList.push('Fine Controller');
            
        }
     
       helper.sendEmailToDiffControllers(component,event,helper,selectedList);
            
    },
    
    onCheck : function(component,event,helper){ 
     
        alert(component.get("v.CheckboxValue1"))
    },
    
  
})