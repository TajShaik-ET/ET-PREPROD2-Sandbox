({
    doInit : function(component, event, helper) {
        console.log('doInit CaseB2BPopup');
        helper.setCommunityLanguage(component, event, helper);
        var lang = helper.getParameterByName(component, event, 'lang');
        component.set("v.lang", lang);
        helper.getLoggedInUserInfo(component,event,helper);
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        if( !$A.util.isEmpty(component.get('v.value')) ) {
            helper.searchRecordsHelper( component, event, helper, component.get('v.value') );
        }
        //var userId = $A.get("$SObjectType.CurrentUser.Id");
    },
    handleOnLoad : function(component, event, helper) {
        component.find("complaintTypeFeedback").set("v.value", "Feedback");
    },
    caseRatingChange : function(component, event, helper) {
        var rating = event.getParam("rating");
        component.find("caseRatingId").set("v.value",rating.toString());
    },
    handleOnSuccess : function(component, event, helper) {
        debugger;
        var filesData = component.get('v.fileList');
        var payload = event.getParams().response;
        console.log('payload '+payload.id);
        var casid=payload.id;
      if (filesData.length===0) {
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:showToast').setParams({
                "title": "Success",
                "message": "Case submitted successfully!",
                "type": "success",
            }).fire();
            
            var actionEvt = $A.get("e.c:ETST_sendDataEvent");
            actionEvt.setParams({
                "actionname": 'refresh'
            });
            
            actionEvt.fire();
        } else {
            helper.handlefileAttached(component, event, helper, casid);
        }
    },
    handleOnSubmit: function (component, event, helper) {
        debugger;
        component.set("v.Spinner",true);
        component.set("v.saveDisabled",true);
        if (helper.checkBeforeInsertValidation(component, event)) {
            helper.submitCase(component, event, helper);
        }
        
        event.preventDefault();
    },
    handleOnError: function (cmp, event, helper) {
      
        var error = event.getParams();
          alert('handleOnError errorMessage '+error);
        // Get the error message
        var errorMessage = event.getParam("message");
        alert('errorMessage '+errorMessage);
    },
    filesUpload: function(component, event, helper) {
        var uniqueName= event.getSource().get("v.name")
        component.set("v.selectedFileName",uniqueName);
        try{
            var files = component.get("v.uploadedDocs");
            console.log(files);
            var fileUploadWrapper = component.get("v.fileList");
            console.log(fileUploadWrapper);
            var contentWrapperArr = [];
            if(files && files.length > 0 && fileUploadWrapper.length < 3 ) {
                for(var i=0; i < files[0].length; i++){
                    var file = files[0][i];                    
                    if(file.size <= 1000000) {                        
                        var reader = new FileReader();
                        reader.name = file.name;
                        reader.type = file.type;                      
                        reader.onloadend = function(e) {
                            var base64 = reader.result.split(',')[1]
                            fileUploadWrapper.push({
                                'filename':file.name,
                                'filetype':file.type,
                                'base64':base64
                            });
                            contentWrapperArr.push({
                                'filename':file.name,
                                'filetype':file.type,
                                'base64':base64                   
                            });
                            console.log(fileUploadWrapper);
                            component.set("v.fileList",fileUploadWrapper);
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Success!",
                                "message": "File uploaded successfully.",
                                "type": "success"
                            });
                            toastEvent.fire();
                        }
                        function handleEvent(event) {
                            if(contentWrapperArr.length == i){
                                component.set("v.fileList",fileUploadWrapper);
                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                    }else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please upload file less than 1 MB.",
                            "mode": "sticky"
                        });
                        toastEvent.fire();
                    }
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You cannot upload more than 3 files.",
                    "mode": "sticky"
                });
                toastEvent.fire();
            }
        }catch (e){
            console.log(e.message);
        }
    },
    removeFile: function(component, event, helper) {
        var name = event.getSource().get("v.name");
        var value = event.getSource().get("v.value");
        console.log(name+' '+value);
        var fileList = component.get("v.fileList");
        for(var i=0; i<fileList.length; i++){
            if(fileList[i].filename == name && i == value){
                var group = component.get("v.fileList");
                group.splice(i, 1); 
                component.set("v.fileList", group);
            }
        }
    },
    // When a keyword is entered in search box
    searchRecords : function( component, event, helper ) {
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
            helper.searchRecordsHelper( component, event, helper, '' );
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    // When an item is selected
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }
            component.set('v.selectedRecord',selectedRecord);
            component.set('v.value',selectedRecord.value);
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    showRecords : function( component, event, helper ) {
        if(!$A.util.isEmpty(component.get('v.recordsList')) && !$A.util.isEmpty(component.get('v.searchString'))) {
            $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    // To remove the selected item.
    removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },
    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
})