({
    doInit : function(component, event, helper) {
        console.log('onload');
        component.set("v.isOpen", true);
        helper.doInit(component, event, helper);		
    },
    closeModel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    /*saveRecord : function(component, event, helper) {
        //var paymentId = component.get("v.paymentId");
        helper.createPaymentRecord(component, event, helper)
            .then(function(result) {
                console.log('result ',result);
                var utility = component.find("ETST_UtilityMethods");
                var params = {
                    "fileName" : component.get('v.fileName'),
                    "fileBody" : component.get('v.fileContent'),
                    "parentRecordId" : result.Id
                };
                return utility.executeServerCall(component, "attachmentInsert", params);
            })
            .then(function() {
                console.log("Attachment inserted successfully.");
                $A.get('e.force:refreshView').fire();
                helper.redirectTo(component, '/etst-home-page?lang=' + component.get("v.clLang"));
            })
            .catch(function(error) {
                var utility = component.find("ETST_UtilityMethods");
                var errorToShow = utility.convertToUserFriendlyErrMsg(error.message);
                console.error(errorToShow);
                utility.showToast("Error", errorToShow, "error", "dismissible");
            });
    }
    saveRecord: function (component, event, helper) {
    helper.createPaymentRecord(component, event, helper)
        .then(function (result) {
            console.log('Result: ', result);
            var utility = component.find("ETST_UtilityMethods");

            // Ensure that the file content is correctly retrieved
            var fileName = component.get('v.fileName');
            var fileContent = component.get('v.fileContent');

            // Check if file content is available
            if (!fileContent) {
                throw new Error("File content is missing or not loaded correctly.");
            }

            var params = {
                "fileName": fileName,
                "fileBody": fileContent,
                "parentRecordId": result
            };

            return utility.executeServerCall(component, "attachmentInsert", params);
        })
        .then(function () {
            console.log("Attachment inserted successfully.");
            $A.get('e.force:refreshView').fire();
            helper.redirectTo(component, '/etst-home-page?lang=' + component.get("v.clLang"));
        })
        .catch(function (error) {
            var utility = component.find("ETST_UtilityMethods");
            var errorToShow = utility.convertToUserFriendlyErrMsg(error.message);
            console.error(errorToShow);
            utility.showToast("Error", errorToShow, "error", "dismissible");
        });
},*/
    saveRecord: function (component, event, helper) {
        var paymentRecord = component.get("v.paymentRecord");
        var isValid = true;
        var utility = component.find("ETST_UtilityMethods");
        var errorMessages = {};
        
        if (!paymentRecord.ETST_Bank_Transaction_Ref_Id__c) {
            isValid = false;
            errorMessages.BankTransactionRefId = "Bank Transaction Ref Id is required.";
        }
        
        if (!paymentRecord.ETST_Bank_Transaction_Date__c) {
            isValid = false;
            errorMessages.BankTransactionDate = "Bank Transaction Date is required.";
        }
        var fileContent = component.get('v.fileContent');
        if (!fileContent) {
            isValid = false;
            errorMessages.FileUpload = "File upload is required.";
        }
        
        component.set("v.errorMessages", errorMessages);
        
        if (isValid) {
            helper.createPaymentRecord(component, event, helper)
            .then(function (result) {
                console.log('Result: ', result);
                
                var fileName = component.get('v.fileName');
                
                var params = {
                    "fileName": fileName,
                    "fileBody": fileContent,
                    "parentRecordId": result
                };
                
                return utility.executeServerCall(component, "attachmentInsert", params);
            })
            .then(function () {
                console.log("Attachment inserted successfully.");
                $A.get('e.force:refreshView').fire();
            })
            .catch(function (error) {
                var errorToShow = utility.convertToUserFriendlyErrMsg(error.message);
                console.error(errorToShow);
                utility.showToast("Error", errorToShow, "error", "dismissible");
            });
        }
    },
    
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    },
    handleFilesChange : function(component, event, helper) {
        var fileInput = event.getSource();
        var files = fileInput.get("v.files");
        if (files.length > 0) {
            var file = files[0];
            var reader = new FileReader();
            reader.onload = $A.getCallback(function() {
                var content = reader.result;
                var base64Marker = 'base64,';
                var dataStart = content.indexOf(base64Marker) + base64Marker.length;
                var base64Content = content.substring(dataStart);
                component.set('v.fileName', file.name);
                component.set('v.fileType', file.type);
                component.set('v.fileContent', base64Content);
            });
            reader.readAsDataURL(file);
        }
    },
})