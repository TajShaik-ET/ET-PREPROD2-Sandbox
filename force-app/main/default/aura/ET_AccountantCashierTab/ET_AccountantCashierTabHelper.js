({
    createComponent: function(component,event,helper, multipleList){
        
        var additionalFields = component.get("v.additionalFieldsToDisplay");
        
        var totalNumberOfLines = component.get("v.numberOfLines");
        component.set("v.numberOfLines",totalNumberOfLines+1);
        
        var accountantDetailsCmp=[];
        accountantDetailsCmp = component.find('accountantDetailsCmp');
        //for loop here to get all the accountant details components
        //Itrate over it and find all collapsible component , itrate over them and collapse.
        
        if(accountantDetailsCmp != null ){
            if(accountantDetailsCmp.length!=undefined && accountantDetailsCmp.length > 0){
                
                for(var i=1;i<accountantDetailsCmp.length;i++){
                    var collapsibleCmp = accountantDetailsCmp[i].find('collapsibleCmp');
                    if(collapsibleCmp!=undefined){
                        collapsibleCmp.collapseAll();
                    }
                }
            }else{
                if(accountantDetailsCmp!=undefined ){
                    var collapsibleCmp = accountantDetailsCmp.find('collapsibleCmp');
                    if(collapsibleCmp!=undefined ){
                        collapsibleCmp.collapseAll();
                    }
                }
            }
        }       
        $A.createComponent(
            "c:ET_AccountantCashierDetails",{
                "aura:id" : "accountantDetailsCmp",
                "lineNumber" : component.get("v.numberOfLines"),
                "multipleList" : multipleList,
                "additionalFields" : additionalFields,
                "editableFieldsByPricingTeam" : component.get("v.editableAccntantFieldsforPricingTeam"),
                "isPricingTeam" :  component.get("v.isPricingTeam"),
                "alterRatesObj": component.get("v.alterRatesWithServiceWrp"),
                "quoteId" : component.get("v.quoteId")
                
            },
            function(newcomponent){
                if (newcomponent.isValid()) {
                    var newCmp = component.find("cmpBody");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body); 
                    
                    if(component.find("accountantDetailsCmp").length == undefined){
                        var commonAccInfoCmp = component.find("serviceRequestCommonCmpAcc");
                        if(commonAccInfoCmp){
                            commonAccInfoCmp.set("v.isDisable", true);
                        }
                    }
                }
            }            
        );
    }
    
})