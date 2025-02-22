({
    doInit : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
       
        helper.getContactID(component, event, helper,userId);
        helper.getCorrectionRecTypeId(component, event, helper);
        helper.getLoginUserVisaEmiratesVal(component, event, helper,userId);
      
        
        var exeAction = component.get("c.getEmpInsDetails");
        exeAction.setParams({ 
            
            "userId":userId
            
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('Ins --Res--'+JSON.stringify(res));
                component.set("v.Insurancedata",res);
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        ); 
    },
    closeModel : function(component, event, helper){
        
        component.set("v.newMemberPopup",false);
        component.set("v.SuccessPage",false);
        
    },
    
    OpenAddFamilyPopup : function(component, event, helper){
        
        component.set("v.newMemberPopup",true);
         component.set("v.DetailPage",true);
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        
        helper.getLoginContactId(component, event, helper,userId);
       // helper.getLoginConAccId(component, event, helper);
        
    },
    
    handleError : function(component, event, helper) {
        
        
        //console.log(event);
        var errors = event.getParams();
         //console.log("Error Response", JSON.stringify(errors));
       
        //console.log("Error details",JSON.stringify(errors.output.fieldErrors));
                var firstKey = Object.keys(errors.output.fieldErrors)[0];
        //console.log('----'+JSON.stringify(errors.output.fieldErrors[firstKey][0].message));
        
         var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Error",
                "title":"Error",
                "message":errors.output.fieldErrors[firstKey][0].message,
                "mode":"dismissible"
            });
            toastReference.fire();
        
        //console.log("----8"+ errors.output.fieldErrors.ETIN_Employee__c.message);
    },
    handleSubmit :function(component, event, helper) {
        
         //var fields = event.getParam("fields");
        event.preventDefault();
        
       
      var files =  component.get("v.filesList");
        
        if(files.length == 2){
            
           
           component.find('createInsuranceForm').submit(); // Submit form 
            
        }else {
             var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Error",
                "title":"Error",
                "message":"Please attach required documents",
                "mode":"dismissible"
            });
            toastReference.fire();
        }  
        
       
      
        
    },
    handleSuccess : function(component, event, helper) {
        
        var params = event.getParams();
        
        component.set("v.CreatedRecID",params.response.id);
       
        component.set("v.IsHide", true);   
         component.set("v.showLoadingSpinner", true);
       // component.set("v.DetailPage",false);
       // component.set("v.DocUploadPage",true);
             
   if(params.response.id != ''){  
            
         
        var files =  component.get("v.filesList");
        
        if (files.length > 0) {
           
                for (var i = 0; i < files.length; i++) 
                {
                    var file = files[i];
                  helper.uploadHelper(component, event,file); 
                    
                }
        }else {
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Error",
                "title":"Error",
                "message":"Please fill required details",
                "mode":"dismissible"
            });
            toastReference.fire();
        }
        }           
        
    },
    
  /*  handleUploadFinished : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        
        helper.getAttachmentList(component, event, helper);
        
    },*/
    /*clearAttachment :function(component, event, helper){
        
        
        
        var selectedPillId = event.getSource().get("v.name");
        
        
        var exeAction = component.get("c.deleteAttachment");
        exeAction.setParams({ 
            "contentDocId": selectedPillId          
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log(res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
        helper.getAttachmentList(component, event, helper);
        
        
    },
    */
    showAddDetailPage :function(component, event, helper){
        
        component.set("v.DetailPage",true);
        component.set("v.DocUploadPage",false);
    },
    
    showSuccessPage : function(component, event, helper){
        
        component.set("v.SuccessPage",true);
        component.set("v.DocUploadPage",false);
        
        
        
    },
    
    downloadFile : function(component, event, helper){
        
        var input =  event.target.id;
       
    
        if(input == ''){
            
             var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "Error",
                    "title" : "Error",
                    "message" : 'Please contact your Insurance Admin',
                    "mode" : "sticky"
                });
                toastReference.fire();
             
        }
      
        
      /*  var exeAction = component.get("c.DownloadAttachment");
        exeAction.setParams({ 
            "parentRecID": input          
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                //console.log(res);
                if(res != null){
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url":res
                    });
                    urlEvent.fire();
                }else {
                    var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "Error",
                    "title" : "Error",
                    "message" : 'An error occurred during Initialization',
                    "mode" : "sticky"
                });
                toastReference.fire();
                }
                
                            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
                
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "Error",
                    "title" : "Error",
                    "message" : 'An error occurred during Initialization',
                    "mode" : "sticky"
                });
                toastReference.fire();
            }
        );
        */
    },
    editInsurance : function(component, event, helper){
       
           // var input =  event.target.id;
       
         var selectedSection = event.currentTarget;
        var index = selectedSection.dataset.filename;
        //alert(input)
        component.set("v.InsuranaceRecId",index);
        component.set("v.correctPopup",true);
        
        var exeAction = component.get("c.getEmpFamilyID");
        exeAction.setParams({ 
           
            "InsRecID":component.get("v.InsuranaceRecId")
            
        });
         exeAction.setCallback(this, function(response) {
            let state = response.getState();
             if (state === "SUCCESS") {
                
                   component.set("v.EmpFamRecID",response.getReturnValue()); 
                               
             }else if (state === "ERROR") {
                let errors = response.getError();
                
                 console.log('Error-getting Family id--'+errors[0].message);
             }
         
         });
         $A.enqueueAction(exeAction);
        
    },
    closeModelCorrection : function(component, event, helper){
        
        component.set("v.correctPopup",false);
    },
    
    handleSubmitCorrReq: function(component, event, helper){
       // event.preventDefault();
        
       
    },
    handleSuccessCorrReq: function(component, event, helper){
        var params = event.getParams();
        
        
        component.set("v.correctionRecId",params.response.id);
       component.set("v.correctPopup",false);        
            var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "success",
                    "title" : "success",
                    "message" : 'Correction request has been submitted',
                    "mode" : ""
                });
             toastReference.fire();
        
    },
    handleErrorCorrReq :function(component, event, helper){
        
    },
   
     handleUploadCaseCorr : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        var AllRowsList = component.get("v.Caseattachments");
        var concatArray = AllRowsList.concat(uploadedFiles)
        
        component.set('v.Caseattachments', concatArray);
      
    },
    
     clearCaseAttachment :function(component, event, helper){
        
        var selectedPillId = event.getSource().get("v.name");
        var titleIndex = event.getSource().get("v.title");
        var AllRowsList = component.get("v.Caseattachments");
        AllRowsList.splice(titleIndex, 1);
        
        component.set("v.Caseattachments",AllRowsList);
        
        var exeAction = component.get("c.deleteAttachment");
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
        

    },
    
    handleFilesChange: function(component, event, helper) {
        
        var fileName = event.getSource().get('v.name');    
        
       var uploadFile = event.getSource().get("v.files");
        

        
        if (event.getSource().get("v.files").length > 0) {
            
             var filelist = component.get("v.filesList");
            
            
             var files = event.getSource().get("v.files");
            
             for (var i = 0; i < files.length; i++) {
                                  
                 if(files[i].size < 2000000){
                    
                      filelist.push(files[i]);
                     
                     if(fileName == 'file1'){
                         
                         component.set("v.file1",true);
                         //alert(uploadFile[0].name);
                         component.set("v.file1Name",uploadFile[0].name);
                         
                     }else if (fileName == 'file2'){
                         // alert(uploadFile[0].name);
                         component.set("v.file2",true);
                         component.set("v.file2Name",uploadFile[0].name);
                     }
                     
                 }else {
                     
                     var toastReference = $A.get("e.force:showToast");
                     toastReference.setParams({
                         "type":"Error",
                         "title":"Error",
                         "message":"Please upload the file lower than 2MB",
                         "mode":"dismissible"
                     });
                     toastReference.fire();
                 }
               
                 
            } 
          
           component.set("v.filesList", filelist);
            
        }
       
    },
    
    submitReq : function(component, event, helper) {
        

      
    },
    
    removeFile : function(component, event, helper) {
        
        var selectedSection = event.currentTarget;
        var index = selectedSection.dataset.index;
        var indexName = selectedSection.dataset.filename;
               
        var removeList = component.get("v.filesList");
               
        removeList.splice(index, 1);
       
        component.set("v.filesList",removeList);
        
        
        if(indexName == component.get("v.file1Name")){
            
            component.set("v.file1",false);
        }
        if(indexName == component.get("v.file2Name")){
           
             component.set("v.file2",false);
            
        }
       
    },
    
    ViewInsurance : function(component, event, helper) {
        
        //var input =  event.target.id;
         var selectedSection = event.currentTarget;
        var index = selectedSection.dataset.filename;
        //alert(index)
        component.set("v.InsuranaceRecId",index);
         component.set("v.viewInsurance",true);

    },
    closeViewPopup : function(component, event, helper) {
        
        component.set("v.viewInsurance",false);

    },
    keyCheck : function(component,event,helper){
        
        //if ((event.which >=65 && event.which<=90)||(event.which >=97 && event.which<=122) || event.which==8 ){
        if (event.key.match(/[a-zA-Z]/g) ||event.key =='Backspace'){ 
        
        }else{
            event.preventDefault();
        } 
        
    },
    keyCheckNumber :function(component,event,helper){
        
        if (event.key.match(/[0-9]/g) ||event.key =='Backspace'){
            
            
        } else {
            event.preventDefault();
            
        }
    },
    stopSpecialChar : function(component,event,helper){
        
        if (event.key.match(/[a-zA-Z0-9-]/g) ||event.key =='Backspace'){
            
            
        } else {
            event.preventDefault();
            
        }
    }
    
})