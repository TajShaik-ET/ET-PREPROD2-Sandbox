({
    doInit: function(component,event,helper){
        //component.set("v.isEditMode",false); //Taj
        var url_string = window.location.href;
        var url = new URL(url_string);
        var RecordId = url.searchParams.get("c__recordId"); 
        if(RecordId != null && RecordId != '' && RecordId != undefined){
            helper.getSObjectName(component,RecordId,helper);
            //helper.getActiveQuoteId(component,event,helper);
        }
        helper.EditableFieldsForPricingTeam(component,event,helper);
        helper.UserPermissions(component,event,helper);
        helper.profilePermissions(component,event,helper);
        helper.getPredefinedMasterData(component,event,helper);
        console.log('opportunityStatus  = '+ component.get('v.opportunityStatus'));
    },

    //SK-
    getOppRecTypeId: function(component, event, helper) {
        var childCompName = event.getParam("oppRecordType");
        console.log('in SRWrapperControlller OpprecordTypeName : childCompName :'+childCompName);
        
        var url_string = window.location.href;
        var url = new URL(url_string);
        var RecordId = url.searchParams.get("c__recordId"); 
        //var RecordId = component.get("v.oppId"); 
        console.log('RecordId: '+RecordId);
        if(RecordId != null && RecordId != '' && RecordId != undefined){
            helper.getOppRecTypeIdHelper(component,RecordId,helper,childCompName);
        }
    },
    
    handleNo:function(component, event, helper){
        $A.util.addClass(component.find('ConfirmDialogPricingCombination'), 'slds-hide');
        //$A.util.toggleClass(component.find('ConfirmDialogPricingCombination'), 'slds-hide');
    },
    handleYes:function(component, event, helper){
        $A.util.addClass(component.find('ConfirmDialogPricingCombination'), 'slds-hide');
        component.set("v.showModal",true);
        helper.setOperationStatus(component,helper, 'fromPriceCustomizationButton');
        
        /*if(helper.getDataCommon(component, event, helper, true)){
             component.set("v.showModal",true);
            var mappingModalcmp = component.find('mappingModalCmp');
            if(mappingModalcmp){
                 mappingModalcmp.setServiceRequestModificationStatus(component.get("v.serviceRequestModificationStatus"));
            }
                           
        }*/
        
        //component.destroy();
    },
    handleProceedButtnClick: function(component, event, helper){
        var commonDataCmp =  component.find("serviceRequestCommonCmp");
        console.log('commonDataCmp## '+JSON.stringify(commonDataCmp));
        if(commonDataCmp.validateDetails()){
            //component.set("v.proceedBttnDisable", true);
            commonDataCmp.set("v.isDisable",true);
            var contractYearVaues =  commonDataCmp.get("v.contractValue");
            var commonServiceRequestDetails = commonDataCmp.get("v.commonServiceRequestDetails");
            commonServiceRequestDetails['ET_Contract_Period__c'] = contractYearVaues;
            component.set("v.showAnnualTargetPrice",commonServiceRequestDetails.ET_Request_for_Target_Price__c);
            component.set("v.commonDetailsForAllTab", commonServiceRequestDetails);
            console.log('commonServiceRequestDetails=## '+JSON.stringify(commonServiceRequestDetails));
            component.set("v.requirementVisibility", true);
            component.set("v.fieldsWithMultipleValueLst", commonDataCmp.get("v.fieldsWithMultipleValueCurrentLst"));
            component.set("v.disableSaveButton",false);
            //helper.intializeTabComponent(component,helper, component.get("v.selectedTabId"));
            helper.saveAllTabCommonDataIntoSystem(component,event,helper);
            // show Edit Button
            var Editcmp = component.find("editButton");
            $A.util.toggleClass(Editcmp,'slds-hide');
            //alert('fields with multiple values in them:::'+ commonDataCmp.get("v.fieldsWithMultipleValueCurrentLst"));
        } 
    },
    handleSubmit : function(component, event, helper) {
        debugger;
        event.preventDefault();
        var fields = event.getParam('fields');
        if(component.get("v.contractValue")){
            fields['ET_Contract_Period__c'] =component.get("v.contractValue").toString() ;
        }
        component.set('v.showAnnualTargetPrice', fields.ET_Request_for_Target_Price__c);
        
        component.set("v.displayUpdateCommonDetailsLayout",false);
        
        // show main common details...
        var cmp = component.find("serviceRequestCommonData");
        $A.util.toggleClass(cmp,'slds-hide');
        //submit common details to server..
        helper.submitCommonDetails(component,event,helper, fields);
        console.log('fields = '+ JSON.stringify(fields));
        console.log('contractValue = '+ component.get("v.contractValue").toString() );
        
        // update child vehicles and workforce requests with a server call
        helper.updateVehicleAndWorkforceRequestsForCommonDetails(component, event, helper, fields);
        //send data to Vehicle Tab using auar:method and from Tab to it's child components...
        debugger;
        // open Vehicle Tab programatically and update Target price field Value...
        /*component.find("tabset").set("v.selectedTabId", 'vehicleLightningTab');
        var vehicleTabComp = component.find('vehicleTab');
        vehicleTabComp.updateChildVehicleDetails(fields.ET_Request_for_Target_Price__c);*/
        
    },
    
    handleEditCommonDetailsCancel : function(component, event, helper) {
        debugger;
        // hide edit layout..
        component.set("v.displayUpdateCommonDetailsLayout",false);
        // show main common details...
        var cmp = component.find("serviceRequestCommonData");
        $A.util.toggleClass(cmp,'slds-hide');
        // show edit button 
        var Editcmp = component.find("editButton");
        $A.util.toggleClass(Editcmp,'slds-hide');
    },
    
    handleSuccess : function(component, event, helper) {
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type":"success",
            "title":"success",
            "message":"Details updated successfully.",
            "mode":"sticky"
        });
        toastReference.fire();
    },
    handleEditCommonDetails : function(component, event, helper) {
        //component.set("v.isEditMode",true);
        // get contract year details from ET_ServiceRequestCommonData
        var contractPeriods = component.find('serviceRequestCommonCmp').get('v.contractPeriods');
        var contractValue = component.find('serviceRequestCommonCmp').get('v.contractValue');
        component.set("v.contractPeriods" , contractPeriods);
        component.set("v.contractValue" , contractValue);
        
        // Hide main common details..
        var cmp = component.find("serviceRequestCommonData");
        $A.util.toggleClass(cmp,'slds-hide');
        // show edit layout.. editButton
        component.set("v.displayUpdateCommonDetailsLayout",true);
        // hide edit button 
        var Editcmp = component.find("editButton");
        $A.util.toggleClass(Editcmp,'slds-hide');
    },
    updateTabs : function(component, event, helper) {
        var selectedTab = event.getParam("tabName");
        var selectedTabValue = event.getParam("selected");
        helper.updateTabsHelper(component, event, helper,selectedTab,selectedTabValue);
    },
    hideMappingModel: function(component, event, helper){ 
        component.set("v.showModal", false);
        
    },
    
    handleCustomizePricingClicked: function(component,event,helper){
        
        /* helper.checkValidityOfOperation(component,helper).then(
              $A.getCallback(function(result) {
                  $A.util.removeClass(component.find('ConfirmDialogPricingCombination'), 'slds-hide');
              })).catch(err => console.log(err))
         */
        
        $A.util.removeClass(component.find('ConfirmDialogPricingCombination'), 'slds-hide');
        
    },
    
    doRefresh: function(component,event,helper){
        var id = event.getParam("childCmpAuraId");
        if(id == 'serviceRequestCommonCmp'){
            component.set("v.commonCmpLoadingDone", true);
            helper.setCommonCmpExistingData(component,event,helper);
        }
        
    },
    
    handleCancelBttnClicked: function(component,event,helper){
        var oppId = component.get("v.opportunityRecordId");
        var serviceRequestId = component.get("v.serviceRequestRecordId");
        if(serviceRequestId){
            window.open('/'+serviceRequestId);
        }
        else if(oppId){
            window.open('/'+oppId);
            
        }
        window.close();
    },
    
    handlesubmitQuoteForApproval  : function(component,event,helper){
        var params = event.getParam('arguments');
        var quoteId ; 
        helper.handlesubmitQuoteForApprovalHelper(component,event,helper);
    },
    
    submitToHeadOfSalesController: function(component, event, helper) {
        helper.submitToHeadOfSalesHelper(component,event,helper);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    onSubmit : function(component, event, helper) {
        debugger;
        helper.onSubmitRequest(component,event,helper,"Approve");
    },

    handleChangeInQuantity : function(component, message, helper) {
        // Get the message from the grandchild component and set it to the attribute
        if (message && message.getParam('changeInVehicleQuantity')) {
            var opportunityStatus = component.get('v.opportunityStatus');
            //var isEditMode = component.get("v.isEditMode");
            var changeInVehicleQuantity = message.getParam('changeInVehicleQuantity');
            console.log('opportunityStatus: ' + opportunityStatus + ' changeInVehicleQuantity: ' + changeInVehicleQuantity);
            if ((opportunityStatus == 'Rejected' || opportunityStatus == 'Rejected by Pricing Team') && changeInVehicleQuantity == true) {
                component.set("v.changeInVehicleQuantity", true);
            }else{
                component.set("v.changeInVehicleQuantity", false);
            }
        }
    },
    
    getData: function(component,event,helper){
        var isAlterRatesChanged = component.get("v.isAlterRatesChanged");
        // fire this method, only if alter Rates Changed...
        if(isAlterRatesChanged){
            helper.saveAlterRatesHelper(component, event, helper);
        }
        else{
            var status = component.get("v.serviceRequestModificationStatus");
            if(status == 'Success' || !component.get("v.existingApplicationData")) {
                debugger;
                helper.getDataCommon(component, event, helper, false);
            }else if(status == 'SRIsInActive'){
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"warning",
                    "title":"warning",
                    "message":"Operation is invalid, Service Request is Inactive",
                    "mode":"sticky"
                });
                toastReference.fire();
            }else if(status == 'QuoteIsNotApprovedOrRejected'){
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"warning",
                    "title":"warning",
                    "message":"Operation is invalid, Active quote is still in approval process or already Approved.",
                    "mode":"sticky"
                });
                toastReference.fire();
                
            }
        }
        
        
    },
    
    getAlterRatesData: function(component,event,helper){
        helper.saveAlterRatesHelper(component, event, helper);
    },
    
    generateQuotation: function(component,event,helper){
        var status = component.get("v.serviceRequestModificationStatus");
        console.log('status: '+status);
        if(status == 'Success') {
            helper.checkValidityOfQuoteCreation(component,event,helper); 
        }else if(status == 'SRIsInActive'){
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"warning",
                "title":"warning",
                "message":"Operation is invalid, Service Request is Inactive",
                "mode":"sticky"
            });
            toastReference.fire();
            
        }
            else if(status == 'QuoteIsNotApprovedOrRejected'){
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"warning",
                    "title":"warning",
                    "message":"Operation is invalid, Active quote is still in approval process or already Approved.",
                    "mode":"sticky"
                });
                toastReference.fire();
            }
        
    },
    
    generateTotalProject : function(component,event,helper){
        helper.generateTotalProjectQuotation(component,event,helper);
    },
    
    handleopenQuotationBttnClicked : function(component,event,helper){
        helper.openActiveQuotationHelper(component,event,helper);  
    },
    
    handleProgrammaticallyTabIdChange: function(component,event,helper){
        /* var selected = component.get("v.selectedTabId");
        component.find("tabset").set("v.selectedTabId", selected);
        if(selected == 'Vehicle' && component.get("v.existingVehicleTabData")){
            var vehicleTab = component.find("vehicleTab");
            if(vehicleTab){
                vehicleTab.intializeTabProgrammaticallyUponLoading(component.get("v.backgroundColor"),
                                                             component.get("v.fieldsWithMultipleValueLst"),
                                                             component.get("v.commonDetailsForAllTab"),
                                                             component.get("v.existingVehicleTabData"));
            }
        }else if(selected == 'Drivers' && component.get("v.existingDriverTabData")){
            var driverTab = component.find("driverTab");
            if(driverTab){
                 driverTab.intializeTabProgrammaticallyUponLoading(component.get("v.backgroundColor"),
                                                             component.get("v.fieldsWithMultipleValueLst"),
                                                             component.get("v.commonDetailsForAllTab"),
                                                             component.get("v.existingDriverTabData"));
            }
           
        }else if(selected == 'School_Bus_Nannies' && component.get("v.existingNannyTabData")){
            var nannyTab = component.find("schoolBusNanniesTab");
            if(nannyTab){
                 nannyTab.intializeTabProgrammaticallyUponLoading(component.get("v.backgroundColor"),
                                                             component.get("v.fieldsWithMultipleValueLst"),
                                                             component.get("v.commonDetailsForAllTab"),
                                                             component.get("v.existingNannyTabData"));
            }
           
        }else if(selected == 'Supervisors' && component.get("v.existingSupervisorTabData")){
            var supervisorTab = component.find("supervisorTab");
            if(supervisorTab){
                 supervisorTab.intializeTabProgrammaticallyUponLoading(component.get("v.backgroundColor"),
                                                             component.get("v.fieldsWithMultipleValueLst"),
                                                             component.get("v.commonDetailsForAllTab"),
                                                             component.get("v.existingSupervisorTabData"));
            }
           
        }else if(selected == 'Coordinators' && component.get("v.existingCoordinatorTabData")){
            var coordinatorTab = component.find("coordinatorTab");
            if(coordinatorTab){
                 coordinatorTab.intializeTabProgrammaticallyUponLoading(component.get("v.backgroundColor"),
                                                             component.get("v.fieldsWithMultipleValueLst"),
                                                             component.get("v.commonDetailsForAllTab"),
                                                             component.get("v.existingCoordinatorTabData"));
            }
           
        }else if(selected == 'Accountant' && component.get("v.existingAccountantTabData")){
            var accountantTab = component.find("accountantTab");
            if(accountantTab){
                 accountantTab.intializeTabProgrammaticallyUponLoading(component.get("v.backgroundColor"),
                                                             component.get("v.fieldsWithMultipleValueLst"),
                                                             component.get("v.commonDetailsForAllTab"),
                                                             component.get("v.existingAccountantTabData"));
            }
           
        }else if(selected == 'Other_Employees' && component.get("v.existingOtherEmpTabData")){
            var otherEmpTab = component.find("otherEmployeeTab");
            if(otherEmpTab){
                 otherEmpTab.intializeTabProgrammaticallyUponLoading(component.get("v.backgroundColor"),
                                                             component.get("v.fieldsWithMultipleValueLst"),
                                                             component.get("v.commonDetailsForAllTab"),
                                                             component.get("v.existingOtherEmpTabData"));
            }
           
        }
        */
        
    },
    
    handleDeletedOtherCostTabWiseEvt: function(component,event,helper){
        var attributes = event.getParams();
        if(attributes){
            var otherCostObjId = attributes.otherCostObjId;
            if(otherCostObjId){
                var deletedOtherCostIdst = component.get("v.deletedOtherCostObjIdsLst");
                if(!deletedOtherCostIdst){
                    deletedOtherCostIdst = [];    
                }
                deletedOtherCostIdst.push(otherCostObjId);
                component.set("v.deletedOtherCostObjIdsLst", deletedOtherCostIdst)
            }
        }
    },
    
    setOppRecordType: function(component,event,helper){
        var attributes = event.getParams();
        if(attributes){
            var oppRecordType = attributes.oppRecordType;
            if(oppRecordType){
                component.set("v.oppRecordType", oppRecordType);
            }
        }
    },
    
    handlenotifyAlterRatesEvent : function(component, event, helper) {
        var alterRatesObj = event.getParam("alterRatesObj");
        console.log('alterRatesObj wrp = '+JSON.stringify(alterRatesObj) );
        component.set("v.alterRatesWrWithServiceList", alterRatesObj);
        component.set("v.isAlterRatesChanged", true);
        console.log('isAlterRatesChanged = '+ component.get('v.isAlterRatesChanged'));
        var compEvent = component.getEvent("alterRateWrpEvent");
        compEvent.setParams({
            "alterRatesObj" : JSON.parse(JSON.stringify(alterRatesObj)),
            "isAlterRateChanged":true
        });
        compEvent.fire();
    },
    deleteAlterRatesData: function(component,event,helper){
        var action = component.get("c.deleteQuote");
        component.set('v.loaded', !component.get('v.loaded'));
        action.setParams({ 
            serviceRequestRecordId : component.get("v.serviceRequestRecordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.loaded', !component.get('v.loaded'));
                var result = JSON.stringify(response.getReturnValue());
                console.log('result = '+result);
                if(result == 'true'){
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"success",
                        "title":"success",
                        "message":"Your request has been completed sucessfully.",
                        "mode":"sticky"
                    });
                    toastReference.fire();
                    //alert('Your request has been completed sucessfully.');
                    //window.location.reload();
                    $A.get('e.force:refreshView').fire();
                }else {
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"warning",
                        "title":"warning",
                        "message":"Unable to complete your Request, Please try again or contact system admin.",
                        "mode":"sticky"
                    });
                    toastReference.fire();
                    // alert('Unable to complete your Request, Please try again or contact system admin.');
                }
            }
            else{
                component.set('v.loaded', !component.get('v.loaded'));
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"warning",
                    "title":"warning",
                    "message":"Unable to complete your Request, Please try again or contact system admin.",
                    "mode":"sticky"
                });
                toastReference.fire();
                //alert('Unable to complete your Request, Please try again or contact system admin.');
            }
        });
        $A.enqueueAction(action);
    },
    rejectRequestData: function(component, event, helper) {
        component.set("v.showRejectionPopup", true);
    },
    submitRejectRequest: function(component, event, helper) {
        if(component.find('fieldId').get('v.value') ==null || component.find('fieldId').get('v.value') ==undefined || component.find('fieldId').get('v.value') ==''){
            component.find('fieldId').setCustomValidity("This field is required");
            component.find('fieldId').reportValidity();
            return true;
        }else {
            var action = component.get("c.rejectServiceRequest");
            action.setParams({ 
                serviceRequestId : component.get("v.serviceRequestRecordId"),
                rejectionReason: component.get("v.rejectionReason")
            });
            component.set('v.loaded', !component.get('v.loaded'));
            action.setCallback(this, function(response) {
                var state = response.getState();
                component.set('v.loaded', !component.get('v.loaded'));
                if (state === "SUCCESS") {
                    var result = JSON.stringify(response.getReturnValue());
                    component.set("v.showRejectionPopup", false);
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"success",
                        "title":"success",
                        "message":"Your request has been completed sucessfully.",
                        "mode":"sticky"
                    });
                    toastReference.fire();
                    //alert('Your request has been completed sucessfully.');
                    //window.location.reload();
                    $A.get('e.force:refreshView').fire();
                }
                else if(state === "ERROR"){
                    var errors = action.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            helper.showToastHelper('Error','error',errors[0].message,'sticky');
                            // alert('Error : ' + errors[0].message);
                            component.set("v.showRejectionPopup", false);
                        }
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    
    closeRejectionPopup: function(component, event, helper) {
        component.set("v.showRejectionPopup", false);
    },
    
    handleContractYearChange: function(component,event,helper){
        console.log(component.get("v.contractValue"));
        var contractValueArray = component.get("v.contractValue");
        if(contractValueArray.length > 1 && contractValueArray.includes('Multiple') && !component.get("v.isMultipleContractSelected")){
            var contractValueNewArray = [];
            contractValueNewArray.push( 'Multiple');
            component.set("v.isMultipleContractSelected", true);
            component.set("v.contractValue", contractValueNewArray);
        }
        else if(contractValueArray.length > 1 && contractValueArray.includes('Multiple') && component.get("v.isMultipleContractSelected")){
            component.set("v.isMultipleContractSelected", false);
            contractValueArray = helper.arrayRemoveElementByValue(contractValueArray, 'Multiple');
            component.set("v.contractValue", contractValueArray);
        }
    },
    OnUploadSpea: function(component, event, helper) {
        try{
            var files = component.get("v.uploadedDocs");
            var fileUploadWrapper = component.get("v.speaFileList");
            var contentWrapperArr = [];
            
            if(files && files.length > 0 && fileUploadWrapper.length < 1 ) {
                for(var i=0; i < files[0].length; i++){
                    var file = files[0][i];
                    var quoteDetail = component.get("v.quoteDetail");
                    // Safely rename the file
                    if (quoteDetail && quoteDetail.Opportunity && quoteDetail.Opportunity.ETSALES_Opportunity_Number__c && quoteDetail.QuoteNumber && quoteDetail.Quote_Type__c == 'Manual') {
                        let oppNum = quoteDetail.Opportunity.ETSALES_Opportunity_Number__c.replace('OPP - ', '');
                        // Get file extension from original file
                        let fileExtension = file.name.split('.').pop();
                        // Create a new file name including the extension
                        let newFileName = oppNum + '_' + quoteDetail.QuoteNumber + '_ManualQuotation.' + fileExtension;
                        // Create a new file with the updated name
                        file = new File([file], newFileName, { type: file.type });
                    } 
                    
                    if(file.size <= 1000000 ) {                        
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
                            component.set("v.speaFileList",fileUploadWrapper);
                        }
                        function handleEvent(event) {
                            if(contentWrapperArr.length == i){
                                
                                component.set("v.speaFileList",fileUploadWrapper);
                            }
                        }
                        reader.readAsDataURL(file);
                        reader.addEventListener('loadend', handleEvent);
                    }else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error!",
                            "message":"Please upload file less than 1 MB.",
                            "mode":"sticky"
                        });
                        toastReference.fire();
                    }
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Error",
                    "title":"Error!",
                    "message": "You cannot upload more than one file.",
                    "mode": "sticky"
                });
                toastEvent.fire();
            }
            component.set("v.disableSubmit", true);
            window.setTimeout(
                $A.getCallback(function() {
                    helper.handleValidationsHelper(component, event, helper);
                }), 5000
            );
        }catch (e){
            console.log(e.message);
        }
    },
    
    removeRecord: function(component, event, helper) {
        var speaFileList = component.get("v.speaFileList");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        speaFileList.splice(index, 1);
        component.set("v.speaFileList", speaFileList);
        helper.handleValidationsHelper(component, event, helper);
    },

    //Taj
    /*handleChangeQuoteType: function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        var quoteDetail = component.get("v.quoteDetail");
        quoteDetail.Quote_Type__c = selectedOptionValue;
        component.set("v.quoteDetail", quoteDetail);
    },*/

    handleChange: function (component, event, helper) {
        var value = event.getParam("value");
        var name = event.getParam("value");
        console.log(value + ' Input:1 ' + name);
        helper.handleValidationsHelper(component, event, helper);
    },

    handleValidations: function (component, event, helper) {
        console.log('handleValidations');
        helper.handleValidationsHelper(component, event, helper);
    },
    
})