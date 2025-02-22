({
    getCorrectionRecTypeId : function(component, event, helper){
    
    var exeAction = component.get("c.getRecordTypeId");
        exeAction.setParams({ 
           
            "objName":"Case",
            "devName":"ETIN_Health_Correction_Request"
            
        });
        
         exeAction.setCallback(this, function(response) {
            let state = response.getState();
             if (state === "SUCCESS") {
                  component.set("v.correctionRecId",response.getReturnValue());
                 
             }else if (state === "ERROR") {
                let errors = response.getError();
                
                 console.log('Error-recType--'+errors[0].message);
             }
         });
        $A.enqueueAction(exeAction);
},
    
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
    
    getLoginContactId : function(component, event, helper,userId) {
        
        var exeAction = component.get("c.getLoginContactId");
        exeAction.setParams({ 
           
            "userId":userId
            
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                component.set("v.EmpContID",res);
                //console.log('contact ID'+res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error.message));
            }
        ); 
    },
    
   /* getLoginConAccId :function(component, event, helper) {
        
        var exeAction = component.get("c.getLoginAccountId");
        
        this.serverSideCall(component,exeAction).then(
            function(res) {
                component.set("v.EmpAccountID",res);
               //console.log('----'+res);
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        ); 
    },
   */

    
    /* getAttachmentList : function(component, event, helper) {  
        
        
        var exeAction = component.get("c.getAttachments");
        
        exeAction.setParams({ 
            "parentRecID": component.get("v.CreatedRecID")       
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                
                component.set('v.attachments', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
                

            }
        );
        
    }, */
    
    getContactID : function(component, event, helper,userId) { 

         var exeAction = component.get("c.getContactLoginId");
        
        exeAction.setParams({ 
            "userId":userId       
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
               
                component.set('v.UserContactId', res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
                

            }
        );
     
      
    
    },
    
     uploadHelper: function(component, event,file) {
     
        var  MAX_FILE_SIZE = 4500000; //Max file size 4.5 MB 
         var CHUNK_SIZE= 750000;   //Chunk Max size 750Kb      
        
        //component.set("v.showLoadingSpinner", true);
       
          // component.set("v.showLoadingSpinner", false);
          //alert('enter upload');
            var self = this;
           var objFileReader = new FileReader();
          
           objFileReader.onload = $A.getCallback(function() {
               var fileContents = objFileReader.result;
               var base64 = 'base64,';
               var dataStart = fileContents.indexOf(base64) + base64.length;
               
               fileContents = fileContents.substring(dataStart);
               //alert('file content'+fileContents);
               self.uploadProcess(component,file,fileContents);
           });
           
           objFileReader.readAsDataURL(file); 
          
    },
 
    uploadProcess: function(component,file,fileContents) {
       
        var startPosition = 0;
        var CHUNK_SIZE= 750000;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveChunk'
        //alert('upload chunk');
         var  MAX_FILE_SIZE = 4500000; //Max file size 4.5 MB 
         var CHUNK_SIZE= 750000;   //Chunk Max size 750Kb      

        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveTheFile");
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            parentID: component.get("v.CreatedRecID")
        });
 
       
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            //alert('file id'+response.getReturnValue());
            var state = response.getState();
            if (state === "SUCCESS") {
                
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition +CHUNK_SIZE);
                
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    //alert('your File is uploaded successfully');
                    component.set("v.showLoadingSpinner", false);
                    component.set("v.DetailPage", false);
                    component.set("v.SuccessPage", true);
                    //Clearing file list after upload
                    var arr = [];
                    component.set("v.filesList",arr);
                    component.set("v.file1",false);
                    component.set("v.file2",false);
                    
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
    
    getLoginUserVisaEmiratesVal : function(component, event, helper,userId) {
        
        var exeAction = component.get("c.getLoginUserVisaEmirates");
        exeAction.setParams({ 
           
            "userId":userId
            
        });
         exeAction.setCallback(this, function(response) {
            let state = response.getState();
             if (state === "SUCCESS") {
                if(response.getReturnValue() == 'Abu Dhabi')   {
                   component.set("v.ShowForCorrctVisaEmirates",true); 
                }                  
             }else if (state === "ERROR") {
                let errors = response.getError();
                
                 console.log('Error-Visa--'+errors[0].message);
             }
         
         });
         $A.enqueueAction(exeAction);
       
    }    
    
    
})