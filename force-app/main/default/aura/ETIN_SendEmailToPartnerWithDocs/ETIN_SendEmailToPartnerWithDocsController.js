({
	doInit : function(component, event, helper) {
		
        helper.getSearchResult(component, event, helper);       
        helper.getPartnerEmailDetails(component, event, helper);  
        helper.getInsRelatedLibraryFiles(component, event, helper); 
        helper.getReportGenerateFile(component, event, helper);
        helper.getUserDetails(component,event, helper);
       
      
        
	},
    onChange : function(component, event, helper) {
        
        component.set("v.locationVal",component.find('LocationId').get('v.value'));
        helper.getSearchResult(component, event, helper);
        helper.getPartnerEmailDetails(component, event, helper);
        helper.getReportGenerateFile(component, event, helper); 
    },
    openModel :function(component, event, helper) {
        
        var selectedRec  = component.get("v.SelectedRecordlist");
        var empIds = [];
        var body = [];
            body.push('Dear Team, <br/><br/>I hope that this mail finds you well<br/>Kindly find the attached documents for members addition<br/><br/>');
        if (selectedRec.length >0 && selectedRec.length <=15) {
            component.set("v.emailVal", component.get("v.ServerEmailVal"));
            
            for(var i = 0; i < selectedRec.length; i++){
                empIds.push(selectedRec[i].Employee_ID__c);
                body.push(selectedRec[i].Employee_ID__c+'- Requested By: '+selectedRec[i].CreatedBy.Name+'<br/>');
            }
            
            body.push('<br/>Best Regards,<br/>' +component.get('v.userDetails').Name+'<br/>Health Insurance Advisor');//Added by Arunsarathy
           // body.push('<br/>Best Regards,<br/>Alsayed Alhindawi,<br/>Health Insurance Advisor');
            
            component.set("v.body",body.toString().replaceAll(',',''));            
            var empIdString = 'New Insurance Request: '+empIds.toString().replaceAll(',','-');
            component.set("v.subject",empIdString);
            component.set("v.showPopup",true);
        }else if(selectedRec.length>15){
             var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":'You can select max 15 records at time',
                "mode":"dismissible"
            });
            toastReference.fire();
        }else{
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":'Please check atleast one record to proceed',
                "mode":"dismissible"
            });
            toastReference.fire();
        }
        
    },
    closePopup : function(component, event, helper) {
        
       helper.closePopupHelper(component, event, helper);
        
    },
    getSelectedRows : function(component, event, helper) {
       
        var selectedRows = event.getParam('selectedRows');
        
         component.set("v.SelectedRecordlist",selectedRows);
         
        
        
    },
    getSelectedDocs :function(component, event, helper) {
        
        var selectedRows = event.getParam('selectedRows');
       
        component.set("v.SelectedDocList",selectedRows);        
        
    },
    
    sendMail :function(component, event, helper) {
       
      helper.SendEmailToPartner(component, event, helper);
    },
    
    removeFile : function(component, event, helper) {
        
        var selectedSection = event.currentTarget;
        var index = selectedSection.dataset.index;
        var indexName = selectedSection.dataset.filename;
               
        var removeList = component.get("v.finalFileList");
               
        removeList.splice(index, 1);
       
        component.set("v.finalFileList",removeList);
      // console.log('--after remove--'+JSON.stringify(component.get("v.finalFileList")));
       
    },
    onFileUploaded : function(component, event, helper) {
         // helper.show(component,event);
        var files = component.get("v.fileToBeUploaded");
        if (files && files.length > 0) {
            var file = files[0][0];
            var reader = new FileReader();
            reader.onloadend = function() {
                var dataURL = reader.result;
                var content = dataURL.match(/,(.*)$/)[1];
                helper.upload(component, file, content, function(answer) {
                    if (answer) {
                        //helper.hide(component,event);
                        // Success
                    }
                    else{
                        // Failure
                    }
                });
            }
            reader.readAsDataURL(file);
        }
        else{
            //helper.hide(component,event);
        }
    
    },
    
    sortColumn : function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
       
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
  
})