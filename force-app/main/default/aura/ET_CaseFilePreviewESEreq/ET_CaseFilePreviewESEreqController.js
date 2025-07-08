({
doInit : function(component, event, helper){
    

    
    
    helper.getuploadedFiles(component, event, helper);
    helper.getProfiledata(component, event, helper);
    
    
    component.set('v.isGovDepartment', false);
    
    helper.setCommunityLanguage(component, event, helper); 
    
    
    },
    
    
     previewFileAction :function(component,event,helper){  
        var rec_id = event.currentTarget.id; 
         alert(rec_id);
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [rec_id]
        });  
    },  
    
    UploadFinished : function(component, event, helper) {  
        var uploadedFiles = event.getParam("files");  
        //var documentId = uploadedFiles[0].documentId;  
        //var fileName = uploadedFiles[0].name; 
        helper.getuploadedFiles(component);         
        component.find('notifLib').showNotice({
            "variant": "success",
            "header": "Success",
            "message": "File Uploaded successfully!!",
            closeCallback: function() {}
        });
        
        
    }, 
    
    delFilesAction:function(component,event,helper){
        component.set("v.Spinner", true); 
        var documentId = event.currentTarget.id;        
        helper.delUploadedfiles(component,documentId);  
    },

    closeModel: function(component, event, helper) {
         component.set("v.openModal" ,null);
         component.set('v.isViewFileModal',false);
        
    },
    
    openFileView1 :function(component, event, helper) {
     var recId = component.get("v.ticketId");
         component.set("v.openModal",recId);
         component.set('v.isViewFileModal',true);
       
        
    },
    
    
    
  
    

})