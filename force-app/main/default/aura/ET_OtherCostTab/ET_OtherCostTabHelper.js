({
    createComponent : function(component,event,helper, lineNumberAndExistindDataMap) {
        var totalNumberOfLines = component.get("v.numberOfLines");
        component.set("v.numberOfLines",totalNumberOfLines+1);
        var costDetailCmpExistindData;
        if(lineNumberAndExistindDataMap[component.get("v.numberOfLines")]){
            costDetailCmpExistindData = lineNumberAndExistindDataMap[component.get("v.numberOfLines")];
        }else{
            costDetailCmpExistindData = null;
        }
        var otherCostDetailsCmp=[];
        otherCostDetailsCmp = component.find('otherCostDetailsCmp');
        //for loop here to get all the driver details components
        //Itrate over it and find all collapsible component , itrate over them and collapse.
        
        if(otherCostDetailsCmp != null ){
            if(otherCostDetailsCmp.length!=undefined && otherCostDetailsCmp.length > 0){
                
                for(var i=1;i<otherCostDetailsCmp.length;i++){
                    var collapsibleCmp = otherCostDetailsCmp[i].find('collapsibleCmp');
                    if(collapsibleCmp!=undefined ){
                        collapsibleCmp.collapseAll();
                    }
                }
            }else{
                var collapsibleCmp = otherCostDetailsCmp.find('collapsibleCmp');
                if(collapsibleCmp!=undefined ){
                    collapsibleCmp.collapseAll();
                }
            }
        }       
        
        $A.createComponent(
            "c:ET_OtherCostDetails",{
                "aura:id" : "otherCostDetailsCmp",
                "lineNumber" : component.get("v.numberOfLines"),
                "existingLineData" : costDetailCmpExistindData,
                "isPricingTeam" :component.get("v.isPricingTeam")
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
        
    },
    
    decreasOtherCostLineCount: function(component,event,helepr){
        var count = component.get("v.numberOfLines");
        component.set("v.numberOfLines",count-1);
        var deletedOtherCostLineNumber = event.getParam("deletedlineItemNumber");
        var otherCostDetailCmpLst = component.find("otherCostDetailsCmp");
        if(otherCostDetailCmpLst != undefined && otherCostDetailCmpLst.length > 0){
            for(var otherCostDetailCmp of otherCostDetailCmpLst){
                var otherCostDetailCmpLineNumber = otherCostDetailCmp.get("v.lineNumber");
                var cmpData = otherCostDetailCmp.get("v.otherCostRecord");
                if(otherCostDetailCmpLineNumber == deletedOtherCostLineNumber){
                    if(cmpData.Id){
                        //alert('cmp id which got deleted : '+ cmpData.Id);
                        var deletedCmpLst = component.get("v.deletedOtherCostChildDetailCmpList");
                        deletedCmpLst.push(cmpData.Id);
                        component.set("v.deletedOtherCostChildDetailCmpList", deletedCmpLst);
                    }
                }
                if(otherCostDetailCmpLineNumber > deletedOtherCostLineNumber){
                    otherCostDetailCmp.set("v.lineNumber", otherCostDetailCmpLineNumber-1);
                    //var lineApiName = helper.getTabLineNumberApiName(tabAuraId);
                    if(cmpData != undefined && cmpData.ET_Other_Cost_Line_Number__c != undefined){
                        var lineNumber = parseInt(cmpData.ET_Other_Cost_Line_Number__c);
                        cmpData.ET_Other_Cost_Line_Number__c = lineNumber - 1;
                    }
                    otherCostDetailCmp.set("v.otherCostRecord",cmpData);
                }
            }
        }
        else if(otherCostDetailCmpLst != undefined && otherCostDetailCmpLst.length == undefined){
            var otherCostDetailCmpLineNumber = otherCostDetailCmpLst.get("v.lineNumber");
            var cmpData = otherCostDetailCmpLst.get("v.otherCostRecord");
            if(otherCostDetailCmpLineNumber == deletedOtherCostLineNumber){
                if(cmpData.Id){
                    //alert('cmp id which got deleted : '+ cmpData.Id);
                    var deletedCmpLst = component.get("v.deletedOtherCostChildDetailCmpList");
                    deletedCmpLst.push(cmpData.Id);
                    component.set("v.deletedOtherCostChildDetailCmpList", deletedCmpLst);
                }
            }
        }
    },
})