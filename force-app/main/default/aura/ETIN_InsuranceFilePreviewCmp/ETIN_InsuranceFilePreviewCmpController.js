({
	doInit : function(component, event, helper) {
		
         helper.getAllDocs(component, event, helper);
	},
    
    NavigateTo : function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/r/AttachedContentDocument/"+component.get("v.recordId")+"/related/AttachedContentDocuments/view"
        });
        urlEvent.fire();
    },
    
     
     handleUploadFinished : function(component, event, helper) {
             
        var uploadedFiles = event.getParam("files");
        
          helper.getAllDocs(component, event, helper);
     }
    
})