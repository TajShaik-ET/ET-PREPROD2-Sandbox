({
    getSRCommonDetails: function(component, event, helper) {
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "ET_Service_Request_Common_Data__c",
            'field_apinames': component.get("v.picklistFields")
        });
        action.setCallback(this, function(a) {
           // alert('inside call back of init');
            var state = a.getState();
            if (state === "SUCCESS"){
                var response=a.getReturnValue();
                if(response!=null && response!=undefined){
                    if(response.contractType==null||response.contractType==undefined||
                        response.serviceEmirates==null||response.serviceEmirates==undefine||
                        response.pricingMethods==null||response.pricingMethods==undefined||
                        response.pricingTypes==null||response.pricingTypes==undefined || response.pricingMethodAndDependentTypeMap==undefined){
                            console.log('contractType or specRequirement or pricingTypes or pricingMethods or dependent picklist for pricing type is null');     
                    }
                    component.set("v.contractType",response.contractTypes);
                    component.set("v.serviceEmirates",response.serviceEmirates);
                    component.set("v.pricingMethods",response.pricingMethods);
                    component.set("v.pricingMethodAndDependentTypeMap",response.pricingMethodAndDependentTypeMap);
                    //setting pricing type value by default; to avoid problems while loading data in edit fucntionality.
                    component.set("v.pricingTypes", (response.pricingMethodAndDependentTypeMap)['Comprehensive Price per Quotation']);
                    //component.set("v.contractPeriods",response.contractPeriods);
                    var options=[];
                    for(var period of response.contractPeriods){
                        options.push({"label" : period, "value" : period});
                    }  
                    
                    var options2=[];
                    for(var period of response.contractPeriods2){
                        options2.push({"label" : period, "value" : period});
                    }  
                    
                    component.set("v.contractPeriods",options);
                    component.set("v.contractPeriods2",options2);
                  
                    console.log('response.contractPeriods '+response.contractPeriods);
                 
                        var delayInMilliseconds = 1000; //1 seconds
                        window.setTimeout(
                            $A.getCallback(function() {
                                //console.log('myHelperMethod EXECUTING NOW... ');
                               var compEvent = component.getEvent("refreshEvent");
                               compEvent.setParam("childCmpAuraId", component.getLocalId());
                                compEvent.fire();
                            }), delayInMilliseconds
                        );     

                        
                        
                       
                    
                }else{
                    console.log('response is null');
                }
             
            }else{
                console.log('Callback from the server failed');
            }
               
        });
        $A.enqueueAction(action);
    },
    
    checkForMultiple : function(component, event, helper) {
        var fieldList = component.get("v.allFieldsCheckLst");
        var obj = component.get("v.commonServiceRequestDetails");
        var multipleList = [];
        // checking for fields having "multiple" value.
        for (var listIndex in fieldList) {
            console.log(fieldList[listIndex]);
            var val = fieldList[listIndex];
            console.log(obj[val]);
            console.log('val ',val);
            // Checking for contract checkbox
            if(val == 'multipleContract'){
                var isMultipleChecked = component.get("v.contractValue").includes("Multiple");
                //var isMultipleChecked =component.find("multipleContract").get("v.checked");
                if(isMultipleChecked){
                    multipleList.push(val);
                }
//                alert(isMultipleChecked);
            }else{
                if(obj[val] == 'Multiple' ){
                  
                    console.log(val)
                    multipleList.push(val);
                }
            }
        }
        component.set("v.fieldsWithMultipleValueCurrentLst",multipleList);
        console.log("checkForMultiple = "+ JSON.stringify(multipleList));
        return true;
    },

    arrayRemoveElementByValue: function(arr, value) {

        return arr.filter(function(ele){
            return ele != value;
        });
    },


    showPriceTypeValuesAccordingPriceMethod: function(component,event,helper){
        var dependentValueMap = component.get("v.pricingMethodAndDependentTypeMap");
      
        var priceMethodValue = component.get("v.commonServiceRequestDetails").ET_Pricing_Method__c;
        if(priceMethodValue != 'Multiple'){
            component.set("v.pricingTypes", dependentValueMap[priceMethodValue]);
        }
    },


    controlVisibilityOfFieldsOnLoad: function(component,existingData){
        var idMappingMap = component.get("v.fieldAuraIdAndRespectiveDivIdMap");
        for(var id in  existingData){
            if(existingData[id] == undefined && existingData[id] == null){
                var elementDiv = component.find(idMappingMap.get(id));
                $A.util.addClass(elementDiv, 'slds-hide');
            }
            
        }
        if(existingData.ET_Price_Utilization__c != undefined && existingData.ET_Pricing_Method__c != 'Multiple' && existingData.ET_Pricing_Type__c != 'Multiple'){
            var priceUtilizationCmp = component.find("priceUtiliationDiv");
            $A.util.removeClass(priceUtilizationCmp,  'slds-hide');
        }
    }
})