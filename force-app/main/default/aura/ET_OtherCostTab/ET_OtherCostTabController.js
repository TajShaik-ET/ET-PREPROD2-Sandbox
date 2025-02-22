({
    doInit:function(component, event, helper){
        debugger;
        var data = component.get("v.existingOtherCostTabData");
       // console.log('other cost existing data :'+JSON.stringify(data));
        var lineNumberAndExistindDataMap = {};
        if(data != undefined && data != null && data.otherCostLineItems != null){
            for(var i=0; i< data.otherCostLineItems.length; i++){
                lineNumberAndExistindDataMap[((data.otherCostLineItems)[i]).ET_Other_Cost_Line_Number__c] = (data.otherCostLineItems)[i];    
            }   
        }
        var firstCostDetailCmpExistindData;
        var totalNumberOfLines = component.get("v.numberOfLines");
        component.set("v.numberOfLines",totalNumberOfLines+1);
        if(lineNumberAndExistindDataMap[component.get("v.numberOfLines")]){
            firstCostDetailCmpExistindData = lineNumberAndExistindDataMap[component.get("v.numberOfLines")];
        }else{
            firstCostDetailCmpExistindData = null;
        }
        // alert('doinit');
        $A.createComponent(
            
            "c:ET_OtherCostDetails",
            {
                "aura:id" : "otherCostDetailsCmp",
                "lineNumber" : component.get("v.numberOfLines"),
                "existingLineData" : firstCostDetailCmpExistindData,
                "isPricingTeam" :component.get("v.isPricingTeam")
            },
            function(newcomponent){
                if (newcomponent.isValid()) {
                    var newCmp = component.find("cmpBody");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body);             
                }
            }            
        );
        if(data != undefined && data != null && data.otherCostLineItems != null){
            for(var i=0; i< data.otherCostLineItems.length - 1; i++){
                helper.createComponent(component,event,helper,lineNumberAndExistindDataMap);
            }
        }
    },
    
    handleAddMore : function(component, event, helper) {
        if(helper.validateAllDetails(component,event,helper)){
            helper.createComponent(component,event,helper, {});
        }  
    },
    
    getData: function(component,event,helper){
        debugger;
        //var otherCostRecordsMap = component.get('v.'); 
        if(helper.validateAllDetails(component,event,helper)){
            var finalDataMap = new Map();
            var dataList = [];
            var dataMapEntry = new Map();
            var otherCostDetailCmps = component.find("otherCostDetailsCmp");
            if(otherCostDetailCmps != undefined ){
                if(otherCostDetailCmps.length!=undefined && otherCostDetailCmps.length > 0){
                    for(var otherCostDetailCmp of otherCostDetailCmps){
                        dataMapEntry = otherCostDetailCmp.get("v.otherCostRecord");
                       // console.log('dataMapEntry'+JSON.stringify(dataMapEntry));
                        dataMapEntry['ET_Cost_Type__c'] = otherCostDetailCmp.get("v.costTypeValue");
                        dataList.push(dataMapEntry);
                    }
                }else{
                    dataMapEntry = otherCostDetailCmps.get("v.otherCostRecord");
                    //console.log('dataMapEntry'+JSON.stringify(dataMapEntry));
                    dataMapEntry['ET_Cost_Type__c'] = otherCostDetailCmps.get("v.costTypeValue");
                    //console.log('dataMapEntry Final__'+JSON.stringify(dataMapEntry));
                    dataList.push(dataMapEntry);
                }
                finalDataMap['otherCostTabInfo'] =  dataList;
               // console.log('finalDataMap Final__'+JSON.stringify(finalDataMap));
                return finalDataMap;
                debugger;
            }   
        }
        return null;
    },
    
    handleNotifyOtherCostTabEvent: function(component,event,helper){
        helper.decreasOtherCostLineCount(component,event,helper);
    }
})