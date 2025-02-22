({
    doInit:function(component, event, helper){
        var action = component.get("c.getAccountantMasterData");
        action.setCallback(this, function(obj){
            var state = obj.getState();
            if(state === 'SUCCESS'){
                var response = obj.getReturnValue();
                if(response!=null && response!= undefined){
                    component.set("v.accountantCashierMasterDataMap", response);
                    console.log(JSON.stringify(component.get("v.accountantCashierMasterDataMap")));
                    
                    var commonCmp = component.find("serviceRequestCommonCmpAcc");
                    var commonInfoFromWrapper = component.get("v.commonInforReceivedFrmWrapper");
                    
                    if((component.get("v.commonFieldsToBePopulateLst") == undefined || component.get("v.commonFieldsToBePopulateLst").length == 0) && commonCmp == undefined){
                        var accountantRecords = new Map();
                        var routeList = [];
                        var accountantCommonInfo = commonInfoFromWrapper;
                        if(commonInfoFromWrapper['ET_Pricing_Method__c'] == 'Comprehensive Price per Route'){
                            routeList.push("Comprehensive Price per Route");
                        }
                        accountantRecords['accountantCommonInfo'] = accountantCommonInfo;
                        component.set("v.accountantRecords",accountantRecords); 
                        component.set("v.additionalFieldsToDisplay",routeList);
                        //component.set("v.multipleFields",fieldsWithMultipleValueLst );
                        var totalNumberOfLines = component.get("v.numberOfLines");
                        component.set("v.numberOfLines",totalNumberOfLines+1);
                        //  alert('doinit');
                        $A.createComponent(
                            "c:ET_AccountantCashierDetails",
                            {
                                "aura:id" : "accountantDetailsCmp",
                                "lineNumber" : component.get("v.numberOfLines"),
                                "additionalFields" : routeList,
                                "accountantCashierMasterDataMap" : component.get("v.accountantCashierMasterDataMap"),
                                "editableFieldsByPricingTeam" : component.get("v.editableAccntantFieldsforPricingTeam"),
                                "isPricingTeam" :  component.get("v.isPricingTeam"),
                                "alterRatesObj": component.get("v.alterRatesWithServiceWrp"),
                                "quoteId" : component.get("v.quoteId")
                                
                            },
                            function(newcomponent){
                                if (component.isValid()) {
                                    var newCmp = component.find("cmpBody");
                                    var body = newCmp.get("v.body");
                                    body.push(newcomponent);
                                    newCmp.set("v.body", body);             
                                }
                            }   
                            
                        );
                    }
                    var data = component.get("v.existingAccountantTabData");
                    console.log('accountant existing data :'+JSON.stringify(data));
                    if(data != undefined && data != null){
                        if(data.manpowerCommonData != null){
                            component.set("v.existingAccountantCommonData", data.manpowerCommonData);
                        }
                        if(data.manpowerLineItems != null){
                            component.set("v.existingAccountantLineItems", data.manpowerLineItems);
                            // intializing line item components here too when local tab common data is same as application common data. 
                            if(component.get("v.commonFieldsToBePopulateLst") == null || component.get("v.commonFieldsToBePopulateLst").length == 0){
                                for(var i=0; i< data.manpowerLineItems.length -1; i++){
                                    helper.createComponent(component, event, helper,component.get("v.multipleFields")); 
                                }
                            }
                            
                        }
                    }
                }
            }else if (state === "ERROR") {
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                console.error(message);
            }
        });
        $A.enqueueAction(action);            
        
    },

    doRefresh: function(component,event,helper){
        var id = event.getParam("childCmpAuraId");
        var data = component.get("v.existingAccountantTabData");
        if(data){
            if(id == 'serviceRequestCommonCmpAcc' && (component.get("v.commonFieldsToBePopulateLst") != null && component.get("v.commonFieldsToBePopulateLst").length > 0)){
                helper.prePopulateDataAfterEvent(component,event,helper).then(
                    $A.getCallback(function(result) {
                        var accountantRecords = helper.getTabCommonData(component,event,helper);
                        if(accountantRecords){ 
                            component.set("v.accountantRecords",accountantRecords);
                            if(data.manpowerLineItems != null){
                               
                                var items = data.manpowerLineItems;
                                if(data.manpowerCommonData != undefined){
                                    for(var i =0; i < items.length ; i++){
                                        helper.createComponent(component, event, helper,component.get("v.multipleFields"));       
                                    }
                                }else{
                                    for(var i=0; i< (items.length)-1 ; i++){
                                        helper.createComponent(component, event, helper,component.get("v.multipleFields")); 
                                    }
                
                                }
                            
                            }
                        }
                    })
                )
            }else{
                helper.prePopulateDataAfterEvent(component,event,helper);
            }
        }
       
    },
  
    handleAddMore : function(component, event, helper) {
            var accountantRecords = helper.getTabCommonData(component,event,helper);
            if(accountantRecords){
                component.set("v.accountantRecords",accountantRecords); 
                if(helper.validateAllDetails(component,event,helper) ||  component.find("accountantDetailsCmp") == undefined || (component.find("accountantDetailsCmp") != undefined && component.find("accountantDetailsCmp").length == undefined && component.find("accountantDetailsCmp").find("collapsibleCmp") == undefined)){
                    helper.createComponent(component, event, helper,component.get("v.multipleFields"));
                }
            }
        
    },
    
    getData : function(component, event,helper) {
        var accountantTabDataMap = helper.getWholeTabData(component,event,helper);
        if(accountantTabDataMap){
            component.set('v.accountantRecords', accountantTabDataMap );
            return accountantTabDataMap;
        }
        return null;
        
    },

    handleNotifyAccountantTabEvent: function(component,event,helper){
        helper.decreasTabLineCount(component,event,helper, 'accountantDetailsCmp');
    },
    
    handleAlterRateEvent : function(component, event, helper) {
        var alterRatesObj = event.getParam("alterRatesObj");
        component.set("v.alterRatesWithServiceWrp", alterRatesObj);
        var childComponent =component.find('accountantDetailsCmp');
        if(childComponent.length != undefined){
            for(var child of childComponent){
                    child.set("v.alterRatesObj", alterRatesObj);
            } 
        }else if(childComponent.length == undefined){
            childComponent.set("v.alterRatesObj", alterRatesObj);
        }
    },
    
    onQuoteIdChange : function(component, event, helper) {
        var childComponent =component.find("accountantDetailsCmp");
        /*if multiple child components present - childComponent is list other wise it's a single object..
          so checking with length, if it's undefined - it's single object and can directly access that single child component..
          If multiple child components iterate over the components and set the Values.. */
        console.log('quoteId in Vehicle Tab  = '+ component.get("v.quoteId"));
        if(childComponent !=undefined && childComponent.length != undefined){
            for(var child of childComponent){
            	child.set("v.quoteId", component.get("v.quoteId"));
            } 
        }
        else if( childComponent !=undefined && childComponent.length == undefined){
            childComponent.set("v.quoteId", component.get("v.quoteId"));
        }
    },
})