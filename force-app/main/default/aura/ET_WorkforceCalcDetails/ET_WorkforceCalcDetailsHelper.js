({
    getworkforceCalcDetails : function (component,event,helper) {
       var action = component.get("c.ET_getWorkforceCalcDetails");
        component.set('v.loaded', !component.get('v.loaded'));
        //alert('type'+component.get('v.workforceType'));
        action.setParams({
            'quoteId': component.get('v.quoteId'),
            'quoteItemType': component.get('v.workforceType')
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
             if (state === "SUCCESS"){
                 component.set('v.loaded', !component.get('v.loaded'));
                var response=a.getReturnValue();
                console.log('response '+response);
                if(response!=null && response!=undefined){
                    component.set('v.totalLines',response.noOfLines);
                    component.set('v.isTargetPriceRequired',response.isTargetPriceRequired);
                    component.set('v.quoteType',response.quoteType);
                    //console.log('response.noOfLines'+response.noOfLines);
                    component.set("v.wrokforceCalcDetails",response.lstQuoteCalcDetails);
                    console.log('wrokforceCalcDetails = '+ JSON.stringify(response.lstQuoteCalcDetails));
                    debugger;
                    console.log('approver details = '+ JSON.stringify(response.wrokforceApprovalDetailsWrp));
                    component.set('v.wrokforceApprovalDetails',response.wrokforceApprovalDetailsWrp);
                    var lineNo = component.get("v.lineNo");
                    helper.getPageData (component,event,helper,lineNo);
                }else{
                    console.log('response is null');
                }
            }
            else{
                component.set('v.loaded', !component.get('v.loaded'));
            }
        });
        $A.enqueueAction(action);
    },
    resetAllLines:  function (component,event,helper) {
        component.set("v.pricingPolicy1",null);
        component.set("v.pricingPolicy2",null);
        component.set("v.pricingPolicy3",null);
        component.set("v.pricingPolicy4",null);
        component.set("v.pricingPolicy5",null);
        component.set("v.pricingPolicy6",null);
        component.set("v.pricingPolicy7",null);
        component.set("v.pricingPolicy8",null);
        //component.set("v.pricingPolicy9",null);
    },
    getPageData:  function (component,event,helper,lineNo) {
        var setOtCostlabel = new Set();
        //console.log('pagedata'+JSON.stringify(component.get('v.wrokforceCalcDetails')));
        //var isComponentVariableSet = false;
        
        for(var pricingPolicy of component.get('v.wrokforceCalcDetails')){
            if(pricingPolicy.Quote_Item_SpecReqs__r != null && pricingPolicy.Quote_Item_SpecReqs__r != undefined){
                for(var specReq of pricingPolicy.Quote_Item_SpecReqs__r){
                    setOtCostlabel.add(specReq.Name);
                }
            }
            console.log('Pricing policy = '+ JSON.stringify(pricingPolicy));
            if(pricingPolicy.ET_Contract_Period__c==1 && pricingPolicy.ET_Workforce_Line_Number__c==lineNo){
                component.set("v.pricingPolicy1",pricingPolicy);
                console.log('ET_Total_Indirect_Operational_Costs__c = '+component.get("v.pricingPolicy1").ET_Total_Indirect_Operational_Costs__c );
                component.set("v.workforceSalary",pricingPolicy.ET_Workforce_Gross_Salary__c);
                component.set("v.noOfWorkforce",pricingPolicy.ET_Number_of_Workforce__c);
                component.set("v.workforceCategory",pricingPolicy.ET_Workforce_Unique_Key__c);
                component.set("v.otherCost1",pricingPolicy.Quote_Item_SpecReqs__r);
                component.set("v.serviceType",pricingPolicy.ET_Service_Type__c);
                //console.log('pricingPolicy-->'+pricingPolicy);
            }else if(pricingPolicy.ET_Contract_Period__c==2 && pricingPolicy.ET_Workforce_Line_Number__c==lineNo){
                component.set("v.pricingPolicy2",pricingPolicy);
                component.set("v.workforceSalary",pricingPolicy.ET_Workforce_Gross_Salary__c);
                component.set("v.noOfWorkforce",pricingPolicy.ET_Number_of_Workforce__c);
                component.set("v.workforceCategory",pricingPolicy.ET_Workforce_Unique_Key__c);
                component.set("v.otherCost2",pricingPolicy.Quote_Item_SpecReqs__r);
                component.set("v.serviceType",pricingPolicy.ET_Service_Type__c);
            }else if(pricingPolicy.ET_Contract_Period__c==3 && pricingPolicy.ET_Workforce_Line_Number__c==lineNo){
                component.set("v.pricingPolicy3",pricingPolicy);
                component.set("v.workforceSalary",pricingPolicy.ET_Workforce_Gross_Salary__c);
                component.set("v.noOfWorkforce",pricingPolicy.ET_Number_of_Workforce__c);
                component.set("v.workforceCategory",pricingPolicy.ET_Workforce_Unique_Key__c);
                component.set("v.otherCost3",pricingPolicy.Quote_Item_SpecReqs__r);
                component.set("v.serviceType",pricingPolicy.ET_Service_Type__c);
            }else if(pricingPolicy.ET_Contract_Period__c==4 && pricingPolicy.ET_Workforce_Line_Number__c==lineNo){
                component.set("v.pricingPolicy4",pricingPolicy );
                component.set("v.workforceSalary",pricingPolicy.ET_Workforce_Gross_Salary__c);
                component.set("v.noOfWorkforce",pricingPolicy.ET_Number_of_Workforce__c);
                component.set("v.workforceCategory",pricingPolicy.ET_Workforce_Unique_Key__c);
                component.set("v.otherCost4",pricingPolicy.Quote_Item_SpecReqs__r);
                component.set("v.serviceType",pricingPolicy.ET_Service_Type__c);
            }else if(pricingPolicy.ET_Contract_Period__c==5 && pricingPolicy.ET_Workforce_Line_Number__c==lineNo){
                component.set("v.pricingPolicy5",pricingPolicy);
                component.set("v.workforceSalary",pricingPolicy.ET_Workforce_Gross_Salary__c);
                component.set("v.noOfWorkforce",pricingPolicy.ET_Number_of_Workforce__c);
                component.set("v.workforceCategory",pricingPolicy.ET_Workforce_Unique_Key__c);
                component.set("v.otherCost5",pricingPolicy.Quote_Item_SpecReqs__r);
                component.set("v.serviceType",pricingPolicy.ET_Service_Type__c);
            }else if(pricingPolicy.ET_Contract_Period__c==6 && pricingPolicy.ET_Workforce_Line_Number__c==lineNo){
                component.set("v.pricingPolicy6",pricingPolicy);
                component.set("v.workforceSalary",pricingPolicy.ET_Workforce_Gross_Salary__c);
                component.set("v.noOfWorkforce",pricingPolicy.ET_Number_of_Workforce__c);
                component.set("v.workforceCategory",pricingPolicy.ET_Workforce_Unique_Key__c);
                component.set("v.otherCost6",pricingPolicy.Quote_Item_SpecReqs__r);
                component.set("v.serviceType",pricingPolicy.ET_Service_Type__c);
            }else if(pricingPolicy.ET_Contract_Period__c==7 && pricingPolicy.ET_Workforce_Line_Number__c==lineNo){
                component.set("v.pricingPolicy7",pricingPolicy);
                component.set("v.workforceSalary",pricingPolicy.ET_Workforce_Gross_Salary__c);
                component.set("v.noOfWorkforce",pricingPolicy.ET_Number_of_Workforce__c);
                component.set("v.workforceCategory",pricingPolicy.ET_Workforce_Unique_Key__c);
                component.set("v.otherCost7",pricingPolicy.Quote_Item_SpecReqs__r);
                component.set("v.serviceType",pricingPolicy.ET_Service_Type__c);
            }else if(pricingPolicy.ET_Contract_Period__c==8 && pricingPolicy.ET_Workforce_Line_Number__c==lineNo){
                component.set("v.pricingPolicy8",pricingPolicy);
                component.set("v.workforceSalary",pricingPolicy.ET_Workforce_Gross_Salary__c);
                component.set("v.noOfWorkforce",pricingPolicy.ET_Number_of_Workforce__c);
                component.set("v.workforceCategory",pricingPolicy.ET_Workforce_Unique_Key__c);
                component.set("v.otherCost8",pricingPolicy.Quote_Item_SpecReqs__r);
                component.set("v.serviceType",pricingPolicy.ET_Service_Type__c);
            }
            
        }
        component.set("v.spcialRequirementLabelsLst",Array.from(setOtCostlabel));
    }
})