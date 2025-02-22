({
    doInit : function(component, event, helper) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var recordId = url.searchParams.get("recordId");
        //alert('recordId'+recordId);   
        if(recordId != null && recordId != '' && recordId != undefined) {
            component.set("v.quoteId",recordId);
        }
        helper.getvehicleCalcDetails(component,event,helper);
    },
    handleComponentEvent: function(component, event, helper) {
        if(event.getParam("objectType")=='Quote'){
            component.set('v.recordId',event.getParam("recordId"));
        }
        //alert( 'recordId'+component.get('v.recordId'));
    },
    
    getDataWithRespectToLine : function(component, event, helper) {
        helper.resetAllLines(component, event, helper);
        var params = event.getParam('arguments');
        var lineNo = params.lineNo;
        helper.getPageData(component,event,helper,lineNo);
    },
    
    navigateNext: function(component, event, helper) {
        helper.resetAllLines(component, event, helper);
        var lineNo=component.get('v.lineNo');
        helper.getPageData(component,event,helper,lineNo+1);
    },
    navigatePrevious: function(component, event, helper) {
        helper.resetAllLines(component, event, helper);
        var lineNo=component.get('v.lineNo');
        helper.getPageData(component,event,helper,lineNo-1);
    },
    navigateFirst: function(component, event, helper) {
        helper.resetAllLines(component, event, helper);
        helper.getPageData(component,event,helper,1);
    },
    navigateLast: function(component, event, helper) {
        helper.resetAllLines(component, event, helper);
        var lineNo=component.get('v.totalLines');
        helper.getPageData(component,event,helper,lineNo);
    },
    
})