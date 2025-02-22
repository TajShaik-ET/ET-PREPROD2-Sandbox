({
   handleonLoad: function(component, event, helper) {
      
        // Optional: Add custom logic to execute when the form loads
        console.log("Form loaded!");
    },

    
    handleSuccess: function(component, event, helper) {
         component.set('v.showSpinner', false);
        helper.showToast("Success", "Record saved successfully", "success");
        var payload = event.getParams().response;
        console.log("Record created/updated successfully: " + payload.id);
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "attachmentInsert";
        var params = {
            "fileName" : component.get('v.fileName'), 
            "fileBody" : component.get('v.fileContent'), 
            "parentRecordId" : payload.id
        };
        var promise = utility.executeServerCall(component, backendMethod, params);       
        promise.then (
            $A.getCallback(function(response) {
               //utility.showToast("School Tranport", "Invoice Created Successfully!", "success", "dismissible");
                console.log("Attachment inserted successfully.");
                
                // After all operations complete successfully, redirect to home page
                helper.redirectTo(component, '/etst-home-page?lang=' + component.get("v.clLang"));
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
        $A.get('e.force:refreshView').fire();
        // Optional: Add custom success handling logic here
    },
    

    handleError: function(component, event, helper) {
         
        var errorMessages = event.getParams().error;
        console.error("Error: " + JSON.stringify(errorMessages));
        
        // Display error messages using the lightning:messages component
        var displayErrorMessage = component.find("displayErrorMessage");
        if (displayErrorMessage) {
            displayErrorMessage.setError(errorMessages);
        }
    },
     handleSubmit: function(component, event, helper) {
         component.set('v.showSpinner', True);  
        // Optional: Add custom pre-submit logic here
        console.log("Form submitted!");
    },
    cancelSave: function(component, event, helper) {
        helper.redirectTo(component, '/etst-home-page?lang='+component.get("v.clLang"));
    },
     handleFilesChange : function(component, event, helper) {
        var fileName = 'No File Selected..';
        var fileOutput = {};
        if (event.getSource().get("v.files").length > 0) {
            var file = event.getSource().get("v.files")[0];
            fileName = file['name'];
            var reader = new FileReader();
            reader.onload = $A.getCallback(function() {
                var content = reader.result;
                var base64 = 'base64,';
                var dataStart = content.indexOf(base64) + base64.length;
                content = content.substring(dataStart); 
                component.set('v.fileName', fileName);
                component.set('v.fileType', file.type);
                component.set('v.fileContent',content);
            });
            reader.readAsDataURL(file);
        }
    },
})