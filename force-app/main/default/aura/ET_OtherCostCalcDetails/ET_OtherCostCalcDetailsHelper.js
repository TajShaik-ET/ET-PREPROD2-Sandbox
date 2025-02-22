({
	getotherCostCalcDetails : function (component,event,helper) {
       var action = component.get("c.ET_getotherCostCalcDetail");
        
        action.setParams({
                'quoteId': component.get('v.quoteId')
            });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
             if (state === "SUCCESS"){
                var response=a.getReturnValue();
                //console.log('response '+response);
                if(response!=null && response!=undefined){
                    var jsonResponse = JSON.parse(response);
                    console.log('other cost data: ',JSON.stringify(jsonResponse));
                    //component.set('v.totalLines',jsonResponse.noOfVehicleLinesInRequest);
                    //console.log(JSON.stringify(jsonResponse));
                    component.set("v.otherCostCalcDetails",jsonResponse);
                    helper.getPageData (component,event,helper,1);
                    }else{
                        console.log('response is null');
                    }
    
            }
        });
        $A.enqueueAction(action);
    },
    
    getPageData:  function (component,event,helper,lineNo) {
        component.set('v.lineNo',lineNo);
        var specialReqLabelLst = [];
        var otherCost1 = [];
        var otherCost2 = [];
        var otherCost3 = [];
        var otherCost4 = [];
        var otherCost5 = [];
        var otherCost6 = [];
        var otherCost7 = [];
        var otherCost8 = [];
        
      //  console.log()
        for(var otherCost of component.get('v.otherCostCalcDetails')){
            specialReqLabelLst.push(otherCost.Name);
            if(otherCost.Quote_Contract_Year__c==1){
                otherCost1.push(otherCost);
                
            }else if(otherCost.Quote_Contract_Year__c ==2){
                otherCost2.push(otherCost);
                
            }else if(otherCost.Quote_Contract_Year__c==3){
                otherCost3.push(otherCost);
                
            }else if(otherCost.Quote_Contract_Year__c==4){
                otherCost4.push(otherCost);
                
            }else if(otherCost.Quote_Contract_Year__c==5){
                otherCost5.push(otherCost);
                
            }else if(otherCost.Quote_Contract_Year__c==6){
                otherCost6.push(otherCost);
                
            }else if(otherCost.Quote_Contract_Year__c==7){
                otherCost7.push(otherCost);
                
            }else if(otherCost.Quote_Contract_Year__c==8){
                otherCost8.push(otherCost);
                
            }
        }
        component.set("v.otherCost1",otherCost1);
        component.set("v.otherCost2",otherCost2);
        component.set("v.otherCost3",otherCost3);
        component.set("v.otherCost4",otherCost4);
        component.set("v.otherCost5",otherCost5);
        component.set("v.otherCost6",otherCost6);
        component.set("v.otherCost7",otherCost7);
        component.set("v.otherCost8",otherCost8);
        component.set("v.spcialRequirementLabelsLst", specialReqLabelLst);
        console.log(JSON.stringify(specialReqLabelLst));
    }
})