({
    doInit:function(component, event, helper){
        helper.processDoInit(component,event,helper);
        //alert('doinit');
    },
    handleAddMore : function(component, event, helper) {
        var driverRecords = helper.getTabCommonData(component,event,helper);
        if(driverRecords){ 
            component.set("v.driverRecords",driverRecords);
            if(helper.validateAllDetails(component,event,helper) ||  component.find("driverDetailsCmp") == undefined || (component.find("driverDetailsCmp") != undefined && component.find("driverDetailsCmp").length == undefined && component.find("driverDetailsCmp").find("collapsibleCmp") == undefined) ){
                helper.createComponent(component, event, helper,component.get("v.multipleFields"));
            }
        }
    },

    doRefresh: function(component,event,helper){
        var id = event.getParam("childCmpAuraId");
        var data = component.get("v.existingDriverTabData");
        if(data){
            if(id == 'serviceRequestCommonCmpDriver' && (component.get("v.commonFieldsToBePopulateLst") != null && component.get("v.commonFieldsToBePopulateLst").length > 0)){
                helper.prePopulateDataAfterEvent(component,event,helper).then(
                    $A.getCallback(function(result) {
                        var driverRecords = helper.getTabCommonData(component,event,helper);
                        if(driverRecords){ 
                            component.set("v.driverRecords",driverRecords);
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

    getData : function(component, event,helper) {
        var driverTabDataMap = helper.getWholeTabData(component,event,helper);
        if(driverTabDataMap){
            debugger;
            component.set('v.driverRecords', driverTabDataMap );
            console.log('driverTabDataMap 55== '+ JSON.stringify(driverTabDataMap));
            return driverTabDataMap;
        }
        return null;
    },

    handleNotifyDriverTabEvent: function(component,event,helper){
        helper.decreasTabLineCount(component,event,helper, 'driverDetailsCmp');
    },
    
    handleAlterRateEvent : function(component, event, helper) {
        var alterRatesObj = event.getParam("alterRatesObj");
        component.set("v.alterRatesWithServiceWrp", alterRatesObj);
        var childComponent =component.find('driverDetailsCmp');
        if(childComponent.length != undefined){
            for(var child of childComponent){
                child.set("v.alterRatesObj", alterRatesObj);
            } 
        }else if(childComponent.length == undefined){
            childComponent.set("v.alterRatesObj", alterRatesObj);
        }
    },
    
    onQuoteIdChange : function(component, event, helper) {
        var childComponent =component.find("driverDetailsCmp");
        /*if multiple child components present - childComponent is list other wise it's a single object..
          so checking with length, if it's undefined - it's single object and can directly access that single child component..
          If multiple child components iterate over the components and set the Values.. */
        console.log('quoteId in Driver Tab  = '+ component.get("v.quoteId"));
        if(childComponent !=undefined && childComponent.length != undefined){
            for(var child of childComponent){
            	child.set("v.quoteId", component.get("v.quoteId"));
            } 
        }
        else if( childComponent !=undefined && childComponent.length == undefined){
            childComponent.set("v.quoteId", component.get("v.quoteId"));
        }
    },
    
    copyDriverController : function(component, event, helper) {
        helper.copyDriverHelper(component, event, helper);
    },
     getManPowerLinesDetailsController : function(component,event,helper){
        helper.getManPowerLinesDetailsHelper(component,event,helper);
    }
})