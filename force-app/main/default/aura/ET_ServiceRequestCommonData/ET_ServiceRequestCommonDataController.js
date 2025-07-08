({
    doInit: function(component,event,helper){
      //  console.log(component.get("v.refresh"));
      
            console.log('inside doinit of common data cmp ' + JSON.stringify(component.get("v.commonServiceRequestDetails")));
           
            helper.getSRCommonDetails(component,event,helper);
            var idsMap = new Map();
            idsMap['multipleContract'] = 'multiContractDiv';
            idsMap['ET_Contract_Type__c'] = 'contractTypeDiv';
            idsMap['ET_Service_Emirate__c'] = 'serviceEmirateDiv';
            idsMap['ET_Pricing_Method__c'] = 'pricingMethodDiv';
            idsMap['ET_Pricing_Type__c'] = 'pricingTypeDiv';
            idsMap['ET_Working_Days_Per_Week__c'] = 'daysPerWeekDiv';
            idsMap['ET_Working_Months_Per_Year__c'] = 'monthsPerYearDiv';
            idsMap['ET_Price_Utilization__c'] = 'priceUtiliationDiv';
            component.set("v.auraElementAndDivIdMap", idsMap);
            var receivedFldLst = component.get("v.fieldsWithMultipleValueLst") ;
            var allFieldlst = component.get("v.allFieldsCheckLst");
    
            if(receivedFldLst != undefined && receivedFldLst.length > 0 ){
                for(var fieldId of allFieldlst){
                    if(!receivedFldLst.includes(fieldId)){
                        var fieldDivCmp = component.find(idsMap[fieldId]);
                        $A.util.addClass(fieldDivCmp,  'slds-hide');
                    }else{
                        if(fieldId == 'ET_Pricing_Type__c'){
                           // helper.showPriceTypeValuesAccordingPriceMethod(component,event,helper);
                        }
                    }
                    
                }
            }
             //SK-
            if(component.get("v.OpprecordTypeName")==undefined){
                var compEvent = component.getEvent("OpprecordTypeNameEvent");
                compEvent.setParams({
                    "oppRecordType": "ET_ServiceRequestCommonData"
                });
                compEvent.fire(); 
            }
    },

    //SK-    
    getOpprecordTypeName: function(component,event,helper){
        var params = event.getParam('arguments');
        //var fieldDivCmpIds =["daysPerWeekDiv","requestforSeparatePriceDiv"];
        
        //alert('getOpprecordTypeName: '+params);
        console.log('OpprecordTypeName: '+params.OpprecordTypeName);
        if(params){
            component.set("v.OpprecordTypeName", params.OpprecordTypeName);
            if(params.OpprecordTypeName == 'Leasing/ Rental'){
                /*fieldDivCmpIds.forEach(function(id) {
                    var fieldDivCmpId =component.find(id);
                     $A.util.addClass(fieldDivCmpId, 'slds-hide');
                });*/
                var selecteDaysPerWeek = component.get("v.selecteDaysPerWeek");
                var selectedMonthPerYear = component.get("v.selectedMonthPerYear");
                var selectedPricingMethod = component.get("v.selectedPricingmethod");
                var selectedPricingType = component.get("v.selectedPricingtype");
                var selectedPriceUtilization = component.get("v.selectedPriceUtilization");
               
                // Set default values in commonServiceRequestDetails
                var commonServiceRequestDetails = component.get("v.commonServiceRequestDetails");
                commonServiceRequestDetails.ET_Working_Days_Per_Week__c = selecteDaysPerWeek;
                commonServiceRequestDetails.ET_Working_Months_Per_Year__c = selectedMonthPerYear;
                commonServiceRequestDetails.ET_Pricing_Method__c = selectedPricingMethod;
                commonServiceRequestDetails.ET_Pricing_Type__c = selectedPricingType;
                commonServiceRequestDetails.ET_Price_Utilization__c = selectedPriceUtilization;
                
                component.set("v.commonServiceRequestDetails", commonServiceRequestDetails);
                console.log('inside getOpprecordTypeName of ET_ServiceRequestCommonData ' + JSON.stringify(component.get("v.OpprecordTypeName")));
                
            } /*else {
                 fieldDivCmpIds.forEach(function(id) {
                    var fieldDivCmpId =component.find(id);
                     $A.util.removeClass(fieldDivCmpId, 'slds-hide');
                });
            }*/
            
        }
    },

    handleChangeInPriceMethod: function(component,event,helper){
        console.log('inside price method change method');
        var dependentValueMap = component.get("v.pricingMethodAndDependentTypeMap");
        var priceMethodValue = component.get("v.commonServiceRequestDetails").ET_Pricing_Method__c;
        
        //var priceTypeValueLst = [];
        // removed dependency of visibility of price utility field on pricing method
       // var fieldDivCmp = component.find('priceUtiliationDiv');
        if(priceMethodValue == 'Multiple'){
            //$A.util.addClass(fieldDivCmp,  'slds-hide');
            component.set("v.pricingTypes", dependentValueMap[priceMethodValue]);

        }else{
           // $A.util.removeClass(fieldDivCmp,  'slds-hide');
            component.set("v.pricingTypes", dependentValueMap[priceMethodValue]);
        }



    },
    
    checkForMultipleController : function(component,event,helper){
        helper.checkForMultiple(component,event,helper);
    },
     
    
    validateDetails: function(component,event,helper){
        var requiredFieldIdLst = component.get("v.allFieldsCheckLst");
        
        var fieldsWithMultipleValueLst = component.get("v.fieldsWithMultipleValueLst");
        var currentCommonData = component.get("v.commonServiceRequestDetails");
        var pricingMethodValue = currentCommonData.ET_Pricing_Method__c;
        var pricingTypeValue = currentCommonData.ET_Pricing_Type__c;
        
        var  requiredFieldsLst = [];
        if(pricingMethodValue != 'Multiple' && pricingTypeValue != 'Multiple'){
            //requiredFieldIdLst.push('ET_Price_Utilization__c');
            requiredFieldsLst.push(component.find('ET_Price_Utilization__c'));
        }
            for(var id in requiredFieldIdLst){
                if(fieldsWithMultipleValueLst.length == 0 || ( fieldsWithMultipleValueLst.length > 0  && fieldsWithMultipleValueLst.includes(requiredFieldIdLst[id]))){
                    if(component.find(requiredFieldIdLst[id])){
                        requiredFieldsLst.push(component.find(requiredFieldIdLst[id]));
                    }
                   
                }
            }
        if(requiredFieldsLst.length!=undefined && requiredFieldsLst.length > 0){
            var allValid = requiredFieldsLst.reduce(function (validSoFar, inputCmp) {            
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);  

            if (allValid) {
			console.log('Multiple values collected');
            helper.checkForMultiple(component, event, helper);
            return true;
            }

            return false;
      }
    },
    handleChange: function(component,event,helper){
        // alert(component.get("v.contractValue"));
    },
    updateCommonFields: function(component,event,helper){

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

    handleChangeInPriceType: function(component,event,helper){
         var commonDataObj = component.get("v.commonServiceRequestDetails")
         var pricingTypeValue = commonDataObj.ET_Pricing_Type__c;
        if(pricingTypeValue ){
            var priceUtilizationDiv = component.find("priceUtiliationDiv");
            if(pricingTypeValue == 'Annual Price'){
                 $A.util.removeClass(priceUtilizationDiv,  'slds-hide');
                commonDataObj.ET_Price_Utilization__c = 1;
                component.set("v.commonServiceRequestDetails", commonDataObj);
                component.set("v.disablePriceUtilization", true);

            }else if(pricingTypeValue == 'Multiple'){
                //component.set("v.disablePriceUtilization", true);
               
                $A.util.addClass(priceUtilizationDiv,  'slds-hide');
                //component.set("v.disablePriceUtilization", true);
            }else{
                commonDataObj.ET_Price_Utilization__c = null;
                component.set("v.commonServiceRequestDetails", commonDataObj);
                component.set("v.disablePriceUtilization", false);
                $A.util.removeClass(priceUtilizationDiv,  'slds-hide');
            }
            
        }
       
    },

    doRefresh: function(component,event,helper){
        //alert('in refresh event handler');
        
        var existingData = Object.assign({},component.get("v.existingCommonInfo") );
        console.log('existingData## '+JSON.stringify(existingData));
        if(existingData != undefined ){
            component.set("v.isDisable", true);
            console.log('existingData in doRefresh method: ' + JSON.stringify(existingData));
            /*if(existingData.ET_Price_Utilization__c != undefined && existingData.ET_Pricing_Method__c != 'Multiple' && existingData.ET_Pricing_Type__c != 'Multiple'){
                var priceUtilizationCmp = component.find("priceUtiliationDiv");
                $A.util.removeClass(priceUtilizationCmp,  'slds-hide');
            }*/
            helper.controlVisibilityOfFieldsOnLoad(component,existingData);
            if(existingData.ET_Contract_Period__c != undefined){
                var contractPeriodLst = existingData.ET_Contract_Period__c.toString().split(',');
                component.set("v.contractValue", contractPeriodLst);
            }
            component.set("v.commonServiceRequestDetails", existingData);
        }
    },

    setAlreadyStoredData: function(component,event,helper){
        return new Promise($A.getCallback(function(resolve, reject) {
            var params = event.getParam('arguments');
            if(params){
                var existingData = params.commonDataToBeSet;
                console.log('existingData11## '+JSON.stringify(existingData));
                if(existingData != undefined ){
                    component.set("v.isDisable", true);
                    console.log('existingData in doRefresh method: ' + JSON.stringify(existingData));
                    /*if(existingData.ET_Price_Utilization__c != undefined && existingData.ET_Pricing_Method__c != 'Multiple' && existingData.ET_Pricing_Type__c != 'Multiple'){
                        var priceUtilizationCmp = component.find("priceUtiliationDiv");
                        $A.util.removeClass(priceUtilizationCmp,  'slds-hide');
                    }*/
                    helper.controlVisibilityOfFieldsOnLoad(component,existingData);
                    if(existingData.ET_Contract_Period__c != undefined){
                        var contractPeriodLst = existingData.ET_Contract_Period__c.split(',');
                        component.set("v.contractValue", contractPeriodLst);
                    }
                    component.set("v.commonServiceRequestDetails", existingData);
                    resolve("Resolved");
                }
            }else{
            	 reject("Rejected");
            }
        }));
    }
     
})