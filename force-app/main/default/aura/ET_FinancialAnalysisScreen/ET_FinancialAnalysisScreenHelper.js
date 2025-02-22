({
	getfinancialAnalysisCalculationData : function(component,evet,helper){
        component.set('v.loaded', !component.get('v.loaded'));
        var action = component.get("c.financialAnalysisScreenData");
        action.setParams({
            'quoteId': component.get('v.quoteId')
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
             if (state === "SUCCESS"){
                 component.set('v.loaded', !component.get('v.loaded'));
                var response=a.getReturnValue();
                console.log('response '+response);
                if(response!='' && response!=null && response!=undefined){
                    console.log('response from finance Class = '+ JSON.stringify(response));
                    console.log('responselength ' + response.length);
                    component.set('v.totalLines',response.length);
                    component.set('v.rentalPriceCalculationsData',response);
                    if(response[0] != undefined && response[0].rentalPriceCalculationLst[0] != undefined){
                        component.set('v.quoteType',response[0].rentalPriceCalculationLst[0].quoteType);
                    }
                    var lineNo = component.get("v.lineNo");
                    console.log('lineNo = '+ lineNo);
                    helper.getPageData(component, response,lineNo);
                    
                }else{
                    console.log('response is null');
                }
            }
            else {
                alert('Internal Error!. Please check with Admin.');
                component.set('v.loaded', !component.get('v.loaded'));
            }
        });
        $A.enqueueAction(action);

    },
    getPageData: function(component,response,lineNo){
        console.log('response ' + JSON.stringify(response));
        console.log('lineNo 2= '+ lineNo);
        if(response[lineNo-1].rentalPriceCalculationLst != null && response[lineNo-1].rentalPriceCalculationLst.length > 0){
            component.set('v.header',response[lineNo-1].reqMapping);
            component.set('v.rentalPriceHeaderInfo',response[lineNo-1].rentalPriceHeaderInfo);
            component.set('v.rentalPriceCalculations',response[lineNo-1].rentalPriceCalculationLst);
            component.set('v.pricingType',response[lineNo-1].rentalPriceCalculationLst[0].pricingType);
            debugger;
            component.set('v.quoteType',response[lineNo-1].rentalPriceCalculationLst[0].quoteType);
            console.log('pricingMethod = '+ response[lineNo-1].financialAnalysisLst[0].pricingMethod);
            component.set('v.pricingMethod',response[lineNo-1].financialAnalysisLst[0].pricingMethod);
            var pricingType = response[lineNo-1].rentalPriceCalculationLst[0].pricingType;
            var pricePerTypeLabel;
            if(pricingType != undefined && pricingType == 'Annual Price'){
                pricePerTypeLabel = 'Annual Price';
            }
            else if(pricingType != undefined && pricingType == 'Monthly Price'){
                pricePerTypeLabel = 'Monthly Price';
            }
                else if(pricingType != undefined ){
                    pricePerTypeLabel = 'Price '+ pricingType;
                }
            component.set('v.pricePerTypeLabel',pricePerTypeLabel);
 
            component.set('v.isTargerPriceRequired',response[lineNo-1].rentalPriceCalculationLst[0].isTargerPriceRequired);
            component.set('v.totalValueOfQuotations',response[lineNo-1].totalValueOfQuotationLst);
            component.set('v.financialAnalysis',response[lineNo-1].financialAnalysisLst);
        }
        
    }
})