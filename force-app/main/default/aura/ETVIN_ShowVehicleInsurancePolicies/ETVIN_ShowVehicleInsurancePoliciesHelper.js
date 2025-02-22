({
	getInsurancedetails : function(component, event, helper) {
		var action = component.get("c.getInsurancePoliciyDetails");
        action.setParams({ 
            //recordId : recordId
        });
      //  alert(component.get('v.recordId'));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var vehicleInsList = response.getReturnValue();
                
                console.log('@@@@ ' + JSON.stringify(vehicleInsList));
                component.set('v.vehicleInsList', vehicleInsList);
                component.set('v.FilteredData', vehicleInsList);
                
               
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
       /* alert(component.get('v.recordId'));
        alert(component.get('v.detailPage'));*/
	},
    updateStatusWithAcceptAndReject : function(component, event, helper, status) {
        var InsuranceTransactions  = component.get('v.InsuranceTransactions');
		var action = component.get("c.updateStatus");
        var  recordId = component.get('v.recordId');
        if(status == 'Approved'){
            action.setParams({ 
                recordId : recordId,
                status : status,
                InsuranceTransactions : InsuranceTransactions
            });
             
        }else{
            action.setParams({ 
                recordId : recordId,
                status : status,
                InsuranceTransactions : null
            });
        }
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            //(state)
            if (state === "SUCCESS") {
                var parentId = response.getReturnValue();
                if(status == 'Approved'){
                   // this.uploadHelper(component,event, 'fileId', parentId);
                }
                component.set("v.isModalOpen", false);
                var msg = '';
                if(status == 'Approved'){
                   msg= 'The record is been approved.'; 
                }else{
                     msg= 'The record is been rejected.';
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "dismissible",
                    message: msg,
                    type: 'Success',
                    title: 'Success!'
                });
                toastEvent.fire();
                
                
                 this.getInsurancedetails(component, event, helper);
                 component.set('v.recordId', '');
                component.set('v.detailPage', false);
                
                var address = new URL(window.location.origin);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": address+'partnerportal/s',
                    "isredirect" :false
                });
                urlEvent.fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
	},
    getPicklistValues: function(component, event, helper, obj, fld, attribute) {
        var action = component.get("c.getPicklistValues");
        action.setParams({ 
            objectName : obj,
            fieldName : fld
        });
        var opts=[];
        action.setCallback(this, function(a) {
           /* opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });*/
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            component.set(attribute, opts);
            //inputIndustry.set("v.options", opts);
             
        });
        $A.enqueueAction(action); 
    },
    
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    uploadHelper: function(component, event, fileid, parentId) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find(fileid).get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents, parentId);
        });
 
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents, parentId) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '', parentId);
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, parentId) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: parentId,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            //alert(state)
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    //alert('your File is uploaded successfully');
                    component.set("v.showLoadingSpinner", false);
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    fetchContentDocument : function(component, event, helper) {
        var action = component.get("c.fetchContentDocument");
        var  recordId = component.get('v.recordId');
       // alert(recordId)
        action.setParams({ 
            recordId : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('@@@ ', response.getReturnValue());
                component.set('v.lstContentDoc', response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);  
    },
    validateFile : function(component, event, helper){
        //var fileInput = component.find('fileId').get("v.files");
        var fileInput1 = component.find('policyfileId').get("v.files");
        var effectiveDate = component.find('effectiveDate').get("v.value");
        var expiryDate = component.find('expiryDate').get("v.value");
        var amount = component.find('amount').get("v.value");
        
         var isvalid = true;
        
        if(expiryDate <= effectiveDate){
            
           helper.ErrorHandle(component, event, helper,'Expiry date should not be less than effective date','Error');
            isvalid = false;
        }
      /*  if(!amount){
             helper.ErrorHandle(component, event, helper,'Amount is mandatory','Error');
            isvalid = false;
        }*/
     
       /*if(!effectiveDate){
            component.find('effectiveDate').setCustomValidity("Complete this field.");
            component.find('effectiveDate').showHelpMessageIfInvalid();
            isvalid = false;
            
        }*/
      /*  if(fileInput == null || fileInput == undefined || fileInput.length == 0){
            component.find('fileId').setCustomValidity("Complete this field.");
            component.find('fileId').showHelpMessageIfInvalid();
            isvalid = false;

        }*/
        if(fileInput1 == null || fileInput1 == undefined || fileInput1.length == 0){
             helper.ErrorHandle(component, event, helper,'Policy attachment is required','Error');
            //component.find('policyfileId').setCustomValidity("Attachment is required.");
            //component.find('policyfileId').showHelpMessageIfInvalid();
            isvalid = false;
        }
        return  isvalid ;
    },
    
    ErrorHandle : function(component, event, helper,msg,title) {
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
            "type" : title,
            "title" : title,
            "message" : msg,
            "mode" : "dismissible"
           });
        toastReference.fire(); 
     }
})