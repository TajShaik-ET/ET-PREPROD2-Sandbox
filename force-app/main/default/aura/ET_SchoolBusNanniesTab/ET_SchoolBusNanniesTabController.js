({
    doInit:function(component, event, helper){
        helper.processDoInit(component,event,helper);
    },

    doRefresh: function(component,event,helper){
        var id = event.getParam("childCmpAuraId");
        var data = component.get("v.existingNannyTabData");
        if(data){
            if(id == 'serviceRequestCommonCmpNanny' && (component.get("v.commonFieldsToBePopulateLst") != null && component.get("v.commonFieldsToBePopulateLst").length > 0)){
                helper.prePopulateDataAfterEvent(component,event,helper).then(
                    $A.getCallback(function(result) {
                        var nannyRecords = helper.getTabCommonData(component,event,helper);
                        if(nannyRecords){ 
                            component.set("v.nannyRecords",nannyRecords);
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
     
            var nannyRecords = helper.getTabCommonData(component,event,helper);
            if(nannyRecords){
                component.set("v.nannyRecords",nannyRecords); 
                if(helper.validateAllDetails(component,event,helper) ||  component.find("schoolBusNannyDetailsCmp") == undefined || (component.find("schoolBusNannyDetailsCmp") != undefined && component.find("schoolBusNannyDetailsCmp").length == undefined && component.find("schoolBusNannyDetailsCmp").find("collapsibleCmp") == undefined)){
                    helper.createComponent(component, event, helper,component.get("v.multipleFields"));
                }
            }
            
        
    },
    
    getData : function(component, event,helper) {
        var nannyTabDataMap = helper.getWholeTabData(component,event,helper);
        if(nannyTabDataMap){
            component.set('v.nannyRecords', nannyTabDataMap );
            return nannyTabDataMap;
        }
        return null;
    },

    handleNotifyNannyTabEvent: function(component,event,helper){
        helper.decreasTabLineCount(component,event,helper, 'schoolBusNannyDetailsCmp');
    },
    
    handleAlterRateEvent : function(component, event, helper) {
        var alterRatesObj = event.getParam("alterRatesObj");
        component.set("v.alterRatesWithServiceWrp", alterRatesObj);
        var childComponent =component.find('schoolBusNannyDetailsCmp');
        if(childComponent.length != undefined){
            for(var child of childComponent){
                child.set("v.alterRatesObj", alterRatesObj);
            } 
        }else if(childComponent.length == undefined){
            childComponent.set("v.alterRatesObj", alterRatesObj);
        }
    },
    
    onQuoteIdChange : function(component, event, helper) {
        var childComponent =component.find("schoolBusNannyDetailsCmp");
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
    copyNannyController : function(component, event, helper) {
        helper.copyNannyHelper(component, event, helper);
    },
    getManPowerLinesDetailsController : function(component,event,helper){
         debugger;
        var workForceLinesList = [];
        var childComponent =component.find('schoolBusNannyDetailsCmp');
        if(childComponent !=undefined && childComponent.length != undefined){
            for(var child of childComponent){
                console.log('workForceRecord = ' + JSON.stringify(child.get('v.workForceRecord')));
                if(child.get('v.workForceRecord.Type__c') == 'Main'){
                    var lineNumber ;
                    if(child.get('v.workForceRecord.ET_Nanny_Line__c')){
                        lineNumber = child.get('v.workForceRecord.ET_Nanny_Line__c');
                    }
                    else if(child.get('v.workForceRecord.ET_Workforce_Line_Info__c')){
                        lineNumber = child.get('v.workForceRecord.ET_Workforce_Line_Info__c').split(':')[1];
                    }
                    if(child.get('v.workForceRecord.ET_Nanny_Category__c') && lineNumber  ){
                        var workforceLine = child.get('v.workForceRecord.ET_Nanny_Category__c')+ '=>'+lineNumber;
                        workForceLinesList.push(workforceLine);
                    }
                }
            } 
        }
        else if( childComponent !=undefined && childComponent.length == undefined){
            if(childComponent.get('v.workForceRecord.Type__c') == 'Main'){
                var lineNumber ;
                if(childComponent.get('v.workForceRecord.ET_Nanny_Line__c')){
                    lineNumber = childComponent.get('v.workForceRecord.ET_Nanny_Line__c');
                }
                else if(childComponent.get('v.workForceRecord.ET_Workforce_Line_Info__c')){
                    lineNumber = childComponent.get('v.workForceRecord.ET_Workforce_Line_Info__c').split(':')[1];
                }
                if(childComponent.get('v.workForceRecord.ET_Nanny_Category__c') && lineNumber  ){
                    var workforceLine = childComponent.get('v.workForceRecord.ET_Nanny_Category__c')+ '=>'+lineNumber;
                    workForceLinesList.push(workforceLine);
                }
            }
        }
        // assign workforceLinesList to all driver lines
        if(childComponent !=undefined && childComponent.length != undefined){
            for(var child of childComponent){
                child.set("v.driverLineDetails", workForceLinesList);
            } 
        }
        else if( childComponent !=undefined && childComponent.length == undefined){
            childComponent.set("v.driverLineDetails",workForceLinesList);
        }
        
        console.log('workForceLinesList = '+ JSON.stringify(workForceLinesList));
    },
})