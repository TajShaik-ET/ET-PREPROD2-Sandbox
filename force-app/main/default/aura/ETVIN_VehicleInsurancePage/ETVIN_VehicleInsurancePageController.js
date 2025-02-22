({
	
    
    doInit: function(component,event,helper){
        helper.getLoggedUserDetails(component, event, helper);
       
        helper.getPartnerList(component, event, helper);
        helper.getCorrPicklistVal(component, event, helper);
       // helper.getSearchResult(component, event, helper);
    },
    
    
    filterSearch :function(component, event, helper) {
        helper.getSearchResult(component, event, helper);
    },
    
    clearSearch : function(component, event, helper) {
        
       component.set("v.policyNumber",'');
        component.set("v.plateNumber",'');
        component.set("v.vehicleModel",'');
        component.set("v.chassisNumber",'');
        component.set("v.engineNumber",'');
        component.set("v.selectedSerachFilterValue",'All');
        //helper.getSearchResult(component, event, helper);
    },
    
    next : function(component, event, helper){
        var pageSize = component.get("v.pageSize");
        var start = component.get("v.start")+pageSize;
        component.set("v.start",start);
        helper.getCurrenetPageData(component, event, helper,start,pageSize);
        
    },
    
    previous : function(component, event, helper)    
    {        
        var pageSize = component.get("v.pageSize");
        var start = component.get("v.start");
        if(start > pageSize){
            start = start-pageSize;
        }else {
            
            start=0;
        }
        
        component.set("v.start",start);
        helper.getCurrenetPageData(component, event, helper,start,pageSize);
        
    },
    
    first : function(component, event, helper)    
    {        
        var pageSize = component.get("v.pageSize");        
        component.set("v.start",0);
        var start = component.get("v.start");
        helper.getCurrenetPageData(component, event, helper,start,pageSize);
        
    },
    
    last : function(component, event, helper)    
    {        
        var pageSize = component.get("v.pageSize"); 
        var total =component.get("v.totalSize");
        
        component.set("v.start",total-pageSize);
        var start = component.get("v.start");
        helper.getCurrenetPageData(component, event, helper,start,pageSize);
        
    },
    
    closeSingleRenwPrcss : function(component, event, helper) {
        
        component.set("v.singleInsuranceRenewalPopup", false);
    },
    
    confirmSingleProcss : function(component, event, helper) {
        
          var exeAction = component.get("c.singleRecRenewPrcss");
                exeAction.setParams({ 
                    
                    "recID":component.get("v.selectedRenewRecId")
                    
                });
                helper.serverSideCall(component,exeAction).then(
                    function(res) {
                       if(res =="Success"){
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "success",
                        "title" : "Success",
                        "message" : 'Renew request has been created',
                        "mode" : "dismissible"
                    });
                    toastReference.fire(); 
                    
                    $A.get('e.force:refreshView').fire();         
                }else {
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "error",
                        "title" : "error",
                        "message" : 'Renewal request is not created,Please check with system administrator',
                        "mode" : "dismissible"
                    });
                    toastReference.fire();
                }      
                        
                    }
                ).catch(
                    function(error) {
                        
                        console.log('Error---'+JSON.stringify(error));
                        
                        var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "error",
                    "title" : "error",
                    "message" : 'Renewal request is not created,Please check with system administrator',
                    "mode" : "dismissible"
                });
                toastReference.fire();
                    }
                );
                
    },
    
    OpenbulkRenewPrcss : function(component, event, helper) {
        
        component.set("v.bulkRenewVehiclePopup",true);
        component.set("v.RenewPrcBar", false);
    },
    
    closeBulkRenwPrcss: function(component, event, helper) {
        
      component.set("v.bulkRenewVehiclePopup", false);
    
       // $A.get('e.force:refreshView').fire();     
        
   },
    
     confirmBulkProcss : function(component, event, helper) {
        
        component.set("v.cnfrmBtn",true);
        component.set("v.RenewPrcBar", true);
        helper.callBatchClsRenwPrcs(component, event, helper);
    },
     handleRowAction : function(component, event, helper) {
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'show_details':
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/"+row.Id,
                    
                });
                urlEvent.fire();
                break;
            case 'correction':
                /* ----------- Correction Request - Start -----------*/     
              /*  var accounts={ ContactId:row.Employee__c, Insurance__c :row.Id }; */
                if(row.ETVIN_Insurance_Status__c =='Active'){
                component.set("v.VehicleID",row.Vehicle__c);
                component.set("v.VehicleInsRecID",row.Id);
                 component.set("v.rowInsCmpny",row.ETVIN_Insurance_Company__c);
                var exeAction = component.get("c.getRecordTypeId");
                exeAction.setParams({ 
                    "objName":"Correction_Cancel_Request__c",
                    "devName":"Correction_Request"
                });
                helper.serverSideCall(component,exeAction).then(
                    function(res) {
                        console.log('Res--'+res);
                       
                        component.set("v.CorrRecordTypeID",res);
                        component.set("v.CorrectionPopup",true);
                     
                      /*  var createRecordEvent = $A.get("e.force:createRecord");
                        createRecordEvent.setParams({
                            "entityApiName": "Case",
                            "recordTypeId" :res,
                            'defaultFieldValues': accounts
                        });
                        createRecordEvent.fire();*/
                    }
                ).catch(
                    function(error) {
                        
                        console.log('Error---'+JSON.stringify(error));
                    }
                );
                }else{
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "warning",
                        "title" : "warning",
                        "message" : 'You cannot create request for inactive insurance',
                        "mode" : "dismissible"
                    });
                    toastReference.fire();
                    
                }
                /* ----------- Correction Request - end -----------*/         
                break;
            case 'cancellation':
                /* ----------- Cancellation Request - Start -----------*/ 
                
                component.set("v.cancelPopup",true);
                 component.set("v.CaseCancStep1",true);   
                component.set("v.VehicleInsRecID",row.Id);
                component.set("v.rowVehicleId",row.Vehicle__c);
                component.set("v.rowInsCmpny",row.ETVIN_Insurance_Company__c);
                
               
                var exeAction = component.get("c.getRecordTypeId");
                exeAction.setParams({ 
                    "objName":"Correction_Cancel_Request__c",
                    "devName":"Cancellation_Request"
                });
                helper.serverSideCall(component,exeAction).then(
                    function(res) {
                      // console.log('can rectype'+res);
                        component.set("v.CancelRecordTypeID",res);
                    }
                ).catch(
                    function(error) {
                        
                        console.log('Error---'+JSON.stringify(error));
                    }
                );
                
                /* ----------- Cancellation Request - End -----------*/
                break;
                case 'Renewal':
                if(row.ETVIN_Is_Renewed__c){
                    var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "warning",
                    "title" : "warning",
                    "message" : 'This Insurance is already renewed',
                    "mode" : "dismissible"
                });
                toastReference.fire();
                }else if(row.ETVIN_Insurance_Status__c != 'Active'){
                    
                    var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "warning",
                    "title" : "warning",
                    "message" : 'Insurance should be active to renew',
                    "mode" : "dismissible"
                });
                toastReference.fire();
                }else {
                    
                   component.set("v.selectedRenewRecId",row.Id);
                   component.set("v.singleInsuranceRenewalPopup", true);
             
                }
                
                break;
             case 'Claim':
                
                var exeAction = component.get("c.getRecordTypeId");
                exeAction.setParams({ 
                    "objName":"ETIN_Claim__c",
                    "devName":"Vehicle_Insurance"
                });
                helper.serverSideCall(component,exeAction).then(
                    function(res) {
                       
                        component.set("v.ClaimInsRecType",res);
                    }
                ).catch(
                    function(error) {
                        
                        console.log('Error---'+JSON.stringify(error));
                    }
                );
                
                if(row.ETVIN_Insurance_Status__c == 'Active'){ 
                    
                component.set("v.claimPopup", true);
                component.set("v.claimStepOne", true);
                component.set("v.rowVehicleId",row.Vehicle__c);
                component.set("v.rowInsCmpny",row.ETVIN_Insurance_Company__c); 
                 component.set("v.VehicleInsRecID",row.Id);
                }else {
                      
                    var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "warning",
                    "title" : "warning",
                    "message" : 'Insurance should be active to Claim',
                    "mode" : "dismissible"
                });
                toastReference.fire();
                    
                }
                 
             break;
                /* vehicle Theft process - Start */
            case 'vehicleTheft':
                
                 component.set("v.theftPopup",true);
                 component.set("v.theftStep1",true);
                 component.set("v.VehicleInsRecID",row.Id);
                 component.set("v.rowVehicleId",row.Vehicle__c);
                 component.set("v.rowInsCmpny",row.ETVIN_Insurance_Company__c);
                
                var exeAction = component.get("c.getRecordTypeId");
                exeAction.setParams({ 
                    "objName":"Correction_Cancel_Request__c",
                    "devName":"Vehicle_Theft_Request"
                });
                helper.serverSideCall(component,exeAction).then(
                    function(res) {
                        // console.log('can rectype'+res);
                        component.set("v.theftRecordTypeID",res);
                    }
                ).catch(
                    function(error) {
                        
                        console.log('Error---'+JSON.stringify(error));
                    }
                );
                break;
                /* vehicle Theft process - End */
                
                /* available for mulkiya -start*/
              case 'vehicleOnline':  
                
                 component.set("v.rowVehicleId",row.Vehicle__c);
                component.set("v.rowInsCmpny",row.ETVIN_Insurance_Company__c);
                component.set("v.VehicleInsRecID",row.Id);
                
                //get recordType Id Available_for_Mulkiya
                 var exeAction = component.get("c.getRecordTypeId");
                exeAction.setParams({ 
                    "objName":"Correction_Cancel_Request__c",
                    "devName":"Available_for_Mulkiya"
                });
                helper.serverSideCall(component,exeAction).then(
                    function(res) {
                        // console.log('can rectype'+res);
                        component.set("v.mulkiyaRecordTypeId",res);
                    }
                ).catch(
                    function(error) {
                        
                        console.log('Error---'+JSON.stringify(error));
                    }
                );
                component.set("v.mulkiyaPopup",true);
               
                break;
                /* available for mulkiya -End*/                
        }
        
        
    },
     closeSingleRenwPrcss : function(component, event, helper) {
        
        component.set("v.singleInsuranceRenewalPopup", false);
    },
    closeMulkiyaModel :function(component, event, helper) {
        
        component.set("v.mulkiyaPopup",false);
    },
    
    confirmSingleProcss : function(component, event, helper) {
        
          var exeAction = component.get("c.singleRecRenewPrcss");
                exeAction.setParams({ 
                    
                    "recID":component.get("v.selectedRenewRecId"),
                    "PartnerId":component.get("v.selectedValue"),
                    "Prcs":component.get("v.RenewValue")
                    
                });
                helper.serverSideCall(component,exeAction).then(
                    function(res) {
                       if(res =="Success"){
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "success",
                        "title" : "Success",
                        "message" : 'Renew request has been created',
                        "mode" : "dismissible"
                    });
                    toastReference.fire(); 
                    
                    $A.get('e.force:refreshView').fire();         
                }else {
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "error",
                        "title" : "error",
                        "message" : 'Renewal request is not created,Please check with system administrator',
                        "mode" : "dismissible"
                    });
                    toastReference.fire();
                }      
                        
                    }
                ).catch(
                    function(error) {
                        
                        console.log('Error---'+JSON.stringify(error));
                        
                        var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "error",
                    "title" : "error",
                    "message" : 'Renewal request is not created,Please check with system administrator',
                    "mode" : "dismissible"
                });
                toastReference.fire();
                    }
                );
                
    },
    
    handleErrorCorrReq : function(component, event, helper) {
        
    },
    
    closeModelCorrectionPopup : function(component, event, helper)  {
        
        component.set("v.CorrectionPopup",false);
        component.set("v.CaseCorrStep3",false);
        component.set("v.CaseCorrStep2",false);
         component.set("v.CaseCorrStep1",true);
         component.set("v.CorrRecId",'');
        component.set('v.Caseattachments', []);
    },
     handleSubmitCorrReq : function(component, event, helper) {
        
       // event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        eventFields["Insurance_Company__c"] = component.get("v.rowInsCmpny");
        component.find('CorrForm').submit(eventFields); 
    },
    
     handleSuccessCorrReq : function(component, event, helper) {
        var params = event.getParams();
        
        component.set("v.CorrRecId",params.response.id); 
         
            component.set("v.CaseCorrStep2",true);
             component.set("v.CaseCorrStep1",false);
         
     /*   var selectedVal = component.get("v.CorrectionFor");
         
         if (selectedVal == 'Emirates ID'){
             
             component.set("v.CorreDocLabel","Emirates ID Copy");
             
         }else if (selectedVal == 'Name' || selectedVal == 'Gender' || selectedVal == 'DOB'){
             
              component.set("v.CorreDocLabel","Passport Copy");
             
         }else if (selectedVal == 'Marital Status'){
             
              component.set("v.CorreDocLabel","Marriage Certificate");
         }else if(selectedVal == 'Plan'){
             
             component.set("v.CorreDocLabel","Approval Document");
         }
         
         if(selectedVal == 'Employee ID'){
             component.set("v.CaseCorrStep3",true);
             component.set("v.CaseCorrStep1",false);
         }else {
             component.set("v.CaseCorrStep2",true);
             component.set("v.CaseCorrStep1",false);
             
         }*/
     },
    
    CorrForOnchange :function(component, event, helper){
     
        var selectedVal = component.find('CorrPickVal').get('v.value');
        component.set("v.SelectedCorrForVal",selectedVal);
        
      },
    
     closeClaimModel : function(component, event, helper) {
        
         component.set("v.claimPopup", false);
    },
     
    handleSubmitClaimReq : function(component, event, helper) {
        
        
        
    },
    handleSuccessClaimReq : function(component, event, helper) {
         
        var params = event.getParams();
      
        component.set("v.CliamRecId",params.response.id); 
       
        component.set("v.claimStepOne",false);
        component.set("v.claimStepTwo",true);
       helper.getClaimDocDetails(component, event, helper);
    },
    handleSubmitMulkiyaReq :function(component, event, helper) {
      
    },
    handleSuccessMulikyaReq: function(component, event, helper) {
        var record = event.getParam("response");
        var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "success",
                        "title" : "Success",
                        "message" : 'Request has been submitted to Insurance company',
                        "mode" : "dismissible"
                    });
                    toastReference.fire(); 
                
         component.set("v.mulkiyaPopup",false);
      
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": record.id
            
        });
        navEvt.fire();
    },
    
    handleErrorClaimReq :function(component, event, helper) {
        
    },
    
     handleUploadClaim :function(component, event, helper) {
        
         var uploadedFiles = event.getParam("files");
       var AllRowsList = component.get("v.ClaimAttachements");
        var concatArray = AllRowsList.concat(uploadedFiles)
        
        
        component.set('v.ClaimAttachements', concatArray);
        
    },
    
    clearClaimAttach :function(component, event, helper){
      
        var selectedPillId = event.getSource().get("v.name");
        var titleIndex = event.getSource().get("v.title");
        var AllRowsList = component.get("v.ClaimAttachements");
        AllRowsList.splice(titleIndex, 1);
       
        component.set("v.ClaimAttachements",AllRowsList);
        
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
    
      prevScrClaim : function(component, event, helper) {
        
        component.set("v.claimStepOne", true);  
        
         component.set("v.claimStepTwo",false);
    },
    submitClaim : function(component, event, helper) {
        
        var docList = component.get("v.ClaimDocList").length;
        var AttachList = component.get("v.ClaimAttachements").length;
        
        if(docList == AttachList){
        
        component.set("v.claimStepTwo", false);
        component.set("v.claimStepThree",true);
               
        }else {
            
            var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "Error",
                    "title" : "Error",
                    "message" : "One or More document is required",
                    "mode" : "dismissible"
                });
                toastReference.fire();
        }
          
    },
     openNewClaimPage : function(component, event, helper) {
        
        var recordId = component.get('v.CliamRecId');
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
           
        });
        navEvt.fire();
        
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
     caseCorrPrevbtn : function(component, event, helper) {
      
        component.set("v.CaseCorrStep1",true);
        component.set("v.CaseCorrStep2",false);
    },
    
    caseCorrNextbtn:function(component, event, helper) {
       
        var docList = component.get("v.Caseattachments").length;
              
        if(docList >= 1 ) {
            
        component.set("v.CaseCorrStep2",false);
        component.set("v.CaseCorrStep3",true);
            
        }else {
            var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "Error",
                    "title" : "Error",
                    "message" :"Correction support document is required",
                    "mode" : "dismissible"
                });
                toastReference.fire();
            
        }
       
        
    },
     openNewCorrDetailPage :function(component, event, helper) {
        
         var recordId = component.get('v.CorrRecId');
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
           
        });
        navEvt.fire();
        
    },
     closeCaneclModel : function(component, event, helper) {
        
        component.set("v.cancelPopup", false);
        component.set("v.CaseCancStep1", true);
       /* component.set("v.CaseCancStep2", false);
        component.set("v.CaseCancStep3", false);
        component.set("v.CaseCanRecID", '');*/
       component.set('v.Caseattachments', []);
    },
    
    handleSubmitCancelReq : function(component, event, helper) {
        
     // event.preventDefault();
     
        
    },
     handleSuccessCancelReq : function(component, event, helper) {
        
         var params = event.getParams();
         
         component.set("v.CaseCanRecID", params.response.id); 
          var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "success",
                        "title" : "Success",
                        "message" : 'Request has been created',
                        "mode" : "dismissible"
                    });
                    toastReference.fire(); 
         
         var navEvt = $A.get("e.force:navigateToSObject");
         navEvt.setParams({
             "recordId": params.response.id
             
         });
         navEvt.fire();
         
        /* var createAcountContactEvent = $A.get("e.force:createRecord");
         createAcountContactEvent.setParams({
             "entityApiName": "ETIN_Claim__c",
             "defaultFieldValues": {
                 'Claim_Amount__c' : '100',
                 'Claim_for__c' : 'Scrapped Vehicle Theft',
                 'ETIN_Claim_Status__c' : 'New',
                 
             }
         });
         createAcountContactEvent.fire();*/
         
       // component.set("v.CaseCancStep1", false);
       // component.set("v.CaseCancStep2", true);
        
        
    },
    getClaimForVal : function(component, event, helper) {
        
        
    },
    
    bulkUploadCancel : function(component, event, helper) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
       
        if (file){
            component.set("v.ShowSpinner",true);
            //console.log("File");
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                
                //console.log("EVT FN");
                var csv = evt.target.result;
                //console.log('csv file contains'+ csv);
                var result = helper.CSV2JSON(component,csv);
                //console.log('result = ' + result);
                //console.log('Result = '+JSON.parse(result));
                
                window.setTimeout($A.getCallback(function(){
                    helper.UploadDataToCRM(component,result);
                }), 10);
                
            }
            reader.onerror = function (evt) {
                //console.log("error reading file");
            }
        }else {
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":'Please choose file',
                "mode":"dismissible"
            });
            toastReference.fire();
        }
    },
    DownloadTemplate : function(component){
        
        var jsonStr = '{"rows":[{"vals":[{"val":"B0053602"},{"val":"2000"},{"val":"200"},{"val":"10"},{"val":"210"}]},{"vals":[{"val":"B0017298"},{"val":"2500.00"},{"val":"345"},{"val":"10"},{"val":"355"}]}],"headers":[{"title":"VehicleInternalNumber"},{"title":"InsuredValue"},{"title":"RefundPremium"},{"title":"RefundVAT"},{"title":"TotalAmount"}]}';
        var jsonData = JSON.parse(jsonStr);       
        var gridData = jsonData;
        // Spliting headers form table.
        var gridDataHeaders = gridData["headers"];
        // Spliting row form table.
        var gridDataRows = gridData["rows"];
        //  CSV download.
        var csv = '';
        for(var i = 0; i < gridDataHeaders.length; i++){         
            csv += (i === (gridDataHeaders.length - 1)) ? gridDataHeaders[i]["title"] : gridDataHeaders[i]["title"] + ','; 
        }
        csv += "\n";
        var data = [];
        for(var i = 0; i < gridDataRows.length; i++){
            var gridRowIns = gridDataRows[i];
            var gridRowInsVals = gridRowIns["vals"];
            var tempRow = [];
            for(var j = 0; j < gridRowInsVals.length; j++){                                     
                var tempValue = gridRowInsVals[j]["val"];
                if(tempValue.includes(',')){
                    tempValue = "\"" + tempValue + "\"";
                }
                tempValue = tempValue.replace(/(\r\n|\n|\r)/gm,"");                 
                tempRow.push(tempValue);
            }
            data.push(tempRow); 
        }
        data.forEach(function(row){
            csv += row.join(',');
            csv += "\n";
        });
        // 6. To download table in CSV format.
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_blank';
        hiddenElement.download = 'VehicleCancellationTemplate'+'.csv'; 
        hiddenElement.click();
    },
    
    closeTheftModel : function(component){
        
       component.set("v.theftPopup", false);
       component.set("v.theftStep1", true);
        
       component.set('v.Caseattachments', []);
    },
    
     handleSubmitTheftReq : function(component, event, helper) {
        
     // event.preventDefault();
     
        
    },
     handleSuccessTheftReq : function(component, event, helper) {
        

         var params = event.getParams();
         
         component.set("v.CaseCanRecID", params.response.id); 
          var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "success",
                        "title" : "Success",
                        "message" : 'Request has been created',
                        "mode" : "dismissible"
                    });
                    toastReference.fire(); 
         
         var navEvt = $A.get("e.force:navigateToSObject");
         navEvt.setParams({
             "recordId": params.response.id
             
         });
         navEvt.fire();
         
    },
    
     bulkUploadRenewal : function(component, event, helper) {
        var fileInput = component.find("file1").getElement();
        var file = fileInput.files[0];
       
        if (file){
            component.set("v.ShowSpinner",true);
            //console.log("File");
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                
                //console.log("EVT FN");
                var csv = evt.target.result;
                //console.log('csv file contains'+ csv);
                var result = helper.CSV2JSON(component,csv);
                //console.log('result = ' + result);
                //console.log('Result = '+JSON.parse(result));
                
                window.setTimeout($A.getCallback(function(){
                    helper.UploadRenewalDataToCRM(component,result);
                }), 10);
                
            }
            reader.onerror = function (evt) {
                //console.log("error reading file");
            }
        }else {
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Warning",
                "title":"Warning",
                "message":'Please choose file',
                "mode":"dismissible"
            });
            toastReference.fire();
        }
    },
    DownloadTemplateRenewal : function(component){
        
       var jsonStr = '{"rows":[{"vals":[{"val":"B0053602"},{"val":"2434343"},{"val":"20000"},{"val":"2021-12-01"},{"val":"2021-12-30"},{"val":"1641"},{"val":"1722.84"}]},{"vals":[{"val":"B0017298"},{"val":"121313"},{"val":"30000"},{"val":"2021-01-01"},{"val":"2021-12-30"},{"val":"1641"},{"val":"1722.84"}]}],"headers":[{"title":"VehicleInternalNumber"},{"title":"InsurancePolicyNumber"},{"title":"InsuredValue"},{"title":"EffectiveDate(YYYY-MM-DD)"},{"title":"ExpiryDate(YYYY-MM-DD)"},{"title":"PremiumExpense"},{"title":"InsurancePremiumWithVAT"}]}';
 
        var jsonData = JSON.parse(jsonStr);       
        var gridData = jsonData;
        // Spliting headers form table.
        var gridDataHeaders = gridData["headers"];
        // Spliting row form table.
        var gridDataRows = gridData["rows"];
        //  CSV download.
        var csv = '';
        for(var i = 0; i < gridDataHeaders.length; i++){         
            csv += (i === (gridDataHeaders.length - 1)) ? gridDataHeaders[i]["title"] : gridDataHeaders[i]["title"] + ','; 
        }
        csv += "\n";
        var data = [];
        for(var i = 0; i < gridDataRows.length; i++){
            var gridRowIns = gridDataRows[i];
            var gridRowInsVals = gridRowIns["vals"];
            var tempRow = [];
            for(var j = 0; j < gridRowInsVals.length; j++){                                     
                var tempValue = gridRowInsVals[j]["val"];
                if(tempValue.includes(',')){
                    tempValue = "\"" + tempValue + "\"";
                }
                tempValue = tempValue.replace(/(\r\n|\n|\r)/gm,"");                 
                tempRow.push(tempValue);
            }
            data.push(tempRow); 
        }
        data.forEach(function(row){
            csv += row.join(',');
            csv += "\n";
        });
        // 6. To download table in CSV format.
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_blank';
        hiddenElement.download = 'VehicleRenewalTemplate'+'.csv'; 
        hiddenElement.click();
    }
        
    
})