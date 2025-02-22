({
    doInit:function(component, event, helper){
        helper.processDoInit(component,event,helper);
        
    },

    doRefresh: function(component,event,helper){
        var id = event.getParam("childCmpAuraId");
        var data = component.get("v.existingSupervisorTabData");
        if(data){
            if(id == 'serviceRequestCommonCmpSupervisor' && (component.get("v.commonFieldsToBePopulateLst") != null && component.get("v.commonFieldsToBePopulateLst").length > 0)){
                helper.prePopulateDataAfterEvent(component,event,helper).then(
                    $A.getCallback(function(result) {
                        var supervisorRecords = helper.getTabCommonData(component,event,helper);
                        if(supervisorRecords){ 
                            component.set("v.supervisorRecords",supervisorRecords);
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
        var supervisorRecords = helper.getTabCommonData(component,event,helper);
        if(supervisorRecords){
            component.set("v.supervisorRecords",supervisorRecords); 
            if(helper.validateAllDetails(component,event,helper) ||  component.find("supervisorDetailsCmp") == undefined){
                helper.createComponent(component, event, helper,component.get("v.multipleFields"));
            }
        }
        
    },
    
    getData : function(component,event,helper) {
        //calling super component helper
        var supervisorTabDataMap = helper.getWholeTabData(component,event,helper);
        if(supervisorTabDataMap){
            component.set('v.supervisorRecords', supervisorTabDataMap );
            return supervisorTabDataMap;
        }
        return null;
    },
     
    handleNotifySupervisorTabEvent: function(component,event,helper){
        //calling super component helper
        helper.decreasTabLineCount(component,event,helper, 'supervisorDetailsCmp');
    },
    
    handleAlterRateEvent : function(component, event, helper) {
        var alterRatesObj = event.getParam("alterRatesObj");
        component.set("v.alterRatesWithServiceWrp", alterRatesObj);
        var childComponent =component.find('supervisorDetailsCmp');
        if(childComponent.length != undefined){
            for(var child of childComponent){
                child.set("v.alterRatesObj", alterRatesObj);
            } 
        }else if(childComponent.length == undefined){
            childComponent.set("v.alterRatesObj", alterRatesObj);
        }
    },
    
    onQuoteIdChange : function(component, event, helper) {
        var childComponent =component.find("supervisorDetailsCmp");
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