({
	doInit : function(component, event, helper) {
        
		helper.getAllDocs(component, event, helper);
        helper.getVehicleTheftDetails(component, event, helper);
        helper.getVehicleNOCDetails(component, event, helper); 
        helper.getVehicleProfCertDetails(component, event, helper);
        helper.getVehicleCancellationLetterDetails(component, event, helper);
        helper.getRequiredDocList(component, event, helper);
       
	},
    
    createNewTheftReport : function(component, event, helper) {
        component.set("v.VehicleTheftPopup", true);
        
    },
    closeVehicleTheftReport : function(component, event, helper) {
        component.set("v.VehicleTheftPopup", false);
    },
    handleSubmitTheftRepo : function(component, event, helper) {
        
    },
    handleSuccessTheftRepo : function(component, event, helper) {
          var params = event.getParams();
        
        if(params.response.id != null) {
            
            component.set("v.VehicleTheftPopup", false);
            helper.handlerShowToastMsg('Success','Theft report is created successfully','success');
            helper.getVehicleTheftDetails(component, event, helper);
        }
      
    },
    createNewNOCReport :  function(component, event, helper) {
        
         component.set("v.VehicleNOCPopup", true);
    },
    closeVehicleNOCReport : function(component, event, helper) {
        
         component.set("v.VehicleNOCPopup", false);
    },
    handleSubmitNOCRepo : function(component, event, helper) {
        
    },
    handleSuccessNOCRepo :function(component, event, helper) {
        
        var params = event.getParams();
        
        if(params.response.id != null) {
            
            component.set("v.VehicleNOCPopup", false);
            helper.handlerShowToastMsg('Success','NOC report is created successfully','success');
            helper.getVehicleNOCDetails(component, event, helper);
        }
    },
    
     
    handleUploadFinished : function(component, event, helper) {
      
        var customLabel = component.get("v.selectedDocValue");
        var uploadedFiles = event.getParam("files");
       
        var documentId = uploadedFiles[0].documentId;
       
        helper.UpdateDocument(component,event,documentId);
       // helper.getAttachmentList(component, event, helper);
        
    },
      clearAttachment :function(component, event, helper){
       
          var selectedPillId =event.target.id;  
      
         var docLabel = selectedPillId.substring(selectedPillId.lastIndexOf("_")+1); //to get Last word
          
         var docID = selectedPillId.substring(0,selectedPillId.lastIndexOf("_"));  //to get first part 
       // helper.deleteDocumentRecord();
          
              
      /*  var exeAction = component.get("c.deleteAttachment");
        exeAction.setParams({ 
            "contentDocId": selectedPillId          
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
               // console.log(res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
        helper.getAttachmentList(component, event, helper); */
            
    },
    
    OpenFile :function(component,event,helper){ 
        var rec_id = event.currentTarget.id;
   
        $A.get('e.lightning:openFiles').fire({
            //Lightning Openfiles event  
                recordIds: [rec_id] //file id  	
               });  
    },  
    
    handleTheftRowAction : function(component, event, helper){
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit_theft':
                
                 alert('edit')
                break;
            case 'Delete_theft':
                helper.deleteSobjectRecord(component, event, helper,'getVehicleTheftDetails');
                break;
            case 'generate_theft':
                var url = '/apex/ETVIN_VehicleTheftReport?id='+ row.Id;
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": url
                });
                urlEvent.fire();
                break;
        }
             
    },
    
      handleNOCRowAction : function(component, event, helper){
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'edit_NOC':
                
                 alert('edit')
                break;
            case 'Delete_NOC':
                helper.deleteSobjectRecord(component, event, helper,'getVehicleNOCDetails');
                break;
            case 'generate_NOC':
                alert('generate')
                break;
        }
             
    }
        
})