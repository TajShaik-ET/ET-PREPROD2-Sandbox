({
    doInit:function(component, event, helper){
        helper.processDoInit(component,event,helper);
    },

    doRefresh: function(component,event,helper){
        var id = event.getParam("childCmpAuraId");
        var data = component.get("v.existingOtherEmpTabData");
        if(data){
            if(id == 'serviceRequestCommonCmpOtherEmp' && (component.get("v.commonFieldsToBePopulateLst") != null && component.get("v.commonFieldsToBePopulateLst").length > 0)){
                helper.prePopulateDataAfterEvent(component,event,helper).then(
                    $A.getCallback(function(result) {
                        var otherEmployeeRecords = helper.getTabCommonData(component,event,helper);
                        if(otherEmployeeRecords){ 
                            component.set("v.otherEmployeeRecords",otherEmployeeRecords);
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
        var otherEmployeeRecords = helper.getTabCommonData(component,event,helper);
        if(otherEmployeeRecords){
            component.set("v.otherEmployeeRecords",otherEmployeeRecords); 
            if(helper.validateAllDetails(component,event,helper) ||  component.find("otherEmployeeDetailsCmp") == undefined || (component.find("otherEmployeeDetailsCmp") != undefined && component.find("otherEmployeeDetailsCmp").length == undefined && component.find("otherEmployeeDetailsCmp").find("collapsibleCmp") == undefined)){
                helper.createComponent(component, event, helper,component.get("v.multipleFields"));
            }
        }
        
    },
    
    getData : function(component, event,helper) {
        var otherEmpTabDataMap = helper.getWholeTabData(component,event,helper);
        if(otherEmpTabDataMap){
            component.set('v.otherEmployeeRecords', otherEmpTabDataMap );
            return otherEmpTabDataMap;
        }
        return null;
    },

    handleNotifyOtherEmpTabEvent: function(component,event,helper){
        helper.decreasTabLineCount(component,event,helper, 'otherEmployeeDetailsCmp');
    },
    
    handleAlterRateEvent : function(component, event, helper) {
        var alterRatesObj = event.getParam("alterRatesObj");
        component.set("v.alterRatesWithServiceWrp", alterRatesObj);
        var childComponent =component.find('otherEmployeeDetailsCmp');
        if(childComponent.length != undefined){
            for(var child of childComponent){
                child.set("v.alterRatesObj", alterRatesObj);
            } 
        }else if(childComponent.length == undefined){
            childComponent.set("v.alterRatesObj", alterRatesObj);
        }
    },
    
    onQuoteIdChange : function(component, event, helper) {
        var childComponent =component.find("otherEmployeeDetailsCmp");
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