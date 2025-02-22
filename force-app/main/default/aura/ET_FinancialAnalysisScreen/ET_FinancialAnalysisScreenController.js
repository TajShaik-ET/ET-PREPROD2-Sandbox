({
	doinit : function(component, event, helper) {
		var url_string = window.location.href;
        var url = new URL(url_string);
        var recordId = url.searchParams.get("recordId");
        if(recordId != null && recordId != '' && recordId != undefined) {
            component.set("v.quoteId",recordId);
        }
        helper.getfinancialAnalysisCalculationData(component,event,helper);

	},
    
    getDataWithRespectToLine : function(component, event, helper) {
        var params = event.getParam('arguments');
        var lineNo = params.lineNo;
        helper.getPageData(component,component.get('v.rentalPriceCalculationsData'),lineNo);
    },
    
    navigateNext: function(component, event, helper) {
        var lineNo=component.get('v.lineNo');
        helper.getPageData(component,component.get('v.rentalPriceCalculationsData'),lineNo+1);
    },
    navigatePrevious: function(component, event, helper) {
        var lineNo=component.get('v.lineNo');
        helper.getPageData(component,component.get('v.rentalPriceCalculationsData'),lineNo-1);
    },
    navigateFirst: function(component, event, helper) {
        helper.getPageData(component,component.get('v.rentalPriceCalculationsData'),1);
    },
    navigateLast: function(component, event, helper) {
        var lineNo=component.get('v.totalLines');
        helper.getPageData(component,component.get('v.rentalPriceCalculationsData'),lineNo);
    },
})