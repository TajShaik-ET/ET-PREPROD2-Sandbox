({
    doInit : function(component, event, helper) {
        
        //helper.getAttachmentList(component, event, helper);
        helper.getPartnerList(component, event, helper);
        helper.getRenewBtnHelper(component, event, helper);
        
        helper.getLoggedUserDetails(component, event, helper);
        helper.getMasterPlanDet(component, event, helper);
        helper.getDefaultInsPartners(component, event, helper);
        helper.getCorrPicklistVal(component, event, helper);
      
        
    },
    
    filterSearch :function(component, event, helper) {
        helper.getSearchResult(component, event, helper);
    },
    
    clearSearch : function(component, event, helper) {
        
        component.set("v.cardNumber",'');
        component.set("v.employeeID",'');
        component.set("v.firstName",'');
        component.set("v.lastName",'');
        component.set("v.emiratesId",'');
        //component.set("v.employeeID",'');
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
    
    openModel :function(component, event, helper)  {
        
        component.set("v.isOpenModel",true);
        
        
        //helper.fetchPickListVal(component, 'ETIN_Department__c', 'empDept');         
        
    },
    insuranceTypeNext : function(component, event, helper)  {
        
        component.set("v.stepOne", true);
        component.set("v.InsuType", false);
        
    },
    empPrev : function(component, event, helper)  {
        component.set("v.stepOne", false);
        component.set("v.InsuType", false);
        component.set("v.LocStep",true);
        component.set("v.EmppaginationList",'');
        
    },
    
    closeModel: function(component, event, helper)  {
        
        component.set("v.isOpenModel",false);
        component.set("v.stepOne", true);
        component.set("v.stepTwo", false);
        component.set("v.stepThree", false);
        
        component.set("v.InsuType", false);
        component.set("v.con_EmpID",'');
        component.set("v.con_Lastname",'');
        component.set("v.con_firstName",'');
        component.set("v.SelectedVal",'');
        component.set("v.EmppaginationList",null);
        component.set("v.EmpSelectedRows",null);
        //component.set("v.LocStep",true);
        
        
    },
    
    closeModelCorrectionPopup : function(component, event, helper)  {
        
        component.set("v.CorrectionPopup",false);
        component.set("v.CaseCorrStep3",false);
        component.set("v.CaseCorrStep2",false);
        component.set("v.CaseCorrStep1",true);
        component.set("v.CaseCorrRecId",'');
        component.set('v.Caseattachments', []);
    },
    /*   InsuranceNew : function(component, event, helper) {
        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "ETIN_Insurance__c"
        });
        createRecordEvent.fire();
        component.set("v.isOpenModel",false);
    },
    
    caseCorrection :  function(component, event, helper) {
        
        var exeAction = component.get("c.getRecordTypeId");
        exeAction.setParams({ 
            "objName":"Case",
            "devName":"Correction_Request"
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('Res--'+res);
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Case",
                    "recordTypeId" :res
                });
                createRecordEvent.fire();
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        component.set("v.isOpenModel",false);
        
    },
    
    caseCancellation :  function(component, event, helper) {

        var exeAction = component.get("c.getRecordTypeId");
        exeAction.setParams({ 
            "objName":"Case",
            "devName":"Cancellation_Request"
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                console.log('Res--'+res);
                var createRecordEvent = $A.get("e.force:createRecord");
                createRecordEvent.setParams({
                    "entityApiName": "Case",
                    "recordTypeId" :res
                });
                createRecordEvent.fire();
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        component.set("v.isOpenModel",false);
        
    },*/
    
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
                //var accounts={ ContactId:row.Employee__c, Insurance__c :row.Id };
                if(row.Insurance_Current_Status__c == 'Active'){
                    
                    component.set("v.ShowFamilyClaim",false);
                    component.set("v.EmpFamilyId",'');
                    component.set("v.caseContactId",row.EmployeeAcc__c);
                    component.set("v.caseInsurId",row.Id);
                    
                    if(row.Employee_Family__c){
                        component.set("v.EmpFamilyId",row.Employee_Family__c); 
                        component.set("v.EmpRelationVal",row.Relation__c);
                        component.set("v.ShowFamilyClaim",true);
                        
                    }
                    
                    var exeAction = component.get("c.getRecordTypeId");
                    exeAction.setParams({ 
                        "objName":"Case",
                        "devName":"ETIN_Health_Correction_Request"
                    });
                    helper.serverSideCall(component,exeAction).then(
                        function(res) {
                            // console.log('Res--'+res);
                            
                            component.set("v.CaseHealthRecordTypeID",res);
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
                }else {
                    helper.ErrorMsgHandler('Insurance should be active','warning');
                }
                /* ----------- Correction Request - end -----------*/         
                break;
            case 'cancellation':
                /* ----------- Cancellation Request - Start -----------*/ 
                if(row.Insurance_Current_Status__c == 'Active'){
                    component.set("v.ShowFamilyClaim",false);
                    component.set("v.EmpFamilyId",'');
                    
                    component.set("v.cancelPopup",true);
                    component.set("v.caseContactId",row.EmployeeAcc__c);
                    component.set("v.caseInsurId",row.Id);
                    if(row.Employee_Family__c){
                        component.set("v.EmpFamilyId",row.Employee_Family__c); 
                        component.set("v.EmpRelationVal",row.Relation__c);
                        component.set("v.ShowFamilyClaim",true);
                        
                    }
                    
                    var exeAction = component.get("c.getRecordTypeId");
                    exeAction.setParams({ 
                        "objName":"Case",
                        "devName":"ETIN_Health_Cancellation_Request"
                    });
                    helper.serverSideCall(component,exeAction).then(
                        function(res) {
                            // console.log('can rectype'+res);
                            component.set("v.CaseHealthCancelRecordTypeID",res);
                        }
                    ).catch(
                        function(error) {
                            
                            console.log('Error---'+JSON.stringify(error));
                        }
                    );}else {
                        helper.ErrorMsgHandler('Insurance should be active','warning');
                    }
                
                /* ----------- Cancellation Request - End -----------*/
                break;
            case 'Renewal':
                if(row.Renew_Status__c){
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "warning",
                        "title" : "warning",
                        "message" : 'This Insurance is already renewed',
                        "mode" : "dismissible"
                    });
                    toastReference.fire();
                }else if(row.Insurance_Current_Status__c != 'Active'){
                    
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
                    component.set("v.singleRenewHelathPopup", true); 
                    
                }
                
                break;
            case 'Claim':
                if(row.Insurance_Current_Status__c == 'Active'){
                component.set("v.ShowFamilyClaim",false);
                component.set("v.EmpFamilyId",'');
                component.set("v.claimPopup", true);
                component.set("v.claimStepOne", true);
                component.set("v.caseContactId",row.EmployeeAcc__c);
                component.set("v.rowInsCmpny",row.Insurance_Company__c);  
                component.set("v.InsEmpID",row.EmployeeAcc__r.ETIN_Employee_Id__c);
                component.set("v.InsCardNumber",row.Card_Number__c);
                component.set("v.ClaimInsPolicy",row.Id);
                if(row.Employee_Family__c){
                    component.set("v.EmpFamilyId",row.Employee_Family__c); 
                    component.set("v.EmpRelationVal",row.Relation__c);
                    component.set("v.ShowFamilyClaim",true);
                    
                }
                }else{
                    helper.ErrorMsgHandler('Insurance should be active','warning');
                }
                
                
                break;
                
        }
        
        
    },
    
    closeClaimModel : function(component, event, helper) {
        
        component.set("v.claimPopup", false);
    },
    
    prevScrClaim : function(component, event, helper) {
        
        component.set("v.claimStepOne", true);  
        
        component.set("v.claimStepTwo",false);
    },
    submitClaim : function(component, event, helper) {
        
        var AttachList = component.get("v.ClaimAttachements").length;
        var docList2 = component.get("v.ClaimDocList");
        
        var truevalues = docList2.filter(function(element) {
            return (element.Mandatory__c == true);
        });
        
        if(truevalues.length <= AttachList){
            
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
    
    /* ----------Employee Dyamic search --------*/
    EmpclearSearch : function(component, event, helper) {
        
        component.set("v.con_EmpID",'');
        component.set("v.con_Lastname",'');
        component.set("v.con_firstName",'');
        component.set("v.SelectedVal",'');
        component.set("v.EmppaginationList",null);
        
    },
    
    EmpFilterSearch :  function(component, event, helper) {
        
        if(component.get("v.con_firstName") || component.get("v.con_Lastname") || component.get("v.con_EmpID")) {
            
            var exeAction = component.get("c.getEmployeeDetails");
            component.set('v.EmpColumns', [ 
                {label: 'Full Name', fieldName: 'link2', type: 'url',typeAttributes: { label:  { fieldName: 'Name' }, target:'_blank'}},
                {label: 'Employee ID', fieldName: 'ETIN_Employee_Id__c', type: 'text'},
                //{label: 'Relation', fieldName: 'ETIN_Relation__c', type: 'text'},
                {label: 'Visa Emirate', fieldName: 'ETIN_Place_of_Visa_Issuance__c', type: 'text'}
            ]);
            
            exeAction.setParams({
                "EmpID":component.get("v.con_EmpID"),
                "firstName": component.get("v.con_firstName"),
                "lastName": component.get("v.con_Lastname"),
                "Dept": component.get("v.SelectedVal"),
                "location": component.get("v.EmpLocation")
            });
            console.log(component.get("v.con_EmpID")+'--'+component.get("v.EmpLocation"))
            helper.serverSideCall(component,exeAction).then(
                function(res) {
                    
                    var records =res;
                    records.forEach(function(record){
                        record.link2 = '/'+record.Id;
                        
                    });
                    
                    console.log('Res'+JSON.stringify(res));
                    component.set("v.EmppaginationList",res);
                }
            ).catch(
                function(error) {
                    
                    console.log('Emp Search Error---'+JSON.stringify(error));
                }
            );
        }else {
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type" : "Warning",
                "title" : "Warning",
                "message" : "Please enter employee detail",
                "mode" : "dismissible"
            });
            toastReference.fire();
        }
    },
    getSelectedRow : function(component, event, helper) {
        
        var selectedRows = event.getParam('selectedRows');
        
        component.set("v.EmpSelectedRows",selectedRows);
        console.log('selectedRows'+selectedRows);
        
    },
    empDetailPrevious : function(component, event, helper) {
        
        component.set("v.stepOne",true);  
        component.set("v.stepTwo",false); 
        component.set("v.PrgsBarCurntStep","1"); 
        //helper.fetchPickListVal(component, 'ETIN_Department__c', 'empDept'); 
        
        component.set("v.EmpSelectedRows",null);
    },
    empNext : function(component, event, helper) {
        
        component.set("v.hideFields",false); 
        /* --  Getting Insurance Health record type -- Start ---- */
        var exeAction = component.get("c.getRecordTypeId");
        exeAction.setParams({ 
            "objName":"ETIN_Insurance__c",
            "devName":"Health_Insurance"
        });
        
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                component.set("v.InsRecordTypeID",res);  
                // console.log(res+'Health RecType ID');
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        /* --  Getting Insurance Health record type -- End ---- */
        
        var selectedRecord = component.get("v.EmpSelectedRows");
        component.set("v.emiratesIdVal",selectedRecord[0].ET_Emirates_Id__c);
        
        var selectedVal = component.get('v.selectedInsType');
        
        
        if(selectedRecord && selectedRecord.length == '1'){
            
            component.set("v.empValue",selectedRecord[0].Id); 
            
            var salaryBand = selectedRecord[0].ETIN_Gross_Salary__c;
            component.set("v.GrossSal",salaryBand);
            
            var masterInsPlans = JSON.parse(component.get("v.MasterInsPlan"));
            console.log('masterInsPlans'+masterInsPlans);
            
            for(var i=0; i < masterInsPlans.length; i++){
                
                if( masterInsPlans[i].Emirates__c == selectedRecord[0].ETIN_Place_of_Visa_Issuance__c && salaryBand <= masterInsPlans[i].Salary__c  && masterInsPlans[i].Condition__c == 'Less or Equal' ){
                    
                    console.log('-mater-1-'+masterInsPlans[i].Plans__c); 
                    component.set("v.setPlanValue",masterInsPlans[i].Plans__c);
                    
                }
                if( masterInsPlans[i].Emirates__c == selectedRecord[0].ETIN_Place_of_Visa_Issuance__c && salaryBand > masterInsPlans[i].Salary__c  && masterInsPlans[i].Condition__c == 'More' ){
                    
                    console.log('-master-2-'+masterInsPlans[i].Plans__c); 
                   console.log(salaryBand+'--'+masterInsPlans[i].Salary__c); 
                    component.set("v.setPlanValue",masterInsPlans[i].Plans__c);
                    
                }
            } 
            
            
            var AllowtoNext = false;
            
            helper.getDocumentUploadList(component, event, helper,selectedRecord[0].ETIN_Place_of_Visa_Issuance__c);
            
            
            var defList =component.get("v.DefaultInsPartnerList"); 
            
            
            if(selectedRecord[0].ETIN_Place_of_Visa_Issuance__c == defList[1].Name){
                var accId =   defList[1].Account_ID__c;            //$A.get("$Label.c.ETIN_Dubai");
                AllowtoNext = true;
                component.set("v.hideFields",true);
                
            }else if (selectedRecord[0].ETIN_Place_of_Visa_Issuance__c == defList[0].Name){
                var accId =  defList[0].Account_ID__c; //$A.get("$Label.c.ETIN_Abu_dhabi");
                AllowtoNext = true; 
            }else {
                
                var accId =   defList[1].Account_ID__c; //set dubai insurance company for other emirates except Abudhabi           
                AllowtoNext = true;
                //Commented by Janardhan - 01/08/2022
                /*var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : "Error",
                    "title" : "Error",
                    "message" : "Your are not eligible to apply Insurance other than Dubai and Abu dhabi",
                    "mode" : "dismissible"
                });
                toastReference.fire();*/
                
            }
            if(selectedRecord[0].ETIN_Employee_Status__c == 'Inactive'){
                
                AllowtoNext = false;
                helper.ErrorMsgHandler('Empolyee is inactive','Warning');
                
            }else{
                AllowtoNext = true;
            }
            
            component.set("v.InsuranceAccId",accId);
            if(AllowtoNext){  
                component.set("v.stepOne",false);  
                component.set("v.stepTwo",true); 
                component.set("v.PrgsBarCurntStep","2");
            }
        }else {
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type" : "Warning",
                "title" : "Warning",
                "message" : "Please select one record",
                "mode" : "dismissible"
            });
            toastReference.fire();
        }
    },
    handleError : function(component, event, helper) {
        
        // alert('Error Here' +event);
        // console.log(event);
        var errors = event.getParams();
        console.log("Error Response", JSON.stringify(errors));
    },
    handleSubmit :function(component, event, helper) {
        // event.preventDefault();
        
    },
    
    handleSuccess : function(component, event, helper) {
        var params = event.getParams();
        
        component.set("v.NewInsuRecId",params.response.id); 
        //alert('new--'+component.get("v.NewInsuRecId"));
        component.set("v.stepTwo",false); 
        component.set("v.stepThree",true);
        // component.set("v.stepFour",true);
        component.set("v.PrgsBarCurntStep","3");
        
        
    },
    
    handleUploadFinished : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        
        var documentId = uploadedFiles[0].documentId;
        
        helper.UpdateDocument(component,event,helper,documentId);
        
        helper.getAttachmentList(component, event, helper);
        
    },
    
    handleUploadCaseCorr : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        var AllRowsList = component.get("v.Caseattachments");
        var concatArray = AllRowsList.concat(uploadedFiles)
        
        
        component.set('v.Caseattachments', concatArray);
        // console.log(JSON.stringify(AllRowsList)+'---upload files');
        //helper.getCaseAttachmentList(component, event, helper);
        
    },
    
    previewFile :function(c,e,h){
        var selectedPillId = e.getSource().get("v.name");
        $A.get('e.lightning:openFiles').fire({
            recordIds: [selectedPillId]
        });
    },
    
    clearAttachment :function(component, event, helper){
        
        component.set("v.step3Spinner",true);
        
        var selectedPillId = event.getSource().get("v.name");
        
        /*    var titleIndex = event.getSource().get("v.title");
        var AllRowsList = component.get("v.attachments");
        AllRowsList.splice(titleIndex, 1);
       
        component.set("v.attachments",AllRowsList);
        
        */
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
        
        helper.getAttachmentList(component, event, helper);
        
        component.set("v.step3Spinner",false);
        
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
        
        // helper.getCaseAttachmentList(component, event, helper);
        
        
        
    },
    
    handleUploadFinishedProfile : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        
        component.set("v.profileContentDocId",documentId);
        var exeAction = component.get("c.getImageContent");
        exeAction.setParams({ 
            "docId": documentId          
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                // console.log(res);
                component.set("v.imgDisplayId",'/sfc/servlet.shepherd/version/download/'+res);
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
        $A.util.toggleClass(component.find('newPic'), 'slds-hide');
        $A.util.toggleClass(component.find('basePic'), 'slds-hide');
        $A.util.toggleClass(component.find('removeBtn'), 'slds-hide');
        $A.util.toggleClass(component.find('uploadBtn'), 'slds-hide');
    },
    
    removeProfilePic : function(component, event, helper) {
        
        var imgdocid = component.get("v.profileContentDocId");
        
        var exeAction = component.get("c.deleteAttachment");
        exeAction.setParams({ 
            "contentDocId": imgdocid          
        });
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                // console.log(res+'Prof Pic');
                //component.set("v.imgDisplayId",'');
                $A.util.toggleClass(component.find('newPic'), 'slds-hide');
                $A.util.toggleClass(component.find('basePic'), 'slds-hide');
                $A.util.toggleClass(component.find('removeBtn'), 'slds-hide');
                $A.util.toggleClass(component.find('uploadBtn'), 'slds-hide');
                
                
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        
        
    },
    
    StepThreeNextBtn :  function(component, event, helper) {
        
        var docList = component.get("v.MasterDocList");
        var AttachList = component.get("v.attachments").length;
        
        var truevalues = docList.filter(function(element) {
            return (element.Mandatory__c == true);
        });
        
        console.log(truevalues.length+'--'+AttachList)
        if(truevalues.length <= AttachList ){
            
           /* component.set("v.stepThree", false);
            //component.set("v.stepFour", true);
            component.set("v.PrgsBarCurntStep","4");
            component.set("v.stepFive", true); */
            var recordId = component.get('v.NewInsuRecId');
            
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": recordId
                
            });
            navEvt.fire();
            
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
    
    StepThreePrevBtn :  function(component, event, helper) {
        
        component.set("v.stepTwo", true);
        component.set("v.stepThree", false);
        component.set("v.PrgsBarCurntStep","2");
        
    },
    StepFourPrevBtn :  function(component, event, helper) {
        
        component.set("v.stepThree", true);
        component.set("v.stepFour", false);
        component.set("v.PrgsBarCurntStep","3"); 
        
        /*   component.set("v.stepTwo", true);
        component.set("v.stepFour", false);
        component.set("v.PrgsBarCurntStep","2"); */
         
     },
    
    StepFourNextBtn :  function(component, event, helper) {
        
        component.set("v.stepFour", false);
        component.set("v.stepFive", true);
        component.set("v.PrgsBarCurntStep","4");
        
    },
    openNewRecDetailPage : function(component, event, helper) {
        
        var recordId = component.get('v.NewInsuRecId');
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
            
        });
        navEvt.fire();
    },
    closePrgrsWindw : function(component, event, helper) {
        
        component.set("v.isOpenModel",false);
        component.set("v.stepOne", true);
    },
    
    handleSuccessCorrReq : function(component, event, helper) {
        var params = event.getParams();
        
        component.set("v.CaseCorrRecId",params.response.id); 
        
        var selectedVal = component.get("v.CorrectionFor");
        
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
            
        }
        
        
        
        /*    var params = event.getParams();
          
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": params.response.id
           
        });
        navEvt.fire(); */
         
         
         
         
     },
    handleSubmitCorrReq : function(component, event, helper) {
        // alert();
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        eventFields["ETIN_Correction_for__c"] = component.get("v.SelectedCorrForVal");
        component.find('CorrForm').submit(eventFields);
    },
    
    caseCorrPrevbtn : function(component, event, helper) {
        //alert(component.get("v.CaseCorrRecId"));
        component.set("v.CaseCorrStep1",true);
        component.set("v.CaseCorrStep2",false);
    },
    
    caseCorrNextbtn:function(component, event, helper) {
        
        var docList = component.get("v.Caseattachments").length;
        var selectedVal = component.get("v.CorrectionFor");
        
        if(docList >= 1 && selectedVal != 'Employee ID') {
            
            component.set("v.CaseCorrStep2",false);
            component.set("v.CaseCorrStep3",true);
            
        }else if(selectedVal != 'Employee ID'){
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type" : "Error",
                "title" : "Error",
                "message" : component.get("v.CorreDocLabel")+" is required",
                "mode" : "dismissible"
            });
            toastReference.fire();
            
        }
        
        
    },
    
    handleErrorCorrReq : function(component, event, helper) {
        
    },
    openNewCaseDetailPage :function(component, event, helper) {
        
        var recordId = component.get('v.CaseCorrRecId');
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
            
        });
        navEvt.fire();
        
    },
    
    openNewCaseCancelDetailPage :function(component, event, helper) {
        
        var recordId = component.get('v.CaseCanRecID');
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
            
        });
        navEvt.fire();
        
    },
    caseCancNextbtn : function(component, event, helper) {
        
        var docList = component.get("v.Caseattachments").length;
        
        if(docList >= 1) {
            component.set("v.CaseCancStep2",false);
            component.set("v.CaseCancStep3",true);
        }else {
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type" : "Error",
                "title" : "Error",
                "message" : "ET Visa cancellation document is required",
                "mode" : "dismissible"
            });
            toastReference.fire();
            
        }
        
    },
    
    OpenbulkRenewPrcss : function(component, event, helper) {
        
        component.set("v.bulkRenewHelathPopup",true);
        component.set("v.RenewPrcBar", false);
    },
    closeBulkRenwPrcss: function(component, event, helper) {
        
        component.set("v.bulkRenewHelathPopup", false);
        
        // $A.get('e.force:refreshView').fire();     
        
    },
    
    confirmBulkProcss : function(component, event, helper) {
        
        component.set("v.cnfrmBtn",true);
        component.set("v.RenewPrcBar", true);
        helper.callBatchClsRenwPrcs(component, event, helper);
    },
    
    closeCaneclModel : function(component, event, helper) {
        
        component.set("v.cancelPopup", false);
        component.set("v.CaseCancStep1", true);
        component.set("v.CaseCancStep2", false);
        component.set("v.CaseCancStep3", false);
        component.set("v.CaseCanRecID", '');
        component.set('v.Caseattachments', []);
    },
    handleSubmitCancelReq : function(component, event, helper) {
        
        //event.preventDefault();
        
    },
    handleSuccessCancelReq : function(component, event, helper) {
        
        var params = event.getParams();
        
        component.set("v.CaseCanRecID", params.response.id); 
        /* var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": params.response.id
           
        });
        navEvt.fire();*/
        component.set("v.CaseCancStep1", false);
        component.set("v.CaseCancStep2", true);
        
        var cancelReason = component.get("v.CancellationReasonVal");
        var finalLabel = 'Related Document';
        if(cancelReason == 'Aunak Card' || cancelReason == 'Thiqa Card'){
            finalLabel = cancelReason+' Copy';
        }else if(cancelReason == 'Out of UAE'){
            finalLabel = 'Exit Stamp Copy';
        }else if(cancelReason == 'End of Service'){
            
            finalLabel ='ET Visa Copy';
        }
        
        component.set("v.CancelDocLabel", finalLabel);       
        
        
    },
    handleErrorCancelReq : function(component, event, helper) {
        
    },
    caseCancPrevbtn : function(component, event, helper) {
        component.set("v.CaseCancStep1", true);
        component.set("v.CaseCancStep2", false);
        
    },
    
    closeSingleRenwPrcss : function(component, event, helper) {
        
        component.set("v.singleRenewHelathPopup", false);
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
                    
                    component.set("v.singleRenewHelathPopup", false);
                    helper.getSearchResult(component, event, helper);
                    //$A.get('e.force:refreshView').fire();    
                    
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
    
    handleSubmitClaimReq : function(component, event, helper) {
        
    },
    
    handleSuccessClaimReq : function(component, event, helper) {
        
        var params = event.getParams();
        
        component.set("v.CliamRecId",params.response.id); 
        component.set("v.claimStepOne",false);
        component.set("v.claimStepTwo",true);
        helper.getClaimDocDetails(component, event, helper);
        
    },
    
    handleErrorClaimReq : function(component, event, helper) {
        
        
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
    
    CorrForOnchange :function(component, event, helper){
        
        var selectedVal = component.find('CorrPickVal').get('v.value');
        component.set("v.SelectedCorrForVal",selectedVal);
        
        if(selectedVal== 'Employee ID'){
            component.set("v.CorrLabelName",'Save');
        }else {
            component.set("v.CorrLabelName",'Next');
        }
    },
    
    DownloadTemplate : function(component){
        
        var jsonStr = '{"rows":[{"vals":[{"val":"ETIN-0000010"},{"val":"1241323"},{"val":"23/235/233"}]},{"vals":[{"val":"ETIN-0000012"},{"val":"132634"},{"val":"34/345/23/2"}]}],"headers":[{"title":"InsRefNumber"},{"title":"CardNumber"},{"title":"PolicyNumber"}]}';
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
        hiddenElement.download = 'SampleUpdateTemplate'+'.csv'; 
        hiddenElement.click();
    },
    
    openFamilyModel : function(component){
        
        component.set("v.OpenFamPopup", true);
    },
    
    closeFamilyModel : function(component){
        
        component.set("v.OpenFamPopup", false);
        component.set("v.FamilyStepOne",true);
        component.set("v.FamilyStepTwo",false);
        component.set("v.FamilyStepThree",false);
        component.set("v.FamilyStepFour",false);
        component.set("v.FampaginationList",null);
        component.set("v.FamilySelectedRows",null);
    },
    FamclearSearch : function(component, event, helper) {
        
        component.set("v.con_EmpID",'');
        component.set("v.con_Lastname",'');
        component.set("v.con_firstName",'');
        component.set("v.SelectedVal",'');
        component.set("v.FampaginationList",null);
        component.set("v.FamilySelectedRows",null);
       
    },
    
    FamFilterSearch :  function(component, event, helper) {
        
        if(component.get("v.con_EmpID") ||component.get("v.con_firstName")||component.get("v.con_Lastname")){
             helper.FamFilterSearchHelper(component, event, helper);
        }else {
            
            helper.ErrorMsgHandler('Please enter empolyee details','warning');
        }
        
       
    },
    openNewFamAdd : function(component){
        
        component.set("v.OpenNewFamAdd",true);
    },
    closeNewFamCreModel : function(component){
        
        component.set("v.OpenNewFamAdd",false);
    },
    handleSubmitFamilyReq : function(component){},
    
    handleSuccessFamilyReq : function(component,event,helper){
        
        var params = event.getParams();
        //alert(params.response.id)
        component.set("v.FamilyRecId",params.response.id); 
        
        component.set("v.OpenNewFamAdd",false); 
        helper.FamFilterSearchHelper(component, event, helper);
        
        
    },
    handleErrorFamilyReq : function(component){},
    handleFamilySubmit :function(component,event,helper){
        
        event.preventDefault(); // stop form submission
        
        var selectedRecord = component.get("v.FamilySelectedRows"); 
        helper.getDocumentUploadList(component, event, helper,selectedRecord[0].Place_of_Visa_Issuance__c);
        
         var labelValue = $A.get("$Label.c.Insurance_AbuDhabiSet")
        if(labelValue.includes(selectedRecord[0].Place_of_Visa_Issuance__c)){
        
        
       /* if(selectedRecord[0].Place_of_Visa_Issuance__c == 'Abu Dhabi' || selectedRecord[0].Place_of_Visa_Issuance__c == 'GCC - Abu Dhabi' || selectedRecord[0].Place_of_Visa_Issuance__c == 'UAE Nationality - Abu Dhabi' ){ */
            
            var eventFields = event.getParam("fields");
            component.find('EmpFamilyForm').submit(eventFields);
            
        }else {
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type" : "Error",
                "title" : "Warning",
                "message" : "You cannot add family insurnace to the selected emirate",
                "mode" : "dismissible"
            });
            toastReference.fire();
        }
        
        
    },
    handleFamilySuccess :function(component,event){
        
        var params = event.getParams();
        component.set("v.NewInsuFamilyRecId",params.response.id);
        component.set("v.FamilyStepTwo",false);
        component.set("v.FamilyStepThree",true);
        component.set("v.PrgsBarFamilyStep",'3');
        
        
    },
    
    GoToNewInsurance : function(component,event,helper){
        
        
        
        var exeAction = component.get("c.getRecordTypeId");
        exeAction.setParams({ 
            "objName":"ETIN_Insurance__c",
            "devName":"Health_Insurance"
        });
        
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                component.set("v.InsRecordTypeID",res);  
                // console.log(res+'Health RecType ID');
            }
        ).catch(
            function(error) {
                
                console.log('Error---'+JSON.stringify(error));
            }
        );
        var selectedRecord = component.get("v.FamilySelectedRows"); 
        
        if(selectedRecord && selectedRecord.length == '1'){
            component.set("v.FamilyStepTwo",true); 
            component.set("v.FamilyStepOne",false); 
            component.set("v.PrgsBarFamilyStep",'2'); 
            component.set("v.empValue",selectedRecord[0].Employee__c);
            component.set("v.EmpFamilyInsID",selectedRecord[0].Id);
            component.set("v.EmpFamRelationVal",selectedRecord[0].Relation__c);
            
            var salaryBand = selectedRecord[0].Employee__r.ETIN_Gross_Salary__c;
            
            component.set("v.GrossSalFam",salaryBand);
                       
            var masterInsPlans = JSON.parse(component.get("v.MasterInsPlan"));
            
            for(var i=0; i < masterInsPlans.length; i++){
                
                if( masterInsPlans[i].Emirates__c == selectedRecord[0].Place_of_Visa_Issuance__c && salaryBand <= masterInsPlans[i].Salary__c  && masterInsPlans[i].Condition__c == 'Less or Equal' ){
                    
                    //console.log(masterInsPlans[i].Plans__c); 
                    component.set("v.setFamPlanValue",masterInsPlans[i].Plans__c);
                    
                }
                if( masterInsPlans[i].Emirates__c == selectedRecord[0].Place_of_Visa_Issuance__c && salaryBand > masterInsPlans[i].Salary__c  && masterInsPlans[i].Condition__c == 'More' ){
                    
                    //console.log(masterInsPlans[i].Plans__c); 
                    component.set("v.setFamPlanValue",masterInsPlans[i].Plans__c);
                    
                }
            } 
            
            var defList =component.get("v.DefaultInsPartnerList"); 
            var accID ='';
            
            if(selectedRecord[0].Place_of_Visa_Issuance__c == defList[0].Name){
                
                accID = defList[0].Account_ID__c;  
                component.set("v.InsuranceFamAccId",accID);
            }
            
            
            
        }else{
            
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type" : "Warning",
                "title" : "Warning",
                "message" : "Please select one record",
                "mode" : "dismissible"
            });
            toastReference.fire();
        } 
    },
    goToFamFirstStep : function(component){
        
        component.set("v.FamilyStepTwo",false); 
        component.set("v.FamilyStepOne",true); 
        component.set("v.PrgsBarFamilyStep",'1');
        //component.set("v.FampaginationList",null);
        component.set("v.FamilySelectedRows",null);
    },
    
    getSelectedRowFamily : function(component, event, helper) {
        
        var selectedRows = event.getParam('selectedRows');
        
        component.set("v.FamilySelectedRows",selectedRows);        
        
    },
    goToInsFamilyStep :function(component, event, helper) {
        component.set("v.FamilyStepTwo",true);
        component.set("v.FamilyStepThree",false);
        component.set("v.PrgsBarFamilyStep",'2');
    },
    gotoCompleteStep :function(component, event, helper) {
        
        
        
        var docList = component.get("v.MasterDocList");
        var AttachList = component.get("v.attachments").length;
        
        var truevalues = docList.filter(function(element) {
            return (element.Mandatory__c == true);
        });
        
        
        if(truevalues.length <= AttachList){
            
            component.set("v.PrgsBarFamilyStep",'4');
            component.set("v.FamilyStepFour",true);
            component.set("v.FamilyStepThree",false); 
            
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
    openNewRecDetailPageFamily  :function(component, event, helper) {
        
        var recordId = component.get('v.NewInsuFamilyRecId');
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
            
        });
        navEvt.fire();
    },
    
    handleUploadFamilyDocs : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        
        
        helper.getAttachmentListFamily(component, event, helper);
        
    },
    
    handleLocation : function(component, event, helper) {
        
        var id = event.getSource().getLocalId();
        
        component.set("v.EmpLocation",id);
        component.set("v.LocationPopup",false);
        component.set("v.MainPage",true);
        var loc = component.get("v.EmpLocation")
        console.log('loc'+loc);
        
        helper.getSearchResult(component, event, helper);
        helper.getPopupMsgHelper(component, event, helper);
        //component.set("v.stepOne",true);
        //component.set("v.InsuType",true);
        // component.set("v.LocStep",false);
        
        
    },
    onChange : function(component, event, helper) {
        let emirates = component.find('emirtSelect').get('v.value');
        if(emirates){
            component.set("v.EmpLocation",emirates);
            component.set("v.LocationPopup",false);
            component.set("v.MainPage",true);
            
            helper.getSearchResult(component, event, helper);
        }
        
        
    }
    
})